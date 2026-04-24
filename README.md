# YouTube Sharing App — Backend

Rails 7.2 API · Ruby 3.1.3 · PostgreSQL 16 · Redis 7 · Sidekiq · ActionCable

---

## Prerequisites

| Tool | Version |
|------|---------|
| Ruby | 3.1.3 |
| Bundler | >= 2.x |
| PostgreSQL | 16 |
| Redis | 7 |
| Docker & Docker Compose | latest (optional) |

---

## Environment Variables

Copy `.env.example` to `.env` and fill in the values:

```bash
cp .env.example .env
```

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | PostgreSQL host | `localhost` |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_USERNAME` | PostgreSQL user | `postgres` |
| `DB_PASSWORD` | PostgreSQL password | `postgres` |
| `REDIS_URL` | Redis connection URL | `redis://localhost:6379/0` |
| `RAILS_ENV` | Rails environment | `development` |
| `SECRET_KEY_BASE` | Rails secret key | *(generate below)* |
| `CORS_ORIGINS` | Allowed frontend origins (comma-separated) | `http://localhost:5173` |

Generate a secret key:
```bash
bundle exec rails secret
```

---

## Run with Docker (recommended)

```bash
cp .env.example .env        # chỉnh SECRET_KEY_BASE nếu cần
docker compose up --build
```

Starts: **PostgreSQL → Redis → Rails API (port 3000) → Sidekiq**.  
DB được tạo và migrate tự động lần đầu boot.

---

### Các lệnh Docker hay dùng

```bash
# Xem logs
docker compose logs -f backend
docker compose logs -f sidekiq

# Chạy Rails console
docker compose exec backend bundle exec rails console

# Chạy migration thủ công
docker compose exec backend bundle exec rails db:migrate

# Chạy tests trong container
docker compose exec backend bundle exec rspec

# Dừng tất cả services
docker compose down

# Dừng và xóa volumes (reset DB)
docker compose down -v
```

---

## Run Locally (without Docker)

> PostgreSQL and Redis must be running on your machine.

### 1. Install dependencies

```bash
bundle install
```

### 2. Setup database

```bash
bundle exec rails db:create db:migrate
# Optional seed data:
bundle exec rails db:seed
```

### 3. Start Rails server

```bash
bundle exec rails server
# API available at http://localhost:3000
```

### 4. Start Sidekiq (separate terminal)

```bash
bundle exec sidekiq -C config/sidekiq.yml
```

---

## Run Tests

```bash
bundle exec rspec
```

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/api/v1/auth/register` | Register new user |
| `POST` | `/api/v1/auth/login` | Login, returns JWT |
| `DELETE` | `/api/v1/auth/logout` | Logout |
| `GET` | `/api/v1/videos` | List shared videos |
| `POST` | `/api/v1/videos` | Share a YouTube video |
| `WS` | `/cable` | ActionCable endpoint (real-time notifications) |

---

## Lint & Security

```bash
# Rubocop
bundle exec rubocop

# Brakeman security scan
bundle exec brakeman
```
