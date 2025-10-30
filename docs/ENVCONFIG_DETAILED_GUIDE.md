# EnvConfig.java - Hướng Dẫn Chi Tiết

## Tổng Quan

`EnvConfig.java` là một class quản lý biến môi trường từ file `.env`. Class này sử dụng pattern **Singleton** và **Static Methods** để đảm bảo file `.env` chỉ được load một lần duy nhất khi ứng dụng khởi động.

## Mục Đích

- Load và quản lý các biến môi trường từ file `.env`
- Cung cấp các method tiện ích để truy xuất giá trị
- Hỗ trợ type-safe getter (String, int, boolean)
- Cung cấp default values và validation

---

## Các Thuộc Tính (Properties)

### 1. `properties` (Static Properties)
```java
private static Properties properties = new Properties();
```

**Mục đích**: Lưu trữ tất cả các cặp key-value từ file `.env`

**Đặc điểm**:
- `static`: Được chia sẻ giữa tất cả instances
- `Properties`: Class của Java cho phép lưu cặp key-value dạng String

### 2. `isLoaded` (Static Boolean)
```java
private static boolean isLoaded = false;
```

**Mục đích**: Đánh dấu xem file `.env` đã được load hay chưa

**Đặc điểm**:
- Ngăn chặn việc load file `.env` nhiều lần
- Được set thành `true` khi load thành công

---

## Static Block - Khởi Tạo Tự Động

```java
static {
    loadEnv();
}
```

### Cách Hoạt Động:

1. **Khi nào chạy?**: Ngay khi class `EnvConfig` được load vào memory (lần đầu tiên được sử dụng)
2. **Chạy bao nhiêu lần?**: Chỉ một lần duy nhất trong suốt vòng đời ứng dụng
3. **Làm gì?**: Gọi method `loadEnv()` để load file `.env`

### Ví Dụ:
```java
// Khi dòng code này chạy lần đầu:
String email = EnvConfig.get("EMAIL_FROM");

// Trình tự thực hiện:
// 1. JVM load class EnvConfig vào memory
// 2. Static block chạy → gọi loadEnv()
// 3. File .env được đọc và lưu vào properties
// 4. Method get() được thực thi
```

---

## Method `loadEnv()` - Load File Môi Trường

### Full Code:
```java
private static void loadEnv() {
    if (isLoaded) {
        return;
    }

    // For web applications, loading from the classpath is the most reliable method.
    try (InputStream is = EnvConfig.class.getClassLoader().getResourceAsStream(".env")) {
        if (is != null) {
            properties.load(is);
            isLoaded = true;
            System.out.println("✓ Đã load file .env thành công từ classpath!");
        } else {
            System.err.println("✗ Không tìm thấy file .env trong classpath.");
            System.err.println("Vui lòng tạo thư mục 'src/main/resources' và đặt file .env vào đó.");
        }
    } catch (IOException ex) {
        System.err.println("✗ Lỗi khi đọc file .env từ classpath: " + ex.getMessage());
    }
}
```

### Mục Đích:
Load các biến môi trường từ file `.env` vào `properties`

### Cách Hoạt Động Chi Tiết:

#### Bước 1: Kiểm tra đã load chưa
```java
if (isLoaded) {
    return;
}
```
- Nếu đã load rồi, thoát ngay để tránh load lại

#### Bước 2: Load từ classpath
```java
try (InputStream is = EnvConfig.class.getClassLoader().getResourceAsStream(".env")) {
```

**Giải thích**:
- `EnvConfig.class.getClassLoader()`: Lấy ClassLoader của class
- `getResourceAsStream(".env")`: Tìm file `.env` trong classpath
- `try-with-resources`: Tự động đóng InputStream sau khi xong

**Classpath là gì?**
- Đường dẫn mà JVM tìm kiếm resources và classes
- Trong web app: `src/main/resources/` → build thành `WEB-INF/classes/`

#### Bước 3: Load properties
```java
if (is != null) {
    properties.load(is);
    isLoaded = true;
    System.out.println("✓ Đã load file .env thành công từ classpath!");
}
```

**Luồng xử lý**:
1. Kiểm tra InputStream có null không (file có tồn tại không)
2. `properties.load(is)`: Parse file `.env` thành cặp key-value
3. Đánh dấu `isLoaded = true`
4. In thông báo thành công

#### Bước 4: Xử lý lỗi
```java
else {
    System.err.println("✗ Không tìm thấy file .env trong classpath.");
    System.err.println("Vui lòng tạo thư mục 'src/main/resources' và đặt file .env vào đó.");
}
```

### Ví Dụ File .env:
```properties
EMAIL_FROM=myemail@gmail.com
EMAIL_PASSWORD=abcd efgh ijkl mnop
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
```

Sau khi load, `properties` sẽ chứa:
```
{
  "EMAIL_FROM": "myemail@gmail.com",
  "EMAIL_PASSWORD": "abcd efgh ijkl mnop",
  "SMTP_HOST": "smtp.gmail.com",
  "SMTP_PORT": "587"
}
```

---

## Method `get(String key)` - Lấy Giá Trị

### Full Code:
```java
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
```

### Mục Đích:
Lấy giá trị của một biến môi trường theo key

### Tham Số:
- `key`: Tên của biến cần lấy (ví dụ: `"EMAIL_FROM"`)

### Giá Trị Trả Về:
- `String`: Giá trị của biến
- `null`: Nếu không tìm thấy key

### Cách Hoạt Động:

#### Bước 1: Đảm bảo đã load
```java
if (!isLoaded) {
    loadEnv();
}
```
- Safety check: Nếu chưa load thì load ngay

#### Bước 2: Lấy giá trị
```java
String value = properties.getProperty(key);
```
- Tìm kiếm key trong properties
- Trả về `null` nếu không tìm thấy

#### Bước 3: Cảnh báo nếu không tìm thấy
```java
if (value == null) {
    System.err.println("⚠ Cảnh báo: Không tìm thấy key '" + key + "' trong file .env");
}
```

### Ví Dụ Sử Dụng:
```java
// File .env:
// EMAIL_FROM=test@gmail.com

String email = EnvConfig.get("EMAIL_FROM");
System.out.println(email); // Output: test@gmail.com

String notExist = EnvConfig.get("NOT_EXIST");
// Console: ⚠ Cảnh báo: Không tìm thấy key 'NOT_EXIST' trong file .env
System.out.println(notExist); // Output: null
```

---

## Method `get(String key, String defaultValue)` - Lấy Giá Trị với Default

### Full Code:
```java
public static String get(String key, String defaultValue) {
    if (!isLoaded) {
        loadEnv();
    }
    return properties.getProperty(key, defaultValue);
}
```

### Mục Đích:
Lấy giá trị của biến môi trường, nếu không tìm thấy thì trả về giá trị mặc định

### Tham Số:
- `key`: Tên của biến cần lấy
- `defaultValue`: Giá trị mặc định nếu không tìm thấy

### Giá Trị Trả Về:
- Giá trị của key nếu tồn tại
- `defaultValue` nếu không tồn tại

### Cách Hoạt Động:

```java
if (!isLoaded) {
    loadEnv();
}
return properties.getProperty(key, defaultValue);
```

1. Kiểm tra đã load chưa
2. Gọi `getProperty(key, defaultValue)` - method built-in của Properties

### Ví Dụ Sử Dụng:
```java
// File .env chỉ có: EMAIL_FROM=test@gmail.com

String host = EnvConfig.get("SMTP_HOST", "smtp.gmail.com");
System.out.println(host); // Output: smtp.gmail.com (default value)

String email = EnvConfig.get("EMAIL_FROM", "default@gmail.com");
System.out.println(email); // Output: test@gmail.com (từ .env)
```

### Khi Nào Dùng?
- Khi bạn có giá trị mặc định hợp lý
- Khi biến không bắt buộc phải có trong `.env`
- Tránh null pointer exception

---

## Method `getRequired(String key)` - Lấy Giá Trị Bắt Buộc

### Full Code:
```java
public static String getRequired(String key) {
    String value = get(key);
    if (value == null || value.trim().isEmpty()) {
        throw new RuntimeException("Biến môi trường bắt buộc '" + key + "' không được tìm thấy hoặc rỗng!");
    }
    return value;
}
```

### Mục Đích:
Lấy giá trị **bắt buộc** phải có, nếu không có thì throw exception

### Tham Số:
- `key`: Tên của biến bắt buộc

### Giá Trị Trả Về:
- `String`: Giá trị của key

### Exception:
- `RuntimeException`: Nếu key không tồn tại hoặc rỗng

### Cách Hoạt Động:

#### Bước 1: Lấy giá trị
```java
String value = get(key);
```

#### Bước 2: Validate
```java
if (value == null || value.trim().isEmpty()) {
    throw new RuntimeException("Biến môi trường bắt buộc '" + key + "' không được tìm thấy hoặc rỗng!");
}
```

**Điều kiện throw exception**:
- `value == null`: Key không tồn tại trong `.env`
- `value.trim().isEmpty()`: Key tồn tại nhưng giá trị rỗng (hoặc chỉ có khoảng trắng)

### Ví Dụ Sử Dụng:

#### Trường Hợp 1: Key tồn tại
```java
// File .env: EMAIL_FROM=test@gmail.com

String email = EnvConfig.getRequired("EMAIL_FROM");
System.out.println(email); // Output: test@gmail.com
```

#### Trường Hợp 2: Key không tồn tại
```java
// File .env không có key EMAIL_PASSWORD

String password = EnvConfig.getRequired("EMAIL_PASSWORD");
// Throw: RuntimeException: Biến môi trường bắt buộc 'EMAIL_PASSWORD' không được tìm thấy hoặc rỗng!
```

#### Trường Hợp 3: Key rỗng
```java
// File .env: EMAIL_PASSWORD=

String password = EnvConfig.getRequired("EMAIL_PASSWORD");
// Throw: RuntimeException: Biến môi trường bắt buộc 'EMAIL_PASSWORD' không được tìm thấy hoặc rỗng!
```

### Khi Nào Dùng?
- Các biến **PHẢI** có để ứng dụng hoạt động
- Ví dụ: Email, password, database connection
- Muốn fail-fast (lỗi ngay từ đầu) thay vì lỗi khi runtime

---

## Method `has(String key)` - Kiểm Tra Key Tồn Tại

### Full Code:
```java
public static boolean has(String key) {
    if (!isLoaded) {
        loadEnv();
    }
    return properties.containsKey(key);
}
```

### Mục Đích:
Kiểm tra xem một key có tồn tại trong file `.env` hay không

### Tham Số:
- `key`: Tên của biến cần kiểm tra

### Giá Trị Trả Về:
- `true`: Key tồn tại
- `false`: Key không tồn tại

### Cách Hoạt Động:

```java
if (!isLoaded) {
    loadEnv();
}
return properties.containsKey(key);
```

1. Đảm bảo đã load
2. Gọi `containsKey(key)` của Properties

### Ví Dụ Sử Dụng:
```java
// File .env: EMAIL_FROM=test@gmail.com

if (EnvConfig.has("EMAIL_FROM")) {
    String email = EnvConfig.get("EMAIL_FROM");
    System.out.println("Email: " + email);
} else {
    System.out.println("Email chưa được cấu hình");
}

if (!EnvConfig.has("DEBUG_MODE")) {
    System.out.println("Debug mode không được cấu hình");
}
```

### Khi Nào Dùng?
- Khi muốn kiểm tra trước khi lấy giá trị
- Khi cần xử lý logic khác nhau tùy theo key có tồn tại hay không
- Tránh nhận null và phải xử lý sau

---

## Method `showAllKeys()` - Hiển Thị Tất Cả Keys

### Full Code:
```java
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
```

### Mục Đích:
Debug - Hiển thị tất cả các key có trong file `.env` (không hiển thị value để bảo mật)

### Cách Hoạt Động:

```java
if (!isLoaded) {
    loadEnv();
}
System.out.println("=== Danh sách các key trong .env ===");
if (properties.isEmpty()) {
    System.out.println("  (Không có key nào)");
} else {
    properties.keySet().forEach(key -> System.out.println("  ✓ " + key));
}
```

### Output Mẫu:
```
=== Danh sách các key trong .env ===
  ✓ EMAIL_FROM
  ✓ EMAIL_PASSWORD
  ✓ SMTP_HOST
  ✓ SMTP_PORT
```

### Ví Dụ Sử Dụng:
```java
public class Main {
    public static void main(String[] args) {
        EnvConfig.showAllKeys();
    }
}
```

### Lưu Ý Bảo Mật:
- **KHÔNG hiển thị value** để tránh leak thông tin nhạy cảm
- Chỉ hiển thị key để developer biết config nào đang có

---

## Method `reload()` - Reload File .env

### Full Code:
```java
public static void reload() {
    properties.clear();
    isLoaded = false;
    loadEnv();
}
```

### Mục Đích:
Reload lại file `.env` (hữu ích khi file `.env` bị thay đổi trong lúc chạy)

### Cách Hoạt Động:

```java
properties.clear();      // Xóa tất cả key-value cũ
isLoaded = false;        // Đặt lại flag
loadEnv();               // Load lại file
```

### Ví Dụ Sử Dụng:
```java
// Lần 1: File .env có EMAIL_FROM=old@gmail.com
String email1 = EnvConfig.get("EMAIL_FROM");
System.out.println(email1); // Output: old@gmail.com

// Developer sửa file .env thành EMAIL_FROM=new@gmail.com
// (Trong thực tế cần restart server, nhưng có thể test bằng reload)

EnvConfig.reload();

String email2 = EnvConfig.get("EMAIL_FROM");
System.out.println(email2); // Output: new@gmail.com
```

### Khi Nào Dùng?
- **Môi trường development**: Test thay đổi config
- **Hot reload**: Khi muốn reload config mà không restart server
- **Thực tế**: Ít dùng vì thường restart server khi đổi config

---

## Method `getInt(String key, int defaultValue)` - Lấy Giá Trị Int

### Full Code:
```java
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
```

### Mục Đích:
Lấy giá trị dạng số nguyên, với xử lý lỗi nếu không parse được

### Tham Số:
- `key`: Tên của biến
- `defaultValue`: Giá trị mặc định nếu không tìm thấy hoặc parse lỗi

### Giá Trị Trả Về:
- `int`: Giá trị đã parse
- `defaultValue`: Nếu không tìm thấy hoặc parse lỗi

### Cách Hoạt Động:

#### Bước 1: Lấy giá trị String
```java
String value = get(key);
if (value == null) {
    return defaultValue;
}
```

#### Bước 2: Parse thành int
```java
try {
    return Integer.parseInt(value);
} catch (NumberFormatException e) {
    System.err.println("⚠ Cảnh báo: Không thể parse '" + key + "' thành int, sử dụng giá trị mặc định: " + defaultValue);
    return defaultValue;
}
```

### Ví Dụ Sử Dụng:

#### Trường Hợp 1: Parse thành công
```java
// File .env: SMTP_PORT=587

int port = EnvConfig.getInt("SMTP_PORT", 465);
System.out.println(port); // Output: 587
```

#### Trường Hợp 2: Key không tồn tại
```java
// File .env không có MAX_RETRIES

int maxRetries = EnvConfig.getInt("MAX_RETRIES", 3);
System.out.println(maxRetries); // Output: 3 (default)
```

#### Trường Hợp 3: Parse lỗi
```java
// File .env: SMTP_PORT=invalid_number

int port = EnvConfig.getInt("SMTP_PORT", 587);
// Console: ⚠ Cảnh báo: Không thể parse 'SMTP_PORT' thành int, sử dụng giá trị mặc định: 587
System.out.println(port); // Output: 587 (default)
```

### Khi Nào Dùng?
- Port numbers (SMTP_PORT, HTTP_PORT)
- Timeout values
- Retry counts
- Any numeric configuration

---

## Method `getBoolean(String key, boolean defaultValue)` - Lấy Giá Trị Boolean

### Full Code:
```java
public static boolean getBoolean(String key, boolean defaultValue) {
    String value = get(key);
    if (value == null) {
        return defaultValue;
    }
    return Boolean.parseBoolean(value);
}
```

### Mục Đích:
Lấy giá trị dạng boolean (true/false)

### Tham Số:
- `key`: Tên của biến
- `defaultValue`: Giá trị mặc định nếu không tìm thấy

### Giá Trị Trả Về:
- `true/false`: Giá trị đã parse
- `defaultValue`: Nếu không tìm thấy

### Cách Hoạt Động:

```java
String value = get(key);
if (value == null) {
    return defaultValue;
}
return Boolean.parseBoolean(value);
```

### Lưu Ý về `Boolean.parseBoolean()`:
- `"true"` (case-insensitive) → `true`
- Bất kỳ giá trị nào khác → `false`
- Không throw exception

### Ví Dụ Sử Dụng:

```java
// File .env:
// DEBUG_MODE=true
// ENABLE_EMAIL=false
// SOMETHING_ELSE=yes

boolean debug = EnvConfig.getBoolean("DEBUG_MODE", false);
System.out.println(debug); // Output: true

boolean email = EnvConfig.getBoolean("ENABLE_EMAIL", true);
System.out.println(email); // Output: false

boolean something = EnvConfig.getBoolean("SOMETHING_ELSE", false);
System.out.println(something); // Output: false (vì "yes" không phải "true")

boolean notExist = EnvConfig.getBoolean("NOT_EXIST", true);
System.out.println(notExist); // Output: true (default)
```

### Khi Nào Dùng?
- Debug mode
- Feature flags
- Enable/disable features
- Boolean configuration options

---

## Tóm Tắt Flow Hoạt Động

### 1. Khi Application Khởi Động:

```
Application Start
    ↓
EnvConfig class được load
    ↓
Static block chạy
    ↓
loadEnv() được gọi
    ↓
Đọc file .env từ classpath
    ↓
Parse thành Properties (key-value pairs)
    ↓
Lưu vào static variable 'properties'
    ↓
Đặt isLoaded = true
    ↓
Sẵn sàng sử dụng
```

### 2. Khi Gọi Method get():

```
EnvConfig.get("EMAIL_FROM")
    ↓
Kiểm tra isLoaded?
    ↓ (nếu false)
loadEnv()
    ↓
properties.getProperty("EMAIL_FROM")
    ↓
Return value hoặc null
```

### 3. Khi Gọi Method getRequired():

```
EnvConfig.getRequired("EMAIL_FROM")
    ↓
get("EMAIL_FROM")
    ↓
value == null hoặc empty?
    ↓ (nếu true)
throw RuntimeException
    ↓ (nếu false)
Return value
```

---

## Best Practices

### 1. **Sử dụng getRequired() cho Config Quan Trọng**
```java
// GOOD - Fail fast nếu thiếu config
String email = EnvConfig.getRequired("EMAIL_FROM");
String password = EnvConfig.getRequired("EMAIL_PASSWORD");
```

### 2. **Sử dụng get() với Default Value cho Config Optional**
```java
// GOOD - Có giá trị mặc định hợp lý
String host = EnvConfig.get("SMTP_HOST", "smtp.gmail.com");
int port = EnvConfig.getInt("SMTP_PORT", 587);
```

### 3. **Kiểm Tra Trước Khi Sử Dụng**
```java
// GOOD - Safe check
if (EnvConfig.has("CUSTOM_CONFIG")) {
    String config = EnvConfig.get("CUSTOM_CONFIG");
    // Use config
}
```

### 4. **Không Hardcode Sensitive Data**
```java
// BAD
String email = "myemail@gmail.com";

// GOOD - Lưu trong .env
String email = EnvConfig.getRequired("EMAIL_FROM");
```

---

## Cấu Trúc File .env

### Format:
```properties
# Email Configuration
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=your-app-password

# SMTP Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587

# Optional Configurations
DEBUG_MODE=false
MAX_RETRIES=3
```

### Lưu Ý:
- Mỗi dòng là một cặp `KEY=VALUE`
- Không có dấu ngoặc kép
- Comment bằng dấu `#`
- Không có khoảng trắng quanh dấu `=`

---

## Troubleshooting

### Problem 1: "Không tìm thấy file .env trong classpath"

**Nguyên nhân**: File `.env` không nằm trong `src/main/resources/`

**Giải pháp**:
```
Dự án/
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │       └── .env  ← Đặt file ở đây
```

### Problem 2: "Không tìm thấy key trong .env"

**Nguyên nhân**: Key không tồn tại hoặc sai tên

**Giải pháp**:
```java
// Debug: Xem tất cả keys
EnvConfig.showAllKeys();

// Kiểm tra key có tồn tại không
if (EnvConfig.has("YOUR_KEY")) {
    // Key tồn tại
}
```

### Problem 3: "Giá trị bị null"

**Nguyên nhân**: Key tồn tại nhưng không có giá trị

**File .env**:
```properties
EMAIL_FROM=   ← Rỗng
```

**Giải pháp**: Thêm giá trị cho key

---

## Kết Luận

`EnvConfig.java` cung cấp một cách an toàn và tiện lợi để quản lý environment variables:

✅ **Singleton pattern**: Load một lần duy nhất  
✅ **Type-safe**: Support String, int, boolean  
✅ **Fail-fast**: `getRequired()` throw exception ngay  
✅ **Default values**: Graceful degradation  
✅ **Debug-friendly**: `showAllKeys()`, `has()`  
✅ **Reload support**: Hot reload configuration  

Sử dụng class này giúp code clean hơn, bảo mật hơn, và dễ maintain hơn!

