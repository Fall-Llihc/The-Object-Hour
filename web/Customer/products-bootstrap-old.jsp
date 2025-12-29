<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Premium Watches - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        
        body {
            background-color: #F9FAFB;
        }
        
        /* Product Card Styles */
        .product-card {
            border: 1px solid #E5E7EB;
            border-radius: 16px;
            transition: all 0.3s ease;
            background: white;
            height: 100%;
            overflow: hidden;
        }
        
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }
        
        .product-image-container {
            position: relative;
            height: 240px;
            background: linear-gradient(135deg, #EEF2FF 0%, #E0E7FF 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .product-image-container i {
            font-size: 5rem;
            color: #667eea;
            opacity: 0.8;
            transition: all 0.3s;
        }
        
        .product-card:hover .product-image-container i {
            transform: scale(1.1);
            opacity: 1;
        }
        
        .badge-stock {
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 0.5rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.75rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        
        .badge-type {
            position: absolute;
            top: 12px;
            left: 12px;
            padding: 0.4rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.75rem;
            background: white;
            color: #667eea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .product-brand {
            color: #6B7280;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .product-name {
            font-size: 1rem;
            font-weight: 600;
            color: #1F2937;
            margin: 0.5rem 0;
            line-height: 1.4;
            min-height: 2.8rem;
        }
        
        .product-spec {
            color: #9CA3AF;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
            margin: 1rem 0 0.5rem 0;
        }
        
        .btn-add-cart {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            color: white;
            width: 100%;
            transition: all 0.3s;
        }
        
        .btn-add-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(102, 126, 234, 0.4);
        }
        
        /* Filter Sidebar */
        .filter-card {
            border: 1px solid #E5E7EB;
            border-radius: 16px;
            background: white;
            position: sticky;
            top: 100px;
        }
        
        .filter-title {
            font-weight: 700;
            color: #1F2937;
            padding: 1.5rem;
            border-bottom: 1px solid #E5E7EB;
            margin: 0;
        }
        
        .filter-item {
            padding: 0.75rem 1.5rem;
            color: #4B5563;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        
        .filter-item:hover {
            background: #F9FAFB;
            color: #667eea;
        }
        
        .filter-item.active {
            background: #EEF2FF;
            color: #667eea;
            font-weight: 600;
            border-left-color: #667eea;
        }
        
        /* Page Header */
        .page-header {
            background: white;
            border-bottom: 1px solid #E5E7EB;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1F2937;
            margin: 0;
        }
        
        .product-count {
            color: #6B7280;
            font-size: 0.95rem;
        }
        
        /* Quantity Input */
        .quantity-input {
            width: 70px;
            border-radius: 8px;
            border: 2px solid #E5E7EB;
            text-align: center;
            font-weight: 600;
        }
        
        .quantity-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #D1D5DB;
            margin-bottom: 1rem;
        }
        
        .empty-state h3 {
            color: #4B5563;
            font-weight: 600;
        }
        
        .empty-state p {
            color: #9CA3AF;
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <%@ include file="/components/navbar.jsp" %>
    
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Premium Watch Collection</h1>
                    <p class="product-count mb-0">
                        <c:choose>
                            <c:when test="${not empty products}">
                                Showing ${products.size()} premium watches
                            </c:when>
                            <c:otherwise>
                                No products found
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container pb-5">
        <!-- Success Message -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                <c:remove var="success" scope="session"/>
            </div>
        </c:if>
        
        <div class="row g-4">
            <!-- Sidebar Filter -->
            <div class="col-lg-3">
                <div class="filter-card">
                    <h5 class="filter-title">
                        <i class="bi bi-funnel me-2"></i>Filter Products
                    </h5>
                    <div>
                        <a href="${pageContext.request.contextPath}/products" 
                           class="filter-item ${empty param.type ? 'active' : ''}">
                            <span><i class="bi bi-grid-3x3-gap me-2"></i>All Watches</span>
                            <span class="badge bg-light text-dark">All</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?type=ANALOG" 
                           class="filter-item ${param.type eq 'ANALOG' ? 'active' : ''}">
                            <span><i class="bi bi-circle me-2"></i>Analog</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?type=DIGITAL" 
                           class="filter-item ${param.type eq 'DIGITAL' ? 'active' : ''}">
                            <span><i class="bi bi-square me-2"></i>Digital</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?type=SMARTWATCH" 
                           class="filter-item ${param.type eq 'SMARTWATCH' ? 'active' : ''}">
                            <span><i class="bi bi-smartwatch me-2"></i>Smartwatch</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="col-lg-9">
                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                            <c:forEach items="${products}" var="product">
                                <div class="col">
                                    <div class="product-card">
                                        <div class="product-image-container">
                                            <span class="badge-type">${product.type}</span>
                                            <c:choose>
                                                <c:when test="${product.stock > 10}">
                                                    <span class="badge bg-success badge-stock">
                                                        <i class="bi bi-check-circle me-1"></i>In Stock
                                                    </span>
                                                </c:when>
                                                <c:when test="${product.stock > 0}">
                                                    <span class="badge bg-warning text-dark badge-stock">
                                                        <i class="bi bi-exclamation-circle me-1"></i>Low Stock
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger badge-stock">
                                                        <i class="bi bi-x-circle me-1"></i>Out of Stock
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <!-- Product Image from Supabase Storage -->
                                            <img src="${product.imageUrl}" 
                                                 alt="${product.name}"
                                                 style="width: 100%; height: 100%; object-fit: cover; position: absolute; top: 0; left: 0;"
                                                 onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            
                                            <!-- Fallback Icon -->
                                            <i class="bi bi-watch" style="display:none;"></i>
                                        </div>
                                        <div class="p-3">
                                            <div class="product-brand">${product.brand}</div>
                                            <h5 class="product-name">${product.name}</h5>
                                            <div class="product-spec">
                                                <i class="bi bi-bookmark"></i>
                                                <span>${product.strapMaterial}</span>
                                            </div>
                                            <div class="product-price">
                                                <fmt:formatNumber value="${product.price}" type="currency" 
                                                                  currencySymbol="Rp " maxFractionDigits="0"/>
                                            </div>
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <form action="${pageContext.request.contextPath}/cart/add" 
                                                          method="post" class="d-flex gap-2 align-items-center mt-3">
                                                        <input type="hidden" name="productId" value="${product.id}">
                                                        <input type="number" name="quantity" class="form-control quantity-input" 
                                                               value="1" min="1" max="${product.stock}">
                                                        <button type="submit" class="btn btn-add-cart">
                                                            <i class="bi bi-cart-plus me-2"></i>Add to Cart
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary w-100 mt-3" disabled>
                                                        <i class="bi bi-x-circle me-2"></i>Out of Stock
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-inbox"></i>
                            <h3>No Products Found</h3>
                            <p>Try adjusting your filters or search query</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-3">
                                <i class="bi bi-arrow-clockwise me-2"></i>View All Products
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>