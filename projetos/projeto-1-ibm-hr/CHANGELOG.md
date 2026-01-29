# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [2026-01-29] - Renomeacao de Ficheiros SQL com Prefixo Numerico

### Changed
- Renomeados 16 ficheiros em `sql/` com prefixo numerico sequencial (`01_`-`08_`) para reflectir ordem de execucao:
  - `schema.sql/.ipynb` → `01_schema.sql/.ipynb`
  - `import_data.sql/.ipynb` → `02_import_data.sql/.ipynb`
  - `analise_exploratoria.sql/.ipynb` → `03_analise_exploratoria.sql/.ipynb`
  - `analise_genero.sql/.ipynb` → `04_analise_genero.sql/.ipynb`
  - `analise_felicidade.sql/.ipynb` → `05_analise_felicidade.sql/.ipynb`
  - `analise_envelhecimento.sql/.ipynb` → `06_analise_envelhecimento.sql/.ipynb`
  - `analise_attrition.sql/.ipynb` → `07_analise_attrition.sql/.ipynb`
  - `analise_adicional.sql/.ipynb` → `08_analise_adicional.sql/.ipynb`
- Actualizadas referencias em `CLAUDE.md` (Projeto_1), `CLAUDE.md` (Cegid_Academy), `PROGRESS.md`

## [2026-01-29] - Correccoes SQL e Jupyter Notebooks

### Fixed
- `analise_genero.sql/.ipynb` - 2 erros corrigidos:
  - Arithmetic overflow no CAST(ROUND(...) AS VARCHAR) - adicionado DECIMAL intermediario
  - Parenteses mal fechados no ROUND do gap salarial percentual
- `analise_adicional.sql/.ipynb` - 2 erros corrigidos:
  - `STRING_AGG(DISTINCT ...)` invalido em SQL Server - substituido por subquery com SELECT DISTINCT
  - Arithmetic overflow no CAST de percentagem (distancia = 1)
- `analise_envelhecimento.sql/.ipynb` - 1 erro corrigido:
  - Arithmetic overflow no CAST de 3 blocos UNION ALL (resumo 55+/60+/62+)
- Padrao comum: `CAST(ROUND(... * 100.0 / ..., N) AS VARCHAR)` falha via pymssql; corrigido com `CAST(CAST(... AS DECIMAL(5,1)) AS VARCHAR)`

## [2026-01-29] - Jupyter Notebooks para Analise SQL

### Added
- 8 Jupyter notebooks em `sql/` correspondendo aos ficheiros SQL:
  - `schema.ipynb` - Setup: criacao da tabela (3 queries)
  - `import_data.ipynb` - Setup: importacao CSV + verificacao (6 queries)
  - `analise_exploratoria.ipynb` - "Quem Somos" (18 queries)
  - `analise_genero.ipynb` - Igualdade de genero (18 queries)
  - `analise_felicidade.ipynb` - Satisfacao e felicidade (19 queries)
  - `analise_envelhecimento.ipynb` - Envelhecimento e reforma (17 queries)
  - `analise_attrition.ipynb` - Perfil de quem sai (21 queries)
  - `analise_adicional.ipynb` - Questoes do grupo (27 queries)
- Total: 333 celulas, 129 queries SQL executaveis via `%%sql`
- Arquitectura conforme notebooks de exercicios (kernel `python3`/`cegid-academy`, Python 3.12.11)
- Conexao JupySQL via `pymssql` ao Docker SQL Server (Projeto1_IBM_HR)

### Changed
- `CLAUDE.md` (Projeto_1) - tabela de ficheiros SQL actualizada com notebooks

## [2026-01-28] - Analise SQL 100% Concluida

### Added
- Executada `analise_felicidade.sql` - 8 seccoes, 7 perguntas respondidas (F1-F7)
  - Indice de felicidade global: 2.73/4 (SATISFEITOS)
  - 71.2% com bom WorkLifeBalance
  - Overtime correlaciona com MAIS felicidade (contra-intuitivo)
  - Quem saiu tinha satisfacao muito mais baixa (2.55 vs 2.77)
- Executada `analise_envelhecimento.sql` - 9 seccoes, 6 perguntas respondidas (E1-E6)
  - 69 colaboradores (4.7%) com 55+ anos
  - 0 reformas nos proximos 5 anos
  - Manager e o unico cargo com gap de sucessao (17 seniores vs 7 jovens)
  - 39 seniores com 20+ anos de experiencia em risco
- Executada `analise_attrition.sql` - 8 seccoes, 8 perguntas respondidas (A1-A8)
  - Taxa global: 16.1% (acima benchmark 10-15%)
  - Sales Representative: 39.8% attrition (mais critico)
  - OverTime: 3x mais risco de saida (30.5% vs 10.4%)
  - 164 colaboradores actuais com 3+ factores de risco
  - Perfil de quem sai: jovem, solteiro, mal pago, overtime, viaja frequentemente
- Executada `analise_adicional.sql` - 9 seccoes, 9 questoes do grupo respondidas (Q1-Q9)
  - Manager e o unico cargo em 3 departamentos
  - 42.9% sem stock options (distribuicao uniforme)
  - PerformanceRating confirmado so com valores 3 e 4
  - Sem conflito de geracoes na satisfacao; Gen Z com 28.1% attrition

### Changed
- `QUESTIONS.md` - todas as 6 seccoes preenchidas com evidencia completa (46 perguntas)
  - Adicionada seccao 2 (Felicidade: F1-F7)
  - Adicionada seccao 4 (Envelhecimento: E1-E6)
  - Adicionada seccao 5 (Attrition: A1-A8)
  - Adicionada seccao 6 (Questoes Adicionais: Q1-Q9)
  - Resumo de progresso: 46/46 (100%)
- `INSIGHTS.md` - resumo executivo completo com 6 seccoes
  - KPIs actualizados com indice felicidade e colaboradores em risco
  - Seccao 2 (Felicidade) preenchida
  - Seccao 4 (Envelhecimento) preenchida
  - Seccao 5 (Attrition) preenchida com factores de risco e perfil comparativo
  - Seccao 6 (Questoes Adicionais) adicionada
  - Alertas e Recomendacoes actualizados (8 alertas, 6 pontos positivos, 12 recomendacoes)
  - Tabela de referencia actualizada (52 queries, 100% concluido)
- `PROGRESS.md` - fase Analise SQL marcada como 100% concluida (52/52 queries)

## [2026-01-28] - Reorganizacao para Rastreabilidade

### Changed
- `QUESTIONS.md` - reestruturado com formato expandido de rastreabilidade
  - Cada questao respondida (G1-G7, C1-C9) agora contem: query SQL, resultado bruto, interpretacao
  - Modelo hibrido: INSIGHTS.md (executivo) + QUESTIONS.md (evidencia completa)
  - Seccoes pendentes (Felicidade, Envelhecimento, Attrition) mantidas em formato tabela
- `INSIGHTS.md` - adicionadas referencias cruzadas para QUESTIONS.md
  - Cada insight tem link `> Evidencia: [Gx/Cx](QUESTIONS.md#...)` para a questao correspondente
  - Header com nota direccionando para QUESTIONS.md para evidencia completa
  - Tabela de referencia rapida com links para seccoes de evidencia
- `PROGRESS.md` - adicionada coluna "Evidencia" a checklist de analises SQL
  - Links directos para seccoes relevantes de QUESTIONS.md
  - Actualizada descricao dos ficheiros de documentacao
- `CLAUDE.md` (Projeto_1) - actualizada descricao dos documentos

## [2026-01-28]

### Added
- `INSIGHTS.md` - novo ficheiro centralizando todas as descobertas da analise
  - Resumo executivo com KPIs
  - Insights organizados por prioridade estrategica (Genero, Felicidade, Caracterizacao, Envelhecimento, Attrition)
  - Alertas e recomendacoes
  - Referencia rapida queries por tema

### Changed
- `QUESTIONS.md` - reestruturado com mapeamento completo pergunta → query → resposta
  - 37 perguntas mapeadas com ficheiro SQL, numero da query, estado e resposta
  - Resumo de progresso (16/37 = 43% respondidas)
  - Seccao de perguntas emergentes
- `PROGRESS.md` - simplificado para focar apenas no tracking
  - Removidos insights detalhados (migrados para INSIGHTS.md)
  - Adicionada seccao de documentacao relacionada
- `CLAUDE.md` - actualizada seccao de documentacao com novos ficheiros

### Added
- Executed `analise_genero.sql` - all 9 queries successful
- Key gender insights documented:
  - 40% women (10pt gap to 50% target)
  - Glass ceiling: women drop from 48.1% at Senior to 34.8% at Executive
  - Positive surprise: women earn MORE on average ($6,686 vs $6,380)
  - Women have lower attrition (14.8% vs 17%)
- Executed `analise_exploratoria.sql` - all 9 queries successful
- Documented comprehensive insights in PROGRESS.md:
  - KPIs: 1470 employees, 36.9 avg age, 40% women, 16.1% attrition, $6,503 avg salary
  - Structure: R&D dominant (65%), pyramid hierarchy well-defined
  - Demographics: 30-34 age bracket dominant, 69 employees near retirement (55+)
  - Education: 69% Bachelor+, Life Sciences dominant (41%)
  - Tenure: 7 years average, 30% with 6-10 years

### Added
- CHANGELOG.md for tracking project history
- PROGRESS.md for tracking current state and insights
- QUESTIONS.md for tracking emergent business questions during analysis

### Changed
- Reorganized project structure into subfolders:
  - `sql/` - All SQL scripts (8 files)
  - `enunciado/` - CSV data file and interview notes
  - `setup/` - Installation guides for Windows and macOS
- Updated file paths in CLAUDE.md, PROGRESS.md

## [2026-01-27]

### Added
- Analysis SQL files structure:
  - `analise_exploratoria.sql` - "Quem Somos" queries (9 queries)
  - `analise_genero.sql` - Gender equality queries (9 queries)
  - `analise_felicidade.sql` - Satisfaction queries (8 queries)
  - `analise_envelhecimento.sql` - Age and retirement queries (6 queries)
  - `analise_attrition.sql` - Attrition profile queries (8 queries)
  - `analise_adicional.sql` - Group-specific questions (3 queries)

## [2026-01-26]

### Added
- Setup documentation:
  - `setup-windows-ssms.md` - Windows + SSMS tutorial
  - `setup-macos-docker.md` - macOS + Docker tutorial
- Database indexes for performance optimization

## [2026-01-25]

### Added
- Initial project structure
- `schema.sql` - Database and table creation
- `import_data.sql` - CSV import script (1470 records)
- `CLAUDE.md` - Project documentation
- Data source: `WA_Fn-UseC_-HR-Employee-Attrition.csv` (Kaggle)

### Changed
- Database `Projeto1_IBM_HR` created and populated
