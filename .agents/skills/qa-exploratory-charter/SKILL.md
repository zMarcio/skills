---
name: qa-exploratory-charter
description: Conduzir teste exploratório por sessões com charter, timebox, heurísticas (SFDIPOT, tours, CRUD, interrupções) e notas com evidências.
---

# Teste exploratório por sessão

## Charter

```text
Explorar <área/funcionalidade>
com <recursos: perfil, dados, dispositivo, heurística>
para descobrir <riscos: perda de dados, inconsistência, UX, permissão>
Timebox: 30–60 min
```

Um charter por risco. Derivar dos riscos e perguntas abertas do card.

## Heurísticas

- **SFDIPOT**: Estrutura, Função, Dados, Interfaces, Plataforma, Operações, Tempo.
- **CRUD completo**: criar, ler, editar, excluir, e reabrir depois de cada passo.
- **Interrupções**: recarregar no meio, voltar do navegador, duas abas, sessão expirada,
  rede lenta (DevTools → Slow 3G), clique duplo em salvar.
- **Dados hostis**: emoji e tom de pele, acentos, RTL, 5000 caracteres, espaços nas pontas,
  telefone com/sem DDI, colar texto formatado.
- **Estados**: vazio, um item, muitos (paginação/scroll), erro do servidor.
- **Consistência**: mesmo dado em telas diferentes (lista × detalhe × relatório × dashboard);
  tema claro/escuro; idioma.
- **Permissões**: mesmo fluxo com perfis diferentes; alterar permissão com sessão aberta.
- **Tempo real**: duas sessões observando o mesmo registro (contadores, não lidos).

## Notas da sessão

```text
Charter:
Início/fim:
Cobertura: o que foi explorado
Achados: BUG-xx / dúvida / melhoria (com evidência)
Riscos não explorados:
% tempo em teste vs. setup vs. investigação de bug:
```

## Verificar

- Todo achado tem passos reproduzíveis e evidência (print, vídeo, request, console).
- Bug → `qa-escritor-card`. Melhoria ou dúvida de requisito → separar, não é defeito.
- Fluxo que vale repetir sempre → sugerir automação ao perfil automatizado.

Com navegador disponível, usar a skill do navegador correspondente e capturar
console e requisições de rede durante a sessão.
