package dao;

import model.BookingService;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.sql.SQLException;
import java.util.ArrayList;

public class BookingServiceDAO {
    public ArrayList<BookingService> getAllBookingService() {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE]";
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
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class); // THAY ?ỔI
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    


public ArrayList<BookingService> getAllBookingService(int staffID)  {
    ArrayList<BookingService> result = new ArrayList<>();

    // T?i ?u SELECT: B? [StaffID] v� ?� c� trong tham s?.
    String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE [StaffID] = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, staffID);

        try (ResultSet rs = ps.executeQuery()) {
            // Kh�ng c?n ki?m tra if (rs != null)
            while (rs.next()) {
                int bookingServiceId = rs.getInt("Booking_Service_ID");
                int bookingId = rs.getInt("BookingID");
                int serviceId = rs.getInt("ServiceID");
                int quantity = rs.getInt("Quantity");
                LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                int status = rs.getInt("Status");

                BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status, staffID);
                result.add(bookingService);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        
    } 
    
    return result;
}
    public ArrayList<BookingService> getAllBookingServiceFromToday(LocalDate today) {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE CONVERT(DATE, [ServiceDate]) >= ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setObject(1, today);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class);
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    public ArrayList<BookingService> getAllBookingService(LocalDate today) {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE CONVERT(DATE, [ServiceDate]) = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setObject(1, today);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class);
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    public ArrayList<BookingService> getAllBookingService(LocalDate today, int statusTmp) {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE CONVERT(DATE, [ServiceDate]) = ? AND [Status] = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setObject(1, today);
            ps.setObject(2, statusTmp);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class);
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    public ArrayList<BookingService> getAllBookingServiceFromToday(LocalDate today, int statusTmp) {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE CONVERT(DATE, [ServiceDate]) >= ? AND [Status] = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setObject(1, today);
            ps.setObject(2, statusTmp);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class);
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    //dung cho tim booking da  hoan thanh boi ai do 
    public ArrayList<BookingService> getAllBookingServiceBaseStartEndDate(LocalDate startDateReport, LocalDate endDateReport, int staffID, int status) {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE ServiceDate >= ? AND ServiceDate <= ? and  [StaffID]  = ? AND  [Status] = ? ";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDate(1, java.sql.Date.valueOf(startDateReport));
            ps.setDate(2, java.sql.Date.valueOf(endDateReport));
            ps.setInt(3, staffID);
            ps.setInt(4, status);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class);
                    int statusTmp = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, statusTmp); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    
    //d�ng cho lay list bao 
    public ArrayList<BookingService> getAllBookingServiceBaseStartEndDate(LocalDate startDateReport, LocalDate endDateReport, int staffID) {
        ArrayList<BookingService> result = new ArrayList<>();

        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE CONVERT(DATE, ServiceDate) BETWEEN ? AND ? and  [StaffID]  = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setObject(1, startDateReport);
            ps.setObject(2, endDateReport);
            ps.setInt(3, staffID);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class);
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
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
        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID],[Note] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] where BookingID = ?";
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
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class); // THAY ?ỔI
                    int status = rs.getInt("Status");
                    String note = rs.getString("Note");
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status,note); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    public BookingService getBookingServiceByBookingServiceId(int bookingServiceId) {

        BookingService result = null;
        String sql = "SELECT  [Booking_Service_ID],[BookingID],[ServiceID],[Quantity] ,[ServiceDate], [Status], [StaffID],[Note] FROM [HotelManagement].[dbo].[BOOKING_SERVICE] where [Booking_Service_ID] = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingServiceId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceID = rs.getInt("Booking_Service_ID");
                    int bookingID = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class); // THAY ?ỔI
                    int status = rs.getInt("Status");
                    String note = rs.getString("Note");
                    result = new BookingService(bookingServiceID, bookingID, serviceId, quantity, serviceDate, status,note); // THAY ?ỔI
                    result.setStaffID(rs.getInt("StaffID"));
                   
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean addBookingService(BookingService bookingService) {
    String sql = "INSERT INTO [dbo].[BOOKING_SERVICE] "
               + "(BookingID, ServiceID, Quantity, ServiceDate, Status, Note, StaffID) "
               + "VALUES (?, ?, ?, ?, ?, ?,?)";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, bookingService.getBookingId());
        ps.setInt(2, bookingService.getServiceId());
        ps.setInt(3, bookingService.getQuantity());
        
        ps.setObject(4, bookingService.getServiceDate()); 
        
        ps.setInt(5, 0);
        
        ps.setString(6, bookingService.getNote()); 
        ps.setInt(7, bookingService.getStaffID());
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
        
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

public boolean addBookingServiceWithTransaction(BookingService bookingService, Connection conn) throws SQLException {
    String sql = "INSERT INTO [dbo].[BOOKING_SERVICE] (BookingID, ServiceID, Quantity, ServiceDate, Status) VALUES (?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, bookingService.getBookingId());
        ps.setInt(2, bookingService.getServiceId());
        ps.setInt(3, bookingService.getQuantity());
        ps.setObject(4, bookingService.getServiceDate());
        ps.setInt(5, bookingService.getStatus());

        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    }
}

    public boolean updateBookingServiceStatus(int bookingServiceId, int status) {
        String sql = "UPDATE [dbo].[BOOKING_SERVICE] SET Status = ? WHERE Booking_Service_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, bookingServiceId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("Vo update DAO ne");;
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean updateBookingServiceStatus(int bookingServiceId, int status, int staffID) {
        String sql = "UPDATE [dbo].[BOOKING_SERVICE] SET Status = ?, StaffID = ? WHERE Booking_Service_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, staffID);
            ps.setInt(3, bookingServiceId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}