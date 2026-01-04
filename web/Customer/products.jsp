<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Premium Watches - The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Dark Mode -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script>if(localStorage.getItem('darkMode')==='true'){document.documentElement.classList.add('dark-mode');}</script>
    <style>
        html.dark-mode body{background-color:#1a1d24!important;color:#d8dee9!important}
        html.dark-mode nav,html.dark-mode .navbar,html.dark-mode .bg-white,html.dark-mode .bg-light{background-color:#242933!important;border-color:#3b4252!important}
        html.dark-mode .bg-gray-50{background-color:#1a1d24!important}
        html.dark-mode .bg-gray-100{background-color:#242933!important}
        html.dark-mode .text-gray-900,html.dark-mode .text-gray-800,html.dark-mode .text-dark{color:#eceff4!important}
        html.dark-mode .text-gray-700{color:#d8dee9!important}
        html.dark-mode .text-gray-600,html.dark-mode .text-gray-500,html.dark-mode .text-muted{color:#9aa5b5!important}
        html.dark-mode .border-gray-200,html.dark-mode .border-b{border-color:#3b4252!important}
        html.dark-mode input,html.dark-mode select,html.dark-mode textarea,html.dark-mode .form-control{background-color:#2e3440!important;border-color:#3b4252!important;color:#eceff4!important}
        html.dark-mode footer,html.dark-mode aside,html.dark-mode .card{background-color:#242933!important;border-color:#3b4252!important}
        html.dark-mode .filter-sidebar{background-color:#242933!important}
        html.dark-mode .products-area{background-color:#1a1d24!important}
        html.dark-mode .product-card{background-color:#2a303c!important;border-color:#3d4555!important}
        html.dark-mode .product-card:hover{background-color:#2e3542!important;border-color:#4a5568!important}
        html.dark-mode .product-image{background:linear-gradient(145deg,#3a4252 0%,#2d3441 100%)!important}
        html.dark-mode .product-image .bi-smartwatch,html.dark-mode .product-image [class*="bi-"]{color:#6b7a94!important}
        html.dark-mode .product-card h3,html.dark-mode .product-card .font-semibold{color:#e8eef5!important}
        html.dark-mode .product-card .text-xs{color:#8899aa!important}
        html.dark-mode .dropdown-menu{background-color:#242933!important;border-color:#3b4252!important}
        html.dark-mode .text-blue-600{color:#81a1c1!important}
        html.dark-mode .pagination-btn{background-color:#2a303c!important;color:#d0d8e2!important}
        html.dark-mode .pagination-btn.active{background-color:#5e81ac!important;color:#fff!important}
    </style>
    <style>
        * { 
            font-family: 'Inter', sans-serif; 
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        html, body {
            height: 100%;
            overflow: hidden;
        }
        
        .app-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
            background: #f5f5f5;
        }
        
        .main-content {
            flex: 1;
            display: flex;
            overflow: hidden;
        }
        
        /* Filter Sidebar */
        .filter-sidebar {
            width: 280px;
            background: white;
            border-right: 1px solid #e5e7eb;
            overflow-y: auto;
            flex-shrink: 0;
        }
        
        /* Products Area */
        .products-area {
            flex: 1;
            overflow-y: auto;
            background: #f5f5f5;
        }
        
        /* Custom scrollbar */
        .products-area::-webkit-scrollbar,
        .filter-sidebar::-webkit-scrollbar {
            width: 6px;
        }
        .products-area::-webkit-scrollbar-track,
        .filter-sidebar::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .products-area::-webkit-scrollbar-thumb,
        .filter-sidebar::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }
        .products-area::-webkit-scrollbar-thumb:hover,
        .filter-sidebar::-webkit-scrollbar-thumb:hover {
            background: #a1a1a1;
        }
        
        /* Product Cards */
        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.2s ease;
            border: 1px solid #e5e7eb;
        }
        
        .product-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .product-image {
            position: relative;
            height: 200px;
            background: #f9fafb;
            overflow: hidden;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .product-card:hover .product-image img {
            transform: scale(1.05);
        }
        
        .stock-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .type-badge {
            background: #2563eb;
            color: white;
            padding: 3px 10px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .add-to-cart-btn {
            background: #2563eb;
            transition: all 0.2s ease;
        }
        
        .add-to-cart-btn:hover {
            background: #1d4ed8;
        }
        
        /* Custom Checkbox */
        .custom-checkbox {
            width: 16px;
            height: 16px;
            border-radius: 4px;
            border: 2px solid #d1d5db;
            cursor: pointer;
            accent-color: #2563eb;
        }
        
        /* Pagination */
        .pagination-btn {
            min-width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.2s;
        }
        
        .pagination-btn.active {
            background: #2563eb;
            color: white;
        }
        
        .pagination-btn:not(.active):hover {
            background: #f3f4f6;
        }
        
        /* Mobile Filter */
        @media (max-width: 1023px) {
            .filter-sidebar {
                position: fixed;
                left: -100%;
                top: 0;
                bottom: 0;
                z-index: 100;
                transition: left 0.3s ease;
                width: 300px;
            }
            
            .filter-sidebar.open {
                left: 0;
            }
            
            .filter-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 99;
            }
            
            .filter-overlay.open {
                display: block;
            }
        }
        
        @media (min-width: 1024px) {
            .mobile-filter-btn {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Navbar -->
        <nav class="bg-white border-b border-gray-200 flex-shrink-0">
            <div class="px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center h-16">
                    <!-- Logo -->
                    <a href="${pageContext.request.contextPath}/" class="flex items-center space-x-2">
                        <i class="bi bi-watch text-blue-600 text-2xl"></i>
                        <span class="font-bold text-xl text-gray-900">The <span class="text-blue-600">Object Hour</span></span>
                    </a>
                    
                    <!-- Search Bar -->
                    <form action="${pageContext.request.contextPath}/products" method="get" class="hidden md:flex flex-1 max-w-lg mx-8">
                        <div class="relative w-full">
                            <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input type="text" 
                                   name="search" 
                                   value="${search}" 
                                   placeholder="Search watches, brands..." 
                                   class="w-full pl-10 pr-4 py-2 bg-gray-100 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                            <c:forEach items="${selectedTypes}" var="t">
                                <input type="hidden" name="type" value="${t}">
                            </c:forEach>
                            <c:forEach items="${selectedBrands}" var="b">
                                <input type="hidden" name="brand" value="${b}">
                            </c:forEach>
                            <c:if test="${not empty sortBy}">
                                <input type="hidden" name="sort" value="${sortBy}">
                            </c:if>
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

        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Mobile Filter Overlay -->
            <div class="filter-overlay" id="filterOverlay" onclick="toggleMobileFilter()"></div>
            
            <!-- Filter Sidebar -->
            <aside class="filter-sidebar" id="filterSidebar">
                <form action="${pageContext.request.contextPath}/products" method="get" id="filterForm">
                    <input type="hidden" name="search" value="${search}">
                    <c:if test="${not empty sortBy}">
                        <input type="hidden" name="sort" value="${sortBy}">
                    </c:if>
                    
                    <div class="p-4">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="font-bold text-lg text-gray-900">
                                <i class="bi bi-funnel text-blue-600 mr-2"></i>Filters
                            </h3>
                            <button type="button" class="lg:hidden text-gray-500 hover:text-gray-700" onclick="toggleMobileFilter()">
                                <i class="bi bi-x-lg text-xl"></i>
                            </button>
                        </div>
                        
                        <!-- Category Filter -->
                        <div class="pb-4 mb-4 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-900 mb-3 uppercase tracking-wide">Category</h4>
                            <div class="space-y-2">
                                <label class="flex items-center cursor-pointer group">
                                    <input type="checkbox" name="type" value="ANALOG" 
                                           ${selectedTypes.contains('ANALOG') ? 'checked' : ''}
                                           class="custom-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">
                                        <i class="bi bi-watch mr-2"></i>Analog
                                    </span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="checkbox" name="type" value="DIGITAL" 
                                           ${selectedTypes.contains('DIGITAL') ? 'checked' : ''}
                                           class="custom-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">
                                        <i class="bi bi-stopwatch mr-2"></i>Digital
                                    </span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="checkbox" name="type" value="SMARTWATCH" 
                                           ${selectedTypes.contains('SMARTWATCH') ? 'checked' : ''}
                                           class="custom-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">
                                        <i class="bi bi-smartwatch mr-2"></i>Smartwatch
                                    </span>
                                </label>
                            </div>
                        </div>
                        
                        <!-- Brand Filter -->
                        <div class="pb-4 mb-4 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-900 mb-3 uppercase tracking-wide">Brand</h4>
                            
                            <div class="mb-3">
                                <div class="relative">
                                    <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>
                                    <input type="text" id="brandSearch" placeholder="Search brands..." 
                                           class="w-full pl-9 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                                </div>
                            </div>
                            
                            <div id="defaultBrands" class="space-y-2 max-h-48 overflow-y-auto">
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Apple" 
                                           ${selectedBrands.contains('Apple') ? 'checked' : ''}
                                           class="custom-checkbox brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Apple</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Casio" 
                                           ${selectedBrands.contains('Casio') ? 'checked' : ''}
                                           class="custom-checkbox brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Casio</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Samsung" 
                                           ${selectedBrands.contains('Samsung') ? 'checked' : ''}
                                           class="custom-checkbox brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Samsung</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Xiaomi" 
                                           ${selectedBrands.contains('Xiaomi') ? 'checked' : ''}
                                           class="custom-checkbox brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Xiaomi</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="DanielW" 
                                           ${selectedBrands.contains('DanielW') ? 'checked' : ''}
                                           class="custom-checkbox brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">DanielW</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Huawei" 
                                           ${selectedBrands.contains('Huawei') ? 'checked' : ''}
                                           class="custom-checkbox brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Huawei</span>
                                </label>
                            </div>
                            
                            <div id="searchResults" class="mt-3" style="display: none;">
                                <div class="text-xs text-gray-500 mb-2 font-medium">Search Results:</div>
                                <div id="dynamicBrands" class="space-y-2"></div>
                                <div id="noMatchMessage" class="text-sm text-gray-400 italic" style="display: none;">
                                    No brands found.
                                </div>
                            </div>
                            
                            <!-- Selected Custom Brands (non-default brands that were checked) -->
                            <div id="selectedCustomBrands" class="mt-3 border-t border-gray-200 pt-3" style="display: none;">
                                <div class="text-xs text-gray-500 mb-2 font-medium">Selected Brands:</div>
                                <div id="selectedCustomBrandsList" class="space-y-2"></div>
                            </div>
                        </div>
                        
                        <!-- Price Range -->
                        <div class="pb-4 mb-4 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-900 mb-3 uppercase tracking-wide">Price Range</h4>
                            <div class="space-y-3">
                                <div>
                                    <label class="text-xs text-gray-600 mb-1 block">Min Price (Rp)</label>
                                    <input type="number" name="minPrice" value="${minPrice}" placeholder="0"
                                           class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                                </div>
                                <div>
                                    <label class="text-xs text-gray-600 mb-1 block">Max Price (Rp)</label>
                                    <input type="number" name="maxPrice" value="${maxPrice}" placeholder="10000000"
                                           class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Availability -->
                        <div class="pb-4 mb-4 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-900 mb-3 uppercase tracking-wide">Availability</h4>
                            <label class="flex items-center cursor-pointer group">
                                <input type="checkbox" name="inStock" value="true" ${inStock ? 'checked' : ''}
                                       class="custom-checkbox">
                                <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">
                                    <i class="bi bi-check-circle mr-2"></i>In Stock Only
                                </span>
                            </label>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="space-y-2">
                            <button type="submit" class="w-full bg-blue-600 text-white py-2.5 rounded-lg hover:bg-blue-700 font-medium transition text-sm">
                                <i class="bi bi-check-circle mr-2"></i>Apply Filters
                            </button>
                            <a href="${pageContext.request.contextPath}/products" class="block w-full bg-gray-100 text-gray-700 py-2.5 rounded-lg hover:bg-gray-200 font-medium transition text-center text-sm">
                                <i class="bi bi-arrow-counterclockwise mr-2"></i>Reset All
                            </a>
                        </div>
                    </div>
                </form>
            </aside>

            <!-- Products Area -->
            <div class="products-area">
                <div class="p-4 lg:p-6">
                    <!-- Header -->
                    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                        <div>
                            <h1 class="text-2xl font-bold text-gray-900">
                                <c:choose>
                                    <c:when test="${not empty search}">
                                        Search: "${search}"
                                    </c:when>
                                    <c:otherwise>
                                        All Products
                                    </c:otherwise>
                                </c:choose>
                            </h1>
                            <p class="text-gray-500 text-sm mt-1">${totalProducts} products found</p>
                        </div>
                        
                        <div class="flex items-center gap-3">
                            <!-- Mobile Filter Button -->
                            <button class="mobile-filter-btn lg:hidden flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50" onclick="toggleMobileFilter()">
                                <i class="bi bi-funnel"></i>
                                Filters
                            </button>
                            
                            <!-- Sort Dropdown -->
                            <form action="${pageContext.request.contextPath}/products" method="get" id="sortForm">
                                <input type="hidden" name="search" value="${search}">
                                <c:forEach items="${selectedTypes}" var="t">
                                    <input type="hidden" name="type" value="${t}">
                                </c:forEach>
                                <c:forEach items="${selectedBrands}" var="b">
                                    <input type="hidden" name="brand" value="${b}">
                                </c:forEach>
                                <c:if test="${not empty minPrice}">
                                    <input type="hidden" name="minPrice" value="${minPrice}">
                                </c:if>
                                <c:if test="${not empty maxPrice}">
                                    <input type="hidden" name="maxPrice" value="${maxPrice}">
                                </c:if>
                                <c:if test="${inStock}">
                                    <input type="hidden" name="inStock" value="true">
                                </c:if>
                                
                                <select name="sort" class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 cursor-pointer" onchange="this.form.submit()">
                                    <option value="">Sort: Default</option>
                                    <option value="name-asc" ${sortBy == 'name-asc' ? 'selected' : ''}>Name: A-Z</option>
                                    <option value="name-desc" ${sortBy == 'name-desc' ? 'selected' : ''}>Name: Z-A</option>
                                    <option value="price-asc" ${sortBy == 'price-asc' ? 'selected' : ''}>Price: Low-High</option>
                                    <option value="price-desc" ${sortBy == 'price-desc' ? 'selected' : ''}>Price: High-Low</option>
                                    <option value="stock-asc" ${sortBy == 'stock-asc' ? 'selected' : ''}>Stock: Low-High</option>
                                    <option value="stock-desc" ${sortBy == 'stock-desc' ? 'selected' : ''}>Stock: High-Low</option>
                                </select>
                            </form>
                        </div>
                    </div>

                    <!-- Products Grid -->
                    <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-4">
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="product" items="${products}">
                                    <div class="product-card">
                                        <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}">
                                            <div class="product-image">
                                                <img src="${product.imageUrl}" 
                                                     data-jpg-url="${product.imageUrlJpg}"
                                                     alt="${product.name}"
                                                     loading="lazy"
                                                     onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';}">
                                                
                                                <div style="display:none;" class="w-full h-full flex items-center justify-center absolute top-0 left-0 bg-gray-100">
                                                    <c:choose>
                                                        <c:when test="${product.type == 'ANALOG'}">
                                                            <i class="bi bi-watch text-5xl text-gray-300"></i>
                                                        </c:when>
                                                        <c:when test="${product.type == 'DIGITAL'}">
                                                            <i class="bi bi-stopwatch text-5xl text-gray-300"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-smartwatch text-5xl text-gray-300"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <c:choose>
                                                    <c:when test="${product.stock == 0}">
                                                        <div class="stock-badge bg-red-500 text-white">Out of Stock</div>
                                                    </c:when>
                                                    <c:when test="${product.stock <= 5}">
                                                        <div class="stock-badge bg-orange-500 text-white">Only ${product.stock} left</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="stock-badge bg-green-500 text-white">In Stock</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </a>
                                        
                                        <div class="p-3">
                                            <p class="text-xs text-gray-500 uppercase tracking-wide mb-1">${product.brand}</p>
                                            
                                            <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}">
                                                <h3 class="font-semibold text-gray-900 text-sm mb-2 hover:text-blue-600 transition line-clamp-2">
                                                    ${product.name}
                                                </h3>
                                            </a>
                                            
                                            <div class="mb-2">
                                                <span class="type-badge">${product.type}</span>
                                            </div>
                                            
                                            <p class="text-blue-600 font-bold text-lg mb-3">
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="Rp" groupingUsed="true" maxFractionDigits="0"/>
                                            </p>
                                            
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                                        <input type="hidden" name="productId" value="${product.id}">
                                                        <input type="hidden" name="quantity" value="1">
                                                        <button type="submit" class="add-to-cart-btn w-full text-white py-2 rounded-lg font-medium text-sm">
                                                            <i class="bi bi-cart-plus mr-1"></i>Add to Cart
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
                                    <div class="bg-gray-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
                                        <i class="bi bi-inbox text-4xl text-gray-400"></i>
                                    </div>
                                    <h3 class="text-xl font-bold text-gray-900 mb-2">No Products Found</h3>
                                    <p class="text-gray-500 mb-4">Try adjusting your filters or search terms</p>
                                    <a href="${pageContext.request.contextPath}/products" 
                                       class="inline-block bg-blue-600 text-white px-6 py-2 rounded-lg font-medium hover:bg-blue-700 transition text-sm">
                                        Clear All Filters
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex justify-center items-center mt-8 gap-1 flex-wrap">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if><c:if test='${not empty sortBy}'>&sort=${sortBy}</c:if>" 
                                       class="pagination-btn border border-gray-300 text-gray-700 hover:bg-gray-100">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button disabled class="pagination-btn border border-gray-200 text-gray-400 cursor-not-allowed">
                                        <i class="bi bi-chevron-left"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                            <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />
                            
                            <c:if test="${startPage > 1}">
                                <a href="?page=1<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if><c:if test='${not empty sortBy}'>&sort=${sortBy}</c:if>" 
                                   class="pagination-btn border border-gray-300 text-gray-700">1</a>
                                <c:if test="${startPage > 2}">
                                    <span class="px-2 text-gray-400">...</span>
                                </c:if>
                            </c:if>

                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <button class="pagination-btn active">${i}</button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${i}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if><c:if test='${not empty sortBy}'>&sort=${sortBy}</c:if>" 
                                           class="pagination-btn border border-gray-300 text-gray-700">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <span class="px-2 text-gray-400">...</span>
                                </c:if>
                                <a href="?page=${totalPages}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if><c:if test='${not empty sortBy}'>&sort=${sortBy}</c:if>" 
                                   class="pagination-btn border border-gray-300 text-gray-700">${totalPages}</a>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if><c:if test='${not empty sortBy}'>&sort=${sortBy}</c:if>" 
                                       class="pagination-btn border border-gray-300 text-gray-700">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button disabled class="pagination-btn border border-gray-200 text-gray-400 cursor-not-allowed">
                                        <i class="bi bi-chevron-right"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="bg-white border-t border-gray-200 py-4 flex-shrink-0">
            <div class="px-4 text-center">
                <p class="text-gray-500 text-sm">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
            </div>
        </footer>
    </div>

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
        
        // Mobile filter toggle
        function toggleMobileFilter() {
            const sidebar = document.getElementById('filterSidebar');
            const overlay = document.getElementById('filterOverlay');
            sidebar.classList.toggle('open');
            overlay.classList.toggle('open');
        }
        
        // Brand search functionality
        let searchTimeout;
        const defaultBrands = ['Apple', 'Casio', 'Samsung', 'Xiaomi', 'DanielW', 'Huawei'];
        
        // Track selected custom brands (brands not in defaultBrands list)
        let selectedCustomBrands = new Set();
        
        const selectedBrandsFromJSP = [
            <c:forEach var="brand" items="${selectedBrands}" varStatus="status">
                "${brand}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Initialize selected custom brands from JSP
        selectedBrandsFromJSP.forEach(function(brand) {
            if (!defaultBrands.map(b => b.toLowerCase()).includes(brand.toLowerCase())) {
                selectedCustomBrands.add(brand);
            }
        });
        
        // Render selected custom brands on page load
        renderSelectedCustomBrands();
        
        document.getElementById('brandSearch')?.addEventListener('input', function(e) {
            const searchTerm = e.target.value.trim();
            
            if (searchTimeout) {
                clearTimeout(searchTimeout);
            }
            
            if (!searchTerm) {
                resetToDefaultBrands();
                return;
            }
            
            searchTimeout = setTimeout(() => {
                performBrandSearch(searchTerm);
            }, 300);
        });
        
        function renderSelectedCustomBrands() {
            const container = document.getElementById('selectedCustomBrands');
            const list = document.getElementById('selectedCustomBrandsList');
            
            if (selectedCustomBrands.size === 0) {
                container.style.display = 'none';
                list.innerHTML = '';
                return;
            }
            
            container.style.display = 'block';
            list.innerHTML = '';
            
            selectedCustomBrands.forEach(function(brand) {
                const labelElement = document.createElement('label');
                labelElement.className = 'flex items-center cursor-pointer group selected-custom-brand';
                labelElement.setAttribute('data-brand', brand);
                
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.name = 'brand';
                checkbox.value = brand;
                checkbox.className = 'custom-checkbox brand-checkbox';
                checkbox.checked = true;
                checkbox.addEventListener('change', function() {
                    if (!this.checked) {
                        selectedCustomBrands.delete(brand);
                        renderSelectedCustomBrands();
                    }
                });
                
                const span = document.createElement('span');
                span.className = 'ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label';
                span.textContent = brand;
                
                labelElement.appendChild(checkbox);
                labelElement.appendChild(span);
                list.appendChild(labelElement);
            });
        }
        
        function resetToDefaultBrands() {
            const searchResults = document.getElementById('searchResults');
            const dynamicBrands = document.getElementById('dynamicBrands');
            
            dynamicBrands.innerHTML = '';
            searchResults.style.display = 'none';
            
            const defaultBrandElements = document.querySelectorAll('.default-brand');
            defaultBrandElements.forEach(brand => {
                brand.style.display = 'flex';
            });
        }
        
        function performBrandSearch(searchTerm) {
            const defaultBrandElements = document.querySelectorAll('.default-brand');
            let visibleDefaultsCount = 0;
            
            defaultBrandElements.forEach(brand => {
                const brandName = brand.querySelector('.brand-label').textContent;
                if (brandName.toLowerCase().includes(searchTerm.toLowerCase())) {
                    brand.style.display = 'flex';
                    visibleDefaultsCount++;
                } else {
                    brand.style.display = 'none';
                }
            });
            
            fetch('${pageContext.request.contextPath}/products?action=searchBrands&q=' + encodeURIComponent(searchTerm))
                .then(response => response.json())
                .then(data => {
                    const searchResults = document.getElementById('searchResults');
                    const dynamicBrands = document.getElementById('dynamicBrands');
                    const noMatchMessage = document.getElementById('noMatchMessage');
                    
                    // Filter out default brands AND already selected custom brands
                    const newBrands = data.brands.filter(function(brand) {
                        const isDefault = defaultBrands.map(b => b.toLowerCase()).includes(brand.toLowerCase());
                        const isAlreadySelected = selectedCustomBrands.has(brand);
                        return !isDefault && !isAlreadySelected;
                    });
                    
                    if (newBrands.length > 0) {
                        searchResults.style.display = 'block';
                        noMatchMessage.style.display = 'none';
                        dynamicBrands.innerHTML = '';
                        
                        newBrands.forEach(function(brand) {
                            const labelElement = document.createElement('label');
                            labelElement.className = 'flex items-center cursor-pointer group';
                            
                            const checkbox = document.createElement('input');
                            checkbox.type = 'checkbox';
                            checkbox.name = 'brand';
                            checkbox.value = brand;
                            checkbox.className = 'custom-checkbox brand-checkbox';
                            checkbox.addEventListener('change', function() {
                                if (this.checked) {
                                    selectedCustomBrands.add(brand);
                                    renderSelectedCustomBrands();
                                    // Remove from search results since it's now in selected
                                    labelElement.remove();
                                    // Hide search results if empty
                                    if (dynamicBrands.children.length === 0) {
                                        searchResults.style.display = 'none';
                                    }
                                }
                            });
                            
                            const span = document.createElement('span');
                            span.className = 'ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label';
                            span.textContent = brand;
                            
                            labelElement.appendChild(checkbox);
                            labelElement.appendChild(span);
                            dynamicBrands.appendChild(labelElement);
                        });
                    } else if (visibleDefaultsCount === 0 && selectedCustomBrands.size === 0) {
                        searchResults.style.display = 'block';
                        noMatchMessage.style.display = 'block';
                        dynamicBrands.innerHTML = '';
                    } else {
                        searchResults.style.display = 'none';
                        dynamicBrands.innerHTML = '';
                    }
                })
                .catch(error => {
                    console.error('Error searching brands:', error);
                });
        }
    </script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
