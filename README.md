# Projeto C2S_Auth

Este é um projeto de microserviços de web scraping simples em Ruby on Rails.
Abaixo estão as instruções para configurar o ambiente, instalar as dependências e acessar a documentação das APIs.

## Requisitos

- **Ruby** 2.7.5 (linguagem de programação usada)
- **Rails** 7.0.8 (framework web usado)
- **MySql** (banco de dados usado)
- **Docker e Docker Compose** (opcional, mas recomendado para gerenciamento de ambiente)
- **Node.js e Yarn** (para gerenciamento de pacotes de front-end)

## Instalação

1. **Instale as dependências:**

   ```bash
   bundle install
   yarn install
   ```

2. **Configure o banco de dados:**

   Crie e migre o banco de dados PostgreSQL:

   ```bash
   rails db:create
   rails db:migrate
   ```
4. **Configure o arquivo `.env`:**

   Crie um arquivo `.env` na raiz do projeto com a seguinte chave:

   ```
   URL_MS_NOTIFICATION=http://localhost:3002
   ```
   A chave `URL_MS_NOTIFICATION` será usada para acessar as APIs do microserviço de notificação.
   ```
   URL_MS_TASK=http://localhost:3000
   ```
   A chave `URL_MS_TASK` será usada para acessar as APIs do microserviço de tarefas.


## Executando o Servidor

Depois que as dependências estiverem instaladas e o banco de dados configurado, você pode iniciar o servidor Rails com o comando:

```bash
rails server -p 3003  
```

Acesse o aplicativo no navegador em `http://localhost:3003`.

## Documentação das APIs

A documentação das APIs do projeto pode ser acessada através do Swagger. O Swagger está configurado para exibir as rotas e os métodos das APIs em uma interface amigável.

1. **Acesse a documentação em:**

   ```
   http://localhost:3003/api-docs
   ```

   Aqui, você encontrará todas as rotas da API disponíveis, incluindo os endpoints dos microserviços de autenticação, notificações e web scraping.

2. **Testes e Desenvolvimento:**

   Durante o desenvolvimento, você pode adicionar ou atualizar os endpoints, e a documentação será atualizada automaticamente.

## Testes

O projeto inclui testes para os microserviços e funcionalidades internas. Para rodar os testes, execute:

```bash
rspec
```

## Contribuição

Se desejar contribuir com este projeto, siga estas etapas:

1. Faça um fork do repositório
2. Crie uma nova branch (`git checkout -b feature/sua-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Envie sua branch (`git push origin feature/sua-feature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

Se precisar de mais detalhes ou ajustes, estou à disposição!