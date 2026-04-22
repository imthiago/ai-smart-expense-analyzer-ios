# AI Smart Expense Analyzer

App iOS para registro e categorização automática de despesas usando IA. O usuário adiciona uma despesa com valor e descrição, e o app categoriza automaticamente via OpenAI — ou de forma offline com um provider mock baseado em palavras-chave.

## Funcionamento online
https://github.com/user-attachments/assets/de19fe97-8007-4a40-9b1b-880c668d4807

## Funcionamento offline
https://github.com/user-attachments/assets/e915a686-ac0f-4209-92fa-41d752c4fd12

## Funcionalidades

- Registro de despesas com valor, descrição e data
- Categorização automática via GPT-4o-mini (ou mock offline)
- Filtro de despesas por categoria
- Geração de insights: categoria com maior gasto e despesas recorrentes
- Persistência local com Core Data


O app já funciona sem nenhuma configuração adicional — por padrão usa o `MockAIProvider`, que categoriza despesas offline com base em palavras-chave.

### Usando a API real da OpenAI (opcional)

Para categorizar com GPT-4o-mini, configure as variáveis de ambiente no scheme:

1. No Xcode: **Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables**
2. Adicione as variáveis abaixo:

| Nome | Valor |
|------|-------|
| `OPENAI_API_KEY` | sua chave de API |
| `USE_REAL_AI` | `1` |

Sem essas variáveis o app continua funcionando normalmente com o mock.

## Arquitetura

O projeto segue Clean Architecture em 4 camadas, com dependências sempre apontando para dentro (Presentation → Domain ← Data):

```
Domain         → Entidades, Use Cases e protocolos
Data           → Repositório CoreData, providers de IA, HTTP client
Infrastructure → Container de Injeção de Dependência, feature flags, logging
Presentation   → ViewControllers, ViewModels, Coordinators (UIKit programático)
```

O padrão de UI é **MVVM** com closures para observação de estado e navegação via **Coordinator pattern**.

## Stack

- **UIKit** — View Code
- **Core Data** — persistência local
- **Swift Concurrency** — async/await em todos os use cases e repositório
- **OpenAI API** — GPT-4o-mini para categorização
- **OSLog** — logging estruturado via `AppLogger` e `ExecutionTracer`
- **XCTest** — testes unitários


## Feature flags

Controladas via variáveis de ambiente no scheme:

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `USE_REAL_AI` | `0` | Usa OpenAI quando o valor é `1`, Mock quando o valor é 0 |
| `INSIGHTS_ENABLED` | `1` | Oculta a seção de insights quando o valor é `0` |
| `OPENAI_API_KEY` | — | Chave da API OpenAI |
