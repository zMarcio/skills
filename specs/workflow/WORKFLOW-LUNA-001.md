# WORKFLOW-LUNA-001 — evolução operacional

Estado: concluído tecnicamente; preparado para commit local autorizado no Find.

## Pedido e autorização

Em 2026-09-26, o usuário pediu analisar/evoluir as skills e agentes preservando seu
estilo, preparar specs, código e revisões autossuficientes com Luna 6 max e worktrees.
Depois pediu aplicar no repositório /home/marciolima/Documentos/find e commitar ali.
Commit local autorizado; nenhuma solicitação de push. Alterações existentes no
pacote skills preservadas; .tmp-profile-draft-count/ no Find fica fora da entrega.

## Escopo e decisões

- Manter KISS/YAGNI, spec-first, GRILL-ME para lacunas materiais, RTK, comunicação
  curta, design consistente e estado persistente no projeto.
- Acrescentar Explorer, Spec Writer e Integrator com responsabilidades delimitadas.
- Criar spec-ready, worktree-delivery e delivery-evidence com descoberta local.
- Registrar onze papéis Codex com gpt-6-luna/max; limitar a três subagentes ativos.
- Atualizar compatibilidade find-job-dev, sem impor modelo Codex ao Claude.
- Definir retomada, ownership de specs/contexto, evidências e revisão independente.
- Preservar histórico e regras locais; nenhuma alteração funcional de produto.

## Aceite

1. TOML válido, perfis referenciados existentes e skills com frontmatter válido.
2. Regras de autonomia não inventam decisões de produto nem autorização de push.
3. Worktrees incluem tratamento de mudanças locais/novos arquivos e revisão integrada.
4. Find preserva seus registros e limitações de validação; apenas arquivos do
   workflow entram no commit, incluindo exceções precisas no .gitignore.
5. Resultado declara verificações reais e limites da ativação em runtime.

## Tarefas e evidências

- GOD: análise, autoria, configuração, sincronização e commit autorizado no Find.
- Auditor Luna 6 max: leitura independente dos oito perfis e conflitos existentes.
- Reviewer Luna 6 max: revisão final do pacote preparado, com evidências no handoff.
- Validação: sintaxe TOML, skills, referências, diff e inventário. Testes do produto
  não se aplicam a esta mudança de instruções/configuração.

## Fora do escopo

Instalação global, alteração de skills externas, código/dados do produto, mudança
automática da sessão atual, publicação remota e benchmark de custo/velocidade.

## Resultado da revisão e validação

- Auditoria e revisão documental independentes executadas com gpt-6-luna/max.
- Corrigidos gatilho excessivo do fluxo completo, identidade do adaptador legado,
  falsa alegação de isolamento sequencial e conflito entre suíte e dados protegidos.
- Três skills passaram no quick_validate; 13 TOMLs do Find parseados e referências
  dos perfis conferidas; links locais resolvidos e 15 registros históricos preservados.
- Sem execução do produto nem verificação de descoberta numa nova sessão Codex.
  A configuração depende da confiança/versão do cliente. Nenhum ganho de tempo
  ou custo foi medido. Commit será identificado no histórico Git, sem hash circular.
