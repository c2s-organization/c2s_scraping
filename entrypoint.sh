#!/bin/bash
set -e

Xvfb :99 -screen 0 1024x768x16 &

# Definir o display para o Xvfb
export DISPLAY=:99

# Criar o banco de dados, se não existir
bundle exec rails db:create

# Executar as migrações
bundle exec rails db:migrate

# Remover PID antigo do servidor (se necessário)
rm -f /app/tmp/pids/server.pid

# Iniciar o servidor Rails
exec bundle exec rails s -b '0.0.0.0'

