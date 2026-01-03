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
                
                <form action="${pageContext.request.contextPath}/products" method="get" class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" name="search" value="${search}" placeholder="Search watches, brands..." 
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

    <div class="container mx-auto px-3 sm:px-4 py-8">
        <div class="flex gap-6">
            <!-- Sidebar Filter -->
            <aside class="w-72 flex-shrink-0 hidden lg:block">
                <form action="${pageContext.request.contextPath}/products" method="get" id="filterForm">
                    <!-- Hidden search field to preserve search when filtering -->
                    <input type="hidden" name="search" value="${search}">
                    <div class="bg-white rounded-2xl shadow-sm p-6 sticky top-24">
                        <h3 class="font-bold text-xl mb-6 text-gray-900">Filters</h3>
                        
                        <!-- Category Filter (Multiple Choice) -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Category</h4>
                            <div class="space-y-3">
                                <label class="flex items-center cursor-pointer group">
                                    <input type="checkbox" name="type" value="ANALOG" 
                                           ${selectedTypes.contains('ANALOG') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Analog</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="checkbox" name="type" value="DIGITAL" 
                                           ${selectedTypes.contains('DIGITAL') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Digital</span>
                                </label>
                                <label class="flex items-center cursor-pointer group">
                                    <input type="checkbox" name="type" value="SMARTWATCH" 
                                           ${selectedTypes.contains('SMARTWATCH') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600">Smartwatch</span>
                                </label>
                            </div>
                        </div>
                        
                        <!-- Brand Filter (Multiple Choice + Search) -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Brand</h4>
                            
                            <!-- Brand Search Input -->
                            <div class="mb-4">
                                <input type="text" id="brandSearch" placeholder="Search brands..." 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                            </div>
                            
                            <!-- Default Brand Checkboxes (always visible) -->
                            <div id="defaultBrands" class="space-y-3">
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Apple" 
                                           ${selectedBrands.contains('Apple') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Apple</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Casio" 
                                           ${selectedBrands.contains('Casio') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Casio</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Samsung" 
                                           ${selectedBrands.contains('Samsung') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Samsung</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Xiaomi" 
                                           ${selectedBrands.contains('Xiaomi') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Xiaomi</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="DanielW" 
                                           ${selectedBrands.contains('DanielW') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">DanielW</span>
                                </label>
                                <label class="flex items-center cursor-pointer group default-brand">
                                    <input type="checkbox" name="brand" value="Huawei" 
                                           ${selectedBrands.contains('Huawei') ? 'checked' : ''}
                                           class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox">
                                    <span class="ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label">Huawei</span>
                                </label>
                            </div>
                            
                            <!-- Dynamic Search Results -->
                            <div id="searchResults" class="mt-3" style="display: none;">
                                <div class="text-xs text-gray-500 mb-2 font-medium">Search Results:</div>
                                <div id="dynamicBrands" class="space-y-2"></div>
                                <div id="noMatchMessage" class="text-sm text-gray-400 italic" style="display: none;">
                                    No brands match your search.
                                </div>
                            </div>
                            
                            <!-- Selected Non-Default Brands -->
                            <div id="selectedNonDefaultBrands" class="mt-3" style="display: none;">
                                <div class="text-xs text-gray-500 mb-2 font-medium">Selected Brands:</div>
                                <div id="selectedBrandsList" class="space-y-2"></div>
                            </div>
                        </div>
                        
                        <!-- Price Range (Manual Input) -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Price Range</h4>
                            <div class="space-y-3">
                                <div>
                                    <label class="text-xs text-gray-600 mb-1 block">Min Price (Rp)</label>
                                    <input type="number" name="minPrice" value="${minPrice}" placeholder="0"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                                </div>
                                <div>
                                    <label class="text-xs text-gray-600 mb-1 block">Max Price (Rp)</label>
                                    <input type="number" name="maxPrice" value="${maxPrice}" placeholder="10000000"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Stock Status -->
                        <div class="mb-6">
                            <h4 class="font-semibold text-sm text-gray-700 mb-4 uppercase tracking-wide">Availability</h4>
                            <label class="flex items-center cursor-pointer group">
                                <input type="checkbox" name="inStock" value="true" ${inStock ? 'checked' : ''}
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
                                    <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}" class="block">
                                        <div class="bg-gray-100 h-48 flex items-center justify-center relative overflow-hidden">
                                            <!-- Product Image from Supabase Storage -->
                                            <img src="${product.imageUrl}" 
                                                 data-jpg-url="${product.imageUrlJpg}"
                                                 alt="${product.name}"
                                                 class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                                 onerror="if(this.src.endsWith('.png')){this.src=this.getAttribute('data-jpg-url');}else{this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';}">
                                            
                                            <!-- Fallback Icon (shown if image fails to load) -->
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
                                    </a>
                                    <div class="p-4">
                                        <p class="text-xs text-gray-500 uppercase tracking-wide mb-1 font-medium">${product.brand}</p>
                                        <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}">
                                            <h3 class="font-bold text-gray-900 mb-2 text-base hover:text-blue-600 transition">${product.name}</h3>
                                        </a>
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
                <c:if test="${totalPages > 1}">
                    <div class="flex justify-center items-center mt-10 space-x-2">
                        <!-- Previous Button -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if>" 
                                   class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">
                                    <i class="bi bi-chevron-left"></i> Previous
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button disabled class="px-4 py-2 border-2 border-gray-300 rounded-lg font-medium text-gray-400 opacity-50 cursor-not-allowed">
                                    <i class="bi bi-chevron-left"></i> Previous
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page Numbers -->
                        <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                        <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />
                        
                        <!-- First page if not in range -->
                        <c:if test="${startPage > 1}">
                            <a href="?page=1<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if>" 
                               class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">
                                1
                            </a>
                            <c:if test="${startPage > 2}">
                                <span class="px-2 text-gray-400">...</span>
                            </c:if>
                        </c:if>

                        <!-- Page number buttons -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <button class="px-4 py-2 bg-blue-600 text-white rounded-lg font-semibold">${i}</button>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${i}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if>" 
                                       class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">
                                        ${i}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Last page if not in range -->
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <span class="px-2 text-gray-400">...</span>
                            </c:if>
                            <a href="?page=${totalPages}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if>" 
                               class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">
                                ${totalPages}
                            </a>
                        </c:if>

                        <!-- Next Button -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}<c:if test='${not empty search}'>&search=${search}</c:if><c:forEach items='${selectedTypes}' var='t'>&type=${t}</c:forEach><c:forEach items='${selectedBrands}' var='b'>&brand=${b}</c:forEach><c:if test='${not empty minPrice}'>&minPrice=${minPrice}</c:if><c:if test='${not empty maxPrice}'>&maxPrice=${maxPrice}</c:if><c:if test='${inStock}'>&inStock=true</c:if>" 
                                   class="px-4 py-2 border-2 border-gray-300 rounded-lg hover:bg-gray-50 font-medium text-gray-700">
                                    Next <i class="bi bi-chevron-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button disabled class="px-4 py-2 border-2 border-gray-300 rounded-lg font-medium text-gray-400 opacity-50 cursor-not-allowed">
                                    Next <i class="bi bi-chevron-right"></i>
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </main>
        </div>
    </div>

    <footer class="bg-gray-900 text-white py-8 mt-16">
        <div class="container mx-auto px-3 sm:px-4 text-center">
            <p class="text-gray-400">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>

    <script>
        let searchTimeout;
        const defaultBrands = ['Apple', 'Casio', 'Samsung', 'Xiaomi', 'DanielW', 'Huawei'];
        
        // Get selected brands from JSP
        const selectedBrandsFromJSP = [
            <c:forEach var="brand" items="${selectedBrands}" varStatus="status">
                "${brand}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Get all available brands from JSP
        const allAvailableBrands = [
            <c:forEach var="brand" items="${allAvailableBrands}" varStatus="status">
                "${brand}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Initialize selected non-default brands on page load
        function initializeSelectedNonDefaultBrands() {
            const selectedNonDefaultContainer = document.getElementById('selectedNonDefaultBrands');
            const selectedBrandsList = document.getElementById('selectedBrandsList');
            
            // Find selected brands that are not in default list
            const selectedNonDefaultBrands = selectedBrandsFromJSP.filter(brand => 
                !defaultBrands.some(defaultBrand => 
                    defaultBrand.toLowerCase() === brand.toLowerCase()
                )
            );
            
            if (selectedNonDefaultBrands.length > 0) {
                selectedNonDefaultContainer.style.display = 'block';
                selectedBrandsList.innerHTML = '';
                
                selectedNonDefaultBrands.forEach(brand => {
                    const labelElement = document.createElement('label');
                    labelElement.className = 'flex items-center cursor-pointer group selected-non-default-brand';
                    
                    const checkbox = document.createElement('input');
                    checkbox.type = 'checkbox';
                    checkbox.name = 'brand';
                    checkbox.value = brand;
                    checkbox.checked = true;
                    checkbox.className = 'w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox';
                    
                    const span = document.createElement('span');
                    span.className = 'ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label';
                    span.textContent = brand;
                    
                    labelElement.appendChild(checkbox);
                    labelElement.appendChild(span);
                    selectedBrandsList.appendChild(labelElement);
                });
            } else {
                selectedNonDefaultContainer.style.display = 'none';
            }
        }
        
        // Enhanced brand filter search functionality
        document.getElementById('brandSearch')?.addEventListener('input', function(e) {
            const searchTerm = e.target.value.trim();
            
            // Clear previous timeout
            if (searchTimeout) {
                clearTimeout(searchTimeout);
            }
            
            // If search is empty, show only default brands
            if (!searchTerm) {
                resetToDefaultBrands();
                return;
            }
            
            // Debounce the search to avoid too many API calls
            searchTimeout = setTimeout(() => {
                performBrandSearch(searchTerm);
            }, 300);
        });
        
        // Add event listener for checkbox changes using event delegation
        document.addEventListener('change', function(e) {
            if (e.target.classList.contains('brand-checkbox')) {
                handleBrandCheckboxChange(e.target);
            }
        });
        
        function handleBrandCheckboxChange(checkbox) {
            const brandLabel = checkbox.closest('label');
            const brandName = checkbox.value;
            const isDefaultBrand = defaultBrands.some(defaultBrand => 
                defaultBrand.toLowerCase() === brandName.toLowerCase()
            );
            
            if (checkbox.checked) {
                // Move checked brand to appropriate section
                if (isDefaultBrand) {
                    moveToTop(brandLabel, false);
                } else {
                    // Move to selected non-default brands section
                    moveToSelectedNonDefault(brandLabel);
                }
            } else {
                // If it's unchecked
                if (isDefaultBrand) {
                    // If it's a default brand, move it back to its original position
                    restoreDefaultPosition(brandLabel, brandName);
                } else {
                    // If it's a non-default brand, remove it
                    brandLabel.remove();
                    updateSelectedNonDefaultVisibility();
                }
            }
        }
        
        function moveToSelectedNonDefault(brandLabel) {
            const selectedNonDefaultContainer = document.getElementById('selectedNonDefaultBrands');
            const selectedBrandsList = document.getElementById('selectedBrandsList');
            
            // Remove from current location
            brandLabel.remove();
            
            // Add to selected non-default section
            brandLabel.className = 'flex items-center cursor-pointer group selected-non-default-brand';
            selectedBrandsList.appendChild(brandLabel);
            selectedNonDefaultContainer.style.display = 'block';
        }
        
        function updateSelectedNonDefaultVisibility() {
            const selectedNonDefaultContainer = document.getElementById('selectedNonDefaultBrands');
            const selectedBrandsList = document.getElementById('selectedBrandsList');
            
            if (selectedBrandsList.children.length === 0) {
                selectedNonDefaultContainer.style.display = 'none';
            }
        }
        
        function moveToTop(brandLabel, isDynamic) {
            const container = isDynamic ? 
                document.getElementById('dynamicBrands') : 
                document.getElementById('defaultBrands');
            
            // Insert at the beginning of the container
            container.insertBefore(brandLabel, container.firstChild);
        }
        
        function restoreDefaultPosition(brandLabel, brandName) {
            const defaultContainer = document.getElementById('defaultBrands');
            const defaultBrandsList = ['Apple', 'Casio', 'Samsung', 'Xiaomi', 'DanielW', 'Huawei'];
            const targetIndex = defaultBrandsList.findIndex(brand => 
                brand.toLowerCase() === brandName.toLowerCase()
            );
            
            if (targetIndex === -1) return;
            
            const allDefaultLabels = Array.from(defaultContainer.children);
            let insertPosition = null;
            
            // Find the correct position to insert
            for (let i = targetIndex + 1; i < defaultBrandsList.length; i++) {
                const nextBrand = defaultBrandsList[i];
                const nextLabel = allDefaultLabels.find(label => 
                    label.querySelector('.brand-label').textContent.toLowerCase() === nextBrand.toLowerCase()
                );
                if (nextLabel) {
                    insertPosition = nextLabel;
                    break;
                }
            }
            
            brandLabel.className = 'flex items-center cursor-pointer group default-brand';
            
            if (insertPosition) {
                defaultContainer.insertBefore(brandLabel, insertPosition);
            } else {
                defaultContainer.appendChild(brandLabel);
            }
        }
        
        function resetToDefaultBrands() {
            const searchResults = document.getElementById('searchResults');
            const dynamicBrands = document.getElementById('dynamicBrands');
            
            // Clear all search results (they'll be preserved in selected section if checked)
            dynamicBrands.innerHTML = '';
            searchResults.style.display = 'none';
            
            // Show all default brands and reorganize them
            reorganizeDefaultBrands();
        }
        
        function reorganizeDefaultBrands() {
            const defaultContainer = document.getElementById('defaultBrands');
            const allDefaultLabels = Array.from(defaultContainer.children);
            
            // Separate checked and unchecked brands
            const checkedBrands = [];
            const uncheckedBrands = [];
            
            allDefaultLabels.forEach(label => {
                const checkbox = label.querySelector('.brand-checkbox');
                const brandName = checkbox.value;
                
                label.style.display = 'flex'; // Show all default brands
                
                if (checkbox.checked) {
                    checkedBrands.push({label, brandName, index: defaultBrands.indexOf(brandName)});
                } else {
                    uncheckedBrands.push({label, brandName, index: defaultBrands.indexOf(brandName)});
                }
            });
            
            // Sort by original index
            checkedBrands.sort((a, b) => a.index - b.index);
            uncheckedBrands.sort((a, b) => a.index - b.index);
            
            // Clear container and reorganize: checked first, then unchecked
            defaultContainer.innerHTML = '';
            [...checkedBrands, ...uncheckedBrands].forEach(item => {
                defaultContainer.appendChild(item.label);
            });
        }
        
        function performBrandSearch(searchTerm) {
            // Filter default brands by search term (case-insensitive)
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
            
            // Reorganize visible default brands (checked on top)
            reorganizeVisibleDefaults();
            
            // Search database for additional brands
            fetch('${pageContext.request.contextPath}/products?action=searchBrands&q=' + encodeURIComponent(searchTerm))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    const searchResults = document.getElementById('searchResults');
                    const dynamicBrands = document.getElementById('dynamicBrands');
                    const noMatchMessage = document.getElementById('noMatchMessage');
                    
                    // Preserve existing checked dynamic brands
                    const existingCheckedBrands = [];
                    const existingDynamicLabels = Array.from(dynamicBrands.children);
                    existingDynamicLabels.forEach(label => {
                        const checkbox = label.querySelector('.brand-checkbox');
                        if (checkbox && checkbox.checked) {
                            existingCheckedBrands.push({
                                element: label,
                                brandName: checkbox.value
                            });
                        }
                    });
                    
                    // Clear only unchecked dynamic brands
                    existingDynamicLabels.forEach(label => {
                        const checkbox = label.querySelector('.brand-checkbox');
                        if (!checkbox || !checkbox.checked) {
                            label.remove();
                        }
                    });
                    
                    // Get brands already present (defaults + existing dynamic)
                    const existingBrandNames = [
                        ...defaultBrands.map(b => b.toLowerCase()),
                        ...existingCheckedBrands.map(b => b.brandName.toLowerCase())
                    ];
                    
                    // Filter out brands that are already present (case-insensitive comparison)
                    const newBrands = data.brands.filter(brand => 
                        !existingBrandNames.includes(brand.toLowerCase())
                    );
                    
                    // Check if we have any results
                    const totalMatches = visibleDefaultsCount + existingCheckedBrands.length + newBrands.length;
                    
                    if (newBrands.length > 0 || existingCheckedBrands.length > 0) {
                        // Show search results section
                        searchResults.style.display = 'block';
                        noMatchMessage.style.display = 'none';
                        
                        // Separate new brands into checked and unchecked
                        const checkedNewBrands = [];
                        const uncheckedNewBrands = [];
                        
                        newBrands.forEach(brand => {
                            const isSelected = selectedBrandsFromJSP.includes(brand);
                            if (isSelected) {
                                checkedNewBrands.push(brand);
                            } else {
                                uncheckedNewBrands.push(brand);
                            }
                        });
                        
                        // Create new brand elements
                        const newBrandElements = [];
                        [...checkedNewBrands, ...uncheckedNewBrands].forEach(brand => {
                            const isSelected = selectedBrandsFromJSP.includes(brand);
                            const labelElement = document.createElement('label');
                            labelElement.className = 'flex items-center cursor-pointer group dynamic-brand';
                            
                            const checkbox = document.createElement('input');
                            checkbox.type = 'checkbox';
                            checkbox.name = 'brand';
                            checkbox.value = brand;
                            checkbox.checked = isSelected;
                            checkbox.className = 'w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-2 focus:ring-blue-500 brand-checkbox';
                            
                            const span = document.createElement('span');
                            span.className = 'ml-3 text-sm text-gray-700 group-hover:text-blue-600 brand-label';
                            span.textContent = brand;
                            
                            labelElement.appendChild(checkbox);
                            labelElement.appendChild(span);
                            
                            newBrandElements.push({
                                element: labelElement,
                                brandName: brand,
                                isChecked: isSelected
                            });
                        });
                        
                        // Reorganize all dynamic brands: existing checked + new checked + new unchecked
                        const allDynamicBrands = [...existingCheckedBrands, ...newBrandElements];
                        const checkedDynamic = allDynamicBrands.filter(b => 
                            (b.element.querySelector && b.element.querySelector('.brand-checkbox').checked) || b.isChecked
                        );
                        const uncheckedDynamic = allDynamicBrands.filter(b => 
                            !(b.element.querySelector && b.element.querySelector('.brand-checkbox').checked) && !b.isChecked
                        );
                        
                        // Clear and reorganize
                        dynamicBrands.innerHTML = '';
                        [...checkedDynamic, ...uncheckedDynamic].forEach(item => {
                            dynamicBrands.appendChild(item.element);
                        });
                    }
                    
                    // Show or hide search results section
                    const hasAnyDynamicBrands = dynamicBrands.children.length > 0;
                    if (hasAnyDynamicBrands) {
                        searchResults.style.display = 'block';
                        noMatchMessage.style.display = 'none';
                    } else if (totalMatches === 0) {
                        searchResults.style.display = 'block';
                        noMatchMessage.style.display = 'block';
                        noMatchMessage.textContent = 'No brands match your search.';
                    } else {
                        searchResults.style.display = 'none';
                    }
                })
                .catch(error => {
                    console.error('Error searching brands:', error);
                    const searchResults = document.getElementById('searchResults');
                    const noMatchMessage = document.getElementById('noMatchMessage');
                    
                    searchResults.style.display = 'block';
                    noMatchMessage.style.display = 'block';
                    noMatchMessage.textContent = 'Error searching brands. Please try again.';
                });
        }
        
        function reorganizeVisibleDefaults() {
            const defaultContainer = document.getElementById('defaultBrands');
            const visibleLabels = Array.from(defaultContainer.children).filter(label => 
                label.style.display !== 'none'
            );
            
            const checkedVisible = [];
            const uncheckedVisible = [];
            
            visibleLabels.forEach(label => {
                const checkbox = label.querySelector('.brand-checkbox');
                const brandName = checkbox.value;
                
                if (checkbox.checked) {
                    checkedVisible.push({label, brandName, index: defaultBrands.findIndex(b => b.toLowerCase() === brandName.toLowerCase())});
                } else {
                    uncheckedVisible.push({label, brandName, index: defaultBrands.findIndex(b => b.toLowerCase() === brandName.toLowerCase())});
                }
            });
            
            // Sort by original index
            checkedVisible.sort((a, b) => a.index - b.index);
            uncheckedVisible.sort((a, b) => a.index - b.index);
            
            // Reorganize: move checked ones to top while maintaining their relative order
            [...checkedVisible, ...uncheckedVisible].forEach((item, index) => {
                const currentIndex = Array.from(defaultContainer.children).indexOf(item.label);
                if (currentIndex !== index) {
                    if (index === 0) {
                        defaultContainer.insertBefore(item.label, defaultContainer.firstChild);
                    } else {
                        const previousItem = [...checkedVisible, ...uncheckedVisible][index - 1];
                        defaultContainer.insertBefore(item.label, previousItem.label.nextSibling);
                    }
                }
            });
        }
        
        function reorganizeDefaultBrands() {
            const defaultContainer = document.getElementById('defaultBrands');
            const allDefaultLabels = Array.from(defaultContainer.children);
            
            // Separate checked and unchecked brands
            const checkedBrands = [];
            const uncheckedBrands = [];
            
            allDefaultLabels.forEach(label => {
                const checkbox = label.querySelector('.brand-checkbox');
                const brandName = checkbox.value;
                
                label.style.display = 'flex'; // Show all default brands
                
                if (checkbox.checked) {
                    checkedBrands.push({label, brandName, index: defaultBrands.findIndex(b => b.toLowerCase() === brandName.toLowerCase())});
                } else {
                    uncheckedBrands.push({label, brandName, index: defaultBrands.findIndex(b => b.toLowerCase() === brandName.toLowerCase())});
                }
            });
            
            // Sort by original index
            checkedBrands.sort((a, b) => a.index - b.index);
            uncheckedBrands.sort((a, b) => a.index - b.index);
            
            // Clear container and reorganize: checked first, then unchecked
            defaultContainer.innerHTML = '';
            [...checkedBrands, ...uncheckedBrands].forEach(item => {
                defaultContainer.appendChild(item.label);
            });
        }
        
        // Initialize the brand organization on page load
        document.addEventListener('DOMContentLoaded', function() {
            initializeSelectedNonDefaultBrands();
            reorganizeDefaultBrands();
        });
    </script>
</body>
</html>
