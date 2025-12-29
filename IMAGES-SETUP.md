# Product Images Setup - Supabase Storage

## Overview
Gambar produk jam ditampilkan dari **Supabase Storage** bucket bernama **"Gambar Jam"** (public).

## URL Pattern
```
https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/{product_name}.png
```

## Konvensi Penamaan File
- **Nama file** = **Nama produk** (persis dari kolom `product.name` di database) + ekstensi **".png"**
- Spasi dalam nama produk akan otomatis di-encode menjadi `%20` di URL
- Contoh:
  - Product name: `Casio Classic Leather Brown`
  - File name: `Casio Classic Leather Brown.png`
  - URL: `https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/Casio%20Classic%20Leather%20Brown.png`

## Implementasi

### 1. Product Model
File: `src/java/model/Product.java`

Method `getImageUrl()` ditambahkan untuk generate URL gambar:
```java
public String getImageUrl() {
    String baseUrl = "https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/";
    String encodedName = this.name.replace(" ", "%20");
    return baseUrl + encodedName + ".png";
}
```

### 2. JSP Pages
Gambar ditampilkan di:
- ✅ **products.jsp** - Halaman daftar produk
- ✅ **cart.jsp** - Halaman keranjang belanja
- ✅ **products-bootstrap-old.jsp** - Versi lama halaman produk
- ✅ **cart-old.jsp** - Versi lama halaman cart

Contoh implementasi di JSP:
```jsp
<img src="${product.imageUrl}" 
     alt="${product.name}"
     class="w-full h-full object-cover"
     onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">

<!-- Fallback Icon jika gambar gagal load -->
<div style="display:none;" class="fallback-icon">
    <i class="bi bi-watch text-6xl text-blue-400"></i>
</div>
```

## Fallback Mechanism
Jika gambar **gagal dimuat** (error 404 atau network error):
- Image element akan di-hide (`display: none`)
- Icon fallback akan ditampilkan (Bootstrap Icons)
- Icon berbeda untuk setiap tipe:
  - **ANALOG** → `bi-watch` (biru)
  - **DIGITAL** → `bi-stopwatch` (ungu)
  - **SMARTWATCH** → `bi-smartwatch` (hijau)

## Upload Gambar ke Supabase Storage

### Step-by-Step:
1. Login ke [Supabase Dashboard](https://supabase.com/dashboard)
2. Pilih project: **The Object Hour**
3. Klik **Storage** di sidebar kiri
4. Pilih bucket: **Gambar Jam**
5. Upload gambar dengan nama **persis sama** dengan nama produk + `.png`
6. Pastikan file di-set sebagai **public**

### Naming Rules:
- ✅ **BENAR**: `Casio Classic Leather Brown.png`
- ❌ **SALAH**: `casio-classic-leather-brown.png`
- ❌ **SALAH**: `Casio_Classic_Leather_Brown.png`
- ✅ Gunakan **spasi**, bukan underscore atau dash
- ✅ **Case-sensitive** - huruf besar/kecil harus persis sama

## Daftar Produk yang Butuh Gambar
Berdasarkan database saat ini (17 produk):

1. Apple Watch 5.png
2. Apple Watch Pro.png
3. Casio Classic Leather Brown.png
4. Casio G-Shock GA-2100.png
5. DanielW Slim Mesh Silver.png
6. Elegant Leather Tan.png
7. Minimalist Black.png
8. Rolex Submariner.png
9. Samsung Galaxy Fit 2.png
10. Samsung Galaxy Watch 6.png
11. Smart Pro Titanium.png
12. Sport Blue Strap.png
13. Vintage Brown Leather.png
14. Xiaomi Mi Band 8.png
15. Xiaomi Smart Band 7 Pro.png
16. Xiaomi Watch S1.png
17. ... (dan seterusnya sesuai database)

## Testing
Untuk test apakah gambar sudah ter-load:
```bash
# Test product page
curl "http://localhost:8080/PBO-Project/products" | grep "supabase.co/storage"

# Test specific image URL
curl -I "https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/Apple%20Watch%205.png"
```

Expected response: `200 OK` jika gambar tersedia, `404 Not Found` jika belum di-upload.

## Troubleshooting

### Gambar tidak muncul?
1. **Cek nama file** - Harus persis sama dengan `product.name`
2. **Cek bucket** - Harus di bucket "Gambar Jam"
3. **Cek visibility** - File harus public
4. **Cek ekstensi** - Harus `.png` (lowercase)
5. **Cek browser console** - Lihat URL yang di-request

### Error 404 pada gambar?
- Nama file tidak match dengan nama produk
- File belum di-upload ke Supabase Storage
- Bucket name salah atau bucket private

### Icon fallback tidak muncul?
- Check JavaScript console errors
- Pastikan Bootstrap Icons CDN ter-load
- Verify `onerror` handler di image tag

## Notes
- **Format gambar**: Direkomendasikan PNG dengan transparent background
- **Ukuran gambar**: Optimal 400x400px atau 600x600px (square)
- **File size**: Maksimal 1-2MB per gambar
- **Compression**: Gunakan tools seperti TinyPNG untuk optimize
