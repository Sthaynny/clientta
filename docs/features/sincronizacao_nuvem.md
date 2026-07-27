# Sincronização na nuvem

## Resumo

Sincronização **opcional** entre dispositivos via conta e backend — **fora do escopo atual** do **Sextante**, que é offline-first sem login.

## Plano

**Pro** (futuro, se o propósito mudar)

### Free

- Apenas dados no aparelho; sem conta.

### Pro

- Sync criptografado ponta a ponta ou backup em nuvem opt-in.
- Exigiria revisão explícita de [PROPOSITO.md](../PROPOSITO.md) e política de privacidade.

## Status no app

**Planejado** — não há Firebase, auth nem API no repositório.

## Dependências / notas técnicas

- Contradiz princípio “sem backend” até decisão documentada.
- Alternativa intermediária: [export_backup.md](export_backup.md) manual permanece válida para Free/Pro offline.
