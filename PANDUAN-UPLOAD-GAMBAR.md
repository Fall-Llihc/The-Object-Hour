# 📸 Panduan Upload Gambar Produk ke Supabase Storage

## Status Saat Ini
⚠️ **Gambar produk belum di-upload ke Supabase Storage**

Saat ini halaman products sudah siap menampilkan gambar, tapi karena gambar belum di-upload ke Supabase Storage bucket "Gambar Jam", maka yang muncul adalah **fallback icon** (ikon jam).

## URL Format
```
https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/{Nama_Produk}.png
```

## Daftar Gambar yang Harus Di-Upload

Berdasarkan produk di database, berikut file yang harus di-upload:

| No | Nama File | Product Name |
|----|-----------|--------------|
| 1 | `Apple Watch 5.png` | Apple Watch 5 |
| 2 | `Apple Watch Pro.png` | Apple Watch Pro |
| 3 | `Elegant Leather Tan.png` | Elegant Leather Tan |
| 4 | `Minimalist Black.png` | Minimalist Black |
| 5 | `Smart Pro Titanium.png` | Smart Pro Titanium |
| 6 | `Retro Classic Gold.png` | Retro Classic Gold |
| 7 | `Urban Sport Red.png` | Urban Sport Red |
| 8 | `Active Fit Blue.png` | Active Fit Blue |
| 9 | `Luxe Mesh Rose Gold.png` | Luxe Mesh Rose Gold |
| 10 | `Casio G-Shock GA-2100.png` | Casio G-Shock GA-2100 |
| 11 | `Casio Classic Leather Brown.png` | Casio Classic Leather Brown |
| 12 | `Samsung Galaxy Watch 6.png` | Samsung Galaxy Watch 6 |
| 13 | `Samsung Galaxy Fit 2.png` | Samsung Galaxy Fit 2 |
| 14 | `Xiaomi Watch S1.png` | Xiaomi Watch S1 |
| 15 | `Xiaomi Mi Band 8.png` | Xiaomi Mi Band 8 |
| 16 | `Xiaomi Smart Band 7 Pro.png` | Xiaomi Smart Band 7 Pro |
| 17 | `DanielW Slim Mesh Silver.png` | DanielW Slim Mesh Silver |

⚠️ **PENTING**: 
- Nama file **HARUS PERSIS** seperti nama produk di database
- Gunakan **SPASI**, bukan underscore atau dash
- **Case-sensitive** - huruf besar/kecil harus sama
- Ekstensi file: **`.png`** (lowercase)

## Langkah-Langkah Upload ke Supabase Storage

### 1. Login ke Supabase Dashboard
```
https://supabase.com/dashboard
```

### 2. Pilih Project
- Klik project: **The Object Hour**
- URL: `https://ykdfyoirtmkscsygyedr.supabase.co`

### 3. Buka Storage
- Di sidebar kiri, klik **"Storage"**
- Pilih bucket: **"Gambar Jam"**

### 4. Upload Files
Untuk setiap produk:
1. Klik tombol **"Upload file"**
2. Pilih file gambar (pastikan nama file sesuai tabel di atas)
3. Klik **"Upload"**

### 5. Set Public Access (Jika Bucket Baru)
Jika bucket "Gambar Jam" baru dibuat:
1. Klik bucket "Gambar Jam"
2. Klik ⚙️ **"Bucket Settings"**
3. Pastikan **"Public bucket"** = ✅ ON
4. Save

### 6. Verify Upload
Test URL gambar di browser:
```
https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/Apple%20Watch%205.png
```

Jika berhasil → Gambar muncul  
Jika gagal → Error 404 atau 400

## Alternatif: Bulk Upload via Supabase CLI

### Install Supabase CLI
```bash
npm install -g supabase
```

### Login
```bash
supabase login
```

### Upload Multiple Files
```bash
# Contoh: upload semua PNG dari folder local
for file in /path/to/images/*.png; do
  supabase storage cp "$file" gambar-jam/
done
```

## Spesifikasi Gambar

### Rekomendasi:
- **Format**: PNG (dengan transparent background)
- **Ukuran**: 800x800px (square/persegi)
- **File size**: Maksimal 500KB - 1MB
- **Background**: Transparent atau putih bersih
- **Compression**: Gunakan [TinyPNG](https://tinypng.com) untuk optimize

### Sumber Gambar:
1. **AI Generated**: Midjourney, DALL-E, Stable Diffusion
2. **Stock Photos**: Unsplash, Pexels (cari "luxury watch")
3. **Product Mockups**: Placeit, Smartmockups
4. **Manual Design**: Figma, Photoshop

## Testing Setelah Upload

### 1. Clear Browser Cache
```
Ctrl + Shift + R (Windows/Linux)
Cmd + Shift + R (Mac)
```

### 2. Test di Browser
```
http://localhost:8080/PBO-Project/products
```

### 3. Check Developer Console
- Tekan `F12`
- Tab **Console** - cek error
- Tab **Network** - filter "png" - cek status code (harus 200 OK)

### 4. Verify Image Load
Jika berhasil:
- ✅ Gambar produk muncul
- ✅ Hover effect scale works
- ✅ No console errors

Jika gagal:
- ❌ Icon fallback muncul (watch icon)
- ⚠️ Console error: "Failed to load resource: 404"

## Troubleshooting

### ❌ Error 400 Bad Request
**Penyebab**: URL encoding issue atau bucket name salah  
**Solusi**: 
- Pastikan bucket name persis: `Gambar Jam` (dengan spasi)
- Cek URL di browser: `%20` untuk spasi

### ❌ Error 404 Not Found
**Penyebab**: File belum di-upload atau nama file salah  
**Solusi**:
- Verify nama file di Storage dashboard
- Re-upload dengan nama yang benar

### ❌ Error 403 Forbidden
**Penyebab**: Bucket masih private  
**Solusi**:
- Set bucket menjadi public
- Atau setup RLS (Row Level Security) policy

### ⚠️ Gambar Tidak Muncul, Icon Fallback Muncul
**Status**: **NORMAL** - ini behavior yang benar saat gambar belum di-upload  
**Aksi**: Upload gambar sesuai panduan

### 🔍 Gambar Blur / Low Quality
**Solusi**:
- Upload gambar dengan resolusi lebih tinggi (min 800x800px)
- Pastikan file tidak ter-compress terlalu banyak

## Quick Test - Sample Product

Untuk testing cepat, upload 1 gambar dulu:

1. Download sample watch image:
   - Google: "apple watch png transparent"
   - Save as: `Apple Watch 5.png`

2. Upload ke Supabase Storage bucket "Gambar Jam"

3. Refresh page: http://localhost:8080/PBO-Project/products

4. Product "Apple Watch 5" seharusnya sudah tampil gambar

## Script untuk Generate Sample Images

Jika tidak punya gambar, bisa pakai placeholder API sementara:

```javascript
// Script Node.js untuk download placeholder
const products = [
  "Apple Watch 5",
  "Apple Watch Pro",
  "Elegant Leather Tan",
  // ... (list lengkap)
];

products.forEach(name => {
  const url = `https://via.placeholder.com/800x800.png/667eea/ffffff?text=${encodeURIComponent(name)}`;
  // Download dan save dengan nama produk + .png
});
```

## Next Steps

1. ✅ **Setup bucket "Gambar Jam"** di Supabase (jika belum)
2. ✅ **Set bucket ke public**
3. 📥 **Upload 1 sample image** untuk test
4. 🧪 **Verify** gambar muncul di http://localhost:8080/PBO-Project/products
5. 📸 **Upload remaining images** (16 lainnya)
6. 🎉 **Done!**

---

**Questions?** Check [IMAGES-SETUP.md](./IMAGES-SETUP.md) untuk technical details.
