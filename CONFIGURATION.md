# Configuration Management

## Centralized Configuration System

The Object Hour menggunakan sistem konfigurasi terpusat di mana semua pengaturan database dan Supabase dikelola melalui:

1. **File `.env`** - Untuk Docker dan environment variables
2. **File `src/java/config/db.properties`** - Untuk konfigurasi aplikasi Java

### Quick Setup

#### 1. Setup Environment Variables (.env)
```bash
# Copy file example
cp .env.example .env

# Edit .env dengan kredensial Anda
nano .env
```

#### 2. Edit Konfigurasi Database (db.properties)
```bash
# Edit file properties
nano src/java/config/db.properties
```

### Configuration Files

#### `.env` (Root directory)
```properties
# Database Configuration
DB_URL=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
DB_USER=postgres.xgpzjbssvucrbzfglolt
DB_PASSWORD=TheObjectHour123
DB_DRIVER=org.postgresql.Driver

# Supabase Storage Configuration
SUPABASE_URL=https://xgpzjbssvucrbzfglolt.supabase.co
SUPABASE_SERVICE_KEY=your_service_key_here
SUPABASE_BUCKET=Gambar Jam
```

#### `src/java/config/db.properties`
```properties
# PostgreSQL Supabase Database Configuration
db.url=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
db.user=postgres.xgpzjbssvucrbzfglolt
db.password=TheObjectHour123
db.driver=org.postgresql.Driver

# Supabase Storage configuration
supabase.url=https://xgpzjbssvucrbzfglolt.supabase.co
supabase.service.key=your_service_key_here
supabase.bucket=Gambar Jam
```

### How It Works

#### 1. Java Applications
- Menggunakan `config.SupabaseConfig` class untuk load konfigurasi
- Prioritas: `db.properties` → Environment Variables → Default values
- File yang menggunakan: `Product.java`, `QuickTest.java`, dll.

#### 2. Docker Containers
- Menggunakan environment variables dari `.env` file
- Docker Compose otomatis load `.env` file
- File yang menggunakan: `Dockerfile`, `docker-compose.yml`

### Changing Database

**To change database, simply edit one of these files:**

#### Option 1: Edit `.env` file (Recommended for Docker)
```bash
nano .env
# Update DB_URL, DB_USER, DB_PASSWORD, SUPABASE_URL
```

#### Option 2: Edit `db.properties` (For local development)  
```bash
nano src/java/config/db.properties
# Update db.url, db.user, db.password, supabase.url
```

### Files That Use Centralized Config

#### ✅ **Centralized (Good):**
- `src/java/config/JDBC.java` - Uses properties + env vars
- `src/java/model/Product.java` - Uses `SupabaseConfig` 
- `src/java/test/QuickTest.java` - Uses properties + env vars
- `Dockerfile` - Uses env vars
- `docker-compose.yml` - Uses `.env` file

#### ⚠️ **Documentation Only:**
- `README.md` - Contains example configurations
- `QUICK-START.md` - References central config
- `SETUP-DOCKER-LENGKAP.md` - References central config

### Benefits

1. **Single Source of Truth**: Change database in one place
2. **Environment Flexibility**: Different configs for dev/prod
3. **Security**: Sensitive data in `.env` (not committed to git)
4. **Docker Ready**: Works seamlessly with containers
5. **Maintainability**: No hardcoded values scattered across files

### Troubleshooting

#### Config Not Loading?
1. Check if `.env` file exists and readable
2. Check if `src/java/config/db.properties` exists
3. Verify file paths and syntax
4. Check console for error messages

#### Docker Issues?
1. Ensure `.env` file is in same directory as `docker-compose.yml`
2. Rebuild containers: `docker compose up --build`
3. Check container logs: `docker compose logs`

#### Still Hardcoded Values?
Run this command to check for any remaining hardcoded database URLs:
```bash
grep -r "jdbc:postgresql\|supabase\.co" --include="*.java" src/
```