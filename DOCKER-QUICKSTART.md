# 🚀 Quick Start with Docker

## Untuk Teman yang Pertama Kali Jalankan:

### 1️⃣ Install Docker Desktop
Download dan install: https://www.docker.com/products/docker-desktop

**Pastikan Docker Desktop sudah running** (icon Docker di system tray berwarna hijau)

### 2️⃣ Clone Project
```bash
git clone <repository-url>
cd The-Object-Hour
```

### 3️⃣ Setup Database Configuration (PENTING!)

**A. Dapatkan Kredensial Supabase:**
1. Login ke https://supabase.com/dashboard
2. Pilih project Anda
3. Klik **Settings** → **Database**
4. Di **Connection String**, pilih **Session pooler** atau **Transaction pooler**
5. Copy informasi:
   - Host (contoh: `aws-1-ap-south-1.pooler.supabase.com`)
   - Port (biasanya `5432`)
   - Database name (biasanya `postgres`)
   - User (format: `postgres.xxxxx`)
   - Password

**B. Edit file `src/java/config/db.properties`:**
```bash
# Windows: notepad src/java/config/db.properties
# Mac/Linux: nano src/java/config/db.properties
```

Isi dengan kredensial Supabase yang baru didapat:
```properties
# PostgreSQL Supabase Database Configuration
db.url=jdbc:postgresql://HOST_ANDA:5432/postgres
db.user=USER_ANDA
db.password=PASSWORD_ANDA
db.driver=org.postgresql.Driver
```

**C. Setup file `.env` untuk Docker:**
```bash
# Copy file example
cp .env.example .env

# Edit .env dan isi password yang sama
# Windows: notepad .env
# Mac/Linux: nano .env
```

Isi file `.env`:
```
DB_PASSWORD=PASSWORD_ANDA_YANG_SAMA_DENGAN_DB_PROPERTIES
```

### 4️⃣ Build WAR File Lokal
**PENTING: Harus build WAR dulu sebelum Docker!**

```bash
# Pastikan punya Java 17 dan Ant terinstall
# Atau gunakan NetBeans untuk build

ant clean dist
```

File `dist/PBO-Project.war` akan dibuat. **Ini yang akan di-copy ke Docker container.**

### 5️⃣ Build Docker Image
```bash
docker compose build
```

Tunggu 1-2 menit untuk download base image.

### 6️⃣ Jalankan Container
```bash
docker compose up -d
```

### 7️⃣ Tunggu Tomcat Start (10-15 detik)
```bash
# Cek log untuk memastikan Tomcat sudah ready
docker compose logs -f
# Tekan Ctrl+C untuk keluar dari log
```

Tunggu sampai muncul: `Server startup in ... milliseconds`

### 8️⃣ Buka Browser
```
http://localhost:8080/PBO-Project
```

**SELESAI! 🎉**

---

## Perintah Berguna

```bash
# Lihat log
docker-compose logs -f

# Stop aplikasi
docker-compose stop

# Start lagi
docker-compose start

# Restart
docker-compose restart

# Rebuild (setelah edit code)
docker-compose down
docker-compose up -d --build
```

## ⚠️ Troubleshooting

### Database Connection Error / No Products
**Gejala:** Aplikasi jalan tapi tidak ada data product

**Solusi:**
1. Pastikan database Supabase **tidak paused** (cek dashboard)
2. Pastikan kredensial di `db.properties` benar
3. Test koneksi database:
   ```bash
   java -cp "build/web/WEB-INF/classes:lib/*" test.TestDatabaseConnection
   ```
4. Restart container:
   ```bash
   docker compose restart
   ```

### Port 8080 sudah dipakai?
Edit `docker-compose.yml`, ganti `8080:8080` jadi `8081:8080`

### Build error?
```bash
docker compose down
docker compose build --no-cache
docker compose up -d
```

### Lupa build WAR?
**Error:** `failed to compute cache key ... "/dist/PBO-Project.war": not found`

**Solusi:**
```bash
# Build WAR dulu
ant clean dist

# Baru build Docker
docker compose build
```

### Perubahan code tidak keliatan?
Setiap kali edit code, harus rebuild:
```bash
ant clean dist
docker compose down
docker compose build
docker compose up -d
```

## 📝 Checklist Sebelum Run Docker

- [ ] Docker Desktop sudah running
- [ ] File `src/java/config/db.properties` sudah diisi kredensial Supabase
- [ ] File `.env` sudah dibuat dan diisi password database
- [ ] Kredensial Supabase sudah dicek valid
- [ ] Database Supabase tidak dalam status paused
- [ ] WAR file sudah di-build dengan `ant clean dist`
- [ ] File `dist/PBO-Project.war` sudah ada

**Dokumentasi lengkap ada di [README-Docker.md](README-Docker.md)**
