---
name: pr-reviewer
description: Valida e revisa Pull Requests (PRs) e funcionalidades/trechos de código específicos em repositórios genéricos (NextJs, Java, Kotlin, GO, NodeJs, Express, Fastfy, etc.), focando em features, fixes e chores. A skill monta um plano de revisão de módulos afetados ou solicitados, gera um documento de análise baseado em SOLID, Sonarqube e qualidade de código, e produz um relatório detalhado com sugestões de melhoria e um planejamento de melhorias com checklist. Use esta skill para garantir a qualidade e conformidade do código em PRs e em funcionalidades/trechos de código avulsos.

Nota importante: não faça nenhuma alteração nos repositórios remotos do github, não altere os Pull Request, não faça commits, não adicione nenhum comentário automaticamente, a ação é somente de leitura no github remoto. Se necessário somente informe no documento de saída a necessidade destes comandos que deverão ser feitos manualmente pelo USER.


---

# PR Reviewer

## Visão Geral

Esta skill permite realizar uma revisão abrangente de Pull Requests e de funcionalidades ou trechos de código específicos, garantindo que o código desenvolvido siga as melhores práticas de engenharia de software. A análise abrange princípios SOLID, padrões de qualidade de código e potenciais problemas identificados por ferramentas como Sonarqube. O objetivo é fornecer um feedback detalhado e construtivo para aprimorar a qualidade do código antes da sua integração ou implementação.

## Workflow de Revisão de Código

O processo de revisão de código com esta skill segue os seguintes passos, adaptando-se ao tipo de entrada (Pull Request ou funcionalidade/trecho de código):

1. Antes de iniciar verifique quais trechos, commits ou PRs foram solicitados pelo usuário para identificar quais serão as analises da review. Para o caso de um Pull Request, procure sempre usar a CLI do github para não cair em discrepancias ou erros com o diff local. Se não conseguir acesso com a CLI do github avise o usuário USER. Verifque se já está instaldo e configurado a CLI do github em "c:\Program Files\GitHub CLI\gh.exe" e para mais informações consulte o manual em `references/cli-github-manual.md` na pasta de referencias da skill.

2.  **Seleção do Tipo de Revisão e Escopo:** O usuário deve especificar se a revisão é para um Pull Request (fornecendo a URL do PR e, opcionalmente, módulos/funcionalidades específicas) ou para uma funcionalidade/trecho de código (fornecendo o conteúdo do código e um contexto para a revisão).
O usuário também pode solicitar a revisão do código que se encontra em "Staged Changes" com a última versão commitada (HEAD) e neste caso pode usar o comando "git diff --staged" ou "git diff --cached"

    1.a) Se necessário acessar o repositório remoto utilize a CLI do github mas utilizar somente para efetuar leituras e não faça nenhuma alteração no repositório remoto.  
    
    1.b) caso necessite de mais detalhes ou operações especificas do github consulte as referencias `cli-github-repomix.xml` e `cli-github-manual.md` e solicite acesso e permissão para o <USER>, não faça nenhuma escrita ou commit sem o conhecimento do <USER> no github. Para as operações de leitura ou only-read pode fazer o acesso no github sem a necessidade de permissão. Utilze a CLI somente para efetuar leitura do tipo read-only e não faça nenhuma alteração no repositório remoto. Não aplique commits, comentários, ou crie algum artefato somente informe na saída do documento ou do chat a necessidade do usuário realizar a ação.

    1.c) antes de realizar qualque instalação do CLI verifique antes se já está instalado e configurado, por exemplo no diretório "c:\Program Files\GitHub CLI\gh.exe"

3.  **Análise Preliminar do Código:** Utiliza-se um script (`analyze_pr.py`) para simular a análise. Dependendo do tipo de revisão:
    *   **Para PRs:** Use a CLI do github para ler dados, por exemplo (gh pr diff <URL_DO_PR>) e outros comandos podem ser consultados na referencia `cli-github-manual.md`. Identifica`r arquivos alterados e sugerir áreas de foco (SOLID, Qualidade de Código, Sonarqube). Em uma implementação real, integraria com APIs de repositórios para obter diffs e metadados.
    *   **Para Funcionalidades/Trechos de Código:** Analisa o conteúdo fornecido, identificando potenciais problemas nas áreas de foco. Em uma implementação real, utilizaria ferramentas de análise estática de código (SAST) ou LLMs para avaliar o código.

4.  **Avaliação Detalhada por Critérios:** O código é avaliado com base em:
    *   **Princípios SOLID:** Verificação da aplicação dos princípios de Responsabilidade Única, Aberto/Fechado, Substituição de Liskov, Segregação de Interfaces e Inversão de Dependência.
    *   **Qualidade de Código:** Evitar números mágicos, evitar repetições, análise de legibilidade, manutenibilidade, complexidade, aderência a padrões de codificação e tratamento de erros.
    *   **Sonarqube (Simulado):** Identificação de code smells, bugs e vulnerabilidades com base em práticas comuns de análise estática.

5. **Sonarqube (Real no servidor):** Após identificar os diffs do código a ser analisado, tente utilizar também o sonarqube se a CLI estiver disponivel e habilitado. Use a CLI do sonarqube que está instalado na estação geralemnte em "C:\Users\user\AppData\Local\sonarqube-cli\bin\sonar.exe". Verifique se o usuário já configorou o login, se ainda não configurou avise o usuário se deseja se conectar, após autorização utilize os comandos para analisar os arquivos do diff, por exemplo com o comando "sonar verify --file src/auth.ts", se tiver mais dúvidas consulte os manuais que constam na referencia desta skill. Use a análise de qualidade, estática da CLI do sonarqube para complementar ainda mais o documento da review.

5.  **Geração do Relatório de Revisão:** No final criar um relatório detalhado que deverá ser gerado, descrevendo o objetivo de cada análise, os resultados encontrados e sugestões de melhoria específicas para o código revisado e procure utilizar o template definido em `\templates\review_report_template.md`. O relatório incluirá um **planejamento de melhorias com um checklist** para cada área de análise (SOLID, Qualidade de Código, Sonarqube), facilitando o acompanhamento e a implementação das recomendações. O relatório deverá ser salvo na pasta `docs/review_<nome ou descricao>_<nome do agente>.md`.

## Recursos da Skill

Esta skill utiliza os seguintes recursos para realizar a revisão de código:

### scripts/

-   `analyze_pr.py`: Um script Python que simula a análise de código. Ele foi atualizado para suportar dois modos de operação:
    *   **Modo PR:** Recebe a URL de um Pull Request e módulos específicos para revisão, retornando um resumo das mudanças e áreas de foco. Em um cenário real, este script seria expandido para interagir com APIs de plataformas de repositório (GitHub, GitLab, Bitbucket) para extrair informações reais do PR, como arquivos alterados, diffs e metadados.
    *   **Modo Funcionalidade/Trecho de Código:** Recebe o conteúdo do código e um contexto de revisão, retornando descobertas simuladas. Em um cenário real, ele poderia integrar com ferramentas de análise estática de código ou LLMs para obter métricas e identificar problemas automaticamente.


### templates/

-   `review_report_template.md`: Um template Markdown versátil utilizado para gerar o relatório final da revisão de código. Este template foi ajustado para se adaptar tanto a revisões de Pull Requests quanto a revisões de funcionalidades/trechos de código. Ele inclui seções para detalhes da revisão, sumário da análise, módulos afetados (para PRs) ou descobertas simuladas (para funcionalidades), e uma análise detalhada com sugestões de melhoria para cada critério (SOLID, Qualidade de Código, Sonarqube). O template também incorpora um planejamento de melhorias com checklists específicos para cada categoria, auxiliando na implementação e acompanhamento das ações corretivas. O template é preenchido dinamicamente com os resultados da análise para criar um relatório compreensível e acionável.


### references/

- `cli-github-repomix.xml`: utilize como referencia para ler o código repositório da CLI do github, consultar README e detalhes especificos da CLI do github. 
- `cli-github-manual.md`: utilize para consultar como usar a CLI do github para acessar os PRs e outras operações necessárias para o github.
- `cli-sonaqube-manual.md`: utilize para consultar todos os comandos da CLI sonarqube.
- `cli-sonaqueb-repomix.xml`: utilizr para consultar detalhes mais especificos da CLI sonarqube.