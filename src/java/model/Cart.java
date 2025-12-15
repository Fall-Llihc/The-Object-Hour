package classes;

import java.util.ArrayList;

public class Cart {
    private int id;
    private int userId;
    private boolean isActive;
    private ArrayList<CartItem> items;

    // Constructor
    public Cart() {
        items = new ArrayList<>();
        isActive = true;
    }

    public Cart(int id, int userId, boolean isActive) {
        this.id = id;
        this.userId = userId;
        this.isActive = isActive;
        this.items = new ArrayList<>();
    }

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public ArrayList<CartItem> getItems() {
        return items;
    }

    public void addItem(CartItem item) {
        items.add(item);
    }

    public void removeItem(CartItem item) {
        items.remove(item);
    }

    public double calculateTotal() {
        double total = 0;
        for (CartItem item : items) {
            total += item.getSubtotal();
        }
        return total;
    }
}
