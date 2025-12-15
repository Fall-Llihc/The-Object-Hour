package test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class QuickTest {
    public static void main(String[] args) {
        System.out.println("=== Quick Database Test ===\n");
        
        // GANTI DENGAN CREDENTIALS SUPABASE KAMU!
        String url = "jdbc:postgresql://aws-0-ap-south-1.pooler.supabase.com:5432/postgres";
        String user = "postgres.ykdfyoirtmkscsygyedr";
        String password = "ObjectHour123";
        
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
