# Questoes de Negocio - Projeto 1: IBM HR Analytics

## Rastreabilidade Completa: Questao → Query → Resultado → Interpretacao

Este documento contém a **evidência completa** de cada análise realizada.

---

## 1. Igualdade de Genero

### G1: Qual a proporcao homens/mulheres global?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 1

**Query**:
```sql
SELECT Gender AS Genero,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Gender;
```

**Resultado**:

| Genero | Total | Percentagem |
|--------|-------|-------------|
| Female | 588 | 40.00 |
| Male | 882 | 60.00 |

**Interpretacao**: 40% mulheres, 10 pontos percentuais abaixo da meta de 50%. Nenhuma area da empresa atinge a meta.

---

### G2: Qual a distribuicao de genero por Department?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 2

**Query**:
```sql
SELECT Department AS Departamento,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
    AS DECIMAL(5,1)) AS PercMulheres,
    CAST(50 - ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
    AS DECIMAL(5,1)) AS GapParaMeta50
FROM Colaboradores
GROUP BY Department
ORDER BY PercMulheres;
```

**Resultado**:

| Departamento | Mulheres | Homens | Total | % Mulheres | Gap p/ Meta 50% |
|--------------|----------|--------|-------|------------|-----------------|
| Human Resources | 20 | 43 | 63 | 31.7% | 18.3% |
| Research & Development | 379 | 582 | 961 | 39.4% | 10.6% |
| Sales | 189 | 257 | 446 | 42.4% | 7.6% |

**Interpretacao**: HR e o departamento mais desequilibrado (31.7% mulheres), apesar de tipicamente ser uma area com mais mulheres. Sales e o mais proximo da meta (42.4%).

---

### G3: Qual a distribuicao de genero por JobLevel?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 4

**Query**:
```sql
SELECT JobLevel AS NivelHierarquico,
    CASE JobLevel
        WHEN 1 THEN 'Entry Level' WHEN 2 THEN 'Junior'
        WHEN 3 THEN 'Mid-Level' WHEN 4 THEN 'Senior'
        WHEN 5 THEN 'Executive'
    END AS DescricaoNivel,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
    AS DECIMAL(5,1)) AS PercMulheres
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;
```

**Resultado**:

| Nivel | Descricao | Mulheres | Homens | Total | % Mulheres |
|-------|-----------|----------|--------|-------|------------|
| 1 | Entry Level | 199 | 344 | 543 | 36.6% |
| 2 | Junior | 220 | 314 | 534 | 41.2% |
| 3 | Mid-Level | 94 | 124 | 218 | 43.1% |
| 4 | Senior | 51 | 55 | 106 | 48.1% |
| 5 | Executive | 24 | 45 | 69 | 34.8% |

**Interpretacao**: Evidencia clara de **glass ceiling**. Mulheres progridem de 36.6% (Entry) ate 48.1% (Senior), quase atingindo equilibrio. Mas caem drasticamente para 34.8% no nivel Executive - uma queda de 13.3 pontos percentuais. Isto sugere barreiras a promocao para os cargos de topo.

---

### G4: Qual a distribuicao de genero por JobRole?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 3

**Query**:
```sql
SELECT JobRole AS Cargo,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
    AS DECIMAL(5,1)) AS PercMulheres
FROM Colaboradores
GROUP BY JobRole
ORDER BY PercMulheres;
```

**Resultado**:

| Cargo | Mulheres | Homens | Total | % Mulheres |
|-------|----------|--------|-------|------------|
| Human Resources | 16 | 36 | 52 | 30.8% |
| Laboratory Technician | 85 | 174 | 259 | 32.8% |
| Healthcare Representative | 51 | 80 | 131 | 38.9% |
| Research Scientist | 114 | 178 | 292 | 39.0% |
| Sales Executive | 132 | 194 | 326 | 40.5% |
| Research Director | 33 | 47 | 80 | 41.3% |
| Sales Representative | 38 | 45 | 83 | 45.8% |
| Manager | 47 | 55 | 102 | 46.1% |
| Manufacturing Director | 72 | 73 | 145 | 49.7% |

**Interpretacao**: Manufacturing Director (49.7%) e o unico cargo perto da meta. HR (30.8%) e Lab Technician (32.8%) sao os cargos mais criticos. Nenhum cargo ultrapassa os 50%.

---

### G5: Existe gap salarial entre generos?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 5

**Query (global)**:
```sql
SELECT Gender AS Genero,
    COUNT(*) AS NumColaboradores,
    AVG(MonthlyIncome) AS SalarioMedio,
    MIN(MonthlyIncome) AS SalarioMin,
    MAX(MonthlyIncome) AS SalarioMax
FROM Colaboradores
GROUP BY Gender;
```

**Resultado (global)**:

| Genero | N | Salario Medio | Min | Max |
|--------|---|---------------|-----|-----|
| Male | 882 | $6,380 | $1,009 | $19,999 |
| Female | 588 | $6,686 | $1,129 | $19,973 |

**Gap percentual**: **-4.58%** (mulheres ganham MAIS)

**Query (por cargo)**:
```sql
SELECT JobRole AS Cargo,
    AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END) AS SalarioMedioMulheres,
    AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END) AS SalarioMedioHomens,
    AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END) -
    AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END) AS GapSalarial
FROM Colaboradores
GROUP BY JobRole
ORDER BY GapSalarial DESC;
```

**Resultado (por cargo)**:

| Cargo | Salario Mulheres | Salario Homens | Gap |
|-------|------------------|----------------|-----|
| Research Director | $15,144 | $16,657 | +$1,513 |
| Manager | $16,915 | $17,409 | +$494 |
| Sales Executive | $6,764 | $7,033 | +$269 |
| Healthcare Rep. | $7,433 | $7,589 | +$156 |
| Lab Technician | $3,246 | $3,232 | -$14 |
| Sales Rep. | $2,671 | $2,587 | -$84 |
| Research Scientist | $3,344 | $3,173 | -$171 |
| Manufacturing Dir. | $7,409 | $7,182 | -$227 |
| Human Resources | $4,540 | $4,100 | -$440 |

**Interpretacao**: Surpresa positiva - globalmente mulheres ganham 4.58% mais. Contudo, nos cargos de topo (Research Director +$1,513, Manager +$494) homens ganham mais. O gap global favoravel as mulheres explica-se provavelmente pela maior concentracao de mulheres nos niveis Senior (48.1%) onde os salarios sao altos.

---

### G6: Mulheres tem mais ou menos OverTime?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 8

**Query**:
```sql
SELECT Gender AS Genero, OverTime,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Gender, OverTime
ORDER BY Gender, OverTime;
```

**Resultado**:

| Genero | OverTime | Total | Percentagem |
|--------|----------|-------|-------------|
| Female | No | 408 | 69.39% |
| Female | Yes | 180 | 30.61% |
| Male | No | 646 | 73.24% |
| Male | Yes | 236 | 26.76% |

**Interpretacao**: Mulheres fazem MAIS overtime (30.6% vs 26.8%). Diferenca de ~4 pontos percentuais. Combinado com o gap salarial favoravel, sugere que mulheres compensam com mais horas para atingir salarios superiores.

---

### G7: Qual a taxa de Attrition por genero?

**Ficheiro**: `sql/04_analise_genero.sql` - Seccao 7

**Query**:
```sql
SELECT Gender AS Genero, Attrition,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2)
    AS DECIMAL(5,2)) AS PercNoGenero
FROM Colaboradores
GROUP BY Gender, Attrition
ORDER BY Gender, Attrition;
```

**Resultado**:

| Genero | Attrition | Total | % no Genero |
|--------|-----------|-------|-------------|
| Female | No | 501 | 85.20% |
| Female | Yes | 87 | 14.80% |
| Male | No | 732 | 82.99% |
| Male | Yes | 150 | 17.01% |

**Interpretacao**: Mulheres tem menor taxa de attrition (14.8% vs 17.0%). Homens saem mais da empresa. Dados de promocao mostram tempos iguais (media 2 anos sem promocao para ambos os generos).

---

## 2. Felicidade

### F1: Qual o nivel medio de JobSatisfaction?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Seccao 1

**Query**:
```sql
SELECT
    ROUND(AVG(CAST(EnvironmentSatisfaction AS FLOAT)), 2) AS MediaSatisfacaoAmbiente,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS MediaSatisfacaoTrabalho,
    ROUND(AVG(CAST(RelationshipSatisfaction AS FLOAT)), 2) AS MediaSatisfacaoRelacoes,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS MediaWorkLifeBalance,
    ROUND(AVG(CAST(JobInvolvement AS FLOAT)), 2) AS MediaEnvolvimento
FROM Colaboradores;
```

**Resultado**:

| Indicador | Media (escala 1-4) |
|-----------|--------------------|
| EnvironmentSatisfaction | 2.72 |
| JobSatisfaction | 2.73 |
| RelationshipSatisfaction | 2.71 |
| WorkLifeBalance | 2.76 |
| JobInvolvement | 2.73 |

**Indice de Felicidade Composto**: **2.73/4** → Classificacao: **SATISFEITOS** (entre 2.5 e 3.0)

**Interpretacao**: Todos os indicadores estao muito proximos (2.71-2.76), todos abaixo de 3.0 ("High"). A empresa esta no limiar entre satisfeita e feliz - nao ha alarme, mas ha espaco para melhoria. O WorkLifeBalance e o indicador mais alto (2.76), o RelationshipSatisfaction o mais baixo (2.71).

---

### F2: Qual o nivel medio de EnvironmentSatisfaction?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Seccao 2

**Query**:
```sql
SELECT EnvironmentSatisfaction AS Nivel,
    CASE EnvironmentSatisfaction
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' WHEN 3 THEN 'High' WHEN 4 THEN 'Very High'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;
```

**Resultado**:

| Nivel | Descricao | Total | Percentagem |
|-------|-----------|-------|-------------|
| 1 | Low | 284 | 19.3% |
| 2 | Medium | 287 | 19.5% |
| 3 | High | 453 | 30.8% |
| 4 | Very High | 446 | 30.3% |

**Interpretacao**: Media 2.72/4. 61.2% dos colaboradores tem satisfacao alta ou muito alta com o ambiente (niveis 3-4). Contudo, 19.3% tem satisfacao baixa - quase 1 em cada 5.

---

### F3: Qual o nivel medio de WorkLifeBalance?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Seccao 2

**Query**:
```sql
SELECT WorkLifeBalance AS Nivel,
    CASE WorkLifeBalance
        WHEN 1 THEN 'Bad' WHEN 2 THEN 'Good' WHEN 3 THEN 'Better' WHEN 4 THEN 'Best'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;
```

**Resultado**:

| Nivel | Descricao | Total | Percentagem |
|-------|-----------|-------|-------------|
| 1 | Bad | 80 | 5.4% |
| 2 | Good | 344 | 23.4% |
| 3 | Better | 893 | 60.7% |
| 4 | Best | 153 | 10.4% |

**Interpretacao**: Media 2.76/4. WorkLifeBalance e o melhor indicador. 71.2% reporta nivel "Better" ou "Best". Apenas 5.4% (80 pessoas) tem WLB "Bad" - grupo pequeno mas critico para retencao. A grande maioria (60.7%) esta no nivel 3 ("Better").

**JobSatisfaction - Distribuicao**:

| Nivel | Descricao | Total | Percentagem |
|-------|-----------|-------|-------------|
| 1 | Low | 289 | 19.7% |
| 2 | Medium | 280 | 19.0% |
| 3 | High | 442 | 30.1% |
| 4 | Very High | 459 | 31.2% |

61.3% com satisfacao alta/muito alta. 19.7% com satisfacao baixa.

---

### F4: Qual departamento tem pior satisfacao?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Seccao 3

**Query**:
```sql
SELECT Department AS Departamento,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(EnvironmentSatisfaction AS FLOAT)), 2) AS Ambiente,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS Trabalho,
    ROUND(AVG(CAST(RelationshipSatisfaction AS FLOAT)), 2) AS Relacoes,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLife,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY Department
ORDER BY IndiceFelicidade DESC;
```

**Resultado**:

| Departamento | N | Ambiente | Trabalho | Relacoes | WorkLife | Indice |
|--------------|---|----------|----------|----------|---------|--------|
| Human Resources | 63 | 2.68 | 2.60 | 2.89 | 2.92 | 2.77 |
| Sales | 446 | 2.68 | 2.75 | 2.70 | 2.82 | 2.74 |
| R&D | 961 | 2.74 | 2.73 | 2.71 | 2.73 | 2.73 |

**Interpretacao**: Surpresa - HR tem o MELHOR indice de felicidade (2.77), nao o pior. As diferencas entre departamentos sao minimas (0.04 pontos). R&D tem o indice mais baixo (2.73), mas com 961 pessoas representa o maior departamento. HR destaca-se em Relacoes (2.89) e WorkLife (2.92), mas tem a pior satisfacao com o Trabalho (2.60).

**Por Cargo**:

| Cargo | N | Satisfacao Trabalho | WorkLife | Indice |
|-------|---|---------------------|---------|--------|
| Manufacturing Director | 145 | 2.68 | 2.77 | 2.77 |
| Manager | 102 | 2.71 | 2.77 | 2.76 |
| Human Resources | 52 | 2.56 | 2.92 | 2.76 |
| Healthcare Rep. | 131 | 2.79 | 2.70 | 2.74 |
| Sales Representative | 83 | 2.73 | 2.89 | 2.74 |
| Sales Executive | 326 | 2.75 | 2.80 | 2.73 |
| Research Scientist | 292 | 2.77 | 2.68 | 2.72 |
| Laboratory Technician | 259 | 2.69 | 2.72 | 2.70 |
| Research Director | 80 | 2.70 | 2.86 | 2.69 |

**Interpretacao**: Research Director tem o pior indice (2.69) e Lab Technician o segundo pior (2.70). Manufacturing Director lidera (2.77). As diferencas sao pequenas (0.08 pontos entre melhor e pior).

---

### F5: Existe correlacao entre satisfacao e OverTime?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Seccao 5.1

**Query**:
```sql
SELECT OverTime,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY OverTime;
```

**Resultado**:

| OverTime | N | Satisfacao | WorkLife | Indice |
|----------|---|-----------|---------|--------|
| Yes | 416 | 2.77 | 2.73 | 2.79 |
| No | 1054 | 2.71 | 2.77 | 2.71 |

**Interpretacao**: Contra-intuitivo - quem faz overtime tem MAIOR indice de felicidade (2.79 vs 2.71) e maior satisfacao com o trabalho (2.77 vs 2.71). Contudo, o WorkLifeBalance e ligeiramente pior (2.73 vs 2.77). Possivel explicacao: quem faz overtime pode ser mais envolvido/motivado, ou recebe compensacao que aumenta a satisfacao.

---

### F6: RelationshipSatisfaction varia por MaritalStatus?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Query adicional

**Query**:
```sql
SELECT MaritalStatus AS EstadoCivil,
    COUNT(*) AS Total,
    ROUND(AVG(CAST(RelationshipSatisfaction AS FLOAT)), 2) AS SatisfacaoRelacoes,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoTrabalho,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY MaritalStatus
ORDER BY SatisfacaoRelacoes DESC;
```

**Resultado**:

| Estado Civil | N | Satisfacao Relacoes | Satisfacao Trabalho | Indice |
|-------------|---|---------------------|---------------------|--------|
| Single | 470 | 2.78 | 2.77 | 2.76 |
| Divorced | 327 | 2.72 | 2.70 | 2.73 |
| Married | 673 | 2.66 | 2.72 | 2.71 |

**Interpretacao**: Solteiros sao os mais satisfeitos com relacoes (2.78), casados os menos (2.66). Diferenca de 0.12 pontos. Solteiros tambem lideram no indice global (2.76). Casados tem o indice mais baixo (2.71). A diferenca pode reflectir pressoes familiares que afectam a percepcao de relacoes no trabalho.

---

### F7: WorkLifeBalance varia por BusinessTravel?

**Ficheiro**: `sql/05_analise_felicidade.sql` - Seccao 5.2

**Query**:
```sql
SELECT BusinessTravel AS TipoViagem,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY BusinessTravel
ORDER BY IndiceFelicidade DESC;
```

**Resultado**:

| Tipo Viagem | N | Satisfacao | WorkLife | Indice |
|-------------|---|-----------|---------|--------|
| Non-Travel | 150 | 2.79 | 2.77 | 2.77 |
| Travel_Frequently | 277 | 2.79 | 2.78 | 2.76 |
| Travel_Rarely | 1043 | 2.70 | 2.76 | 2.72 |

**Interpretacao**: Surpreendentemente, quem viaja frequentemente tem WorkLifeBalance ligeiramente MELHOR (2.78) do que quem nao viaja (2.77) ou viaja raramente (2.76). As diferencas sao minimas. Quem viaja raramente (maioria - 71%) tem o indice mais baixo (2.72). BusinessTravel nao parece ser um factor significativo de insatisfacao.

**Factores adicionais analisados**:

**Distancia de Casa**:

| Distancia | N | Satisfacao | WorkLife |
|-----------|---|-----------|---------|
| 0-5 (Muito Perto) | 632 | 2.75 | 2.79 |
| 6-10 (Perto) | 394 | 2.70 | 2.75 |
| 11-15 (Medio) | 115 | 2.66 | 2.76 |
| 16+ (Longe) | 329 | 2.74 | 2.72 |

**Anos sem Promocao**:

| Anos sem Promocao | N | Satisfacao |
|-------------------|---|-----------|
| 0 (Recente) | 581 | 2.71 |
| 1-2 anos | 516 | 2.76 |
| 3-5 anos | 158 | 2.82 |
| 5+ anos | 215 | 2.63 |

**Faixa Salarial**:

| Faixa Salarial | N | Satisfacao | Indice |
|----------------|---|-----------|--------|
| Baixo (<3000) | 395 | 2.75 | 2.75 |
| Medio (3000-6000) | 519 | 2.70 | 2.70 |
| Alto (6000-10000) | 275 | 2.76 | 2.74 |
| Muito Alto (>10000) | 281 | 2.71 | 2.75 |

**Satisfacao vs Attrition**:

| Attrition | N | Satisfacao | WorkLife | Indice |
|-----------|---|-----------|---------|--------|
| No (ficou) | 1233 | 2.78 | 2.78 | 2.77 |
| Yes (saiu) | 237 | 2.47 | 2.66 | 2.55 |

**Factores de preocupacao**:

| Factor de Risco | Total | % |
|-----------------|-------|---|
| Colaboradores com OverTime | 416 | 28.3% |
| WorkLife Balance "Bad" | 80 | 5.4% |
| Job Satisfaction "Low" | 289 | 19.7% |

**% com Satisfacao Alta/Muito Alta (3 ou 4)**: JobSatisfaction 61.3% | WorkLifeBalance 71.2% | EnvironmentSatisfaction 61.2%

---

## 3. Caracterizacao - "Quem Somos"

### C1: Qual o departamento dominante?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 6

**Query**:
```sql
SELECT Department AS Departamento,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Department
ORDER BY Total DESC;
```

**Resultado**:

| Departamento | Total | Percentagem |
|--------------|-------|-------------|
| Research & Development | 961 | 65.37% |
| Sales | 446 | 30.34% |
| Human Resources | 63 | 4.29% |

**Interpretacao**: R&D domina com quase 2/3 da empresa. HR e muito pequeno (4.3%) - pode ser intencional (empresa tecnologica) ou indicar sub-investimento.

---

### C2: Qual a idade media e distribuicao etaria?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 2

**Query (estatisticas)**:
```sql
SELECT MIN(Age) AS IdadeMinima, MAX(Age) AS IdadeMaxima,
    AVG(Age) AS IdadeMedia,
    CAST(ROUND(STDEV(Age),2) AS DECIMAL(5,2)) AS DesvioPadrao
FROM Colaboradores;
```

**Resultado (estatisticas)**:

| Idade Min | Idade Max | Idade Media | Desvio Padrao |
|-----------|-----------|-------------|---------------|
| 18 | 60 | 36 | 9.14 |

**Query (faixas etarias)**:
```sql
SELECT CASE
    WHEN Age < 25 THEN '18-24' WHEN Age < 30 THEN '25-29'
    WHEN Age < 35 THEN '30-34' WHEN Age < 40 THEN '35-39'
    WHEN Age < 45 THEN '40-44' WHEN Age < 50 THEN '45-49'
    WHEN Age < 55 THEN '50-54' WHEN Age < 60 THEN '55-59'
    ELSE '60+'
    END AS FaixaEtaria,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY [... mesma expressao CASE ...]
ORDER BY MIN(Age);
```

**Resultado (faixas etarias)**:

| Faixa Etaria | Total | Percentagem |
|--------------|-------|-------------|
| 18-24 | 97 | 6.60% |
| 25-29 | 229 | 15.58% |
| 30-34 | 325 | 22.11% |
| 35-39 | 297 | 20.20% |
| 40-44 | 208 | 14.15% |
| 45-49 | 141 | 9.59% |
| 50-54 | 104 | 7.07% |
| 55-59 | 64 | 4.35% |
| 60+ | 5 | 0.34% |

**Interpretacao**: Populacao jovem - media 36 anos, faixa dominante 30-34 (22.1%). 57.9% tem menos de 40 anos. Apenas 4.7% com 55+ anos (perto da reforma).

---

### C3: Qual o nivel de Education predominante?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 5

**Query**:
```sql
SELECT Education,
    CASE Education
        WHEN 1 THEN 'Below College' WHEN 2 THEN 'College'
        WHEN 3 THEN 'Bachelor' WHEN 4 THEN 'Master' WHEN 5 THEN 'Doctor'
    END AS NivelEducacao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Education
ORDER BY Education;
```

**Resultado**:

| Education | Nivel | Total | Percentagem |
|-----------|-------|-------|-------------|
| 1 | Below College | 170 | 11.56% |
| 2 | College | 282 | 19.18% |
| 3 | Bachelor | 572 | 38.91% |
| 4 | Master | 398 | 27.07% |
| 5 | Doctor | 48 | 3.27% |

**Interpretacao**: Bachelor e o nivel predominante (38.9%). 69.25% tem Bachelor ou superior (Bachelor + Master + Doctor). Populacao altamente qualificada.

---

### C4: Quais as areas de EducationField?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 5

**Query**:
```sql
SELECT EducationField AS AreaEducacao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY EducationField
ORDER BY Total DESC;
```

**Resultado**:

| Area de Educacao | Total | Percentagem |
|------------------|-------|-------------|
| Life Sciences | 606 | 41.22% |
| Medical | 464 | 31.56% |
| Marketing | 159 | 10.82% |
| Technical Degree | 132 | 8.98% |
| Other | 82 | 5.58% |
| Human Resources | 27 | 1.84% |

**Interpretacao**: Life Sciences (41.2%) e Medical (31.6%) dominam, coerente com R&D ser o maior departamento. Apenas 1.84% com formacao em HR - alinhado com o pequeno tamanho do departamento de HR.

---

### C5: Qual o MaritalStatus mais comum?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 4

**Query**:
```sql
SELECT MaritalStatus AS EstadoCivil,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY MaritalStatus
ORDER BY Total DESC;
```

**Resultado**:

| Estado Civil | Total | Percentagem |
|--------------|-------|-------------|
| Married | 673 | 45.78% |
| Single | 470 | 31.97% |
| Divorced | 327 | 22.24% |

**Interpretacao**: Maioria casados (45.8%). 22.2% divorciados - valor relativamente alto.

---

### C6: Quantas empresas anteriores em media (NumCompaniesWorked)?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 7 (metricas agregadas)

**Query**:
```sql
SELECT AVG(NumCompaniesWorked) AS MediaEmpresas,
    AVG(DistanceFromHome) AS MediaDistancia
FROM Colaboradores;
```

**Resultado**:

| Media Empresas | Media Distancia |
|----------------|-----------------|
| 2 | 9 |

**Interpretacao**: Em media, colaboradores trabalharam em ~2.7 empresas antes (valor arredondado para 2 pelo AVG inteiro). Mobilidade moderada.

---

### C7: Qual a distancia media de casa (DistanceFromHome)?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 7 (mesma query de C6)

**Resultado**: Media de **9 unidades** (provavelmente milhas, contexto EUA/IBM).

**Interpretacao**: Distancia moderada. A unidade nao e especificada no dataset. Valores variam de 1 a 29.

---

### C8: Qual a distribuicao por JobRole?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 6

**Query**:
```sql
SELECT JobRole AS Cargo,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2)
    AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY JobRole
ORDER BY Total DESC;
```

**Resultado**:

| Cargo | Total | Percentagem |
|-------|-------|-------------|
| Sales Executive | 326 | 22.18% |
| Research Scientist | 292 | 19.86% |
| Laboratory Technician | 259 | 17.62% |
| Manufacturing Director | 145 | 9.86% |
| Healthcare Representative | 131 | 8.91% |
| Manager | 102 | 6.94% |
| Sales Representative | 83 | 5.65% |
| Research Director | 80 | 5.44% |
| Human Resources | 52 | 3.54% |

**Interpretacao**: Top 3 cargos (Sales Exec, Research Sci, Lab Tech) representam ~60% da empresa. Estrutura tipica de empresa tecnologica com forte componente de R&D e vendas.

---

### C9: Qual o salario medio por departamento/cargo?

**Ficheiro**: `sql/03_analise_exploratoria.sql` - Seccao 8

**Query (por departamento)**:
```sql
SELECT Department AS Departamento,
    COUNT(*) AS NumColaboradores,
    MIN(MonthlyIncome) AS SalarioMin,
    AVG(MonthlyIncome) AS SalarioMedio,
    MAX(MonthlyIncome) AS SalarioMax
FROM Colaboradores
GROUP BY Department
ORDER BY SalarioMedio DESC;
```

**Resultado (por departamento)**:

| Departamento | N | Sal. Min | Sal. Medio | Sal. Max |
|--------------|---|----------|------------|----------|
| Sales | 446 | $1,052 | $6,959 | $19,847 |
| Human Resources | 63 | $1,555 | $6,654 | $19,717 |
| Research & Development | 961 | $1,009 | $6,281 | $19,999 |

**Query (por nivel hierarquico)**:
```sql
SELECT JobLevel AS Nivel,
    COUNT(*) AS NumColaboradores,
    AVG(MonthlyIncome) AS SalarioMedio
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;
```

**Resultado (por nivel hierarquico)**:

| Nivel | N | Salario Medio |
|-------|---|---------------|
| 1 - Entry | 543 | $2,786 |
| 2 - Junior | 534 | $5,502 |
| 3 - Mid | 218 | $9,817 |
| 4 - Senior | 106 | $15,503 |
| 5 - Executive | 69 | $19,191 |

**Estatisticas gerais**: Min $1,009 / Media $6,502 / Max $19,999 / Desvio Padrao $4,708

**Interpretacao**: Sales paga melhor em media ($6,959). A progressao salarial por nivel e consistente: quase duplica entre Entry ($2,786) e Junior ($5,502), e novamente entre Junior e Mid ($9,817). Desvio padrao alto ($4,708) indica grande dispersao salarial.

---

## 4. Envelhecimento

### E1: Quantos colaboradores tem 55+ anos?

**Ficheiro**: `sql/06_analise_envelhecimento.sql` - Seccoes 1-2

**Query**:
```sql
SELECT
    CASE
        WHEN Age >= 60 THEN '60+ (Reforma muito proxima: 0-7 anos)'
        WHEN Age >= 55 THEN '55-59 (Reforma proxima: 8-12 anos)'
        WHEN Age >= 50 THEN '50-54 (Pre-reforma: 13-17 anos)'
    END AS FaixaCritica,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS PercTotal
FROM Colaboradores
WHERE Age >= 50
GROUP BY [... CASE ...]
ORDER BY MIN(Age) DESC;
```

**Resultado**:

| Faixa Critica | Total | % do Total |
|---------------|-------|------------|
| 60+ (Reforma muito proxima: 0-7 anos) | 5 | 0.3% |
| 55-59 (Reforma proxima: 8-12 anos) | 64 | 4.4% |
| 50-54 (Pre-reforma: 13-17 anos) | 104 | 7.1% |
| **Total 50+** | **173** | **11.8%** |
| **Total 55+** | **69** | **4.7%** |

**Interpretacao**: 69 colaboradores (4.7%) com 55+ anos. Risco de reforma a curto prazo e baixo (apenas 5 com 60+). Contudo, 173 colaboradores (11.8%) com 50+ anos representam risco a medio prazo.

---

### E2: Quantos colaboradores tem 60+ anos?

**Ficheiro**: `sql/06_analise_envelhecimento.sql` - Seccao 2

**Resultado**: **5 colaboradores** (0.3%) com 60 anos (idade maxima no dataset). Nenhum com 62+, logo 0 reformas nos proximos 5 anos (reforma aos 67 em Portugal).

**Interpretacao**: Risco imediato de reforma e nulo. A idade maxima no dataset e 60 anos, com 7 anos ate a reforma. Contudo, isto e um dataset ficticio - na realidade, saidas antecipadas sao comuns.

---

### E3: Qual a distribuicao de TotalWorkingYears?

**Ficheiro**: `sql/06_analise_envelhecimento.sql` - Seccao 7

**Query**:
```sql
SELECT
    CASE
        WHEN Age < 30 THEN '18-29' WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49' WHEN Age < 60 THEN '50-59'
        ELSE '60+'
    END AS FaixaEtaria,
    COUNT(*) AS Total,
    AVG(YearsAtCompany) AS MediaAnosEmpresa,
    AVG(YearsInCurrentRole) AS MediaAnosCargo,
    AVG(TotalWorkingYears) AS MediaExperienciaTotal
FROM Colaboradores
GROUP BY [... CASE ...]
ORDER BY MIN(Age);
```

**Resultado**:

| Faixa Etaria | N | Media Anos Empresa | Media Anos Cargo | Media Experiencia Total |
|--------------|---|--------------------|-----------------|-----------------------|
| 18-29 | 326 | 4 | 2 | 4 |
| 30-39 | 622 | 6 | 4 | 9 |
| 40-49 | 349 | 8 | 4 | 15 |
| 50-59 | 168 | 9 | 4 | 21 |
| 60+ | 5 | 12 | 6 | 19 |

**Interpretacao**: Experiencia total cresce linearmente com a idade (4→9→15→21 anos). Anos na empresa crescem mais devagar (4→6→8→9), sugerindo que colaboradores mais velhos ja mudaram de empresa antes. Curiosamente, os 60+ tem menos experiencia total (19) do que os 50-59 (21) - amostra muito pequena (5 pessoas).

---

### E4: Quantos anos em media ficam na empresa?

**Ficheiro**: `sql/06_analise_envelhecimento.sql` - Seccao 7 (mesma query E3)

**Resultado**: Media global de **7 anos** na empresa (ja documentado em C6). Por faixa etaria: 4 anos (18-29), 6 anos (30-39), 8 anos (40-49), 9 anos (50-59), 12 anos (60+).

**Interpretacao**: Colaboradores ficam em media 7 anos. Os mais velhos (50+) ficam ~9 anos, o que e relativamente estavel. Isto indica retencao razoavel para os seniores.

---

### E5: Quem esta perto da reforma esta em cargos criticos?

**Ficheiro**: `sql/06_analise_envelhecimento.sql` - Seccoes 4-6

**Query (envelhecimento por cargo)**:
```sql
SELECT JobRole AS Cargo, COUNT(*) AS Total, AVG(Age) AS IdadeMedia,
    SUM(CASE WHEN Age >= 55 THEN 1 ELSE 0 END) AS Colaboradores55mais,
    CAST(ROUND(SUM(CASE WHEN Age >= 55 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS Perc55mais
FROM Colaboradores
GROUP BY JobRole
ORDER BY IdadeMedia DESC;
```

**Resultado (por cargo)**:

| Cargo | Total | Idade Media | 55+ | % 55+ |
|-------|-------|-------------|-----|-------|
| Manager | 102 | 46 | 17 | 16.7% |
| Research Director | 80 | 44 | 6 | 7.5% |
| Healthcare Rep. | 131 | 39 | 11 | 8.4% |
| Manufacturing Dir. | 145 | 38 | 6 | 4.1% |
| Sales Executive | 326 | 36 | 12 | 3.7% |
| Human Resources | 52 | 35 | 1 | 1.9% |
| Research Scientist | 292 | 34 | 11 | 3.8% |
| Lab Technician | 259 | 34 | 5 | 1.9% |
| Sales Representative | 83 | 30 | 0 | 0.0% |

**Resultado (planeamento de sucessao)**:

| Cargo | Perto Reforma (55+) | Jovens (<35) | Total | Alerta |
|-------|---------------------|-------------|-------|--------|
| **Manager** | **17** | **7** | 102 | **RISCO: Mais seniores que jovens** |
| Sales Executive | 12 | 148 | 326 | OK |
| Research Scientist | 11 | 174 | 292 | OK |
| Healthcare Rep. | 11 | 36 | 131 | OK |
| Research Director | 6 | 13 | 80 | OK |
| Manufacturing Dir. | 6 | 48 | 145 | OK |
| Lab Technician | 5 | 139 | 259 | OK |
| Human Resources | 1 | 25 | 52 | OK |

**Resultado (risco por colaboradores seniores com experiencia)**:
- **39 colaboradores** com 55+ anos E 20+ anos de experiencia - alto risco de perda de conhecimento

**Interpretacao**: **Manager e o cargo em risco critico** - 16.7% dos Managers tem 55+ anos, e ha mais seniores (17) do que jovens (<35, apenas 7). Isto representa um gap de sucessao. Research Director (idade media 44) e Healthcare Rep. (8.4% com 55+) tambem merecem atencao. 39 colaboradores seniores tem vasta experiencia (20+ anos) que sera perdida quando se reformarem.

---

### E6: Qual o risco de saida em massa por departamento?

**Ficheiro**: `sql/06_analise_envelhecimento.sql` - Seccoes 3, 5, 8

**Query (por departamento)**:
```sql
SELECT Department AS Departamento,
    COUNT(*) AS ColaboradoresEmRisco,
    AVG(TotalWorkingYears) AS MediaExperiencia,
    AVG(YearsAtCompany) AS MediaAnosEmpresa,
    SUM(CASE WHEN JobLevel >= 4 THEN 1 ELSE 0 END) AS SenioresAltoNivel
FROM Colaboradores
WHERE Age >= 55
GROUP BY Department
ORDER BY ColaboradoresEmRisco DESC;
```

**Resultado (risco por departamento - colaboradores 55+)**:

| Departamento | N (55+) | % 55+ | Media Experiencia | Media Anos Empresa | Seniores Nivel 4-5 |
|--------------|---------|-------|-------------------|--------------------|---------------------|
| R&D | 47 | 4.9% | 20 | 9 | 18 |
| Sales | 18 | 4.0% | 23 | 11 | 8 |
| Human Resources | 4 | 6.3% | 27 | 5 | 3 |

**Resultado (attrition por faixa etaria)**:

| Faixa Etaria | Ficou | Saiu | Taxa Attrition |
|-------------|-------|------|----------------|
| 18-29 | 235 | 91 | **27.9%** |
| 30-39 | 533 | 89 | 14.3% |
| 40-49 | 315 | 34 | **9.7%** |
| 50+ | 150 | 23 | 13.3% |

**Resultado (distribuicao geracional)**:

| Geracao | Total | % | Idade Media |
|---------|-------|---|-------------|
| Gen Z (< 28) | 210 | 14.3% | 24 |
| Millennials (28-43) | 913 | 62.1% | 34 |
| Gen X (44-59) | 342 | 23.3% | 49 |
| Baby Boomers (60+) | 5 | 0.3% | 60 |

**Interpretacao**: Risco de saida em massa e **BAIXO**. HR tem a maior percentagem de 55+ (6.3%) mas com apenas 4 pessoas. R&D tem 47 colaboradores 55+, incluindo 18 em niveis 4-5 (Senior/Executive) - maior risco absoluto. A attrition e mais alta nos jovens (27.9% para 18-29) do que nos seniores (9.7-13.3%). Millennials dominam (62.1%), o que da folga para sucessao. O principal risco e a perda de conhecimento dos 39 seniores com 20+ anos de experiencia, nao a saida em massa.

---

## 5. Attrition

### A1: Qual a taxa global de Attrition?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccao 1

**Query**:
```sql
SELECT Attrition,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Attrition;
```

**Resultado**:

| Attrition | Total | Percentagem |
|-----------|-------|-------------|
| No | 1233 | 83.88% |
| Yes | 237 | **16.12%** |

**Interpretacao**: Taxa de attrition de 16.1% - acima do benchmark tipico de 10-15% para empresas tecnologicas. 237 colaboradores sairam, restam 1233.

---

### A2: Qual departamento perde mais pessoas?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccoes 3-4

**Query (por departamento)**:
```sql
SELECT Department AS Departamento,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY Department
ORDER BY TaxaAttrition DESC;
```

**Resultado (por departamento)**:

| Departamento | Saidas | Total | Taxa Attrition |
|--------------|--------|-------|----------------|
| Sales | 92 | 446 | **20.6%** |
| Human Resources | 12 | 63 | 19.0% |
| R&D | 133 | 961 | 13.8% |

**Resultado (por cargo)**:

| Cargo | Saidas | Total | Taxa Attrition |
|-------|--------|-------|----------------|
| **Sales Representative** | **33** | **83** | **39.8%** |
| Laboratory Technician | 62 | 259 | 23.9% |
| Human Resources | 12 | 52 | 23.1% |
| Sales Executive | 57 | 326 | 17.5% |
| Research Scientist | 47 | 292 | 16.1% |
| Healthcare Rep. | 9 | 131 | 6.9% |
| Manufacturing Dir. | 10 | 145 | 6.9% |
| Manager | 5 | 102 | 4.9% |
| Research Director | 2 | 80 | 2.5% |

**Interpretacao**: Sales perde mais pessoas (20.6%), mas o cargo critico e **Sales Representative com 39.8% de attrition** - quase 4 em cada 10 saem. Lab Technician (23.9%) e HR (23.1%) tambem sao criticos. Cargos de gestao (Manager 4.9%, Research Director 2.5%) tem attrition muito baixa.

---

### A3: Quem sai tem mais OverTime?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccao 6.1

**Query**:
```sql
SELECT OverTime,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY OverTime;
```

**Resultado**:

| OverTime | Saidas | Total | Taxa Attrition |
|----------|--------|-------|----------------|
| Yes | 127 | 416 | **30.5%** |
| No | 110 | 1054 | 10.4% |

**Interpretacao**: **OverTime e o maior factor de risco** - 30.5% de attrition vs 10.4% sem overtime. Quem faz overtime tem 3x mais probabilidade de sair. Dos 237 que sairam, 53.6% faziam overtime.

---

### A4: Existe padrao de satisfacao em quem sai?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccoes 6.5-6.6

**Query (por satisfacao)**:
```sql
SELECT
    CASE JobSatisfaction
        WHEN 1 THEN '1-Low' WHEN 2 THEN '2-Medium'
        WHEN 3 THEN '3-High' WHEN 4 THEN '4-Very High'
    END AS SatisfacaoTrabalho,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
```

**Resultado (JobSatisfaction)**:

| Nivel | Saidas | Total | Taxa Attrition |
|-------|--------|-------|----------------|
| 1-Low | 66 | 289 | **22.8%** |
| 2-Medium | 46 | 280 | 16.4% |
| 3-High | 73 | 442 | 16.5% |
| 4-Very High | 52 | 459 | **11.3%** |

**Resultado (WorkLifeBalance)**:

| Nivel | Saidas | Total | Taxa Attrition |
|-------|--------|-------|----------------|
| 1-Bad | 25 | 80 | **31.3%** |
| 2-Good | 58 | 344 | 16.9% |
| 3-Better | 127 | 893 | 14.2% |
| 4-Best | 27 | 153 | 17.6% |

**Interpretacao**: Padrao claro - satisfacao baixa correlaciona com mais saidas. Job Satisfaction "Low" tem 22.8% de attrition (dobro da "Very High" com 11.3%). WorkLife Balance "Bad" tem a taxa mais alta (31.3%). Curiosamente, WLB "Best" (17.6%) tem mais attrition que "Better" (14.2%).

---

### A5: YearsSinceLastPromotion influencia saidas?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccao 6.4

**Query**:
```sql
SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 anos'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos'
    END AS AnosSemPromocao,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY [... CASE ...]
ORDER BY TaxaAttrition DESC;
```

**Resultado**:

| Anos sem Promocao | Saidas | Total | Taxa Attrition |
|-------------------|--------|-------|----------------|
| 0 anos | 110 | 581 | **18.9%** |
| 5+ anos | 35 | 215 | 16.3% |
| 1-2 anos | 76 | 516 | 14.7% |
| 3-5 anos | 16 | 158 | **10.1%** |

**Interpretacao**: Surpreendente - quem foi promovido recentemente (0 anos) tem a MAIOR attrition (18.9%). Possivelmente sao colaboradores que receberam promocao mas decidiram sair (talvez a promocao veio tarde). 5+ anos sem promocao tambem tem taxa alta (16.3%). O ponto doce e 3-5 anos (10.1%).

---

### A6: Qual o perfil tipico de quem sai?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccoes 2, 5, 7

**Query (perfil comparativo)**:
```sql
SELECT
    'Perfil de quem SAIU' AS Categoria,
    ROUND(AVG(CAST(Age AS FLOAT)), 1) AS IdadeMedia,
    ... -- overtime, travel, solteiros, satisfacao, salario, anos empresa
FROM Colaboradores WHERE Attrition = 'Yes'
UNION ALL
SELECT 'Perfil de quem FICOU', ...
FROM Colaboradores WHERE Attrition = 'No';
```

**Resultado**:

| Metrica | Saiu | Ficou | Delta |
|---------|------|-------|-------|
| Idade media | **33.6** | 37.6 | -4 anos |
| Salario medio | **$4,787** | $6,833 | -$2,046 |
| Anos na empresa | **5.1** | 7.4 | -2.3 anos |
| Experiencia total | 8.2 | 11.9 | -3.7 anos |
| Distancia de casa | **10.6** | 8.9 | +1.7 |
| Satisfacao trabalho | **2.47** | 2.78 | -0.31 |
| WorkLifeBalance | **2.66** | 2.78 | -0.12 |
| % com OverTime | **53.6%** | 23.4% | +30.2pp |
| % Travel Frequently | **29.1%** | 16.9% | +12.2pp |
| % Solteiros | **50.6%** | 28.4% | +22.2pp |

**Por faixa etaria**:

| Faixa | Saidas | Total | Taxa |
|-------|--------|-------|------|
| 18-24 | 38 | 97 | **39.2%** |
| 25-29 | 53 | 229 | 23.1% |
| 30-34 | 59 | 325 | 18.2% |
| 50+ | 23 | 173 | 13.3% |
| 35-39 | 30 | 297 | 10.1% |
| 40-49 | 34 | 349 | 9.7% |

**Por estado civil**:

| Estado | Taxa Attrition |
|--------|----------------|
| Single | **25.5%** |
| Married | 12.5% |
| Divorced | 10.1% |

**Perfil tipico de quem sai**: Jovem (~34 anos), solteiro, salario baixo (~$4,787), faz overtime, viaja frequentemente, menos satisfeito, vive mais longe da empresa, menos tempo na empresa (~5 anos).

---

### A7: DistanceFromHome correlaciona com Attrition?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccao 6.3

**Query**:
```sql
SELECT
    CASE
        WHEN DistanceFromHome <= 5 THEN '0-5 (Muito Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10 (Perto)'
        WHEN DistanceFromHome <= 20 THEN '11-20 (Medio)'
        ELSE '20+ (Longe)'
    END AS Distancia,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY [... CASE ...]
ORDER BY TaxaAttrition DESC;
```

**Resultado**:

| Distancia | Saidas | Total | Taxa Attrition |
|-----------|--------|-------|----------------|
| 20+ (Longe) | 45 | 204 | **22.1%** |
| 11-20 (Medio) | 48 | 240 | 20.0% |
| 6-10 (Perto) | 57 | 394 | 14.5% |
| 0-5 (Muito Perto) | 87 | 632 | 13.8% |

**Interpretacao**: Correlacao clara - quanto mais longe, mais saem. 22.1% de attrition para quem vive a 20+ unidades vs 13.8% para quem vive perto. Diferenca de 8.3 pontos percentuais.

---

### A8: BusinessTravel correlaciona com Attrition?

**Ficheiro**: `sql/07_analise_attrition.sql` - Seccao 6.2

**Query**:
```sql
SELECT BusinessTravel AS TipoViagem,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY BusinessTravel
ORDER BY TaxaAttrition DESC;
```

**Resultado**:

| Tipo Viagem | Saidas | Total | Taxa Attrition |
|-------------|--------|-------|----------------|
| Travel_Frequently | 69 | 277 | **24.9%** |
| Travel_Rarely | 156 | 1043 | 15.0% |
| Non-Travel | 12 | 150 | **8.0%** |

**Interpretacao**: Forte correlacao - viagens frequentes triplicam a attrition (24.9% vs 8.0%). Este e o segundo maior factor de risco apos OverTime.

**Faixa Salarial vs Attrition**:

| Faixa | Saidas | Total | Taxa |
|-------|--------|-------|------|
| Baixo (<3000) | 113 | 395 | **28.6%** |
| Medio-Baixo (3000-5000) | 50 | 354 | 14.1% |
| Medio (5000-8000) | 34 | 340 | 10.0% |
| Alto (8000-12000) | 29 | 186 | 15.6% |
| Muito Alto (>12000) | 11 | 195 | **5.6%** |

**Colaboradores em risco (actualmente na empresa, com 3+ factores de risco)**: **164 colaboradores**

---

## 6. Questoes Adicionais do Grupo

### Q1: Existem os mesmos JobRoles em varios departamentos?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 1

**Query**:
```sql
SELECT Department AS Departamento, JobRole AS Cargo, COUNT(*) AS Total
FROM Colaboradores
GROUP BY Department, JobRole
ORDER BY JobRole, Department;
```

**Resultado**:

| Departamento | Cargo | Total |
|--------------|-------|-------|
| R&D | Healthcare Representative | 131 |
| HR | Human Resources | 52 |
| R&D | Laboratory Technician | 259 |
| **HR** | **Manager** | **11** |
| **R&D** | **Manager** | **54** |
| **Sales** | **Manager** | **37** |
| R&D | Manufacturing Director | 145 |
| R&D | Research Director | 80 |
| R&D | Research Scientist | 292 |
| Sales | Sales Executive | 326 |
| Sales | Sales Representative | 83 |

**Interpretacao**: **Apenas Manager existe em 3 departamentos** (HR: 11, R&D: 54, Sales: 37). Todos os outros cargos sao exclusivos de um departamento. Isto significa que Manager e o unico cargo transversal.

---

### Q2: So ha stock options para certo tipo de colaborador?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 2

**Resultado (distribuicao)**:

| Nivel | Descricao | Total | % |
|-------|-----------|-------|---|
| 0 | Sem Stock Options | 631 | **42.9%** |
| 1 | Basico | 596 | 40.5% |
| 2 | Medio | 158 | 10.7% |
| 3 | Alto | 85 | 5.8% |

**Resultado (por JobLevel)**:

| Nivel | Sem Stock | Nivel 1 | Nivel 2 | Nivel 3 | Media |
|-------|-----------|---------|---------|---------|-------|
| 1 (Entry) | 257 | 206 | 41 | 39 | 0.75 |
| 2 (Junior) | 219 | 207 | 83 | 25 | 0.84 |
| 3 (Mid) | 86 | 97 | 22 | 13 | 0.83 |
| 4 (Senior) | 43 | 49 | 8 | 6 | 0.78 |
| 5 (Executive) | 26 | 37 | 4 | 2 | 0.74 |

**Resultado (por cargo - % com stock options)**:

| Cargo | Total | Com Stock | % Com Stock | Media |
|-------|-------|-----------|-------------|-------|
| Manager | 102 | 65 | 63.7% | 0.75 |
| Healthcare Rep. | 131 | 80 | 61.1% | 0.83 |
| Manufacturing Dir. | 145 | 86 | 59.3% | 0.81 |
| Research Director | 80 | 47 | 58.8% | 0.85 |
| Lab Technician | 259 | 151 | 58.3% | 0.82 |
| Sales Executive | 326 | 187 | 57.4% | 0.82 |
| Human Resources | 52 | 28 | 53.8% | 0.75 |
| Research Scientist | 292 | 156 | 53.4% | 0.77 |
| Sales Representative | 83 | 39 | **47.0%** | 0.63 |

**Interpretacao**: 42.9% dos colaboradores NAO tem stock options. A distribuicao e relativamente uniforme entre niveis hierarquicos (media 0.74-0.84). Nao ha evidencia de que stock options sejam exclusivas de cargos altos. Sales Representative tem a menor cobertura (47%).

---

### Q3: Muita gente a viver a 1 unidade de distancia?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 3

**Resultado (distribuicao detalhada)**:

| Distancia | Total | % |
|-----------|-------|---|
| 1 (Muito Perto) | **208** | **14.1%** |
| 2-5 (Perto) | 424 | 28.8% |
| 6-10 | 394 | 26.8% |
| 11-15 | 115 | 7.8% |
| 16-20 | 125 | 8.5% |
| 21+ (Longe) | 204 | 13.9% |

**Interpretacao**: Sim, 14.1% (208 pessoas) vivem a 1 unidade de distancia - o valor individual mais frequente. 42.9% vivem a ate 5 unidades. A distribuicao e bimodal: muitos perto (1-5) e muitos longe (21+). Provavelmente reflecte uma empresa com sede urbana onde muitos colaboradores vivem no centro e outros nos suburbios.

---

### Q4: PerformanceRating so tem valores 3 e 4?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 4

**Resultado**:

| PerformanceRating | Descricao | Total | % |
|-------------------|-----------|-------|---|
| 3 | Excellent | 1244 | **84.6%** |
| 4 | Outstanding | 226 | 15.4% |

**Confirmado**: Apenas valores 3 e 4 existem (escala original 1-4). Nenhum colaborador tem rating 1 (Low) ou 2 (Good).

**Interpretacao**: Possivel vies de avaliacao. Na pratica, a empresa so usa 2 dos 4 niveis. Isto torna o PerformanceRating pouco discriminativo - nao distingue colaboradores medianos de bons. 84.6% sao "Excellent" e 15.4% "Outstanding".

---

### Q5: Ha conflito de geracoes?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 5

**Resultado (satisfacao por geracao)**:

| Geracao | N | Satisfacao Trabalho | WorkLife | Ambiente | Relacoes |
|---------|---|---------------------|---------|----------|----------|
| Gen Z (< 28) | 210 | 2.71 | 2.77 | 2.68 | 2.69 |
| Millennials (28-43) | 913 | 2.74 | 2.77 | 2.73 | 2.67 |
| Gen X (44-59) | 342 | 2.71 | 2.73 | 2.74 | **2.83** |
| Baby Boomers (60+) | 5 | 2.20 | **3.00** | 2.00 | **3.40** |

**Resultado (attrition por geracao)**:

| Geracao | Saidas | Total | Taxa Attrition |
|---------|--------|-------|----------------|
| Gen Z (< 28) | 59 | 210 | **28.1%** |
| Millennials (28-43) | 136 | 913 | 14.9% |
| Gen X (44-59) | 42 | 342 | 12.3% |
| Baby Boomers (60+) | 0 | 5 | 0.0% |

**Interpretacao**: Nao ha evidencia de conflito de geracoes nos indicadores de satisfacao - as diferencas sao minimas (0.03-0.06 pontos). Gen X destaca-se em RelationshipSatisfaction (2.83), possivelmente por maior estabilidade. Baby Boomers tem amostra muito pequena (5) para conclusoes. O principal contraste e na attrition: Gen Z sai 2x mais (28.1%) que Millennials (14.9%).

---

### Q6: Chefias sao mais masculinas?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 6

**Resultado (cargos de gestao por genero)**:

| Cargo | Mulheres | Homens | % Mulheres |
|-------|----------|--------|------------|
| Research Director | 33 | 47 | 41.3% |
| Manager | 47 | 55 | 46.1% |
| Manufacturing Director | 72 | 73 | 49.7% |

**Interpretacao**: Cargos de gestao estao relativamente equilibrados (41-50% mulheres). Manufacturing Director quase atinge a meta 50% (49.7%). Contudo, ja documentado em G3, o nivel Executive (JobLevel 5) cai para 34.8% mulheres - o glass ceiling existe nos cargos de topo, nao nos cargos de gestao intermedios.

---

### Q7: Experiencia correlaciona com felicidade?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 7

**Resultado (por anos na empresa)**:

| Anos na Empresa | N | Satisfacao | WorkLife |
|-----------------|---|-----------|---------|
| 0 (Novo) | 44 | **2.59** | 2.75 |
| 1-2 anos | 298 | 2.79 | 2.76 |
| 3-5 anos | 434 | 2.66 | 2.76 |
| 6-10 anos | 448 | 2.77 | 2.75 |
| 10+ anos | 246 | 2.72 | 2.78 |

**Resultado (por experiencia total)**:

| Experiencia Total | N | Satisfacao | WorkLife |
|-------------------|---|-----------|---------|
| 0-5 anos | 316 | 2.76 | 2.76 |
| 6-10 anos | 607 | 2.73 | 2.77 |
| 11-20 anos | 340 | 2.73 | 2.74 |
| 20+ anos | 207 | 2.70 | 2.77 |

**Interpretacao**: Novos colaboradores (0 anos) tem a satisfacao mais baixa (2.59) - possivelmente em fase de adaptacao. Apos 1-2 anos melhora (2.79). Nao ha tendencia clara de deterioracao com o tempo - a satisfacao mantem-se estavel (2.66-2.79) independentemente da antiguidade.

---

### Q8: MonthlyRate, DailyRate, HourlyRate - o que significam?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 8

**Resultado (estatisticas)**:

| Metrica | Min | Max | Media | Desvio Padrao |
|---------|-----|-----|-------|---------------|
| MonthlyIncome | $1,009 | $19,999 | $6,502 | $4,708 |
| MonthlyRate | $2,094 | $26,999 | $14,313 | $7,118 |
| DailyRate | $102 | $1,499 | $802 | $404 |
| HourlyRate | $30 | $100 | $65 | $20 |

**Interpretacao**: MonthlyRate ($14,313 media) e muito superior a MonthlyIncome ($6,502) - provavelmente inclui beneficios e custos antes de impostos. DailyRate e HourlyRate parecem ter distribuicoes uniformes (desvio padrao alto relativo a media). Estes rates parecem ser gerados aleatoriamente no dataset e nao correlacionam com o salario real (MonthlyIncome).

---

### Q9: Colunas constantes confirmadas?

**Ficheiro**: `sql/08_analise_adicional.sql` - Seccao 9

**Resultado**:

| Coluna | Valores Distintos | Min | Max |
|--------|-------------------|-----|-----|
| Over18 | 1 | Y | Y |
| EmployeeCount | 1 | 1 | 1 |
| StandardHours | 1 | 80 | 80 |

**Confirmado**: 3 colunas sao constantes e podem ser ignoradas na analise. Todos os colaboradores tem mais de 18 anos, contagem = 1, e horas standard = 80.

---

## Resumo de Progresso

| Categoria | Total | Respondidas | Pendentes |
|-----------|-------|-------------|-----------|
| Igualdade de Genero | 7 | 7 | 0 |
| Felicidade | 7 | 7 | 0 |
| Caracterizacao | 9 | 9 | 0 |
| Envelhecimento | 6 | 6 | 0 |
| Attrition | 8 | 8 | 0 |
| Questoes Adicionais | 9 | 9 | 0 |
| **Total** | **46** | **46** | **0** |

**Progresso**: 46/46 perguntas respondidas (100%)

---

## Perguntas Emergentes

Perguntas que surgem durante a analise e nao estavam na lista original.

### Em Aberto

| Data | Pergunta | Contexto | Prioridade |
|------|----------|----------|------------|
| 2026-01-28 | Porque mulheres fazem mais overtime mas ganham mais? | Descoberto na analise de genero (G5+G6) | Media |
| 2026-01-28 | O que explica a queda de mulheres no nivel Executive? | Glass ceiling identificado (G3) | Alta |
| 2026-01-28 | HR tem apenas 4.3% da empresa - e intencional? | Estrutura organizacional (C1) | Baixa |

### Respondidas

| Data | Pergunta | Resposta | Referencia |
|------|----------|----------|------------|
| - | - | - | - |

### Descartadas

| Data | Pergunta | Motivo |
|------|----------|--------|
| - | - | - |

---

## Legenda

- ✅ Respondida - query executada, resultado bruto e interpretacao documentados
- ⏳ Pendente - query existe mas ainda nao foi executada
- ❌ Bloqueada - dependencia ou problema identificado
