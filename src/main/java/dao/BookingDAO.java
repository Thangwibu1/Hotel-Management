// Giả sử file này nằm trong package dao
package dao;

// 1. Thêm đầy đủ các import cần thiết
import model.Booking;
import utils.DBConnection;
import utils.IConstant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class BookingDAO {

    public ArrayList<Booking> getAllBookings() {
        ArrayList<Booking> result = new ArrayList<>();
        String sql = "SELECT [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING]";

        // 2. Sử dụng try-with-resources để tự động đóng Connection, PreparedStatement, ResultSet
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs != null) {
                while (rs.next()) {
                    // 3. Lấy dữ liệu từ ResultSet
                    // Lấy các cột số và chuỗi như bình thường
                    int bookingId = rs.getInt("BookingID");
                    int guestId = rs.getInt("GuestID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");

                    // Lấy các cột ngày giờ bằng kiểu đối tượng chính xác
                    LocalDateTime checkInDateTime = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDateTime = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);

                    // 4. Format các đối tượng ngày giờ thành String theo hằng số đã định nghĩa
                    String checkInDateStr = checkInDateTime.format(IConstant.localDateFormat);
                    String checkOutDateStr = checkOutDateTime.format(IConstant.localDateFormat);
                    String bookingDateStr = bookingDate.format(IConstant.dateFormat);

                    // 5. Tạo đối tượng Booking và set giá trị
                    Booking booking = new Booking();
                    booking.setBookingId(bookingId);
                    booking.setGuestId(guestId);
                    booking.setRoomId(roomId);
                    booking.setStatus(status);
                    booking.setCheckInDate(checkInDateStr);   // Set giá trị String
                    booking.setCheckOutDate(checkOutDateStr); // Set giá trị String
                    booking.setBookingDate(bookingDateStr);   // Set giá trị String

                    // 6. Thêm đối tượng vào danh sách kết quả
                    result.add(booking);
                }
            }
        } catch (Exception e) { // Nên bắt Exception cụ thể hơn là Exception chung
            e.printStackTrace();
        }

        return result;
    }
}