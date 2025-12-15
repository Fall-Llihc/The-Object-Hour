package dao;

import config.JDBC;
import model.CartItem;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CartItemDAO - Data Access Object untuk tabel cart_items
 * Menangani semua operasi CRUD untuk CartItem
 * 
 * @author The Object Hour Team
 */
public class CartItemDAO {
    
    private ProductDAO productDAO = new ProductDAO();
    
    /**
     * Add item to cart
     * 
     * @param cartItem CartItem object
     * @return Generated cart_item ID, atau null jika gagal
     */
    public Long addItem(CartItem cartItem) {
        String sql = "INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, subtotal) " +
                     "VALUES (?, ?, ?, ?, ?) RETURNING id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartItem.getCartId());
            stmt.setLong(2, cartItem.getProductId());
            stmt.setInt(3, cartItem.getQuantity());
            stmt.setBigDecimal(4, cartItem.getUnitPrice());
            stmt.setBigDecimal(5, cartItem.getSubtotal());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error adding item to cart: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find cart item by ID
     * 
     * @param id CartItem ID
     * @return CartItem object atau null jika tidak ditemukan
     */
    public CartItem findById(Long id) {
        String sql = "SELECT * FROM cart_items WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCartItem(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding cart item by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find all items in a cart
     * 
     * @param cartId Cart ID
     * @return List of cart items with product details
     */
    public List<CartItem> findAllByCartId(Long cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE cart_id = ? ORDER BY id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CartItem item = mapResultSetToCartItem(rs);
                // Load product details
                Product product = productDAO.findById(item.getProductId());
                item.setProduct(product);
                items.add(item);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding cart items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    /**
     * Find cart item by cart ID and product ID
     * 
     * @param cartId Cart ID
     * @param productId Product ID
     * @return CartItem object atau null jika tidak ditemukan
     */
    public CartItem findByCartAndProduct(Long cartId, Long productId) {
        String sql = "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartId);
            stmt.setLong(2, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCartItem(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding cart item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Update cart item
     * 
     * @param cartItem CartItem object with updated data
     * @return true jika berhasil
     */
    public boolean updateItem(CartItem cartItem) {
        String sql = "UPDATE cart_items SET quantity = ?, unit_price = ?, subtotal = ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cartItem.getQuantity());
            stmt.setBigDecimal(2, cartItem.getUnitPrice());
            stmt.setBigDecimal(3, cartItem.getSubtotal());
            stmt.setLong(4, cartItem.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating cart item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update quantity of cart item
     * 
     * @param cartItemId Cart Item ID
     * @param newQuantity New quantity
     * @return true jika berhasil
     */
    public boolean updateQuantity(Long cartItemId, int newQuantity) {
        String sql = "UPDATE cart_items SET quantity = ?, subtotal = unit_price * ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, newQuantity);
            stmt.setLong(3, cartItemId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete cart item by ID
     * 
     * @param id CartItem ID
     * @return true jika berhasil
     */
    public boolean deleteItem(Long id) {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting cart item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete all items in a cart
     * 
     * @param cartId Cart ID
     * @return true jika berhasil
     */
    public boolean deleteAllByCartId(Long cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0; // Return true even if no items deleted
            
        } catch (SQLException e) {
            System.err.println("Error deleting cart items: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get total items count in cart
     * 
     * @param cartId Cart ID
     * @return Total items count
     */
    public int getItemsCount(Long cartId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total FROM cart_items WHERE cart_id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting items count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Helper method: Map ResultSet to CartItem object
     */
    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setId(rs.getLong("id"));
        item.setCartId(rs.getLong("cart_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        
        return item;
    }
}
