package service;

import dao.ProductDAO;
import model.Product;
import java.math.BigDecimal;
import java.util.List;

/**
 * ProductService - Service layer untuk manajemen produk
 * Menangani business logic untuk CRUD produk
 * 
 * @author The Object Hour Team
 */
public class ProductService {
    
    private ProductDAO productDAO;
    
    public ProductService() {
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get all active products (untuk customer)
     * 
     * @return List of active products
     */
    public List<Product> getAllActiveProducts() {
        return productDAO.findAllActive();
    }
    
    /**
     * Get all products (untuk admin)
     * 
     * @return List of all products
     */
    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }
    
    /**
     * Get product by ID
     * 
     * @param productId Product ID
     * @return Product object
     */
    public Product getProductById(Long productId) {
        return productDAO.findById(productId);
    }
    
    /**
     * Get products by type
     * 
     * @param type Product type (ANALOG, DIGITAL, SMARTWATCH)
     * @return List of products
     */
    public List<Product> getProductsByType(String type) {
        return productDAO.findByType(type);
    }
    
    /**
     * Get products by brand
     * 
     * @param brand Brand name
     * @return List of products
     */
    public List<Product> getProductsByBrand(String brand) {
        return productDAO.findByBrand(brand);
    }
    
    /**
     * Search products by name
     * 
     * @param keyword Search keyword
     * @return List of products
     */
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveProducts();
        }
        return productDAO.searchByName(keyword);
    }
    
    /**
     * Create new product (admin only)
     * 
     * @param name Product name
     * @param brand Brand name
     * @param type Product type
     * @param strapMaterial Strap material
     * @param price Price
     * @param stock Stock quantity
     * @return Product ID jika berhasil, null jika gagal
     */
    public Long createProduct(String name, String brand, String type, String strapMaterial, 
                             BigDecimal price, int stock) {
        // Validasi input
        if (name == null || name.trim().isEmpty()) {
            System.out.println("Product name is required");
            return null;
        }
        
        if (brand == null || brand.trim().isEmpty()) {
            System.out.println("Brand is required");
            return null;
        }
        
        if (type == null || (!type.equals("ANALOG") && !type.equals("DIGITAL") && !type.equals("SMARTWATCH"))) {
            System.out.println("Invalid product type. Must be ANALOG, DIGITAL, or SMARTWATCH");
            return null;
        }
        
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            System.out.println("Price must be greater than 0");
            return null;
        }
        
        if (stock < 0) {
            System.out.println("Stock cannot be negative");
            return null;
        }
        
        // Buat product baru
        Product product = new Product();
        product.setName(name);
        product.setBrand(brand);
        product.setType(type);
        product.setStrapMaterial(strapMaterial);
        product.setPrice(price);
        product.setStock(stock);
        product.setActive(true);
        
        // Simpan ke database
        Long productId = productDAO.createProduct(product);
        
        if (productId != null) {
            System.out.println("Product created successfully: " + name);
        }
        
        return productId;
    }
    
    /**
     * Update product (admin only)
     * 
     * @param product Product object with updated data
     * @return true jika berhasil
     */
    public boolean updateProduct(Product product) {
        // Validasi input
        if (product == null || product.getId() == null) {
            System.out.println("Invalid product");
            return false;
        }
        
        if (product.getPrice() != null && product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            System.out.println("Price must be greater than 0");
            return false;
        }
        
        if (product.getStock() < 0) {
            System.out.println("Stock cannot be negative");
            return false;
        }
        
        // Update database
        boolean success = productDAO.updateProduct(product);
        
        if (success) {
            System.out.println("Product updated successfully: " + product.getName());
        }
        
        return success;
    }
    
    /**
     * Delete (deactivate) product (admin only)
     * 
     * @param productId Product ID
     * @return true jika berhasil
     */
    public boolean deleteProduct(Long productId) {
        boolean success = productDAO.deleteProduct(productId);
        
        if (success) {
            System.out.println("Product deactivated successfully: " + productId);
        }
        
        return success;
    }
    
    public boolean hardDeleteProduct(Long productId) {
        if (productId == null) return false;
        return productDAO.hardDeleteProduct(productId);
    }
    
    /**
     * Check if product is available (in stock and active)
     * 
     * @param productId Product ID
     * @param quantity Required quantity
     * @return true if available
     */
    public boolean isProductAvailable(Long productId, int quantity) {
        Product product = productDAO.findById(productId);
        
        if (product == null) {
            System.out.println("Product not found: " + productId);
            return false;
        }
        
        if (!product.isActive()) {
            System.out.println("Product is not active: " + productId);
            return false;
        }
        
        if (product.getStock() < quantity) {
            System.out.println("Insufficient stock for product: " + productId + 
                             " (Available: " + product.getStock() + ", Required: " + quantity + ")");
            return false;
        }
        
        return true;
    }
    
    /**
     * Update product stock
     * 
     * @param productId Product ID
     * @param newStock New stock value
     * @return true jika berhasil
     */
    public boolean updateStock(Long productId, int newStock) {
        if (newStock < 0) {
            System.out.println("Stock cannot be negative");
            return false;
        }
        
        return productDAO.updateStock(productId, newStock);
    }
    
    /**
     * Decrease product stock (untuk checkout)
     * 
     * @param productId Product ID
     * @param quantity Quantity to decrease
     * @return true jika berhasil
     */
    public boolean decreaseStock(Long productId, int quantity) {
        if (quantity <= 0) {
            System.out.println("Quantity must be greater than 0");
            return false;
        }
        
        // Check stock availability first
        if (!isProductAvailable(productId, quantity)) {
            return false;
        }
        
        return productDAO.decreaseStock(productId, quantity);
    }
}
