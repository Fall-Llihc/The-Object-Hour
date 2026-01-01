package service;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 * Small helper service to upload product images to Supabase Storage.
 * Reads configuration from `config/db.properties` or environment variable `SUPABASE_SERVICE_KEY`.
 */
public class SupabaseStorageService {

    private final String supabaseUrl;
    private final String serviceKey;
    private final String bucket;

    public SupabaseStorageService() {
        Properties props = new Properties();
        String tmpUrl = null;
        String tmpKey = null;
        String tmpBucket = "Gambar Jam";
        try (InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream("config/db.properties")) {
            if (in != null) {
                props.load(in);
                tmpUrl = props.getProperty("supabase.url");
                tmpKey = props.getProperty("supabase.service.key");
                tmpBucket = props.getProperty("supabase.bucket", tmpBucket);
            }
        } catch (IOException e) {
            // ignore and fallback to env
        }

        if (tmpKey == null || tmpKey.trim().isEmpty()) {
            tmpKey = System.getenv("SUPABASE_SERVICE_KEY");
        }
        if (tmpUrl == null || tmpUrl.trim().isEmpty()) {
            tmpUrl = System.getenv("SUPABASE_URL");
        }
        this.supabaseUrl = (tmpUrl != null && !tmpUrl.isEmpty()) ? tmpUrl : "";
        this.serviceKey = (tmpKey != null && !tmpKey.isEmpty()) ? tmpKey : null;
        this.bucket = tmpBucket;
    }

    /**
     * Uploads the given input stream to Supabase Storage under the bucket and filename provided.
     * Uses PUT to /storage/v1/object/{bucket}/{path} with Authorization header.
     * Returns true on 2xx response.
     */
    public boolean uploadFile(InputStream input, String filename, String contentType) throws IOException {
        if (serviceKey == null || serviceKey.trim().isEmpty()) {
            System.err.println("Supabase service key not configured. Set supabase.service.key in db.properties or SUPABASE_SERVICE_KEY env var.");
            return false;
        }
        if (supabaseUrl == null || supabaseUrl.isEmpty()) {
            System.err.println("Supabase URL not configured.");
            return false;
        }

        String encBucket = URLEncoder.encode(bucket, StandardCharsets.UTF_8.toString()).replace("+", "%20");
        String encFilename = URLEncoder.encode(filename, StandardCharsets.UTF_8.toString()).replace("+", "%20");

        // PUT to storage endpoint (uploads object)
        String endpoint = String.format("%s/storage/v1/object/%s/%s", supabaseUrl, encBucket, encFilename);
        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("PUT");
        conn.setRequestProperty("Authorization", "Bearer " + serviceKey);
        if (contentType != null && !contentType.isEmpty()) {
            conn.setRequestProperty("Content-Type", contentType);
        }
        // Ask Supabase to upsert if object exists
        conn.setRequestProperty("x-upsert", "true");

        try (OutputStream os = conn.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int read;
            while ((read = input.read(buffer)) != -1) {
                os.write(buffer, 0, read);
            }
            os.flush();
        }

        int code = conn.getResponseCode();
        return code >= 200 && code < 300;
    }
}
