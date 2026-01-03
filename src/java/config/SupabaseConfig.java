package config;

import java.io.InputStream;
import java.util.Properties;

/**
 * Centralized Supabase Configuration Manager
 * Loads configuration from db.properties and environment variables
 * 
 * @author The Object Hour Team
 */
public class SupabaseConfig {
    private static String supabaseUrl;
    private static String serviceKey;
    private static String bucketName;
    
    static {
        loadConfig();
    }
    
    private static void loadConfig() {
        try {
            // Load from properties file first
            Properties props = new Properties();
            InputStream input = SupabaseConfig.class.getResourceAsStream("/config/db.properties");
            if (input != null) {
                props.load(input);
                supabaseUrl = props.getProperty("supabase.url");
                serviceKey = props.getProperty("supabase.service.key");
                bucketName = props.getProperty("supabase.bucket");
                input.close();
            }
        } catch (Exception e) {
            System.err.println("Error loading Supabase config from properties: " + e.getMessage());
        }
        
        // Fallback to environment variables
        if (supabaseUrl == null) {
            supabaseUrl = System.getenv("SUPABASE_URL");
        }
        if (serviceKey == null) {
            serviceKey = System.getenv("SUPABASE_SERVICE_KEY");
        }
        if (bucketName == null) {
            bucketName = System.getenv("SUPABASE_BUCKET");
        }
        
        // Set defaults if still null
        if (bucketName == null) {
            bucketName = "Gambar Jam";
        }
    }
    
    /**
     * Get Supabase project URL
     * @return Supabase URL (e.g., https://xgpzjbssvucrbzfglolt.supabase.co)
     */
    public static String getSupabaseUrl() {
        return supabaseUrl;
    }
    
    /**
     * Get Supabase Storage bucket name for product images
     * @return Bucket name (default: "Gambar Jam")
     */
    public static String getBucketName() {
        return bucketName;
    }
    
    /**
     * Get Supabase service role key
     * @return Service key for API access
     */
    public static String getServiceKey() {
        return serviceKey;
    }
    
    /**
     * Get full Supabase Storage base URL for product images
     * @return Full storage URL (e.g., https://xgpzjbssvucrbzfglolt.supabase.co/storage/v1/object/public/Gambar%20Jam/)
     */
    public static String getStorageBaseUrl() {
        if (supabaseUrl == null || bucketName == null) {
            return null;
        }
        String encodedBucket = bucketName.replace(" ", "%20");
        return supabaseUrl + "/storage/v1/object/public/" + encodedBucket + "/";
    }
    
    /**
     * Reload configuration (useful for runtime changes)
     */
    public static void reloadConfig() {
        loadConfig();
    }
}