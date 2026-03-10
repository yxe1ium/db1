DROP DATABASE IF EXISTS hosting_db;
CREATE DATABASE hosting_db OWNER postgres ENCODING 'UTF8';
\c hosting_db;

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    company VARCHAR(100),
    address TEXT,
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE zones (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE domains (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    zone_id INT REFERENCES zones(id),
    name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    reg_date DATE NOT NULL,
    expire_date DATE NOT NULL,
    UNIQUE(name, zone_id)
);

CREATE TABLE dns (
    id SERIAL PRIMARY KEY,
    domain_id INT REFERENCES domains(id) ON DELETE CASCADE,
    type VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    value TEXT NOT NULL,
    priority INT
);

CREATE TABLE plans (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    disk_mb INT NOT NULL,
    bandwidth_mb INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE hosting (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    plan_id INT REFERENCES plans(id),
    domain_id INT REFERENCES domains(id),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    number VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created TIMESTAMP DEFAULT NOW(),
    paid_at TIMESTAMP
);

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES invoices(id),
    client_id INT REFERENCES clients(id),
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(50),
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'open',
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE ssl (
    id SERIAL PRIMARY KEY,
    domain_id INT REFERENCES domains(id),
    client_id INT REFERENCES clients(id),
    expire_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active'
);

CREATE INDEX idx_domains_client ON domains(client_id);
CREATE INDEX idx_domains_expire ON domains(expire_date);
CREATE INDEX idx_invoices_client ON invoices(client_id);
