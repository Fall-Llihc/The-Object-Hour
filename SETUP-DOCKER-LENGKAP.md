# 🐳 Docker Setup - The Object Hour
## Panduan Lengkap untuk Teman yang Akan Menjalankan Project

---

## 📋 Yang Dibutuhkan

1. **Docker Desktop** - Download di https://www.docker.com/products/docker-desktop
2. **Kredensial Supabase** - Database connection details
3. **Git** - Untuk clone project

**TIDAK PERLU:**
- ❌ NetBeans
- ❌ Apache Ant  
- ❌ Tomcat lokal
- ❌ Setup Java lokal

**Docker akan build semuanya otomatis!** 🎉

---

## 🚀 Step-by-Step Installation

### STEP 1: Install Docker Desktop
- Download dan install Docker Desktop
- **Start Docker Desktop** dan pastikan icon di system tray berwarna hijau
- Test Docker sudah jalan:
  ```bash
  docker --version
  docker compose version
  ```

### STEP 2: Clone Project
```bash
git clone <repository-url>
cd The-Object-Hour
```

### STEP 3: Setup Database Configuration ⚠️ PENTING!

**A. Dapatkan Kredensial Supabase:**
1. Login ke https://supabase.com/dashboard
2. Pilih project "The Object Hour"
3. Klik **Settings** → **Database**
4. Di **Connection String**, pilih **Session pooler**
5. Copy informasi ini:
   ```
   Host: aws-1-ap-southeast-1.pooler.supabase.com
   Port: 5432
   Database: postgres
   User: postgres.xgpzjbssvucrbzfglolt
   Password: TheObjectHour123
   ```

**B. Edit File `src/java/config/db.properties`:**
```bash
# Windows
notepad src\java\config\db.properties

# Mac/Linux
nano src/java/config/db.properties
```

Isi dengan kredensial Supabase:
```properties
# PostgreSQL Supabase Database Configuration
db.url=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
db.user=postgres.xgpzjbssvucrbzfglolt
db.password=TheObjectHour123
db.driver=org.postgresql.Driver
```

**GANTI dengan kredensial milikmu!**

**C. Setup File `.env` untuk Docker:**
```bash
# Copy file example
cp .env.example .env

# Edit .env
# Windows: notepad .env
# Mac/Linux: nano .env
```

Isi file `.env`:
```
DB_PASSWORD=ObjectHour123
```

**Password harus SAMA dengan di db.properties!**

### STEP 4: Build dan Jalankan dengan Docker 🐳

**Satu perintah untuk build dan run!**

```bash
docker compose up -d --build
```

Perintah ini akan:
1. ✅ Download dependencies
2. ✅ Install Apache Ant di dalam Docker
3. ✅ Build WAR file dari source code
4. ✅ Deploy ke Tomcat
5. ✅ Start aplikasi

**Tunggu 2-3 menit** untuk pertama kali (download image + build)

### STEP 5: Cek Status Container
```bash
# Lihat status
docker compose ps

# Harus muncul:
# NAME              STATUS
# the-object-hour   Up X seconds
```

### STEP 6: Tunggu Build Selesai (2-3 menit pertama kali)
```bash
# Lihat progress build
docker compose logs -f

# Tunggu sampai muncul:
# "BUILD SUCCESSFUL"
# "Server startup in XXX milliseconds"
# "Database configuration loaded"

# Tekan Ctrl+C untuk exit
```

### STEP 7: Buka Aplikasi! 🎉
```
http://localhost:8080/PBO-Project
```

Jika berhasil, akan muncul:
- ✅ Home page dengan hero section
- ✅ Products page dengan 17 produk jam tangan
- ✅ Filter categories dan brands
- ✅ Shopping cart functionality

---

## ⚠️ Troubleshooting

### Problem: No Products / Database Error

**Gejala:** Aplikasi jalan tapi tidak ada data product

**Solusi:**
1. **Cek database tidak paused:**
   - Buka Supabase Dashboard
   - Jika ada tombol "Resume", klik untuk aktifkan

2. **Restart container:**
   ```bash
   docker compose restart
   ```

3. **Cek log untuk error:**
   ```bash
   docker compose logs --tail=50
   ```

### Problem: Port 8080 Sudah Dipakai

**Error:** "port is already allocated"

**Solusi:** Edit `docker-compose.yml`, ganti port:
```yaml
ports:
  - "8081:8080"  # Akses via localhost:8081
```

### Problem: WAR File Not Found

**Error:** "dist/PBO-Project.war: not found"

**Solusi:**
```bash
# Build WAR dulu!
ant clean dist

# Baru build Docker
docker compose build
```

### Problem: Perubahan Code Tidak Muncul

Setiap edit code, rebuild Docker:
```bash
docker compose down
docker compose up -d --build
```

**Tidak perlu build WAR manual!** Docker akan build otomatis.

---

## 📖 Perintah Docker Berguna

```bash
# Lihat status container
docker compose ps

# Lihat log real-time
docker compose logs -f

# Stop aplikasi
docker compose stop

# Start lagi
docker compose start

# Restart container
docker compose restart

# Stop dan hapus container
docker compose down

# Rebuild image
docker compose build --no-cache

# Lihat container yang jalan
docker ps

# Masuk ke dalam container
docker exec -it the-object-hour bash
```

---

## ✅ Checklist Sebelum Mulai

- [ ] Docker Desktop installed dan running
- [ ] File `src/java/config/db.properties` sudah diisi
- [ ] File `.env` sudah dibuat dan diisi
- [ ] Database Supabase tidak paused
- [ ] Port 8080 tidak dipakai
- [ ] Koneksi internet stabil

**Jika semua ✅, silakan mulai dari STEP 4!**

**TIDAK PERLU:**
- ❌ Build WAR manual
- ❌ Install NetBeans/Ant
- ❌ Setup Java lokal

---

## 📚 Dokumentasi Lengkap

- [DOCKER-QUICKSTART.md](DOCKER-QUICKSTART.md) - Panduan super cepat
- [README-Docker.md](README-Docker.md) - Dokumentasi detail lengkap

---

## 🆘 Need Help?

Jika ada masalah:
1. Cek log: `docker compose logs -f`
2. Cek status: `docker compose ps`
3. Test database: `java -cp "build/web/WEB-INF/classes:lib/*" test.TestDatabaseConnection`
4. Restart: `docker compose restart`

**Good luck! 🚀**
