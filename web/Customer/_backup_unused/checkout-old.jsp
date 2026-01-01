<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .checkout-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .checkout-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        
        .section-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            font-size: 1.25rem;
            font-weight: 600;
        }
        
        .section-body {
            padding: 2rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
        }
        
        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .payment-option {
            border: 2px solid #e2e8f0;
            border-radius: 15px;
            padding: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }
        
        .payment-option:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }
        
        .payment-option input[type="radio"] {
            width: 20px;
            height: 20px;
            accent-color: #667eea;
        }
        
        .payment-option.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
        }
        
        .payment-icon {
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
        
        .order-summary {
            background: #f7fafc;
            border-radius: 15px;
            padding: 1.5rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .summary-row:last-child {
            border-bottom: none;
            font-weight: 600;
            font-size: 1.25rem;
            color: #667eea;
        }
        
        .cart-item {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            background: white;
            border-radius: 10px;
            margin-bottom: 0.75rem;
        }
        
        .item-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .btn-checkout {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 1rem 3rem;
            font-size: 1.125rem;
            font-weight: 600;
            border-radius: 12px;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        
        .alert {
            border-radius: 12px;
            border: none;
        }
    </style>
</head>
<body>
    <div class="checkout-container">
        <!-- Header -->
        <div class="text-center mb-4">
            <h1 class="text-white mb-2">
                <i class="bi bi-bag-check-fill"></i> Checkout
            </h1>
            <p class="text-white opacity-75">Lengkapi informasi pengiriman dan pilih metode pembayaran</p>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout/process" method="post">
            <div class="row g-4">
                <!-- Left Column: Forms -->
                <div class="col-lg-7">
                    <!-- Shipping Information -->
                    <div class="checkout-card mb-4">
                        <div class="section-header">
                            <i class="bi bi-truck me-2"></i> Informasi Pengiriman
                        </div>
                        <div class="section-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="shippingName" class="form-label">Nama Penerima *</label>
                                    <input type="text" class="form-control" id="shippingName" name="shippingName" 
                                           placeholder="Nama lengkap penerima" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="shippingPhone" class="form-label">Nomor Telepon *</label>
                                    <input type="tel" class="form-control" id="shippingPhone" name="shippingPhone" 
                                           placeholder="08xxxxxxxxxx" pattern="[0-9]{10,13}" required>
                                    <small class="text-muted">Contoh: 081234567890</small>
                                </div>
                                <div class="col-12">
                                    <label for="shippingAddress" class="form-label">Alamat Lengkap *</label>
                                    <textarea class="form-control" id="shippingAddress" name="shippingAddress" 
                                              rows="3" placeholder="Jalan, RT/RW, Kelurahan, Kecamatan" required></textarea>
                                </div>
                                <div class="col-md-8">
                                    <label for="shippingCity" class="form-label">Kota *</label>
                                    <input type="text" class="form-control" id="shippingCity" name="shippingCity" 
                                           placeholder="Nama kota" required>
                                </div>
                                <div class="col-md-4">
                                    <label for="shippingPostalCode" class="form-label">Kode Pos</label>
                                    <input type="text" class="form-control" id="shippingPostalCode" 
                                           name="shippingPostalCode" placeholder="12345" pattern="[0-9]{5}">
                                </div>
                                <div class="col-12">
                                    <label for="notes" class="form-label">Catatan (Opsional)</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="2" 
                                              placeholder="Catatan untuk kurir atau toko"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="checkout-card">
                        <div class="section-header">
                            <i class="bi bi-credit-card me-2"></i> Metode Pembayaran
                        </div>
                        <div class="section-body">
                            <div class="payment-options">
                                <!-- E-Wallet -->
                                <label class="payment-option" for="ewallet">
                                    <div class="d-flex align-items-center">
                                        <input type="radio" id="ewallet" name="paymentMethod" value="EWALLET" required>
                                        <div class="payment-icon ms-3">
                                            <i class="bi bi-wallet2"></i>
                                        </div>
                                        <div class="ms-3 flex-grow-1">
                                            <h6 class="mb-1">E-Wallet</h6>
                                            <small class="text-muted">GoPay, OVO, Dana, ShopeePay</small>
                                        </div>
                                        <i class="bi bi-chevron-right text-muted"></i>
                                    </div>
                                </label>

                                <!-- Bank Transfer -->
                                <label class="payment-option" for="bank">
                                    <div class="d-flex align-items-center">
                                        <input type="radio" id="bank" name="paymentMethod" value="BANK" required>
                                        <div class="payment-icon ms-3">
                                            <i class="bi bi-bank"></i>
                                        </div>
                                        <div class="ms-3 flex-grow-1">
                                            <h6 class="mb-1">Transfer Bank</h6>
                                            <small class="text-muted">BCA, Mandiri, BNI, BRI</small>
                                        </div>
                                        <i class="bi bi-chevron-right text-muted"></i>
                                    </div>
                                </label>

                                <!-- Cash on Delivery -->
                                <label class="payment-option" for="cash">
                                    <div class="d-flex align-items-center">
                                        <input type="radio" id="cash" name="paymentMethod" value="CASH" required>
                                        <div class="payment-icon ms-3">
                                            <i class="bi bi-cash-coin"></i>
                                        </div>
                                        <div class="ms-3 flex-grow-1">
                                            <h6 class="mb-1">Cash on Delivery (COD)</h6>
                                            <small class="text-muted">Bayar saat barang diterima</small>
                                        </div>
                                        <i class="bi bi-chevron-right text-muted"></i>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Order Summary -->
                <div class="col-lg-5">
                    <div class="checkout-card">
                        <div class="section-header">
                            <i class="bi bi-receipt me-2"></i> Ringkasan Pesanan
                        </div>
                        <div class="section-body">
                            <!-- Cart Items -->
                            <div class="mb-3">
                                <c:forEach items="${cart.items}" var="item">
                                    <div class="cart-item">
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">${item.product.name}</h6>
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

                            <!-- Summary -->
                            <div class="order-summary">
                                <div class="summary-row">
                                    <span>Subtotal</span>
                                    <span>
                                        <fmt:formatNumber value="${total}" type="currency" 
                                                        currencySymbol="Rp " groupingUsed="true" 
                                                        minFractionDigits="0" maxFractionDigits="0"/>
                                    </span>
                                </div>
                                <div class="summary-row">
                                    <span>Ongkir</span>
                                    <span class="text-success">GRATIS</span>
                                </div>
                                <div class="summary-row">
                                    <span>Total Pembayaran</span>
                                    <span>
                                        <fmt:formatNumber value="${total}" type="currency" 
                                                        currencySymbol="Rp " groupingUsed="true" 
                                                        minFractionDigits="0" maxFractionDigits="0"/>
                                    </span>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-checkout">
                                    <i class="bi bi-check-circle me-2"></i>
                                    Buat Pesanan
                                </button>
                            </div>

                            <!-- Back Link -->
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none">
                                    <i class="bi bi-arrow-left me-1"></i> Kembali ke Keranjang
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Payment option selection styling
        document.querySelectorAll('.payment-option input[type="radio"]').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.payment-option').forEach(option => {
                    option.classList.remove('selected');
                });
                if (this.checked) {
                    this.closest('.payment-option').classList.add('selected');
                }
            });
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const shippingName = document.getElementById('shippingName').value.trim();
            const shippingPhone = document.getElementById('shippingPhone').value.trim();
            const shippingAddress = document.getElementById('shippingAddress').value.trim();
            const shippingCity = document.getElementById('shippingCity').value.trim();
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');

            if (!shippingName || !shippingPhone || !shippingAddress || !shippingCity) {
                e.preventDefault();
                alert('Harap lengkapi semua informasi pengiriman yang wajib diisi!');
                return false;
            }

            if (!paymentMethod) {
                e.preventDefault();
                alert('Harap pilih metode pembayaran!');
                return false;
            }

            // Phone number validation
            const phonePattern = /^[0-9]{10,13}$/;
            if (!phonePattern.test(shippingPhone)) {
                e.preventDefault();
                alert('Nomor telepon harus berisi 10-13 digit angka!');
                return false;
            }

            return true;
        });
    </script>
</body>
</html>
