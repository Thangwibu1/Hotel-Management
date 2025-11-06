# EmailSender.java - Hướng Dẫn Chi Tiết

## Tổng Quan

`EmailSender.java` là một class wrapper cho JavaMail API, cung cấp các method tiện ích để gửi email với nhiều tùy chọn khác nhau. Class này hỗ trợ:

- Email văn bản thuần (plain text)
- Email HTML
- Email với file đính kèm (attachments)
- Email gửi đến nhiều người nhận
- Email với CC và BCC
- Cấu hình SMTP linh hoạt (SSL và STARTTLS)

---

## Các Thuộc Tính (Instance Variables)

### 1. `fromEmail` (String)
```java
private final String fromEmail;
```
**Mục đích**: Email của người gửi  
**Ví dụ**: `"myhotel@gmail.com"`  
**Lưu ý**: Phải là email hợp lệ và được cấu hình SMTP

### 2. `appPassword` (String)
```java
private final String appPassword;
```
**Mục đích**: Mật khẩu ứng dụng (App Password) của email  
**Lưu ý**: 
- **KHÔNG phải** mật khẩu đăng nhập Gmail thông thường
- Là App Password được tạo từ Google Account Settings
- Định dạng: `"abcd efgh ijkl mnop"` (16 ký tự, có thể có khoảng trắng)

### 3. `smtpHost` (String)
```java
private final String smtpHost;
```
**Mục đích**: Địa chỉ SMTP server  
**Ví dụ**: 
- Gmail: `"smtp.gmail.com"`
- Outlook: `"smtp-mail.outlook.com"`
- Yahoo: `"smtp.mail.yahoo.com"`

### 4. `smtpPort` (int)
```java
private final int smtpPort;
```
**Mục đích**: Port của SMTP server  
**Các port phổ biến**:
- `587`: STARTTLS (recommended)
- `465`: SSL/TLS
- `25`: Non-encrypted (không nên dùng)

### 5. `session` (Session)
```java
private final Session session;
```
**Mục đích**: Mail session chứa cấu hình SMTP và authentication  
**Đặc điểm**: 
- Được tạo một lần trong constructor
- Được sử dụng cho tất cả các email gửi đi
- Immutable (không thay đổi sau khi tạo)

---

## Constructor 1: Default Constructor

### Full Code:
```java
public EmailSender() {
    // Load thông tin từ .env
    this.fromEmail = EnvConfig.getRequired("EMAIL_FROM");
    this.appPassword = EnvConfig.getRequired("EMAIL_PASSWORD");
    this.smtpHost = EnvConfig.get("SMTP_HOST", "smtp.gmail.com");
    this.smtpPort = EnvConfig.getInt("SMTP_PORT", 587);

    // Tạo session
    this.session = createSession();

    System.out.println("✓ EmailSender đã được khởi tạo thành công!");
    System.out.println("  From: " + fromEmail);
    System.out.println("  SMTP: " + smtpHost + ":" + smtpPort);
}
```

### Mục Đích:
Tạo EmailSender với cấu hình từ file `.env`

### Cách Hoạt Động Chi Tiết:

#### Bước 1: Load thông tin từ .env
```java
this.fromEmail = EnvConfig.getRequired("EMAIL_FROM");
this.appPassword = EnvConfig.getRequired("EMAIL_PASSWORD");
this.smtpHost = EnvConfig.get("SMTP_HOST", "smtp.gmail.com");
this.smtpPort = EnvConfig.getInt("SMTP_PORT", 587);
```

**Giải thích**:
- `getRequired()`: Email và password là **bắt buộc**, throw exception nếu thiếu
- `get()` với default: SMTP host và port có giá trị mặc định (Gmail)

#### Bước 2: Tạo session
```java
this.session = createSession();
```
Gọi method `createSession()` để khởi tạo Mail Session

#### Bước 3: In thông tin cấu hình
```java
System.out.println("✓ EmailSender đã được khởi tạo thành công!");
System.out.println("  From: " + fromEmail);
System.out.println("  SMTP: " + smtpHost + ":" + smtpPort);
```

### Ví Dụ Sử Dụng:
```java
// File .env:
// EMAIL_FROM=hotel@gmail.com
// EMAIL_PASSWORD=abcd efgh ijkl mnop

EmailSender sender = new EmailSender();
// Console output:
// ✓ EmailSender đã được khởi tạo thành công!
//   From: hotel@gmail.com
//   SMTP: smtp.gmail.com:587
```

### Khi Nào Dùng?
- **Production**: Luôn dùng constructor này
- Cấu hình từ file `.env` an toàn và dễ quản lý

---

## Constructor 2: Custom Constructor

### Full Code:
```java
public EmailSender(String fromEmail, String appPassword, String smtpHost, int smtpPort) {
    this.fromEmail = fromEmail;
    this.appPassword = appPassword;
    this.smtpHost = smtpHost;
    this.smtpPort = smtpPort;
    this.session = createSession();
}
```

### Mục Đích:
Tạo EmailSender với cấu hình tùy chỉnh (không dùng file `.env`)

### Tham Số:
- `fromEmail`: Email người gửi
- `appPassword`: App password
- `smtpHost`: SMTP server
- `smtpPort`: SMTP port

### Ví Dụ Sử Dụng:
```java
EmailSender sender = new EmailSender(
    "test@gmail.com",
    "abcd efgh ijkl mnop",
    "smtp.gmail.com",
    587
);
```

### Khi Nào Dùng?
- **Testing**: Khi muốn test với email khác
- **Multi-tenant**: Khi có nhiều email account khác nhau
- **Dynamic configuration**: Khi config được load từ database

---

## Method `createSession()` - Tạo Mail Session

### Full Code:
```java
private Session createSession() {
    Properties props = new Properties();
    props.put("mail.smtp.host", smtpHost);
    props.put("mail.smtp.port", String.valueOf(smtpPort));
    props.put("mail.smtp.auth", "true");
    
    // Nếu port 465, dùng SSL, nếu port 587 dùng STARTTLS
    if (smtpPort == 465) {
        // SSL Mode (Port 465)
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        props.put("mail.smtp.ssl.trust", smtpHost);
    } else {
        // STARTTLS Mode (Port 587)
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        props.put("mail.smtp.ssl.trust", smtpHost);
    }
    
    // Timeout settings
    props.put("mail.smtp.connectiontimeout", "10000");
    props.put("mail.smtp.timeout", "10000");
    props.put("mail.smtp.writetimeout", "10000");
    
    // Debug mode (có thể bỏ comment để debug)
    // props.put("mail.debug", "true");

    return Session.getInstance(props, new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(fromEmail, appPassword);
        }
    });
}
```

### Mục Đích:
Tạo và cấu hình JavaMail Session với authentication và security settings

### Cách Hoạt Động Chi Tiết:

#### Bước 1: Tạo Properties object
```java
Properties props = new Properties();
```

#### Bước 2: Cấu hình SMTP cơ bản
```java
props.put("mail.smtp.host", smtpHost);
props.put("mail.smtp.port", String.valueOf(smtpPort));
props.put("mail.smtp.auth", "true");
```

**Giải thích**:
- `mail.smtp.host`: Địa chỉ SMTP server
- `mail.smtp.port`: Port number (phải là String)
- `mail.smtp.auth`: Bật authentication (đăng nhập)

#### Bước 3: Cấu hình SSL hoặc STARTTLS

##### Nếu Port 465 (SSL Mode):
```java
if (smtpPort == 465) {
    props.put("mail.smtp.ssl.enable", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
    props.put("mail.smtp.ssl.trust", smtpHost);
}
```

**Giải thích**:
- `ssl.enable`: Bật SSL encryption ngay từ đầu
- `ssl.protocols`: Chỉ dùng TLS version 1.2 và 1.3 (an toàn hơn)
- `ssl.trust`: Trust SMTP server (bỏ qua certificate validation)

**Luồng kết nối**:
```
Client → [SSL Connection] → SMTP Server (Port 465)
         ↑ Encrypted từ đầu
```

##### Nếu Port 587 (STARTTLS Mode):
```java
else {
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.starttls.required", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
    props.put("mail.smtp.ssl.trust", smtpHost);
}
```

**Giải thích**:
- `starttls.enable`: Bật STARTTLS
- `starttls.required`: Bắt buộc phải dùng STARTTLS (fail nếu không support)
- `ssl.protocols`: TLS versions được phép
- `ssl.trust`: Trust server

**Luồng kết nối**:
```
Client → [Plain Connection] → SMTP Server (Port 587)
              ↓
         [STARTTLS Command]
              ↓
         [Upgrade to TLS]
              ↓
         [Encrypted Connection]
```

#### Bước 4: Cấu hình Timeout
```java
props.put("mail.smtp.connectiontimeout", "10000");
props.put("mail.smtp.timeout", "10000");
props.put("mail.smtp.writetimeout", "10000");
```

**Giải thích**:
- `connectiontimeout`: Timeout khi kết nối đến server (10 giây)
- `timeout`: Timeout khi đọc response từ server (10 giây)
- `writetimeout`: Timeout khi gửi dữ liệu đến server (10 giây)

**Tại sao cần timeout?**
- Tránh application bị "treo" nếu SMTP server chậm/down
- User experience tốt hơn (không chờ vô hạn)

#### Bước 5: Tạo Session với Authenticator
```java
return Session.getInstance(props, new Authenticator() {
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(fromEmail, appPassword);
    }
});
```

**Giải thích**:
- `Session.getInstance()`: Tạo mail session mới
- `Authenticator`: Anonymous class để cung cấp credentials
- `getPasswordAuthentication()`: Được gọi khi SMTP server yêu cầu đăng nhập
- `PasswordAuthentication`: Object chứa username (email) và password

### So Sánh SSL vs STARTTLS:

| Đặc điểm | SSL (Port 465) | STARTTLS (Port 587) |
|----------|----------------|---------------------|
| Encryption timing | Ngay từ đầu | Sau khi kết nối |
| Security | Tốt | Tốt (nếu required=true) |
| Compatibility | Cũ hơn | Mới hơn, được khuyến nghị |
| Gmail support | ✅ | ✅ (recommended) |

---

## Method `sendTextEmail()` - Gửi Email Văn Bản

### Full Code:
```java
public boolean sendTextEmail(String toEmail, String subject, String body) {
    try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setText(body);

        Transport.send(message);
        System.out.println("✓ Email đã được gửi thành công đến: " + toEmail);
        return true;

    } catch (MessagingException e) {
        System.err.println("✗ Lỗi khi gửi email: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
```

### Mục Đích:
Gửi email văn bản thuần (plain text) đơn giản

### Tham Số:
- `toEmail`: Email người nhận (ví dụ: `"guest@example.com"`)
- `subject`: Tiêu đề email (ví dụ: `"Booking Confirmation"`)
- `body`: Nội dung email (plain text)

### Giá Trị Trả Về:
- `true`: Gửi thành công
- `false`: Gửi thất bại

### Cách Hoạt Động Chi Tiết:

#### Bước 1: Tạo Message object
```java
Message message = new MimeMessage(session);
```
- `MimeMessage`: Implementation của Message interface
- Sử dụng `session` đã được config

#### Bước 2: Set thông tin người gửi
```java
message.setFrom(new InternetAddress(fromEmail));
```
- `InternetAddress`: Đại diện cho email address
- Parse và validate email format

#### Bước 3: Set người nhận
```java
message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
```

**Giải thích**:
- `RecipientType.TO`: Người nhận chính
- `InternetAddress.parse()`: Parse string thành array InternetAddress
  - Hỗ trợ single email: `"user@example.com"`
  - Hỗ trợ multiple emails: `"user1@example.com, user2@example.com"`

#### Bước 4: Set subject và body
```java
message.setSubject(subject);
message.setText(body);
```
- `setSubject()`: Tiêu đề email
- `setText()`: Nội dung plain text

#### Bước 5: Gửi email
```java
Transport.send(message);
```

**Luồng gửi email**:
```
1. Kết nối đến SMTP server
2. Authenticate (login)
3. Gửi MAIL FROM command
4. Gửi RCPT TO command
5. Gửi DATA command
6. Gửi nội dung email
7. Đóng kết nối
```

#### Bước 6: Handle thành công
```java
System.out.println("✓ Email đã được gửi thành công đến: " + toEmail);
return true;
```

#### Bước 7: Handle lỗi
```java
catch (MessagingException e) {
    System.err.println("✗ Lỗi khi gửi email: " + e.getMessage());
    e.printStackTrace();
    return false;
}
```

### Ví Dụ Sử Dụng:
```java
EmailSender sender = new EmailSender();

boolean success = sender.sendTextEmail(
    "guest@example.com",
    "Booking Confirmation",
    "Dear Guest,\n\nYour booking has been confirmed.\n\nThank you!"
);

if (success) {
    System.out.println("Email sent!");
} else {
    System.out.println("Failed to send email");
}
```

### Khi Nào Dùng?
- Email thông báo đơn giản
- Không cần formatting
- Không cần hình ảnh/link

---

## Method `sendHtmlEmail()` - Gửi Email HTML

### Full Code:
```java
public boolean sendHtmlEmail(String toEmail, String subject, String htmlBody) {
    try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlBody, "text/html; charset=utf-8");

        Transport.send(message);
        System.out.println("✓ Email HTML đã được gửi thành công đến: " + toEmail);
        return true;

    } catch (MessagingException e) {
        System.err.println("✗ Lỗi khi gửi email HTML: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
```

### Mục Đích:
Gửi email với nội dung HTML (có formatting, màu sắc, link, hình ảnh)

### Tham Số:
- `toEmail`: Email người nhận
- `subject`: Tiêu đề email
- `htmlBody`: Nội dung HTML (String chứa HTML code)

### Giá Trị Trả Về:
- `true`: Gửi thành công
- `false`: Gửi thất bại

### Cách Hoạt Động Chi Tiết:

Tương tự `sendTextEmail()` nhưng khác ở:

#### Set content type
```java
message.setContent(htmlBody, "text/html; charset=utf-8");
```

**Giải thích**:
- `setContent()`: Thay vì `setText()`
- `"text/html"`: Chỉ định content type là HTML
- `charset=utf-8`: Hỗ trợ Unicode (tiếng Việt, emoji, etc.)

### Ví Dụ Sử Dụng:

```java
String htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; }
            .header { background-color: #4CAF50; color: white; padding: 20px; }
            .content { padding: 20px; }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Booking Confirmation</h1>
        </div>
        <div class="content">
            <p>Dear <strong>Guest</strong>,</p>
            <p>Your booking has been confirmed.</p>
            <p>Booking ID: <strong>#12345</strong></p>
            <a href="https://hotel.com/booking/12345">View Booking Details</a>
        </div>
    </body>
    </html>
""";

EmailSender sender = new EmailSender();
sender.sendHtmlEmail(
    "guest@example.com",
    "Booking Confirmation",
    htmlContent
);
```

### Output Email:
![HTML Email Example - với header màu xanh, text có format, link có thể click]

### Khi Nào Dùng?
- Booking confirmations (có styling đẹp)
- Marketing emails
- Newsletters
- Emails với logo, images, buttons

### Lưu Ý:
- Test trên nhiều email clients (Gmail, Outlook, Yahoo)
- Một số CSS không hoạt động trong email
- Inline CSS tốt hơn external CSS
- Luôn có fallback text version

---

## Method `sendEmailWithAttachment()` - Gửi Email Với File Đính Kèm

### Full Code:
```java
public boolean sendEmailWithAttachment(String toEmail, String subject, String body, String filePath) {
    try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);

        // Tạo phần nội dung
        BodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setText(body);

        // Tạo multipart
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);

        // Thêm file đính kèm
        messageBodyPart = new MimeBodyPart();
        File file = new File(filePath);
        if (!file.exists()) {
            System.err.println("✗ File không tồn tại: " + filePath);
            return false;
        }
        ((MimeBodyPart) messageBodyPart).attachFile(file);
        multipart.addBodyPart(messageBodyPart);

        message.setContent(multipart);

        Transport.send(message);
        System.out.println("✓ Email với file đính kèm đã được gửi thành công đến: " + toEmail);
        return true;

    } catch (Exception e) {
        System.err.println("✗ Lỗi khi gửi email với file đính kèm: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
```

### Mục Đích:
Gửi email với một file đính kèm

### Tham Số:
- `toEmail`: Email người nhận
- `subject`: Tiêu đề email
- `body`: Nội dung email
- `filePath`: Đường dẫn đến file cần đính kèm

### Giá Trị Trả Về:
- `true`: Gửi thành công
- `false`: Gửi thất bại (hoặc file không tồn tại)

### Cách Hoạt Động Chi Tiết:

#### Bước 1-3: Giống sendTextEmail()
```java
Message message = new MimeMessage(session);
message.setFrom(new InternetAddress(fromEmail));
message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
message.setSubject(subject);
```

#### Bước 4: Tạo phần nội dung text
```java
BodyPart messageBodyPart = new MimeBodyPart();
messageBodyPart.setText(body);
```

**Giải thích**:
- `BodyPart`: Một phần của email multipart
- `MimeBodyPart`: Implementation của BodyPart
- Phần này chứa text message

#### Bước 5: Tạo Multipart container
```java
Multipart multipart = new MimeMultipart();
multipart.addBodyPart(messageBodyPart);
```

**Giải thích**:
- `Multipart`: Container chứa nhiều parts (text + attachments)
- `MimeMultipart`: Implementation
- Add text part vào multipart

**Cấu trúc email**:
```
Email
├── Part 1: Text body
└── Part 2: File attachment (sẽ thêm sau)
```

#### Bước 6: Kiểm tra file tồn tại
```java
messageBodyPart = new MimeBodyPart();
File file = new File(filePath);
if (!file.exists()) {
    System.err.println("✗ File không tồn tại: " + filePath);
    return false;
}
```

**Tại sao cần kiểm tra?**
- Tránh exception khi attach file không tồn tại
- Return sớm để không waste resources

#### Bước 7: Attach file
```java
((MimeBodyPart) messageBodyPart).attachFile(file);
multipart.addBodyPart(messageBodyPart);
```

**Giải thích**:
- `attachFile()`: Method của MimeBodyPart để attach file
- Tự động detect MIME type của file
- Add attachment part vào multipart

**Cấu trúc email hoàn chỉnh**:
```
Email
├── Part 1: Text body ("Your invoice is attached")
└── Part 2: invoice.pdf (attachment)
```

#### Bước 8: Set content và gửi
```java
message.setContent(multipart);
Transport.send(message);
```

### Ví Dụ Sử Dụng:

```java
EmailSender sender = new EmailSender();

// Gửi invoice PDF
boolean success = sender.sendEmailWithAttachment(
    "customer@example.com",
    "Your Invoice",
    "Dear Customer,\n\nPlease find your invoice attached.\n\nThank you!",
    "C:/invoices/invoice_12345.pdf"
);

if (success) {
    System.out.println("Invoice sent successfully!");
}
```

### Các Loại File Có Thể Attach:
- **PDF**: Invoices, contracts, receipts
- **Images**: JPG, PNG
- **Documents**: DOCX, XLSX, TXT
- **Archives**: ZIP, RAR

### Giới Hạn:
- **File size**: Thường 25MB (Gmail), 20MB (Outlook)
- **Security**: Một số file types bị block (.exe, .bat, .vbs)

### Khi Nào Dùng?
- Gửi invoice
- Gửi booking confirmation PDF
- Gửi contracts
- Gửi receipts

---

## Method `sendEmailWithMultipleAttachments()` - Gửi Email Với Nhiều File

### Full Code:
```java
public boolean sendEmailWithMultipleAttachments(String toEmail, String subject, String body, List<String> filePaths) {
    try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);

        // Tạo phần nội dung
        BodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setText(body);

        // Tạo multipart
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);

        // Thêm các file đính kèm
        for (String filePath : filePaths) {
            File file = new File(filePath);
            if (!file.exists()) {
                System.err.println("⚠ Cảnh báo: File không tồn tại, bỏ qua: " + filePath);
                continue;
            }
            messageBodyPart = new MimeBodyPart();
            ((MimeBodyPart) messageBodyPart).attachFile(file);
            multipart.addBodyPart(messageBodyPart);
        }

        message.setContent(multipart);

        Transport.send(message);
        System.out.println("✓ Email với nhiều file đính kèm đã được gửi thành công đến: " + toEmail);
        return true;

    } catch (Exception e) {
        System.err.println("✗ Lỗi khi gửi email với nhiều file đính kèm: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
```

### Mục Đích:
Gửi email với nhiều files đính kèm

### Tham Số:
- `toEmail`: Email người nhận
- `subject`: Tiêu đề email
- `body`: Nội dung email
- `filePaths`: **List** các đường dẫn files

### Giá Trị Trả Về:
- `true`: Gửi thành công
- `false`: Gửi thất bại

### Cách Hoạt Động Chi Tiết:

Tương tự `sendEmailWithAttachment()` nhưng có loop để attach nhiều files:

#### Loop qua từng file
```java
for (String filePath : filePaths) {
    File file = new File(filePath);
    if (!file.exists()) {
        System.err.println("⚠ Cảnh báo: File không tồn tại, bỏ qua: " + filePath);
        continue; // Bỏ qua file này, tiếp tục với file tiếp theo
    }
    messageBodyPart = new MimeBodyPart();
    ((MimeBodyPart) messageBodyPart).attachFile(file);
    multipart.addBodyPart(messageBodyPart);
}
```

**Giải thích**:
- Loop qua từng file path trong list
- Kiểm tra file có tồn tại không
- Nếu không tồn tại: **Warning** + `continue` (không fail toàn bộ email)
- Nếu tồn tại: Attach file

**Cấu trúc email**:
```
Email
├── Part 1: Text body
├── Part 2: invoice.pdf
├── Part 3: receipt.pdf
└── Part 4: contract.pdf
```

### Ví Dụ Sử Dụng:

```java
EmailSender sender = new EmailSender();

List<String> files = Arrays.asList(
    "C:/documents/invoice.pdf",
    "C:/documents/receipt.pdf",
    "C:/documents/contract.pdf"
);

boolean success = sender.sendEmailWithMultipleAttachments(
    "customer@example.com",
    "Your Documents",
    "Dear Customer,\n\nPlease find all your documents attached.\n\nThank you!",
    files
);
```

### Khi Nào Dùng?
- Gửi invoice + receipt + contract cùng lúc
- Gửi nhiều hình ảnh
- Gửi complete document package

### Lưu Ý:
- Tổng file size không vượt quá giới hạn email provider
- Có thể slow nếu files lớn
- Consider using file sharing service nếu files quá lớn

---

## Method `sendEmailToMultipleRecipients()` - Gửi Email Đến Nhiều Người

### Full Code:
```java
public boolean sendEmailToMultipleRecipients(List<String> toEmails, String subject, String body) {
    try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));

        // Tạo danh sách địa chỉ người nhận
        InternetAddress[] addresses = new InternetAddress[toEmails.size()];
        for (int i = 0; i < toEmails.size(); i++) {
            addresses[i] = new InternetAddress(toEmails.get(i));
        }
        message.setRecipients(Message.RecipientType.TO, addresses);

        message.setSubject(subject);
        message.setText(body);

        Transport.send(message);
        System.out.println("✓ Email đã được gửi thành công đến " + toEmails.size() + " người nhận");
        return true;

    } catch (MessagingException e) {
        System.err.println("✗ Lỗi khi gửi email đến nhiều người nhận: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
```

### Mục Đích:
Gửi email đến nhiều người nhận cùng lúc

### Tham Số:
- `toEmails`: **List** các email addresses
- `subject`: Tiêu đề email
- `body`: Nội dung email

### Giá Trị Trả Về:
- `true`: Gửi thành công
- `false`: Gửi thất bại

### Cách Hoạt Động Chi Tiết:

#### Tạo array InternetAddress
```java
InternetAddress[] addresses = new InternetAddress[toEmails.size()];
for (int i = 0; i < toEmails.size(); i++) {
    addresses[i] = new InternetAddress(toEmails.get(i));
}
```

**Giải thích**:
- Convert List<String> thành array InternetAddress[]
- Mỗi email string được parse thành InternetAddress object

#### Set recipients
```java
message.setRecipients(Message.RecipientType.TO, addresses);
```

**Tất cả người nhận đều thấy nhau** (giống như TO trong email thông thường)

### Ví Dụ Sử Dụng:

```java
EmailSender sender = new EmailSender();

List<String> recipients = Arrays.asList(
    "manager@hotel.com",
    "receptionist@hotel.com",
    "accounting@hotel.com"
);

sender.sendEmailToMultipleRecipients(
    recipients,
    "Daily Report",
    "Dear Team,\n\nHere is today's report...\n\nBest regards"
);
```

### Email nhận được:
```
To: manager@hotel.com, receptionist@hotel.com, accounting@hotel.com
Subject: Daily Report
Body: Dear Team...
```

### Khi Nào Dùng?
- Team notifications
- Group announcements
- Broadcast messages

### Lưu Ý về Privacy:
- Tất cả recipients đều **thấy email của nhau**
- Nếu muốn ẩn danh → Dùng BCC (method tiếp theo)

---

## Method `sendEmailWithCcBcc()` - Gửi Email Với CC và BCC

### Full Code:
```java
public boolean sendEmailWithCcBcc(String toEmail, List<String> ccEmails, List<String> bccEmails,
                                  String subject, String body) {
    try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

        // Thêm CC
        if (ccEmails != null && !ccEmails.isEmpty()) {
            InternetAddress[] ccAddresses = new InternetAddress[ccEmails.size()];
            for (int i = 0; i < ccEmails.size(); i++) {
                ccAddresses[i] = new InternetAddress(ccEmails.get(i));
            }
            message.setRecipients(Message.RecipientType.CC, ccAddresses);
        }

        // Thêm BCC
        if (bccEmails != null && !bccEmails.isEmpty()) {
            InternetAddress[] bccAddresses = new InternetAddress[bccEmails.size()];
            for (int i = 0; i < bccEmails.size(); i++) {
                bccAddresses[i] = new InternetAddress(bccEmails.get(i));
            }
            message.setRecipients(Message.RecipientType.BCC, bccAddresses);
        }

        message.setSubject(subject);
        message.setText(body);

        Transport.send(message);
        System.out.println("✓ Email với CC/BCC đã được gửi thành công");
        return true;

    } catch (MessagingException e) {
        System.err.println("✗ Lỗi khi gửi email với CC/BCC: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
```

### Mục Đích:
Gửi email với đầy đủ options: TO, CC, BCC

### Tham Số:
- `toEmail`: Email người nhận chính
- `ccEmails`: List email CC (Carbon Copy) - có thể null
- `bccEmails`: List email BCC (Blind Carbon Copy) - có thể null
- `subject`: Tiêu đề email
- `body`: Nội dung email

### Giá Trị Trả Về:
- `true`: Gửi thành công
- `false`: Gửi thất bại

### Cách Hoạt Động Chi Tiết:

#### Bước 1: Set TO recipient
```java
message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
```

#### Bước 2: Add CC nếu có
```java
if (ccEmails != null && !ccEmails.isEmpty()) {
    InternetAddress[] ccAddresses = new InternetAddress[ccEmails.size()];
    for (int i = 0; i < ccEmails.size(); i++) {
        ccAddresses[i] = new InternetAddress(ccEmails.get(i));
    }
    message.setRecipients(Message.RecipientType.CC, ccAddresses);
}
```

**Giải thích**:
- Kiểm tra null và empty để tránh NullPointerException
- Convert list thành array
- Set recipient type là CC

#### Bước 3: Add BCC nếu có
```java
if (bccEmails != null && !bccEmails.isEmpty()) {
    InternetAddress[] bccAddresses = new InternetAddress[bccEmails.size()];
    for (int i = 0; i < bccEmails.size(); i++) {
        bccAddresses[i] = new InternetAddress(bccEmails.get(i));
    }
    message.setRecipients(Message.RecipientType.BCC, bccAddresses);
}
```

### So Sánh TO vs CC vs BCC:

| Type | Visibility | Use Case |
|------|-----------|----------|
| **TO** | Tất cả đều thấy | Người nhận chính |
| **CC** | Tất cả đều thấy | Người cần biết (FYI) |
| **BCC** | Chỉ mình họ thấy email của họ | Privacy, mass email |

### Ví Dụ Sử Dụng:

```java
EmailSender sender = new EmailSender();

List<String> cc = Arrays.asList("manager@hotel.com");
List<String> bcc = Arrays.asList("archive@hotel.com", "backup@hotel.com");

sender.sendEmailWithCcBcc(
    "guest@example.com",              // TO: người nhận chính
    cc,                                 // CC: manager để biết
    bcc,                                // BCC: archive để lưu (không ai biết)
    "Booking Confirmation",
    "Dear Guest, your booking is confirmed..."
);
```

### Email nhận được:

#### Guest nhìn thấy:
```
To: guest@example.com
CC: manager@hotel.com
Subject: Booking Confirmation
```

#### Manager nhìn thấy:
```
To: guest@example.com
CC: manager@hotel.com
Subject: Booking Confirmation
```

#### Archive nhìn thấy:
```
To: guest@example.com
CC: manager@hotel.com
Subject: Booking Confirmation
```

**Lưu ý**: Không ai biết archive@hotel.com cũng nhận email!

### Khi Nào Dùng?

#### CC:
- Manager cần biết về transaction
- Team members cần FYI
- Transparency

#### BCC:
- Mass email (newsletter) mà muốn privacy
- Archive/backup emails
- Không muốn recipients biết nhau

---

## Tóm Tắt Workflow Gửi Email

### 1. Basic Text Email:
```
EmailSender Constructor
    ↓
Load config from .env
    ↓
Create SMTP Session
    ↓
Create Message
    ↓
Set FROM, TO, SUBJECT, BODY
    ↓
Transport.send()
    ↓
Email sent!
```

### 2. Email With Attachment:
```
Create Message
    ↓
Create Multipart container
    ↓
Add text body part
    ↓
Add attachment part(s)
    ↓
Set message content = multipart
    ↓
Send
```

### 3. Email With Multiple Recipients:
```
Create Message
    ↓
Parse multiple email addresses
    ↓
Set recipients (TO/CC/BCC)
    ↓
Set subject and body
    ↓
Send (all recipients receive same email)
```

---

## SMTP Connection Flow

### Port 587 (STARTTLS):
```
1. Client connects to server:587
2. Server: "220 smtp.gmail.com ESMTP ready"
3. Client: "EHLO"
4. Server: "250 STARTTLS available"
5. Client: "STARTTLS"
6. [Upgrade to TLS encryption]
7. Client sends username/password
8. Server: "235 Authentication successful"
9. Client sends email
10. Server: "250 OK"
11. Close connection
```

### Port 465 (SSL):
```
1. [SSL handshake immediately]
2. Client connects via SSL to server:465
3. Server: "220 smtp.gmail.com ESMTP ready"
4. [All communication encrypted from start]
5. Authentication
6. Send email
7. Close connection
```

---

## Error Handling

### Common Errors:

#### 1. AuthenticationFailedException
```
Nguyên nhân:
- Email hoặc password sai
- Chưa bật App Password
- Chưa bật "Less secure app access" (old Gmail)

Giải pháp:
- Kiểm tra EMAIL_FROM và EMAIL_PASSWORD trong .env
- Tạo App Password từ Google Account
```

#### 2. MessagingException: Could not connect
```
Nguyên nhân:
- SMTP_HOST hoặc SMTP_PORT sai
- Firewall block
- No internet connection

Giải pháp:
- Kiểm tra SMTP_HOST và SMTP_PORT
- Test với telnet smtp.gmail.com 587
- Kiểm tra firewall/antivirus
```

#### 3. SendFailedException
```
Nguyên nhân:
- Email người nhận không hợp lệ
- Email bị reject bởi recipient server

Giải pháp:
- Validate email format trước khi gửi
- Kiểm tra email có tồn tại không
```

#### 4. File not found (Attachment)
```
Nguyên nhân:
- File path sai
- File bị xóa

Giải pháp:
- Kiểm tra file.exists() trước khi attach
- Dùng absolute path
```

---

## Best Practices

### 1. **Luôn Dùng Try-Catch**
```java
// GOOD
try {
    sender.sendTextEmail(...);
} catch (Exception e) {
    logger.error("Failed to send email", e);
    // Handle error gracefully
}
```

### 2. **Validate Email Format**
```java
// GOOD
if (email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
    sender.sendTextEmail(email, ...);
}
```

### 3. **Check File Size Before Attach**
```java
// GOOD
File file = new File(filePath);
if (file.length() > 25 * 1024 * 1024) { // 25MB
    System.out.println("File too large!");
    return false;
}
```

### 4. **Use HTML Email for Better UX**
```java
// GOOD - Professional looking
sender.sendHtmlEmail(email, subject, htmlContent);

// BAD - Plain and boring
sender.sendTextEmail(email, subject, plainText);
```

### 5. **Use BCC for Privacy**
```java
// GOOD - Recipients don't see each other
sender.sendEmailWithCcBcc(
    "noreply@hotel.com",  // TO: dummy
    null,                  // CC: none
    recipientList,         // BCC: all recipients
    subject,
    body
);
```

---

## Testing

### Test Email Sending:
```java
public static void main(String[] args) {
    EmailSender sender = new EmailSender();
    
    // Test 1: Simple text email
    boolean success1 = sender.sendTextEmail(
        "your-email@gmail.com",
        "Test Email",
        "This is a test email."
    );
    System.out.println("Test 1: " + (success1 ? "PASS" : "FAIL"));
    
    // Test 2: HTML email
    String html = "<h1>Test</h1><p>This is <strong>HTML</strong> email</p>";
    boolean success2 = sender.sendHtmlEmail(
        "your-email@gmail.com",
        "HTML Test",
        html
    );
    System.out.println("Test 2: " + (success2 ? "PASS" : "FAIL"));
}
```

---

## Performance Tips

### 1. **Reuse EmailSender Instance**
```java
// GOOD - Tạo một lần, dùng nhiều lần
EmailSender sender = new EmailSender();
for (String email : recipients) {
    sender.sendTextEmail(email, subject, body);
}

// BAD - Tạo mới mỗi lần (chậm)
for (String email : recipients) {
    new EmailSender().sendTextEmail(email, subject, body);
}
```

### 2. **Send Async**
```java
// GOOD - Không block main thread
CompletableFuture.runAsync(() -> {
    sender.sendTextEmail(email, subject, body);
});
```

### 3. **Batch Sending**
```java
// GOOD - Gửi một email đến nhiều người
sender.sendEmailToMultipleRecipients(recipients, subject, body);

// BAD - Gửi nhiều email riêng lẻ
for (String email : recipients) {
    sender.sendTextEmail(email, subject, body);
}
```

---

## Security Considerations

### 1. **Never Hardcode Credentials**
```java
// BAD
String email = "myemail@gmail.com";
String password = "mypassword123";

// GOOD
String email = EnvConfig.getRequired("EMAIL_FROM");
String password = EnvConfig.getRequired("EMAIL_PASSWORD");
```

### 2. **Use App Password, Not Real Password**
- Tạo App Password từ Google Account
- App Password có thể revoke bất kỳ lúc nào
- Không ảnh hưởng đến main account

### 3. **Validate User Input**
```java
// Prevent email injection
if (email.contains("\n") || email.contains("\r")) {
    throw new IllegalArgumentException("Invalid email");
}
```

### 4. **Rate Limiting**
```java
// Tránh spam
if (emailsSentToday > 500) {
    throw new RuntimeException("Daily limit exceeded");
}
```

---

## Kết Luận

`EmailSender.java` cung cấp một interface đơn giản nhưng mạnh mẽ để gửi email:

✅ **Hỗ trợ đầy đủ các loại email**: Text, HTML, attachments  
✅ **Security**: SSL, STARTTLS, App Password support  
✅ **Flexibility**: TO, CC, BCC, multiple recipients  
✅ **Error handling**: Try-catch, validation  
✅ **Easy configuration**: Load from .env file  
✅ **Production-ready**: Timeout, proper MIME handling  

Sử dụng class này giúp việc gửi email trong Java application trở nên dễ dàng và professional!

