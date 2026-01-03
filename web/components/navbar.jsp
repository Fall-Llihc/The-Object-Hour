<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Modern Navbar Component -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/products">
            <div class="brand-logo-icon me-2">
                <i class="bi bi-watch"></i>
            </div>
            <div>
                <span class="brand-name">The Object Hour</span>
                <br><small class="brand-tagline">Premium Watches</small>
            </div>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Search Bar -->
            <form class="d-flex mx-auto my-2 my-lg-0" style="width: 100%; max-width: 500px;" 
                  action="${pageContext.request.contextPath}/products/search" method="get">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0">
                        <i class="bi bi-search text-muted"></i>
                    </span>
                    <input class="form-control border-start-0 ps-0" type="search" 
                           name="keyword" placeholder="Search watches..." value="${param.keyword}">
                </div>
            </form>
            
            <!-- Right Menu -->
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">
                            <i class="bi bi-speedometer2"></i>
                            <span class="d-lg-none d-inline ms-2">Dashboard</span>
                        </a>
                    </li>
                </c:if>
                
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3" style="font-size: 1.25rem;"></i>
                        <span class="d-lg-none d-inline ms-2">Cart</span>
                        <c:if test="${not empty sessionScope.cartCount && sessionScope.cartCount > 0}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                ${sessionScope.cartCount}
                            </span>
                        </c:if>
                    </a>
                </li>
                
                <li class="nav-item d-flex align-items-center dropdown">
                    <a class="nav-link fw-semibold pe-1" href="${pageContext.request.contextPath}/history">
                        ${sessionScope.user.name}
                    </a>

                    <a class="nav-link dropdown-toggle ps-1" 
                       href="#" 
                       role="button" 
                       data-bs-toggle="dropdown" 
                       aria-expanded="false">
                        <i class="bi bi-person-circle fs-4"></i>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><h6 class="dropdown-header">${sessionScope.user.name}</h6></li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                <i class="bi bi-bag-check me-2"></i>My Orders
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Logout
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<style>
    .navbar {
        border-bottom: 1px solid #E5E7EB;
    }
    
    .brand-logo-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.5rem;
    }
    
    .brand-name {
        font-weight: 700;
        font-size: 1.1rem;
        color: #1F2937;
        line-height: 1.2;
    }
    
    .brand-tagline {
        color: #6B7280;
        font-size: 0.75rem;
    }
    
    .navbar .form-control:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .nav-link {
        color: #4B5563 !important;
        font-weight: 500;
        padding: 0.5rem 1rem !important;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .nav-link:hover {
        background: #F3F4F6;
        color: #667eea !important;
    }
    
    .user-avatar {
        font-size: 1.75rem;
        color: #667eea;
    }
    
    .dropdown-menu {
        border: none;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        border-radius: 12px;
        padding: 0.5rem;
    }
    
    .dropdown-item {
        border-radius: 8px;
        padding: 0.5rem 1rem;
    }
    
    .dropdown-item:hover {
        background: #F3F4F6;
    }
</style>
