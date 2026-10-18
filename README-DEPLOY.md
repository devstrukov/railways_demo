# Деплой на другую Ubuntu-машину

Полный стек (PostgreSQL + backend + frontend) упакован в Docker-образы. На целевой машине нужны только **Docker Engine** и **Docker Compose plugin**. Java и Node **не требуются**.

## Что входит в bundle

- `railways-demo-images.tar.gz` — Docker-образы (postgres:18, backend, frontend/nginx)
- `docker-compose.runtime.yml` — описание сервисов (только готовые образы)
- `railway_aggregator_new.sql` и init-скрипт PostgreSQL
- `scripts/deploy.sh` — скрипт загрузки и запуска

## Сборка bundle (на машине разработки)

```bash
./scripts/package.sh
```

Результат: `railways-demo-bundle.tar.gz`

## Установка на целевой Ubuntu

### 1. Установить Docker (если ещё не установлен)

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2
sudo usermod -aG docker $USER
# перелогиниться или: newgrp docker
```

### 2. Распаковать и запустить

```bash
mkdir railways-demo && cd railways-demo
tar xzf /path/to/railways-demo-bundle.tar.gz
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

Или вручную:

```bash
gunzip -c railways-demo-images.tar.gz | docker load
docker compose -f docker-compose.runtime.yml up -d
```

### 3. Открыть приложение

http://localhost:8080

При первом запуске PostgreSQL автоматически создаст роль `test` и импортирует дамп.

## Управление

```bash
# Статус
docker compose -f docker-compose.runtime.yml ps

# Логи
docker compose -f docker-compose.runtime.yml logs -f

# Остановка
docker compose -f docker-compose.runtime.yml down

# Полная очистка (включая данные БД)
docker compose -f docker-compose.runtime.yml down -v
```

## Порты

| Сервис | Порт на хосте |
|---|---|
| Frontend (nginx) | 8080 |
| Backend | только внутри Docker-сети |
| PostgreSQL | только внутри Docker-сети |

## Проверка после деплоя

```bash
curl http://localhost:8080/api/users
curl http://localhost:8080/api/bookings
```

Ожидается JSON с 5 пользователями и 7 бронированиями.
