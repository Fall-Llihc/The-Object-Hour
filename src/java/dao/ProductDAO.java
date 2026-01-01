package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import config.JDBC;
import model.Product;

/**
 * ProductDAO - Data Access Object untuk tabel products
 * Menangani semua operasi CRUD untuk Product
 * 
 * @author The Object Hour Team
 */
public class ProductDAO {
    
    /**
     * Create new product
     * 
     * @param product Product object
     * @return Generated product ID, atau null jika gagal
     */
    public Long createProduct(Product product) {
        String sql = "INSERT INTO products (name, brand, type, strap_material, price, stock, is_active, specifications, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW()) RETURNING id";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getBrand());
            stmt.setString(3, product.getType());
            stmt.setString(4, product.getStrapMaterial());
            stmt.setBigDecimal(5, product.getPrice());
            stmt.setInt(6, product.getStock());
            stmt.setBoolean(7, product.isActive());
            stmt.setString(8, product.getSpecifications());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find product by ID
     * 
     * @param id Product ID
     * @return Product object atau null jika tidak ditemukan
     */
    public Product findById(Long id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding product by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all products
     * 
     * @return List of products
     */
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Get all active products (untuk customer)
     * 
     * @return List of active products
     */
    public List<Product> findAllActive() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting active products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Find products by type
     * 
     * @param type Product type (ANALOG, DIGITAL, SMARTWATCH)
     * @return List of products
     */
    public List<Product> findByType(String type) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type = ? AND is_active = true ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding products by type: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Find products by brand
     * 
     * @param brand Brand name
     * @return List of products
     */
    public List<Product> findByBrand(String brand) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE brand = ? AND is_active = true ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, brand);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding products by brand: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Search products by name
     * 
     * @param keyword Keyword to search
     * @return List of products
     */
    public List<Product> searchByName(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name ILIKE ? AND is_active = true ORDER BY created_at DESC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Get distinct brands from database
     * 
     * @return List of unique brand names
     */
    public List<String> findDistinctBrands() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM products WHERE is_active = true ORDER BY brand ASC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting distinct brands: " + e.getMessage());
            e.printStackTrace();
        }
        return brands;
    }
    
    /**
     * Search for brands containing keyword
     * 
     * @param keyword Search keyword
     * @return List of matching brand names
     */
    public List<String> searchBrands(String keyword) {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM products WHERE is_active = true AND brand ILIKE ? ORDER BY brand ASC";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching brands: " + e.getMessage());
            e.printStackTrace();
        }
        return brands;
    }
    
    /**
     * Update product
     * 
     * @param product Product object with updated data
     * @return true jika berhasil
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, brand = ?, type = ?, strap_material = ?, " +
                     "price = ?, stock = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getBrand());
            stmt.setString(3, product.getType());
            stmt.setString(4, product.getStrapMaterial());
            stmt.setBigDecimal(5, product.getPrice());
            stmt.setInt(6, product.getStock());
            stmt.setBoolean(7, product.isActive());
            stmt.setLong(8, product.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update product stock
     * 
     * @param productId Product ID
     * @param newStock New stock value
     * @return true jika berhasil
     */
    public boolean updateStock(Long productId, int newStock) {
        String sql = "UPDATE products SET stock = ? WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newStock);
            stmt.setLong(2, productId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating stock: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Decrease product stock (untuk checkout)
     * 
     * @param productId Product ID
     * @param quantity Quantity to decrease
     * @return true jika berhasil
     */
    public boolean decreaseStock(Long productId, int quantity) {
        String sql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setLong(2, productId);
            stmt.setInt(3, quantity);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error decreasing stock: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete product by ID (soft delete: set is_active = false)
     * 
     * @param id Product ID
     * @return true jika berhasil
     */
    public boolean deleteProduct(Long id) {
        String sql = "UPDATE products SET is_active = false WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Hard delete product (permanent)
     * 
     * @param id Product ID
     * @return true jika berhasil
     */
    public boolean hardDeleteProduct(Long id) {
        String sql = "DELETE FROM products WHERE id = ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error hard deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method: Map ResultSet to Product object
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getLong("id"));
        product.setName(rs.getString("name"));
        product.setBrand(rs.getString("brand"));
        product.setType(rs.getString("type"));
        product.setStrapMaterial(rs.getString("strap_material"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setActive(rs.getBoolean("is_active"));
        product.setSpecifications(rs.getString("specifications"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return product;
    }
}
