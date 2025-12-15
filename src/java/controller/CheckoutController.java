package controller;

import service.CartService;
import service.OrderService;
import model.Cart;
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
        
        // Check if user is logged in
        Long userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String action = getAction(request);
        
        switch (action) {
            case "process":
                processCheckout(request, response);
                break;
            default:
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
        
        // Validate cart before checkout
        boolean isValid = cartService.validateCartForCheckout(userId);
        
        if (!isValid) {
            request.getSession().setAttribute("error", "Keranjang kosong atau ada produk yang tidak tersedia");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        Cart cart = cartService.getCartWithItems(userId);
        BigDecimal total = cartService.getCartTotal(userId);
        
        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("/Customer/checkout.jsp").forward(request, response);
    }
    
    /**
     * Process checkout
     * POLYMORPHISM: Menggunakan PaymentMethod interface
     */
    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        
        // Get payment method from form
        String paymentType = request.getParameter("paymentMethod");
        
        if (paymentType == null || paymentType.trim().isEmpty()) {
            request.setAttribute("error", "Silakan pilih metode pembayaran");
            showCheckoutPage(request, response);
            return;
        }
        
        // Validate cart
        boolean isValid = cartService.validateCartForCheckout(userId);
        
        if (!isValid) {
            request.setAttribute("error", "Keranjang tidak valid untuk checkout");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Create payment method (POLYMORPHISM!)
        PaymentMethod paymentMethod = orderService.createPaymentMethod(paymentType);
        
        if (paymentMethod == null) {
            request.setAttribute("error", "Metode pembayaran tidak valid");
            showCheckoutPage(request, response);
            return;
        }
        
        // Process checkout
        Long orderId = orderService.checkout(userId, paymentMethod);
        
        if (orderId != null) {
            request.getSession().setAttribute("success", "Pesanan berhasil dibuat! Order ID: #" + orderId);
            request.getSession().setAttribute("orderId", orderId);
            request.getSession().setAttribute("paymentInstructions", paymentMethod.getPaymentInstructions());
            
            response.sendRedirect(request.getContextPath() + "/checkout/success?id=" + orderId);
        } else {
            request.setAttribute("error", "Gagal membuat pesanan. Silakan coba lagi.");
            showCheckoutPage(request, response);
        }
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
