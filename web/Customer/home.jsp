<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - The Object Hour</title>
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
                <!-- Logo -->
                <div class="flex items-center space-x-2">
                    <i class="bi bi-watch text-blue-600 text-2xl"></i>
                    <span class="text-xl font-bold">The <span class="text-blue-600">Object Hour</span></span>
                </div>
                
                <!-- Search Bar -->
                <div class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" placeholder="Search watches, brands..." 
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    </div>
                </div>
                
                <!-- Right Menu -->
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/auth/login" class="text-gray-700 hover:text-blue-600 font-medium">Login</a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 font-medium">Register</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="bg-gradient-to-r from-blue-500 to-blue-700 text-white">
        <div class="container mx-auto px-3 sm:px-4 py-20">
            <div class="max-w-2xl">
                <h1 class="text-5xl font-bold mb-4">
                    Time is <span class="text-blue-200">Precious</span><br>
                    Choose Wisely
                </h1>
                <p class="text-xl text-blue-100 mb-8">
                    Discover premium watches from world-class brands.<br>
                    Quality timepieces for every style and occasion.
                </p>
                <div class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/products" 
                       class="bg-white text-blue-600 px-6 py-3 rounded-lg font-semibold hover:bg-blue-50 transition inline-flex items-center">
                        Browse Collection <i class="bi bi-arrow-right ml-2"></i>
                    </a>
                    <a href="#categories" 
                       class="border-2 border-white text-white px-6 py-3 rounded-lg font-semibold hover:bg-white hover:text-blue-600 transition inline-flex items-center">
                        Best Deals <i class="bi bi-tag ml-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Watch By Category -->
    <section id="categories" class="py-16">
        <div class="container mx-auto px-3 sm:px-4">
            <div class="text-center mb-12">
                <h2 class="text-3xl font-bold text-gray-900 mb-2">Watch By Category</h2>
                <p class="text-gray-600">Find the perfect watch for you</p>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Analog Watches -->
                <a href="${pageContext.request.contextPath}/products?type=ANALOG" 
                   class="bg-white rounded-2xl p-8 shadow-sm hover:shadow-lg transition group cursor-pointer">
                    <div class="flex justify-center mb-6">
                        <div class="w-20 h-20 bg-blue-500 rounded-full flex items-center justify-center group-hover:scale-110 transition">
                            <i class="bi bi-watch text-white text-4xl"></i>
                        </div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 text-center mb-2">Analog Watches</h3>
                    <p class="text-gray-600 text-center">Classic timepieces with timeless design</p>
                </a>
                
                <!-- Digital Watches -->
                <a href="${pageContext.request.contextPath}/products?type=DIGITAL" 
                   class="bg-white rounded-2xl p-8 shadow-sm hover:shadow-lg transition group cursor-pointer">
                    <div class="flex justify-center mb-6">
                        <div class="w-20 h-20 bg-purple-500 rounded-full flex items-center justify-center group-hover:scale-110 transition">
                            <i class="bi bi-lightning-charge text-white text-4xl"></i>
                        </div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 text-center mb-2">Digital Watches</h3>
                    <p class="text-gray-600 text-center">Modern digital displays with advanced features</p>
                </a>
                
                <!-- Smartwatches -->
                <a href="${pageContext.request.contextPath}/products?type=SMARTWATCH" 
                   class="bg-white rounded-2xl p-8 shadow-sm hover:shadow-lg transition group cursor-pointer">
                    <div class="flex justify-center mb-6">
                        <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center group-hover:scale-110 transition">
                            <i class="bi bi-phone text-white text-4xl"></i>
                        </div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 text-center mb-2">Smartwatches</h3>
                    <p class="text-gray-600 text-center">Smart technology on your wrist</p>
                </a>
            </div>
        </div>
    </section>

    <!-- Featured Watches -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-3 sm:px-4">
            <div class="mb-12">
                <h2 class="text-3xl font-bold text-gray-900 mb-2">Featured Watches</h2>
                <p class="text-gray-600">Handpicked selection just for you</p>
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <c:choose>
                    <c:when test="${not empty featuredProducts}">
                        <c:forEach var="product" items="${featuredProducts}">
                            <div class="bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-xl transition-all duration-300 group">
                                <div class="bg-gray-100 h-48 flex items-center justify-center relative overflow-hidden">
                                    <!-- Product Image from Supabase Storage -->
                                    <img src="${product.imageUrl}" 
                                         data-jpg-url="${product.imageUrlJpg}"
                                         alt="${product.name}"
                                         class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                         onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';}">
                                    
                                    <!-- Fallback Icon -->
                                    <div style="display:none;" class="w-full h-full flex items-center justify-center absolute top-0 left-0">
                                        <c:choose>
                                            <c:when test="${product.type == 'ANALOG'}">
                                                <i class="bi bi-watch text-6xl text-blue-400"></i>
                                            </c:when>
                                            <c:when test="${product.type == 'DIGITAL'}">
                                                <i class="bi bi-stopwatch text-6xl text-purple-400"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-smartwatch text-6xl text-green-400"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Stock Badge -->
                                    <c:if test="${product.stock <= 5 && product.stock > 0}">
                                        <div class="absolute top-2 right-2 bg-orange-500 text-white text-xs px-2 py-1 rounded-full font-semibold">
                                            Only ${product.stock} left
                                        </div>
                                    </c:if>
                                    <c:if test="${product.stock == 0}">
                                        <div class="absolute top-2 right-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full font-semibold">
                                            Out of Stock
                                        </div>
                                    </c:if>
                                </div>
                                <div class="p-4">
                                    <p class="text-xs text-gray-500 uppercase tracking-wide mb-1 font-medium">${product.brand}</p>
                                    <h3 class="font-bold text-gray-900 mb-2 text-base line-clamp-2">${product.name}</h3>
                                    <div class="flex items-center mb-3">
                                        <span class="inline-block px-2 py-1 text-xs font-medium rounded-full
                                            <c:choose>
                                                <c:when test="${product.type == 'ANALOG'}">bg-blue-100 text-blue-700</c:when>
                                                <c:when test="${product.type == 'DIGITAL'}">bg-purple-100 text-purple-700</c:when>
                                                <c:otherwise>bg-green-100 text-green-700</c:otherwise>
                                            </c:choose>">
                                            ${product.type}
                                        </span>
                                    </div>
                                    <p class="text-blue-600 font-bold text-xl mb-3">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                                    </p>
                                    
                                    <c:choose>
                                        <c:when test="${product.stock > 0}">
                                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                                <input type="hidden" name="productId" value="${product.id}">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="w-full bg-blue-600 text-white py-2.5 rounded-lg hover:bg-blue-700 transition font-semibold text-sm">
                                                    <i class="bi bi-cart-plus mr-1"></i> Add to Cart
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button disabled class="w-full bg-gray-300 text-gray-500 py-2.5 rounded-lg cursor-not-allowed font-semibold text-sm">
                                                Out of Stock
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full text-center py-16">
                            <i class="bi bi-inbox text-6xl text-gray-300 mb-4"></i>
                            <p class="text-gray-500 text-lg">No products available</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- View All Button -->
            <div class="text-center mt-10">
                <a href="${pageContext.request.contextPath}/products" 
                   class="inline-block bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition font-semibold">
                    View All Products <i class="bi bi-arrow-right ml-2"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-8">
        <div class="container mx-auto px-3 sm:px-4 text-center">
            <p class="text-gray-400">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>
</body>
</html>
