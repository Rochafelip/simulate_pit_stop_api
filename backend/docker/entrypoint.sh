#!/bin/bash
set -e

echo "🔧 Limpando PID antigo..."
rm -f /app/tmp/pids/server.pid

echo "🛠️ Preparando banco de dados..."
bundle exec rails db:prepare

if [ "$RUN_SEEDS" = "true" ]; then
  echo "🌱 Rodando seeds..."
  bundle exec rails db:seed
fi

echo "🚀 Iniciando servidor Rails..."
exec bundle exec rails server -b 0.0.0.0 -p 3000
