package service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import dao.CartDAO;
import dao.CartItemDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import dao.ProductDAO;
import model.BankTransferPayment;
import model.Cart;
import model.CartItem;
import model.CashPayment;
import model.EWalletPayment;
import model.Order;
import model.OrderItem;
import model.PaymentMethod;
import model.Product;

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
     * Supports partial checkout - hanya checkout item yang dipilih
     */
    public Long checkout(Long userId, PaymentMethod paymentMethod,
                         String shippingName, String shippingPhone, String shippingAddress,
                         String shippingCity, String shippingState, String shippingPostalCode, 
                         String notes) {
        // Call overloaded method with null selectedItemIds (checkout all items)
        return checkout(userId, paymentMethod, shippingName, shippingPhone, shippingAddress,
                       shippingCity, shippingState, shippingPostalCode, notes, null);
    }

    /**
     * Checkout cart menjadi order dengan informasi penerima
     * Supports partial checkout - hanya checkout item yang dipilih
     * 
     * @param selectedItemIds Comma-separated cart item IDs to checkout (null = all items)
     */
    public Long checkout(Long userId, PaymentMethod paymentMethod,
                         String shippingName, String shippingPhone, String shippingAddress,
                         String shippingCity, String shippingState, String shippingPostalCode, 
                         String notes, String selectedItemIds) {

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

        List<CartItem> allCartItems = cartItemDAO.findAllByCartId(cart.getId());
        if (allCartItems == null || allCartItems.isEmpty()) {
            System.out.println("Cart is empty");
            return null;
        }

        // Determine which items to checkout
        List<CartItem> itemsToCheckout;
        List<CartItem> itemsToKeep = new ArrayList<>();
        
        if (selectedItemIds != null && !selectedItemIds.trim().isEmpty()) {
            // Parse selected item IDs
            Set<Long> selectedIds = parseSelectedItemIds(selectedItemIds);
            
            itemsToCheckout = new ArrayList<>();
            for (CartItem item : allCartItems) {
                if (selectedIds.contains(item.getId())) {
                    itemsToCheckout.add(item);
                } else {
                    itemsToKeep.add(item);
                }
            }
            
            if (itemsToCheckout.isEmpty()) {
                System.out.println("No valid items selected for checkout");
                return null;
            }
            
            System.out.println("Partial checkout: " + itemsToCheckout.size() + " items selected, " + 
                             itemsToKeep.size() + " items will remain in cart");
        } else {
            // Checkout all items
            itemsToCheckout = allCartItems;
            System.out.println("Full checkout: " + itemsToCheckout.size() + " items");
        }

        // Validate and calculate total for selected items
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : itemsToCheckout) {
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

        // Create order items only for selected items
        for (CartItem cartItem : itemsToCheckout) {
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

        // Handle cart after checkout
        if (itemsToKeep.isEmpty()) {
            // All items checked out - deactivate the cart
            cartDAO.deactivateCart(cart.getId());
            System.out.println("All items checked out, cart deactivated");
        } else {
            // Partial checkout - remove only checked out items, keep the rest
            for (CartItem checkedOutItem : itemsToCheckout) {
                cartItemDAO.deleteItem(checkedOutItem.getId());
            }
            System.out.println("Partial checkout complete, " + itemsToKeep.size() + " items remain in cart");
        }
        
        return orderId;
    }
    
    /**
     * Parse comma-separated item IDs string to Set
     */
    private Set<Long> parseSelectedItemIds(String selectedItemIds) {
        Set<Long> ids = new HashSet<>();
        if (selectedItemIds == null || selectedItemIds.trim().isEmpty()) {
            return ids;
        }
        
        String[] parts = selectedItemIds.split(",");
        for (String part : parts) {
            try {
                ids.add(Long.parseLong(part.trim()));
            } catch (NumberFormatException e) {
                System.err.println("Invalid cart item ID: " + part);
            }
        }
        return ids;
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
