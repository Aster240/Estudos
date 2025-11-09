# Backend - Projeto 1: Sistema de Gerenciamento de Matrículas

Este repositório contém o código backend para o **Projeto 1 da disciplina de Banco de Dados (BDOO)**.

O objetivo principal é desenvolver o backend e o banco de dados para um sistema completo de gerenciamento acadêmico , aplicando conceitos avançados de Views, Stored Procedures, Triggers e Transações.

## 🎯 Sobre o Projeto (Contexto da Atividade)

O sistema foi projetado para gerenciar todas as facetas da vida acadêmica, incluindo:

  * Alunos, Professores e Cursos 
  * Turmas, Matrículas e Históricos 
  * Logs de Operações e Auditoria 

A implementação do banco de dados foca em garantir a integridade dos dados e automatizar processos acadêmicos <mark style="background-color:#DB5461">através de regras de negócio complexas implementadas diretamente no banco.</mark>

-----

## 🚀 Configuração do Ambiente (Backend)

Siga os passos abaixo para configurar e executar o ambiente de desenvolvimento Python.

### 1\. Pré-requisitos

  * [Python 3.8+](https://www.python.org/downloads/)
  * Um SGBD (como MySQL ou MariaDB) em execução.

### 2\. Clonar o Repositório

```bash
git clone [URL_DO_SEU_REPOSITORIO]
cd Estudos/backend
```

### 3\. Criar e Ativar o Ambiente Virtual (venv)

Recomenda-se o uso de um ambiente virtual para <mark style="background-color:#DB5461">isolar as dependências do projeto.

```bash
# Criar o ambiente virtual
python3 -m venv venv
```

**Para ativar o venv:**

  * **No Windows (CMD ou PowerShell):**

    ```powershell
    .\venv\Scripts\activate
    ```

  * **No macOS ou Linux (Bash/Zsh):**

    ```bash
    source venv/bin/activate
    ```

Você saberá que funcionou pois o nome `(venv)` aparecerá no início do seu prompt de terminal.

### 4\. Instalar as Dependências

Com o ambiente ativado, instale os pacotes Python necessários:

```bash
pip install mysql-connector-python python-dotenv
```

-----

## ⚙️ Variáveis de Ambiente

Para que o script Python possa se conectar ao banco de dados, você precisa configurar as variáveis de ambiente.

1.  Na pasta `backend/`, crie um arquivo chamado `.env`.
2.  Copie e cole o conteúdo abaixo no arquivo `.env`, **ajustando os valores** para corresponder à sua configuração local do banco de dados.

<!-- end list -->

```.env
# Configuração do Banco de Dados
DB_HOST=localhost
DB_USER=root
DB_PASS=SUA_SENHA_AQUI
DB_NAME=entrega_final_grupo05
```

> **Nota:** O arquivo `.env` nunca deve ser enviado para o repositório (ele deve estar no seu `.gitignore`).

-----

## Configuração do Banco de Dados (SQL)

O backend Python se conecta a um banco de dados que deve ser previamente criado e populado usando o script SQL principal do projeto.

1.  Inicie seu serviço de SGBD (MySQL, MariaDB, etc.).
2.  Crie um banco de dados com o nome que você definiu em `DB_NAME` (ex: `entrega_final_grupo05`).
3.  Execute o arquivo SQL principal (ex: `projeto_grupo_X.sql` ) para criar todas as tabelas, views, procedures e triggers

-----

## 📦Entregáveis do Projeto

Conforme a especificação da atividade, os entregáveis finais deste projeto são:

1.  **Arquivo SQL Completo (`projeto_grupo_X.sql`):** 

      * Contém DDL, DML (se houver), Views, Stored Procedures, Funções e Triggers
      * Deve ser autoexecutável em um banco de dados limpo
2.  **Relatório PDF (`relatorio_grupo_X.pdf`):** 

      * DER completo e descrição das tabelas
      * Explicação detalhada da lógica de procedures, funções e triggers
      * Prints dos testes e logs de execução