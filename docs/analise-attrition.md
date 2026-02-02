# Analise de Attrition — IBM HR Analytics

> Analise aprofundada da variavel Attrition do dataset IBM HR, com foco em relacoes causais,
> interaccoes entre variaveis, e perfis de risco multi-variavel.
>
> **Base de dados**: `Projeto1_IBM_HR`, tabela `Colaboradores` (1470 registos)
> **Complementa**: analises existentes em `sql/07_analise_attrition.sql` e `sql/08_analise_adicional.sql`

---

## 1. Introducao

### O que e Attrition em RH

Attrition (rotatividade voluntaria) refere-se a saida voluntaria de colaboradores de uma organizacao. Distingue-se de:
- **Layoffs/despedimentos**: iniciativa da empresa
- **Reformas**: saida natural por idade
- **Turnover total**: inclui todos os tipos de saida

No mundo real, o attrition mede-se atraves de:
- **HRIS** (Human Resources Information Systems): registo de motivo de saida
- **Exit interviews**: entrevistas de saida estruturadas
- **Payroll**: cessacao de processamento salarial

### Benchmarks de industria

| Referencia | Taxa |
|:---|---:|
| Taxa "saudavel" (industria geral) | 10-12% |
| Sector tecnologico | 13-15% |
| **IBM HR Dataset** | **16.1%** |
| Alerta elevado | >15% |
| Crise de retencao | >20% |

A taxa de 16.1% (237 de 1470) situa-se acima do limiar de alerta. Justifica investigacao aprofundada.

### Contexto do dataset

Este dataset e um **snapshot transversal** (cross-sectional): um unico momento no tempo com 1470 registos, dos quais 237 (16.1%) ja sairam e 1233 (83.9%) permanecem. **Nao e longitudinal** — nao sabemos quando cada pessoa saiu, nem podemos observar trajectoria ao longo do tempo. Esta limitacao e fundamental para interpretar os resultados.

---

## 2. Framework Causal

### Causas vs Correlacoes vs Consequencias

Com dados transversais, **nao podemos provar causalidade**. Podemos apenas identificar associacoes estatisticas. No entanto, com base na teoria de RH e senso comum, podemos classificar as variaveis em tres categorias:

| Categoria | Descricao | Exemplos no dataset |
|:---|:---|:---|
| **Causas provaveis** | Factores que plausivelmente *provocam* saida | OverTime, salario baixo, insatisfacao, estagnacao |
| **Correlacoes** | Associadas mas sem direccao causal clara | Idade, estado civil, educacao |
| **Consequencias/Artefactos** | Resultado do processo de saida ou do dataset | YearsAtCompany baixo (quem sai cedo tem poucos anos) |

### Classificacao das 35 variaveis

**Causas provaveis (accionaveis pela empresa)**:
- OverTime, MonthlyIncome, JobSatisfaction, EnvironmentSatisfaction
- WorkLifeBalance, JobInvolvement, StockOptionLevel
- YearsInCurrentRole (estagnacao), YearsSinceLastPromotion
- TrainingTimesLastYear, BusinessTravel

**Correlacoes (perfil demografico)**:
- Age, Gender, MaritalStatus, DistanceFromHome
- Education, EducationField, NumCompaniesWorked

**Confounders (variaveis que distorcem relacoes)**:
- JobLevel (explica grande parte da variacao salarial)
- JobRole (explica OverTime e salario)
- Department (explica EducationField)

**Artefactos/Constantes**:
- EmployeeCount (=1), StandardHours (=80), Over18 (=Y)
- EmployeeNumber (ID)

---

## 3. Panorama Geral

### Taxa global e perfil comparativo

|  | Leavers (Yes) | Stayers (No) |
|:---|---:|---:|
| **N** | 237 (16.1%) | 1233 (83.9%) |
| **Idade media** | 33 anos | 37 anos |
| **Salario medio** | $4,787 | $6,832 |
| **Tenure medio** | 5 anos | 7 anos |

### Top factores de risco (taxa de attrition)

| Factor | Taxa | vs Global (16.1%) |
|:---|---:|:---|
| OverTime = Yes | 30.5% | 1.9x |
| MonthlyIncome < $3k | 28.6% | 1.8x |
| Single | 25.5% | 1.6x |
| Idade 18-30 | 25.9% | 1.6x |
| Sales Representative | 39.8% | 2.5x |
| Travel_Frequently | 24.9% | 1.5x |
| JobSatisfaction = 1 | 22.8% | 1.4x |
| StockOptionLevel = 0 | 24.4% | 1.5x |

---

## 4. Analise de Interaccoes

A analise univariada (um factor de cada vez) subestima o risco real. Quando combinamos factores, os efeitos podem ser **aditivos** (somam-se) ou **multiplicativos** (amplificam-se mutuamente).

### 4.1: OverTime x Faixa Salarial — efeito multiplicativo?

**Pergunta**: O efeito do OverTime e o mesmo para quem ganha pouco e quem ganha bem?

```sql
SELECT CONCAT(OverTime, '_', CASE WHEN MonthlyIncome >= 5000 THEN 'HighSal' ELSE 'LowSal' END) AS Combo,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CONCAT(OverTime, '_', CASE WHEN MonthlyIncome >= 5000 THEN 'HighSal' ELSE 'LowSal' END)
```

|  | Salario < $5k | Salario >= $5k |
|:---|---:|---:|
| **Sem OverTime** | 13.8% (544) | 6.9% (510) |
| **Com OverTime** | **42.9%** (205) | 18.5% (211) |
| *Multiplicador OT* | *3.1x* | *2.7x* |

Com detalhes por faixa mais fina:

| OverTime | Faixa Salarial | N | Leavers | Taxa |
|:---|:---|---:|---:|---:|
| Yes | < $3k | 114 | 64 | **56.1%** |
| Yes | $3k-$5k | 91 | 24 | 26.4% |
| Yes | $5k-$10k | 126 | 27 | 21.4% |
| Yes | $10k+ | 85 | 12 | 14.1% |
| No | < $3k | 281 | 49 | 17.4% |
| No | $3k-$5k | 263 | 26 | 9.9% |
| No | $5k-$10k | 314 | 22 | 7.0% |
| No | $10k+ | 196 | 13 | 6.6% |

**Interpretacao**: O efeito e **super-aditivo**. OverTime sozinho = 30.5%, salario baixo sozinho = 28.6%. Se fosse aditivo, esperariamos ~45%. Mas OverTime + salario <$3k = **56.1%** — o dobro do OverTime isolado. Quem faz horas extra *e* ganha mal esta na pior posicao possivel: mais de metade saiu.

### 4.2: OverTime x BusinessTravel

**Pergunta**: A viagem frequente amplifica o efeito do OverTime?

```sql
SELECT CONCAT(OverTime, ' | ', BusinessTravel) AS OT_Travel,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * Leavers / Total AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CONCAT(OverTime, ' | ', BusinessTravel)
```

|  | Non-Travel | Travel_Rarely | Travel_Frequently |
|:---|---:|---:|---:|
| **Sem OT** | 4.3% (115) | 9.6% (748) | 17.3% (191) |
| **Com OT** | 20.0% (35) | 28.5% (295) | **41.9%** (86) |
| *Multiplicador OT* | *4.7x* | *3.0x* | *2.4x* |

**Interpretacao**: OverTime + Travel_Frequently = **41.9%**, quase 3x a taxa global. A viagem frequente sozinha ja e um factor (24.9%), e o OverTime amplifica-o. Nota: o grupo Non-Travel+OT tem apenas 35 pessoas (amostra pequena).

### 4.3: Triplo — Jovem + Solteiro + Salario baixo

**Pergunta**: Qual a taxa do perfil "classico" de alto risco?

```sql
-- Perfil: idade <= 30, solteiro, salario < $3000
SELECT COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * Leavers / Total AS DECIMAL(5,1)) AS Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
WHERE Age <= 30 AND MaritalStatus = 'Single' AND MonthlyIncome < 3000
```

| Perfil | N | Leavers | Taxa |
|:---|---:|---:|---:|
| Jovem + Solteiro + Sal < $3k | 82 | 41 | **50.0%** |
| Todos os outros | 1388 | 196 | 14.1% |

**Multiplicador**: 3.5x a taxa global. Metade deste grupo saiu.

### 4.4: Quadruplo — acrescentar OverTime

| Perfil | N | Leavers | Taxa |
|:---|---:|---:|---:|
| Jovem + Solteiro + OT | 44 | 29 | **65.9%** |
| Jovem + Solteiro + Sal < $3k + OT | 28 | 21 | **75.0%** |

**Interpretacao**: Com 4 factores combinados, 3 em cada 4 pessoas sairam. Este e o perfil de risco mais extremo identificavel no dataset.

---

## 5. Padroes Temporais

### 5.1: Tenure — a "zona de perigo"

**Pergunta**: Em que fase da permanencia o risco de saida e maior?

```sql
SELECT CASE WHEN YearsAtCompany <= 1 THEN '0-1 anos'
            WHEN YearsAtCompany <= 3 THEN '2-3 anos'
            WHEN YearsAtCompany <= 5 THEN '4-5 anos'
            WHEN YearsAtCompany <= 10 THEN '6-10 anos'
            WHEN YearsAtCompany <= 20 THEN '11-20 anos'
            ELSE '21+ anos' END AS Faixa_Tenure,
       COUNT(*) AS Total, Leavers, Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY [faixa]
```

| Faixa Tenure | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **0-1 anos** | 215 | 75 | **34.9%** |
| **2-3 anos** | 255 | 47 | **18.4%** |
| 4-5 anos | 306 | 40 | 13.1% |
| 6-10 anos | 448 | 55 | 12.3% |
| 11-20 anos | 180 | 12 | 6.7% |
| 21+ anos | 66 | 8 | 12.1% |

**Interpretacao**: A **zona de perigo** e clara: os primeiros 3 anos. Um terco dos colaboradores com 0-1 anos saiu. Apos 5 anos, o risco estabiliza abaixo da media. Os 21+ anos com 12.1% representam provavelmente reformas pre-antecipadas (amostra pequena, 66 pessoas).

**Implicacao pratica**: Os programas de onboarding e retencao devem focar-se intensamente nos primeiros 3 anos.

### 5.2: Tempo no cargo actual — estagnacao

```sql
SELECT [faixa YearsInCurrentRole], COUNT(*), Leavers, Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY [faixa]
```

| Faixa (YearsInCurrentRole) | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **0-1 anos** | 301 | 84 | **27.9%** |
| 2-3 anos | 507 | 84 | 16.6% |
| 4-5 anos | 140 | 16 | 11.4% |
| 6-7 anos | 259 | 33 | 12.7% |
| 8+ anos | 263 | 20 | **7.6%** |

**Interpretacao**: O padrao e inverso ao esperado — quem esta ha pouco tempo no cargo sai mais. Isto **nao** significa que a estagnacao e boa. Significa que quem e novo no cargo inclui muitos colaboradores recentes na empresa (confounding com tenure). Quem esta ha 8+ anos no mesmo cargo e um "sobrevivente" — os insatisfeitos ja sairam antes.

### 5.3: Tempo com o manager actual

| Faixa (YearsWithCurrManager) | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **0-1 anos** | 339 | 96 | **28.3%** |
| 2-3 anos | 486 | 69 | 14.2% |
| 4-5 anos | 129 | 15 | 11.6% |
| 6-7 anos | 245 | 35 | 14.3% |
| 8+ anos | 271 | 22 | 8.1% |

**Interpretacao**: Padrao semelhante — os primeiros 0-1 anos com um manager sao criticos (28.3%). Isto pode reflectir: (a) manager novo = relacao nao estabelecida, ou (b) colaborador novo = ainda nao integrado. Apos estabelecer relacao (4-5+ anos), o risco cai significativamente.

---

## 6. Compensacao e Retencao

### 6.1: DailyRate, HourlyRate, MonthlyRate — sao preditivos?

```sql
SELECT Attrition,
       AVG(DailyRate) AS Avg_DailyRate,
       AVG(HourlyRate) AS Avg_HourlyRate,
       AVG(MonthlyRate) AS Avg_MonthlyRate
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY Attrition
```

| Metrica | Leavers | Stayers | Diferenca |
|:---|---:|---:|:---|
| DailyRate | 750 | 812 | -7.6% |
| HourlyRate | 65 | 65 | 0% |
| MonthlyRate | 14,559 | 14,265 | +2.1% |

**Interpretacao**: Estas tres variaveis sao **praticamente iguais** entre quem sai e quem fica. O HourlyRate e identico. O MonthlyRate e ate ligeiramente *superior* nos leavers. **Conclusao**: DailyRate, HourlyRate e MonthlyRate **nao sao preditivos** de attrition. Apenas o **MonthlyIncome** (salario mensal real) diferencia os grupos.

> **Nota tecnica**: O significado exacto de DailyRate/HourlyRate/MonthlyRate no dataset IBM nao e documentado. Provavelmente representam taxas de referencia ou custos internos, nao o salario efectivo recebido.

### 6.2: StockOptionLevel como retencao

```sql
SELECT StockOptionLevel, COUNT(*) AS Total, Leavers, Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY StockOptionLevel
```

| StockOptionLevel | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **0 (sem opcoes)** | 631 | 154 | **24.4%** |
| 1 | 596 | 56 | 9.4% |
| 2 | 158 | 12 | **7.6%** |
| 3 | 85 | 15 | 17.6% |

**Interpretacao**: O efeito e claro e nao-linear:
- **Nivel 0 → 1**: reducao drastica (24.4% → 9.4%, multiplicador 0.39x)
- **Nivel 1 → 2**: reducao adicional (9.4% → 7.6%)
- **Nivel 3**: subida para 17.6% — possivel artefacto (N=85 pequeno) ou perfil especifico de executivos com opcoes elevadas mas outras insatisfacoes

**Recomendacao**: Atribuir pelo menos nivel 1 de stock options a todos os colaboradores e a medida com melhor custo-beneficio aparente para retencao.

### 6.3: PercentSalaryHike — os aumentos previnem saidas?

| Faixa de Aumento | N | Leavers | Taxa |
|:---|---:|---:|---:|
| 11-13% | 617 | 108 | 17.5% |
| 14-17% | 462 | 70 | 15.2% |
| 18-25% | 391 | 59 | 15.1% |

**Interpretacao**: O efeito e **fraco**. A diferenca entre o grupo com menor aumento (17.5%) e maior aumento (15.1%) e de apenas 2.4 pontos percentuais. Aumentos salariais isolados **nao sao suficientes** para reter colaboradores — os factores estruturais (OverTime, funcao, stock options) pesam muito mais.

---

## 7. Desenvolvimento e Carreira

### 7.1: Training vs Attrition

```sql
SELECT TrainingTimesLastYear, COUNT(*) AS Total, Leavers, Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY TrainingTimesLastYear
```

| Formacoes (ultimo ano) | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **0** | 54 | 15 | **27.8%** |
| 1 | 71 | 9 | 12.7% |
| 2 | 547 | 98 | 17.9% |
| 3 | 491 | 69 | 14.1% |
| 4 | 123 | 26 | 21.1% |
| 5 | 119 | 14 | 11.8% |
| 6 | 65 | 6 | **9.2%** |

**Interpretacao**: Zero formacoes = 27.8% (1.7x a media). Tendencia geral decrescente com mais formacao, mas nao e monotona (o valor 4 tem pico de 21.1%). O investimento em formacao parece ter efeito protector, especialmente a diferenca entre 0 e 1+ formacoes.

### 7.2: Estagnacao — tempo no cargo + tempo sem promocao

```sql
SELECT CONCAT(
  CASE WHEN YearsInCurrentRole >= 5 THEN 'LongRole' ELSE 'ShortRole' END, '_',
  CASE WHEN YearsSinceLastPromotion >= 5 THEN 'NoPromo' ELSE 'RecentPromo' END
) AS Estagnacao, COUNT(*), Leavers, Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY [combo]
```

| Perfil | N | Leavers | Taxa | Interpretacao |
|:---|---:|---:|---:|:---|
| ShortRole + RecentPromo | 882 | 176 | 20.0% | Novos — alta rotatividade natural |
| ShortRole + NoPromo | 30 | 7 | 23.3% | Novos sem promocao — amostra pequena |
| LongRole + NoPromo | 230 | 30 | 13.0% | "Estagnados" — taxa abaixo da media |
| **LongRole + RecentPromo** | 328 | 24 | **7.3%** | **Os mais retidos** |

**Interpretacao**: O resultado contra-intuitivo ("estagnados" com 13.0% < novos com 20.0%) explica-se pelo **survivorship bias**: quem ficou 5+ anos no mesmo cargo *sem* promocao e ja passou o periodo de maior risco. Os insatisfeitos com estagnacao ja sairam antes dos 5 anos.

A combinacao mais protectora e **cargo longo + promocao recente** (7.3%) — pessoas com experiencia que sentiram progressao.

### 7.3: YearsSinceLastPromotion

| Tempo sem promocao | N | Leavers | Taxa |
|:---|---:|---:|---:|
| 0 anos (acabou de ser promovido) | 581 | 110 | 18.9% |
| 1-2 anos | 516 | 76 | 14.7% |
| 3-5 anos | 158 | 16 | **10.1%** |
| 6-10 anos | 149 | 27 | 18.1% |
| 11+ anos | 66 | 8 | 12.1% |

**Interpretacao**: O valor 0 anos tem 18.9% — surpreendentemente alto. Isto sugere que **algumas promocoes sao "demasiado tarde"** — a pessoa ja decidiu sair antes da promocao, ou a promocao foi uma tentativa falhada de retencao. A faixa 3-5 anos (10.1%) sao os sobreviventes estaveis.

### 7.4: EducationField vs Attrition

| Area de Formacao | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **Human Resources** | 27 | 7 | **25.9%** |
| **Technical Degree** | 132 | 32 | **24.2%** |
| **Marketing** | 159 | 35 | **22.0%** |
| Life Sciences | 606 | 89 | 14.7% |
| Medical | 464 | 63 | 13.6% |
| Other | 82 | 11 | 13.4% |

### 7.5: EducationField x Department (mismatch)

```sql
SELECT CONCAT(EducationField, ' | ', Department) AS Combo,
       COUNT(*), Leavers, Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CONCAT(EducationField, ' | ', Department)
HAVING COUNT(*) >= 50
```

| Combinacao | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **Marketing \| Sales** | 159 | 35 | **22.0%** |
| **Technical Degree \| R&D** | 94 | 20 | **21.3%** |
| Life Sciences \| Sales | 150 | 29 | 19.3% |
| Medical \| Sales | 88 | 14 | 15.9% |
| Life Sciences \| R&D | 440 | 59 | 13.4% |
| Medical \| R&D | 363 | 47 | 12.9% |
| Other \| R&D | 64 | 7 | 10.9% |

Caso especifico de mismatch: **Technical Degree em Sales** = 29.4% (N=34) — pessoas com formacao tecnica colocadas em vendas, possivel desalinhamento de funcao.

### 7.6: JobInvolvement

| JobInvolvement | N | Leavers | Taxa | Descricao |
|:---|---:|---:|---:|:---|
| **1 (Low)** | 83 | 28 | **33.7%** | 2.1x a media |
| 2 (Medium) | 375 | 71 | 18.9% | |
| 3 (High) | 868 | 125 | 14.4% | |
| **4 (Very High)** | 144 | 13 | **9.0%** | Metade da media |

**Interpretacao**: Relacao monotonica quase perfeita. JobInvolvement 1 → 4 reduz a taxa de 33.7% para 9.0% (multiplicador 3.7x). Este e um dos factores com gradiente mais claro no dataset.

### 7.7: EnvironmentSatisfaction

| EnvironmentSatisfaction | N | Leavers | Taxa |
|:---|---:|---:|---:|
| **1 (Low)** | 284 | 72 | **25.4%** |
| 2 (Medium) | 287 | 43 | 15.0% |
| 3 (High) | 453 | 62 | 13.7% |
| 4 (Very High) | 446 | 60 | 13.5% |

**Interpretacao**: Grande salto entre nivel 1 e 2 (25.4% → 15.0%). Apos nivel 2, o efeito estabiliza. O factor critico e estar no nivel mais baixo.

### 7.8: RelationshipSatisfaction

| RelationshipSatisfaction | N | Leavers | Taxa |
|:---|---:|---:|---:|
| 1 (Low) | 276 | 57 | 20.7% |
| 2 (Medium) | 303 | 45 | 14.9% |
| 3 (High) | 459 | 71 | 15.5% |
| 4 (Very High) | 432 | 64 | 14.8% |

**Interpretacao**: Efeito mais fraco que os outros indicadores de satisfacao. Nivel 1 destaca-se (20.7%), mas niveis 2-4 sao praticamente iguais (~15%). A satisfacao com relacoes de trabalho e menos preditiva que a satisfacao com o ambiente ou o trabalho em si.

---

## 8. Confounders — controlando variaveis

### 8.1: Salario controlado por JobLevel

O salario bruto esta fortemente correlacionado com o JobLevel. Sera que o efeito do "salario baixo" desaparece quando controlamos pelo nivel?

**Medias salariais por nivel**:

| JobLevel | Salario medio | N |
|:---|---:|---:|
| 1 | $2,787 | 543 |
| 2 | $5,502 | 534 |
| 3 | $9,817 | 218 |
| 4 | $15,504 | 106 |
| 5 | $19,192 | 69 |

**Resultado global controlado**:

| Posicao vs media do nivel | N | Leavers | Taxa |
|:---|---:|---:|---:|
| Abaixo da media | 805 | 149 | **18.5%** |
| Acima da media | 665 | 88 | **13.2%** |

**Detalhe por nivel**:

| JobLevel | Abaixo (Taxa) | Acima (Taxa) | Diferenca |
|:---|---:|---:|:---|
| **1** | 31.6% (316) | 18.9% (227) | **12.7 pp** |
| 2 | 9.1% (308) | 10.6% (226) | -1.5 pp |
| 3 | 14.6% (103) | 14.8% (115) | -0.2 pp |
| 4 | 10.9% (46) | 0.0% (60) | **10.9 pp** |
| 5 | 3.1% (32) | 10.8% (37) | -7.7 pp |

**Interpretacao**:
- **No nivel 1** (entry-level), o salario importa muito: ganhar abaixo da media = 31.6% vs acima = 18.9%. E aqui que a diferenca salarial mais pesa.
- **Nos niveis 2-3**, o salario relativo **nao importa** — as taxas sao praticamente iguais.
- **No nivel 4**, ninguem acima da media saiu (N=60, possivel artefacto de amostra).
- **No nivel 5**, os que ganham acima da media saem mais (10.8% vs 3.1%) — possivel efeito de "oferta externa" para executivos bem pagos.
- **Conclusao**: O efeito "salario baixo" e sobretudo um efeito de **ser entry-level mal pago**, nao um efeito universal.

### 8.2: OverTime controlado por JobRole

O OverTime tem o mesmo efeito em todas as funcoes, ou certas funcoes sao mais vulneraveis?

```sql
SELECT CONCAT(JobRole, '_', OverTime) AS Grp, COUNT(*) AS T,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS L,
       CAST(100.0 * L / T AS DECIMAL(5,1)) AS Tx
FROM Projeto1_IBM_HR.dbo.Colaboradores
WHERE JobRole IN ('Sales Representative', 'Laboratory Technician', 'Research Scientist', 'Research Director', 'Human Resources')
GROUP BY CONCAT(JobRole, '_', OverTime)
```

| JobRole | Sem OT | Com OT | Multiplicador |
|:---|---:|---:|---:|
| **Sales Representative** | 28.8% (59) | **66.7%** (24) | 2.3x |
| **Laboratory Technician** | 15.7% (197) | **50.0%** (62) | 3.2x |
| **Research Scientist** | 7.2% (195) | **34.0%** (97) | 4.7x |
| Human Resources | 17.9% (39) | 38.5% (13) | 2.2x |
| Research Director | 1.8% (57) | 4.3% (23) | 2.4x |

**Interpretacao**:
- O OverTime amplifica o attrition em **todas** as funcoes, mas com magnitudes diferentes.
- **Research Scientist** tem o maior multiplicador (4.7x) — de uma taxa base muito baixa (7.2%) salta para 34.0%.
- **Sales Representative com OT** = **66.7%** — dois tercos sairam. E a combinacao mais toxica.
- **Research Director** e quase imune ao OverTime (1.8% → 4.3%) — provavelmente por compensacao e senioridade.

### 8.3: NumCompaniesWorked — job hoppers

| Empresas anteriores | N | Leavers | Taxa |
|:---|---:|---:|---:|
| 0 (primeira empresa) | 197 | 23 | 11.7% |
| 1 | 521 | 98 | **18.8%** |
| 2-3 | 305 | 32 | **10.5%** |
| 4-5 | 202 | 33 | 16.3% |
| 6+ | 245 | 51 | **20.8%** |

**Interpretacao**: O padrao nao e linear. O grupo "1 empresa anterior" (18.8%) e os "6+" (20.8%) sao os mais propensos a sair. A explicacao provavel:
- **1 empresa anterior**: Mudaram uma vez, descobriram que podem mudar — "porta giratoria" activada
- **6+**: Job hoppers confirmados — o padrao de comportamento esta estabelecido
- **0 (primeira empresa)**: Ainda nao sabem o que existe la fora — mais leais por inercia
- **2-3**: O sweet spot — experiencia suficiente para escolher bem, sem padrao de saltar

---

## 9. Perfis de Risco Multi-variavel

### 9.1: Score de risco expandido (10 factores)

Construimos um score de 0 a 10 pontos, atribuindo 1 ponto por cada factor de risco presente:

| Factor | Criterio (1 ponto se...) |
|:---|:---|
| OverTime | = Yes |
| Salario baixo | MonthlyIncome < $3,000 |
| Insatisfacao trabalho | JobSatisfaction = 1 |
| Novato | YearsAtCompany <= 1 |
| Solteiro | MaritalStatus = Single |
| Jovem | Age <= 30 |
| Sem stock options | StockOptionLevel = 0 |
| Ambiente mau | EnvironmentSatisfaction = 1 |
| Mau work-life balance | WorkLifeBalance = 1 |
| Baixo envolvimento | JobInvolvement <= 2 |

```sql
SELECT (CASE WHEN OverTime='Yes' THEN 1 ELSE 0 END)
     + (CASE WHEN MonthlyIncome < 3000 THEN 1 ELSE 0 END)
     + (CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 0 END)
     + (CASE WHEN YearsAtCompany <= 1 THEN 1 ELSE 0 END)
     + (CASE WHEN MaritalStatus = 'Single' THEN 1 ELSE 0 END)
     + (CASE WHEN Age <= 30 THEN 1 ELSE 0 END)
     + (CASE WHEN StockOptionLevel = 0 THEN 1 ELSE 0 END)
     + (CASE WHEN EnvironmentSatisfaction = 1 THEN 1 ELSE 0 END)
     + (CASE WHEN WorkLifeBalance = 1 THEN 1 ELSE 0 END)
     + (CASE WHEN JobInvolvement <= 2 THEN 1 ELSE 0 END) AS RiskScore
-- ...
```

### Distribuicao por score individual

| Score | N | Leavers | Taxa | Classificacao |
|:---|---:|---:|---:|:---|
| 0 | 140 | 7 | 5.0% | Baixo |
| 1 | 312 | 13 | 4.2% | Baixo |
| 2 | 362 | 28 | 7.7% | Medio |
| 3 | 295 | 40 | 13.6% | Medio |
| 4 | 191 | 55 | **28.8%** | Alto |
| 5 | 108 | 48 | **44.4%** | Alto |
| 6 | 40 | 25 | **62.5%** | Critico |
| 7+ | 22 | 21 | **95.5%** | Critico |

### Distribuicao por faixa

| Faixa de Risco | Score | N | Leavers | Taxa |
|:---|:---|---:|---:|---:|
| Baixo | 0-1 | 452 | 20 | **4.4%** |
| Medio | 2-3 | 657 | 68 | **10.4%** |
| Alto | 4-5 | 299 | 103 | **34.4%** |
| Critico | 6+ | 62 | 46 | **74.2%** |

**Interpretacao**: O score tem uma **capacidade discriminatoria excepcional**:
- Score 0-1: apenas 4.4% sairam — estes colaboradores sao os mais seguros
- Score 7+: 95.5% sairam — quase certo que vao sair
- O salto critico acontece no score 4 (28.8%) — a partir daqui o risco e material

### 9.2: Colaboradores actuais por faixa de risco

| Faixa de Risco | Score | Colaboradores Actuais | Accao sugerida |
|:---|:---|---:|:---|
| Baixo | 0-1 | 432 (35.0%) | Manter — sem accao especifica |
| Medio | 2-3 | 589 (47.8%) | Monitorizar — accoes preventivas gerais |
| **Alto** | 4-5 | **196 (15.9%)** | **Intervir — planos individuais de retencao** |
| **Critico** | 6+ | **16 (1.3%)** | **Urgente — retencao imediata ou gestao de saida** |

**Total em risco (score 4+)**: 212 colaboradores actuais (17.2% do efectivo).

Estes 212 colaboradores devem ser o foco prioritario de qualquer programa de retencao. Os 16 criticos necessitam de atencao imediata — com base nos dados historicos, mais de 70% deste perfil saiu.

---

## 10. Sintese e Conclusoes

### Hierarquia de factores (do mais ao menos impactante)

| Rank | Factor | Taxa isolada | Tipo | Accionavel? |
|:---|:---|---:|:---|:---|
| 1 | **OverTime = Yes** | 30.5% | Causa provavel | Sim |
| 2 | **MonthlyIncome < $3k** | 28.6% | Causa provavel | Sim |
| 3 | **JobInvolvement = 1** | 33.7% | Causa provavel | Parcialmente |
| 4 | **StockOptionLevel = 0** | 24.4% | Causa provavel | Sim |
| 5 | **WorkLifeBalance = 1** | 31.3% | Causa provavel | Parcialmente |
| 6 | **EnvironmentSatisfaction = 1** | 25.4% | Causa provavel | Sim |
| 7 | **YearsAtCompany <= 1** | 34.9% | Correlacao temporal | Indirectamente |
| 8 | **Single** | 25.5% | Correlacao demografica | Nao |
| 9 | **Age <= 30** | 25.9% | Correlacao demografica | Nao |
| 10 | **JobSatisfaction = 1** | 22.8% | Causa provavel | Parcialmente |

### O que os dados dizem

1. **OverTime e o factor n.1**: Consistente em todas as funcoes, com multiplicadores de 2.3x a 4.7x. E o factor mais accionavel — reduzir horas extra deveria ser a prioridade.

2. **As interaccoes sao super-aditivas**: OverTime + salario baixo = 56.1% (nao 45% aditivo). O risco real esta nas *combinacoes* de factores, nao nos factores isolados.

3. **Os primeiros 3 anos sao criticos**: Um terco dos colaboradores com 0-1 anos saiu. Programas de onboarding e mentoring sao essenciais.

4. **Stock options nivel 1 e a medida com melhor custo-beneficio**: Reduz a taxa de 24.4% para 9.4% — um investimento com retorno quase garantido.

5. **O salario importa sobretudo no nivel 1 (entry-level)**: Controlando por JobLevel, o efeito do salario desaparece nos niveis 2-5. O problema e pagar mal a quem comeca.

6. **O score de risco funciona**: De 4.4% (score 0-1) a 95.5% (score 7+), o modelo simples de 10 factores discrimina eficazmente.

### O que os dados NAO dizem

1. **Nao sabemos a causalidade**: Dados transversais mostram associacao, nao causa. Seria necessario acompanhar colaboradores ao longo do tempo.

2. **Nao sabemos se o attrition e voluntario**: O dataset nao distingue demissao voluntaria de despedimento.

3. **Nao sabemos o momento da saida**: Sem datas, nao podemos calcular taxas anuais reais nem tendencias temporais.

4. **Survivorship bias e real**: Os "estagnados" que ficaram 8+ anos no mesmo cargo parecem satisfeitos — mas os insatisfeitos ja sairam antes.

5. **N=1470 limita subgrupos**: Combinacoes de 4-5 variaveis resultam em grupos pequenos (N<30) onde as taxas sao instáveis.

### Recomendacoes prioritarias

1. **Reduzir OverTime sistematico** — especialmente em Sales Representatives e Laboratory Technicians
2. **Atribuir stock options nivel 1** a todos os colaboradores sem opcoes (631 pessoas)
3. **Programa de retencao 0-3 anos** — onboarding estruturado, mentoring, check-ins trimestrais
4. **Revisao salarial no nivel 1** — fechar o gap entre abaixo/acima da media (31.6% vs 18.9%)
5. **Monitorizar os 212 colaboradores actuais com score 4+** — planos individuais de retencao
6. **Intervencao urgente nos 16 colaboradores com score 6+** — risco historico de 74.2%

---

## Apendice: Todas as Queries SQL

As queries abaixo foram executadas na base de dados `Projeto1_IBM_HR`, tabela `Colaboradores`.

### A.1: DailyRate/HourlyRate/MonthlyRate — comparacao leavers vs stayers

```sql
SELECT Attrition,
       COUNT(*) AS N,
       AVG(DailyRate) AS Avg_DailyRate,
       AVG(HourlyRate) AS Avg_HourlyRate,
       AVG(MonthlyRate) AS Avg_MonthlyRate
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY Attrition;
```

### A.2: StockOptionLevel vs Attrition

```sql
SELECT StockOptionLevel,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY StockOptionLevel;
```

### A.3: PercentSalaryHike vs Attrition

```sql
SELECT CASE WHEN PercentSalaryHike <= 13 THEN '11-13%'
            WHEN PercentSalaryHike <= 17 THEN '14-17%'
            ELSE '18-25%' END AS Faixa_Hike,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CASE WHEN PercentSalaryHike <= 13 THEN '11-13%'
              WHEN PercentSalaryHike <= 17 THEN '14-17%'
              ELSE '18-25%' END;
```

### A.4: TrainingTimesLastYear vs Attrition

```sql
SELECT TrainingTimesLastYear,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY TrainingTimesLastYear;
```

### A.5: EducationField vs Attrition

```sql
SELECT EducationField,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY EducationField;
```

### A.6: JobInvolvement vs Attrition

```sql
SELECT JobInvolvement,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY JobInvolvement;
```

### A.7: EnvironmentSatisfaction vs Attrition

```sql
SELECT EnvironmentSatisfaction,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY EnvironmentSatisfaction;
```

### A.8: RelationshipSatisfaction vs Attrition

```sql
SELECT RelationshipSatisfaction,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY RelationshipSatisfaction;
```

### A.9: YearsAtCompany — zona de perigo

```sql
SELECT CASE WHEN YearsAtCompany <= 1 THEN '0-1 anos'
            WHEN YearsAtCompany <= 3 THEN '2-3 anos'
            WHEN YearsAtCompany <= 5 THEN '4-5 anos'
            WHEN YearsAtCompany <= 10 THEN '6-10 anos'
            WHEN YearsAtCompany <= 20 THEN '11-20 anos'
            ELSE '21+ anos' END AS Faixa_Tenure,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CASE WHEN YearsAtCompany <= 1 THEN '0-1 anos'
              WHEN YearsAtCompany <= 3 THEN '2-3 anos'
              WHEN YearsAtCompany <= 5 THEN '4-5 anos'
              WHEN YearsAtCompany <= 10 THEN '6-10 anos'
              WHEN YearsAtCompany <= 20 THEN '11-20 anos'
              ELSE '21+ anos' END;
```

### A.10: YearsInCurrentRole agrupado

```sql
SELECT CASE WHEN YearsInCurrentRole <= 1 THEN '0-1 anos'
            WHEN YearsInCurrentRole <= 3 THEN '2-3 anos'
            WHEN YearsInCurrentRole <= 5 THEN '4-5 anos'
            WHEN YearsInCurrentRole <= 7 THEN '6-7 anos'
            ELSE '8+ anos' END AS Faixa_Role,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CASE WHEN YearsInCurrentRole <= 1 THEN '0-1 anos'
              WHEN YearsInCurrentRole <= 3 THEN '2-3 anos'
              WHEN YearsInCurrentRole <= 5 THEN '4-5 anos'
              WHEN YearsInCurrentRole <= 7 THEN '6-7 anos'
              ELSE '8+ anos' END;
```

### A.11: YearsWithCurrManager agrupado

```sql
SELECT CASE WHEN YearsWithCurrManager <= 1 THEN '0-1 anos'
            WHEN YearsWithCurrManager <= 3 THEN '2-3 anos'
            WHEN YearsWithCurrManager <= 5 THEN '4-5 anos'
            WHEN YearsWithCurrManager <= 7 THEN '6-7 anos'
            ELSE '8+ anos' END AS Faixa_Manager,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CASE WHEN YearsWithCurrManager <= 1 THEN '0-1 anos'
              WHEN YearsWithCurrManager <= 3 THEN '2-3 anos'
              WHEN YearsWithCurrManager <= 5 THEN '4-5 anos'
              WHEN YearsWithCurrManager <= 7 THEN '6-7 anos'
              ELSE '8+ anos' END;
```

### A.12: OverTime x Faixa Salarial (crosstab detalhado)

```sql
SELECT OverTime,
       CASE WHEN MonthlyIncome < 3000 THEN '< $3k'
            WHEN MonthlyIncome < 5000 THEN '$3k-$5k'
            WHEN MonthlyIncome < 10000 THEN '$5k-$10k'
            ELSE '$10k+' END AS Faixa_Sal,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY OverTime,
         CASE WHEN MonthlyIncome < 3000 THEN '< $3k'
              WHEN MonthlyIncome < 5000 THEN '$3k-$5k'
              WHEN MonthlyIncome < 10000 THEN '$5k-$10k'
              ELSE '$10k+' END;
```

### A.13: OverTime x BusinessTravel

```sql
SELECT OverTime, BusinessTravel,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY OverTime, BusinessTravel;
```

### A.14: Perfil triplo — Jovem + Solteiro + Salario baixo

```sql
SELECT 'Jovem+Solteiro+SalBaixo' AS Perfil,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
WHERE Age <= 30 AND MaritalStatus = 'Single' AND MonthlyIncome < 3000
UNION ALL
SELECT 'Outros',
       COUNT(*),
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1))
FROM Projeto1_IBM_HR.dbo.Colaboradores
WHERE NOT (Age <= 30 AND MaritalStatus = 'Single' AND MonthlyIncome < 3000);
```

### A.15: Teste aditividade — OverTime x Salary (4 combinacoes)

```sql
SELECT CONCAT(OverTime, '_', CASE WHEN MonthlyIncome >= 5000 THEN 'HighSal' ELSE 'LowSal' END) AS Combo,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CONCAT(OverTime, '_', CASE WHEN MonthlyIncome >= 5000 THEN 'HighSal' ELSE 'LowSal' END);
```

### A.16: Media salarial por JobLevel

```sql
SELECT JobLevel,
       AVG(CAST(MonthlyIncome AS FLOAT)) AS AvgIncome,
       COUNT(*) AS N
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY JobLevel;
```

### A.17: Salario controlado por JobLevel — abaixo vs acima da media

```sql
-- Usando medias calculadas: JL1=2787, JL2=5502, JL3=9817, JL4=15504, JL5=19192
SELECT CASE WHEN (JobLevel=1 AND MonthlyIncome<2787)
              OR (JobLevel=2 AND MonthlyIncome<5502)
              OR (JobLevel=3 AND MonthlyIncome<9817)
              OR (JobLevel=4 AND MonthlyIncome<15504)
              OR (JobLevel=5 AND MonthlyIncome<19192) THEN 'Abaixo_Media_Nivel'
            ELSE 'Acima_Media_Nivel' END AS SalPos,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CASE WHEN (JobLevel=1 AND MonthlyIncome<2787)
                OR (JobLevel=2 AND MonthlyIncome<5502)
                OR (JobLevel=3 AND MonthlyIncome<9817)
                OR (JobLevel=4 AND MonthlyIncome<15504)
                OR (JobLevel=5 AND MonthlyIncome<19192) THEN 'Abaixo_Media_Nivel'
              ELSE 'Acima_Media_Nivel' END;
```

### A.18: OverTime controlado por JobRole

```sql
-- Executado individualmente por role (Sales Representative, Laboratory Technician,
-- Research Scientist, Research Director, Human Resources)
SELECT CONCAT(JobRole, '_', OverTime) AS Grp,
       COUNT(*) AS T,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS L,
       CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,1)) AS Tx
FROM Projeto1_IBM_HR.dbo.Colaboradores
WHERE JobRole = '<ROLE_NAME>'
GROUP BY CONCAT(JobRole, '_', OverTime);
```

### A.19: NumCompaniesWorked agrupado

```sql
SELECT CASE WHEN NumCompaniesWorked = 0 THEN '0 (primeira)'
            WHEN NumCompaniesWorked = 1 THEN '1'
            WHEN NumCompaniesWorked <= 3 THEN '2-3'
            WHEN NumCompaniesWorked <= 5 THEN '4-5'
            ELSE '6+' END AS Companies,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CASE WHEN NumCompaniesWorked = 0 THEN '0 (primeira)'
              WHEN NumCompaniesWorked = 1 THEN '1'
              WHEN NumCompaniesWorked <= 3 THEN '2-3'
              WHEN NumCompaniesWorked <= 5 THEN '4-5'
              ELSE '6+' END;
```

### A.20: Estagnacao — YearsInCurrentRole + YearsSinceLastPromotion

```sql
SELECT CONCAT(
    CASE WHEN YearsInCurrentRole >= 5 THEN 'LongRole' ELSE 'ShortRole' END, '_',
    CASE WHEN YearsSinceLastPromotion >= 5 THEN 'NoPromo' ELSE 'RecentPromo' END
  ) AS Estagnacao,
  COUNT(*) AS Total,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Leavers,
  CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CONCAT(
    CASE WHEN YearsInCurrentRole >= 5 THEN 'LongRole' ELSE 'ShortRole' END, '_',
    CASE WHEN YearsSinceLastPromotion >= 5 THEN 'NoPromo' ELSE 'RecentPromo' END);
```

### A.21: EducationField x Department

```sql
SELECT CONCAT(EducationField, ' | ', Department) AS Combo,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY CONCAT(EducationField, ' | ', Department)
HAVING COUNT(*) >= 50;
```

### A.22: Score de risco expandido (10 factores) — distribuicao por faixas

```sql
SELECT CASE WHEN rs <= 1 THEN 'Baixo (0-1)'
            WHEN rs <= 3 THEN 'Medio (2-3)'
            WHEN rs <= 5 THEN 'Alto (4-5)'
            ELSE 'Critico (6+)' END AS Faixa,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM (
  SELECT Attrition,
    (CASE WHEN OverTime='Yes' THEN 1 ELSE 0 END)
    + (CASE WHEN MonthlyIncome < 3000 THEN 1 ELSE 0 END)
    + (CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN YearsAtCompany <= 1 THEN 1 ELSE 0 END)
    + (CASE WHEN MaritalStatus = 'Single' THEN 1 ELSE 0 END)
    + (CASE WHEN Age <= 30 THEN 1 ELSE 0 END)
    + (CASE WHEN StockOptionLevel = 0 THEN 1 ELSE 0 END)
    + (CASE WHEN EnvironmentSatisfaction = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN WorkLifeBalance = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN JobInvolvement <= 2 THEN 1 ELSE 0 END) AS rs
  FROM Projeto1_IBM_HR.dbo.Colaboradores
) scored
GROUP BY CASE WHEN rs <= 1 THEN 'Baixo (0-1)'
              WHEN rs <= 3 THEN 'Medio (2-3)'
              WHEN rs <= 5 THEN 'Alto (4-5)'
              ELSE 'Critico (6+)' END;
```

### A.23: Colaboradores actuais por faixa de risco

```sql
-- Mesma query de A.22 mas com WHERE Attrition = 'No'
SELECT CASE WHEN rs <= 1 THEN 'Baixo (0-1)'
            WHEN rs <= 3 THEN 'Medio (2-3)'
            WHEN rs <= 5 THEN 'Alto (4-5)'
            ELSE 'Critico (6+)' END AS Faixa,
       COUNT(*) AS Actuais
FROM (
  SELECT (CASE WHEN OverTime='Yes' THEN 1 ELSE 0 END)
    + (CASE WHEN MonthlyIncome < 3000 THEN 1 ELSE 0 END)
    + (CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN YearsAtCompany <= 1 THEN 1 ELSE 0 END)
    + (CASE WHEN MaritalStatus = 'Single' THEN 1 ELSE 0 END)
    + (CASE WHEN Age <= 30 THEN 1 ELSE 0 END)
    + (CASE WHEN StockOptionLevel = 0 THEN 1 ELSE 0 END)
    + (CASE WHEN EnvironmentSatisfaction = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN WorkLifeBalance = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN JobInvolvement <= 2 THEN 1 ELSE 0 END) AS rs
  FROM Projeto1_IBM_HR.dbo.Colaboradores
  WHERE Attrition = 'No'
) scored
GROUP BY CASE WHEN rs <= 1 THEN 'Baixo (0-1)'
              WHEN rs <= 3 THEN 'Medio (2-3)'
              WHEN rs <= 5 THEN 'Alto (4-5)'
              ELSE 'Critico (6+)' END;
```

### A.24: Score por valor individual (0-7+)

```sql
-- Executado individualmente para cada score (0, 1, 2, ..., 7+)
SELECT [score] AS Score,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,1)) AS Taxa
FROM (
  SELECT Attrition,
    (CASE WHEN OverTime='Yes' THEN 1 ELSE 0 END)
    + (CASE WHEN MonthlyIncome < 3000 THEN 1 ELSE 0 END)
    + (CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN YearsAtCompany <= 1 THEN 1 ELSE 0 END)
    + (CASE WHEN MaritalStatus = 'Single' THEN 1 ELSE 0 END)
    + (CASE WHEN Age <= 30 THEN 1 ELSE 0 END)
    + (CASE WHEN StockOptionLevel = 0 THEN 1 ELSE 0 END)
    + (CASE WHEN EnvironmentSatisfaction = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN WorkLifeBalance = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN JobInvolvement <= 2 THEN 1 ELSE 0 END) AS rs
  FROM Projeto1_IBM_HR.dbo.Colaboradores
) scored
WHERE rs = [N]
GROUP BY rs;
```

### A.25: WorkLifeBalance vs Attrition

```sql
SELECT WorkLifeBalance,
       COUNT(*) AS Total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
       CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Taxa_Pct
FROM Projeto1_IBM_HR.dbo.Colaboradores
GROUP BY WorkLifeBalance;
```
