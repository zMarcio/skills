---
name: qa-test-design
description: Projetar casos de teste rastreáveis a critérios de aceite usando técnicas (partição, valor limite, tabela de decisão, transição de estado, pairwise) e classificar cada caso por perfil de QA.
---

# Design de casos de teste

## Técnica por tipo de regra

- Campo com faixas/formatos → **partição de equivalência + valor limite**
  (mín−1, mín, máx, máx+1, vazio, nulo, espaços, unicode/emoji, tamanho extremo).
- Regra com várias condições → **tabela de decisão** (uma coluna por combinação relevante).
- Entidade com status (ticket, atendimento, oportunidade) → **transição de estado**:
  transições válidas, inválidas e repetidas (duplo clique, reenvio).
- Muitas combinações de filtros/config → **pairwise**, não produto cartesiano.
- Lista/busca → paginação, ordenação, resultado vazio, acúmulo entre buscas,
  reset de scroll, debounce.
- Permissão → perfil com/sem acesso, sessão ativa após mudança de permissão (JWT antigo).

## Regras

- Todo caso aponta para um CA (`CA1`) ou risco (`R1`). Caso sem origem é cortado.
- Um objetivo por caso. Resultado esperado observável (texto, status HTTP, linha no banco).
- Dados sintéticos; nunca dados reais de clientes.
- Priorizar: P1 caminho principal e perda de dados; P2 erros e limites; P3 cosmético.
- Escolher a camada mais barata que detecta o defeito (API antes de E2E).

## Perfil executor

| Perfil | Quando |
|---|---|
| api | contrato, status, validação, autorização, efeito no banco via endpoint |
| automatizado | fluxo de UI repetível que vale manter na suíte Playwright |
| exploratorio | comportamento pouco especificado, UX, combinações não previstas |
| integracao | fluxo que cruza serviços, filas, webhooks ou banco |
| regressao | módulos vizinhos que o card pode ter quebrado |

## Saída

```text
ID | CA/R | Perfil | Prioridade | Pré-condição | Passos | Dados | Esperado
TC01 | CA1 | api | P1 | ... | ... | ... | ...
```

Informar quais CAs ficaram sem caso e por quê.
