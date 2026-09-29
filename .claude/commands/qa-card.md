---
description: Fluxo completo de QA a partir de um card
argument-hint: <url-ou-id-do-card>
---

Para o card $ARGUMENTS:
1. Use o agent card-reader para extrair o escopo.
2. Use o test-designer para gerar os casos.
3. Use o test-executor para executar.
4. Use o regression-runner nos módulos impactados.
5. Use o integrity-checker se o card mexer em dados.
6. Para cada falha, use o bug-reporter.
Consolide um relatório final: casos executados, passou/falhou, regressão, bugs abertos.

## Regras do fluxo

- Passe a saída de cada etapa como entrada da próxima (escopo → casos → resultados).
  Não reexecute uma etapa cuja entrada não mudou.
- Etapas 3, 4 e 5 podem rodar em paralelo depois da etapa 2 quando não
  disputarem os mesmos dados de teste; caso contrário, rode em sequência.
- Se faltar ambiente, credencial de teste ou acesso ao card, pergunte uma vez;
  enquanto isso, avance no que não depende disso (ex.: design de casos).
- A etapa 5 só roda se o card-reader marcar `Mexe em dados: sim`; senão
  registre "não aplicável" no relatório.
- A etapa 6 recebe as falhas das etapas 3, 4 e 5. Falha de ambiente e teste
  instável são listados à parte, não viram bug de produto.
- Nenhum efeito externo (criar issue/página, enviar mensagem, escrever em
  produção) sem autorização explícita. Por padrão, bugs saem como texto.
- Monte o relatório final com a skill `qa-relatorio`, com parecer
  Apto / Apto com ressalvas / Não apto / Inconclusivo e cobertura pendente.
  Os cards de bug vêm logo abaixo, cada um em seu bloco de código.
