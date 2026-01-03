<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History - The Object Hour</title>
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
        html.dark-mode footer{background-color:#242933!important;border-color:#3b4252!important}
        /* Order cards - better contrast */
        html.dark-mode .order-section,html.dark-mode .rounded-lg.border{background-color:#2a303c!important;border-color:#3d4555!important}
        html.dark-mode .order-section:hover{background-color:#2e3542!important}
        /* Order item rows */
        html.dark-mode .order-item,html.dark-mode .bg-gray-50.rounded-lg{background-color:#343b4a!important}
        html.dark-mode .order-item:hover{background-color:#3a4252!important}
        /* Product image placeholder */
        html.dark-mode .bg-gray-100.rounded-lg{background:linear-gradient(145deg,#3a4252 0%,#2d3441 100%)!important}
        html.dark-mode .text-blue-600{color:#81a1c1!important}
        html.dark-mode .dropdown-menu{background-color:#242933!important;border-color:#3b4252!important}
        /* Breadcrumb */
        html.dark-mode .text-gray-400{color:#6b7a8a!important}
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
        
        .order-section {
            transition: all 0.2s ease;
        }
        .order-section:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        
        .order-item {
            transition: all 0.2s ease;
        }
        .order-item:hover {
            background-color: #f9fafb;
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
                                    <a href="${pageContext.request.contextPath}/cart" 
                                       class="block px-4 py-3 text-gray-700 hover:bg-gray-50 transition flex items-center">
                                        <i class="bi bi-cart3 mr-3 text-blue-600"></i>
                                        My Cart
                                    </a>
                                    <a href="${pageContext.request.contextPath}/orders/history" 
                                       class="block px-4 py-3 text-gray-700 hover:bg-gray-50 transition flex items-center bg-blue-50">
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
            
            <!-- Check if user is logged in -->
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <!-- Not Logged In State -->
                    <div class="bg-white rounded-lg border border-gray-200 p-12 text-center">
                        <div class="w-20 h-20 mx-auto bg-yellow-100 rounded-full flex items-center justify-center mb-6">
                            <i class="bi bi-person-lock text-4xl text-yellow-600"></i>
                        </div>
                        <h2 class="text-xl font-semibold text-gray-900 mb-2">Login Required</h2>
                        <p class="text-gray-500 mb-6">Please login to view your order history.</p>
                        <div class="flex justify-center gap-4">
                            <a href="${pageContext.request.contextPath}/auth/login" 
                               class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition">
                                <i class="bi bi-box-arrow-in-right mr-2"></i>
                                Login
                            </a>
                            <a href="${pageContext.request.contextPath}/auth/register" 
                               class="inline-flex items-center px-6 py-3 bg-white text-blue-600 font-medium rounded-lg border border-blue-600 hover:bg-blue-50 transition">
                                <i class="bi bi-person-plus mr-2"></i>
                                Register
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Breadcrumb -->
                    <nav class="flex items-center space-x-2 text-sm mb-6">
                        <a href="${pageContext.request.contextPath}/" class="text-gray-500 hover:text-blue-600">Home</a>
                        <i class="bi bi-chevron-right text-gray-400 text-xs"></i>
                        <a href="${pageContext.request.contextPath}/products" class="text-gray-500 hover:text-blue-600">Products</a>
                        <i class="bi bi-chevron-right text-gray-400 text-xs"></i>
                        <span class="text-gray-900 font-medium">Order History</span>
                    </nav>
                    
                    <!-- Page Header -->
                    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                        <div>
                            <h1 class="text-2xl sm:text-3xl font-bold text-gray-900">Order History</h1>
                            <p class="text-gray-500 mt-1">
                                <c:choose>
                                    <c:when test="${not empty orders and orders.size() > 0}">
                                        You have ${orders.size()} checkout(s) in your history
                                    </c:when>
                                    <c:otherwise>
                                        No checkout history found
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/products" class="flex items-center text-blue-600 hover:text-blue-700 font-medium">
                            <i class="bi bi-arrow-left mr-2"></i>
                            Continue Shopping
                        </a>
                    </div>

                    <!-- Success/Error Messages -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-4">
                            <div class="flex items-start">
                                <i class="bi bi-check-circle-fill mr-2 mt-0.5 flex-shrink-0"></i>
                                <div class="flex-1">${sessionScope.success}</div>
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
                                <div class="flex-1">${sessionScope.error}</div>
                                <button onclick="this.closest('.bg-red-50').remove()" class="ml-2 text-red-600 hover:text-red-800 flex-shrink-0">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                            </div>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty orders and orders.size() > 0}">
                            <div class="space-y-6">
                                <!-- Each Order Section -->
                                <c:forEach var="order" items="${orders}" varStatus="loop">
                            <div class="order-section bg-white rounded-lg border border-gray-200 overflow-hidden">
                                <!-- Order Header -->
                                <div class="px-4 sm:px-6 py-4 bg-gray-50 border-b border-gray-200">
                                    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
                                        <div class="flex items-center gap-4">
                                            <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                                                <i class="bi bi-receipt text-blue-600 text-lg"></i>
                                            </div>
                                            <div>
                                                <h2 class="font-semibold text-gray-900">Order #${orders.size() - loop.index}</h2>
                                                <p class="text-sm text-gray-500">
                                                    <i class="bi bi-calendar3 mr-1"></i>
                                                    ${order.formattedCreatedAt}
                                                </p>
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-3">
                                            <!-- Status Badge -->
                                            <c:choose>
                                                <c:when test="${order.status == 'PENDING'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-700">
                                                        <i class="bi bi-clock-history mr-1"></i>Pending
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.status == 'PAID'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-700">
                                                        <i class="bi bi-check-circle mr-1"></i>Paid
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-700">
                                                        <i class="bi bi-x-circle mr-1"></i>Cancelled
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <!-- Payment Method -->
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">
                                                <c:choose>
                                                    <c:when test="${order.paymentMethod == 'EWALLET'}">
                                                        <i class="bi bi-wallet2 mr-1"></i>E-Wallet
                                                    </c:when>
                                                    <c:when test="${order.paymentMethod == 'BANK'}">
                                                        <i class="bi bi-bank mr-1"></i>Bank Transfer
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-cash mr-1"></i>Cash
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Order Items -->
                                <div class="divide-y divide-gray-100">
                                    <c:forEach var="item" items="${order.items}">
                                        <div class="order-item p-4 sm:px-6">
                                            <div class="flex gap-4">
                                                <!-- Product Image -->
                                                <div class="flex-shrink-0">
                                                    <div class="w-16 h-16 sm:w-20 sm:h-20 bg-gray-100 rounded-lg overflow-hidden flex items-center justify-center">
                                                        <c:choose>
                                                            <c:when test="${not empty item.product.imageUrl}">
                                                                <img src="${item.product.imageUrl}" 
                                                                     alt="${item.product.name}"
                                                                     class="w-full h-full object-cover"
                                                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                                                <div class="hidden w-full h-full items-center justify-center">
                                                                    <i class="bi bi-watch text-2xl text-gray-400"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-watch text-2xl text-gray-400"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                
                                                <!-- Product Details -->
                                                <div class="flex-1 min-w-0">
                                                    <div class="flex flex-col sm:flex-row sm:justify-between gap-2">
                                                        <div class="flex-1">
                                                            <c:if test="${not empty item.product.brand}">
                                                                <p class="text-xs text-gray-500 uppercase tracking-wide mb-1">
                                                                    ${item.product.brand}
                                                                </p>
                                                            </c:if>
                                                            <h3 class="font-semibold text-gray-900 text-sm sm:text-base leading-tight">
                                                                <c:choose>
                                                                    <c:when test="${not empty item.product}">
                                                                        ${item.product.name}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Product #${item.productId}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </h3>
                                                            
                                                            <!-- Type Badge -->
                                                            <c:if test="${not empty item.product.type}">
                                                                <span class="inline-flex items-center mt-2 px-2 py-0.5 text-xs font-medium rounded-full
                                                                    ${item.product.type == 'ANALOG' ? 'bg-blue-100 text-blue-700' : 
                                                                      item.product.type == 'DIGITAL' ? 'bg-purple-100 text-purple-700' : 
                                                                      'bg-green-100 text-green-700'}">
                                                                    ${item.product.type}
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <!-- Price Details -->
                                                        <div class="text-right">
                                                            <p class="text-xs text-gray-500">
                                                                <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="Rp " groupingUsed="true" maxFractionDigits="0"/> × ${item.quantity}
                                                            </p>
                                                            <p class="font-semibold text-gray-900 text-base">
                                                                <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="Rp " groupingUsed="true" maxFractionDigits="0"/>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Order Footer -->
                                <div class="px-4 sm:px-6 py-4 bg-gray-50 border-t border-gray-200">
                                    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                                        <!-- Shipping Info -->
                                        <div class="flex items-start gap-2 text-sm text-gray-600">
                                            <i class="bi bi-geo-alt text-gray-400 mt-0.5"></i>
                                            <div>
                                                <p class="font-medium text-gray-700">${order.shippingName}</p>
                                                <p class="text-gray-500">${order.shippingAddress}, ${order.shippingCity}</p>
                                            </div>
                                        </div>
                                        
                                        <!-- Total & Actions -->
                                        <div class="flex items-center gap-4 w-full sm:w-auto">
                                            <div class="flex-1 sm:flex-none text-right">
                                                <p class="text-xs text-gray-500">Total</p>
                                                <p class="font-bold text-xl text-blue-600">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="Rp " groupingUsed="true" maxFractionDigits="0"/>
                                                </p>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/orders/view?id=${order.id}" 
                                               class="inline-flex items-center px-4 py-2 bg-blue-600 text-white font-medium text-sm rounded-lg hover:bg-blue-700 transition">
                                                <i class="bi bi-eye mr-2"></i>
                                                View Detail
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="bg-white rounded-lg border border-gray-200 p-12 text-center">
                                <div class="w-20 h-20 mx-auto bg-blue-100 rounded-full flex items-center justify-center mb-6">
                                    <i class="bi bi-bag-x text-4xl text-blue-500"></i>
                                </div>
                                <h2 class="text-xl font-semibold text-gray-900 mb-2">No Order History Yet</h2>
                                <p class="text-gray-500 mb-6 max-w-md mx-auto">
                                    You haven't made any purchases yet. Browse our collection and find your perfect watch!
                                </p>
                                <a href="${pageContext.request.contextPath}/products" 
                                   class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition">
                                    <i class="bi bi-shop mr-2"></i>
                                    Start Shopping
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 mt-auto">
        <div class="container mx-auto px-4 text-center">
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
            const chevron = document.getElementById('userMenuChevron');
            
            if (userMenuContainer && !userMenuContainer.contains(event.target)) {
                dropdown.classList.add('hidden');
                chevron.style.transform = 'rotate(0deg)';
            }
        });
    </script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
