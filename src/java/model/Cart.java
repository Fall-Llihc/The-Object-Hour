package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Cart Entity Model
 * Represents carts table in database
 * 
 * @author The Object Hour Team
 */
public class Cart {
    private Long id;
    private Long userId;
    private boolean isActive;
    private LocalDateTime createdAt;
    
    // Transient field - not in database
    private List<CartItem> items;

    // Constructors
    public Cart() {
        this.items = new ArrayList<>();
    }

    public Cart(Long id, Long userId, boolean isActive, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.items = new ArrayList<>();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
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

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    // Helper methods
    public void addItem(CartItem item) {
        this.items.add(item);
    }

    public int getTotalItems() {
        return items.stream().mapToInt(CartItem::getQuantity).sum();
    }

    @Override
    public String toString() {
        return "Cart{" +
                "id=" + id +
                ", userId=" + userId +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                ", itemsCount=" + (items != null ? items.size() : 0) +
                '}';
    }
}
