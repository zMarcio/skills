---
name: qa-integration-flows
description: Testar fluxos que cruzam serviços — API, filas/workers, webhooks, WebSocket, armazenamento (S3) e canais externos (WhatsApp Baileys/Meta) — verificando contrato, propagação, idempotência e falhas parciais.
---

# Testes de integração

## Mapear o fluxo

Desenhar a cadeia antes de testar: origem → transporte → processamento → persistência →
efeito visível. Ex.: mensagem WhatsApp → webhook/socket → fila → worker → banco →
socket → tela de Conversas. Identificar em cada salto: contrato, log e onde observar.

## Casos obrigatórios

- **Caminho feliz ponta a ponta**: evento entra e aparece no destino com os mesmos dados.
- **Contrato**: campos, tipos e formatos entre produtor e consumidor (telefone normalizado,
  IDs `@g.us`/LID, datas com fuso, encoding de emoji).
- **Idempotência/duplicidade**: mesmo evento 2x (retry de webhook, reconexão) não duplica.
- **Ordem**: eventos fora de ordem ou simultâneos não corrompem estado.
- **Falha parcial**: dependência fora (S3, Redis, API externa) → erro tratado, retry com
  limite, sem registro órfão; recuperação ao voltar.
- **Filtro de escopo**: o que não deveria ser processado não é (ex.: grupo externo não
  aciona bot).
- **Propagação de configuração/permissão**: mudança vale para sessões já abertas quando
  o requisito exige.
- **Recursos**: conexões/sockets fechados após uso; sem crescimento contínuo em logs/métricas.

## Executar

- Preferir ambiente de homologação ou containers locais (`podman compose up`/`docker compose up`).
- Canais externos reais só com número/conta de teste. Sem mensagem para contato real.
- Observar: logs (`pm2 logs <app> --lines 200`), fila, banco (query read-only), rede.

## Verificar

- Cada salto do fluxo tem evidência (request, log com timestamp, linha no banco, tela).
- Dados no destino batem com a origem (skill `qa-data-integrity` para conferência em massa).
- Relatar latência ponta a ponta quando o requisito falar em tempo real.
