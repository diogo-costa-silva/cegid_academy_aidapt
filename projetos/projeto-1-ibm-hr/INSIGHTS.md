# Insights - Projeto 1: IBM HR Analytics

> Resumo executivo com KPIs e conclusoes.
> Para evidencia completa (queries + resultados brutos), ver [QUESTIONS.md](QUESTIONS.md).

## Resumo Executivo (KPIs)

| Metrica | Valor | Nota |
|---------|-------|------|
| Total Colaboradores | **1470** | |
| Idade Media | **36 anos** | Min 18, Max 60 |
| % Mulheres | **40%** | Meta 50% NAO atingida |
| Taxa Attrition | **16.1%** | 237 saidas (acima benchmark 10-15%) |
| Indice Felicidade | **2.73/4** | SATISFEITOS (abaixo de 3.0 "High") |
| Salario Medio | **$6,502/mes** | Desvio padrao $4,708 |
| Anos na Empresa (media) | **7 anos** | Max 40 anos |
| Departamento Dominante | **R&D (65.4%)** | |
| Colaboradores em Risco | **164** | 3+ factores de risco de attrition |
| 55+ anos (perto reforma) | **69 (4.7%)** | 0 reformas nos proximos 5 anos |

---

## 1. Igualdade de Genero

### Visao Geral
- **Proporcao global**: 40% mulheres / 60% homens
- **Gap para meta 50%**: 10 pontos percentuais
- **Meta atingida**: NAO - nenhum cargo ou departamento atinge a meta

> Evidencia: [G1](QUESTIONS.md#g1-qual-a-proporcao-homensmuiheres-global)

### Por Departamento

| Departamento | Mulheres | % Mulheres | Gap para 50% |
|--------------|----------|------------|--------------|
| Human Resources | 20 | 31.7% | -18.3% |
| R&D | 379 | 39.4% | -10.6% |
| Sales | 189 | 42.4% | -7.6% |

> Evidencia: [G2](QUESTIONS.md#g2-qual-a-distribuicao-de-genero-por-department)

### Por Nivel Hierarquico (Glass Ceiling Analysis)

| Nivel | Descricao | % Mulheres | Insight |
|-------|-----------|------------|---------|
| 1 | Entry Level | 36.6% | Entrada ja desequilibrada |
| 2 | Junior | 41.2% | Melhoria |
| 3 | Mid-Level | 43.1% | Continua a melhorar |
| 4 | Senior | **48.1%** | Quase equilibrado! |
| 5 | Executive | **34.8%** | QUEDA - glass ceiling |

**Conclusao**: Existe um "glass ceiling" claro - mulheres progridem bem ate ao nivel Senior (48.1%), mas caem drasticamente no nivel Executive (34.8%).

> Evidencia: [G3](QUESTIONS.md#g3-qual-a-distribuicao-de-genero-por-joblevel)

### Por Cargo

| Cargo                     | % Mulheres | Situacao |
| ------------------------- | ---------- | -------- |
| Manufacturing Director    | 49.7%      | Melhor   |
| Manager                   | 46.1%      | Bom      |
| Research Director         | 41.3%      | Moderado |
| Healthcare Representative | 38.9%      | Fraco    |
| Sales Executive           | 40.5%      | Moderado |
| Sales Representative      | 45.8%      | Bom      |
| Research Scientist        | 39.0%      | Fraco    |
| Lab Technician            | 32.8%      | Fraco    |
| Human Resources           | 30.8%      | Critico  |

> Evidencia: [G4](QUESTIONS.md#g4-qual-a-distribuicao-de-genero-por-jobrole)

### Gap Salarial - SURPRESA POSITIVA

**Global**: Mulheres ganham MAIS ($6,686 vs $6,380) = **-4.58%** a favor das mulheres

**Por cargo - Homens ganham mais:**
| Cargo | Gap | Significado |
|-------|-----|-------------|
| Research Director | +$1,513 | Homens ganham mais |
| Manager | +$494 | |
| Sales Executive | +$269 | |

**Por cargo - Mulheres ganham mais:**
| Cargo | Gap | Significado |
|-------|-----|-------------|
| Human Resources | -$440 | Mulheres ganham mais |
| Manufacturing Director | -$227 | |
| Research Scientist | -$171 | |

> Evidencia: [G5](QUESTIONS.md#g5-existe-gap-salarial-entre-generos)

### Outros Indicadores

| Indicador | Mulheres | Homens | Conclusao |
|-----------|----------|--------|-----------|
| Taxa Attrition | 14.8% | 17.0% | Mulheres saem menos |
| OverTime | 30.6% | 26.8% | Mulheres fazem MAIS |
| Anos desde promocao | 2.0 | 2.0 | Igual |

> Evidencia: [G6](QUESTIONS.md#g6-mulheres-tem-mais-ou-menos-overtime), [G7](QUESTIONS.md#g7-qual-a-taxa-de-attrition-por-genero)

### Conclusao Genero

- **Positivo**: Gap salarial favoravel as mulheres, menor attrition feminina
- **Atencao**: Glass ceiling no nivel Executive, meta 50% nao atingida em nenhum nivel
- **Critico**: HR e Lab Technician com representacao muito baixa de mulheres

---

## 2. Felicidade

### Resposta: "Somos felizes?" → MODERADAMENTE SATISFEITOS

**Indice de Felicidade Global: 2.73/4** → Classificacao: **SATISFEITOS** (limiar entre satisfeito e feliz)

### Niveis Medios de Satisfacao

| Indicador | Media (1-4) | % Alta/Muito Alta |
|-----------|-------------|-------------------|
| WorkLifeBalance | **2.76** (melhor) | 71.2% |
| JobSatisfaction | 2.73 | 61.3% |
| JobInvolvement | 2.73 | - |
| EnvironmentSatisfaction | 2.72 | 61.2% |
| RelationshipSatisfaction | **2.71** (pior) | - |

> Evidencia: [F1](QUESTIONS.md#f1-qual-o-nivel-medio-de-jobsatisfaction)

### Distribuicoes Chave

**WorkLifeBalance** (melhor indicador):
- 60.7% no nivel "Better" (3)
- Apenas 5.4% no nivel "Bad" (1)
- 71.2% nos niveis 3-4

> Evidencia: [F3](QUESTIONS.md#f3-qual-o-nivel-medio-de-worklifebalance)

**EnvironmentSatisfaction**:
- 61.2% nos niveis High/Very High
- 19.3% no nivel Low - quase 1 em cada 5

> Evidencia: [F2](QUESTIONS.md#f2-qual-o-nivel-medio-de-environmentsatisfaction)

### Por Departamento

| Departamento | Indice | Destaque |
|--------------|--------|----------|
| Human Resources | **2.77** (melhor) | Melhor em Relacoes (2.89) e WorkLife (2.92) |
| Sales | 2.74 | |
| R&D | **2.73** (pior) | Maior departamento (961 pessoas) |

**Nota**: Diferenca minima entre departamentos (0.04 pontos). HR surpreende como o mais feliz.

> Evidencia: [F4](QUESTIONS.md#f4-qual-departamento-tem-pior-satisfacao)

### Cargos Mais e Menos Felizes

| Mais Felizes | Indice | Menos Felizes | Indice |
|-------------|--------|---------------|--------|
| Manufacturing Dir. | 2.77 | Research Director | 2.69 |
| Manager | 2.76 | Lab Technician | 2.70 |
| Human Resources | 2.76 | Research Scientist | 2.72 |

### Factores de Influencia

**OverTime** (contra-intuitivo):
- Quem faz overtime: indice **2.79** (MAIS feliz)
- Quem nao faz: indice **2.71**
- Mas WorkLife pior (2.73 vs 2.77)

> Evidencia: [F5](QUESTIONS.md#f5-existe-correlacao-entre-satisfacao-e-overtime)

**MaritalStatus**:
- Solteiros mais satisfeitos com relacoes (2.78) e globalmente (2.76)
- Casados menos satisfeitos (relacoes 2.66, global 2.71)

> Evidencia: [F6](QUESTIONS.md#f6-relationshipsatisfaction-varia-por-maritalstatus)

**BusinessTravel**: Impacto minimo - diferencas de apenas 0.05 pontos

> Evidencia: [F7](QUESTIONS.md#f7-worklifebalance-varia-por-businesstravel)

**Anos sem Promocao**: Quem nao e promovido ha 5+ anos tem satisfacao mais baixa (2.63 vs media 2.73)

**Satisfacao vs Attrition**: Quem saiu tinha indice significativamente mais baixo (**2.55** vs 2.77 de quem ficou)

### Factores de Preocupacao

| Factor de Risco | Total | % |
|-----------------|-------|---|
| OverTime | 416 | 28.3% |
| Job Satisfaction "Low" | 289 | 19.7% |
| WorkLife Balance "Bad" | 80 | 5.4% |

### Conclusao Felicidade

- **Positivo**: Maioria satisfeita (61-71% com niveis altos), WLB e o melhor indicador
- **Atencao**: Indice global de 2.73 esta abaixo de 3.0 ("High") - espaco para melhoria
- **Critico**: 19.7% com satisfacao baixa, quem sai tem indice muito mais baixo (2.55)
- **Surpresas**: Overtime correlaciona com MAIS felicidade (nao menos); HR e o departamento mais feliz

---

## 3. Caracterizacao ("Quem Somos")

### Estrutura Organizacional

**Departamentos:**
| Departamento | Colaboradores | % |
|--------------|---------------|---|
| R&D | 961 | 65.4% |
| Sales | 446 | 30.3% |
| Human Resources | 63 | 4.3% |

> Evidencia: [C1](QUESTIONS.md#c1-qual-o-departamento-dominante)

**Piramide Hierarquica:**
| Nivel | Colaboradores | % |
|-------|---------------|---|
| 1 - Entry | 543 | 36.9% |
| 2 - Junior | 534 | 36.3% |
| 3 - Mid | 218 | 14.8% |
| 4 - Senior | 106 | 7.2% |
| 5 - Executive | 69 | 4.7% |

**Cargos mais comuns:**
1. Sales Executive (22.2%)
2. Research Scientist (19.9%)
3. Lab Technician (17.6%)

> Evidencia: [C8](QUESTIONS.md#c8-qual-a-distribuicao-por-jobrole)

### Demografia

**Faixas Etarias:**
| Faixa | Colaboradores | % |
|-------|---------------|---|
| 30-34 | 325 | 22.1% |
| 35-39 | 297 | 20.2% |
| 25-29 | 229 | 15.6% |
| 40-44 | 208 | 14.2% |
| 18-24 | 97 | 6.6% |
| 45-49 | 141 | 9.6% |
| 50-54 | 104 | 7.1% |
| 55-59 | 64 | 4.4% |
| 60+ | 5 | 0.3% |

> Evidencia: [C2](QUESTIONS.md#c2-qual-a-idade-media-e-distribuicao-etaria)

**Estado Civil:**
| Estado | % |
|--------|---|
| Casados | 45.8% |
| Solteiros | 32.0% |
| Divorciados | 22.2% |

> Evidencia: [C5](QUESTIONS.md#c5-qual-o-maritalstatus-mais-comum)

### Educacao

**Nivel de Formacao:**
| Nivel | % |
|-------|---|
| Bachelor | 38.9% |
| Master | 27.1% |
| College | 19.2% |
| Below College | 11.6% |
| Doctor | 3.3% |

> Evidencia: [C3](QUESTIONS.md#c3-qual-o-nivel-de-education-predominante)

**Areas de Formacao:**
| Area | % |
|------|---|
| Life Sciences | 41.2% |
| Medical | 31.6% |
| Marketing | 10.8% |
| Technical Degree | 9.0% |
| Human Resources | 1.8% |
| Other | 5.6% |

**Nota**: 69% dos colaboradores tem Bachelor ou superior - populacao altamente qualificada.

> Evidencia: [C4](QUESTIONS.md#c4-quais-as-areas-de-educationfield)

### Antiguidade

| Metrica | Valor |
|---------|-------|
| Media na empresa | 7 anos |
| Maximo na empresa | 40 anos |
| Experiencia total media | 11 anos |
| Empresas anteriores (media) | ~2.7 |
| Distancia de casa (media) | ~9 unidades |

> Evidencia: [C6](QUESTIONS.md#c6-quantas-empresas-anteriores-em-media-numcompaniesworked), [C7](QUESTIONS.md#c7-qual-a-distancia-media-de-casa-distancefromhome)

### Salarios

**Por Departamento:**
| Departamento | Salario Medio |
|--------------|---------------|
| Sales | $6,959 |
| HR | $6,654 |
| R&D | $6,281 |

**Por Nivel Hierarquico:**
| Nivel | Salario Medio |
|-------|---------------|
| 1 - Entry | $2,786 |
| 2 - Junior | $5,502 |
| 3 - Mid | $9,817 |
| 4 - Senior | $15,503 |
| 5 - Executive | $19,191 |

> Evidencia: [C9](QUESTIONS.md#c9-qual-o-salario-medio-por-departamentocargo)

---

## 4. Envelhecimento

### Visao Geral

| Metrica | Valor |
|---------|-------|
| Idade media | 36 anos |
| Desvio padrao | 9.14 |
| 55+ anos | **69 (4.7%)** |
| 60+ anos | 5 (0.3%) |
| 50+ anos (medio prazo) | 173 (11.8%) |
| Reformas nos proximos 5 anos | **0** (idade max = 60, reforma aos 67) |

> Evidencia: [E1](QUESTIONS.md#e1-quantos-colaboradores-tem-55-anos), [E2](QUESTIONS.md#e2-quantos-colaboradores-tem-60-anos)

### Distribuicao Geracional

| Geracao | Total | % |
|---------|-------|---|
| Gen Z (< 28) | 210 | 14.3% |
| **Millennials (28-43)** | **913** | **62.1%** |
| Gen X (44-59) | 342 | 23.3% |
| Baby Boomers (60+) | 5 | 0.3% |

Empresa dominada por Millennials (62.1%) - populacao jovem com folga para sucessao.

### Experiencia por Faixa Etaria

| Faixa | Media Anos Empresa | Media Experiencia Total |
|-------|--------------------|-----------------------|
| 18-29 | 4 | 4 |
| 30-39 | 6 | 9 |
| 40-49 | 8 | 15 |
| 50-59 | 9 | 21 |

> Evidencia: [E3](QUESTIONS.md#e3-qual-a-distribuicao-de-totalworkingyears), [E4](QUESTIONS.md#e4-quantos-anos-em-media-ficam-na-empresa)

### ALERTA: Cargo em Risco - Manager

| Cargo | 55+ | Jovens (<35) | Alerta |
|-------|-----|-------------|--------|
| **Manager** | **17 (16.7%)** | **7** | **RISCO: Mais seniores que jovens** |
| Healthcare Rep. | 11 (8.4%) | 36 | OK |
| Research Director | 6 (7.5%) | 13 | OK |

**Manager e o unico cargo com gap de sucessao**: 17 perto da reforma vs apenas 7 jovens.

> Evidencia: [E5](QUESTIONS.md#e5-quem-esta-perto-da-reforma-esta-em-cargos-criticos)

### Risco por Departamento (colaboradores 55+)

| Departamento | N (55+) | % 55+ | Seniores Nivel 4-5 |
|--------------|---------|-------|---------------------|
| R&D | 47 | 4.9% | 18 |
| Sales | 18 | 4.0% | 8 |
| HR | 4 | 6.3% | 3 |

**Perda de conhecimento**: 39 colaboradores 55+ com 20+ anos de experiencia

> Evidencia: [E6](QUESTIONS.md#e6-qual-o-risco-de-saida-em-massa-por-departamento)

### Attrition por Faixa Etaria

| Faixa | Taxa Attrition |
|-------|----------------|
| 18-29 | **27.9%** (mais alta) |
| 30-39 | 14.3% |
| 40-49 | **9.7%** (mais baixa) |
| 50+ | 13.3% |

**Nota**: O risco principal nao e a reforma dos seniores, mas a **saida dos jovens** (27.9% de attrition nos 18-29).

### Conclusao Envelhecimento

- **Risco BAIXO a curto prazo**: 0 reformas nos proximos 5 anos
- **Risco MEDIO a medio prazo**: 69 colaboradores (4.7%) com 55+
- **Risco ALTO em Managers**: Unico cargo com gap de sucessao (17 seniores vs 7 jovens)
- **Perda de conhecimento**: 39 seniores com 20+ anos de experiencia em risco
- **Paradoxo**: O maior risco demografico nao e a reforma, mas a attrition dos jovens (27.9%)

---

## 5. Attrition

### Visao Geral
- **Taxa global**: **16.1%** (237 saidas de 1470)
- Acima do benchmark tipico de 10-15%
- **164 colaboradores actuais** com 3+ factores de risco

> Evidencia: [A1](QUESTIONS.md#a1-qual-a-taxa-global-de-attrition)

### Por Departamento e Cargo

**Departamento**:
| Departamento | Taxa Attrition |
|--------------|----------------|
| Sales | **20.6%** |
| HR | 19.0% |
| R&D | 13.8% |

**Top 3 cargos mais criticos**:
| Cargo | Taxa |
|-------|------|
| Sales Representative | **39.8%** |
| Lab Technician | 23.9% |
| Human Resources | 23.1% |

**Cargos mais estaveis**: Manager (4.9%), Research Director (2.5%)

> Evidencia: [A2](QUESTIONS.md#a2-qual-departamento-perde-mais-pessoas)

### Perfil Comparativo: Quem Sai vs Quem Fica

| Metrica | Saiu | Ficou | Delta |
|---------|------|-------|-------|
| Idade media | 33.6 | 37.6 | **-4 anos** |
| Salario medio | $4,787 | $6,833 | **-$2,046** |
| % OverTime | 53.6% | 23.4% | **+30pp** |
| % Solteiros | 50.6% | 28.4% | **+22pp** |
| % Travel Freq. | 29.1% | 16.9% | +12pp |
| Satisfacao | 2.47 | 2.78 | -0.31 |
| Anos empresa | 5.1 | 7.4 | -2.3 |

**Perfil tipico de quem sai**: Jovem (~34), solteiro, salario baixo (~$4,787), faz overtime, viaja frequentemente, menos satisfeito.

> Evidencia: [A6](QUESTIONS.md#a6-qual-o-perfil-tipico-de-quem-sai)

### Top Factores de Risco (ordenados por impacto)

| # | Factor | Com Factor | Sem Factor | Multiplicador |
|---|--------|-----------|------------|----------------|
| 1 | **OverTime** | 30.5% | 10.4% | **3.0x** |
| 2 | **Salario < $3,000** | 28.6% | ~12% | 2.4x |
| 3 | **BusinessTravel Freq.** | 24.9% | 8.0% | 3.1x |
| 4 | **Solteiro** | 25.5% | ~11% | 2.3x |
| 5 | **Idade 18-24** | 39.2% | ~13% | 3.0x |
| 6 | **WLB "Bad"** | 31.3% | ~15% | 2.1x |
| 7 | **Job Satisfaction "Low"** | 22.8% | 11.3% | 2.0x |
| 8 | **Distancia 20+** | 22.1% | 13.8% | 1.6x |

> Evidencia: [A3](QUESTIONS.md#a3-quem-sai-tem-mais-overtime), [A4](QUESTIONS.md#a4-existe-padrao-de-satisfacao-em-quem-sai), [A7](QUESTIONS.md#a7-distancefromhome-correlaciona-com-attrition), [A8](QUESTIONS.md#a8-businesstravel-correlaciona-com-attrition)

### Promocoes e Attrition

| Anos sem Promocao | Taxa |
|-------------------|------|
| 0 (recente) | 18.9% |
| 1-2 | 14.7% |
| 3-5 | **10.1%** (mais baixa) |
| 5+ | 16.3% |

**Surpresa**: Quem foi promovido recentemente tem MAIS attrition (18.9%). Possivel explicacao: promocao tardia, ou colaboradores que recebem promocao antes de sair.

> Evidencia: [A5](QUESTIONS.md#a5-yearsssincelastpromotion-influencia-saidas)

### Conclusao Attrition

- **Critico**: Taxa de 16.1% acima do benchmark; Sales Rep com 39.8%
- **Top 3 factores**: OverTime (3x risco), BusinessTravel frequente (3.1x), Salario baixo (2.4x)
- **164 colaboradores actuais em risco** (3+ factores de risco simultaneos)
- **Perfil de risco**: Jovem, solteiro, mal pago, com overtime e viagens frequentes
- **Accao urgente**: Reduzir overtime em Sales e Lab Technician; rever politica salarial para salarios < $3,000

---

## 6. Questoes Adicionais do Grupo

### Descobertas Chave

| Questao | Resposta |
|---------|---------|
| JobRoles em multiplos departamentos? | Apenas **Manager** existe em 3 departamentos |
| Stock options exclusivas? | Nao - distribuicao uniforme (42.9% sem stock options) |
| Muita gente a dist. 1? | Sim - **208 (14.1%)** a 1 unidade de distancia |
| PerformanceRating so 3 e 4? | **Confirmado** - 84.6% Excellent (3), 15.4% Outstanding (4) |
| Conflito de geracoes? | **Nao** - satisfacao similar entre geracoes; Gen Z sai mais (28.1%) |
| Chefias masculinas? | Parcial - gestao intermediaria equilibrada, glass ceiling no topo (34.8%) |
| Experiencia vs felicidade? | Novos menos satisfeitos (2.59); estavel apos 1-2 anos |
| Rates vs Income? | MonthlyRate ($14,313) nao correlaciona com MonthlyIncome ($6,502) |
| Colunas constantes? | Over18, EmployeeCount, StandardHours - **confirmadas constantes** |

> Evidencia: [Q1-Q9](QUESTIONS.md#6-questoes-adicionais-do-grupo)

### Insights Relevantes

- **PerformanceRating e pouco discriminativo** - so usa 2 de 4 niveis, 84.6% sao "Excellent"
- **Manager e o unico cargo transversal** - presente em HR, R&D e Sales
- **Gen Z e o grupo de maior risco** - 28.1% de attrition, o dobro dos Millennials
- **Novos colaboradores precisam de atencao** - satisfacao mais baixa (2.59) nos primeiros meses

---

## Alertas e Recomendacoes

### Alertas (por prioridade)

1. **Sales Representative: 39.8% attrition** - quase 4 em cada 10 saem
   > Evidencia: [A2](QUESTIONS.md#a2-qual-departamento-perde-mais-pessoas)
2. **OverTime: 3x mais risco de saida** - 30.5% vs 10.4% de attrition
   > Evidencia: [A3](QUESTIONS.md#a3-quem-sai-tem-mais-overtime)
3. **Glass Ceiling**: Queda de 48.1% para 34.8% de mulheres entre nivel Senior e Executive
   > Evidencia: [G3](QUESTIONS.md#g3-qual-a-distribuicao-de-genero-por-joblevel)
4. **164 colaboradores em risco** actual (3+ factores de risco simultaneos)
   > Evidencia: [A6](QUESTIONS.md#a6-qual-o-perfil-tipico-de-quem-sai)
5. **Meta 50% genero nao atingida**: Nenhum departamento ou cargo atinge a meta
   > Evidencia: [G1](QUESTIONS.md#g1-qual-a-proporcao-homensmuiheres-global)
6. **Managers em risco de sucessao**: 17 seniores (55+) vs apenas 7 jovens (<35)
   > Evidencia: [E5](QUESTIONS.md#e5-quem-esta-perto-da-reforma-esta-em-cargos-criticos)
7. **Gen Z: 28.1% attrition** - saida massiva dos mais jovens
   > Evidencia: [Q5 adicional](QUESTIONS.md#q5-ha-conflito-de-geracoes)
8. **Satisfacao moderada (2.73/4)** - abaixo de "High" (3.0)
   > Evidencia: [F1](QUESTIONS.md#f1-qual-o-nivel-medio-de-jobsatisfaction)

### Pontos Positivos

1. **Gap salarial favoravel**: Mulheres ganham em media 4.58% mais
   > Evidencia: [G5](QUESTIONS.md#g5-existe-gap-salarial-entre-generos)
2. **Menor attrition feminina**: 14.8% vs 17% dos homens
   > Evidencia: [G7](QUESTIONS.md#g7-qual-a-taxa-de-attrition-por-genero)
3. **Populacao qualificada**: 69% com Bachelor ou superior
   > Evidencia: [C3](QUESTIONS.md#c3-qual-o-nivel-de-education-predominante)
4. **71.2% com bom WorkLifeBalance** (nivel 3-4)
   > Evidencia: [F3](QUESTIONS.md#f3-qual-o-nivel-medio-de-worklifebalance)
5. **0 reformas nos proximos 5 anos** - sem urgencia demografica
   > Evidencia: [E2](QUESTIONS.md#e2-quantos-colaboradores-tem-60-anos)
6. **Gestao intermediaria equilibrada em genero** (41-50% mulheres)
   > Evidencia: [Q6 adicional](QUESTIONS.md#q6-chefias-sao-mais-masculinas)

### Recomendacoes

**Prioridade Alta (Attrition)**:
1. Reduzir overtime obrigatorio, especialmente em Sales e Lab Technician
2. Rever politica salarial para colaboradores <$3,000/mes (28.6% de attrition)
3. Programa de retencao para Sales Representatives (39.8% de attrition)
4. Monitorizar os 164 colaboradores com 3+ factores de risco

**Prioridade Media (Genero)**:
5. Investigar barreiras a promocao de mulheres para nivel Executive
6. Programas de recrutamento focados em mulheres para Lab Technician e HR
7. Analisar causas do overtime elevado em mulheres (30.6% vs 26.8%)

**Prioridade Media (Retencao Jovens)**:
8. Programa de onboarding reforçado (novos colaboradores menos satisfeitos)
9. Programa de mentoring para Gen Z (28.1% de attrition)
10. Politica de viagens alternativa (Travel_Frequently: 24.9% attrition)

**Prioridade Baixa (Sucessao)**:
11. Plano de sucessao para cargo Manager (gap seniores vs jovens)
12. Programa de transferencia de conhecimento para os 39 seniores (55+, 20+ anos experiencia)

---

## Referencia Rapida: Queries por Tema

| Tema | Ficheiro SQL | Queries | Perguntas | Evidencia |
|------|--------------|---------|-----------|-----------|
| Caracterizacao | `03_analise_exploratoria.sql` | 18 | 9 (C1-C9) | [C1-C9](QUESTIONS.md#3-caracterizacao---quem-somos) |
| Genero | `04_analise_genero.sql` | 18 | 7 (G1-G7) | [G1-G7](QUESTIONS.md#1-igualdade-de-genero) |
| Felicidade | `05_analise_felicidade.sql` | 19 | 7 (F1-F7) | [F1-F7](QUESTIONS.md#2-felicidade) |
| Envelhecimento | `06_analise_envelhecimento.sql` | 17 | 6 (E1-E6) | [E1-E6](QUESTIONS.md#4-envelhecimento) |
| Attrition | `07_analise_attrition.sql` | 21 | 8 (A1-A8) | [A1-A8](QUESTIONS.md#5-attrition) |
| Adicional | `08_analise_adicional.sql` | 27 | 9 (Q1-Q9) | [Q1-Q9](QUESTIONS.md#6-questoes-adicionais-do-grupo) |
| **Total** | | **120** | **46** | **100% concluido** |
