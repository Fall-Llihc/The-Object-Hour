# 🚀 Quick Start - The Object Hour

## Untuk Teman-Teman Tim 

**Cara tercepat run project tanpa setup NetBeans/Ant!**

### Yang Dibutuhkan:
- Docker Desktop (https://www.docker.com/products/docker-desktop)
- Git

### 3 Langkah Simple:

#### 1. Clone & Setup Database
```bash
git clone <repo-url>
cd The-Object-Hour
```

**Setup Database Configuration:**

1. Copy environment file:
```bash
cp .env.example .env
```

2. Edit `.env` file dengan kredensial Supabase Anda:
```properties
DB_URL=jdbc:postgresql://YOUR_HOST:5432/postgres?sslmode=require
DB_USER=YOUR_DATABASE_USER  
DB_PASSWORD=YOUR_DATABASE_PASSWORD
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
```

3. **ATAU** edit file `src/java/config/db.properties` (alternatif):
```properties
db.url=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
db.user=postgres.xgpzjbssvucrbzfglolt
db.password=TheObjectHour123
```

#### 2. Build & Run (Satu perintah!)
```bash
docker compose up -d --build
```

Tunggu 2-3 menit untuk pertama kali (download + build otomatis)

#### 3. Buka Browser
```
http://localhost:8080/PBO-Project
```

**DONE! ✅**

---

## Keuntungan Pakai Docker:

✅ **Tidak perlu install:**
- NetBeans
- Apache Ant
- Tomcat
- Setup Java lokal

✅ **Semua settingan sama** - tidak peduli OS atau konfigurasi laptop

✅ **Build otomatis** - Docker build WAR dari source code

✅ **Portable** - bisa jalan di laptop siapapun yang punya Docker

---

## Command Berguna:

```bash
# Lihat log
docker compose logs -f

# Restart
docker compose restart

# Stop
docker compose down

# Rebuild setelah edit code
docker compose down && docker compose up -d --build
```

---

## Troubleshooting

### Port 8080 sudah dipakai?
Edit `docker-compose.yml`, ganti ke port lain:
```yaml
ports:
  - "8081:8080"  # Akses via localhost:8081
```

### Database error?
- Cek Supabase dashboard, pastikan database tidak di-pause
- Cek credentials di `db.properties` sudah benar
- Restart: `docker compose restart`

---

**Need help?** Lihat [SETUP-DOCKER-LENGKAP.md](SETUP-DOCKER-LENGKAP.md) untuk panduan detail.
