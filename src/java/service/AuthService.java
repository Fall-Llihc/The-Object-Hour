package service;

import dao.UserDAO;
import model.User;
import model.Customer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

/**
 * AuthService - Service layer untuk autentikasi dan registrasi
 * Menangani business logic untuk login, register, dan password hashing
 * 
 * @author The Object Hour Team
 */
public class AuthService {
    
    private UserDAO userDAO;
    
    public AuthService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * Login user
     * 
     * @param username Username
     * @param password Plain text password
     * @return User object jika berhasil, null jika gagal
     */
    public User login(String username, String password) {
        // Validasi input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            System.out.println("Username or password is empty");
            return null;
        }
        
        // Hash password
        String passwordHash = hashPassword(password);
        
        // Cari user di database
        User user = userDAO.login(username, passwordHash);
        
        if (user != null) {
            System.out.println("Login successful for user: " + username);
        } else {
            System.out.println("Login failed for user: " + username);
        }
        
        return user;
    }
    
    /**
     * Register customer baru
     * 
     * @param username Username
     * @param password Plain text password
     * @param name Full name
     * @return User ID jika berhasil, null jika gagal
     */
    public Long registerCustomer(String username, String password, String name) {
        // Validasi input
        if (username == null || username.trim().isEmpty()) {
            System.out.println("Username is required");
            return null;
        }
        
        if (password == null || password.length() < 6) {
            System.out.println("Password must be at least 6 characters");
            return null;
        }
        
        if (name == null || name.trim().isEmpty()) {
            System.out.println("Name is required");
            return null;
        }
        
        // Cek apakah username sudah ada
        if (userDAO.isUsernameExists(username)) {
            System.out.println("Username already exists: " + username);
            return null;
        }
        
        // Hash password
        String passwordHash = hashPassword(password);
        
        // Buat user baru
        Customer customer = new Customer();
        customer.setUsername(username);
        customer.setPasswordHash(passwordHash);
        customer.setName(name);
        customer.setRole("CUSTOMER");
        
        // Simpan ke database
        Long userId = userDAO.createUser(customer);
        
        if (userId != null) {
            System.out.println("Registration successful for user: " + username);
        } else {
            System.out.println("Registration failed for user: " + username);
        }
        
        return userId;
    }
    
    /**
     * Change password
     * 
     * @param userId User ID
     * @param oldPassword Old password (plain text)
     * @param newPassword New password (plain text)
     * @return true jika berhasil
     */
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        // Validasi input
        if (newPassword == null || newPassword.length() < 6) {
            System.out.println("New password must be at least 6 characters");
            return false;
        }
        
        // Ambil user dari database
        User user = userDAO.findById(userId);
        if (user == null) {
            System.out.println("User not found");
            return false;
        }
        
        // Verify old password
        String oldPasswordHash = hashPassword(oldPassword);
        if (!oldPasswordHash.equals(user.getPasswordHash())) {
            System.out.println("Old password is incorrect");
            return false;
        }
        
        // Hash new password
        String newPasswordHash = hashPassword(newPassword);
        user.setPasswordHash(newPasswordHash);
        
        // Update database
        boolean success = userDAO.updateUser(user);
        
        if (success) {
            System.out.println("Password changed successfully for user: " + user.getUsername());
        }
        
        return success;
    }
    
    /**
     * Hash password menggunakan SHA-256
     * 
     * @param password Plain text password
     * @return Hashed password (hex string)
     */
    public String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            
            // Convert byte array to hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            e.printStackTrace();
            // Fallback: return plain password (NOT SECURE - for development only)
            return password;
        }
    }
    
    /**
     * Validate username format
     * 
     * @param username Username to validate
     * @return true if valid
     */
    public boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        
        // Username harus 3-20 karakter, hanya huruf, angka, underscore
        return username.matches("^[a-zA-Z0-9_]{3,20}$");
    }
    
    /**
     * Validate password strength
     * 
     * @param password Password to validate
     * @return true if strong enough
     */
    public boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        
        // Password minimal 6 karakter
        // Bisa ditambahkan requirement lain (uppercase, number, special char)
        return true;
    }
    
    /**
     * Check if user is admin
     * 
     * @param user User object
     * @return true if admin
     */
    public boolean isAdmin(User user) {
        return user != null && user.isAdmin();
    }
    
    /**
     * Check if user is customer
     * 
     * @param user User object
     * @return true if customer
     */
    public boolean isCustomer(User user) {
        return user != null && user.isCustomer();
    }
}
