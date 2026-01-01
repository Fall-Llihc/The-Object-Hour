# Product Images Setup - Supabase Storage

## Overview
Gambar produk jam ditampilkan dari **Supabase Storage** bucket bernama **"Gambar Jam"** (public).

## URL Pattern
```
https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/{brand}%20{name}.png
```

## Konvensi Penamaan File
- **Nama file** = **Brand + spasi + Name** (dari kolom `product.brand` dan `product.name` di database) + ekstensi **".png"**
- Spasi dalam nama akan otomatis di-encode menjadi `%20` di URL
- Contoh:
  - Product brand: `Casio`
  - Product name: `G-Shock GA-2100`
  - File name: `Casio G-Shock GA-2100.png`
  - URL: `https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/Casio%20G-Shock%20GA-2100.png`

## Implementasi

### 1. Product Model
File: `src/java/model/Product.java`

Method `getImageUrl()` ditambahkan untuk generate URL gambar:
```java
public String getImageUrl() {
    String baseUrl = "https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/";
    String fullName = this.brand + " " + this.name;
    String encodedName = fullName.replace(" ", "%20");
    return baseUrl + encodedName + ".png";
}
```

**Note:** Format nama file adalah `{brand} {name}.png`, contoh: `Casio G-Shock GA-2100.png`

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
6. Pastikan file di-seG-Shock GA-2100.png` (brand + spasi + name)
- ✅ **BENAR**: `Rolex Submariner Date.png`
- ❌ **SALAH**: `casio-g-shock-ga-2100.png` (lowercase + dash)
- ❌ **SALAH**: `Casio_G-Shock_GA-2100.png` (underscore)
- ❌ **SALAH**: `G-Shock GA-2100.png` (tanpa brand)
- ✅ Gunakan **spasi** antara brand dan name, bukan underscore atau dash
- ✅ **Case-sensitive** - huruf besar/kecil harus persis sama dengan database
- ✅ Format: `{product.brand} {product.name}.png`
- ❌ **SALAH**: `Casio_Classic_Leather_Brown.png`
- ✅ Gunakan **spasi**, bukan underscore atau dash
- ✅ **Case-sensitive** - huruf format: `{brand} {name}.png`):

### Rolex Collection
1. `Rolex Rolex Submariner Date.png`
2. `Rolex Rolex Datejust 41.png`
3. `Rolex GMT-Master II.png`
4. `Rolex Daytona.png`

### Omega Collection
5. `Omega Speedmaster Professional.png`
6. `Omega Seamaster Aqua Terra.png`
7. `Omega Constellation.png`

### Seiko Collection
8. `Seiko Presage Cocktail Time.png`
9. `Seiko Prospex Diver.png`
10. `Seiko 5 Sports.png`

### Casio G-Shock Collection
11. `Casio G-Shock GA-2100.png`
12. `Casio G-Shock MTG-B2000.png`
13. `Casio G-Shock Mudmaster.png`

### Apple Watch Collection
14. `Apple Watch Series 9 GPS.png`
15. `Apple Watch Ultra 2.png`
16. `Apple Watch Hermes Series 9.png`
Series%209%20GPS
### Samsung Galaxy Watch
17. `Samsung Galaxy Watch 6 Classic.png`
18. `Samsung Galaxy Watch 6.png`

### Tag Heuer Collection
19. `Tag Heuer Carrera Chronograph.png`
20. `Tag Heuer Monaco.png`

### Citizen Collection
21. `Citizen Eco-Drive Promaster.png`
format `{product.brand} {product.name}.png` (dengan spasi)
2. **Cek bucket** - Harus di bucket "Gambar Jam"
3. **Cek visibility** - File harus public
4. **Cek ekstensi** - Harus `.png` (lowercase)
5. **Cek browser console** - Lihat URL yang di-request
6. **Cek database** - Pastikan brand dan name di database match dengan nama file

### Error 404 pada gambar?
- Nama file tidak match dengan format `{brand} {name}.png`
- File belum di-upload ke Supabase Storage
- Bucket name salah atau bucket private
- Brand atau name di database berbeda dengan nama file (case-sensitive)
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
