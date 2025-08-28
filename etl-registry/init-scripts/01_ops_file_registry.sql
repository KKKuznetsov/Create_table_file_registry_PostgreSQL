-- Схема
CREATE SCHEMA IF NOT EXISTS ops;

-- Таблица реестра файлов (TIMESTAMPTZ)
CREATE TABLE IF NOT EXISTS ops.file_registry (
    id              BIGSERIAL PRIMARY KEY,
    file_path       TEXT NOT NULL,
    uploaded_at     TIMESTAMPTZ NOT NULL,
    status          TEXT NOT NULL CHECK (status IN ('NEW','PROCESSING','ERROR','CREATED','DELETE')),
    data_provider   TEXT NOT NULL CHECK (data_provider IN ('Сеть','Дистрибьютор')),
    report_year     SMALLINT NOT NULL CHECK (report_year >= 2000),
    report_month    SMALLINT NOT NULL CHECK (report_month BETWEEN 1 AND 12),
    client_name     TEXT NOT NULL,
    report_type     TEXT NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    error_reason    TEXT
);

-- Антидубли
CREATE UNIQUE INDEX IF NOT EXISTS uq_file_registry_file_path
  ON ops.file_registry(file_path);

-- Индексы под типовые запросы
CREATE INDEX IF NOT EXISTS idx_file_registry_status
  ON ops.file_registry(status);

CREATE INDEX IF NOT EXISTS idx_file_registry_status_uploaded
  ON ops.file_registry(status, uploaded_at);

CREATE INDEX IF NOT EXISTS idx_file_registry_provider
  ON ops.file_registry(data_provider);

CREATE INDEX IF NOT EXISTS idx_file_registry_period
  ON ops.file_registry(report_year, report_month);

CREATE INDEX IF NOT EXISTS idx_file_registry_client
  ON ops.file_registry(client_name);

-- Частичный индекс «свежие NEW»
CREATE INDEX IF NOT EXISTS idx_file_registry_new_uploaded
  ON ops.file_registry(uploaded_at) WHERE status = 'NEW';