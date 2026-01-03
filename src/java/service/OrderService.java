package service;

import dao.*;
import model.*;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.util.stream.Collectors;

/**
 * OrderService - Service layer untuk manajemen order dan checkout
 * Menangani business logic untuk checkout, payment processing, dan order management
 */
public class OrderService {

    private final OrderDAO orderDAO;
    private final OrderItemDAO orderItemDAO;
    private final CartDAO cartDAO;
    private final CartItemDAO cartItemDAO;
    private final ProductDAO productDAO;

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderItemDAO = new OrderItemDAO();
        this.cartDAO = new CartDAO();
        this.cartItemDAO = new CartItemDAO();
        this.productDAO = new ProductDAO();
    }

    /**
     * Checkout cart menjadi order dengan informasi penerima
     */
    public Long checkout(Long userId, PaymentMethod paymentMethod,
                         String shippingName, String shippingPhone, String shippingAddress,
                         String shippingCity, String shippingState, String shippingPostalCode, String notes) {

        if (userId == null || paymentMethod == null) {
            System.out.println("User ID and Payment Method are required");
            return null;
        }

        if (shippingName == null || shippingName.trim().isEmpty() ||
            shippingPhone == null || shippingPhone.trim().isEmpty() ||
            shippingAddress == null || shippingAddress.trim().isEmpty()) {
            System.out.println("Shipping information is required");
            return null;
        }

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

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            Product product = productDAO.findById(item.getProductId());
            if (product == null || !product.isActive() || product.getStock() < item.getQuantity()) {
                System.out.println("Product unavailable or insufficient stock: " +
                        (product != null ? product.getName() : item.getProductId()));
                return null;
            }
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        if (!paymentMethod.validatePayment(totalAmount)) {
            System.out.println("Payment validation failed");
            return null;
        }

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
                orderDAO.deleteOrder(orderId);
                return null;
            }

            boolean stockUpdated = productDAO.decreaseStock(cartItem.getProductId(), cartItem.getQuantity());
            if (!stockUpdated) {
                System.out.println("Failed to update product stock");
                orderItemDAO.deleteAllByOrderId(orderId);
                orderDAO.deleteOrder(orderId);
                return null;
            }
        }

        boolean paymentSuccess = paymentMethod.processPayment(orderId, totalAmount);

        if (paymentSuccess) {
            orderDAO.markAsPaid(orderId);
            System.out.println("Order created and paid successfully: #" + orderId);
        } else {
            System.out.println("Order created but payment pending: #" + orderId);
        }

        cartDAO.deactivateCart(cart.getId());
        return orderId;
    }

    public Order getOrderById(Long orderId) {
        Order order = orderDAO.findById(orderId);
        if (order != null) {
            List<OrderItem> items = orderItemDAO.findAllByOrderId(orderId);
            order.setItems(items);
        }
        return order;
    }

    public List<Order> getOrdersByUser(Long userId) {
        return orderDAO.findByUserId(userId);
    }

    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    public List<Order> getOrdersByStatus(String status) {
        return orderDAO.findByStatus(status);
    }

    public List<Order> getOrdersByDateRange(Timestamp startDate, Timestamp endDate) {
        return orderDAO.findByDateRange(startDate, endDate);
    }

    public List<Order> getOrdersByStatusAndDateRange(String status, Timestamp startDate, Timestamp endDate) {
        List<Order> ranged = orderDAO.findByDateRange(startDate, endDate);
        return ranged.stream()
                .filter(o -> o.getStatus() != null && o.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    public boolean updateOrderStatus(Long orderId, String newStatus) {
        if (!isValidStatus(newStatus)) {
            System.out.println("Invalid order status: " + newStatus);
            return false;
        }
        return orderDAO.updateStatus(orderId, newStatus);
    }

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

    public PaymentMethod createPaymentMethod(String paymentType) {
        if (paymentType == null) return null;

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

    private boolean isValidStatus(String status) {
        return status != null &&
                (status.equalsIgnoreCase("PENDING") ||
                 status.equalsIgnoreCase("PAID") ||
                 status.equalsIgnoreCase("CANCELLED"));
    }
}
