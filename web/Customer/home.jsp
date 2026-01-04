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
    <!-- Dark Mode CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script>
        // Apply dark mode immediately before render
        if (localStorage.getItem('darkMode') === 'true') {
            document.documentElement.classList.add('dark-mode');
        }
    </script>
    <style>
        /* Critical Dark Mode - Enhanced & Harmonious */
        html.dark-mode body { background-color: #1a1d24 !important; color: #d8dee9 !important; }
        html.dark-mode nav, html.dark-mode .bg-white { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .bg-gray-50 { background-color: #1a1d24 !important; }
        html.dark-mode .bg-gray-100 { background-color: #242933 !important; }
        html.dark-mode .text-gray-900, html.dark-mode .text-gray-800 { color: #eceff4 !important; }
        html.dark-mode .text-gray-700 { color: #d8dee9 !important; }
        html.dark-mode .text-gray-600, html.dark-mode .text-gray-500 { color: #9aa5b5 !important; }
        html.dark-mode .border-gray-200, html.dark-mode .border-b { border-color: #3b4252 !important; }
        html.dark-mode input, html.dark-mode select { background-color: #2e3440 !important; border-color: #3b4252 !important; color: #eceff4 !important; }
        html.dark-mode footer { background-color: #242933 !important; border-color: #3b4252 !important; }
        /* Category cards - lighter surface */
        html.dark-mode .rounded-2xl, html.dark-mode .rounded-xl { background-color: #2a303c !important; border-color: #3d4555 !important; }
        html.dark-mode .rounded-2xl:hover, html.dark-mode .rounded-xl:hover { background-color: #2e3542 !important; }
        /* Product cards on home */
        html.dark-mode .group.bg-white { background-color: #2a303c !important; border-color: #3d4555 !important; }
        html.dark-mode .group.bg-white:hover { background-color: #2e3542 !important; }
        html.dark-mode .bg-gray-100.h-48 { background: linear-gradient(145deg, #3a4252 0%, #2d3441 100%) !important; }
        html.dark-mode .text-blue-600 { color: #81a1c1 !important; }
        html.dark-mode .dropdown-menu { background-color: #242933 !important; border-color: #3b4252 !important; }
        /* Category icon backgrounds */
        html.dark-mode .bg-blue-100 { background-color: rgba(94, 129, 172, 0.2) !important; }
        html.dark-mode .bg-purple-100 { background-color: rgba(180, 142, 173, 0.2) !important; }
        html.dark-mode .bg-green-100 { background-color: rgba(163, 190, 140, 0.2) !important; }
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
                <form action="${pageContext.request.contextPath}/products" method="get" class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" 
                               name="search" 
                               placeholder="Search watches, brands..." 
                               class="w-full pl-10 pr-4 py-2 bg-gray-100 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                    </div>
                </form>
                
                <!-- Right Actions -->
                <div class="flex items-center space-x-3">
                    <!-- Dark Mode Toggle -->
                    <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
                        <i class="bi bi-moon-fill"></i>
                    </button>
                    
                    <!-- Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="relative p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition">
                        <i class="bi bi-cart3 text-xl"></i>
                        <c:if test="${not empty cartCount and cartCount > 0}">
                            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center font-bold">
                                ${cartCount}
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
    <main>
        <!-- Hero Section -->
        <section class="bg-gradient-to-r from-blue-600 to-blue-800 text-white">
            <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-16 sm:py-20">
                <div class="max-w-2xl">
                    <h1 class="text-4xl sm:text-5xl font-bold mb-4 leading-tight">
                        Time is <span class="text-blue-200">Precious</span><br>
                        Choose Wisely
                    </h1>
                    <p class="text-lg sm:text-xl text-blue-100 mb-8">
                        Discover premium watches from world-class brands.<br>
                        Quality timepieces for every style and occasion.
                    </p>
                    <div class="flex flex-wrap gap-4">
                        <a href="${pageContext.request.contextPath}/products" 
                           class="bg-white text-blue-600 px-6 py-3 rounded-lg font-semibold hover:bg-blue-50 transition inline-flex items-center">
                            Browse Collection <i class="bi bi-arrow-right ml-2"></i>
                        </a>
                        <a href="#featured" 
                           class="border-2 border-white text-white px-6 py-3 rounded-lg font-semibold hover:bg-white hover:text-blue-600 transition inline-flex items-center">
                            Best Deals <i class="bi bi-tag ml-2"></i>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Watch By Category -->
        <section id="categories" class="py-16 bg-gray-50">
            <div class="container mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-12">
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Watch By Category</h2>
                    <p class="text-gray-600">Find the perfect watch for you</p>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                    <!-- Analog Watches -->
                    <a href="${pageContext.request.contextPath}/products?type=ANALOG" 
                       class="bg-white rounded-2xl p-8 border border-gray-200 hover:shadow-lg hover:border-blue-200 transition group cursor-pointer">
                        <div class="flex justify-center mb-6">
                            <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center group-hover:bg-blue-500 group-hover:scale-110 transition-all">
                                <i class="bi bi-watch text-blue-600 text-3xl group-hover:text-white transition"></i>
                            </div>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 text-center mb-2">Analog Watches</h3>
                        <p class="text-gray-500 text-center text-sm">Classic timepieces with timeless design</p>
                    </a>
                    
                    <!-- Digital Watches -->
                    <a href="${pageContext.request.contextPath}/products?type=DIGITAL" 
                       class="bg-white rounded-2xl p-8 border border-gray-200 hover:shadow-lg hover:border-purple-200 transition group cursor-pointer">
                        <div class="flex justify-center mb-6">
                            <div class="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center group-hover:bg-purple-500 group-hover:scale-110 transition-all">
                                <i class="bi bi-lightning-charge text-purple-600 text-3xl group-hover:text-white transition"></i>
                            </div>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 text-center mb-2">Digital Watches</h3>
                        <p class="text-gray-500 text-center text-sm">Modern digital displays with advanced features</p>
                    </a>
                    
                    <!-- Smartwatches -->
                    <a href="${pageContext.request.contextPath}/products?type=SMARTWATCH" 
                       class="bg-white rounded-2xl p-8 border border-gray-200 hover:shadow-lg hover:border-green-200 transition group cursor-pointer">
                        <div class="flex justify-center mb-6">
                            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center group-hover:bg-green-500 group-hover:scale-110 transition-all">
                                <i class="bi bi-smartwatch text-green-600 text-3xl group-hover:text-white transition"></i>
                            </div>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 text-center mb-2">Smartwatches</h3>
                        <p class="text-gray-500 text-center text-sm">Smart technology on your wrist</p>
                    </a>
                </div>
            </div>
        </section>

        <!-- Featured Watches -->
        <section id="featured" class="py-16 bg-white">
            <div class="container mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
                    <div>
                        <h2 class="text-3xl font-bold text-gray-900 mb-2">Featured Watches</h2>
                        <p class="text-gray-600">Handpicked selection just for you</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/products" class="text-blue-600 hover:text-blue-700 font-medium flex items-center">
                        View All <i class="bi bi-arrow-right ml-2"></i>
                    </a>
                </div>
                
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <c:choose>
                        <c:when test="${not empty featuredProducts}">
                            <c:forEach var="product" items="${featuredProducts}">
                                <div class="bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-lg transition-all duration-300 group">
                                    <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}" class="block">
                                        <div class="bg-gray-100 h-48 flex items-center justify-center relative overflow-hidden">
                                            <!-- Product Image -->
                                            <img src="${product.imageUrl}" 
                                                 data-jpg-url="${product.imageUrlJpg}"
                                                 alt="${product.name}"
                                                 class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                                 onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';}">
                                            
                                            <!-- Fallback Icon -->
                                            <div style="display:none;" class="w-full h-full flex items-center justify-center absolute top-0 left-0 bg-gray-100">
                                                <c:choose>
                                                    <c:when test="${product.type == 'ANALOG'}">
                                                        <i class="bi bi-watch text-5xl text-blue-300"></i>
                                                    </c:when>
                                                    <c:when test="${product.type == 'DIGITAL'}">
                                                        <i class="bi bi-stopwatch text-5xl text-purple-300"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-smartwatch text-5xl text-green-300"></i>
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
                                    </a>
                                    <div class="p-4">
                                        <p class="text-xs text-gray-500 uppercase tracking-wide mb-1 font-medium">${product.brand}</p>
                                        <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}">
                                            <h3 class="font-semibold text-gray-900 mb-2 text-sm line-clamp-2 hover:text-blue-600 transition">${product.name}</h3>
                                        </a>
                                        <div class="flex items-center mb-3">
                                            <span class="inline-block px-2 py-0.5 text-xs font-medium rounded-full
                                                <c:choose>
                                                    <c:when test="${product.type == 'ANALOG'}">bg-blue-100 text-blue-700</c:when>
                                                    <c:when test="${product.type == 'DIGITAL'}">bg-purple-100 text-purple-700</c:when>
                                                    <c:otherwise>bg-green-100 text-green-700</c:otherwise>
                                                </c:choose>">
                                                ${product.type}
                                            </span>
                                        </div>
                                        <p class="text-blue-600 font-bold text-lg mb-3">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                                        </p>
                                        
                                        <c:choose>
                                            <c:when test="${product.stock > 0}">
                                                <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                                    <input type="hidden" name="productId" value="${product.id}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition font-medium text-sm">
                                                        <i class="bi bi-cart-plus mr-1"></i> Add to Cart
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <button disabled class="w-full bg-gray-200 text-gray-500 py-2 rounded-lg cursor-not-allowed font-medium text-sm">
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
                                <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                    <i class="bi bi-inbox text-4xl text-gray-400"></i>
                                </div>
                                <p class="text-gray-500 text-lg mb-4">No products available yet</p>
                                <a href="${pageContext.request.contextPath}/products" class="text-blue-600 hover:text-blue-700 font-medium">
                                    Check back later <i class="bi bi-arrow-right ml-1"></i>
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- View All Button -->
                <c:if test="${not empty featuredProducts}">
                    <div class="text-center mt-10">
                        <a href="${pageContext.request.contextPath}/products" 
                           class="inline-flex items-center bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition font-semibold">
                            View All Products <i class="bi bi-arrow-right ml-2"></i>
                        </a>
                    </div>
                </c:if>
            </div>
        </section>
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
    </script>
    
    <!-- Dark Mode Script -->
    <script>
        (function() {
            // Update icons
            function updateIcons() {
                var isDark = document.documentElement.classList.contains('dark-mode');
                var buttons = document.getElementsByClassName('dark-mode-toggle');
                for (var i = 0; i < buttons.length; i++) {
                    var icon = buttons[i].getElementsByTagName('i')[0];
                    if (icon) {
                        icon.className = isDark ? 'bi bi-sun-fill' : 'bi bi-moon-fill';
                    }
                }
            }
            
            // Toggle function
            function toggle() {
                var html = document.documentElement;
                if (html.classList.contains('dark-mode')) {
                    html.classList.remove('dark-mode');
                    localStorage.setItem('darkMode', 'false');
                } else {
                    html.classList.add('dark-mode');
                    localStorage.setItem('darkMode', 'true');
                }
                updateIcons();
            }
            
            // Attach click handlers
            var buttons = document.getElementsByClassName('dark-mode-toggle');
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].onclick = toggle;
            }
            
            // Initial update
            updateIcons();
            
            // Expose globally
            window.toggleDarkMode = toggle;
        })();
    </script>
</body>
</html>