package dao;

import model.Booking;
import utils.DBConnection;
// Không cần import IConstant chứa formatter nữa (trừ khi dùng ở nơi khác)

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class BookingDAO {

    public ArrayList<Booking> getAllBookings() {
        ArrayList<Booking> result = new ArrayList<>();
        String sql = "SELECT TOP (1000) [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING]";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs != null) {
                while (rs.next()) {
                    // Bước 1: Lấy tất cả dữ liệu từ ResultSet
                    int bookingId = rs.getInt("BookingID");
                    int guestId = rs.getInt("GuestID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");

                    // Lấy thẳng đối tượng ngày giờ
                    LocalDateTime checkInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);

                    // Bước 2: Tạo đối tượng Booking và set trực tiếp các đối tượng ngày giờ
                    Booking booking = new Booking();
                    booking.setBookingId(bookingId);
                    booking.setGuestId(guestId);
                    booking.setRoomId(roomId);
                    booking.setStatus(status);
                    booking.setCheckInDate(checkInDate);   // Gán trực tiếp đối tượng
                    booking.setCheckOutDate(checkOutDate); // Gán trực tiếp đối tượng
                    booking.setBookingDate(bookingDate);   // Gán trực tiếp đối tượng

                    result.add(booking);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public boolean addBooking(Booking booking) {
        String sql = "INSERT INTO [dbo].[BOOKING] (GuestID, RoomID, CheckInDate, CheckOutDate, BookingDate, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, booking.getGuestId());
            ps.setInt(2, booking.getRoomId());
            ps.setObject(3, booking.getCheckInDate());   // Gán trực tiếp đối tượng
            ps.setObject(4, booking.getCheckOutDate()); // Gán trực tiếp đối tượng
            ps.setObject(5, booking.getBookingDate());   // Gán trực tiếp đối tượng
            ps.setString(6, booking.getStatus());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}