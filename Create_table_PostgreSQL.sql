CREATE SCHEMA IF NOT EXISTS ops;

CREATE TABLE ops.file_registry (
    id              BIGSERIAL PRIMARY KEY,
    file_path       TEXT NOT NULL,              -- Полный или относительный путь к файлу на SFTP
    uploaded_at     TIMESTAMP NOT NULL,         -- Дата/время, когда файл был выложен на SFTP
    status          TEXT NOT NULL CHECK (status IN ('NEW', 'PROCESSING', 'PROCESSED', 'ERROR')),
    data_provider   TEXT NOT NULL CHECK (data_provider IN ('Сеть', 'Дистрибьютор')),
    report_year     SMALLINT NOT NULL CHECK (report_year >= 2000),
    report_month    SMALLINT NOT NULL CHECK (report_month BETWEEN 1 AND 12),
    client_name     TEXT NOT NULL,
    report_type     TEXT NOT NULL,              -- Закупки, продажи, остатки и т.д.
    
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индексы для ускорения поиска
CREATE INDEX idx_file_registry_status ON ops.file_registry(status);
CREATE INDEX idx_file_registry_provider ON ops.file_registry(data_provider);
CREATE INDEX idx_file_registry_period ON ops.file_registry(report_year, report_month);
CREATE INDEX idx_file_registry_client ON ops.file_registry(client_name);
