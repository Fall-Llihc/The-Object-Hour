package dao;

import config.JDBC;
import model.OrderItem;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderItemDAO - Data Access Object untuk tabel order_items
 * Menangani semua operasi CRUD untuk OrderItem
 * 
 * @author The Object Hour Team
 */
public class OrderItemDAO {
    
    private ProductDAO productDAO = new ProductDAO();
    
    /**
     * Create new order item
     * 
     * @param orderItem OrderItem object
     * @return Generated order_item ID, atau null jika gagal
     */
    public Long createOrderItem(OrderItem orderItem) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) " +
                     "VALUES (?, ?, ?, ?, ?) RETURNING id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, orderItem.getOrderId());
            stmt.setLong(2, orderItem.getProductId());
            stmt.setInt(3, orderItem.getQuantity());
            stmt.setBigDecimal(4, orderItem.getUnitPrice());
            stmt.setBigDecimal(5, orderItem.getSubtotal());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating order item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find order item by ID
     * 
     * @param id OrderItem ID
     * @return OrderItem object atau null jika tidak ditemukan
     */
    public OrderItem findById(Long id) {
        String sql = "SELECT * FROM order_items WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOrderItem(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding order item by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find all items in an order
     * 
     * @param orderId Order ID
     * @return List of order items with product details
     */
    public List<OrderItem> findAllByOrderId(Long orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ? ORDER BY id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = mapResultSetToOrderItem(rs);
                // Load product details
                Product product = productDAO.findById(item.getProductId());
                item.setProduct(product);
                items.add(item);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding order items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    /**
     * Update order item
     * 
     * @param orderItem OrderItem object with updated data
     * @return true jika berhasil
     */
    public boolean updateOrderItem(OrderItem orderItem) {
        String sql = "UPDATE order_items SET quantity = ?, unit_price = ?, subtotal = ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderItem.getQuantity());
            stmt.setBigDecimal(2, orderItem.getUnitPrice());
            stmt.setBigDecimal(3, orderItem.getSubtotal());
            stmt.setLong(4, orderItem.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating order item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete order item by ID
     * 
     * @param id OrderItem ID
     * @return true jika berhasil
     */
    public boolean deleteOrderItem(Long id) {
        String sql = "DELETE FROM order_items WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting order item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete all items in an order
     * 
     * @param orderId Order ID
     * @return true jika berhasil
     */
    public boolean deleteAllByOrderId(Long orderId) {
        String sql = "DELETE FROM order_items WHERE order_id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, orderId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting order items: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method: Map ResultSet to OrderItem object
     */
    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getLong("id"));
        item.setOrderId(rs.getLong("order_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        
        return item;
    }
}
