# Usar uma imagem base oficial do Ruby
FROM ruby:2.7.5

# Instalar dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client build-essential libxml2-dev libxslt1-dev
# Instalar dependências do sistema
RUN apt-get update -qq && apt-get install -y \
  firefox-esr \
  wget \
  xvfb \
  libgtk-3-0 \
  libdbus-glib-1-2 \
  libasound2 \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  nodejs

# Instalar o GeckoDriver (driver para o Firefox)
RUN wget -q https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz \
    && tar -xzf geckodriver-v0.30.0-linux64.tar.gz \
    && mv geckodriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/geckodriver

# Configurar o diretório de trabalho dentro do container
WORKDIR /app

# Copiar o Gemfile e Gemfile.lock para o container
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Instalar as gems necessárias
RUN bundle install

# Copiar o código da aplicação
COPY . /app

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

# Expor a porta que o Rails utilizará
EXPOSE 3003

# Comando padrão para iniciar o servidor do Rails
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
