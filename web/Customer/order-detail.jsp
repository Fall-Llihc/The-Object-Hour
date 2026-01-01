<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #${order.id} - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #667eea;
            --primary-dark: #764ba2;
            --success: #10b981;
            --danger: #ef4444;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-600: #6b7280;
            --gray-800: #1f2937;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .order-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }
        
        .order-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }
        
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.75rem 2rem;
            font-size: 1.125rem;
            font-weight: 600;
        }
        
        .card-body-custom {
            padding: 2rem;
        }
        
        .status-badge {
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
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
        
        .info-row {
            display: flex;
            padding: 1rem 0;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #6b7280;
            width: 200px;
            flex-shrink: 0;
        }
        
        .info-value {
            color: #1f2937;
            flex-grow: 1;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            background: #f9fafb;
            border-radius: 12px;
            margin-bottom: 1rem;
        }
        
        .item-info {
            flex-grow: 1;
            margin-left: 1rem;
        }
        
        .payment-instructions {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 1.5rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
        
        .payment-instructions.bank {
            background: #dbeafe;
            border-left-color: #3b82f6;
        }
        
        .payment-instructions.cash {
            background: #dcfce7;
            border-left-color: #10b981;
        }
        
        .total-section {
            background: #f9fafb;
            border-radius: 12px;
            padding: 1.5rem;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .total-row:last-child {
            border-bottom: none;
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
            padding-top: 1rem;
        }
        
        .btn-back {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 0.75rem 2rem;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-cancel {
            background: #ef4444;
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-cancel:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }
        
        .shipping-address {
            background: var(--gray-50);
            padding: 1.5rem;
            border-radius: 12px;
            border-left: 4px solid var(--primary);
        }
        
        .info-group {
            padding-bottom: 0.75rem;
        }
        
        .info-group .info-label {
            font-weight: 600;
            color: var(--gray-600);
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
            display: block;
        }
        
        .info-group .info-value {
            color: var(--gray-800);
            font-size: 1rem;
            padding-left: 1.75rem;
        }
        
        .icon-box {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="order-container">
        <!-- Header -->
        <div class="text-center mb-4">
            <h1 class="text-white mb-2">
                <i class="bi bi-receipt"></i> Detail Pesanan
            </h1>
            <p class="text-white opacity-75">Order #${order.id}</p>
        </div>

        <!-- Success Message -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <!-- Order Status Card -->
        <div class="order-card">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="mb-1">Order #${order.id}</h5>
                    <small class="opacity-75">
                        <fmt:formatDate value="${order.createdAt}" pattern="dd MMMM yyyy, HH:mm" locale="id_ID"/>
                    </small>
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
        </div>

        <div class="row g-4">
            <!-- Left Column -->
            <div class="col-lg-8">
                <!-- Informasi Penerima -->
                <div class="order-card">
                    <div class="card-header-custom">
                        <i class="bi bi-person-badge me-2"></i> Informasi Penerima
                    </div>
                    <div class="card-body-custom">
                        <div class="shipping-address">
                            <div class="info-group mb-3">
                                <label class="info-label"><i class="bi bi-person me-2"></i>Nama Penerima</label>
                                <div class="info-value">${order.shippingName}</div>
                            </div>
                            <div class="info-group mb-3">
                                <label class="info-label"><i class="bi bi-telephone me-2"></i>No. Telepon Penerima</label>
                                <div class="info-value">${order.shippingPhone}</div>
                            </div>
                            <div class="info-group mb-3">
                                <label class="info-label"><i class="bi bi-geo-alt me-2"></i>Alamat Penerima</label>
                                <div class="info-value">${order.shippingAddress}</div>
                            </div>
                            <div class="info-group mb-3">
                                <label class="info-label"><i class="bi bi-building me-2"></i>Kota/Kabupaten</label>
                                <div class="info-value">${order.shippingCity}</div>
                            </div>
                            <c:if test="${not empty order.shippingState}">
                                <div class="info-group mb-3">
                                    <label class="info-label"><i class="bi bi-map me-2"></i>Provinsi</label>
                                    <div class="info-value">${order.shippingState}</div>
                                </div>
                            </c:if>
                            <c:if test="${not empty order.shippingPostalCode}">
                                <div class="info-group">
                                    <label class="info-label"><i class="bi bi-mailbox me-2"></i>Kode Pos</label>
                                    <div class="info-value">${order.shippingPostalCode}</div>
                                </div>
                            </c:if>
                            <c:if test="${not empty order.notes}">
                                <div class="mt-3 pt-3 border-top">
                                    <small class="text-muted"><i class="bi bi-chat-left-text me-2"></i>Catatan:</small>
                                    <p class="mb-0 mt-1">${order.notes}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="order-card">
                    <div class="card-header-custom">
                        <i class="bi bi-box-seam me-2"></i> Item Pesanan
                    </div>
                    <div class="card-body-custom">
                        <c:forEach items="${order.items}" var="item">
                            <div class="order-item">
                                <div class="icon-box">
                                    <i class="bi bi-smartwatch"></i>
                                </div>
                                <div class="item-info">
                                    <h6 class="mb-1">${item.productName}</h6>
                                    <div class="text-muted small">
                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" 
                                                        currencySymbol="Rp " groupingUsed="true" 
                                                        minFractionDigits="0" maxFractionDigits="0"/> 
                                        × ${item.quantity}
                                    </div>
                                </div>
                                <div class="text-end">
                                    <strong>
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" 
                                                        currencySymbol="Rp " groupingUsed="true" 
                                                        minFractionDigits="0" maxFractionDigits="0"/>
                                    </strong>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="col-lg-4">
                <!-- Payment Information -->
                <div class="order-card">
                    <div class="card-header-custom">
                        <i class="bi bi-credit-card me-2"></i> Pembayaran
                    </div>
                    <div class="card-body-custom">
                        <div class="info-row">
                            <div class="info-label">Metode Pembayaran</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'EWALLET'}">
                                        <i class="bi bi-wallet2 me-2"></i> E-Wallet
                                    </c:when>
                                    <c:when test="${order.paymentMethod == 'BANK'}">
                                        <i class="bi bi-bank me-2"></i> Transfer Bank
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-cash-coin me-2"></i> Cash on Delivery
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Payment Instructions -->
                        <c:if test="${order.status == 'PENDING'}">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'EWALLET'}">
                                    <div class="payment-instructions">
                                        <h6 class="mb-2"><i class="bi bi-info-circle me-2"></i>Instruksi Pembayaran</h6>
                                        <ol class="mb-0 ps-3">
                                            <li>Buka aplikasi e-wallet Anda (GoPay, OVO, Dana, ShopeePay)</li>
                                            <li>Scan QR Code atau masukkan nomor: <strong>081234567890</strong></li>
                                            <li>Masukkan nominal: <strong><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="Rp " groupingUsed="true" minFractionDigits="0" maxFractionDigits="0"/></strong></li>
                                            <li>Konfirmasi pembayaran</li>
                                        </ol>
                                    </div>
                                </c:when>
                                <c:when test="${order.paymentMethod == 'BANK'}">
                                    <div class="payment-instructions bank">
                                        <h6 class="mb-2"><i class="bi bi-info-circle me-2"></i>Instruksi Transfer</h6>
                                        <div class="mb-2">
                                            <small class="text-muted d-block">Bank</small>
                                            <strong>BCA</strong>
                                        </div>
                                        <div class="mb-2">
                                            <small class="text-muted d-block">No. Rekening</small>
                                            <strong>1234567890</strong>
                                        </div>
                                        <div class="mb-2">
                                            <small class="text-muted d-block">Atas Nama</small>
                                            <strong>The Object Hour</strong>
                                        </div>
                                        <div>
                                            <small class="text-muted d-block">Jumlah Transfer</small>
                                            <strong class="text-primary">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                currencySymbol="Rp " groupingUsed="true" 
                                                                minFractionDigits="0" maxFractionDigits="0"/>
                                            </strong>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="payment-instructions cash">
                                        <h6 class="mb-2"><i class="bi bi-info-circle me-2"></i>Cash on Delivery</h6>
                                        <p class="mb-0">Pembayaran akan dilakukan saat barang diterima. Siapkan uang tunai sejumlah:</p>
                                        <strong class="text-success fs-5">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                            currencySymbol="Rp " groupingUsed="true" 
                                                            minFractionDigits="0" maxFractionDigits="0"/>
                                        </strong>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <c:if test="${order.status == 'PAID' && not empty order.paidAt}">
                            <div class="alert alert-success mt-3 mb-0">
                                <small class="d-block mb-1"><i class="bi bi-calendar-check me-2"></i>Dibayar pada:</small>
                                <strong><fmt:formatDate value="${order.paidAt}" pattern="dd MMMM yyyy, HH:mm" locale="id_ID"/></strong>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="order-card">
                    <div class="card-header-custom">
                        <i class="bi bi-calculator me-2"></i> Ringkasan
                    </div>
                    <div class="card-body-custom">
                        <div class="total-section">
                            <div class="total-row">
                                <span>Subtotal</span>
                                <span>
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                    currencySymbol="Rp " groupingUsed="true" 
                                                    minFractionDigits="0" maxFractionDigits="0"/>
                                </span>
                            </div>
                            <div class="total-row">
                                <span>Ongkir</span>
                                <span class="text-success">GRATIS</span>
                            </div>
                            <div class="total-row">
                                <span>Total</span>
                                <span>
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                    currencySymbol="Rp " groupingUsed="true" 
                                                    minFractionDigits="0" maxFractionDigits="0"/>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-back">
                        <i class="bi bi-arrow-left me-2"></i> Kembali ke Daftar Pesanan
                    </a>
                    <c:if test="${order.status == 'PENDING'}">
                        <button type="button" class="btn btn-cancel" onclick="confirmCancel()">
                            <i class="bi bi-x-circle me-2"></i> Batalkan Pesanan
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmCancel() {
            if (confirm('Apakah Anda yakin ingin membatalkan pesanan ini?')) {
                window.location.href = '${pageContext.request.contextPath}/orders/cancel?id=${order.id}';
            }
        }
    </script>
</body>
</html>
