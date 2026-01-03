package test;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

public class QuickTest {
    public static void main(String[] args) {
        System.out.println("=== Quick Database Test ===\n");
        
        // Load configuration from db.properties
        String url = null;
        String user = null;
        String password = null;
        
        try {
            Properties props = new Properties();
            InputStream input = QuickTest.class.getResourceAsStream("/config/db.properties");
            if (input != null) {
                props.load(input);
                url = props.getProperty("db.url");
                user = props.getProperty("db.user");
                password = props.getProperty("db.password");
                input.close();
            }
        } catch (Exception e) {
            System.err.println("Error loading db.properties: " + e.getMessage());
        }
        
        // Fallback to environment variables if properties not found
        if (url == null) url = System.getenv("DB_URL");
        if (user == null) user = System.getenv("DB_USER");
        if (password == null) password = System.getenv("DB_PASSWORD");
        
        System.out.println("Testing connection to:");
        System.out.println("URL: " + url);
        System.out.println("User: " + user);
        System.out.println();
        
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            if (conn != null) {
                System.out.println("✓ CONNECTION SUCCESS!\n");
                
                // Count users
                PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM users");
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    System.out.println("Total users in database: " + rs.getInt(1));
                }
                rs.close();
                stmt.close();
                
                // Count products
                stmt = conn.prepareStatement("SELECT COUNT(*) FROM products");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    System.out.println("Total products in database: " + rs.getInt(1));
                }
                rs.close();
                stmt.close();
                
                conn.close();
                System.out.println("\n✓ Database is working perfectly!");
            }
            
        } catch (Exception e) {
            System.out.println("✗ CONNECTION FAILED!");
            System.out.println("Error: " + e.getMessage());
            System.out.println("\nPossible issues:");
            System.out.println("1. Wrong username/password");
            System.out.println("2. Wrong database URL");
            System.out.println("3. Database not accessible");
            System.out.println("\nPlease check your Supabase credentials!");
        }
    }
}
