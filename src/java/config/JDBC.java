package config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Database Connection Utility for PostgreSQL (Supabase)
 * Manages database connections using connection pooling best practices
 * 
 * @author The Object Hour Team
 */
public class JDBC {
    
    private static String DB_URL;
    private static String DB_USER;
    private static String DB_PASSWORD;
    private static String DB_DRIVER;
    
    // Static block untuk load konfigurasi saat class pertama kali dimuat
    static {
        loadDatabaseConfig();
    }
    
    /**
     * Load database configuration from db.properties file
     */
    private static void loadDatabaseConfig() {
        Properties props = new Properties();
        try (InputStream input = JDBC.class.getClassLoader().getResourceAsStream("config/db.properties")) {
            if (input == null) {
                System.err.println("Sorry, unable to find db.properties");
                // Fallback ke environment variables atau hardcoded (untuk development)
                loadFromEnvironment();
                return;
            }
            props.load(input);
            DB_URL = props.getProperty("db.url");
            DB_USER = props.getProperty("db.user");
            DB_PASSWORD = props.getProperty("db.password");
            DB_DRIVER = props.getProperty("db.driver");
            
            // Load PostgreSQL driver
            Class.forName(DB_DRIVER);
            System.out.println("Database configuration loaded successfully");
        } catch (IOException | ClassNotFoundException e) {
            System.err.println("Error loading database configuration: " + e.getMessage());
            loadFromEnvironment();
        }
    }
    
    /**
     * Fallback: Load from environment variables
     */
    private static void loadFromEnvironment() {
        // Try Docker-style env vars first
        String dbHost = System.getenv("DB_HOST");
        String dbPort = System.getenv("DB_PORT");
        String dbName = System.getenv("DB_NAME");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");
        
        if (dbHost != null && dbPort != null && dbName != null && dbUser != null && dbPassword != null) {
            // Build URL from components (Docker format)
            DB_URL = String.format("jdbc:postgresql://%s:%s/%s", dbHost, dbPort, dbName);
            DB_USER = dbUser;
            DB_PASSWORD = dbPassword;
        } else {
            // Try legacy env var format
            DB_URL = System.getenv("DB_URL");
            DB_USER = System.getenv("DB_USER");
            DB_PASSWORD = System.getenv("DB_PASSWORD");
        }
        
        DB_DRIVER = "org.postgresql.Driver";
        
        if (DB_URL == null || DB_USER == null || DB_PASSWORD == null) {
            // Development fallback (remove in production!)
            DB_URL = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
            DB_USER = "postgres.xgpzjbssvucrbzfglolt";
            DB_PASSWORD = "TheObjectHour123";
        }
        
        try {
            Class.forName(DB_DRIVER);
            System.out.println("Database configuration loaded from environment variables");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL Driver not found: " + e.getMessage());
        }
    }
    
    /**
     * Get database connection
     * ALWAYS use try-with-resources untuk auto-close connection
     * 
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (DB_URL == null || DB_USER == null || DB_PASSWORD == null) {
            throw new SQLException("Database configuration not loaded properly");
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    /**
     * Test database connection
     * 
     * @return true if connection successful
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Connection test failed: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Close connection safely
     * 
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}
