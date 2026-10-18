#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Сборка Docker-образов..."
docker compose -f docker-compose.deploy.yml build

echo "==> Экспорт образов..."
IMAGES="postgres:18 railways_demo-backend:latest railways_demo-frontend:latest"
docker save $IMAGES | gzip > railways-demo-images.tar.gz

echo "==> Формирование bundle..."
tar czf railways-demo-bundle.tar.gz \
  railways-demo-images.tar.gz \
  docker-compose.runtime.yml \
  railway_aggregator_new.sql \
  docker/postgres/init/01-init.sh \
  scripts/deploy.sh \
  README-DEPLOY.md

echo "Готово: $ROOT_DIR/railways-demo-bundle.tar.gz"
