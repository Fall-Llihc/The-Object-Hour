# Docker Setup - The Object Hour

Dokumentasi untuk menjalankan aplikasi **The Object Hour** menggunakan Docker.

## 📋 Prerequisites

Yang perlu diinstall di komputer teman Anda:
- **Docker Desktop** ([Download disini](https://www.docker.com/products/docker-desktop))
  - Windows: Docker Desktop for Windows
  - Mac: Docker Desktop for Mac  
  - Linux: Docker Engine

**Hanya itu!** Tidak perlu install Java, Tomcat, atau tool lainnya.

## 🚀 Cara Menjalankan (Pertama Kali)

### 1. Clone/Download Project
```bash
git clone <repository-url>
cd The-Object-Hour
```

### 2. Setup Database Configuration (CRITICAL!)

**PENTING:** File `db.properties` **HARUS** diisi sebelum build WAR!

**A. Dapatkan Kredensial Supabase:**

1. Login ke https://supabase.com/dashboard
2. Pilih project Anda (misal: "The Object Hour")
3. Klik menu **Settings** (gear icon) → **Database**
4. Scroll ke bagian **Connection String**
5. Pilih mode **Session pooler** atau **Transaction pooler**
6. Copy detail koneksi:
   - **Host**: `aws-X-ap-south-1.pooler.supabase.com`
   - **Port**: `5432` (Session mode) atau `6543` (Transaction mode)
   - **Database**: `postgres`
   - **User**: `postgres.xxxxxxxxxxxxx`
   - **Password**: (klik "Show password")

**CATATAN:** Pastikan database **tidak dalam status paused**! Jika paused, klik "Resume" di dashboard.

**B. Edit File Database Properties:**

```bash
# Buka file db.properties
nano src/java/config/db.properties
# atau di Windows: notepad src/java/config/db.properties
```

Isi dengan kredensial yang baru didapat:
```properties
# PostgreSQL Supabase Database Configuration
db.url=jdbc:postgresql://aws-1-ap-south-1.pooler.supabase.com:5432/postgres
db.user=postgres.ykdfyoirtmkscsygyedr
db.password=ObjectHour123
db.driver=org.postgresql.Driver
```

**Ganti** nilai `db.url`, `db.user`, dan `db.password` dengan milik Anda!

### 3. Setup Environment Variables untuk Docker

```bash
# Copy file example
cp .env.example .env

# Edit file .env
nano .env  # Linux/Mac
# atau: notepad .env  # Windows
```

Isi file `.env` dengan **password database yang sama**:
```
DB_PASSWORD=ObjectHour123
```

⚠️ **JANGAN COMMIT FILE `.env` KE GIT!** (sudah di-gitignore)

### 4. Build WAR File Lokal

**Docker menggunakan WAR file yang sudah di-build**, bukan build dari source di dalam container.

```bash
# Pastikan Java 17 dan Apache Ant terinstall
# Atau gunakan NetBeans untuk build

ant clean dist
```

Setelah sukses, file `dist/PBO-Project.war` akan dibuat.

**Jika `ant` tidak terinstall:**
- **Windows/Mac/Linux dengan NetBeans**: Buka project di NetBeans, klik kanan project → "Clean and Build"
- **Install Ant manual**: 
  ```bash
  # Ubuntu/Debian
  sudo apt install ant
  
  # Mac
  brew install ant
  ```

### 5. Build Docker Image

```bash
docker compose build
```

Perintah ini akan:
- ✅ Download base image Tomcat 9.0.112 + JDK 17
- ✅ Copy WAR file ke image
- ✅ Setup environment variables

**Tunggu 1-2 menit** untuk build pertama kali (download ~500MB).

### 6. Jalankan Container

```bash
docker compose up -d
```

Flag `-d` = detached mode (jalan di background)

### 7. Verifikasi Container Running

```bash
# Cek status
docker compose ps

# Output yang diharapkan:
# NAME              IMAGE                 STATUS
# the-object-hour   the-object-hour-app   Up X seconds
```

### 8. Tunggu Tomcat Startup (10-15 detik)

```bash
# Lihat log startup
docker compose logs -f

# Tunggu sampai muncul:
# "Server startup in XXX milliseconds"
# Tekan Ctrl+C untuk exit
```

### 9. Test Database Connection

```bash
# Dari dalam container
docker exec -it the-object-hour bash -c "cd /usr/local/tomcat && tail -50 logs/catalina.out | grep -i 'Database configuration'"

# Harus muncul: "Database configuration loaded from environment variables"
```

### 10. Akses Aplikasi

Buka browser:
```
http://localhost:8080/PBO-Project
```

Jika berhasil, Anda akan melihat:
- ✅ Home page dengan hero section
- ✅ Products page dengan 17 produk jam tangan
- ✅ Filter berdasarkan kategori dan brand
- ✅ Cart functionality

**SELESAI! 🎉**

## 📖 Perintah Docker Penting

### Melihat Status Container
```bash
docker-compose ps
```

### Melihat Log Aplikasi
```bash
# Lihat semua log
docker-compose logs

# Lihat log real-time (tekan Ctrl+C untuk stop)
docker-compose logs -f

# Lihat log 100 baris terakhir
docker-compose logs --tail=100
```

### Stop Aplikasi
```bash
docker-compose stop
```

### Start Aplikasi (setelah di-stop)
```bash
docker-compose start
```

### Restart Aplikasi
```bash
docker-compose restart
```

### Stop dan Hapus Container
```bash
docker-compose down
```

### Rebuild Aplikasi (setelah edit code)
```bash
# Stop container
docker-compose down

# Rebuild dan start ulang
docker-compose up -d --build
```

## 🔧 Troubleshooting

### Database Connection Error / No Products
**Gejala:** Aplikasi jalan tapi tidak ada data, atau error "Tenant or user not found"

**Penyebab:**
1. Database Supabase dalam status **paused** (hemat resource)
2. Kredensial database salah atau expired
3. Network issue

**Solusi:**
1. **Cek status database:**
   - Buka Supabase Dashboard → Project → Settings → Database
   - Jika ada tombol "Resume", klik untuk aktifkan database
   
2. **Verifikasi kredensial:**
   ```bash
   # Test koneksi dari local (butuh Java)
   java -cp "build/web/WEB-INF/classes:lib/*" test.TestDatabaseConnection
   ```
   
3. **Restart container:**
   ```bash
   docker compose restart
   # Tunggu 10 detik
   docker compose logs -f
   ```

4. **Jika masih error, rebuild:**
   ```bash
   # Update db.properties dengan kredensial baru
   nano src/java/config/db.properties
   
   # Update .env
   nano .env
   
   # Rebuild WAR
   ant clean dist
   
   # Rebuild Docker
   docker compose down
   docker compose build
   docker compose up -d
   ```

### Port 8080 Sudah Dipakai
**Error:** "Bind for 0.0.0.0:8080 failed: port is already allocated"

**Solusi:**
```bash
# Edit docker-compose.yml, ganti port:
ports:
  - "8081:8080"  # Akses via localhost:8081
```

### Build Error: WAR File Not Found
**Error:** `failed to compute cache key ... "/dist/PBO-Project.war": not found`

**Penyebab:** Belum build WAR file lokal

**Solusi:**
```bash
# Build WAR dulu
ant clean dist

# Pastikan file ada
ls -lh dist/PBO-Project.war

# Baru build Docker
docker compose build
```

### Perubahan Code Tidak Muncul
Setiap kali edit source code:
```bash
# 1. Rebuild WAR
ant clean dist

# 2. Stop container
docker compose down

# 3. Rebuild image
docker compose build

# 4. Start ulang
docker compose up -d
```

### Container Exit/Crash
```bash
# Lihat error log
docker compose logs --tail=100

# Cek container status
docker compose ps
```

## 📦 Struktur File Docker

```
The-Object-Hour/
├── Dockerfile              # Instruksi build image
├── docker-compose.yml      # Konfigurasi container
├── .dockerignore          # File yang di-exclude saat build
├── .env                   # Environment variables (jangan di-commit!)
├── .env.example           # Template untuk .env
└── README-Docker.md       # Dokumentasi ini
```hecklist Sebelum Run Docker

Pastikan semua ini sudah dilakukan:

### Pre-requisites:
- [ ] Docker Desktop terinstall dan **running**
- [ ] Java 17 terinstall (untuk build WAR)
- [ ] Apache Ant terinstall atau NetBeans IDE

### Files Configuration:
- [ ] File `src/java/config/db.properties` sudah dibuat dan diisi kredensial Supabase
- [ ] File `.env` sudah dibuat (copy dari `.env.example`)
- [ ] Password di `.env` sama dengan di `db.properties`

### Database:
- [ ] Sudah punya project Supabase
- [ ] Database **tidak dalam status paused**
- [ ] Kredensial database sudah dicek valid (test dengan TestDatabaseConnection)
- [ ] Ada data products di database (minimal 1 product untuk test)

### Build:
- [ ] WAR file sudah di-build: `ant clean dist`
- [ ] File `dist/PBO-Project.war` sudah ada dan tidak error

### Network:
- [ ] Port 8080 tidak dipakai aplikasi lain
- [ ] Koneksi internet stabil (untuk akses Supabase)

**Jika semua checklist ✅, lanjut ke build dan run Docker!**-docker.sh
```

2. **Upload project ke server**
```bash
# Via Git
git clone <repo-url>
cd The-Object-Hour

# Atau via SCP/SFTP
scp -r The-Object-Hour/ user@server:/path/to/app/
```

3. **Setup dan jalankan**
```bash
cp .env.example .env
nano .env  # Isi password

docker-compose up -d
```

4. **Setup domain (opsional)**
   - Install Nginx sebagai reverse proxy
   - Setup SSL dengan Let's Encrypt
   - Point domain ke port 8080

## ⚙️ Spesifikasi Container

- **Base Image**: Tomcat 9.0.112 + JDK 17
- **Build Tool**: Apache Ant
- **Database**: Supabase PostgreSQL (eksternal)
- **JDBC Driver**: PostgreSQL 42.7.3
- **Port**: 8080

## 📝 Catatan Penting

1. **Database**: Aplikasi tetap menggunakan Supabase PostgreSQL, tidak ada database lokal
2. **Perubahan Code**: Setiap kali edit code, harus rebuild: `docker-compose up -d --build`
3. **Logs**: Selalu cek logs jika ada masalah: `docker-compose logs -f`
4. **Performance**: Build pertama lama (2-3 menit), build berikutnya lebih cepat karena cache
5. **Cleanup**: Untuk hapus semua image dan free disk space:
   ```bash
   docker system prune -a
   ```

## 🤝 Support

Jika ada masalah:
1. Cek logs: `docker-compose logs`
2. Cek status: `docker-compose ps`
3. Restart: `docker-compose restart`
4. Rebuild: `docker-compose up -d --build`

## 📚 Dokumentasi Lengkap

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Tomcat Docker Hub](https://hub.docker.com/_/tomcat)
