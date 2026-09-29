---
name: qa-k6-load
description: Planejar, escrever e executar testes de carga com k6 em fases (smoke, load, stress, spike, soak) com thresholds, e interpretar p95, erros e TTFB.
---

# Carga com k6

Executar somente em ambiente autorizado (nunca produção sem aprovação explícita
com janela definida). Avisar o time antes de stress/soak em ambiente compartilhado.

## Fases

| Fase | Objetivo | Perfil típico |
|---|---|---|
| smoke | script funciona | 1–2 VUs, 1 min |
| load | carga esperada | rampa até N VUs, 10–20 min |
| stress | ponto de quebra | rampa acima de N até degradar |
| spike | pico súbito | salto 0→alto→0 |
| soak | vazamento/estabilidade | carga média, 1h+ |

Avançar de fase apenas se a anterior passou.

## Script base

```js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [{ duration: '1m', target: 10 }, { duration: '5m', target: 10 }, { duration: '1m', target: 0 }],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<800'],
    'http_req_waiting': ['p(95)<600'], // TTFB
  },
};

const BASE = __ENV.BASE_URL;
const TOKEN = __ENV.TOKEN;

export default function () {
  const r = http.get(`${BASE}/api/v1/<rota>`, { headers: { Authorization: `Bearer ${TOKEN}` } });
  check(r, { '200': (x) => x.status === 200 });
  sleep(1);
}
```

```bash
k6 run -e BASE_URL=https://<homolog> -e TOKEN=$TOKEN script.js
k6 run --summary-export results/k6.json script.js
```

## Priorizar alvos

Endpoints sem paginação, relatórios com filtro amplo (ex.: anual), histórico de
atendimento, exportações e buscas. TTFB alto em GET simples indica query/serialização.

## Interpretar

- p95 subindo com VUs constantes → saturação (pool de conexões, threadpool, CPU).
- Erros 5xx/timeout só acima de X VUs → ponto de quebra; registrar X.
- Memória do processo crescendo no soak → vazamento (cruzar com PM2/logs).
- Relatar: fase, VUs, p50/p95/p99, taxa de erro, TTFB, ponto de quebra e hipótese.
