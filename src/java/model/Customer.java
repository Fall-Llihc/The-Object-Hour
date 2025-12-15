package model;

import java.time.LocalDateTime;

/**
 * Customer User Model (extends User)
 * Represents customer user with shopping-specific functionalities
 * 
 * @author The Object Hour Team
 */
public class Customer extends User {

    public Customer() {
        super();
        this.setRole("CUSTOMER");
    }

    public Customer(Long id, String username, String passwordHash, String name, LocalDateTime createdAt) {
        super(id, username, passwordHash, name, "CUSTOMER", createdAt);
    }

    // Customer-specific methods can be added here
    public boolean canShop() {
        return true;
    }

    public boolean canCheckout() {
        return true;
    }

    public boolean canViewOrders() {
        return true;
    }
}
