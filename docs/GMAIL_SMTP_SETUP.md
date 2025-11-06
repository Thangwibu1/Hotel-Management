# Hướng Dẫn Cấu Hình Gmail SMTP

## Lỗi SSL/TLS Handshake - Nguyên Nhân và Giải Pháp

### Lỗi thường gặp:

```
javax.mail.MessagingException: Could not convert socket to TLS
javax.net.ssl.SSLHandshakeException: Remote host terminated the handshake
```

## Bước 1: Tạo App Password cho Gmail

Google đã **tắt tính năng "Less secure app access"**, bạn **BẮT BUỘC** phải sử dụng **App Password**.

### Cách tạo App Password:

1. **Truy cập Google Account**: https://myaccount.google.com/
2. **Bật 2-Step Verification** (bắt buộc):
   - Vào `Security` → `2-Step Verification`
   - Follow hướng dẫn để bật
3. **Tạo App Password**:
   - Vào `Security` → `2-Step Verification` → kéo xuống dưới
   - Chọn `App passwords`
   - Chọn app: `Mail`
   - Chọn device: `Other (Custom name)` → nhập tên: `Hotel Management`
   - Click `Generate`
   - **LƯU Ý**: Copy mật khẩu 16 ký tự này ngay (bỏ khoảng trắng)

## Bước 2: Cấu Hình File .env

Tạo hoặc cập nhật file `.env` trong thư mục gốc project:

### Cấu hình cho Port 587 (STARTTLS) - Khuyến nghị

```env
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=abcd efgh ijkl mnop
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
```

### Cấu hình cho Port 465 (SSL) - Alternative

Nếu port 587 không hoạt động, thử port 465:

```env
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=abcd efgh ijkl mnop
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
```

### Lưu ý quan trọng:

1. **EMAIL_FROM**: Địa chỉ Gmail của bạn
2. **EMAIL_PASSWORD**:
   - ❌ KHÔNG dùng mật khẩu Gmail thường
   - ✅ PHẢI dùng App Password (16 ký tự)
   - Có thể có hoặc không có khoảng trắng đều được
3. **SMTP_PORT**:
   - `587` - STARTTLS (thử đầu tiên)
   - `465` - SSL (nếu 587 không được)

## Bước 3: Vị Trí File .env

File `.env` phải được đặt ở:

```
Hotel-Management/
├── .env          ← File cấu hình ở đây
├── pom.xml
├── src/
└── ...
```

## Bước 4: Test Email

### Option 1: Thử gửi email test đơn giản

Tạo file test:

```java
package controller.feature;

public class EmailTest {
    public static void main(String[] args) {
        try {
            EmailSender sender = new EmailSender();
            boolean result = sender.sendTextEmail(
                "recipient@example.com",  // Thay bằng email nhận
                "Test Email",
                "This is a test email from Hotel Management System"
            );

            if (result) {
                System.out.println("✓ Email sent successfully!");
            } else {
                System.out.println("✗ Failed to send email!");
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

### Option 2: Enable Debug Mode

Trong `EmailSender.java`, uncomment dòng debug:

```java
// Debug mode (có thể bỏ comment để debug)
props.put("mail.debug", "true");
```

Sau đó chạy lại để xem log chi tiết.

## Các Port SMTP của Gmail

| Port | Protocol | Mô tả                                | Khuyến nghị         |
| ---- | -------- | ------------------------------------ | ------------------- |
| 587  | STARTTLS | Upgrade từ plain connection sang TLS | ⭐ Thử đầu tiên     |
| 465  | SSL/TLS  | Encrypted từ đầu                     | ⭐ Thử nếu 587 fail |
| 25   | Plain    | Không mã hóa                         | ❌ KHÔNG dùng       |

## Troubleshooting

### 1. Lỗi: "Could not convert socket to TLS"

**Nguyên nhân**:

- Chưa tạo App Password
- Port cấu hình sai
- Firewall block

**Giải pháp**:

1. Đảm bảo đã tạo App Password (không phải mật khẩu Gmail thường)
2. Thử đổi port từ 587 sang 465
3. Kiểm tra firewall

### 2. Lỗi: "Authentication failed"

**Nguyên nhân**:

- Email hoặc password sai
- Chưa bật 2-Step Verification

**Giải pháp**:

1. Xác nhận email đúng
2. Bật 2-Step Verification
3. Tạo lại App Password mới

### 3. Lỗi: "Connection timeout"

**Nguyên nhân**:

- Mạng không kết nối được SMTP server
- Firewall/Proxy block

**Giải pháp**:

1. Kiểm tra kết nối internet
2. Thử disable firewall/antivirus tạm thời
3. Kiểm tra proxy settings nếu ở công ty

### 4. Lỗi: "Username and Password not accepted"

**Nguyên nhân**:

- Đang dùng password Gmail thường thay vì App Password

**Giải pháp**:

1. ✅ PHẢI tạo và dùng App Password
2. ❌ KHÔNG dùng mật khẩu Gmail thường

## Kiểm Tra Nhanh

### Check 1: App Password

```
✓ Đã bật 2-Step Verification?
✓ Đã tạo App Password?
✓ Đã copy App Password đúng (16 ký tự)?
```

### Check 2: File .env

```
✓ File .env có trong thư mục gốc?
✓ EMAIL_FROM đúng địa chỉ Gmail?
✓ EMAIL_PASSWORD là App Password (không phải mật khẩu thường)?
✓ SMTP_PORT là 587 hoặc 465?
```

### Check 3: Code

```
✓ EmailSender được khởi tạo đúng?
✓ Không có exception khi init?
✓ Debug mode có hiển thị gì?
```

## Cấu Hình Nâng Cao

### Sử dụng nhiều email accounts

```java
// Account 1 - Gửi email booking
EmailSender bookingSender = new EmailSender(
    "booking@yourdomain.com",
    "app-password-1",
    "smtp.gmail.com",
    587
);

// Account 2 - Gửi email support
EmailSender supportSender = new EmailSender(
    "support@yourdomain.com",
    "app-password-2",
    "smtp.gmail.com",
    587
);
```

### Custom timeout

Trong `EmailSender.java`, điều chỉnh timeout:

```java
props.put("mail.smtp.connectiontimeout", "30000"); // 30 giây
props.put("mail.smtp.timeout", "30000");
props.put("mail.smtp.writetimeout", "30000");
```

## Gmail Limits

### Sending Limits

- **Free Gmail**: 500 emails/day
- **Google Workspace**: 2000 emails/day

### Best Practices

1. Không gửi quá 100 emails/giờ
2. Delay 1-2 giây giữa các email
3. Sử dụng batch processing cho nhiều emails
4. Monitor để tránh bị Gmail block

## Alternative Email Providers

Nếu Gmail không hoạt động, có thể dùng:

### 1. Outlook/Hotmail

```env
EMAIL_FROM=your-email@outlook.com
EMAIL_PASSWORD=your-password
SMTP_HOST=smtp-mail.outlook.com
SMTP_PORT=587
```

### 2. SendGrid (Professional)

```env
EMAIL_FROM=your-email@yourdomain.com
EMAIL_PASSWORD=sendgrid-api-key
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
```

### 3. AWS SES (Professional)

```env
EMAIL_FROM=your-email@yourdomain.com
EMAIL_PASSWORD=aws-smtp-password
SMTP_HOST=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
```

## Security Notes

1. ⚠️ **KHÔNG commit file .env** lên Git
2. ⚠️ **KHÔNG chia sẻ App Password**
3. ⚠️ **KHÔNG hardcode password** trong source code
4. ✅ Add `.env` vào `.gitignore`
5. ✅ Tạo file `.env.example` để hướng dẫn

### .gitignore

```
.env
*.env
.env.local
```

### .env.example

```env
# Gmail SMTP Configuration
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=your-16-digit-app-password
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
```

## Liên Hệ Support

Nếu vẫn gặp vấn đề sau khi thử tất cả các bước trên:

1. Enable debug mode và copy full log
2. Check file .env configuration
3. Verify App Password được tạo đúng
4. Test với email client khác (Thunderbird, Outlook) để đảm bảo credentials đúng

---

**Cập nhật**: Tháng 10/2025 - Gmail đã hoàn toàn tắt "Less secure app access", App Password là bắt buộc.
