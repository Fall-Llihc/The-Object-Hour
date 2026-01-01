package controller;

import service.CartService;
import service.OrderService;
import model.Cart;
import model.Order;
import model.PaymentMethod;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * CheckoutController - Controller untuk proses checkout
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/checkout/*"})
public class CheckoutController extends HttpServlet {
    
    private CartService cartService;
    private OrderService orderService;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        orderService = new OrderService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        Long userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String action = getAction(request);
        
        switch (action) {
            case "":
            case "payment":
                showCheckoutPage(request, response);
                break;
            default:
                showCheckoutPage(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("CheckoutController.doPost - Request received");
        System.out.println("CheckoutController.doPost - URI: " + request.getRequestURI());
        System.out.println("CheckoutController.doPost - PathInfo: " + request.getPathInfo());
        
        // Check if user is logged in
        Long userId = getUserId(request);
        if (userId == null) {
            System.out.println("CheckoutController.doPost - User not logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        System.out.println("CheckoutController.doPost - User ID: " + userId);
        
        String action = getAction(request);
        System.out.println("CheckoutController.doPost - Action: " + action);
        
        // Default POST ke checkout adalah process checkout
        if (action == null || action.isEmpty()) {
            System.out.println("CheckoutController.doPost - Processing checkout (default)");
            processCheckout(request, response);
            return;
        }
        
        switch (action) {
            case "process":
                System.out.println("CheckoutController.doPost - Processing checkout (explicit)");
                processCheckout(request, response);
                break;
            default:
                System.out.println("CheckoutController.doPost - Unknown action, showing checkout page");
                showCheckoutPage(request, response);
                break;
        }
    }
    
    /**
     * Show checkout page
     */
    private void showCheckoutPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        
        // Debug logging
        System.out.println("CheckoutController.showCheckoutPage - User ID: " + userId);
        
        // Validate cart before checkout
        boolean isValid = cartService.validateCartForCheckout(userId);
        
        System.out.println("CheckoutController.showCheckoutPage - Cart valid: " + isValid);
        
        if (!isValid) {
            System.out.println("CheckoutController.showCheckoutPage - Redirecting to cart (invalid)");
            request.getSession().setAttribute("error", "Keranjang kosong atau ada produk yang tidak tersedia. Silakan tambahkan produk ke keranjang terlebih dahulu.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        Cart cart = cartService.getCartWithItems(userId);
        BigDecimal total = cartService.getCartTotal(userId);
        
        System.out.println("CheckoutController.showCheckoutPage - Cart items: " + (cart != null && cart.getItems() != null ? cart.getItems().size() : 0));
        System.out.println("CheckoutController.showCheckoutPage - Total: " + total);
        System.out.println("CheckoutController.showCheckoutPage - Forwarding to /Customer/checkout.jsp");
        
        request.setAttribute("cartItems", cart.getItems());
        request.setAttribute("totalPrice", total);
        
        request.getRequestDispatcher("/Customer/checkout.jsp").forward(request, response);
    }
    
    /**
     * Process checkout
     * POLYMORPHISM: Menggunakan PaymentMethod interface
     */
    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("====== PROCESS CHECKOUT STARTED ======");
        
        Long userId = getUserId(request);
        System.out.println("User ID: " + userId);
        
        // Get form data
        String paymentType = request.getParameter("paymentMethod");
        String shippingName = request.getParameter("shippingName");
        String shippingPhone = request.getParameter("shippingPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String shippingCity = request.getParameter("shippingCity");
        String shippingState = request.getParameter("shippingState");
        String shippingPostalCode = request.getParameter("shippingPostalCode");
        String notes = request.getParameter("notes");
        
        System.out.println("Payment Type: " + paymentType);
        System.out.println("Shipping Name: " + shippingName);
        System.out.println("Shipping Phone: " + shippingPhone);
        System.out.println("Shipping Address: " + shippingAddress);
        System.out.println("Shipping City: " + shippingCity);
        System.out.println("Shipping State: " + shippingState);
        System.out.println("Shipping Postal Code: " + shippingPostalCode);
        
        // Validate payment method
        if (paymentType == null || paymentType.trim().isEmpty()) {
            System.out.println("VALIDATION FAILED: Payment method empty");
            request.setAttribute("error", "Silakan pilih metode pembayaran");
            showCheckoutPage(request, response);
            return;
        }
        System.out.println("Validation OK: Payment method");
        
        // Validate shipping information
        if (shippingName == null || shippingName.trim().isEmpty() ||
            shippingPhone == null || shippingPhone.trim().isEmpty() ||
            shippingAddress == null || shippingAddress.trim().isEmpty() ||
            shippingCity == null || shippingCity.trim().isEmpty() ||
            shippingState == null || shippingState.trim().isEmpty()) {
            System.out.println("VALIDATION FAILED: Shipping information incomplete");
            request.setAttribute("error", "Harap lengkapi informasi pengiriman");
            showCheckoutPage(request, response);
            return;
        }
        System.out.println("Validation OK: Shipping information");
        
        // Validate cart
        System.out.println("Validating cart...");
        boolean isValid = cartService.validateCartForCheckout(userId);
        System.out.println("Cart validation result: " + isValid);
        
        if (!isValid) {
            System.out.println("VALIDATION FAILED: Cart is not valid");
            request.setAttribute("error", "Keranjang tidak valid untuk checkout");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        System.out.println("Validation OK: Cart is valid");
        
        // Create payment method (POLYMORPHISM!)
        System.out.println("Creating payment method: " + paymentType);
        PaymentMethod paymentMethod = orderService.createPaymentMethod(paymentType);
        
        if (paymentMethod == null) {
            System.out.println("ERROR: Failed to create payment method");
            request.setAttribute("error", "Metode pembayaran tidak valid");
            showCheckoutPage(request, response);
            return;
        }
        System.out.println("Payment method created: " + paymentMethod.getPaymentMethodName());
        
        // Process checkout with shipping information
        System.out.println("Calling orderService.checkout()...");
        Long orderId = orderService.checkout(userId, paymentMethod, 
                                            shippingName, shippingPhone, shippingAddress,
                                            shippingCity, shippingState, shippingPostalCode, notes);
        System.out.println("Order ID returned: " + orderId);
        
        if (orderId != null) {
            System.out.println("SUCCESS: Order created with ID: " + orderId);
            
            // Get order detail untuk ditampilkan di success page
            Order order = orderService.getOrderById(orderId);
            request.getSession().setAttribute("order", order);
            
            System.out.println("Redirecting to payment-success page");
            // Redirect to payment success page
            response.sendRedirect(request.getContextPath() + "/payment-success");
        } else {
            System.out.println("ERROR: Failed to create order");
            request.setAttribute("error", "Gagal membuat pesanan. Silakan coba lagi.");
            showCheckoutPage(request, response);
        }
        
        System.out.println("====== PROCESS CHECKOUT ENDED ======");
    }
    
    /**
     * Get user ID from session
     */
    private Long getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        return (Long) session.getAttribute("userId");
    }
    
    /**
     * Get action from request path
     */
    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            return "";
        }
        return pathInfo.substring(1);
    }
}
