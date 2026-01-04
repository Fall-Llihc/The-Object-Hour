<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Security check: redirect to login if not logged in --%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/auth/login">
        <c:param name="error" value="Silakan login terlebih dahulu untuk checkout"/>
    </c:redirect>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Mode -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script>if(localStorage.getItem('darkMode')==='true'){document.documentElement.classList.add('dark-mode');}</script>
    <style>
        html.dark-mode body{background-color:#1a1d24!important;color:#d8dee9!important}
        html.dark-mode nav,html.dark-mode .navbar,html.dark-mode .bg-white,html.dark-mode .bg-light{background-color:#242933!important;border-color:#3b4252!important}
        html.dark-mode .bg-gray-50{background-color:#1a1d24!important}
        html.dark-mode .bg-gray-100{background-color:#2a303c!important}
        html.dark-mode .text-gray-900,html.dark-mode .text-gray-800,html.dark-mode .text-dark{color:#eceff4!important}
        html.dark-mode .text-gray-700{color:#d8dee9!important}
        html.dark-mode .text-gray-600,html.dark-mode .text-gray-500,html.dark-mode .text-muted{color:#9aa5b5!important}
        html.dark-mode .border-gray-200,html.dark-mode .border-b,html.dark-mode .border{border-color:#3b4252!important}
        html.dark-mode input,html.dark-mode select,html.dark-mode textarea,html.dark-mode .form-control{background-color:#2e3440!important;border-color:#3b4252!important;color:#eceff4!important}
        html.dark-mode footer,html.dark-mode .card{background-color:#242933!important;border-color:#3b4252!important}
        /* Checkout cards */
        html.dark-mode .rounded-xl{background-color:#2a303c!important;border-color:#3d4555!important}
        /* Product image */
        html.dark-mode .bg-gray-100.rounded-lg{background:linear-gradient(145deg,#3a4252 0%,#2d3441 100%)!important}
        html.dark-mode .text-blue-600{color:#81a1c1!important}
        html.dark-mode .dropdown-menu{background-color:#242933!important;border-color:#3b4252!important}
    </style>
    <style>
        * { font-family: 'Inter', sans-serif; }
        html, body {
            height: 100%;
        }
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Navbar -->
    <nav class="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-50">
        <div class="container mx-auto px-3 sm:px-4">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <div class="flex items-center space-x-2">
                    <i class="bi bi-watch text-blue-600 text-2xl"></i>
                    <a href="${pageContext.request.contextPath}/" class="text-xl font-bold">
                        The <span class="text-blue-600">Object Hour</span>
                    </a>
                </div>
                
                <!-- Search Bar -->
                <div class="hidden md:flex flex-1 max-w-xl mx-8">
                    <form action="${pageContext.request.contextPath}/products" method="get" class="w-full">
                        <div class="relative">
                            <input type="text" name="search" placeholder="Cari jam tangan..."
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <button type="submit" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-blue-600">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- User Menu -->
                <div class="flex items-center space-x-3">
                    <!-- Dark Mode Toggle -->
                    <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
                        <i class="bi bi-moon-fill"></i>
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/cart" class="relative text-gray-600 hover:text-blue-600">
                        <i class="bi bi-cart3 text-xl"></i>
                    </a>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <!-- Dropdown Menu -->
                            <div class="relative group">
                                <button class="flex items-center space-x-2 text-gray-700 hover:text-blue-600 font-medium">
                                    <i class="bi bi-person-circle text-xl"></i>
                                    <span class="hidden sm:inline">${sessionScope.user.name}</span>
                                    <i class="bi bi-chevron-down text-sm"></i>
                                </button>
                                <div class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                                    <a href="${pageContext.request.contextPath}/cart" class="flex items-center px-4 py-3 text-gray-700 hover:bg-gray-50">
                                        <i class="bi bi-cart3 mr-3 text-blue-600"></i>My Cart
                                    </a>
                                    <a href="${pageContext.request.contextPath}/orders" class="flex items-center px-4 py-3 text-gray-700 hover:bg-gray-50">
                                        <i class="bi bi-clock-history mr-3 text-blue-600"></i>Order History
                                    </a>
                                    <hr class="my-1">
                                    <a href="${pageContext.request.contextPath}/auth/logout" class="flex items-center px-4 py-3 text-red-600 hover:bg-red-50">
                                        <i class="bi bi-box-arrow-right mr-3"></i>Logout
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth/login" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 font-medium">
                                Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="main-content container mx-auto px-3 sm:px-4 py-8 max-w-7xl">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">
            <i class="bi bi-credit-card-fill text-blue-600 mr-2"></i>Checkout
        </h1>

        <!-- Error Messages -->
        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-4">
                <i class="bi bi-exclamation-triangle-fill mr-2"></i>${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="bg-white rounded-2xl shadow-sm p-12 text-center">
                    <i class="bi bi-cart-x text-gray-300 text-6xl mb-4"></i>
                    <h3 class="text-2xl font-bold text-gray-900 mb-2">Keranjang Kosong</h3>
                    <p class="text-gray-600 mb-6">Tambahkan produk terlebih dahulu untuk checkout</p>
                    <a href="${pageContext.request.contextPath}/products" 
                       class="inline-block bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 font-semibold transition-colors">
                        <i class="bi bi-shop mr-2"></i>Belanja Sekarang
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <form action="${pageContext.request.contextPath}/checkout" method="post">
                    <!-- Hidden field for selected items -->
                    <c:if test="${not empty selectedItemIds}">
                        <input type="hidden" name="selectedItemIds" value="${selectedItemIds}">
                    </c:if>
                    
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Left: Form -->
                        <div class="lg:col-span-2">
                            <!-- Informasi Pengiriman -->
                            <div class="bg-white rounded-2xl shadow-sm p-6 mb-6">
                                <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                                    <i class="bi bi-geo-alt-fill text-blue-600 text-2xl mr-3"></i>
                                    Alamat Pengiriman
                                </h2>
                                
                                <div class="space-y-5">
                                    <!-- Nama & Telepon -->
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label for="shippingName" class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="bi bi-person text-gray-400 mr-1"></i>
                                                Nama Penerima <span class="text-red-500">*</span>
                                            </label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                   id="shippingName" name="shippingName" placeholder="Nama lengkap penerima" required>
                                        </div>
                                        <div>
                                            <label for="shippingPhone" class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="bi bi-telephone text-gray-400 mr-1"></i>
                                                No. Telepon <span class="text-red-500">*</span>
                                            </label>
                                            <div class="flex">
                                                <span class="inline-flex items-center px-3 text-gray-500 bg-gray-100 border border-r-0 border-gray-300 rounded-l-lg">
                                                    +62
                                                </span>
                                                <input type="tel" class="flex-1 px-4 py-3 border border-gray-300 rounded-r-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                       id="shippingPhone" name="shippingPhone" placeholder="812 3456 7890" required
                                                       pattern="[0-9]{9,13}" title="Masukkan nomor telepon yang valid">
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Label Alamat -->
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="bi bi-bookmark text-gray-400 mr-1"></i>
                                            Tandai Sebagai
                                        </label>
                                        <div class="flex gap-3">
                                            <label class="flex items-center px-4 py-2 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-blue-500 transition-all">
                                                <input type="radio" name="addressLabel" value="Rumah" class="mr-2 text-blue-600" checked>
                                                <i class="bi bi-house-door mr-2 text-blue-600"></i>
                                                <span class="font-medium">Rumah</span>
                                            </label>
                                            <label class="flex items-center px-4 py-2 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-blue-500 transition-all">
                                                <input type="radio" name="addressLabel" value="Kantor" class="mr-2 text-blue-600">
                                                <i class="bi bi-building mr-2 text-blue-600"></i>
                                                <span class="font-medium">Kantor</span>
                                            </label>
                                        </div>
                                    </div>
                                    
                                    <!-- Provinsi & Kota -->
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label for="shippingState" class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="bi bi-map text-gray-400 mr-1"></i>
                                                Provinsi <span class="text-red-500">*</span>
                                            </label>
                                            <select class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white transition-all" 
                                                    id="shippingState" name="shippingState" required>
                                                <option value="">Pilih Provinsi</option>
                                                <option value="DKI Jakarta">DKI Jakarta</option>
                                                <option value="Jawa Barat">Jawa Barat</option>
                                                <option value="Jawa Tengah">Jawa Tengah</option>
                                                <option value="Jawa Timur">Jawa Timur</option>
                                                <option value="Banten">Banten</option>
                                                <option value="DIY">DI Yogyakarta</option>
                                                <option value="Bali">Bali</option>
                                                <option value="Sumatera Utara">Sumatera Utara</option>
                                                <option value="Sumatera Barat">Sumatera Barat</option>
                                                <option value="Sumatera Selatan">Sumatera Selatan</option>
                                                <option value="Kalimantan Timur">Kalimantan Timur</option>
                                                <option value="Sulawesi Selatan">Sulawesi Selatan</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label for="shippingCity" class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="bi bi-geo text-gray-400 mr-1"></i>
                                                Kota/Kabupaten <span class="text-red-500">*</span>
                                            </label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                   id="shippingCity" name="shippingCity" placeholder="Contoh: Jakarta Selatan" required>
                                        </div>
                                    </div>
                                    
                                    <!-- Kecamatan & Kelurahan -->
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label for="shippingDistrict" class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="bi bi-pin-map text-gray-400 mr-1"></i>
                                                Kecamatan <span class="text-red-500">*</span>
                                            </label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                   id="shippingDistrict" name="shippingDistrict" placeholder="Contoh: Kebayoran Baru" required>
                                        </div>
                                        <div>
                                            <label for="shippingVillage" class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="bi bi-pin text-gray-400 mr-1"></i>
                                                Kelurahan <span class="text-red-500">*</span>
                                            </label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                   id="shippingVillage" name="shippingVillage" placeholder="Contoh: Senayan" required>
                                        </div>
                                    </div>
                                    
                                    <!-- Kode Pos -->
                                    <div class="w-full md:w-1/3">
                                        <label for="shippingPostalCode" class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="bi bi-mailbox text-gray-400 mr-1"></i>
                                            Kode Pos <span class="text-red-500">*</span>
                                        </label>
                                        <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                               id="shippingPostalCode" name="shippingPostalCode" placeholder="12190" required
                                               pattern="[0-9]{5}" maxlength="5" title="Kode pos harus 5 digit">
                                    </div>
                                    
                                    <!-- Alamat Lengkap -->
                                    <div>
                                        <label for="shippingAddress" class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="bi bi-house text-gray-400 mr-1"></i>
                                            Alamat Lengkap <span class="text-red-500">*</span>
                                        </label>
                                        <textarea class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                  id="shippingAddress" name="shippingAddress" rows="3" 
                                                  placeholder="Nama jalan, nomor rumah, RT/RW, gedung, lantai, dll" required></textarea>
                                        <p class="text-xs text-gray-500 mt-1">Contoh: Jl. Sudirman No. 123, RT 05/RW 02, Gedung ABC Lt. 5</p>
                                    </div>
                                    
                                    <!-- Patokan -->
                                    <div>
                                        <label for="shippingLandmark" class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="bi bi-signpost text-gray-400 mr-1"></i>
                                            Patokan <span class="text-gray-400 font-normal">(Opsional)</span>
                                        </label>
                                        <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                               id="shippingLandmark" name="shippingLandmark" placeholder="Contoh: Dekat indomaret, seberang masjid">
                                    </div>
                                    
                                    <!-- Catatan untuk Kurir -->
                                    <div>
                                        <label for="notes" class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="bi bi-chat-left-text text-gray-400 mr-1"></i>
                                            Catatan untuk Kurir <span class="text-gray-400 font-normal">(Opsional)</span>
                                        </label>
                                        <textarea class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all" 
                                                  id="notes" name="notes" rows="2" 
                                                  placeholder="Contoh: Titip ke satpam jika tidak ada orang"></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Metode Pembayaran -->
                            <div class="bg-white rounded-2xl shadow-sm p-6">
                                <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                                    <i class="bi bi-credit-card text-blue-600 text-2xl mr-3"></i>
                                    Metode Pembayaran
                                </h2>
                                
                                <div class="space-y-3">
                                    <!-- Transfer Bank -->
                                    <label class="flex items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-blue-500 hover:bg-blue-50 transition-all">
                                        <input type="radio" name="paymentMethod" value="BANK_TRANSFER" class="w-5 h-5 text-blue-600" required>
                                        <div class="ml-4 flex items-center flex-1">
                                            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg flex items-center justify-center mr-4">
                                                <i class="bi bi-bank text-white text-xl"></i>
                                            </div>
                                            <div>
                                                <div class="font-bold text-gray-900">Transfer Bank</div>
                                                <div class="text-sm text-gray-500">BCA, Mandiri, BNI, BRI</div>
                                            </div>
                                        </div>
                                    </label>
                                    
                                    <!-- E-Wallet -->
                                    <label class="flex items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-purple-500 hover:bg-purple-50 transition-all">
                                        <input type="radio" name="paymentMethod" value="EWALLET" class="w-5 h-5 text-purple-600" required>
                                        <div class="ml-4 flex items-center flex-1">
                                            <div class="w-12 h-12 bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg flex items-center justify-center mr-4">
                                                <i class="bi bi-wallet2 text-white text-xl"></i>
                                            </div>
                                            <div>
                                                <div class="font-bold text-gray-900">E-Wallet / QRIS</div>
                                                <div class="text-sm text-gray-500">GoPay, OVO, Dana, ShopeePay</div>
                                            </div>
                                        </div>
                                    </label>
                                    
                                    <!-- Cash -->
                                    <label class="flex items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-green-500 hover:bg-green-50 transition-all">
                                        <input type="radio" name="paymentMethod" value="CASH" class="w-5 h-5 text-green-600" required>
                                        <div class="ml-4 flex items-center flex-1">
                                            <div class="w-12 h-12 bg-gradient-to-br from-green-500 to-green-600 rounded-lg flex items-center justify-center mr-4">
                                                <i class="bi bi-cash-coin text-white text-xl"></i>
                                            </div>
                                            <div>
                                                <div class="font-bold text-gray-900">Bayar di Tempat (COD)</div>
                                                <div class="text-sm text-gray-500">Bayar saat barang tiba</div>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Order Summary -->
                        <div class="lg:col-span-1">
                            <div class="bg-white rounded-2xl shadow-sm p-6 sticky top-24">
                                <h2 class="text-xl font-bold text-gray-900 mb-6">Ringkasan Pesanan</h2>
                                
                                <!-- Cart Items -->
                                <div class="space-y-4 mb-6 max-h-80 overflow-y-auto">
                                    <c:forEach var="item" items="${cartItems}">
                                        <div class="flex items-start space-x-3 pb-4 border-b border-gray-100 last:border-0">
                                            <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 overflow-hidden">
                                                <img src="${item.product.imageUrl}" 
                                                     data-jpg-url="${item.product.imageUrlJpg}"
                                                     alt="${item.product.name}"
                                                     class="w-full h-full object-cover"
                                                     onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';}">
                                                
                                                <div style="display:none;" class="w-full h-full flex items-center justify-center">
                                                    <i class="bi bi-watch text-2xl text-blue-400"></i>
                                                </div>
                                            </div>
                                            
                                            <div class="flex-1 min-w-0">
                                                <h3 class="font-semibold text-sm text-gray-900 mb-1 truncate">${item.product.name}</h3>
                                                <p class="text-xs text-gray-500 mb-1">${item.product.brand}</p>
                                                <div class="flex justify-between items-center">
                                                    <span class="text-xs text-gray-600">Qty: ${item.quantity}</span>
                                                    <span class="font-bold text-sm text-blue-600">
                                                        <fmt:formatNumber value="${item.subtotal}" type="currency" 
                                                                        currencySymbol="Rp" groupingUsed="true" 
                                                                        maxFractionDigits="0"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Total -->
                                <div class="border-t-2 border-gray-200 pt-4 mb-6">
                                    <div class="flex justify-between items-center mb-3">
                                        <span class="text-gray-600">Subtotal</span>
                                        <span class="font-semibold text-gray-900">
                                            <fmt:formatNumber value="${totalPrice}" type="currency" 
                                                            currencySymbol="Rp" groupingUsed="true" 
                                                            maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                    <div class="flex justify-between items-center mb-3">
                                        <span class="text-gray-600">Ongkir</span>
                                        <span class="font-semibold text-green-600">GRATIS</span>
                                    </div>
                                    <div class="flex justify-between items-center text-lg">
                                        <span class="font-bold text-gray-900">Total</span>
                                        <span class="font-bold text-blue-600 text-2xl">
                                            <fmt:formatNumber value="${totalPrice}" type="currency" 
                                                            currencySymbol="Rp" groupingUsed="true" 
                                                            maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- Submit Button -->
                                <button type="submit" 
                                        class="w-full bg-blue-600 text-white py-4 rounded-xl font-bold text-lg hover:bg-blue-700 transition-colors shadow-lg hover:shadow-xl">
                                    <i class="bi bi-check-circle mr-2"></i>Buat Pesanan
                                </button>
                                
                                <a href="${pageContext.request.contextPath}/cart" 
                                   class="block text-center text-gray-600 hover:text-blue-600 mt-4 font-medium">
                                    <i class="bi bi-arrow-left mr-2"></i>Kembali ke Keranjang
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-8 mt-auto">
        <div class="container mx-auto px-4 text-center">
            <div class="flex items-center justify-center space-x-2 mb-3">
                <i class="bi bi-watch text-blue-600 text-2xl"></i>
                <span class="text-xl font-bold text-gray-900">The <span class="text-blue-600">Object Hour</span></span>
            </div>
            <p class="text-gray-500">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
