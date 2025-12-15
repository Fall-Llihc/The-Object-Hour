package test;

import config.JDBC;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDatabaseConnection {
    public static void main(String[] args) {
        System.out.println("=== Testing Database Connection ===\n");
        
        try {
            // Test 1: Connection
            System.out.println("1. Testing connection to Supabase...");
            Connection conn = JDBC.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✓ Connection SUCCESS!\n");
                
                // Test 2: Count Users
                System.out.println("2. Testing Users table...");
                String sqlUsers = "SELECT COUNT(*) as total FROM users";
                PreparedStatement stmtUsers = conn.prepareStatement(sqlUsers);
                ResultSet rsUsers = stmtUsers.executeQuery();
                if (rsUsers.next()) {
                    int totalUsers = rsUsers.getInt("total");
                    System.out.println("✓ Total Users: " + totalUsers);
                }
                rsUsers.close();
                stmtUsers.close();
                
                // Test 3: List Users
                System.out.println("\n3. Listing all users:");
                String sqlListUsers = "SELECT id, username, name, role FROM users ORDER BY id";
                PreparedStatement stmtList = conn.prepareStatement(sqlListUsers);
                ResultSet rsList = stmtList.executeQuery();
                while (rsList.next()) {
                    System.out.println("   - ID: " + rsList.getLong("id") + 
                                     " | Username: " + rsList.getString("username") + 
                                     " | Name: " + rsList.getString("name") + 
                                     " | Role: " + rsList.getString("role"));
                }
                rsList.close();
                stmtList.close();
                
                // Test 4: Count Products
                System.out.println("\n4. Testing Products table...");
                String sqlProducts = "SELECT COUNT(*) as total FROM products WHERE is_active = true";
                PreparedStatement stmtProducts = conn.prepareStatement(sqlProducts);
                ResultSet rsProducts = stmtProducts.executeQuery();
                if (rsProducts.next()) {
                    int totalProducts = rsProducts.getInt("total");
                    System.out.println("✓ Total Active Products: " + totalProducts);
                }
                rsProducts.close();
                stmtProducts.close();
                
                // Test 5: Sample Products
                System.out.println("\n5. Sample products (first 5):");
                String sqlSample = "SELECT name, brand, type, price, stock FROM products WHERE is_active = true ORDER BY id LIMIT 5";
                PreparedStatement stmtSample = conn.prepareStatement(sqlSample);
                ResultSet rsSample = stmtSample.executeQuery();
                while (rsSample.next()) {
                    System.out.println("   - " + rsSample.getString("brand") + " " + 
                                     rsSample.getString("name") + 
                                     " (" + rsSample.getString("type") + ")" +
                                     " - Rp " + String.format("%,.0f", rsSample.getDouble("price")) + 
                                     " - Stock: " + rsSample.getInt("stock"));
                }
                rsSample.close();
                stmtSample.close();
                
                // Test 6: Group by Type
                System.out.println("\n6. Products by Type:");
                String sqlByType = "SELECT type, COUNT(*) as total FROM products WHERE is_active = true GROUP BY type ORDER BY type";
                PreparedStatement stmtType = conn.prepareStatement(sqlByType);
                ResultSet rsType = stmtType.executeQuery();
                while (rsType.next()) {
                    System.out.println("   - " + rsType.getString("type") + ": " + rsType.getInt("total") + " products");
                }
                rsType.close();
                stmtType.close();
                
                conn.close();
                System.out.println("\n✓ All tests PASSED! Database connection is working perfectly!\n");
                
            } else {
                System.out.println("✗ Connection FAILED!");
            }
            
        } catch (Exception e) {
            System.out.println("✗ ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
