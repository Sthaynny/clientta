#!/usr/bin/env node
/**
 * Concede acesso Pro gratuito via coleção billing_free_access.
 *
 * Uso:
 *   cd functions
 *   node scripts/grant_free_access.js <email> [--note "..."] [--confirm]
 *   node scripts/grant_free_access.js --seed [--confirm]
 *   node scripts/grant_free_access.js <email> --dry-run
 *
 * Requer credenciais Admin (firebase login ou GOOGLE_APPLICATION_CREDENTIALS).
 */

const admin = require('firebase-admin');
const fs = require('fs');
const os = require('os');
const path = require('path');
const {
  FREE_ACCESS_COLLECTION,
  normalizeEmail,
  syncUserEntitlements,
} = require('../billing_entitlements');

const SEED_ENTRIES = require('../billing_free_access_seed');

function resolveApplicationDefaultCredentials() {
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    return process.env.GOOGLE_APPLICATION_CREDENTIALS;
  }

  const firebaseConfigDir = process.platform === 'win32'
    ? path.join(process.env.APPDATA || '', 'firebase')
    : path.join(os.homedir(), '.config', 'firebase');

  if (!fs.existsSync(firebaseConfigDir)) {
    return null;
  }

  const credentialFile = fs
    .readdirSync(firebaseConfigDir)
    .find((file) => file.endsWith('_application_default_credentials.json'));

  if (!credentialFile) {
    return null;
  }

  const resolved = path.join(firebaseConfigDir, credentialFile);
  process.env.GOOGLE_APPLICATION_CREDENTIALS = resolved;
  return resolved;
}

function parseArgs(argv) {
  const flags = new Set(argv.filter((arg) => arg.startsWith('--')));
  const positional = argv.filter((arg) => !arg.startsWith('--'));

  const dryRun = flags.has('--dry-run');
  const confirm = flags.has('--confirm');
  const seed = flags.has('--seed');

  if (dryRun && confirm) {
    throw new Error('Use apenas um modo: --dry-run ou --confirm');
  }
  if (!dryRun && !confirm) {
    throw new Error('Modo obrigatório: --dry-run (simular) ou --confirm (executar)');
  }

  let note = null;
  const noteIndex = argv.indexOf('--note');
  if (noteIndex >= 0) {
    note = String(argv[noteIndex + 1] || '').trim() || null;
  }

  if (seed) {
    return {
      entries: SEED_ENTRIES.map((entry) => ({
        email: normalizeEmail(entry.email),
        note: entry.note || null,
      })),
      dryRun,
      confirm,
      seed,
    };
  }

  const email = normalizeEmail(positional[0]);
  if (!email) {
    throw new Error(
      'Informe o email ou use --seed: node scripts/grant_free_access.js <email> [--note "..."] [--dry-run|--confirm]',
    );
  }

  return {
    entries: [{ email, note }],
    dryRun,
    confirm,
    seed: false,
  };
}

function getFirestore() {
  return admin.firestore();
}

async function grantFreeAccessEntry({ email, note }, { dryRun }) {
  const docRef = getFirestore().collection(FREE_ACCESS_COLLECTION).doc(email);
  const payload = {
    enabled: true,
    note: note || null,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  if (!dryRun) {
    const existing = await docRef.get();
    if (existing.exists) {
      delete payload.createdAt;
    }
    await docRef.set(payload, { merge: true });
  }

  return { email, note: note || null, granted: true };
}

async function findAuthUserByEmail(email) {
  try {
    return await admin.auth().getUserByEmail(email);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      return null;
    }
    throw error;
  }
}

async function syncExistingUserEntitlements(email, { dryRun }) {
  const authUser = await findAuthUserByEmail(email);
  if (!authUser?.uid) {
    return { synced: false, reason: 'auth_user_not_found' };
  }

  if (dryRun) {
    return { synced: false, reason: 'dry_run', uid: authUser.uid };
  }

  const billing = require('../billing');
  const result = await syncUserEntitlements({
    uid: authUser.uid,
    email,
    getUserDoc: billing.getUserDoc,
    updateUserSubscription: billing.updateUserSubscription,
    isSimulatedStripeResourceId: billing.isSimulatedStripeResourceId,
  });

  return {
    synced: true,
    uid: authUser.uid,
    appliedFreeAccess: result.appliedFreeAccess,
    subscription: result.subscription,
  };
}

async function grantFreeAccess(entries, { dryRun }) {
  const results = [];

  for (const entry of entries) {
    const grant = await grantFreeAccessEntry(entry, { dryRun });
    const sync = await syncExistingUserEntitlements(entry.email, { dryRun });
    results.push({ ...grant, sync });
  }

  return results;
}

function printReport({ entries, dryRun, seed }, results) {
  console.log(`\nAcesso Pro gratuito (${seed ? 'seed' : 'manual'})`);
  console.log(`Modo: ${dryRun ? 'DRY-RUN (nada foi alterado)' : 'CONFIRM (alterações aplicadas)'}`);
  console.log(`Entradas: ${entries.length}`);

  for (const result of results) {
    console.log('\n---');
    console.log(`Email: ${result.email}`);
    console.log(`Nota: ${result.note ?? '(nenhuma)'}`);
    console.log(`Firestore billing_free_access: ${result.granted ? 'ok' : 'falhou'}`);
    if (result.sync.synced) {
      console.log(`UID: ${result.sync.uid}`);
      console.log(`Assinatura atualizada: ${result.sync.appliedFreeAccess ? 'sim' : 'já ativa/outro plano'}`);
      if (result.sync.subscription) {
        console.log(`Plano: ${result.sync.subscription.plan}, status: ${result.sync.subscription.status}`);
      }
    } else {
      console.log(`Sync usuário: ignorado (${result.sync.reason})`);
    }
  }
}

async function main() {
  const parsed = parseArgs(process.argv.slice(2));
  const credentialsPath = resolveApplicationDefaultCredentials();

  if (!credentialsPath) {
    throw new Error(
      'Credenciais não encontradas. Rode `firebase login` ou defina GOOGLE_APPLICATION_CREDENTIALS.',
    );
  }

  if (!admin.apps.length) {
    admin.initializeApp({
      projectId: process.env.GCLOUD_PROJECT || process.env.GOOGLE_CLOUD_PROJECT || 'clientta-app',
    });
  }

  const results = await grantFreeAccess(parsed.entries, { dryRun: parsed.dryRun });
  printReport(parsed, results);
}

if (require.main === module) {
  main().catch((error) => {
    console.error('Falha ao conceder acesso gratuito:', error);
    process.exitCode = 1;
  });
}

module.exports = {
  grantFreeAccess,
  grantFreeAccessEntry,
  parseArgs,
};
