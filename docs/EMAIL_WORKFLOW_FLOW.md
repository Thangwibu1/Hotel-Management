# 📧 Luồng Hoạt Động - Hệ Thống Gửi Email Xác Nhận Booking

## 🎯 Tổng Quan

Document này mô tả chi tiết luồng hoạt động của chức năng gửi email xác nhận booking trong Hotel Management System, từ khi nhận request đặt phòng cho đến khi email được gửi đến khách hàng.

---

## 📊 Sơ Đồ Luồng Tổng Thể

```
┌─────────────────┐
│  Client Request │
│  (Đặt phòng)    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ BookingController       │
│ doPost()                │
└────────┬────────────────┘
         │
         ├─── 1. Parse Request Parameters
         │
         ├─── 2. Create Booking
         │
         ├─── 3. Add Services
         │
         ├─── 4. Create Payment
         │
         ├─── 5. Get Guest Email
         │
         ├─── 6. Send Email (Async)
         │           │
         │           ▼
         │    ┌─────────────────────┐
         │    │ Email Thread        │
         │    │ (Background)        │
         │    └──────┬──────────────┘
         │           │
         │           ▼
         │    sendBookingConfirmationEmail()
         │           │
         │           ├─── Get Booking Info
         │           ├─── Get Guest Info
         │           ├─── Get Room Info
         │           ├─── Get Services
         │           ├─── Calculate Total
         │           ├─── Generate HTML
         │           └─── Send Email
         │                    │
         │                    ▼
         │            ┌───────────────┐
         │            │ EmailSender   │
         │            │ sendHtmlEmail()│
         │            └───────┬───────┘
         │                    │
         │                    ├─── Load .env Config
         │                    ├─── Create SMTP Session
         │                    ├─── Setup SSL/TLS
         │                    └─── Send via Gmail
         │                           │
         │                           ▼
         │                    ┌──────────────┐
         │                    │ Gmail SMTP   │
         │                    │ Server       │
         │                    └──────┬───────┘
         │                           │
         │                           ▼
         │                    ┌──────────────┐
         │                    │ Customer     │
         │                    │ Email Inbox  │
         │                    └──────────────┘
         │
         ▼
┌─────────────────────────┐
│ Redirect to Booking     │
│ Confirmation Page       │
└─────────────────────────┘
```

---

## 🔄 Chi Tiết Từng Bước

### **PHASE 1: Nhận Request và Xử Lý Booking**

#### Bước 1.1: Client gửi request đặt phòng

**Location**: `BookingController.doPost()`

**Request Parameters**:

```java
- roomId: ID phòng
- guestId: ID khách hàng
- checkInDate: Ngày nhận phòng (yyyy-MM-dd)
- checkOutDate: Ngày trả phòng (yyyy-MM-dd)
- bookingDate: Ngày đặt (yyyy-MM-dd)
- serviceId[]: Danh sách ID dịch vụ
- serviceQuantity[]: Số lượng từng dịch vụ
- serviceDate[]: Ngày sử dụng từng dịch vụ
- totalAmount: Tổng tiền
```

**Code**:

```java
String roomId = req.getParameter("roomId");
String guestId = req.getParameter("guestId");
String checkInDate = req.getParameter("checkInDate");
String checkOutDate = req.getParameter("checkOutDate");
String bookingDate = req.getParameter("bookingDate");
```

#### Bước 1.2: Parse và Convert dữ liệu

**Convert sang LocalDateTime**:

```java
LocalDate inDate = LocalDate.parse(checkInDate);
LocalDate outDate = LocalDate.parse(checkOutDate);
LocalDate bookDate = LocalDate.parse(bookingDate);

LocalDateTime inDateTime = inDate.atStartOfDay();          // 00:00:00
LocalDateTime outDateTime = outDate.atTime(23, 59, 59);    // 23:59:59
```

**Parse danh sách services**:

```java
ArrayList<ChoosenService> services = new ArrayList<>();
String[] serviceId = req.getParameterValues("serviceId");
String[] serviceQuantity = req.getParameterValues("serviceQuantity");
String[] serviceDate = req.getParameterValues("serviceDate");

for (int i = 0; i < serviceId.length; i++) {
    ChoosenService service = new ChoosenService(
        Integer.parseInt(serviceId[i]),
        Integer.parseInt(serviceQuantity[i]),
        LocalDate.parse(serviceDate[i])
    );
    services.add(service);
}
```

#### Bước 1.3: Tạo Booking mới

**Method**: `bookingHandle()`

```java
Booking newBooking = new Booking(
    guestId,      // ID khách hàng
    roomId,       // ID phòng
    inDateTime,   // Check-in datetime
    outDateTime,  // Check-out datetime
    bookDate,     // Ngày đặt
    "Reserved"    // Trạng thái
);

int newBookingId = bookingDAO.addBookingV2(newBooking);
```

**Database**: Insert vào bảng `BOOKING`

#### Bước 1.4: Thêm Services vào Booking

**Method**: `bookingServiceHandle()`

```java
for (ChoosenService service : services) {
    BookingService newBookingService = new BookingService(
        bookingId,              // ID booking vừa tạo
        service.getServiceId(), // ID service
        service.getQuantity(),  // Số lượng
        service.getServiceDate(), // Ngày sử dụng
        0                       // Status: pending
    );
    bookingServiceDAO.addBookingService(newBookingService);
}
```

**Database**: Insert vào bảng `BOOKING_SERVICE`

#### Bước 1.5: Tạo Payment (Cọc 50%)

```java
Payment newPayment = new Payment(
    newBookingId,                              // ID booking
    bookDate,                                  // Ngày thanh toán
    (double)(Integer.parseInt(totalAmount))/2.0, // 50% tổng tiền
    "cash",                                    // Phương thức
    "Pending"                                  // Trạng thái
);
paymentDAO.addPayment(newPayment);
```

**Database**: Insert vào bảng `PAYMENT`

#### Bước 1.6: Update Room Status

```java
roomDAO.updateRoomStatus(roomId, "Available");
```

**Database**: Update bảng `ROOM`

---

### **PHASE 2: Chuẩn Bị Gửi Email**

#### Bước 2.1: Lấy thông tin Guest

```java
Guest viewGuest = guestDAO.getGuestById(Integer.parseInt(guestId));
String recipientEmail = viewGuest.getEmail();
```

**Database Query**:

```sql
SELECT * FROM GUEST WHERE guestId = ?
```

**Data lấy được**:

- Full Name
- Email
- Phone
- Address
- ID Number

#### Bước 2.2: Validate Email

```java
if (recipientEmail != null && !recipientEmail.trim().isEmpty()) {
    // Proceed to send email
}
```

#### Bước 2.3: Khởi động Email Thread (Async)

**Tại sao dùng Thread riêng?**

- ✅ Không block response về client
- ✅ Cải thiện performance
- ✅ User không phải đợi email gửi xong

```java
final int finalBookingId = newBookingId;
final String finalEmail = recipientEmail;

new Thread(() -> {
    sendBookingConfirmationEmail(finalEmail, finalBookingId);
}).start();
```

---

### **PHASE 3: Thu Thập Dữ Liệu Email**

#### Bước 3.1: Method Entry

**Method**: `sendBookingConfirmationEmail(String recipientEmail, int bookingId)`

**Parameters**:

- `recipientEmail`: Email khách hàng
- `bookingId`: ID booking vừa tạo

#### Bước 3.2: Lấy thông tin Booking

```java
Booking booking = bookingDAO.getBookingById(bookingId);
```

**Database Query**:

```sql
SELECT * FROM BOOKING WHERE BookingID = ?
```

**Data lấy được**:

- Booking ID
- Guest ID
- Room ID
- Check-in DateTime
- Check-out DateTime
- Booking Date
- Status

#### Bước 3.3: Lấy thông tin Guest

```java
Guest guest = guestDAO.getGuestById(booking.getGuestId());
```

**Data lấy được**:

- Guest Name (để chào trong email)
- Email
- Phone

#### Bước 3.4: Lấy thông tin Room

```java
Room room = roomDAO.getRoomById(booking.getRoomId());
```

**Database Query**:

```sql
SELECT * FROM ROOM WHERE RoomID = ?
```

**Data lấy được**:

- Room Number (VD: "101", "202")
- Room Type ID
- Status
- Description

#### Bước 3.5: Lấy thông tin Room Type

```java
RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
```

**Database Query**:

```sql
SELECT * FROM ROOM_TYPE WHERE RoomTypeID = ?
```

**Data lấy được**:

- Type Name (VD: "Deluxe", "Suite")
- Capacity (Số người)
- Price Per Night (Giá/đêm)

#### Bước 3.6: Lấy danh sách Services

```java
List<BookingService> bookingServices =
    bookingServiceDAO.getBookingServiceByBookingId(bookingId);
```

**Database Query**:

```sql
SELECT * FROM BOOKING_SERVICE WHERE BookingID = ?
```

**Data lấy được** (cho mỗi service):

- Service ID
- Quantity (Số lượng)
- Service Date (Ngày sử dụng)

#### Bước 3.7: Lấy chi tiết từng Service

```java
for (BookingService bs : bookingServices) {
    Service service = serviceDAO.getServiceById(bs.getServiceId());
    // Process service...
}
```

**Database Query** (mỗi service):

```sql
SELECT * FROM SERVICE WHERE ServiceID = ?
```

**Data lấy được**:

- Service Name (VD: "Breakfast", "Spa")
- Service Type
- Price (Giá đơn vị)

---

### **PHASE 4: Tính Toán và Xử Lý Dữ Liệu**

#### Bước 4.1: Tính số đêm lưu trú

```java
long numberOfNights = ChronoUnit.DAYS.between(
    booking.getCheckInDate().toLocalDate(),
    booking.getCheckOutDate().toLocalDate()
);
```

**Ví dụ**:

- Check-in: 2025-10-27
- Check-out: 2025-10-30
- Number of nights: 3 đêm

#### Bước 4.2: Tính tổng tiền phòng

```java
BigDecimal roomTotal = roomType.getPricePerNight()
    .multiply(BigDecimal.valueOf(numberOfNights));
```

**Ví dụ**:

- Price/night: 1,000,000 VNĐ
- Number of nights: 3
- Room total: 3,000,000 VNĐ

#### Bước 4.3: Tính tổng tiền services

```java
BigDecimal servicesTotal = BigDecimal.ZERO;

for (BookingService bs : bookingServices) {
    Service service = serviceDAO.getServiceById(bs.getServiceId());

    BigDecimal serviceItemTotal = service.getPrice()
        .multiply(BigDecimal.valueOf(bs.getQuantity()));

    servicesTotal = servicesTotal.add(serviceItemTotal);
}
```

**Ví dụ**:

- Breakfast: 200,000 × 2 = 400,000 VNĐ
- Spa: 500,000 × 1 = 500,000 VNĐ
- Services total: 900,000 VNĐ

#### Bước 4.4: Tính tổng cộng

```java
BigDecimal grandTotal = roomTotal.add(servicesTotal);
```

**Ví dụ**:

- Room: 3,000,000 VNĐ
- Services: 900,000 VNĐ
- **Grand Total: 3,900,000 VNĐ**

#### Bước 4.5: Tính số tiền đã cọc và còn lại

```java
BigDecimal depositAmount = grandTotal.divide(BigDecimal.valueOf(2));
BigDecimal remainingAmount = depositAmount;
```

**Ví dụ**:

- Grand total: 3,900,000 VNĐ
- Deposit (50%): 1,950,000 VNĐ
- Remaining: 1,950,000 VNĐ

---

### **PHASE 5: Tạo Nội Dung Email HTML**

#### Bước 5.1: Setup DateTimeFormatter

```java
DateTimeFormatter dateFormatter =
    DateTimeFormatter.ofPattern("dd/MM/yyyy");
DateTimeFormatter dateTimeFormatter =
    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
```

#### Bước 5.2: Tạo HTML cho Services Table

```java
StringBuilder servicesHtml = new StringBuilder();

for (BookingService bs : bookingServices) {
    Service service = serviceDAO.getServiceById(bs.getServiceId());
    BigDecimal serviceItemTotal = service.getPrice()
        .multiply(BigDecimal.valueOf(bs.getQuantity()));

    servicesHtml.append(String.format(
        "<tr>" +
        "<td>%s</td>" +                    // Service name
        "<td>%d</td>" +                    // Quantity
        "<td>%s</td>" +                    // Service date
        "<td>%,d VNĐ</td>" +               // Unit price
        "<td>%,d VNĐ</td>" +               // Total
        "</tr>",
        service.getServiceName(),
        bs.getQuantity(),
        bs.getServiceDate().format(dateFormatter),
        service.getPrice().intValue(),
        serviceItemTotal.intValue()
    ));
}
```

#### Bước 5.3: Tạo HTML Email hoàn chỉnh

**Cấu trúc Email**:

1. **Header** (Gradient purple background)

   - Tiêu đề: "✓ Xác Nhận Đặt Phòng"
   - Mã booking: "#123"

2. **Greeting**

   - "Xin chào [Tên khách hàng]"

3. **Booking Information Section**

   - Mã đặt phòng
   - Ngày đặt
   - Trạng thái

4. **Room Information Section**

   - Số phòng
   - Loại phòng
   - Sức chứa
   - Giá/đêm

5. **Stay Duration Section**

   - Ngày nhận phòng
   - Ngày trả phòng
   - Số đêm

6. **Services Section** (nếu có)

   - Bảng chi tiết services
   - Tên, số lượng, ngày, giá

7. **Payment Details Section**

   - Tiền phòng
   - Tiền dịch vụ
   - Tổng cộng
   - Đã thanh toán (50%)
   - Còn lại

8. **Notes Section**

   - Lưu ý về giấy tờ
   - Giờ check-in/check-out
   - Thông tin liên hệ

9. **Footer**
   - Lời cảm ơn
   - Copyright

```java
String htmlContent = String.format(
    "<!DOCTYPE html>..." +
    "...[Full HTML template]..." +
    "</html>",
    // All parameters
    bookingId,
    guest.getFullName(),
    booking.getBookingDate().format(dateFormatter),
    // ... etc
);
```

---

### **PHASE 6: Gửi Email qua SMTP**

#### Bước 6.1: Khởi tạo EmailSender

```java
EmailSender emailSender = new EmailSender();
```

**Điều gì xảy ra khi khởi tạo?**

##### Step 6.1.1: Load Environment Configuration

```java
// EmailSender constructor
this.fromEmail = EnvConfig.getRequired("EMAIL_FROM");
this.appPassword = EnvConfig.getRequired("EMAIL_PASSWORD");
this.smtpHost = EnvConfig.get("SMTP_HOST", "smtp.gmail.com");
this.smtpPort = EnvConfig.getInt("SMTP_PORT", 587);
```

**EnvConfig.java** đọc từ file `.env`:

```
Hotel-Management/
└── src/main/resources/
    └── .env
```

**File .env content**:

```env
EMAIL_FROM=hotel@gmail.com
EMAIL_PASSWORD=abcdefghijklmnop
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
```

##### Step 6.1.2: Create SMTP Session

```java
Properties props = new Properties();
props.put("mail.smtp.host", smtpHost);           // smtp.gmail.com
props.put("mail.smtp.port", String.valueOf(smtpPort)); // 587
props.put("mail.smtp.auth", "true");

if (smtpPort == 465) {
    // SSL Mode
    props.put("mail.smtp.ssl.enable", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
} else {
    // STARTTLS Mode (port 587)
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.starttls.required", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
}

// Timeout settings
props.put("mail.smtp.connectiontimeout", "10000");
props.put("mail.smtp.timeout", "10000");
props.put("mail.smtp.writetimeout", "10000");
```

##### Step 6.1.3: Create Authenticated Session

```java
Session session = Session.getInstance(props, new Authenticator() {
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(fromEmail, appPassword);
    }
});
```

#### Bước 6.2: Gọi sendHtmlEmail()

```java
boolean result = emailSender.sendHtmlEmail(
    recipientEmail,  // Địa chỉ email khách hàng
    "Xác nhận đặt phòng #" + bookingId + " - Hotel Management System",
    htmlContent      // HTML đã generate
);
```

#### Bước 6.3: Tạo Email Message

```java
Message message = new MimeMessage(session);
message.setFrom(new InternetAddress(fromEmail));
message.setRecipients(
    Message.RecipientType.TO,
    InternetAddress.parse(recipientEmail)
);
message.setSubject(subject);
message.setContent(htmlContent, "text/html; charset=utf-8");
```

**Message structure**:

```
From: hotel@gmail.com
To: customer@example.com
Subject: Xác nhận đặt phòng #123 - Hotel Management System
Content-Type: text/html; charset=utf-8

[HTML Content]
```

#### Bước 6.4: Gửi qua SMTP Transport

```java
Transport.send(message);
```

**Điều gì xảy ra?**

1. **Connect to SMTP Server**

   ```
   Connecting to smtp.gmail.com:587...
   ```

2. **STARTTLS Handshake** (nếu port 587)

   ```
   220 smtp.gmail.com ESMTP
   EHLO localhost
   250-smtp.gmail.com
   STARTTLS
   220 Ready to start TLS
   ```

3. **SSL/TLS Negotiation**

   ```
   TLSv1.3 handshake
   Certificate verification
   Secure connection established
   ```

4. **Authentication**

   ```
   AUTH LOGIN
   Username: hotel@gmail.com (base64)
   Password: [App Password] (base64)
   235 Authentication successful
   ```

5. **Send Email**

   ```
   MAIL FROM:<hotel@gmail.com>
   RCPT TO:<customer@example.com>
   DATA
   [Email headers and body]
   .
   250 OK, message sent
   ```

6. **Close Connection**
   ```
   QUIT
   221 Bye
   ```

---

### **PHASE 7: Logging và Response**

#### Bước 7.1: Log kết quả gửi email

```java
if (result) {
    System.out.println("✓ Đã gửi email xác nhận booking #"
        + bookingId + " đến: " + recipientEmail);
} else {
    System.out.println("✗ Không thể gửi email");
}
```

**Console output**:

```
✓ EmailSender đã được khởi tạo thành công!
  From: hotel@gmail.com
  SMTP: smtp.gmail.com:587
✓ Email HTML đã được gửi thành công đến: customer@example.com
✓ Đã gửi email xác nhận booking #123 đến: customer@example.com
```

#### Bước 7.2: Return từ email thread

Email thread hoàn thành công việc (async, không block main thread)

#### Bước 7.3: Main thread redirect

```java
resp.sendRedirect("./viewBookingAfter?bookingId=" + newBookingId);
```

**User được chuyển đến trang xác nhận booking**

---

## ⏱️ Timeline Thực Tế

### Main Thread (User-facing)

```
T+0ms    : Nhận request đặt phòng
T+50ms   : Parse parameters
T+100ms  : Create booking (DB insert)
T+150ms  : Add services (DB inserts)
T+180ms  : Create payment (DB insert)
T+200ms  : Get guest info (DB query)
T+210ms  : Start email thread (async)
T+220ms  : Redirect to confirmation page ✅ USER SEES RESPONSE
```

### Email Thread (Background)

```
T+210ms  : Thread started
T+220ms  : Call sendBookingConfirmationEmail()
T+240ms  : Get booking (DB query)
T+260ms  : Get guest (DB query)
T+280ms  : Get room (DB query)
T+300ms  : Get room type (DB query)
T+320ms  : Get booking services (DB query)
T+340ms  : Get services details (DB queries)
T+360ms  : Calculate totals
T+380ms  : Generate HTML
T+400ms  : Initialize EmailSender
T+420ms  : Load .env config
T+440ms  : Create SMTP session
T+500ms  : Connect to SMTP server
T+600ms  : TLS handshake
T+700ms  : Authenticate
T+900ms  : Send email data
T+1200ms : Email sent ✅
T+1220ms : Log success
T+1230ms : Thread terminates
```

**Total user wait time**: ~220ms (chỉ đợi đến khi redirect)
**Total email process time**: ~1000ms (diễn ra ở background)

---

## 🗄️ Database Queries Summary

### Queries trong Main Thread (Create Booking)

1. `INSERT INTO BOOKING` - Tạo booking mới
2. `INSERT INTO BOOKING_SERVICE` - Thêm services (multiple)
3. `INSERT INTO PAYMENT` - Tạo payment
4. `UPDATE ROOM SET status = 'Available'` - Update room
5. `SELECT * FROM GUEST WHERE guestId = ?` - Get guest email

**Total: ~5-10 queries** (tùy số lượng services)

### Queries trong Email Thread

1. `SELECT * FROM BOOKING WHERE BookingID = ?`
2. `SELECT * FROM GUEST WHERE guestId = ?`
3. `SELECT * FROM ROOM WHERE RoomID = ?`
4. `SELECT * FROM ROOM_TYPE WHERE RoomTypeID = ?`
5. `SELECT * FROM BOOKING_SERVICE WHERE BookingID = ?`
6. `SELECT * FROM SERVICE WHERE ServiceID = ?` (multiple, mỗi service)

**Total: ~6-15 queries** (tùy số lượng services)

---

## 🔐 Security & Configuration

### Environment Variables (.env)

```env
EMAIL_FROM=hotel@gmail.com          # Gmail address
EMAIL_PASSWORD=abcdefghijklmnop     # App Password (16 chars)
SMTP_HOST=smtp.gmail.com            # SMTP server
SMTP_PORT=587                       # Port (587 or 465)
```

### Gmail App Password

- **Yêu cầu**: 2-Step Verification phải được bật
- **Tạo tại**: Google Account → Security → App passwords
- **Format**: 16 ký tự (có thể có khoảng trắng)
- **Bảo mật**: KHÔNG commit lên Git

### SSL/TLS Configuration

- **Port 587**: STARTTLS (upgrade to TLS)
- **Port 465**: SSL/TLS (encrypted from start)
- **Protocols**: TLSv1.2, TLSv1.3
- **Timeouts**: 10 seconds

---

## 🎨 Email Template Features

### Responsive Design

- Max-width: 600px
- Mobile-friendly
- Inline CSS

### Sections

1. ✅ Header (Gradient purple)
2. ✅ Greeting
3. ✅ Booking info
4. ✅ Room details
5. ✅ Stay duration
6. ✅ Services table (conditional)
7. ✅ Payment breakdown
8. ✅ Important notes
9. ✅ Footer

### Styling

- **Colors**: Purple gradient, green (paid), red (remaining)
- **Typography**: Arial, sans-serif
- **Icons**: Emoji icons (📋, 🏨, 📅, 🛎️, 💰)
- **Layout**: Cards with borders and shadows

---

## 🚀 Performance Optimization

### Async Email Sending

```java
new Thread(() -> {
    sendBookingConfirmationEmail(email, bookingId);
}).start();
```

**Benefits**:

- ✅ User không đợi email gửi xong
- ✅ Response time nhanh (~220ms)
- ✅ Better UX

### Lazy Loading

- Email chỉ load data khi cần
- Không ảnh hưởng booking process

### Error Handling

```java
try {
    // Send email
    return true;
} catch (Exception e) {
    System.err.println("✗ Lỗi: " + e.getMessage());
    e.printStackTrace();
    return false;
}
```

- Lỗi email không làm fail booking
- User vẫn thấy booking thành công

---

## 📝 Logs & Debugging

### Console Logs

**Successful Flow**:

```
✓ Đã load file .env thành công từ classpath!
✓ EmailSender đã được khởi tạo thành công!
  From: hotel@gmail.com
  SMTP: smtp.gmail.com:587
✓ Email HTML đã được gửi thành công đến: customer@example.com
✓ Đã gửi email xác nhận booking #123 đến: customer@example.com
```

**Error Examples**:

```
✗ Không tìm thấy booking với ID: 999
✗ Lỗi khi gửi email xác nhận booking: Could not convert socket to TLS
✗ Lỗi khi gửi email HTML: Authentication failed
```

### Debug Mode

Uncomment trong `EmailSender.java`:

```java
props.put("mail.debug", "true");
```

**Output**: Chi tiết SMTP conversation

---

## 📦 Dependencies

### Required Classes

- `BookingController` - Main controller
- `EmailSender` - SMTP sender
- `EnvConfig` - Environment loader

### Required DAOs

- `BookingDAO`
- `GuestDAO`
- `RoomDAO`
- `RoomTypeDAO`
- `BookingServiceDAO`
- `ServiceDAO`
- `PaymentDAO`

### Required Models

- `Booking`
- `Guest`
- `Room`
- `RoomType`
- `BookingService`
- `Service`
- `Payment`

### External Libraries

- JavaMail API
- javax.mail

---

## ✅ Summary

### Luồng chính:

1. **Nhận request** → Parse parameters
2. **Tạo booking** → Database inserts
3. **Lấy email** → Guest query
4. **Start thread** → Async email
5. **Redirect** → User sees confirmation
6. **Background**: Load data → Calculate → Generate HTML → Send SMTP

### Thời gian:

- **User wait**: ~220ms
- **Email sent**: ~1200ms (background)

### Kết quả:

- ✅ Booking được tạo trong DB
- ✅ User redirect đến confirmation page
- ✅ Email gửi đến khách hàng
- ✅ All async, non-blocking

---

**Tài liệu liên quan**:

- `BOOKING_EMAIL_GUIDE.md` - Hướng dẫn sử dụng
- `GMAIL_SMTP_SETUP.md` - Setup SMTP
- `EMAIL_CONFIG_QUICKSTART.md` - Quick start
