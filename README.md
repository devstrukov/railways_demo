# Лабораторная №3 — Железнодорожный агрегатор

Учебное приложение для работы с PostgreSQL-базой железнодорожного агрегатора: ленточная форма пользователей, табличная форма бронирований, сложная форма с подчинёнными билетами и печатный отчёт.

## Требования

| Компонент | Версия |
|---|---|
| Java | 21 |
| Node.js | 22 |
| npm | 10+ |
| PostgreSQL | 18 |
| Docker + Compose | для учебной БД и переносимого деплоя |

## Структура проекта

```
frontend/   — React + TypeScript + Redux Toolkit + Vite + Bootstrap
backend/    — Java 21 + Spring Boot + JDBC
docker/     — init-скрипт PostgreSQL
scripts/    — упаковка и деплой bundle
```

### Frontend-стек

- **TypeScript** — все компоненты в `.tsx`, типы API в `src/types/`
- **Redux Toolkit** — состояние в `src/store/` (ui, users, bookings, bookingDetail)
- **React 18** — функциональные компоненты с `useAppSelector` / `useAppDispatch`

## 1. Учебная база данных в Docker

Запуск PostgreSQL 18 на порту **5433** (не конфликтует с локальным PostgreSQL):

```bash
docker compose up -d postgres
```

При первом запуске дамп [`railway_aggregator_new.sql`](railway_aggregator_new.sql) импортируется автоматически через init-скрипт.

### Ручной импорт в новую пустую базу

```bash
docker compose up -d postgres

PGPASSWORD=postgres psql -h localhost -p 5433 -U postgres -v ON_ERROR_STOP=1 \
  -c "CREATE USER test WITH PASSWORD 'test' SUPERUSER;" \
  -c "CREATE DATABASE railway_aggregator OWNER test;"

PGPASSWORD=test psql -h localhost -p 5433 -U test -d railway_aggregator \
  -v ON_ERROR_STOP=1 -f railway_aggregator_new.sql
```

> Импорт выполняется **один раз** для новой базы. Не запускайте его при каждом старте приложения.

### Подключение к уже существующей БД

Скопируйте `.env.example` и задайте переменные окружения перед запуском backend:

```bash
cp .env.example .env
export $(grep -v '^#' .env | xargs)
```

Spring Boot **не читает** `.env` автоматически — передайте переменные через `export`, IDE Run Configuration или systemd.

## 2. Запуск backend (локально)

```bash
cd backend
./mvnw spring-boot:run
```

Переменные окружения (значения по умолчанию):

| Переменная | По умолчанию |
|---|---|
| `DB_HOST` | `localhost` |
| `DB_PORT` | `5433` |
| `DB_NAME` | `railway_aggregator` |
| `DB_USER` | `test` |
| `DB_PASSWORD` | `test` |
| `SERVER_PORT` | `8080` |

Backend: http://localhost:8080

## 3. Запуск frontend (локально)

```bash
cd frontend
npm install
npm run dev
```

Frontend: http://localhost:5173 (прокси `/api` → backend `:8080`)

## Соответствие требованиям лабораторной

| Элемент | Реализация |
|---|---|
| Ленточная форма «Пользователи» | `UsersTab.tsx` — горизонтальные полосы, state в `usersSlice` |
| Табличная форма «Бронирования» | `BookingsTab.tsx` — HTML-таблица, state в `bookingsSlice` |
| Сложная форма «Подробное бронирование» | `BookingDetailTab.tsx` — форма + билеты, state в `bookingDetailSlice` |
| Печатный отчёт | `PrintReport.tsx` — A4, `window.print()`, данные из Redux |
| API | 7 эндпоинтов в `backend/`, JDBC без JPA |

## Сценарий скринкаста

1. Вкладка «Пользователи» — изменить email/телефон, нажать «Сохранить», обновить страницу.
2. Вкладка «Бронирования» — показать таблицу, нажать «Открыть».
3. «Подробное бронирование» — изменить статус и сумму, сохранить.
4. Переключить бронирование в списке — показать смену билетов (№7 — «Билетов нет»).
5. «Печатный отчёт» → предварительный просмотр печати браузера.

## Перенос на другую машину

См. [`README-DEPLOY.md`](README-DEPLOY.md) — полный Docker-стек без Java/Node на целевой Ubuntu.
