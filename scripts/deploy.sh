#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f railways-demo-images.tar.gz ]; then
  echo "Файл railways-demo-images.tar.gz не найден. Распакуйте bundle или запустите package.sh."
  exit 1
fi

if [ ! -f docker-compose.runtime.yml ]; then
  echo "Файл docker-compose.runtime.yml не найден."
  exit 1
fi

echo "==> Загрузка Docker-образов..."
gunzip -c railways-demo-images.tar.gz | docker load

echo "==> Запуск приложения..."
docker compose -f docker-compose.runtime.yml up -d

echo ""
echo "Приложение запущено: http://localhost:8080"
echo "Остановка: docker compose -f docker-compose.runtime.yml down"
