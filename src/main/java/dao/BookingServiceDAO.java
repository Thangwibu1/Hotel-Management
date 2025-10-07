package dao;

import model.BookingService;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BookingServiceDAO {
    public ArrayList<BookingService> getAllBookingService() {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status] FROM [HotelManagement].[dbo].[BOOKING_SERVICE]";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class); // THAY ĐỔI
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ĐỔI
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<BookingService> getBookingServiceByBookingId(int bookingId) {

        ArrayList<BookingService> result = new ArrayList<>();
        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] where BookingID = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class); // THAY ĐỔI
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ĐỔI
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean addBookingService(BookingService bookingService) {
        String sql = "INSERT INTO [dbo].[BOOKING_SERVICE] (BookingID, ServiceID, Quantity, ServiceDate, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingService.getBookingId());
            ps.setInt(2, bookingService.getServiceId());
            ps.setInt(3, bookingService.getQuantity());
            ps.setObject(4, bookingService.getServiceDate()); // THAY ĐỔI
            ps.setInt(5, bookingService.getStatus());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
