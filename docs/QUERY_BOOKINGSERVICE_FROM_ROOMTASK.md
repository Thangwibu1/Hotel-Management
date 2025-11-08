# Query BookingService từ RoomTask

## Mục đích
Tài liệu này giải thích cách lấy `Booking_Service_ID` từ `RoomTaskID` với điều kiện `isSystemTask = 0`.

## Phương án 1: Liên kết qua RoomID và Booking đang active

### SQL Query

```sql
SELECT bs.Booking_Service_ID
FROM ROOM_TASK rt
JOIN BOOKING b ON rt.RoomID = b.RoomID 
    AND b.Status IN ('Reserved', 'Checked-in')
JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID
WHERE rt.RoomTaskID = @RoomTaskID
  AND rt.isSystemTask = 0;
```

### Giải thích chi tiết

#### 1. Bảng ROOM_TASK (rt)
- **Vai trò**: Bảng chính chứa thông tin về công việc dọn dẹp phòng
- **Cột quan trọng**:
  - `RoomTaskID`: ID của task cần tìm
  - `RoomID`: ID phòng mà task này được thực hiện
  - `isSystemTask`: Phân biệt task do hệ thống tự động tạo (1) hay do user tạo (0)
  - `StaffID`: Nhân viên được gán
  - `StatusClean`: Trạng thái dọn dẹp (Cleaned, In Progress, Pending, Maintenance)

#### 2. JOIN với bảng BOOKING (b)
```sql
JOIN BOOKING b ON rt.RoomID = b.RoomID 
    AND b.Status IN ('Reserved', 'Checked-in')
```

**Mục đích**: Tìm booking (đặt phòng) đang hoạt động cho phòng đó

**Điều kiện JOIN**:
- `rt.RoomID = b.RoomID`: Khớp phòng trong task với phòng trong booking
- `b.Status IN ('Reserved', 'Checked-in')`: Chỉ lấy những booking đang active
  - `Reserved`: Đã đặt phòng, chưa check-in
  - `Checked-in`: Đang ở trong phòng
  - **Không lấy**: `Checked-out` (đã trả phòng), `Canceled` (đã hủy)

**Lý do**: Task dọn phòng thường liên quan đến khách đang ở hoặc sắp đến, không liên quan đến booking đã kết thúc.

#### 3. JOIN với bảng BOOKING_SERVICE (bs)
```sql
JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID
```

**Mục đích**: Lấy các dịch vụ được đặt trong booking đó

**Quan hệ**: 
- Một booking có thể có nhiều dịch vụ (1-N)
- Mỗi dịch vụ có một `Booking_Service_ID` riêng

#### 4. Điều kiện WHERE
```sql
WHERE rt.RoomTaskID = @RoomTaskID
  AND rt.isSystemTask = 0;
```

**Lọc kết quả**:
- `rt.RoomTaskID = @RoomTaskID`: Chỉ lấy task cụ thể mà bạn đang quan tâm
- `rt.isSystemTask = 0`: Chỉ lấy task do người dùng tạo (không phải task tự động của hệ thống)

### Sơ đồ quan hệ

```
ROOM_TASK (RoomTaskID=X, RoomID=Y, isSystemTask=0)
    |
    | JOIN ON RoomID
    ↓
BOOKING (BookingID=Z, RoomID=Y, Status='Checked-in')
    |
    | JOIN ON BookingID
    ↓
BOOKING_SERVICE (Booking_Service_ID=A, BookingID=Z, ServiceID=...)
```

### Ví dụ thực tế

Giả sử:
- Phòng 101 có `RoomID = 1`
- Khách A đang ở phòng 101, có `BookingID = 5`, Status = 'Checked-in'
- Khách A đặt 3 dịch vụ: Breakfast, Laundry, Room Keeping
  - Booking_Service_ID = 10 (Breakfast)
  - Booking_Service_ID = 11 (Laundry)
  - Booking_Service_ID = 12 (Room Keeping)
- Task dọn phòng 101 được tạo với `RoomTaskID = 7`, `isSystemTask = 0`

**Kết quả query**:
```
Booking_Service_ID
------------------
10
11
12
```

Query sẽ trả về **tất cả 3 dịch vụ** mà khách đã đặt trong booking đang active của phòng đó.

### Ưu điểm
✅ Đơn giản, dễ hiểu
✅ Tìm được tất cả dịch vụ liên quan đến phòng đang có booking active
✅ Phù hợp khi muốn xem toàn bộ dịch vụ của khách đang ở

### Nhược điểm
⚠️ Trả về TẤT CẢ dịch vụ trong booking, không chỉ dịch vụ dọn phòng
⚠️ Nếu có nhiều booking cùng lúc (ít xảy ra), sẽ trả về nhiều kết quả
⚠️ Không lọc theo thời gian (task có thể tạo trước hoặc sau khi đặt dịch vụ)

### Khi nào sử dụng
- Khi bạn muốn xem tất cả dịch vụ mà khách đang ở đã đặt
- Khi muốn liên kết task dọn phòng với booking hiện tại của phòng đó
- Khi logic nghiệp vụ cho phép một task liên quan đến nhiều dịch vụ

### Cải tiến có thể áp dụng

#### Chỉ lấy 1 kết quả (nếu cần):
```sql
SELECT TOP 1 bs.Booking_Service_ID
FROM ROOM_TASK rt
JOIN BOOKING b ON rt.RoomID = b.RoomID 
    AND b.Status IN ('Reserved', 'Checked-in')
JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID
WHERE rt.RoomTaskID = @RoomTaskID
  AND rt.isSystemTask = 0
ORDER BY bs.ServiceDate DESC;  -- Lấy dịch vụ mới nhất
```

#### Chỉ lấy dịch vụ dọn phòng (Room Keeping):
```sql
SELECT bs.Booking_Service_ID
FROM ROOM_TASK rt
JOIN BOOKING b ON rt.RoomID = b.RoomID 
    AND b.Status IN ('Reserved', 'Checked-in')
JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID
JOIN SERVICE s ON bs.ServiceID = s.ServiceID
WHERE rt.RoomTaskID = @RoomTaskID
  AND rt.isSystemTask = 0
  AND s.ServiceType = 'HouseKeeping';
```

#### Lọc theo StaffID (cùng nhân viên):
```sql
SELECT bs.Booking_Service_ID
FROM ROOM_TASK rt
JOIN BOOKING b ON rt.RoomID = b.RoomID 
    AND b.Status IN ('Reserved', 'Checked-in')
JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID
WHERE rt.RoomTaskID = @RoomTaskID
  AND rt.isSystemTask = 0
  AND (rt.StaffID = bs.StaffID OR bs.StaffID IS NULL);
```

## Cách sử dụng trong Java

```java
public List<Integer> getBookingServiceIdsByRoomTaskId(int roomTaskId) {
    List<Integer> bookingServiceIds = new ArrayList<>();
    String sql = "SELECT bs.Booking_Service_ID " +
                 "FROM ROOM_TASK rt " +
                 "JOIN BOOKING b ON rt.RoomID = b.RoomID " +
                 "    AND b.Status IN ('Reserved', 'Checked-in') " +
                 "JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID " +
                 "WHERE rt.RoomTaskID = ? " +
                 "  AND rt.isSystemTask = 0";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, roomTaskId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            bookingServiceIds.add(rs.getInt("Booking_Service_ID"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return bookingServiceIds;
}
```

## Tham khảo

- [given.sql](../data/given.sql) - Schema database đầy đủ
- Các phương án khác có thể xem trong mã nguồn RoomTaskDAO.java

