# Hướng Dẫn Chức Năng Check-out

## Tổng Quan

Chức năng check-out cho phép receptionist thực hiện check-out khách hàng sau khi kiểm tra thanh toán đầy đủ và tạo invoice.

## Quy Trình Check-out

```
1. Receptionist chọn booking cần check-out
   ↓
2. Hệ thống tính toán:
   - Tổng tiền phải trả (phòng + dịch vụ)
   - Số tiền đã thanh toán
   - Số tiền còn thiếu
   ↓
3. Kiểm tra thanh toán:
   
   A. Nếu CHƯA trả đủ:
      → Hiển thị cảnh báo
      → Hiển thị số tiền còn thiếu
      → Nút "Đi Thanh Toán Ngay" → chuyển đến paymentRemain
   
   B. Nếu ĐÃ trả đủ:
      → Cập nhật status booking = "Checked-out"
      → Tạo Invoice mới
      → Hiển thị thông báo thành công
      → Hiển thị invoice
      → Nút "In Hóa Đơn"
```

## Files Liên Quan

### 1. checkOutController.java
**Đường dẫn:** `src/main/java/controller/receptionist/checkOutController.java`

**URL:** `/receptionist/checkOutController`

**Chức năng chính:**

#### A. Tính toán tổng tiền (giống PaymentRemainController)
```java
// Tính tiền phòng
double pricePerNight = roomType.getPricePerNight().doubleValue();
double roomTotal = pricePerNight * numberOfNights;

// Tính tiền dịch vụ
double servicesTotal = 0;
for (BookingService bs : bookingServices) {
    Service service = serviceDAO.getServiceById(bs.getServiceId());
    double servicePrice = service.getPrice().doubleValue();
    double serviceItemTotal = servicePrice * bs.getQuantity();
    servicesTotal += serviceItemTotal;
}

// Tổng tiền
double totalAmount = roomTotal + servicesTotal;
```

#### B. Kiểm tra thanh toán
```java
// Tính số tiền đã trả
ArrayList<Payment> payments = paymentDAO.getPaymentByBookingId(bookingId);
double paidAmount = 0;
for (Payment payment : payments) {
    paidAmount += payment.getAmount();
}

// Tính số tiền còn thiếu
double remainingAmount = totalAmount - paidAmount;

// Kiểm tra
if (remainingAmount > 0) {
    // Chưa trả đủ → hiển thị cảnh báo
} else {
    // Đã trả đủ → checkout
}
```

#### C. Thực hiện check-out (nếu đã trả đủ)
```java
// 1. Cập nhật status booking
boolean updateSuccess = bookingDAO.updateBookingStatus(bookingId, "Checked-out");

// 2. Tạo invoice
Invoice invoice = new Invoice();
invoice.setBookingId(bookingId);
invoice.setIssueDate(new Date(System.currentTimeMillis()));
invoice.setPrice(totalAmount);
invoice.setDiscount(0);
invoice.setTax(0);
invoice.setTotalAmount(totalAmount);
invoice.setStatus("Paid");

boolean invoiceSuccess = invoiceDAO.addInvoice(invoice);

// 3. Hiển thị trang thành công
```

### 2. checkOutView.jsp
**Đường dẫn:** `src/main/webapp/receptionist/checkOutView.jsp`

**2 Trạng thái:**

#### Trạng thái 1: Chưa Thanh Toán Đủ ⚠️
- **Header:** Màu đỏ với icon cảnh báo
- **Alert:** Thông báo lỗi màu đỏ
- **Nội dung:**
  - Thông tin booking
  - Tổng kết: Tổng tiền, Đã trả, **Còn thiếu**
- **Nút:**
  - "Đi Thanh Toán Ngay" (màu đỏ) → chuyển đến `/paymentRemain`
  - "Quay Lại"

#### Trạng thái 2: Check-out Thành Công ✅
- **Header:** Màu tím với icon check
- **Alert:** Thông báo thành công màu xanh
- **Nội dung:**
  - Thông tin booking
  - Tổng kết thanh toán
  - **Invoice box** (gradient tím):
    - Ngày xuất
    - Tổng tiền
    - Trạng thái: "Paid"
- **Nút:**
  - "In Hóa Đơn" → `window.print()`
  - "Quay Lại"

## Database Operations

### 1. UPDATE Booking Status
```sql
UPDATE BOOKING 
SET Status = 'Checked-out' 
WHERE BookingID = ?
```

### 2. INSERT Invoice
```sql
INSERT INTO INVOICE 
(BookingID, IssueDate, Price, Discount, Tax, TotalAmount, Status) 
VALUES (?, ?, ?, ?, ?, ?, ?)
```

**Giá trị mẫu:**
- BookingID: ID của booking
- IssueDate: Ngày hiện tại
- Price: Tổng tiền (phòng + dịch vụ)
- Discount: 0 (không giảm giá)
- Tax: 0 (không thuế)
- TotalAmount: = Price (do không có discount/tax)
- Status: "Paid"

## Flow Charts

### Flow 1: Check-out Thất Bại (Chưa trả đủ)
```
checkOutController
    ↓
Tính tổng tiền
    ↓
Tính tiền đã trả
    ↓
remainingAmount > 0 ? → YES
    ↓
Set errorMessage
    ↓
Forward to checkOutView.jsp
    ↓
Hiển thị cảnh báo đỏ
    ↓
Nút "Đi Thanh Toán Ngay"
    ↓
→ /paymentRemain?bookingId=xxx
```

### Flow 2: Check-out Thành Công (Đã trả đủ)
```
checkOutController
    ↓
Tính tổng tiền
    ↓
Tính tiền đã trả
    ↓
remainingAmount == 0 ? → YES
    ↓
updateBookingStatus("Checked-out")
    ↓
addInvoice()
    ↓
Set successMessage
    ↓
Forward to checkOutView.jsp
    ↓
Hiển thị thông báo xanh ✓
    ↓
Hiển thị Invoice
    ↓
Nút "In Hóa Đơn"
```

## Validation & Error Handling

### 1. Booking không tồn tại
```java
if (booking == null) {
    request.setAttribute("errorMessage", "Không tìm thấy booking!");
    request.getRequestDispatcher("/error.jsp").forward(request, response);
    return;
}
```

### 2. Không thể cập nhật status
```java
if (!updateSuccess) {
    request.setAttribute("errorMessage", "Không thể cập nhật trạng thái booking!");
    request.getRequestDispatcher("/error.jsp").forward(request, response);
    return;
}
```

### 3. Không thể tạo invoice
```java
if (!invoiceSuccess) {
    request.setAttribute("errorMessage", "Không thể tạo invoice!");
    request.getRequestDispatcher("/error.jsp").forward(request, response);
    return;
}
```

## Attributes Được Gửi

| Attribute | Type | Khi nào có | Mô tả |
|-----------|------|-----------|-------|
| booking | Booking | Luôn có | Thông tin booking |
| room | Room | Luôn có | Thông tin phòng |
| roomType | RoomType | Luôn có | Loại phòng |
| totalAmount | Double | Luôn có | Tổng tiền phải trả |
| paidAmount | Double | Luôn có | Số tiền đã trả |
| remainingAmount | Double | Nếu chưa trả đủ | Số tiền còn thiếu |
| numberOfNights | Long | Nếu thành công | Số đêm |
| roomTotal | Double | Nếu thành công | Tiền phòng |
| servicesTotal | Double | Nếu thành công | Tiền dịch vụ |
| invoice | Invoice | Nếu thành công | Invoice đã tạo |
| successMessage | String | Nếu thành công | "Check-out thành công!" |
| errorMessage | String | Nếu thất bại | Thông báo lỗi |

## Test Cases

### Test Case 1: Check-out với thanh toán đầy đủ
```
Input: bookingId = 123 (đã trả đủ 100%)
Expected:
- Status booking = "Checked-out"
- Invoice được tạo
- Hiển thị trang thành công màu tím
- Có nút "In Hóa Đơn"
```

### Test Case 2: Check-out với chưa thanh toán
```
Input: bookingId = 456 (mới trả 50%)
Expected:
- Status booking không đổi
- Không tạo invoice
- Hiển thị cảnh báo màu đỏ
- Hiển thị số tiền còn thiếu
- Có nút "Đi Thanh Toán Ngay"
```

### Test Case 3: Check-out với thanh toán thừa
```
Input: bookingId = 789 (trả 120%)
remainingAmount = -200,000 (âm)
Expected:
- remainingAmount < 0 → vẫn cho phép checkout
- Status booking = "Checked-out"
- Invoice được tạo với totalAmount = giá gốc
```

### Test Case 4: Booking không tồn tại
```
Input: bookingId = 999 (không tồn tại)
Expected:
- Forward to error.jsp
- errorMessage = "Không tìm thấy booking!"
```

## Integration với Hệ Thống

### 1. Từ Receptionist Dashboard
```jsp
<form action="/receptionist/checkOutController" method="post">
    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
    <button type="submit">Check-out</button>
</form>
```

### 2. Link đến Payment
Nếu chưa trả đủ:
```jsp
<form action="../paymentRemain" method="post">
    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
    <button type="submit">Đi Thanh Toán Ngay</button>
</form>
```

## Tính Năng In Hóa Đơn

### Print Functionality
```javascript
<button onclick="window.print()">
    <i class="fas fa-print"></i>
    In Hóa Đơn
</button>
```

Khi click:
- Trình duyệt mở dialog in
- Chỉ in nội dung của trang (invoice)
- Có thể lưu PDF

## Giao Diện

### Màu Sắc

**Thành công:**
- Header: Gradient tím (#667eea → #764ba2)
- Alert: Xanh lá (#d4edda)
- Icon: Check circle ✓

**Thất bại:**
- Header: Gradient đỏ (#ff6b6b → #ee5a6f)
- Alert: Đỏ nhạt (#f8d7da)
- Icon: Warning triangle ⚠️

### Animation
- Icon scale in (0.5s ease-out)
- Button hover: translateY(-2px)
- Smooth transitions

## Notes

- **Không rollback:** Nếu tạo invoice thất bại sau khi update booking, status đã bị thay đổi nhưng không có invoice
- **Discount & Tax:** Hiện tại set = 0, có thể mở rộng thêm
- **Print:** Sử dụng `window.print()` native của browser
- **Security:** Chỉ receptionist mới có quyền truy cập URL này

## Future Enhancements

1. **Transaction Management:** Wrap update booking + create invoice trong transaction
2. **Email Invoice:** Gửi invoice qua email cho khách
3. **PDF Generation:** Tạo file PDF invoice thay vì print
4. **Discount Logic:** Thêm logic tính discount dựa trên voucher/membership
5. **Tax Calculation:** Tự động tính thuế VAT
6. **Partial Checkout:** Cho phép checkout ngay cả khi chưa trả đủ (ghi nợ)

## Example URL

```
http://localhost:8080/HotelManagement/receptionist/checkOutController?bookingId=123
```

## Comparison với PaymentRemainController

| Feature | PaymentRemainController | checkOutController |
|---------|------------------------|-------------------|
| URL | `/paymentRemain` | `/receptionist/checkOutController` |
| Người dùng | Guest | Receptionist |
| Chức năng | Xem và thanh toán | Check-out và tạo invoice |
| Logic tính tiền | ✓ Giống nhau | ✓ Giống nhau |
| Kiểm tra thanh toán | ✓ Hiển thị còn thiếu | ✓ Chặn nếu chưa đủ |
| Cập nhật booking | ✗ Không | ✓ Update status |
| Tạo invoice | ✗ Không | ✓ Tạo mới |
| Allow thanh toán | ✓ Có form | ✗ Redirect |

