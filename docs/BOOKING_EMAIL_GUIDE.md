# Hướng Dẫn Sử Dụng Hàm Gửi Email Xác Nhận Booking

## Tổng Quan

Hàm `sendBookingConfirmationEmail()` được tạo trong `BookingController.java` để tự động gửi email xác nhận đẹp mắt cho khách hàng sau khi hoàn thành đặt phòng.

## Chữ Ký Hàm

```java
protected boolean sendBookingConfirmationEmail(String recipientEmail, int bookingId)
```

### Tham Số

| Tham số          | Kiểu   | Mô tả                                 |
| ---------------- | ------ | ------------------------------------- |
| `recipientEmail` | String | Địa chỉ email người nhận (khách hàng) |
| `bookingId`      | int    | ID của booking vừa tạo thành công     |

### Giá Trị Trả Về

- `true`: Email được gửi thành công
- `false`: Có lỗi xảy ra khi gửi email

## Cách Hoạt Động

Hàm này sẽ tự động:

1. **Lấy thông tin từ database**:

   - Thông tin booking từ `Booking` model
   - Thông tin khách hàng từ `Guest` model
   - Thông tin phòng từ `Room` model
   - Thông tin loại phòng từ `RoomType` model
   - Danh sách dịch vụ đã đặt từ `BookingService` model
   - Chi tiết từng dịch vụ từ `Service` model

2. **Tính toán tự động**:

   - Số đêm lưu trú
   - Tổng tiền phòng
   - Tổng tiền dịch vụ
   - Tổng cộng toàn bộ
   - Số tiền đã thanh toán (50%)
   - Số tiền còn lại

3. **Tạo email HTML đẹp mắt** với:

   - Header gradient màu tím
   - Thông tin đặt phòng chi tiết
   - Thông tin phòng và loại phòng
   - Thời gian nhận/trả phòng
   - Bảng dịch vụ đã đặt (nếu có)
   - Chi tiết thanh toán
   - Ghi chú quan trọng cho khách

4. **Gửi email** qua `EmailSender` class

## Cách Sử Dụng

### 1. Sử dụng trong BookingController (Đã tích hợp sẵn)

Hàm đã được tự động gọi trong method `doPost()` sau khi booking thành công:

```java
// Gửi email xác nhận booking nếu booking thành công
if (newBookingId > 0) {
    String recipientEmail = viewGuest.getEmail();
    if (recipientEmail != null && !recipientEmail.trim().isEmpty()) {
        // Gửi email trong thread riêng để không block response
        final int finalBookingId = newBookingId;
        final String finalEmail = recipientEmail;
        new Thread(() -> {
            sendBookingConfirmationEmail(finalEmail, finalBookingId);
        }).start();
    }
}
```

### 2. Sử dụng thủ công từ controller khác

```java
BookingController bookingController = new BookingController();
bookingController.init(); // Khởi tạo các DAO

String customerEmail = "customer@example.com";
int bookingId = 123;

boolean success = bookingController.sendBookingConfirmationEmail(customerEmail, bookingId);

if (success) {
    System.out.println("Email đã được gửi thành công!");
} else {
    System.out.println("Có lỗi khi gửi email!");
}
```

## Nội Dung Email

Email được gửi đi bao gồm các phần sau:

### 📋 Thông Tin Đặt Phòng

- Mã đặt phòng
- Ngày đặt
- Trạng thái booking

### 🏨 Thông Tin Phòng

- Số phòng
- Loại phòng
- Sức chứa
- Giá phòng/đêm

### 📅 Thời Gian Lưu Trú

- Ngày nhận phòng
- Ngày trả phòng
- Tổng số đêm

### 🛎️ Dịch Vụ Đã Đặt (nếu có)

Bảng chi tiết gồm:

- Tên dịch vụ
- Số lượng
- Ngày sử dụng
- Đơn giá
- Thành tiền

### 💰 Chi Tiết Thanh Toán

- Tiền phòng (số đêm × giá/đêm)
- Tiền dịch vụ
- **Tổng cộng**
- Đã thanh toán (50%)
- Còn lại

### Ghi Chú

- Yêu cầu mang giấy tờ tùy thân
- Giờ nhận phòng: 14:00
- Giờ trả phòng: 12:00
- Thông tin liên hệ hỗ trợ

## Định Dạng Ngày Tháng

- **Ngày đơn giản**: `dd/MM/yyyy` (VD: 27/10/2025)
- **Ngày giờ đầy đủ**: `dd/MM/yyyy HH:mm` (VD: 27/10/2025 14:00)

## Định Dạng Tiền Tệ

Tất cả số tiền được format với dấu phẩy ngăn cách hàng nghìn và đơn vị VNĐ:

- VD: `1,500,000 VNĐ`

## Xử Lý Bất Đồng Bộ

Email được gửi trong một **thread riêng** để:

- ✅ Không làm chậm response trả về cho client
- ✅ Cải thiện trải nghiệm người dùng
- ✅ Tránh timeout khi gửi email lâu

## Yêu Cầu Hệ Thống

### 1. Email Configuration

Đảm bảo file `.env` đã được cấu hình đúng:

```env
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
```

### 2. Dependencies Required

- `EmailSender` class trong package `controller.feature`
- Các DAO classes: `BookingDAO`, `GuestDAO`, `RoomDAO`, `RoomTypeDAO`, `BookingServiceDAO`, `ServiceDAO`
- Các Model classes: `Booking`, `Guest`, `Room`, `RoomType`, `BookingService`, `Service`

### 3. Database

Hàm cần truy cập các bảng:

- `BOOKING`
- `GUEST`
- `ROOM`
- `ROOM_TYPE`
- `BOOKING_SERVICE`
- `SERVICE`

## Xử Lý Lỗi

Hàm có xử lý các trường hợp:

1. **Booking không tồn tại**:

   ```java
   if (booking == null) {
       System.err.println("Không tìm thấy booking với ID: " + bookingId);
       return false;
   }
   ```

2. **Exception khi gửi email**:
   ```java
   catch (Exception e) {
       System.err.println("✗ Lỗi khi gửi email xác nhận booking: " + e.getMessage());
       e.printStackTrace();
       return false;
   }
   ```

## Log Messages

### Thành công

```
✓ Đã gửi email xác nhận booking #123 đến: customer@example.com
```

### Thất bại

```
✗ Lỗi khi gửi email xác nhận booking: [Chi tiết lỗi]
```

## Best Practices

1. **Luôn kiểm tra email hợp lệ** trước khi gọi hàm:

   ```java
   if (email != null && !email.trim().isEmpty()) {
       sendBookingConfirmationEmail(email, bookingId);
   }
   ```

2. **Sử dụng async** để tránh block main thread:

   ```java
   new Thread(() -> {
       sendBookingConfirmationEmail(email, bookingId);
   }).start();
   ```

3. **Log kết quả** để tracking:
   ```java
   boolean result = sendBookingConfirmationEmail(email, bookingId);
   if (!result) {
       // Xử lý khi gửi email thất bại
       logger.error("Failed to send booking confirmation email");
   }
   ```

## Tùy Chỉnh

Nếu muốn tùy chỉnh email template, bạn có thể chỉnh sửa:

1. **Màu sắc**: Thay đổi gradient trong header
2. **Nội dung**: Thêm/bớt sections trong HTML
3. **Định dạng**: Thay đổi DateTimeFormatter patterns
4. **Logo**: Thêm logo công ty vào header
5. **Footer**: Cập nhật thông tin liên hệ

## Ví Dụ Email Output

Subject: `Xác nhận đặt phòng #123 - Hotel Management System`

Nội dung: HTML email đẹp mắt với đầy đủ thông tin booking, responsive design, và professional styling.

## Troubleshooting

| Vấn đề                      | Nguyên nhân        | Giải pháp                       |
| --------------------------- | ------------------ | ------------------------------- |
| Email không được gửi        | Cấu hình SMTP sai  | Kiểm tra lại file `.env`        |
| Email vào spam              | Email chưa verify  | Xác thực domain email           |
| Thiếu thông tin trong email | Dữ liệu null từ DB | Kiểm tra dữ liệu trong database |
| Format tiền sai             | Locale settings    | Đảm bảo server có Locale VN     |

## Support

Nếu có vấn đề khi sử dụng hàm này, vui lòng:

1. Check console logs để xem error messages
2. Verify database có đầy đủ dữ liệu cho booking
3. Test EmailSender riêng biệt để đảm bảo email config đúng
