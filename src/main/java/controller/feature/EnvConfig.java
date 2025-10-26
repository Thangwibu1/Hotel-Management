package controller.feature;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Class quản lý biến môi trường từ file .env
 * Hỗ trợ load từ file system và classpath
 */
public class EnvConfig {
    private static Properties properties = new Properties();
    private static boolean isLoaded = false;

    // Load file .env khi class được khởi tạo
    static {
        loadEnv();
    }

    /**
     * Load các biến môi trường từ file .env
     * Thử load từ file system trước, nếu không có thì load từ classpath
     */
    private static void loadEnv() {
        if (isLoaded) {
            return;
        }

        try {
            // Thử load từ file system (thư mục gốc project)
            FileInputStream fis = new FileInputStream(".env");
            properties.load(fis);
            fis.close();
            isLoaded = true;
            System.out.println("✓ Đã load file .env thành công từ file system!");
        } catch (IOException e) {
            // Nếu không tìm thấy, thử load từ classpath (resources folder)
            try {
                InputStream is = EnvConfig.class.getClassLoader().getResourceAsStream(".env");
                if (is != null) {
                    properties.load(is);
                    is.close();
                    isLoaded = true;
                    System.out.println("✓ Đã load file .env thành công từ classpath!");
                } else {
                    System.err.println("✗ Không tìm thấy file .env");
                    System.err.println("Vui lòng tạo file .env trong thư mục gốc project hoặc trong resources folder");
                }
            } catch (IOException ex) {
                System.err.println("✗ Lỗi khi đọc file .env: " + ex.getMessage());
            }
        }
    }

    /**
     * Lấy giá trị của biến môi trường
     * @param key Tên biến cần lấy
     * @return Giá trị của biến, null nếu không tìm thấy
     */
    public static String get(String key) {
        if (!isLoaded) {
            loadEnv();
        }

        String value = properties.getProperty(key);
        if (value == null) {
            System.err.println("⚠ Cảnh báo: Không tìm thấy key '" + key + "' trong file .env");
        }
        return value;
    }

    /**
     * Lấy giá trị với giá trị mặc định nếu không tìm thấy
     * @param key Tên biến cần lấy
     * @param defaultValue Giá trị mặc định
     * @return Giá trị của biến hoặc giá trị mặc định
     */
    public static String get(String key, String defaultValue) {
        if (!isLoaded) {
            loadEnv();
        }
        return properties.getProperty(key, defaultValue);
    }

    /**
     * Lấy giá trị bắt buộc, throw exception nếu không tìm thấy
     * @param key Tên biến cần lấy
     * @return Giá trị của biến
     * @throws RuntimeException nếu không tìm thấy
     */
    public static String getRequired(String key) {
        String value = get(key);
        if (value == null || value.trim().isEmpty()) {
            throw new RuntimeException("Biến môi trường bắt buộc '" + key + "' không được tìm thấy hoặc rỗng!");
        }
        return value;
    }

    /**
     * Kiểm tra xem key có tồn tại không
     * @param key Tên biến cần kiểm tra
     * @return true nếu tồn tại, false nếu không
     */
    public static boolean has(String key) {
        if (!isLoaded) {
            loadEnv();
        }
        return properties.containsKey(key);
    }

    /**
     * Hiển thị tất cả các key (không hiển thị value để bảo mật)
     */
    public static void showAllKeys() {
        if (!isLoaded) {
            loadEnv();
        }
        System.out.println("=== Danh sách các key trong .env ===");
        if (properties.isEmpty()) {
            System.out.println("  (Không có key nào)");
        } else {
            properties.keySet().forEach(key -> System.out.println("  ✓ " + key));
        }
    }

    /**
     * Reload file .env (hữu ích khi file .env bị thay đổi)
     */
    public static void reload() {
        properties.clear();
        isLoaded = false;
        loadEnv();
    }

    /**
     * Lấy giá trị dạng int
     */
    public static int getInt(String key, int defaultValue) {
        String value = get(key);
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            System.err.println("⚠ Cảnh báo: Không thể parse '" + key + "' thành int, sử dụng giá trị mặc định: " + defaultValue);
            return defaultValue;
        }
    }

    /**
     * Lấy giá trị dạng boolean
     */
    public static boolean getBoolean(String key, boolean defaultValue) {
        String value = get(key);
        if (value == null) {
            return defaultValue;
        }
        return Boolean.parseBoolean(value);
    }
}


