#!/bin/bash
set -e

# Iniciar o Xvfb para rodar sem display
Xvfb :99 -screen 0 1024x768x16 &

# Definir o display para o Xvfb
export DISPLAY=:99

# Executar o comando principal passado para o container
exec "$@"
