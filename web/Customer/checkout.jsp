<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Navbar -->
    <nav class="bg-white shadow-sm sticky top-0 z-50">
        <div class="container mx-auto px-3 sm:px-4">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-2">
                    <i class="bi bi-watch text-blue-600 text-2xl"></i>
                    <a href="${pageContext.request.contextPath}/" class="text-xl font-bold">
                        The <span class="text-blue-600">Object Hour</span>
                    </a>
                </div>
                
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/cart" class="relative">
                        <i class="bi bi-cart3 text-blue-600 text-xl"></i>
                    </a>
                    
                    <c:if test="${not empty sessionScope.user}">
                        <span class="font-medium text-gray-700">${sessionScope.user.name}</span>
                        <a href="${pageContext.request.contextPath}/auth/logout" 
                           class="text-red-600 hover:text-red-700 font-medium">
                            <i class="bi bi-box-arrow-right text-xl"></i>
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-3 sm:px-4 py-8 max-w-7xl">
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
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Left: Form -->
                        <div class="lg:col-span-2">
                            <!-- Informasi Pengiriman -->
                            <div class="bg-white rounded-2xl shadow-sm p-6 mb-6">
                                <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                                    <i class="bi bi-truck text-blue-600 text-2xl mr-3"></i>
                                    Informasi Pengiriman
                                </h2>
                                
                                <div class="space-y-4">
                                    <div>
                                        <label for="shippingName" class="block text-sm font-semibold text-gray-700 mb-2">
                                            Nama Lengkap <span class="text-red-500">*</span>
                                        </label>
                                        <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                               id="shippingName" name="shippingName" placeholder="John Doe" required>
                                    </div>
                                    
                                    <div>
                                        <label for="shippingPhone" class="block text-sm font-semibold text-gray-700 mb-2">
                                            No. Telepon <span class="text-red-500">*</span>
                                        </label>
                                        <input type="tel" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                               id="shippingPhone" name="shippingPhone" placeholder="08123456789" required>
                                    </div>
                                    
                                    <div>
                                        <label for="shippingAddress" class="block text-sm font-semibold text-gray-700 mb-2">
                                            Alamat/Nama Jalan <span class="text-red-500">*</span>
                                        </label>
                                        <textarea class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                                  id="shippingAddress" name="shippingAddress" rows="3" 
                                                  placeholder="Jl. Contoh No. 123" required></textarea>
                                    </div>
                                    
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label for="shippingCity" class="block text-sm font-semibold text-gray-700 mb-2">
                                                Kota/Kabupaten <span class="text-red-500">*</span>
                                            </label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                                   id="shippingCity" name="shippingCity" placeholder="Jakarta" required>
                                        </div>
                                        <div>
                                            <label for="shippingState" class="block text-sm font-semibold text-gray-700 mb-2">
                                                Provinsi <span class="text-red-500">*</span>
                                            </label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                                   id="shippingState" name="shippingState" placeholder="DKI Jakarta" required>
                                        </div>
                                    </div>
                                    
                                    <div>
                                        <label for="shippingPostalCode" class="block text-sm font-semibold text-gray-700 mb-2">
                                            Kode Pos <span class="text-red-500">*</span>
                                        </label>
                                        <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                               id="shippingPostalCode" name="shippingPostalCode" placeholder="12345" required>
                                    </div>
                                    
                                    <div>
                                        <label for="notes" class="block text-sm font-semibold text-gray-700 mb-2">
                                            Catatan (Opsional)
                                        </label>
                                        <textarea class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                                                  id="notes" name="notes" rows="2" 
                                                  placeholder="Catatan tambahan untuk penjual"></textarea>
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
</body>
</html>
