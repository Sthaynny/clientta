const CALLABLE_OPTIONS = {
  region: 'southamerica-east1',
  invoker: 'public',
};

function callableWithSecrets(secrets) {
  return { ...CALLABLE_OPTIONS, secrets };
}

module.exports = { CALLABLE_OPTIONS, callableWithSecrets };
