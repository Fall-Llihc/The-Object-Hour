<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - The Object Hour</title>
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
                        <i class="bi bi-cart3 text-blue-600 text-xl"></i>
                        <c:if test="${not empty cart and not empty cart.items}">
                            <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">
                                ${cart.items.size()}
                            </span>
                        </c:if>
                    </a>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <i class="bi bi-person-circle text-gray-700 text-xl"></i>
                            <span class="font-medium text-gray-700">${sessionScope.user.name}</span>
                            <a href="${pageContext.request.contextPath}/auth/logout" 
                               class="text-red-600 hover:text-red-700 font-medium">
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

    <div class="container mx-auto px-3 sm:px-4 py-8 max-w-6xl">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Your Cart</h1>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg mb-4">
                <i class="bi bi-check-circle-fill mr-2"></i>${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-4">
                <i class="bi bi-exclamation-triangle-fill mr-2"></i>${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${not empty cart and not empty cart.items}">
                <!-- Cart Items -->
                <c:forEach var="item" items="${cart.items}">
                    <div class="bg-white rounded-2xl shadow-sm p-6 mb-4">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-6">
                                <!-- Product Image -->
                                <div class="bg-gray-100 w-24 h-24 rounded-xl flex items-center justify-center flex-shrink-0">
                                    <c:choose>
                                        <c:when test="${item.product.type == 'ANALOG'}">
                                            <i class="bi bi-watch text-4xl text-blue-400"></i>
                                        </c:when>
                                        <c:when test="${item.product.type == 'DIGITAL'}">
                                            <i class="bi bi-stopwatch text-4xl text-purple-400"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-smartwatch text-4xl text-green-400"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Product Info -->
                                <div>
                                    <p class="text-xs text-gray-500 uppercase mb-1">${item.product.brand}</p>
                                    <h3 class="font-bold text-lg text-gray-900 mb-1">${item.product.name}</h3>
                                    <span class="inline-block px-2 py-1 text-xs font-medium rounded-full
                                        <c:choose>
                                            <c:when test="${item.product.type == 'ANALOG'}">bg-blue-100 text-blue-700</c:when>
                                            <c:when test="${item.product.type == 'DIGITAL'}">bg-purple-100 text-purple-700</c:when>
                                            <c:otherwise>bg-green-100 text-green-700</c:otherwise>
                                        </c:choose>">
                                        ${item.product.type}
                                    </span>
                                    <p class="text-blue-600 font-bold text-xl mt-2">
                                        <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                                    </p>
                                </div>
                            </div>
                            
                            <!-- Quantity Controls & Actions -->
                            <div class="flex items-center space-x-4">
                                <!-- Quantity Selector -->
                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="flex items-center border-2 border-gray-200 rounded-lg">
                                    <input type="hidden" name="cartItemId" value="${item.id}">
                                    <button type="submit" name="quantity" value="${item.quantity - 1}" 
                                            class="px-3 py-2 text-gray-600 hover:bg-gray-50 disabled:opacity-30" 
                                            ${item.quantity <= 1 ? 'disabled' : ''}>
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <input type="text" value="${item.quantity}" readonly
                                           class="w-12 text-center border-x-2 border-gray-200 focus:outline-none font-medium">
                                    <button type="submit" name="quantity" value="${item.quantity + 1}" 
                                            class="px-3 py-2 text-gray-600 hover:bg-gray-50 disabled:opacity-30"
                                            ${item.quantity >= item.product.stock ? 'disabled' : ''}>
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </form>
                                
                                <!-- Delete Button -->
                                <a href="${pageContext.request.contextPath}/cart/remove?id=${item.id}" 
                                   onclick="return confirm('Yakin ingin menghapus item ini dari keranjang?')"
                                   class="bg-red-100 text-red-600 px-4 py-2 rounded-lg hover:bg-red-200 transition font-medium">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                        
                        <!-- Subtotal per item -->
                        <div class="mt-4 pt-4 border-t border-gray-200 flex justify-between items-center">
                            <div class="text-sm text-gray-500">
                                <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/> × ${item.quantity}
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-gray-500">Subtotal</p>
                                <p class="text-lg font-bold text-gray-900">
                                    <c:choose>
                                        <c:when test="${not empty item.subtotal}">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Cart Summary -->
                <div class="bg-white rounded-2xl shadow-sm p-6">
                    <h2 class="font-bold text-lg mb-4">Order Summary</h2>
                    <div class="space-y-2 mb-4">
                        <div class="flex justify-between text-gray-600">
                            <span>Subtotal (${cart.items.size()} items)</span>
                            <span>
                                <fmt:formatNumber value="${total}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                            </span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Shipping</span>
                            <span class="text-green-600 font-medium">FREE</span>
                        </div>
                        <div class="border-t pt-2 flex justify-between font-bold text-xl">
                            <span>Total</span>
                            <span class="text-blue-600">
                                <fmt:formatNumber value="${total}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                            </span>
                        </div>
                    </div>
                    <button onclick="window.location.href='${pageContext.request.contextPath}/checkout'" 
                            class="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 font-semibold text-lg mb-3">
                        <i class="bi bi-credit-card mr-2"></i>Proceed to Checkout
                    </button>
                    <a href="${pageContext.request.contextPath}/cart/clear" 
                       onclick="return confirm('Yakin ingin mengosongkan seluruh keranjang?')"
                       class="block w-full text-center bg-gray-100 text-gray-700 py-2.5 rounded-lg hover:bg-gray-200 font-medium">
                        <i class="bi bi-trash mr-2"></i>Clear Cart
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty Cart -->
                <div class="bg-white rounded-2xl shadow-sm p-12 text-center">
                    <i class="bi bi-cart-x text-6xl text-gray-300 mb-4"></i>
                    <h2 class="text-2xl font-bold text-gray-900 mb-2">Your cart is empty</h2>
                    <p class="text-gray-600 mb-6">Start shopping to add items to your cart</p>
                    <a href="${pageContext.request.contextPath}/products" 
                       class="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 font-semibold">
                        <i class="bi bi-arrow-left mr-2"></i>Continue Shopping
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Continue Shopping -->
        <div class="text-center mt-6">
            <a href="${pageContext.request.contextPath}/products" class="text-blue-600 hover:text-blue-700 font-medium">
                <i class="bi bi-arrow-left mr-2"></i>Continue Shopping
            </a>
        </div>
    </div>

    <footer class="bg-gray-900 text-white py-8 mt-16">
        <div class="container mx-auto px-3 sm:px-4 text-center">
            <p class="text-gray-400">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>
</body>
</html>
