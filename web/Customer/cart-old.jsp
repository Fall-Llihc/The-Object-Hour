<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f9fafb; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .cart-item { background: white; border-radius: 10px; padding: 1rem; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-watch"></i> The Object Hour
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a></li>
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/cart"><i class="bi bi-cart"></i> Cart</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders">My Orders</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2><i class="bi bi-cart3"></i> Shopping Cart</h2>
        <hr>
        
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show">
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                <c:remove var="success" scope="session"/>
            </div>
        </c:if>

        <div class="row">
            <div class="col-md-8">
                <c:if test="${not empty cart.items}">
                    <c:forEach items="${cart.items}" var="item">
                        <div class="cart-item">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <div class="bg-light p-3 rounded text-center">
                                        <i class="bi bi-watch" style="font-size: 2rem; color: #667eea;"></i>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <h5>${item.product.name}</h5>
                                    <p class="text-muted mb-0">${item.product.brand}</p>
                                    <small class="text-muted">${item.product.type}</small>
                                </div>
                                <div class="col-md-2">
                                    <p class="mb-0">Price</p>
                                    <h6><fmt:formatNumber value="${item.unitPrice}" type="currency" currencyCode="IDR"/></h6>
                                </div>
                                <div class="col-md-2">
                                    <form action="${pageContext.request.contextPath}/cart/update" method="post">
                                        <input type="hidden" name="cartItemId" value="${item.id}">
                                        <div class="input-group input-group-sm">
                                            <input type="number" name="quantity" class="form-control" value="${item.quantity}" min="0" max="${item.product.stock}">
                                            <button type="submit" class="btn btn-outline-primary btn-sm">
                                                <i class="bi bi-arrow-repeat"></i>
                                            </button>
                                        </div>
                                    </form>
                                </div>
                                <div class="col-md-2 text-end">
                                    <h5 class="text-primary"><fmt:formatNumber value="${item.subtotal}" type="currency" currencyCode="IDR"/></h5>
                                    <a href="${pageContext.request.contextPath}/cart/remove?id=${item.id}" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash"></i> Remove
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                
                <c:if test="${empty cart.items}">
                    <div class="alert alert-info text-center">
                        <i class="bi bi-cart-x" style="font-size: 3rem;"></i>
                        <h4 class="mt-3">Your cart is empty</h4>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-2">
                            <i class="bi bi-shop"></i> Continue Shopping
                        </a>
                    </div>
                </c:if>
            </div>

            <c:if test="${not empty cart.items}">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Cart Summary</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Total Items:</span>
                                <strong>${cart.totalItems}</strong>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-3">
                                <h5>Total:</h5>
                                <h5 class="text-primary">
                                    <fmt:formatNumber value="${total}" type="currency" currencyCode="IDR"/>
                                </h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100 mb-2">
                                <i class="bi bi-credit-card"></i> Proceed to Checkout
                            </a>
                            <a href="${pageContext.request.contextPath}/cart/clear" class="btn btn-outline-danger w-100" 
                               onclick="return confirm('Are you sure you want to clear the cart?')">
                                <i class="bi bi-trash"></i> Clear Cart
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
