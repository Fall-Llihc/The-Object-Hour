package model;

import java.time.LocalDateTime;

/**
 * Admin User Model (extends User)
 * Represents admin user with additional admin-specific functionalities
 * 
 * @author The Object Hour Team
 */
public class Admin extends User {

    public Admin() {
        super();
        this.setRole("ADMIN");
    }

    public Admin(Long id, String username, String passwordHash, String name, LocalDateTime createdAt) {
        super(id, username, passwordHash, name, "ADMIN", createdAt);
    }

    // Admin-specific methods can be added here
    public boolean canManageProducts() {
        return true;
    }

    public boolean canViewReports() {
        return true;
    }

    public boolean canManageUsers() {
        return true;
    }
}
