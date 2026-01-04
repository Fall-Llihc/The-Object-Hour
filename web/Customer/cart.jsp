<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Security check: redirect to login if not logged in --%>
<c:if test="${empty sessionScope.userId}">
    <c:redirect url="/auth/login">
        <c:param name="error" value="Silakan login terlebih dahulu untuk mengakses keranjang"/>
    </c:redirect>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - The Object Hour</title>
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
        /* Cart items */
        html.dark-mode .cart-item,html.dark-mode .rounded-xl{background-color:#2a303c!important;border-color:#3d4555!important}
        html.dark-mode .cart-item:hover{background-color:#2e3542!important}
        /* Product image */
        html.dark-mode .bg-gray-100.rounded-lg{background:linear-gradient(145deg,#3a4252 0%,#2d3441 100%)!important}
        html.dark-mode .text-blue-600{color:#81a1c1!important}
        html.dark-mode .dropdown-menu{background-color:#242933!important;border-color:#3b4252!important}
    </style>
    <style>
        * { 
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        html {
            height: 100%;
        }
        
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: #f5f5f5;
        }
        
        main {
            flex: 1 0 auto;
        }
        
        .cart-item {
            transition: all 0.2s ease;
        }
        .cart-item:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }
        .cart-item.unselected {
            opacity: 0.6;
            background-color: #fafafa;
        }
        .checkbox-custom {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #2563eb;
        }
        
        /* Smooth scrollbar */
        ::-webkit-scrollbar {
            width: 6px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        ::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <a href="${pageContext.request.contextPath}/" class="flex items-center space-x-2">
                    <i class="bi bi-watch text-blue-600 text-2xl"></i>
                    <span class="font-bold text-xl text-gray-900">The <span class="text-blue-600">Object Hour</span></span>
                </a>
                
                <!-- Search Bar -->
                <div class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" 
                               placeholder="Search watches, brands..." 
                               class="w-full pl-10 pr-4 py-2 bg-gray-100 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                    </div>
                </div>
                
                <!-- Right Actions -->
                <div class="flex items-center space-x-3">
                    <!-- Dark Mode Toggle -->
                    <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
                        <i class="bi bi-moon-fill"></i>
                    </button>
                    
                    <!-- Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="relative p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition">
                        <i class="bi bi-cart3 text-xl"></i>
                        <c:if test="${not empty cart and not empty cart.items}">
                            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center font-bold">
                                ${cart.items.size()}
                            </span>
                        </c:if>
                    </a>
                    
                    <!-- User Menu -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="relative" id="userMenuContainer">
                                <button onclick="toggleUserMenu()" class="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                                    <i class="bi bi-person-circle text-gray-600 text-xl"></i>
                                    <span class="hidden sm:inline text-gray-700 font-medium">${sessionScope.user.name}</span>
                                    <i class="bi bi-chevron-down text-gray-400 text-sm" id="userMenuChevron"></i>
                                </button>
                                
                                <!-- Dropdown Menu -->
                                <div id="userDropdown" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 overflow-hidden z-50">
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <a href="${pageContext.request.contextPath}/admin/products" 
                                           class="block px-4 py-3 text-blue-600 hover:bg-blue-50 transition flex items-center font-semibold">
                                            <i class="bi bi-speedometer2 mr-3"></i>
                                            Admin Dashboard
                                        </a>
                                        <div class="border-t border-gray-200"></div>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/cart" 
                                       class="block px-4 py-3 text-gray-700 hover:bg-gray-50 transition flex items-center">
                                        <i class="bi bi-cart3 mr-3 text-blue-600"></i>
                                        My Cart
                                    </a>
                                    <a href="${pageContext.request.contextPath}/orders/history" 
                                       class="block px-4 py-3 text-gray-700 hover:bg-gray-50 transition flex items-center">
                                        <i class="bi bi-clock-history mr-3 text-blue-600"></i>
                                        Order History
                                    </a>
                                    <a href="${pageContext.request.contextPath}/auth/logout" 
                                       class="block px-4 py-3 text-red-600 hover:bg-red-50 transition flex items-center border-t">
                                        <i class="bi bi-box-arrow-right mr-3"></i>
                                        Logout
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-gray-700 hover:text-blue-600 font-medium">Login</a>
                            <a href="${pageContext.request.contextPath}/auth/register" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 font-medium transition">Register</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="py-6">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-6xl">
            <!-- Breadcrumb -->
            <nav class="flex items-center space-x-2 text-sm mb-6">
                <a href="${pageContext.request.contextPath}/" class="text-gray-500 hover:text-blue-600">Home</a>
                <i class="bi bi-chevron-right text-gray-400 text-xs"></i>
                <a href="${pageContext.request.contextPath}/products" class="text-gray-500 hover:text-blue-600">Products</a>
                <i class="bi bi-chevron-right text-gray-400 text-xs"></i>
                <span class="text-gray-900 font-medium">Shopping Cart</span>
            </nav>
            
            <!-- Page Header -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
            <div>
                <h1 class="text-2xl sm:text-3xl font-bold text-gray-900">Shopping Cart</h1>
                <p class="text-gray-500 mt-1">
                    <c:choose>
                        <c:when test="${not empty cart and not empty cart.items}">
                            ${cart.items.size()} item(s) in your cart
                        </c:when>
                        <c:otherwise>
                            Your cart is empty
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div id="selectionInfo" class="text-sm text-gray-600 bg-gray-100 px-3 py-1.5 rounded-full">
                <i class="bi bi-check2-square mr-1"></i>
                <span id="selectedText">0 of 0 selected</span>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-4">
                <div class="flex items-start">
                    <i class="bi bi-check-circle-fill mr-2 mt-0.5 flex-shrink-0"></i>
                    <div class="flex-1 whitespace-pre-line">${sessionScope.success}</div>
                    <button onclick="this.closest('.bg-green-50').remove()" class="ml-2 text-green-600 hover:text-green-800 flex-shrink-0">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4">
                <div class="flex items-start">
                    <i class="bi bi-exclamation-triangle-fill mr-2 mt-0.5 flex-shrink-0"></i>
                    <div class="flex-1 whitespace-pre-line">${sessionScope.error}</div>
                    <button onclick="this.closest('.bg-red-50').remove()" class="ml-2 text-red-600 hover:text-red-800 flex-shrink-0">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${not empty cart and not empty cart.items}">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- Cart Items Column -->
                    <div class="lg:col-span-2 space-y-3">
                        <!-- Select All Header -->
                        <div class="bg-white rounded-lg border border-gray-200 p-4">
                            <div class="flex flex-wrap items-center justify-between gap-3">
                                <label class="flex items-center cursor-pointer">
                                    <input type="checkbox" id="selectAll" class="checkbox-custom rounded border-gray-300">
                                    <span class="ml-3 font-medium text-gray-800">Select All</span>
                                    <span class="ml-2 text-sm text-gray-500">(${cart.items.size()} items)</span>
                                </label>
                                <div class="flex items-center gap-4">
                                    <button onclick="selectAvailable()" class="text-sm text-blue-600 hover:text-blue-700 font-medium">
                                        <i class="bi bi-check-all mr-1"></i>Available Only
                                    </button>
                                    <button onclick="clearSelection()" class="text-sm text-gray-500 hover:text-gray-700 font-medium">
                                        <i class="bi bi-x-lg mr-1"></i>Clear
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Cart Items List -->
                        <c:forEach var="item" items="${cart.items}" varStatus="loop">
                            <div class="cart-item bg-white rounded-lg border border-gray-200 overflow-hidden" 
                                 id="item-${loop.index}"
                                 data-id="${item.id}"
                                 data-price="${item.unitPrice * item.quantity}"
                                 data-stock="${item.product.stock}"
                                 data-qty="${item.quantity}"
                                 data-active="${item.product.active}"
                                 data-available="${item.product.active and item.product.stock > 0 and item.quantity <= item.product.stock}">
                                
                                <!-- Item Content -->
                                <div class="p-4">
                                    <div class="flex gap-4">
                                        <!-- Checkbox -->
                                        <div class="flex items-start pt-1">
                                            <input type="checkbox" 
                                                   class="item-checkbox checkbox-custom rounded border-gray-300"
                                                   data-index="${loop.index}"
                                                   id="checkbox-${loop.index}"
                                                   ${item.product.active and item.product.stock > 0 and item.quantity <= item.product.stock ? 'checked' : ''}>
                                        </div>
                                        
                                        <!-- Product Image -->
                                        <div class="flex-shrink-0">
                                            <div class="w-20 h-20 sm:w-24 sm:h-24 bg-gray-100 rounded-lg overflow-hidden flex items-center justify-center">
                                                <img src="${item.product.imageUrl}" 
                                                     data-jpg-url="${item.product.imageUrlJpg}"
                                                     alt="${item.product.name}"
                                                     class="w-full h-full object-cover"
                                                     onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';}">
                                                <div style="display:none;" class="w-full h-full flex items-center justify-center">
                                                    <i class="bi bi-watch text-3xl text-gray-400"></i>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Product Details -->
                                        <div class="flex-1 min-w-0">
                                            <div class="flex flex-col sm:flex-row sm:justify-between gap-2">
                                                <div class="flex-1">
                                                    <p class="text-xs text-gray-500 uppercase tracking-wide mb-1">
                                                        ${not empty item.product.brand ? item.product.brand : 'Brand'}
                                                    </p>
                                                    <h3 class="font-semibold text-gray-900 text-base sm:text-lg leading-tight mb-2">
                                                        ${item.product.name}
                                                    </h3>
                                                    
                                                    <!-- Badges -->
                                                    <div class="flex flex-wrap gap-2 mb-3">
                                                        <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-full
                                                            ${item.product.type == 'ANALOG' ? 'bg-blue-100 text-blue-700' : 
                                                              item.product.type == 'DIGITAL' ? 'bg-purple-100 text-purple-700' : 
                                                              'bg-green-100 text-green-700'}">
                                                            ${item.product.type}
                                                        </span>
                                                        
                                                        <c:choose>
                                                            <c:when test="${not item.product.active}">
                                                                <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-full bg-gray-200 text-gray-700">
                                                                    <i class="bi bi-slash-circle mr-1"></i>Unavailable
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${item.product.stock <= 0}">
                                                                <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-full bg-red-100 text-red-700">
                                                                    <i class="bi bi-x-circle mr-1"></i>Out of Stock
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${item.quantity > item.product.stock}">
                                                                <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-full bg-yellow-100 text-yellow-700">
                                                                    <i class="bi bi-exclamation-triangle mr-1"></i>Only ${item.product.stock} left
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${item.product.stock <= 5}">
                                                                <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-full bg-orange-100 text-orange-700">
                                                                    <i class="bi bi-info-circle mr-1"></i>Low Stock
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-full bg-green-100 text-green-700">
                                                                    <i class="bi bi-check-circle mr-1"></i>In Stock
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    
                                                    <!-- Unit Price -->
                                                    <p class="text-blue-600 font-bold text-lg">
                                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="Rp " groupingUsed="true" maxFractionDigits="0"/>
                                                    </p>
                                                </div>
                                                
                                                <!-- Right Side: Quantity & Actions -->
                                                <div class="flex flex-row sm:flex-col items-center sm:items-end gap-3 mt-2 sm:mt-0">
                                                    <!-- Quantity Control -->
                                                    <div class="flex items-center">
                                                        <c:choose>
                                                            <c:when test="${item.product.stock <= 0}">
                                                                <div class="flex items-center border border-gray-200 rounded-lg opacity-50">
                                                                    <button disabled class="w-8 h-8 flex items-center justify-center text-gray-400">
                                                                        <i class="bi bi-dash"></i>
                                                                    </button>
                                                                    <span class="w-10 text-center text-sm font-medium text-gray-400">${item.quantity}</span>
                                                                    <button disabled class="w-8 h-8 flex items-center justify-center text-gray-400">
                                                                        <i class="bi bi-plus"></i>
                                                                    </button>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="flex items-center border border-gray-200 rounded-lg hover:border-blue-300 transition-colors">
                                                                    <input type="hidden" name="cartItemId" value="${item.id}">
                                                                    <button type="submit" name="quantity" value="${item.quantity - 1}" 
                                                                            class="w-8 h-8 flex items-center justify-center text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-l-lg transition-colors ${item.quantity <= 1 ? 'opacity-40 cursor-not-allowed' : ''}"
                                                                            ${item.quantity <= 1 ? 'disabled' : ''}>
                                                                        <i class="bi bi-dash"></i>
                                                                    </button>
                                                                    <span class="w-10 text-center text-sm font-medium">${item.quantity}</span>
                                                                    <button type="submit" name="quantity" value="${item.quantity + 1}" 
                                                                            class="w-8 h-8 flex items-center justify-center text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-r-lg transition-colors ${item.quantity >= item.product.stock ? 'opacity-40 cursor-not-allowed' : ''}"
                                                                            ${item.quantity >= item.product.stock ? 'disabled' : ''}>
                                                                        <i class="bi bi-plus"></i>
                                                                    </button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    
                                                    <!-- Delete Button -->
                                                    <a href="${pageContext.request.contextPath}/cart/remove?id=${item.id}" 
                                                       onclick="return confirm('Remove this item from cart?')"
                                                       class="flex items-center text-sm text-red-600 hover:text-red-700 font-medium">
                                                        <i class="bi bi-trash mr-1"></i>
                                                        <span class="hidden sm:inline">Remove</span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Stock Warning -->
                                    <c:if test="${item.product.stock <= 0 or item.quantity > item.product.stock}">
                                        <div class="mt-4 p-3 bg-red-50 border border-red-200 rounded-lg">
                                            <div class="flex items-start">
                                                <i class="bi bi-exclamation-triangle-fill text-red-500 mr-2 mt-0.5"></i>
                                                <div class="text-sm">
                                                    <c:choose>
                                                        <c:when test="${item.product.stock <= 0}">
                                                            <p class="font-medium text-red-800">This item is out of stock</p>
                                                            <p class="text-red-600">Please remove it or wait for restocking</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="font-medium text-red-800">Insufficient stock</p>
                                                            <p class="text-red-600">Only ${item.product.stock} available. Please reduce quantity.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Item Footer: Subtotal -->
                                <div class="px-4 sm:px-5 py-3 bg-gray-50 border-t border-gray-100">
                                    <div class="flex justify-between items-center">
                                        <span class="text-sm text-gray-500">
                                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="Rp " groupingUsed="true" maxFractionDigits="0"/> × ${item.quantity}
                                        </span>
                                        <div class="text-right">
                                            <span class="text-xs text-gray-500">Subtotal</span>
                                            <p class="font-bold text-lg ${(item.product.stock <= 0 or item.quantity > item.product.stock) ? 'text-red-500 line-through' : 'text-gray-900'}">
                                                <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="Rp " groupingUsed="true" maxFractionDigits="0"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Order Summary Column -->
                    <div class="lg:col-span-1">
                        <div class="bg-white rounded-lg border border-gray-200 p-5 sticky top-20">
                            <h2 class="font-bold text-lg text-gray-900 mb-4">Order Summary</h2>
                            
                            <!-- Selection Status -->
                            <div id="summaryStatus" class="mb-4 p-3 bg-blue-50 rounded-lg">
                                <div class="flex items-center">
                                    <i class="bi bi-info-circle text-blue-500 mr-2"></i>
                                    <div class="text-sm">
                                        <p class="font-medium text-blue-800">Selected for Checkout</p>
                                        <p class="text-blue-600"><span id="summaryCount">0</span> of ${cart.items.size()} items</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Warnings -->
                            <div id="stockWarning" class="mb-4 p-3 bg-red-50 rounded-lg hidden">
                                <div class="flex items-start">
                                    <i class="bi bi-exclamation-triangle text-red-500 mr-2 mt-0.5"></i>
                                    <div class="text-sm">
                                        <p class="font-medium text-red-800">Stock Issues Detected</p>
                                        <p class="text-red-600">Some items have insufficient stock</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div id="noItemsWarning" class="mb-4 p-3 bg-yellow-50 rounded-lg hidden">
                                <div class="flex items-start">
                                    <i class="bi bi-exclamation-triangle text-yellow-500 mr-2 mt-0.5"></i>
                                    <div class="text-sm">
                                        <p class="font-medium text-yellow-800">No Items Selected</p>
                                        <p class="text-yellow-600">Please select items to checkout</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Price Summary -->
                            <div class="space-y-3 mb-5">
                                <div class="flex justify-between text-gray-600">
                                    <span>Subtotal (<span id="itemCount">0</span> items)</span>
                                    <span id="subtotal">Rp 0</span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Shipping</span>
                                    <span class="text-green-600 font-medium">FREE</span>
                                </div>
                                <div class="border-t pt-3 flex justify-between items-center">
                                    <span class="font-bold text-lg">Total</span>
                                    <span id="totalPrice" class="font-bold text-xl text-blue-600">Rp 0</span>
                                </div>
                            </div>
                            
                            <!-- Checkout Button -->
                            <button id="checkoutBtn" 
                                    onclick="checkout()"
                                    disabled
                                    class="w-full bg-gray-300 text-gray-500 py-3 rounded-lg font-semibold mb-3 transition cursor-not-allowed">
                                <i class="bi bi-bag-check mr-2"></i>
                                <span id="checkoutText">Select Items</span>
                            </button>
                            
                            <!-- Clear Cart -->
                            <a href="${pageContext.request.contextPath}/cart/clear" 
                               onclick="return confirm('Clear all items from cart?')"
                               class="block w-full text-center text-gray-600 py-2 rounded-lg hover:bg-gray-100 text-sm font-medium transition">
                                <i class="bi bi-trash mr-1"></i>Clear Cart
                            </a>
                            
                            <div class="border-t mt-4 pt-4">
                                <a href="${pageContext.request.contextPath}/products" 
                                   class="flex items-center justify-center text-blue-600 hover:text-blue-700 font-medium text-sm">
                                    <i class="bi bi-arrow-left mr-2"></i>Continue Shopping
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty Cart -->
                <div class="bg-white rounded-lg border border-gray-200 p-12 text-center max-w-md mx-auto">
                    <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                        <i class="bi bi-cart-x text-3xl text-gray-400"></i>
                    </div>
                    <h2 class="text-xl font-bold text-gray-900 mb-2">Your cart is empty</h2>
                    <p class="text-gray-500 mb-6">Looks like you haven't added anything to your cart yet.</p>
                    <a href="${pageContext.request.contextPath}/products" 
                       class="inline-flex items-center bg-blue-600 text-white px-5 py-2.5 rounded-lg hover:bg-blue-700 font-medium transition">
                        <i class="bi bi-arrow-left mr-2"></i>Start Shopping
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 mt-auto">
        <div class="container mx-auto px-4 text-center">
            <div class="flex items-center justify-center space-x-2 mb-2">
                <i class="bi bi-watch text-blue-600 text-xl"></i>
                <span class="font-bold text-gray-900">The <span class="text-blue-600">Object Hour</span></span>
            </div>
            <p class="text-gray-500 text-sm">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>

    <script>
        // User dropdown toggle
        function toggleUserMenu() {
            const dropdown = document.getElementById('userDropdown');
            const chevron = document.getElementById('userMenuChevron');
            dropdown.classList.toggle('hidden');
            
            if (!dropdown.classList.contains('hidden')) {
                chevron.style.transform = 'rotate(180deg)';
            } else {
                chevron.style.transform = 'rotate(0deg)';
            }
        }
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const userMenuContainer = document.getElementById('userMenuContainer');
            const dropdown = document.getElementById('userDropdown');
            
            if (userMenuContainer && !userMenuContainer.contains(event.target)) {
                if (dropdown && !dropdown.classList.contains('hidden')) {
                    dropdown.classList.add('hidden');
                    const chevron = document.getElementById('userMenuChevron');
                    if (chevron) {
                        chevron.style.transform = 'rotate(0deg)';
                    }
                }
            }
        });
        
        // State
        const selectedItems = new Set();
        const totalItems = ${not empty cart and not empty cart.items ? cart.items.size() : 0};
        
        // DOM Elements
        const selectAllCheckbox = document.getElementById('selectAll');
        const checkboxes = document.querySelectorAll('.item-checkbox');
        const checkoutBtn = document.getElementById('checkoutBtn');
        const checkoutText = document.getElementById('checkoutText');
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Add listeners to individual checkboxes
            checkboxes.forEach(cb => {
                cb.addEventListener('change', function() {
                    const idx = parseInt(this.dataset.index);
                    if (this.checked) {
                        selectedItems.add(idx);
                    } else {
                        selectedItems.delete(idx);
                    }
                    updateItemVisual(idx, this.checked);
                    updateUI();
                });
            });
            
            // Add listener to select all
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    toggleAll(this.checked);
                });
            }
            
            // Initial state - select available items
            selectAvailable();
        });
        
        function toggleAll(checked) {
            selectedItems.clear();
            checkboxes.forEach(cb => {
                const idx = parseInt(cb.dataset.index);
                cb.checked = checked;
                if (checked) {
                    selectedItems.add(idx);
                }
                updateItemVisual(idx, checked);
            });
            updateUI();
        }
        
        function selectAvailable() {
            selectedItems.clear();
            checkboxes.forEach(cb => {
                const idx = parseInt(cb.dataset.index);
                const item = document.getElementById('item-' + idx);
                const available = item.dataset.available === 'true';
                
                cb.checked = available;
                if (available) {
                    selectedItems.add(idx);
                }
                updateItemVisual(idx, available);
            });
            updateUI();
        }
        
        function clearSelection() {
            selectedItems.clear();
            checkboxes.forEach(cb => {
                const idx = parseInt(cb.dataset.index);
                cb.checked = false;
                updateItemVisual(idx, false);
            });
            if (selectAllCheckbox) selectAllCheckbox.checked = false;
            updateUI();
        }
        
        function updateItemVisual(index, selected) {
            const item = document.getElementById('item-' + index);
            if (item) {
                if (selected) {
                    item.classList.remove('unselected');
                } else {
                    item.classList.add('unselected');
                }
            }
        }
        
        function updateUI() {
            updateSelectAllState();
            updateSummary();
            updateCheckoutButton();
        }
        
        function updateSelectAllState() {
            if (selectAllCheckbox) {
                selectAllCheckbox.checked = selectedItems.size === totalItems && totalItems > 0;
                selectAllCheckbox.indeterminate = selectedItems.size > 0 && selectedItems.size < totalItems;
            }
        }
        
        function updateSummary() {
            let total = 0;
            let hasStockIssues = false;
            let count = selectedItems.size;
            
            selectedItems.forEach(idx => {
                const item = document.getElementById('item-' + idx);
                if (item) {
                    const price = parseFloat(item.dataset.price) || 0;
                    const available = item.dataset.available === 'true';
                    total += price;
                    if (!available) hasStockIssues = true;
                }
            });
            
            // Format currency
            const formatted = formatCurrency(total);
            
            // Update display
            document.getElementById('selectedText').textContent = count + ' of ' + totalItems + ' selected';
            document.getElementById('summaryCount').textContent = count;
            document.getElementById('itemCount').textContent = count;
            document.getElementById('subtotal').textContent = formatted;
            document.getElementById('totalPrice').textContent = formatted;
            
            // Warnings
            const stockWarning = document.getElementById('stockWarning');
            const noItemsWarning = document.getElementById('noItemsWarning');
            
            if (hasStockIssues && count > 0) {
                stockWarning.classList.remove('hidden');
            } else {
                stockWarning.classList.add('hidden');
            }
            
            if (count === 0) {
                noItemsWarning.classList.remove('hidden');
            } else {
                noItemsWarning.classList.add('hidden');
            }
        }
        
        function updateCheckoutButton() {
            let hasStockIssues = false;
            selectedItems.forEach(idx => {
                const item = document.getElementById('item-' + idx);
                if (item && item.dataset.available !== 'true') {
                    hasStockIssues = true;
                }
            });
            
            const count = selectedItems.size;
            
            if (count === 0) {
                checkoutBtn.disabled = true;
                checkoutBtn.className = 'w-full bg-gray-300 text-gray-500 py-3 rounded-lg font-semibold mb-3 transition cursor-not-allowed';
                checkoutText.textContent = 'Select Items';
            } else if (hasStockIssues) {
                checkoutBtn.disabled = true;
                checkoutBtn.className = 'w-full bg-red-100 text-red-600 py-3 rounded-lg font-semibold mb-3 transition cursor-not-allowed';
                checkoutText.textContent = 'Fix Stock Issues';
            } else {
                checkoutBtn.disabled = false;
                checkoutBtn.className = 'w-full bg-blue-600 text-white py-3 rounded-lg font-semibold mb-3 transition hover:bg-blue-700 cursor-pointer';
                checkoutText.textContent = 'Checkout (' + count + ')';
            }
        }
        
        function formatCurrency(amount) {
            return 'Rp ' + new Intl.NumberFormat('id-ID').format(amount);
        }
        
        function checkout() {
            if (selectedItems.size === 0) {
                alert('Please select at least one item to checkout.');
                return;
            }
            
            // Check stock issues
            let hasStockIssues = false;
            selectedItems.forEach(idx => {
                const item = document.getElementById('item-' + idx);
                if (item && item.dataset.available !== 'true') {
                    hasStockIssues = true;
                }
            });
            
            if (hasStockIssues) {
                alert('Please deselect items with stock issues before checkout.');
                return;
            }
            
            // Get selected item IDs
            const ids = [];
            selectedItems.forEach(idx => {
                const item = document.getElementById('item-' + idx);
                if (item) {
                    ids.push(item.dataset.id);
                }
            });
            
            // Redirect to checkout
            window.location.href = '${pageContext.request.contextPath}/checkout?selectedItems=' + ids.join(',');
        }
    </script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
