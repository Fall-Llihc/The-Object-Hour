package controller;

import service.OrderService;
import model.Order;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * PaymentSuccessController - Handle payment success page
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "PaymentSuccessController", urlPatterns = {"/payment-success"})
public class PaymentSuccessController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("PaymentSuccessController.doGet - Request received");
        
        // Check if user is logged in
        HttpSession session = request.getSession(true);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("PaymentSuccessController.doGet - User not logged in, redirecting to login");
            session.setAttribute("error", "Please login to view your order confirmation");
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        System.out.println("PaymentSuccessController.doGet - User ID: " + session.getAttribute("userId"));
        
        // Get order from session
        Order order = (Order) session.getAttribute("order");
        
        System.out.println("PaymentSuccessController.doGet - Order from session: " + (order != null ? order.getId() : "null"));
        
        if (order == null) {
            // No order in session, check if orderId parameter exists
            String orderIdStr = request.getParameter("orderId");
            System.out.println("PaymentSuccessController.doGet - OrderId parameter: " + orderIdStr);
            
            if (orderIdStr != null) {
                try {
                    Long orderId = Long.parseLong(orderIdStr);
                    OrderService orderService = new OrderService();
                    order = orderService.getOrderById(orderId);
                    System.out.println("PaymentSuccessController.doGet - Order loaded from DB: " + (order != null ? order.getId() : "null"));
                } catch (NumberFormatException e) {
                    System.out.println("PaymentSuccessController.doGet - Invalid orderId format");
                }
            }
            
            if (order == null) {
                // No order found, redirect to home
                System.out.println("PaymentSuccessController.doGet - No order found, redirecting to home");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
        }
        
        // Set order as request attribute for JSP
        request.setAttribute("order", order);
        
        // Remove order from session (one-time display)
        session.removeAttribute("order");
        
        System.out.println("PaymentSuccessController.doGet - Forwarding to payment-success.jsp with order #" + order.getId());
        
        // Forward to success page
        request.getRequestDispatcher("/Customer/payment-success.jsp").forward(request, response);
    }
}
