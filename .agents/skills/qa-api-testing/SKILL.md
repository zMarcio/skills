---
name: qa-api-testing
description: Implementar, executar e verificar testes de API com Postman (newman) ou Bruno (bru) — contrato, status, validação, autorização, efeitos em dados e collections de smoke/regressão.
---

# Testes de API (Postman / Bruno)

## Implementar

Por endpoint, cobrir no mínimo:

- **Sucesso**: status, schema do body, campos obrigatórios, tipos, paginação.
- **Validação**: campo ausente, tipo errado, limite, string vazia, payload grande → 400/422 com mensagem útil.
- **Autenticação**: sem token, token expirado, token inválido → 401.
- **Autorização**: perfil sem permissão, recurso de outra empresa/tenant (IDOR) → 403/404.
- **Idempotência**: reenvio do mesmo POST/PUT; DELETE repetido.
- **Efeito**: após escrita, GET confirma o estado (ou query read-only no banco).

Script de teste (Postman; Bruno usa `test()`/`expect` equivalentes):

```js
pm.test("status 200", () => pm.response.to.have.status(200));
pm.test("tempo < 2s", () => pm.expect(pm.response.responseTime).to.be.below(2000));
const b = pm.response.json();
pm.test("schema", () => pm.expect(b).to.have.property("data").that.is.an("array"));
pm.collectionVariables.set("id", b.data[0]?.id);
```

Boas práticas: variáveis de ambiente para base URL/token (nunca token fixo na
collection), auth herdada da pasta, datas dinâmicas (`{{$isoTimestamp}}`),
pastas por módulo, request de login no início da collection.

## Executar (CLI)

```bash
# Postman
npx newman run <collection.json> -e <env.json> --reporters cli,junit \
  --reporter-junit-export results/api.xml --bail folder
npx newman run <collection.json> -e <env.json> --folder "Cadastros"
npx newman run <collection.json> -e <env.json> -d dados.csv   # data-driven

# Bruno
npx @usebruno/cli run <pasta> --env <env> --output results/api.json
```

## Verificar

- Toda request tem ao menos um `test`. Auditar: auth ausente, URL com erro de
  digitação, request sem assertion, variáveis não definidas.
- Nenhum segredo versionado (`grep -rE "Bearer [A-Za-z0-9]" .`).
- Rodar 2x seguidas: resultado estável e sem dependência de ordem não declarada.
- Escrita só em ambiente de teste/homologação com dados sintéticos.

Carga/desempenho de endpoint → skill `qa-k6-load`.
