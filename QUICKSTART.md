# Quick Start Guide - The Object Hour

## 🚀 Cara Menjalankan Aplikasi

### 1. Setup Database (Supabase)

Buka **Supabase SQL Editor** dan jalankan file `sample-data.sql`:

```sql
-- Copy semua isi dari sample-data.sql dan Execute di Supabase
```

File ini akan membuat:
- **2 User Akun** (admin & customer)
- **25+ Produk Jam Tangan** dari berbagai brand (Rolex, Omega, Seiko, Casio, Apple, Samsung, dll)

### 2. Run di NetBeans

1. **Open Project** di NetBeans
2. **Clean and Build** (Shift + F11)
3. **Run** (F6)
4. Browser akan otomatis membuka: `http://localhost:8080/PBO-Project/`

### 3. Login ke Aplikasi

#### Login sebagai **Customer**:
```
Username: customer
Password: customer123
```

#### Login sebagai **Admin**:
```
Username: admin
Password: admin123
```

---

## 📱 Fitur yang Bisa Dicoba

### Sebagai Customer:
✅ **Browse Products** - Lihat katalog jam tangan premium  
✅ **Filter by Type** - Analog, Digital, Smartwatch  
✅ **Search Products** - Cari berdasarkan nama/brand  
✅ **Add to Cart** - Tambahkan produk ke keranjang  
✅ **Checkout** - Pilih metode pembayaran (E-Wallet, Bank Transfer, COD)  
✅ **View Orders** - Lihat riwayat pesanan  
✅ **Cancel Order** - Batalkan pesanan yang masih pending  

### Sebagai Admin:
✅ **Product Management** - CRUD produk jam tangan  
✅ **Stock Management** - Update stok produk  
✅ **Sales Reports** - Lihat laporan penjualan per produk  
✅ **Order Monitoring** - Monitor semua pesanan customer  

---

## 🎨 Design Highlights

- **Modern Marketplace UI** - Mirip Tokopedia/Shopee/Bukalapak
- **Light & Clean Theme** - Elegant white background dengan accent purple-blue
- **Responsive Design** - Mobile & Desktop friendly
- **Smooth Animations** - Hover effects, transitions
- **Bootstrap 5** - Modern component library
- **Bootstrap Icons** - Beautiful icon set

---

## 📦 Sample Products Include:

### Luxury Watches
- **Rolex** Submariner, Datejust, GMT-Master, Daytona (Rp 95jt - 185jt)
- **Omega** Speedmaster, Seamaster, Constellation (Rp 65jt - 85jt)
- **Tag Heuer** Carrera, Monaco (Rp 45jt - 75jt)

### Mid-Range Watches
- **Seiko** Presage, Prospex, Seiko 5 (Rp 3.2jt - 6.5jt)
- **Citizen** Eco-Drive, Chronomaster (Rp 8.5jt - 15jt)
- **Tissot** PRX, Gentleman (Rp 9.5jt - 11jt)

### Digital & Smartwatches
- **Casio G-Shock** GA-2100, MTG, Mudmaster (Rp 1.8jt - 12.5jt)
- **Apple Watch** Series 9, Ultra 2, Hermes (Rp 6.4jt - 24.9jt)
- **Samsung Galaxy Watch** 6, 6 Classic (Rp 3.9jt - 5.4jt)
- **Garmin** Fenix, Epix (Rp 14.5jt - 18.5jt)

---

## 🔐 Demo Accounts

| Role | Username | Password | Access |
|------|----------|----------|--------|
| Admin | `admin` | `admin123` | Full access + Management |
| Customer | `customer` | `customer123` | Shopping features |
| Customer | `jane` | `123456` | Shopping features |

---

## 💳 Payment Methods (Polymorphism Demo)

Saat checkout, pilih metode pembayaran:

1. **E-Wallet** 
   - GoPay, OVO, Dana, ShopeePay, LinkAja
   
2. **Bank Transfer**
   - BCA, Mandiri, BNI, BRI, CIMB Niaga
   
3. **Cash on Delivery (COD)**
   - Bayar tunai saat barang diterima

---

## 🎯 Testing Checklist

- [ ] Login sebagai customer
- [ ] Browse products & filter by type
- [ ] Search products dengan keyword
- [ ] Add multiple products to cart
- [ ] Update quantity di cart
- [ ] Remove items from cart
- [ ] Checkout dengan E-Wallet
- [ ] View order history
- [ ] Login sebagai admin
- [ ] Add new product
- [ ] Edit existing product
- [ ] View sales reports

---

## 📸 Screenshots

### 1. Login Page
Modern gradient background dengan clean white card

### 2. Product Catalog
Grid layout dengan product cards, hover effects, stock badges

### 3. Shopping Cart
Summary with product images, quantity controls, total calculation

### 4. Checkout
Payment method selection dengan instructions

### 5. Order History
List of orders dengan status badges dan detail view

### 6. Admin Dashboard
Product management table dengan CRUD operations

---

## 🛠️ Tech Stack

- **Backend**: Java Servlet/JSP (Jakarta EE)
- **Database**: PostgreSQL (Supabase Cloud)
- **Frontend**: Bootstrap 5.3, Bootstrap Icons
- **Architecture**: MVC Pattern (Model-View-Controller)
- **OOP**: Inheritance, Polymorphism, Encapsulation
- **Security**: SHA-256 Password Hashing, PreparedStatement
- **Server**: Apache Tomcat 9.0

---

## 📚 Documentation

Full documentation available in `README.md`:
- Complete project structure
- Database schema
- API endpoints
- OOP concepts implementation
- Troubleshooting guide

---

**Enjoy Testing! 🎉**
