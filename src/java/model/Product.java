package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Product Entity Model
 * Represents products table in database
 * 
 * @author The Object Hour Team
 */
public class Product {
    private Long id;
    private String name;
    private String brand;
    private String type; // 'ANALOG', 'DIGITAL', 'SMARTWATCH'
    private String strapMaterial;
    private BigDecimal price;
    private int stock;
    private boolean isActive;
    private LocalDateTime createdAt;

    // Constructors
    public Product() {
    }

    public Product(Long id, String name, String brand, String type, String strapMaterial, 
                   BigDecimal price, int stock, boolean isActive, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.type = type;
        this.strapMaterial = strapMaterial;
        this.price = price;
        this.stock = stock;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStrapMaterial() {
        return strapMaterial;
    }

    public void setStrapMaterial(String strapMaterial) {
        this.strapMaterial = strapMaterial;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Helper methods
    public boolean isInStock() {
        return this.stock > 0 && this.isActive;
    }

    public boolean canFulfillOrder(int quantity) {
        return this.stock >= quantity && this.isActive;
    }

    public void decreaseStock(int quantity) {
        if (this.stock >= quantity) {
            this.stock -= quantity;
        } else {
            throw new IllegalArgumentException("Insufficient stock");
        }
    }
    
    /**
     * Get Supabase Storage image URL for this product
     * @return Full URL to product image in Supabase Storage
     */
    public String getImageUrl() {
        String baseUrl = "https://ykdfyoirtmkscsygyedr.supabase.co/storage/v1/object/public/Gambar%20Jam/";
        String encodedName = this.name.replace(" ", "%20");
        return baseUrl + encodedName + ".png";
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", brand='" + brand + '\'' +
                ", type='" + type + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", isActive=" + isActive +
                '}';
    }
}
