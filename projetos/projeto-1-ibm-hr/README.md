# Projeto 1: IBM HR Analytics

Analise de dados de RH da IBM com SQL Server — 129 queries SQL respondendo a 46 questoes estrategicas.

## Contexto do Projeto

### Cenario Ficticio
- **Papel**: Novo diretor de RH da IBM
- **Situacao**: Antigo gerente faleceu, levando conhecimento nao documentado
- **Objetivo**: Conhecer a populacao da empresa atraves de analise de dados

### Dados
- **Ficheiro**: `enunciado/WA_Fn-UseC_-HR-Employee-Attrition.csv`
- **Entrevista**: `enunciado/Notas_Entrevista_Projeto01.docx`
- **Registos**: 1470 colaboradores
- **Variaveis**: 35 colunas
- **Fonte**: Dataset ficticio criado por IBM data scientists (Kaggle)

## Prioridades Estrategicas

### 1. Igualdade de Genero (CRITICO)
- **Meta**: 50% mulheres em todos os cargos
- Analise por departamento, cargo, nivel hierarquico
- Gap salarial por genero

### 2. Felicidade dos Colaboradores
- Indicadores: EnvironmentSatisfaction, JobSatisfaction, RelationshipSatisfaction, WorkLifeBalance
- Factores correlacionados: OverTime, BusinessTravel, DistanceFromHome

### 3. Caracterizacao da Populacao ("Quem Somos")
- Demografia: idade, genero, estado civil, educacao
- Estrutura: departamentos, cargos, niveis
- Antiguidade: anos na empresa, no cargo, com o manager

### 4. Envelhecimento e Reforma
- Idade de reforma em Portugal: 67 anos
- Identificar colaboradores perto dos 60
- Riscos de saida em massa por area

### 5. Attrition (Saidas)
- Perfil de quem sai vs quem fica
- Factores de risco

## Principais Descobertas

- **Genero**: 40% mulheres (meta 50%); glass ceiling no nivel Executive (34.8%)
- **Felicidade**: Indice 2.73/4 (SATISFEITOS); 71.2% com bom WorkLifeBalance
- **Attrition**: 16.1% global; Sales Rep 39.8%; OverTime = 3x mais risco
- **Envelhecimento**: 69 (4.7%) com 55+; Manager com gap de sucessao
- **164 colaboradores actuais em risco** (3+ factores de risco)

## Ficheiros SQL

Localizacao: `sql/`

| Ficheiro SQL | Notebook | Descricao | Queries |
|-------------|----------|-----------|---------|
| `01_schema.sql` | `01_schema.ipynb` | Criacao da base de dados e tabela | - |
| `02_import_data.sql` | `02_import_data.ipynb` | Importacao do CSV (1470 registos) | - |
| `03_analise_exploratoria.sql` | `03_analise_exploratoria.ipynb` | Visao geral: "Quem somos" | 18 |
| `04_analise_genero.sql` | `04_analise_genero.ipynb` | Igualdade de genero | 18 |
| `05_analise_felicidade.sql` | `05_analise_felicidade.ipynb` | Satisfacao e felicidade | 19 |
| `06_analise_envelhecimento.sql` | `06_analise_envelhecimento.ipynb` | Idade e reforma | 17 |
| `07_analise_attrition.sql` | `07_analise_attrition.ipynb` | Perfil de quem sai | 21 |
| `08_analise_adicional.sql` | `08_analise_adicional.ipynb` | Questoes do grupo | 27 |

**Total**: 8 ficheiros SQL + 8 notebooks Jupyter, 129 queries SQL

## Documentacao

| Ficheiro | Descricao |
|----------|-----------|
| `INSIGHTS.md` | Resumo executivo - KPIs, conclusoes, alertas |
| `QUESTIONS.md` | Rastreabilidade completa - cada questao com query SQL, resultado e interpretacao |
| `PROGRESS.md` | Estado actual e checklist de analises |
| `CHANGELOG.md` | Historico de alteracoes do projeto |
| [`docs/setup-windows-ssms.md`](../../docs/setup-windows-ssms.md) | Tutorial para Windows + SSMS |
| [`docs/setup-macos-docker.md`](../../docs/setup-macos-docker.md) | Tutorial para macOS + Docker |

## Como Executar

### 1. Configurar credenciais

```bash
cp ../../.env.example ../../.env
# Editar .env com a password do SQL Server
```

### 2. Criar base de dados

```sql
-- Executar em ordem no SQL Server:
-- 1. sql/01_schema.sql
-- 2. sql/02_import_data.sql (requer CSV no caminho configurado)
```

### 3. Executar analises

Os notebooks Jupyter (`sql/*.ipynb`) executam as queries com resultados interactivos via JupySQL.

## Dicionario de Variaveis

### Variaveis de Satisfacao (Escala 1-4)
| Variavel | Descricao | Escala |
|----------|-----------|--------|
| EnvironmentSatisfaction | Satisfacao com o ambiente | 1=Low, 2=Medium, 3=High, 4=Very High |
| JobSatisfaction | Satisfacao com o trabalho | 1=Low, 2=Medium, 3=High, 4=Very High |
| RelationshipSatisfaction | Satisfacao com relacoes | 1=Low, 2=Medium, 3=High, 4=Very High |
| WorkLifeBalance | Equilibrio vida-trabalho | 1=Bad, 2=Good, 3=Better, 4=Best |
| JobInvolvement | Envolvimento no trabalho | 1=Low, 2=Medium, 3=High, 4=Very High |

### Variaveis Demograficas
| Variavel | Valores |
|----------|---------|
| Age | 18-60 (idade em anos) |
| Gender | Female, Male |
| MaritalStatus | Single, Married, Divorced |
| Education | 1=Below College, 2=College, 3=Bachelor, 4=Master, 5=Doctor |
| EducationField | Life Sciences, Medical, Marketing, Technical Degree, Human Resources, Other |

### Variaveis de Carreira
| Variavel | Descricao |
|----------|-----------|
| Department | Human Resources, Research & Development, Sales |
| JobRole | 9 cargos diferentes |
| JobLevel | 1-5 (nivel hierarquico) |
| YearsAtCompany | Anos na empresa |
| YearsInCurrentRole | Anos no cargo atual |
| YearsSinceLastPromotion | Anos desde ultima promocao |
| YearsWithCurrManager | Anos com o manager atual |
| TotalWorkingYears | Total de anos de experiencia |
| NumCompaniesWorked | Numero de empresas onde trabalhou |

### Variaveis Salariais
| Variavel | Descricao |
|----------|-----------|
| MonthlyIncome | Salario mensal |
| MonthlyRate | Taxa mensal (salario + beneficios, antes de impostos) |
| DailyRate | Taxa diaria |
| HourlyRate | Taxa horaria |
| PercentSalaryHike | % de aumento salarial |
| StockOptionLevel | 0=Nenhum, 1=Basico, 2=Medio, 3=Alto |

### Outras Variaveis
| Variavel | Valores |
|----------|---------|
| Attrition | Yes/No (saiu da empresa) |
| OverTime | Yes/No |
| BusinessTravel | Non-Travel, Travel_Rarely, Travel_Frequently |
| DistanceFromHome | 1-29 (unidade nao especificada, provavelmente milhas) |
| PerformanceRating | 3=Excellent, 4=Outstanding (so estes valores no dataset) |
| TrainingTimesLastYear | Numero de formacoes no ultimo ano |

### Variaveis Constantes (podem ser ignoradas)
| Variavel | Valor | Nota |
|----------|-------|------|
| EmployeeCount | Sempre 1 | Redundante |
| Over18 | Sempre "Y" | Redundante |
| StandardHours | Sempre 80 | Redundante |

## Notas Importantes

- **PerformanceRating**: So tem valores 3 e 4 no dataset (nunca 1 ou 2) - possivel vies
- **DistanceFromHome**: Unidade nao especificada (provavelmente milhas, contexto EUA/IBM)
- **Dados ficticios**: Dataset criado para fins educacionais, nao representa dados reais da IBM

---

*Programa AiDAPT - Cegid Academy 2025/2026*
