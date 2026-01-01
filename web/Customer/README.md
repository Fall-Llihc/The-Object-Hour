# Customer Pages

Folder ini berisi semua halaman JSP untuk customer (user biasa).

## File yang Aktif Digunakan

### 1. **home.jsp**
- **Fungsi**: Halaman utama aplikasi
- **Route**: `/` (index.jsp)
- **Fitur**: 
  - Hero section dengan CTA
  - Kategori produk (Analog, Digital, Smartwatch)
  - Featured products
  - Navbar dengan cart icon

### 2. **products.jsp**
- **Fungsi**: Halaman daftar produk
- **Route**: `/products`
- **Controller**: ProductController
- **Fitur**:
  - Grid produk dengan gambar
  - Filter by brand & type
  - Search
  - Add to cart button
  - Stock indicator

### 3. **product-detail.jsp**
- **Fungsi**: Detail produk individual
- **Route**: `/products/view?id={id}`
- **Controller**: ProductController
- **Fitur**:
  - Product image & info lengkap
  - Quantity selector
  - Add to cart
  - Stock availability

### 4. **cart.jsp**
- **Fungsi**: Keranjang belanja
- **Route**: `/cart`
- **Controller**: CartController
- **Fitur**:
  - List cart items dengan gambar
  - Update quantity (+/-)
  - Remove item
  - Total harga
  - Checkout button
  - Empty cart message

### 5. **checkout.jsp**
- **Fungsi**: Form checkout & pembayaran
- **Route**: `/checkout`
- **Controller**: CheckoutController
- **Fitur**:
  - Form informasi pengiriman (6 fields)
  - Pilihan metode pembayaran (Bank Transfer, E-Wallet, COD)
  - Order summary sidebar
  - Validation

### 6. **payment-success.jsp**
- **Fungsi**: Halaman sukses setelah checkout
- **Route**: `/payment-success`
- **Controller**: PaymentSuccessController
- **Fitur**:
  - Animasi checkmark
  - Pesan sukses
  - Tombol kembali ke home

### 7. **orders.jsp**
- **Fungsi**: Daftar pesanan user
- **Route**: `/orders`
- **Controller**: OrderController
- **Fitur**:
  - List order dengan status
  - Order ID & tanggal
  - Total amount
  - Link ke detail order

### 8. **order-detail.jsp**
- **Fungsi**: Detail pesanan individual
- **Route**: `/orders/view?id={id}`
- **Controller**: OrderController
- **Fitur**:
  - Informasi penerima (nama, alamat, telepon, dll)
  - List item pesanan
  - Metode pembayaran
  - Status order
  - Total amount

---

## Teknologi

- **Frontend**: Tailwind CSS, Bootstrap Icons, Inter Font
- **Backend**: Java Servlet, JSP, JSTL
- **Database**: PostgreSQL (Supabase)

## Folder Backup

Folder `_backup_unused/` berisi file-file lama yang sudah tidak dipakai:
- cart-old.jsp
- checkout-old.jsp
- products-bootstrap-old.jsp
- products-new.jsp
- view.jsp

**JANGAN HAPUS** folder ini, hanya untuk referensi jika perlu rollback.
