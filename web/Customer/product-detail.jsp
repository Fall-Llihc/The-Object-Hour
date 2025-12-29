<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - ${product.brand} | The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        .image-zoom:hover img {
            transform: scale(1.05);
            transition: transform 0.3s ease;
        }
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
                
                <form action="${pageContext.request.contextPath}/products" method="get" class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" name="search" placeholder="Search watches, brands..." 
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </form>
                
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

    <!-- Breadcrumb -->
    <div class="bg-white border-b">
        <div class="container mx-auto px-3 sm:px-4 py-3">
            <div class="flex items-center space-x-2 text-sm text-gray-600">
                <a href="${pageContext.request.contextPath}/" class="hover:text-blue-600">Home</a>
                <i class="bi bi-chevron-right text-xs"></i>
                <a href="${pageContext.request.contextPath}/products" class="hover:text-blue-600">Products</a>
                <i class="bi bi-chevron-right text-xs"></i>
                <span class="text-gray-900 font-medium">${product.name}</span>
            </div>
        </div>
    </div>

    <!-- Product Detail -->
    <div class="container mx-auto px-3 sm:px-4 py-8">
        <div class="grid lg:grid-cols-2 gap-8 lg:gap-12">
            <!-- Product Image -->
            <div class="image-zoom">
                <div class="bg-white rounded-2xl shadow-lg p-8 sticky top-24">
                    <div class="relative aspect-square rounded-xl overflow-hidden bg-gray-100">
                        <img id="productImage" 
                             src="${product.imageUrl}" 
                             data-jpg-url="${product.imageUrlJpg}"
                             alt="${product.name}"
                             class="w-full h-full object-contain transition-transform duration-300"
                             onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.style.display='none';this.nextElementSibling.style.display='flex';}">
                        <div style="display:none;" class="w-full h-full flex items-center justify-center">
                            <i class="bi bi-watch text-gray-300 text-9xl"></i>
                        </div>
                        
                        <!-- Stock Badge -->
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <div class="absolute top-4 right-4 bg-green-500 text-white text-xs px-3 py-1.5 rounded-full font-semibold flex items-center space-x-1">
                                    <i class="bi bi-check-circle-fill"></i>
                                    <span>In Stock (${product.stock})</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="absolute top-4 right-4 bg-red-500 text-white text-xs px-3 py-1.5 rounded-full font-semibold">
                                    Out of Stock
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Product Info -->
            <div class="space-y-6">
                <!-- Brand & Type -->
                <div class="flex items-center space-x-3">
                    <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">${product.brand}</span>
                    <span class="inline-block px-3 py-1 text-xs font-medium rounded-full
                        <c:choose>
                            <c:when test="${product.type == 'ANALOG'}">bg-blue-100 text-blue-700</c:when>
                            <c:when test="${product.type == 'DIGITAL'}">bg-purple-100 text-purple-700</c:when>
                            <c:otherwise>bg-green-100 text-green-700</c:otherwise>
                        </c:choose>">
                        ${product.type}
                    </span>
                </div>

                <!-- Product Name -->
                <h1 class="text-3xl lg:text-4xl font-bold text-gray-900">${product.name}</h1>

                <!-- Price -->
                <div class="flex items-baseline space-x-3">
                    <span class="text-4xl font-bold text-blue-600">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                    </span>
                </div>

                <!-- Divider -->
                <hr class="border-gray-200">

                <!-- Specifications -->
                <div>
                    <h2 class="text-xl font-bold text-gray-900 mb-4">Specifications</h2>
                    <div class="bg-gray-50 rounded-xl p-5 space-y-3">
                        <c:choose>
                            <c:when test="${not empty product.specifications}">
                                <c:forEach items="${product.specifications.split('\\|')}" var="spec">
                                    <div class="flex items-start space-x-3">
                                        <i class="bi bi-check-circle-fill text-blue-600 text-lg mt-0.5"></i>
                                        <span class="text-gray-700 leading-relaxed">${spec.trim()}</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="flex items-start space-x-3">
                                    <i class="bi bi-check-circle-fill text-blue-600 text-lg mt-0.5"></i>
                                    <span class="text-gray-700">Brand: ${product.brand}</span>
                                </div>
                                <div class="flex items-start space-x-3">
                                    <i class="bi bi-check-circle-fill text-blue-600 text-lg mt-0.5"></i>
                                    <span class="text-gray-700">Type: ${product.type}</span>
                                </div>
                                <c:if test="${not empty product.strapMaterial}">
                                    <div class="flex items-start space-x-3">
                                        <i class="bi bi-check-circle-fill text-blue-600 text-lg mt-0.5"></i>
                                        <span class="text-gray-700">Strap Material: ${product.strapMaterial}</span>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Divider -->
                <hr class="border-gray-200">

                <!-- Quantity & Actions -->
                <c:choose>
                    <c:when test="${product.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" id="addToCartForm">
                            <input type="hidden" name="productId" value="${product.id}">
                            
                            <!-- Quantity Selector -->
                            <div class="space-y-4">
                                <label class="block text-sm font-semibold text-gray-700">Quantity</label>
                                <div class="flex items-center space-x-4">
                                    <div class="flex items-center border-2 border-gray-300 rounded-lg">
                                        <button type="button" onclick="decreaseQuantity()" 
                                                class="px-4 py-3 text-gray-600 hover:bg-gray-100 font-semibold text-lg">
                                            -
                                        </button>
                                        <input type="number" name="quantity" id="quantity" value="1" min="1" max="${product.stock}" 
                                               class="w-20 text-center border-x-2 border-gray-300 py-3 font-semibold text-lg focus:outline-none">
                                        <button type="button" onclick="increaseQuantity()" 
                                                class="px-4 py-3 text-gray-600 hover:bg-gray-100 font-semibold text-lg">
                                            +
                                        </button>
                                    </div>
                                    <span class="text-sm text-gray-500">${product.stock} available</span>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex flex-col sm:flex-row gap-3 mt-6">
                                <button type="submit" 
                                        class="flex-1 bg-blue-600 text-white py-4 rounded-xl hover:bg-blue-700 transition font-semibold text-lg flex items-center justify-center space-x-2 shadow-lg">
                                    <i class="bi bi-cart-plus text-xl"></i>
                                    <span>Add to Cart</span>
                                </button>
                                <button type="button" onclick="buyNow()" 
                                        class="flex-1 bg-gray-900 text-white py-4 rounded-xl hover:bg-gray-800 transition font-semibold text-lg shadow-lg">
                                    Buy Now
                                </button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-red-50 border-2 border-red-200 rounded-xl p-6 text-center">
                            <i class="bi bi-exclamation-circle text-red-500 text-4xl mb-2"></i>
                            <p class="text-red-700 font-semibold text-lg">This product is currently out of stock</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Additional Info -->
                <div class="grid grid-cols-3 gap-4 pt-4">
                    <div class="text-center p-4 bg-gray-50 rounded-xl">
                        <i class="bi bi-truck text-blue-600 text-2xl mb-2"></i>
                        <p class="text-xs text-gray-600 font-medium">Free Shipping</p>
                    </div>
                    <div class="text-center p-4 bg-gray-50 rounded-xl">
                        <i class="bi bi-shield-check text-blue-600 text-2xl mb-2"></i>
                        <p class="text-xs text-gray-600 font-medium">1 Year Warranty</p>
                    </div>
                    <div class="text-center p-4 bg-gray-50 rounded-xl">
                        <i class="bi bi-arrow-clockwise text-blue-600 text-2xl mb-2"></i>
                        <p class="text-xs text-gray-600 font-medium">Easy Returns</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-gray-900 text-white py-8 mt-16">
        <div class="container mx-auto px-3 sm:px-4 text-center">
            <p class="text-gray-400">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>

    <script>
        const maxStock = ${product.stock};
        
        function decreaseQuantity() {
            const input = document.getElementById('quantity');
            const currentValue = parseInt(input.value);
            if (currentValue > 1) {
                input.value = currentValue - 1;
            }
        }
        
        function increaseQuantity() {
            const input = document.getElementById('quantity');
            const currentValue = parseInt(input.value);
            if (currentValue < maxStock) {
                input.value = currentValue + 1;
            }
        }
        
        function buyNow() {
            // Add to cart first
            const form = document.getElementById('addToCartForm');
            const formData = new FormData(form);
            
            fetch('${pageContext.request.contextPath}/cart/add', {
                method: 'POST',
                body: formData
            })
            .then(() => {
                // Redirect to cart page
                window.location.href = '${pageContext.request.contextPath}/cart';
            })
            .catch(error => {
                console.error('Error:', error);
                // Still redirect on error
                window.location.href = '${pageContext.request.contextPath}/cart';
            });
        }
    </script>
</body>
</html>
