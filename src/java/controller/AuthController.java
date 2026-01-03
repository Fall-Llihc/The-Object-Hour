package controller;

import service.AuthService;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * AuthController - Controller untuk autentikasi (login, logout, register)
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "AuthController", urlPatterns = {"/auth/*"})
public class AuthController extends HttpServlet {
    
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getAction(request);
        
        switch (action) {
            case "login":
                showLoginPage(request, response);
                break;
            case "register":
                showRegisterPage(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getAction(request);
        
        switch (action) {
            case "login":
                processLogin(request, response);
                break;
            case "register":
                processRegister(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }
    
    /**
     * Show login page
     */
    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Auth/login.jsp").forward(request, response);
    }
    
    /**
     * Show register page
     */
    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
    }
    
    /**
     * Process login
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username dan password harus diisi");
            request.getRequestDispatcher("/Auth/login.jsp").forward(request, response);
            return;
        }
        
        // Login
        User user = authService.login(username, password);
        
        if (user != null) {
            // Login success - create session with proper configuration
            HttpSession session = request.getSession(true);
            
            // Invalidate any existing session first to prevent session fixation
            if (session != null && session.getAttribute("userId") == null) {
                // Session is new or empty, just use it
            } else if (session != null) {
                // Get redirect URL before invalidating
                String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
                session.invalidate();
                session = request.getSession(true);
                if (redirectUrl != null) {
                    session.setAttribute("redirectAfterLogin", redirectUrl);
                }
            }
            
            // Set session attributes
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            // Set session timeout to 60 minutes (in seconds)
            session.setMaxInactiveInterval(60 * 60);
            
            // Check for redirect after login
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            session.removeAttribute("redirectAfterLogin");
            
            // Redirect based on role or saved URL
            if (redirectUrl != null && !redirectUrl.contains("/auth/")) {
                response.sendRedirect(redirectUrl);
            } else if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } else {
            // Login failed
            request.setAttribute("error", "Username atau password salah");
            request.getRequestDispatcher("/Auth/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Process registration
     */
    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        
        // Validate input
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username harus diisi");
            request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!authService.isValidUsername(username)) {
            request.setAttribute("error", "Username harus 3-20 karakter (huruf, angka, underscore)");
            request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password minimal 6 karakter");
            request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password dan konfirmasi password tidak cocok");
            request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
            return;
        }
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Nama lengkap harus diisi");
            request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
            return;
        }
        
        // Register
        Long userId = authService.registerCustomer(username, password, name);
        
        if (userId != null) {
            // Registration success
            request.setAttribute("success", "Registrasi berhasil! Silakan login.");
            request.getRequestDispatcher("/Auth/login.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("error", "Username sudah digunakan atau terjadi kesalahan");
            request.getRequestDispatcher("/Auth/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Logout
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/products");
    }
    
    /**
     * Get action from request path
     */
    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            return "login";
        }
        return pathInfo.substring(1);
    }
}
