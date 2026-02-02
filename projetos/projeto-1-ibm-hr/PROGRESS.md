# Progresso - Projeto 1: IBM HR Analytics

## Estado Actual

### Fases do Projeto

| Fase | Descricao | Estado |
|------|-----------|--------|
| Setup | 01_schema.sql e 02_import_data.sql | ✅ Concluido |
| Analise SQL | Executar queries e documentar insights | ✅ Concluido (100%) |
| Power BI | Criar dashboard de monitorizacao | ⬜ Pendente |
| Apresentacao | 3 slides executivos | ⬜ Pendente |

### Checklist de Analises SQL

| Ficheiro | Tema | Queries | Perguntas | Estado | Evidencia |
|----------|------|---------|-----------|--------|-----------|
| `03_analise_exploratoria.sql` | Quem Somos | 18 | 9 (C1-C9) | ✅ Concluido | [C1-C9](QUESTIONS.md#3-caracterizacao---quem-somos) |
| `04_analise_genero.sql` | Igualdade de Genero | 18 | 7 (G1-G7) | ✅ Concluido | [G1-G7](QUESTIONS.md#1-igualdade-de-genero) |
| `05_analise_felicidade.sql` | Felicidade | 19 | 7 (F1-F7) | ✅ Concluido | [F1-F7](QUESTIONS.md#2-felicidade) |
| `06_analise_envelhecimento.sql` | Envelhecimento | 17 | 6 (E1-E6) | ✅ Concluido | [E1-E6](QUESTIONS.md#4-envelhecimento) |
| `07_analise_attrition.sql` | Attrition | 21 | 8 (A1-A8) | ✅ Concluido | [A1-A8](QUESTIONS.md#5-attrition) |
| `08_analise_adicional.sql` | Questoes do Grupo | 27 | 9 (Q1-Q9) | ✅ Concluido | [Q1-Q9](QUESTIONS.md#6-questoes-adicionais-do-grupo) |
| **Total** | | **120** | **46** | **100%** | |

---

## Proximos Passos

1. [x] Executar `sql/05_analise_felicidade.sql` e documentar insights
2. [x] Executar `sql/06_analise_envelhecimento.sql` e documentar insights
3. [x] Executar `sql/07_analise_attrition.sql` e documentar insights
4. [x] Executar `sql/08_analise_adicional.sql` e documentar insights
5. [ ] Compilar principais descobertas para Power BI
6. [ ] Criar dashboard Power BI
7. [ ] Preparar 3 slides executivos

---

## Documentacao Relacionada

| Ficheiro | Conteudo |
|----------|----------|
| `INSIGHTS.md` | Resumo executivo - KPIs, conclusoes e links para evidencia |
| `QUESTIONS.md` | Rastreabilidade completa - questao, query SQL, resultado bruto, interpretacao |
| `README.md` | Especificacao do projeto e dicionario de variaveis |
| `CHANGELOG.md` | Historico de alteracoes |

---

## Bloqueios / Notas

- Nenhum bloqueio actual
- Ambiente Docker funcional (container `sqlserver`, porta 1433)
- MCP `cegid-sqlserver` disponivel para execucao directa

---

## Historico de Actualizacoes

| Data | Alteracao |
|------|-----------|
| 2026-01-29 | Correccao de inconsistencias na documentacao - contagens de queries, percentagens e nomes de ficheiros |
| 2026-01-28 | Analise SQL 100% concluida - 120 queries executadas, 46 perguntas respondidas |
| 2026-01-28 | Executada 08_analise_adicional.sql - 27 queries, questoes do grupo respondidas |
| 2026-01-28 | Executada 07_analise_attrition.sql - 21 queries, perfil de quem sai identificado |
| 2026-01-28 | Executada 06_analise_envelhecimento.sql - 17 queries, risco de sucessao em Managers |
| 2026-01-28 | Executada 05_analise_felicidade.sql - 19 queries, indice felicidade 2.73/4 |
| 2026-01-28 | Reorganizacao documentacao: QUESTIONS.md expandido com evidencia completa, INSIGHTS.md com referencias cruzadas |
| 2026-01-28 | Reorganizacao da documentacao: criado INSIGHTS.md, actualizado QUESTIONS.md |
| 2026-01-28 | Executada 04_analise_genero.sql - 18 queries, descoberto glass ceiling |
| 2026-01-28 | Executada 03_analise_exploratoria.sql - 18 queries, insights documentados |
| 2026-01-28 | Reorganizacao: scripts SQL em `sql/`, enunciado em `enunciado/`, setup em `setup/` |
| 2026-01-28 | Criacao do ficheiro PROGRESS.md |
