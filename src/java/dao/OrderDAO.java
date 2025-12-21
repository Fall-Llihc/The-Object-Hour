package dao;

import config.JDBC;
import model.Order;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderDAO - Data Access Object untuk tabel orders
 * Menangani semua operasi CRUD untuk Order
 * 
 * @author The Object Hour Team
 */
public class OrderDAO {
    
    private UserDAO userDAO = new UserDAO();
    
    /**
     * Create new order
     * 
     * @param order Order object
     * @return Generated order ID, atau null jika gagal
     */
    public Long createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, cart_id, payment_method, status, total_amount, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, NOW()) RETURNING id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, order.getUserId());
            
            if (order.getCartId() != null) {
                stmt.setLong(2, order.getCartId());
            } else {
                stmt.setNull(2, Types.BIGINT);
            }
            
            stmt.setString(3, order.getPaymentMethod());
            stmt.setString(4, order.getStatus());
            stmt.setBigDecimal(5, order.getTotalAmount());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating order: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find order by ID
     * 
     * @param id Order ID
     * @return Order object atau null jika tidak ditemukan
     */
    public Order findById(Long id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Load user details
                User user = userDAO.findById(order.getUserId());
                order.setUser(user);
                return order;
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding order by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all orders
     * 
     * @return List of orders
     */
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Load user details
                User user = userDAO.findById(order.getUserId());
                order.setUser(user);
                orders.add(order);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Find orders by user ID
     * 
     * @param userId User ID
     * @return List of orders
     */
    public List<Order> findByUserId(Long userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding orders by user: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Find orders by status
     * 
     * @param status Order status (PENDING, PAID, CANCELLED)
     * @return List of orders
     */
    public List<Order> findByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Load user details
                User user = userDAO.findById(order.getUserId());
                order.setUser(user);
                orders.add(order);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding orders by status: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Find paid orders (untuk laporan)
     * 
     * @return List of paid orders
     */
    public List<Order> findPaidOrders() {
        return findByStatus("PAID");
    }
    
    /**
     * Find orders by date range
     * 
     * @param startDate Start date
     * @param endDate End date
     * @return List of orders
     */
    public List<Order> findByDateRange(Timestamp startDate, Timestamp endDate) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Load user details
                User user = userDAO.findById(order.getUserId());
                order.setUser(user);
                orders.add(order);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding orders by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Update order
     * 
     * @param order Order object with updated data
     * @return true jika berhasil
     */
    public boolean updateOrder(Order order) {
        String sql = "UPDATE orders SET user_id = ?, cart_id = ?, payment_method = ?, " +
                     "status = ?, total_amount = ?, paid_at = ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, order.getUserId());
            
            if (order.getCartId() != null) {
                stmt.setLong(2, order.getCartId());
            } else {
                stmt.setNull(2, Types.BIGINT);
            }
            
            stmt.setString(3, order.getPaymentMethod());
            stmt.setString(4, order.getStatus());
            stmt.setBigDecimal(5, order.getTotalAmount());
            
            if (order.getPaidAt() != null) {
                stmt.setTimestamp(6, Timestamp.valueOf(order.getPaidAt()));
            } else {
                stmt.setNull(6, Types.TIMESTAMP);
            }
            
            stmt.setLong(7, order.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating order: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update order status
     * 
     * @param orderId Order ID
     * @param newStatus New status
     * @return true jika berhasil
     */
    public boolean updateStatus(Long orderId, String newStatus) {
        String sql;
        
        if ("PAID".equalsIgnoreCase(newStatus)) {
            sql = "UPDATE orders SET status = ?, paid_at = NOW() WHERE id = ?";
        } else {
            sql = "UPDATE orders SET status = ? WHERE id = ?";
        }
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus);
            stmt.setLong(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Mark order as paid
     * 
     * @param orderId Order ID
     * @return true jika berhasil
     */
    public boolean markAsPaid(Long orderId) {
        return updateStatus(orderId, "PAID");
    }
    
    /**
     * Cancel order
     * 
     * @param orderId Order ID
     * @return true jika berhasil
     */
    public boolean cancelOrder(Long orderId) {
        return updateStatus(orderId, "CANCELLED");
    }
    
    /**
     * Delete order by ID
     * 
     * @param id Order ID
     * @return true jika berhasil
     */
    public boolean deleteOrder(Long id) {
        String sql = "DELETE FROM orders WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method: Map ResultSet to Order object
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setUserId(rs.getLong("user_id"));
        
        long cartId = rs.getLong("cart_id");
        if (!rs.wasNull()) {
            order.setCartId(cartId);
        }
        
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setStatus(rs.getString("status"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp paidAt = rs.getTimestamp("paid_at");
        if (paidAt != null) {
            order.setPaidAt(paidAt.toLocalDateTime());
        }
        
        return order;
    }
}
