package dao;

import config.JDBC;
import model.Cart;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CartDAO - Data Access Object untuk tabel carts
 * Menangani semua operasi CRUD untuk Cart
 * 
 * @author The Object Hour Team
 */
public class CartDAO {
    
    /**
     * Create new cart
     * 
     * @param cart Cart object
     * @return Generated cart ID, atau null jika gagal
     */
    public Long createCart(Cart cart) {
        String sql = "INSERT INTO carts (user_id, is_active, created_at) " +
                     "VALUES (?, ?, NOW()) RETURNING id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cart.getUserId());
            stmt.setBoolean(2, cart.isActive());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating cart: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find cart by ID
     * 
     * @param id Cart ID
     * @return Cart object atau null jika tidak ditemukan
     */
    public Cart findById(Long id) {
        String sql = "SELECT * FROM carts WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding cart by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find active cart by user ID
     * Jika tidak ada, buat cart baru
     * 
     * @param userId User ID
     * @return Cart object
     */
    public Cart findOrCreateActiveCartByUserId(Long userId) {
        Cart cart = findActiveCartByUserId(userId);
        
        if (cart == null) {
            // Buat cart baru
            Cart newCart = new Cart();
            newCart.setUserId(userId);
            newCart.setActive(true);
            
            Long cartId = createCart(newCart);
            if (cartId != null) {
                cart = findById(cartId);
            }
        }
        
        return cart;
    }
    
    /**
     * Find active cart by user ID
     * 
     * @param userId User ID
     * @return Cart object atau null jika tidak ditemukan
     */
    public Cart findActiveCartByUserId(Long userId) {
        String sql = "SELECT * FROM carts WHERE user_id = ? AND is_active = true " +
                     "ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding active cart: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find all carts by user ID
     * 
     * @param userId User ID
     * @return List of carts
     */
    public List<Cart> findAllByUserId(Long userId) {
        List<Cart> carts = new ArrayList<>();
        String sql = "SELECT * FROM carts WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                carts.add(mapResultSetToCart(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding carts by user: " + e.getMessage());
            e.printStackTrace();
        }
        return carts;
    }
    
    /**
     * Update cart
     * 
     * @param cart Cart object with updated data
     * @return true jika berhasil
     */
    public boolean updateCart(Cart cart) {
        String sql = "UPDATE carts SET user_id = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cart.getUserId());
            stmt.setBoolean(2, cart.isActive());
            stmt.setLong(3, cart.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating cart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Deactivate cart (set is_active = false)
     * Digunakan setelah checkout
     * 
     * @param cartId Cart ID
     * @return true jika berhasil
     */
    public boolean deactivateCart(Long cartId) {
        String sql = "UPDATE carts SET is_active = false WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deactivating cart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete cart by ID
     * 
     * @param id Cart ID
     * @return true jika berhasil
     */
    public boolean deleteCart(Long id) {
        String sql = "DELETE FROM carts WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting cart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method: Map ResultSet to Cart object
     */
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getLong("id"));
        cart.setUserId(rs.getLong("user_id"));
        cart.setActive(rs.getBoolean("is_active"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            cart.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return cart;
    }
}
