# Backup Unused Files

Folder ini berisi file-file JSP yang **tidak aktif digunakan** di aplikasi.

## File yang Dipindahkan

| File | Alasan | Tanggal Backup |
|------|--------|----------------|
| `cart-old.jsp` | Versi lama halaman cart (sudah diganti `cart.jsp`) | 29 Dec 2025 |
| `products-bootstrap-old.jsp` | Versi lama dengan Bootstrap CSS (sudah diganti Tailwind) | 29 Dec 2025 |
| `products-new.jsp` | Versi alternatif yang tidak jadi dipakai | 29 Dec 2025 |
| `view.jsp` | Template kosong "Hello World" (tidak terpakai) | 29 Dec 2025 |

## File Aktif (Masih di Folder `Customer/`)

### ✅ `products.jsp`
- **Status**: AKTIF
- **Controller**: `ProductController.java` (line 88, 133)
- **Fungsi**: Halaman daftar produk dengan filter & search
- **Style**: Tailwind CSS
- **Features**: 
  - Product grid dengan image dari Supabase Storage
  - Filter by category, brand, price
  - Add to cart functionality
  - Fallback PNG → JPG → Icon

### ✅ `cart.jsp`
- **Status**: AKTIF  
- **Controller**: `CartController.java` (line 99)
- **Fungsi**: Halaman keranjang belanja
- **Style**: Tailwind CSS
- **Features**:
  - Cart items display dengan gambar produk
  - Quantity update (+/-)
  - Remove item
  - Subtotal calculation
  - Checkout button

### ✅ `home.jsp`
- **Status**: AKTIF
- **Controller**: Index page (landing page)
- **Fungsi**: Homepage/landing page
- **Style**: Tailwind CSS
- **Features**:
  - Hero section
  - Featured products showcase
  - Call-to-action buttons

## Catatan

- File backup ini **AMAN UNTUK DIHAPUS** kalau sudah yakin tidak perlu
- File ini disimpan untuk jaga-jaga kalau ada komponen yang perlu di-reference
- Jangan ubah file di folder `Customer/` utama kecuali file aktif di atas

## Restore File

Jika perlu restore salah satu file:
```bash
# Contoh: restore products-bootstrap-old.jsp
mv _backup_unused/products-bootstrap-old.jsp ../
```

## Hapus Backup

Jika sudah yakin tidak butuh:
```bash
# Hapus seluruh folder backup
rm -rf _backup_unused/
```
