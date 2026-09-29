---
name: qa-data-integrity
description: Verificar integridade de dados no PostgreSQL antes e depois de uma mudança — contagens, órfãos, duplicidades, nulos indevidos, normalização e backup seguro — usando somente leitura, exceto restore autorizado.
---

# Integridade de dados (PostgreSQL)

Aplicar quando o card mexe em dados: migration, importação, sincronização, normalização,
exclusão em massa, restore ou mudança de relacionamento.

## Regras de segurança

- Queries de verificação são **somente leitura**. Usar transação read-only:
  `psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "SET default_transaction_read_only = on;" -f checks.sql`
- Nunca em produção sem autorização explícita. Nunca exportar dados pessoais para evidência;
  evidência = contagens e IDs.
- Restore/alteração só com autorização e backup antes:
  `pg_dump -n <schema1> -n <schema2> -Fc -f /tmp/backup_$(date +%Y%m%d_%H%M%S).dump "$DATABASE_URL"`
  (por schema, cobrindo tudo que o CASCADE atinge) → `TRUNCATE ... CASCADE` →
  `pg_restore --data-only --no-owner --no-privileges`. Sem `--clean`, `--create`,
  `--disable-triggers`.

## Snapshot antes/depois

Rodar o mesmo `checks.sql` antes e depois; comparar saída (`diff antes.txt depois.txt`).

```sql
-- contagem por tabela afetada
SELECT 'contact.contacts' t, count(*) FROM contact.contacts;

-- órfãos (filho sem pai)
SELECT count(*) FROM <schema>.<filho> f
LEFT JOIN <schema>.<pai> p ON p.id = f.<pai_id>
WHERE f.<pai_id> IS NOT NULL AND p.id IS NULL;

-- duplicidade pela chave de negócio
SELECT <chave>, count(*) FROM <schema>.<tabela>
GROUP BY <chave> HAVING count(*) > 1 LIMIT 20;

-- nulos em coluna obrigatória pelo negócio
SELECT count(*) FROM <schema>.<tabela> WHERE <coluna> IS NULL;

-- normalização (ex.: telefone só dígitos)
SELECT count(*) FROM contact.contacts WHERE phone ~ '[^0-9]';

-- linhas alteradas pela janela da mudança
SELECT count(*) FROM <schema>.<tabela> WHERE updated_at >= '<inicio>';
```

## Verificar

- Contagens mudaram exatamente como o card prevê (nem mais, nem menos).
- Zero órfãos, zero duplicidades novas, zero nulos indevidos, normalização 100%.
- Constraints presentes: `\d+ <schema>.<tabela>` (FK, unique, not null).
- Leitura pela aplicação confere com o banco (API/tela mostram o mesmo número).
- Divergência → `qa-bug-card` com a query e as contagens como evidência.
