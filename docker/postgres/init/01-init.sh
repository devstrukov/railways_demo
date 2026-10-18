#!/bin/bash
set -euo pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER test WITH PASSWORD 'test' SUPERUSER;
    CREATE DATABASE railway_aggregator OWNER test;
EOSQL

psql -v ON_ERROR_STOP=1 --username test --dbname railway_aggregator \
    -f /dump/railway_aggregator_new.sql
