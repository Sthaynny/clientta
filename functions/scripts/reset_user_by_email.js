#!/usr/bin/env node
/**
 * Reseta todos os dados de um usuário no Firebase (Auth + Firestore + Stripe opcional).
 *
 * Uso:
 *   cd functions
 *   node scripts/reset_user_by_email.js <email> [--dry-run]
 *   node scripts/reset_user_by_email.js <email> --confirm
 *
 * Requer credenciais Admin:
 *   - `firebase login` (usa automaticamente o ADC em %APPDATA%\\firebase no Windows), ou
 *   - `GOOGLE_APPLICATION_CREDENTIALS` apontando para uma service account.
 * Para cancelar assinatura/cliente Stripe: STRIPE_SECRET_KEY no ambiente.
 */

const admin = require('firebase-admin');
const fs = require('fs');
const os = require('os');
const path = require('path');

const KNOWN_SUBCOLLECTIONS = ['appointments', 'encounterNotes'];
const BATCH_SIZE = 400;

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
  const positional = argv.filter((arg) => !arg.startsWith('--'));
  const flags = new Set(argv.filter((arg) => arg.startsWith('--')));

  const email = positional[0]?.trim().toLowerCase();
  if (!email) {
    throw new Error('Informe o email: node scripts/reset_user_by_email.js <email> [--dry-run|--confirm]');
  }

  const dryRun = flags.has('--dry-run');
  const confirm = flags.has('--confirm');

  if (dryRun && confirm) {
    throw new Error('Use apenas um modo: --dry-run ou --confirm');
  }
  if (!dryRun && !confirm) {
    throw new Error('Modo obrigatório: --dry-run (simular) ou --confirm (executar)');
  }

  return { email, dryRun, confirm };
}

function getFirestore() {
  return admin.firestore();
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

async function findFirestoreUsersByEmail(email) {
  const snapshot = await getFirestore()
    .collection('users')
    .where('email', '==', email)
    .get();

  return snapshot.docs;
}

async function listSubcollections(userRef) {
  const collections = await userRef.listCollections();
  return collections.map((collection) => collection.id);
}

async function countCollectionDocs(collectionRef) {
  const snapshot = await collectionRef.count().get();
  return snapshot.data().count;
}

async function deleteCollectionDocs(collectionRef, { dryRun }) {
  let deleted = 0;

  while (true) {
    const snapshot = await collectionRef.limit(BATCH_SIZE).get();
    if (snapshot.empty) {
      break;
    }

    if (!dryRun) {
      const batch = getFirestore().batch();
      for (const doc of snapshot.docs) {
        batch.delete(doc.ref);
      }
      await batch.commit();
    }

    deleted += snapshot.size;
    if (snapshot.size < BATCH_SIZE) {
      break;
    }
  }

  return deleted;
}

function isSimulatedStripeResourceId(resourceId) {
  return String(resourceId || '').startsWith('sandbox_');
}

async function cleanupStripe(userData, { dryRun }) {
  const stripeSecretKey = process.env.STRIPE_SECRET_KEY;
  const subscription = userData.subscription || {};
  const result = {
    skipped: false,
    subscriptionCanceled: false,
    customerDeleted: false,
    reason: null,
  };

  const stripeSubscriptionId = subscription.stripeSubscriptionId;
  const stripeCustomerId = subscription.stripeCustomerId;

  if (!stripeSubscriptionId && !stripeCustomerId) {
    result.skipped = true;
    result.reason = 'no_stripe_resources';
    return result;
  }

  if (
    isSimulatedStripeResourceId(stripeSubscriptionId) ||
    isSimulatedStripeResourceId(stripeCustomerId)
  ) {
    result.skipped = true;
    result.reason = 'sandbox_resources';
    return result;
  }

  if (!stripeSecretKey) {
    result.skipped = true;
    result.reason = 'missing_STRIPE_SECRET_KEY';
    return result;
  }

  const Stripe = require('stripe');
  const stripe = new Stripe(stripeSecretKey, {
    apiVersion: '2026-05-27.dahlia',
  });

  if (stripeSubscriptionId) {
    if (!dryRun) {
      try {
        await stripe.subscriptions.cancel(stripeSubscriptionId);
        result.subscriptionCanceled = true;
      } catch (error) {
        if (error.code !== 'resource_missing') {
          throw error;
        }
      }
    } else {
      result.subscriptionCanceled = true;
    }
  }

  if (stripeCustomerId) {
    if (!dryRun) {
      try {
        await stripe.customers.del(stripeCustomerId);
        result.customerDeleted = true;
      } catch (error) {
        if (error.code !== 'resource_missing') {
          throw error;
        }
      }
    } else {
      result.customerDeleted = true;
    }
  }

  return result;
}

async function buildUserResetPlan(uid, userData) {
  const userRef = getFirestore().collection('users').doc(uid);
  const subcollectionIds = await listSubcollections(userRef);
  const allSubcollections = [...new Set([...KNOWN_SUBCOLLECTIONS, ...subcollectionIds])];

  const subcollections = [];
  for (const id of allSubcollections) {
    const count = await countCollectionDocs(userRef.collection(id));
    subcollections.push({ id, count });
  }

  return {
    uid,
    email: userData.email || null,
    userDocExists: true,
    subcollections,
    stripe: {
      stripeCustomerId: userData.subscription?.stripeCustomerId || null,
      stripeSubscriptionId: userData.subscription?.stripeSubscriptionId || null,
      status: userData.subscription?.status || null,
    },
  };
}

async function resetUserData(uid, userData, { dryRun }) {
  const userRef = getFirestore().collection('users').doc(uid);
  const deletedSubcollections = {};

  const subcollectionIds = await listSubcollections(userRef);
  const allSubcollections = [...new Set([...KNOWN_SUBCOLLECTIONS, ...subcollectionIds])];

  for (const id of allSubcollections) {
    deletedSubcollections[id] = await deleteCollectionDocs(userRef.collection(id), {
      dryRun,
    });
  }

  if (!dryRun) {
    await userRef.delete();
  }

  const stripe = await cleanupStripe(userData, { dryRun });

  return {
    deletedSubcollections,
    userDocDeleted: true,
    stripe,
  };
}

async function deleteAuthUser(uid, { dryRun }) {
  if (!dryRun) {
    await admin.auth().deleteUser(uid);
  }
  return true;
}

async function resetUserByEmail(email, { dryRun }) {
  const authUser = await findAuthUserByEmail(email);
  const firestoreMatches = await findFirestoreUsersByEmail(email);

  const uidSet = new Set();
  if (authUser?.uid) {
    uidSet.add(authUser.uid);
  }
  for (const doc of firestoreMatches) {
    uidSet.add(doc.id);
  }

  if (uidSet.size === 0) {
    return {
      email,
      dryRun,
      found: false,
      message: 'Nenhum usuário encontrado para este email.',
      plans: [],
      results: [],
    };
  }

  const plans = [];
  const results = [];

  for (const uid of uidSet) {
    const userRef = getFirestore().collection('users').doc(uid);
    const userSnapshot = await userRef.get();
    const userData = userSnapshot.exists ? userSnapshot.data() || {} : {};

    const plan = await buildUserResetPlan(uid, userData);
    plans.push(plan);

    const resetResult = await resetUserData(uid, userData, { dryRun });
    const authDeleted = authUser?.uid === uid
      ? await deleteAuthUser(uid, { dryRun })
      : false;

    results.push({
      uid,
      ...resetResult,
      authDeleted,
    });
  }

  return {
    email,
    dryRun,
    found: true,
    plans,
    results,
  };
}

function printReport(report) {
  console.log(`\nReset de usuário: ${report.email}`);
  console.log(`Modo: ${report.dryRun ? 'DRY-RUN (nada foi alterado)' : 'CONFIRM (alterações aplicadas)'}`);

  if (!report.found) {
    console.log(report.message);
    return;
  }

  for (const plan of report.plans) {
    console.log('\n--- Plano ---');
    console.log(`UID: ${plan.uid}`);
    console.log(`Email no Firestore: ${plan.email ?? '(vazio)'}`);
    console.log('Subcoleções:');
    for (const sub of plan.subcollections) {
      console.log(`  - ${sub.id}: ${sub.count} documento(s)`);
    }
    console.log('Stripe:');
    console.log(`  - customer: ${plan.stripe.stripeCustomerId ?? '(nenhum)'}`);
    console.log(`  - subscription: ${plan.stripe.stripeSubscriptionId ?? '(nenhuma)'}`);
    console.log(`  - status: ${plan.stripe.status ?? '(nenhum)'}`);
  }

  for (const result of report.results) {
    console.log('\n--- Resultado ---');
    console.log(`UID: ${result.uid}`);
    console.log(`Documento users/{uid} removido: ${result.userDocDeleted}`);
    console.log(`Auth removido: ${result.authDeleted}`);
    console.log('Subcoleções removidas:');
    for (const [id, count] of Object.entries(result.deletedSubcollections)) {
      console.log(`  - ${id}: ${count}`);
    }
    if (result.stripe.skipped) {
      console.log(`Stripe: ignorado (${result.stripe.reason})`);
    } else {
      console.log(
        `Stripe: assinatura cancelada=${result.stripe.subscriptionCanceled}, cliente removido=${result.stripe.customerDeleted}`,
      );
    }
  }
}

async function main() {
  const { email, dryRun } = parseArgs(process.argv.slice(2));
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

  const report = await resetUserByEmail(email, { dryRun });
  printReport(report);

  if (!report.found) {
    process.exitCode = 1;
  }
}

if (require.main === module) {
  main().catch((error) => {
    console.error('Falha ao resetar usuário:', error);
    process.exitCode = 1;
  });
}

module.exports = {
  resetUserByEmail,
  parseArgs,
  deleteCollectionDocs,
  cleanupStripe,
};
