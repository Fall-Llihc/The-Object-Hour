package service;

import dao.*;
import model.*;
import java.math.BigDecimal;
import java.util.List;

/**
 * OrderService - Service layer untuk manajemen order dan checkout
 * Menangani business logic untuk checkout, payment processing, dan order management
 * Demonstrates POLYMORPHISM dengan PaymentMethod interface
 * 
 * @author The Object Hour Team
 */
public class OrderService {
    
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private ProductDAO productDAO;
    
    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderItemDAO = new OrderItemDAO();
        this.cartDAO = new CartDAO();
        this.cartItemDAO = new CartItemDAO();
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Checkout cart menjadi order dengan informasi penerima
     * POLYMORPHISM: Menggunakan PaymentMethod interface untuk berbagai jenis pembayaran
     * 
     * @param userId User ID
     * @param paymentMethod Payment method implementation (EWallet, Bank, Cash)
     * @param shippingName Nama Penerima
     * @param shippingPhone No. Telepon Penerima
     * @param shippingAddress Alamat Penerima
     * @param shippingCity Kota/Kabupaten Penerima
     * @param shippingState Provinsi Penerima
     * @param shippingPostalCode Kode Pos Penerima
     * @param notes Catatan tambahan untuk penerima
     * @return Order ID jika berhasil, null jika gagal
     */
    public Long checkout(Long userId, PaymentMethod paymentMethod, 
                        String shippingName, String shippingPhone, String shippingAddress,
                        String shippingCity, String shippingState, String shippingPostalCode, String notes) {
        // Validasi input
        if (userId == null || paymentMethod == null) {
            System.out.println("User ID and Payment Method are required");
            return null;
        }
        
        // Validate shipping information
        if (shippingName == null || shippingName.trim().isEmpty() ||
            shippingPhone == null || shippingPhone.trim().isEmpty() ||
            shippingAddress == null || shippingAddress.trim().isEmpty()) {
            System.out.println("Shipping information is required");
            return null;
        }
        
        // Get active cart with items
        Cart cart = cartDAO.findActiveCartByUserId(userId);
        if (cart == null) {
            System.out.println("No active cart found");
            return null;
        }
        
        List<CartItem> cartItems = cartItemDAO.findAllByCartId(cart.getId());
        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("Cart is empty");
            return null;
        }
        
        // Calculate total
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            // Validate product availability
            Product product = productDAO.findById(item.getProductId());
            if (product == null || !product.isActive() || product.getStock() < item.getQuantity()) {
                System.out.println("Product unavailable or insufficient stock: " + 
                                 (product != null ? product.getName() : item.getProductId()));
                return null;
            }
            
            totalAmount = totalAmount.add(item.getSubtotal());
        }
        
        // Validate payment
        if (!paymentMethod.validatePayment(totalAmount)) {
            System.out.println("Payment validation failed");
            return null;
        }
        
        // Create order with shipping information
        Order order = new Order();
        order.setUserId(userId);
        order.setCartId(cart.getId());
        order.setPaymentMethod(paymentMethod.getPaymentMethodName());
        order.setStatus("PENDING");
        order.setTotalAmount(totalAmount);
        order.setShippingName(shippingName);
        order.setShippingPhone(shippingPhone);
        order.setShippingAddress(shippingAddress);
        order.setShippingCity(shippingCity);
        order.setShippingState(shippingState);
        order.setShippingPostalCode(shippingPostalCode);
        order.setNotes(notes);
        
        Long orderId = orderDAO.createOrder(order);
        if (orderId == null) {
            System.out.println("Failed to create order");
            return null;
        }
        
        // Create order items from cart items
        for (CartItem cartItem : cartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setProductId(cartItem.getProductId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setUnitPrice(cartItem.getUnitPrice());
            orderItem.setSubtotal(cartItem.getSubtotal());
            
            Long orderItemId = orderItemDAO.createOrderItem(orderItem);
            if (orderItemId == null) {
                System.out.println("Failed to create order item");
                // Rollback: delete order
                orderDAO.deleteOrder(orderId);
                return null;
            }
            
            // Decrease product stock
            boolean stockUpdated = productDAO.decreaseStock(cartItem.getProductId(), cartItem.getQuantity());
            if (!stockUpdated) {
                System.out.println("Failed to update product stock");
                // Rollback: delete order and items
                orderItemDAO.deleteAllByOrderId(orderId);
                orderDAO.deleteOrder(orderId);
                return null;
            }
        }
        
        // Process payment (POLYMORPHISM in action!)
        boolean paymentSuccess = paymentMethod.processPayment(orderId, totalAmount);
        
        if (paymentSuccess) {
            // Mark order as PAID
            orderDAO.markAsPaid(orderId);
            System.out.println("Order created and paid successfully: #" + orderId);
        } else {
            System.out.println("Order created but payment pending: #" + orderId);
        }
        
        // Deactivate cart
        cartDAO.deactivateCart(cart.getId());
        
        return orderId;
    }
    
    /**
     * Get order by ID with items
     * 
     * @param orderId Order ID
     * @return Order object with items
     */
    public Order getOrderById(Long orderId) {
        Order order = orderDAO.findById(orderId);
        
        if (order != null) {
            List<OrderItem> items = orderItemDAO.findAllByOrderId(orderId);
            order.setItems(items);
        }
        
        return order;
    }
    
    /**
     * Get all orders by user
     * 
     * @param userId User ID
     * @return List of orders
     */
    public List<Order> getOrdersByUser(Long userId) {
        return orderDAO.findByUserId(userId);
    }
    
    /**
     * Get all orders (admin)
     * 
     * @return List of all orders
     */
    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }
    
    /**
     * Get orders by status
     * 
     * @param status Order status (PENDING, PAID, CANCELLED)
     * @return List of orders
     */
    public List<Order> getOrdersByStatus(String status) {
        return orderDAO.findByStatus(status);
    }
    
    /**
     * Update order status
     * 
     * @param orderId Order ID
     * @param newStatus New status
     * @return true jika berhasil
     */
    public boolean updateOrderStatus(Long orderId, String newStatus) {
        // Validasi status
        if (!isValidStatus(newStatus)) {
            System.out.println("Invalid order status: " + newStatus);
            return false;
        }
        
        return orderDAO.updateStatus(orderId, newStatus);
    }
    
    /**
     * Cancel order
     * Only PENDING orders can be cancelled
     * 
     * @param orderId Order ID
     * @return true jika berhasil
     */
    public boolean cancelOrder(Long orderId) {
        Order order = orderDAO.findById(orderId);
        
        if (order == null) {
            System.out.println("Order not found: " + orderId);
            return false;
        }
        
        if (!order.isPending()) {
            System.out.println("Only PENDING orders can be cancelled");
            return false;
        }
        
        // Restore product stock
        List<OrderItem> items = orderItemDAO.findAllByOrderId(orderId);
        for (OrderItem item : items) {
            Product product = productDAO.findById(item.getProductId());
            if (product != null) {
                int newStock = product.getStock() + item.getQuantity();
                productDAO.updateStock(product.getId(), newStock);
            }
        }
        
        return orderDAO.cancelOrder(orderId);
    }
    
    /**
     * Create PaymentMethod instance based on type
     * Factory pattern untuk membuat PaymentMethod (POLYMORPHISM)
     * 
     * @param paymentType Payment type (EWALLET, BANK, CASH)
     * @return PaymentMethod implementation
     */
    public PaymentMethod createPaymentMethod(String paymentType) {
        if (paymentType == null) {
            return null;
        }
        
        switch (paymentType.toUpperCase()) {
            case "EWALLET":
                return new EWalletPayment("GoPay", "081234567890");
                
            case "BANK":
            case "BANK_TRANSFER":
                return new BankTransferPayment("BCA", "1234567890", "The Object Hour");
                
            case "CASH":
            case "COD":
                return new CashPayment("Default Address", "Customer", "081234567890");
                
            default:
                System.out.println("Unknown payment type: " + paymentType);
                return null;
        }
    }
    
    /**
     * Validate order status
     * 
     * @param status Status to validate
     * @return true if valid
     */
    private boolean isValidStatus(String status) {
        return status != null && 
               (status.equalsIgnoreCase("PENDING") || 
                status.equalsIgnoreCase("PAID") || 
                status.equalsIgnoreCase("CANCELLED"));
    }
}
