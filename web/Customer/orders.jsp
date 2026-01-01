<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pesanan Saya - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .orders-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .order-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .order-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .order-header {
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .order-body {
            padding: 1.5rem;
        }
        
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .status-paid {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .order-info {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-bottom: 1rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-icon {
            color: #667eea;
            font-size: 1.2rem;
        }
        
        .info-text small {
            color: #6b7280;
            font-size: 0.85rem;
        }
        
        .info-text strong {
            color: #1f2937;
        }
        
        .order-items-preview {
            background: #f9fafb;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }
        
        .item-preview {
            color: #6b7280;
            font-size: 0.9rem;
        }
        
        .filter-tabs {
            background: white;
            border-radius: 16px;
            padding: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .filter-tabs .nav-link {
            color: #6b7280;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .filter-tabs .nav-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .filter-tabs .nav-link:hover:not(.active) {
            background: #f3f4f6;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .empty-state i {
            font-size: 5rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }
        
        .btn-view-detail {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-view-detail:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .page-header h1 {
            color: white;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .page-header p {
            color: white;
            opacity: 0.85;
        }
    </style>
</head>
<body>
    <div class="orders-container">
        <div class="page-header">
            <h1><i class="bi bi-bag-check"></i> Pesanan Saya</h1>
            <p>Lacak dan kelola semua pesanan Anda</p>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <ul class="nav nav-pills justify-content-center" id="orderTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="all-tab" data-bs-toggle="pill" 
                            data-bs-target="#all" type="button" role="tab">
                        <i class="bi bi-list-ul me-2"></i> Semua
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="pending-tab" data-bs-toggle="pill" 
                            data-bs-target="#pending" type="button" role="tab">
                        <i class="bi bi-clock-history me-2"></i> Menunggu Pembayaran
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="paid-tab" data-bs-toggle="pill" 
                            data-bs-target="#paid" type="button" role="tab">
                        <i class="bi bi-check-circle me-2"></i> Sudah Dibayar
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="cancelled-tab" data-bs-toggle="pill" 
                            data-bs-target="#cancelled" type="button" role="tab">
                        <i class="bi bi-x-circle me-2"></i> Dibatalkan
                    </button>
                </li>
            </ul>
        </div>

        <!-- Orders List -->
        <div class="tab-content" id="orderTabsContent">
            <div class="tab-pane fade show active" id="all" role="tabpanel">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-state">
                            <i class="bi bi-inbox"></i>
                            <h3 class="text-muted">Belum ada pesanan</h3>
                            <p class="text-muted">Mulai berbelanja dan pesanan Anda akan muncul di sini</p>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-view-detail mt-3">
                                <i class="bi bi-shop me-2"></i> Mulai Belanja
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${orders}" var="order">
                            <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                                <div class="order-header">
                                    <div>
                                        <small class="text-muted">Order #${order.id}</small>
                                        <div class="small text-muted">
                                            <i class="bi bi-calendar3 me-1"></i>
                                            <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm" locale="id_ID"/>
                                        </div>
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${order.status == 'PENDING'}">
                                                <span class="status-badge status-pending">
                                                    <i class="bi bi-clock-history me-1"></i> Menunggu Pembayaran
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'PAID'}">
                                                <span class="status-badge status-paid">
                                                    <i class="bi bi-check-circle-fill me-1"></i> Sudah Dibayar
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-cancelled">
                                                    <i class="bi bi-x-circle-fill me-1"></i> Dibatalkan
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="order-body">
                                    <div class="order-info">
                                        <div class="info-item">
                                            <i class="bi bi-credit-card info-icon"></i>
                                            <div class="info-text">
                                                <small>Metode Pembayaran</small>
                                                <div>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${order.paymentMethod == 'EWALLET'}">E-Wallet</c:when>
                                                            <c:when test="${order.paymentMethod == 'BANK'}">Transfer Bank</c:when>
                                                            <c:otherwise>Cash on Delivery</c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <i class="bi bi-geo-alt info-icon"></i>
                                            <div class="info-text">
                                                <small>Dikirim ke</small>
                                                <div><strong>${order.shippingCity}</strong></div>
                                            </div>
                                        </div>
                                        <div class="info-item ms-auto">
                                            <i class="bi bi-cash-stack info-icon"></i>
                                            <div class="info-text text-end">
                                                <small>Total Pembayaran</small>
                                                <div>
                                                    <strong class="text-primary fs-5">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                        currencySymbol="Rp " groupingUsed="true" 
                                                                        minFractionDigits="0" maxFractionDigits="0"/>
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="order-items-preview">
                                        <div class="item-preview">
                                            <i class="bi bi-box-seam me-2"></i>
                                            <strong>${order.items.size()}</strong> item
                                            <c:if test="${not empty order.items && order.items.size() > 0}">
                                                - ${order.items[0].productName}
                                                <c:if test="${order.items.size() > 1}">
                                                    dan ${order.items.size() - 1} item lainnya
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-end mt-3">
                                        <button type="button" class="btn btn-view-detail"
                                                onclick="event.stopPropagation(); window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                                            <i class="bi bi-eye me-2"></i> Lihat Detail
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="tab-pane fade" id="pending" role="tabpanel">
                <c:set var="hasPending" value="false"/>
                <c:forEach items="${orders}" var="order">
                    <c:if test="${order.status == 'PENDING'}">
                        <c:set var="hasPending" value="true"/>
                        <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                            <!-- Same content as above -->
                            <div class="order-header">
                                <div>
                                    <small class="text-muted">Order #${order.id}</small>
                                    <div class="small text-muted">
                                        <i class="bi bi-calendar3 me-1"></i>
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm" locale="id_ID"/>
                                    </div>
                                </div>
                                <span class="status-badge status-pending">
                                    <i class="bi bi-clock-history me-1"></i> Menunggu Pembayaran
                                </span>
                            </div>
                            <div class="order-body">
                                <div class="order-info">
                                    <div class="info-item">
                                        <i class="bi bi-credit-card info-icon"></i>
                                        <div class="info-text">
                                            <small>Metode Pembayaran</small>
                                            <div>
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${order.paymentMethod == 'EWALLET'}">E-Wallet</c:when>
                                                        <c:when test="${order.paymentMethod == 'BANK'}">Transfer Bank</c:when>
                                                        <c:otherwise>Cash on Delivery</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <i class="bi bi-geo-alt info-icon"></i>
                                        <div class="info-text">
                                            <small>Dikirim ke</small>
                                            <div><strong>${order.shippingCity}</strong></div>
                                        </div>
                                    </div>
                                    <div class="info-item ms-auto">
                                        <i class="bi bi-cash-stack info-icon"></i>
                                        <div class="info-text text-end">
                                            <small>Total Pembayaran</small>
                                            <div>
                                                <strong class="text-primary fs-5">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                    currencySymbol="Rp " groupingUsed="true" 
                                                                    minFractionDigits="0" maxFractionDigits="0"/>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="order-items-preview">
                                    <div class="item-preview">
                                        <i class="bi bi-box-seam me-2"></i>
                                        <strong>${order.items.size()}</strong> item
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end mt-3">
                                    <button type="button" class="btn btn-view-detail"
                                            onclick="event.stopPropagation(); window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                                        <i class="bi bi-eye me-2"></i> Lihat Detail
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasPending}">
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h3 class="text-muted">Tidak ada pesanan menunggu pembayaran</h3>
                    </div>
                </c:if>
            </div>

            <div class="tab-pane fade" id="paid" role="tabpanel">
                <c:set var="hasPaid" value="false"/>
                <c:forEach items="${orders}" var="order">
                    <c:if test="${order.status == 'PAID'}">
                        <c:set var="hasPaid" value="true"/>
                        <!-- Similar card for PAID orders -->
                        <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                            <div class="order-header">
                                <div>
                                    <small class="text-muted">Order #${order.id}</small>
                                    <div class="small text-muted">
                                        <i class="bi bi-calendar3 me-1"></i>
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm" locale="id_ID"/>
                                    </div>
                                </div>
                                <span class="status-badge status-paid">
                                    <i class="bi bi-check-circle-fill me-1"></i> Sudah Dibayar
                                </span>
                            </div>
                            <div class="order-body">
                                <div class="order-info">
                                    <div class="info-item">
                                        <i class="bi bi-credit-card info-icon"></i>
                                        <div class="info-text">
                                            <small>Metode Pembayaran</small>
                                            <div>
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${order.paymentMethod == 'EWALLET'}">E-Wallet</c:when>
                                                        <c:when test="${order.paymentMethod == 'BANK'}">Transfer Bank</c:when>
                                                        <c:otherwise>Cash on Delivery</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <i class="bi bi-geo-alt info-icon"></i>
                                        <div class="info-text">
                                            <small>Dikirim ke</small>
                                            <div><strong>${order.shippingCity}</strong></div>
                                        </div>
                                    </div>
                                    <div class="info-item ms-auto">
                                        <i class="bi bi-cash-stack info-icon"></i>
                                        <div class="info-text text-end">
                                            <small>Total Pembayaran</small>
                                            <div>
                                                <strong class="text-primary fs-5">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                    currencySymbol="Rp " groupingUsed="true" 
                                                                    minFractionDigits="0" maxFractionDigits="0"/>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="order-items-preview">
                                    <div class="item-preview">
                                        <i class="bi bi-box-seam me-2"></i>
                                        <strong>${order.items.size()}</strong> item
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end mt-3">
                                    <button type="button" class="btn btn-view-detail"
                                            onclick="event.stopPropagation(); window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                                        <i class="bi bi-eye me-2"></i> Lihat Detail
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasPaid}">
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h3 class="text-muted">Belum ada pesanan yang dibayar</h3>
                    </div>
                </c:if>
            </div>

            <div class="tab-pane fade" id="cancelled" role="tabpanel">
                <c:set var="hasCancelled" value="false"/>
                <c:forEach items="${orders}" var="order">
                    <c:if test="${order.status == 'CANCELLED'}">
                        <c:set var="hasCancelled" value="true"/>
                        <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                            <div class="order-header">
                                <div>
                                    <small class="text-muted">Order #${order.id}</small>
                                    <div class="small text-muted">
                                        <i class="bi bi-calendar3 me-1"></i>
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm" locale="id_ID"/>
                                    </div>
                                </div>
                                <span class="status-badge status-cancelled">
                                    <i class="bi bi-x-circle-fill me-1"></i> Dibatalkan
                                </span>
                            </div>
                            <div class="order-body">
                                <div class="order-info">
                                    <div class="info-item">
                                        <i class="bi bi-credit-card info-icon"></i>
                                        <div class="info-text">
                                            <small>Metode Pembayaran</small>
                                            <div>
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${order.paymentMethod == 'EWALLET'}">E-Wallet</c:when>
                                                        <c:when test="${order.paymentMethod == 'BANK'}">Transfer Bank</c:when>
                                                        <c:otherwise>Cash on Delivery</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <i class="bi bi-geo-alt info-icon"></i>
                                        <div class="info-text">
                                            <small>Dikirim ke</small>
                                            <div><strong>${order.shippingCity}</strong></div>
                                        </div>
                                    </div>
                                    <div class="info-item ms-auto">
                                        <i class="bi bi-cash-stack info-icon"></i>
                                        <div class="info-text text-end">
                                            <small>Total Pembayaran</small>
                                            <div>
                                                <strong class="text-muted fs-5">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                    currencySymbol="Rp " groupingUsed="true" 
                                                                    minFractionDigits="0" maxFractionDigits="0"/>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="order-items-preview">
                                    <div class="item-preview">
                                        <i class="bi bi-box-seam me-2"></i>
                                        <strong>${order.items.size()}</strong> item
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end mt-3">
                                    <button type="button" class="btn btn-view-detail"
                                            onclick="event.stopPropagation(); window.location.href='${pageContext.request.contextPath}/orders/view?id=${order.id}'">
                                        <i class="bi bi-eye me-2"></i> Lihat Detail
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasCancelled}">
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h3 class="text-muted">Tidak ada pesanan yang dibatalkan</h3>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
