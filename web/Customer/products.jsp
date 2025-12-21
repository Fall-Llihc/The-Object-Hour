<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Featured Watches - The Object Hour</title>
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
                
                <div class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" placeholder="Search watches, brands..." 
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>
                
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/cart" class="relative">
                        <i class="bi bi-cart3 text-gray-700 text-xl"></i>
                        <c:if test="${not empty cartCount and cartCount > 0}">
                            <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">
                                ${cartCount}
                            </span>
                        </c:if>
                    </a>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <span class="text-gray-700 font-medium">${sessionScope.user.name}</span>
                            <a href="${pageContext.request.contextPath}/auth/logout" class="text-gray-700 hover:text-red-600">
                                <i class="bi bi-box-arrow-right text-xl"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-gray-700 hover:text-blue-600 font-medium">Login</a>
                            <a href="${pageContext.request.contextPath}/auth/register" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 font-medium">Register</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-3 sm:px-4 py-8">
        <div class="flex gap-6">
            <!-- Sidebar Filter -->
            <aside class="w-72 flex-shrink-0 hidden lg:block">
                <form action="${pageContext.request.contextPath}/products" method="get" id="filterForm">
                    <div class="bg-white rounded-2xl shadow-sm p-6 sticky top-24">
                        <h3 class="font-bold text-xl mb-6 text-gray-900">Filters</h3>
                        
                        <!-- Category Filter -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Category</h4>
                            <div class="space-y-3">
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="type" value="" ${empty selectedType ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">All Watches</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="type" value="ANALOG" ${selectedType == 'ANALOG' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Analog</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="type" value="DIGITAL" ${selectedType == 'DIGITAL' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Digital</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="type" value="SMARTWATCH" ${selectedType == 'SMARTWATCH' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Smartwatch</span>
                                </label>
                            </div>
                        </div>
                        
                        <!-- Brand Filter -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Brand</h4>
                            <div class="space-y-3">
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="brand" value="" ${empty selectedBrand ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">All Brands</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="brand" value="Casio" ${selectedBrand == 'Casio' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Casio</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="brand" value="Samsung" ${selectedBrand == 'Samsung' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Samsung</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="brand" value="Xiaomi" ${selectedBrand == 'Xiaomi' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Xiaomi</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="brand" value="DanielW" ${selectedBrand == 'DanielW' ? 'checked' : ''} 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500" onchange="this.form.submit()">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">DanielW</span>
                                </label>
                            </div>
                        </div>
                        
                        <!-- Price Range -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Price Range</h4>
                            <div class="space-y-3">
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="priceRange" value="all" checked 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">All Prices</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="priceRange" value="0-500000" 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Under Rp500K</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="priceRange" value="500000-1000000" 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Rp500K - Rp1M</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="priceRange" value="1000000-2000000" 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Rp1M - Rp2M</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="radio" name="priceRange" value="2000000-999999999" 
                                           class="w-4 h-4 text-blue-600 border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Above Rp2M</span>
                                </label>
                            </div>
                        </div>
                        
                        <!-- Stock Status -->
                        <div class="mb-6">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Availability</h4>
                            <label class="flex items-center cursor-pointer group">
                                <input type="checkbox" name="inStock" value="true" 
                                       class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500">
                                <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">In Stock Only</span>
                            </label>
                        </div>
                        
                        <div class="space-y-2">
                            <button type="submit" class="w-full bg-blue-600 text-white py-2.5 rounded-lg hover:bg-blue-700 font-semibold transition">
                                Apply Filters
                            </button>
                            <a href="${pageContext.request.contextPath}/products" class="block w-full bg-gray-100 text-gray-700 py-2.5 rounded-lg hover:bg-gray-200 font-medium transition text-center">
                                Reset All
                            </a>
                        </div>
                    </div>
                </form>
            </aside>

            <!-- Products Grid -->
            <main class="flex-1">
                <div class="mb-6">
                    <h1 class="text-2xl font-bold text-gray-900 mb-1">Featured Watches</h1>
                    <p class="text-gray-600">Handpicked selection just for you</p>
                </div>

                <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
                    <!-- Product Cards from Database -->
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-xl transition-all duration-300 group">
                                    <div class="bg-gray-100 h-48 flex items-center justify-center relative overflow-hidden">
                                        <c:choose>
                                            <c:when test="${product.type == 'ANALOG'}">
                                                <i class="bi bi-watch text-6xl text-blue-400 group-hover:scale-110 transition-transform duration-300"></i>
                                            </c:when>
                                            <c:when test="${product.type == 'DIGITAL'}">
                                                <i class="bi bi-stopwatch text-6xl text-purple-400 group-hover:scale-110 transition-transform duration-300"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-smartwatch text-6xl text-green-400 group-hover:scale-110 transition-transform duration-300"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        
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
                                        <h3 class="font-bold text-gray-900 mb-2 text-base">${product.name}</h3>
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
                                <p class="text-gray-500 text-lg">No products found</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <div class="flex justify-center items-center mt-10 space-x-2">
                    <button class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed">
                        <i class="bi bi-chevron-left"></i> Previous
                    </button>
                    <button class="px-4 py-2 bg-blue-600 text-white rounded-lg font-semibold">1</button>
                    <button class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">2</button>
                    <button class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">3</button>
                    <button class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">
                        Next <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
            </main>
        </div>
    </div>

    <footer class="bg-gray-900 text-white py-8 mt-16">
        <div class="container mx-auto px-3 sm:px-4 text-center">
            <p class="text-gray-400">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>
</body>
</html>
