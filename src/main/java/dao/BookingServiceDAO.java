package dao;

import model.BookingService;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;

import java.sql.SQLException;
import java.util.ArrayList;
import model.ServiceDetail;

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
                    java.time.LocalDate serviceDate = rs.getObject("ServiceDate", java.time.LocalDate.class); // THAY �?ỔI
                    int status = rs.getInt("Status");

                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status); // THAY �?ỔI
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
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status, note); // THAY ?ỔI
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    public BookingService getById(int bookingServiceId) {
        BookingService result = null;
        String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status],[StaffID],[Note] " +
                     "FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE [Booking_Service_ID] = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingServiceId);
            ResultSet rs = ps.executeQuery();
            if (rs != null && rs.next()) {
                int bookingServiceID = rs.getInt("Booking_Service_ID");
                int bookingID = rs.getInt("BookingID");
                int serviceId = rs.getInt("ServiceID");
                int quantity = rs.getInt("Quantity");
                LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                int status = rs.getInt("Status");
                String note = rs.getString("Note");
                result = new BookingService(bookingServiceID, bookingID, serviceId, quantity, serviceDate, status, note);
                result.setStaffID(rs.getInt("StaffID"));
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
                    result = new BookingService(bookingServiceID, bookingID, serviceId, quantity, serviceDate, status, note); // THAY ?ỔI
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

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public ArrayList<ServiceDetail> getServiceDetailsByBookingId(int bookingId) {
        ArrayList<ServiceDetail> list = new ArrayList<>();
        String sql = "SELECT s.ServiceID, s.ServiceName, s.Price, bs.Quantity, bs.ServiceDate\n"
                + "FROM BOOKING_SERVICE bs\n"
                + "JOIN SERVICE s ON s.ServiceID = bs.ServiceID\n"
                + "WHERE bs.BookingID = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ServiceDetail(
                            rs.getInt("ServiceID"),
                            rs.getString("ServiceName"),
                            rs.getBigDecimal("Price"),
                            rs.getInt("Quantity"),
                            rs.getObject("ServiceDate", LocalDate.class)
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy tất cả BookingService theo ngày cụ thể
     *
<<<<<<< Updated upstream
     * @param date Ngày cần l�?c
=======
     * @param date Ngày cần l�?c
>>>>>>> Stashed changes
     * @return Danh sách BookingService trong ngày đó
     */
    public ArrayList<BookingService> getAllBookingService(LocalDate date) {
        ArrayList<BookingService> result = new ArrayList<>();
        String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status],[StaffID],[Note] "
                + "FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE [ServiceDate] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, date);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                    int status = rs.getInt("Status");
                    String note = rs.getString("Note");
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status, note);
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy tất cả BookingService theo ngày và status
     *
<<<<<<< Updated upstream
     * @param date Ngày cần l�?c
     * @param status Trạng thái cần l�?c
=======
     * @param date Ngày cần l�?c
     * @param status Trạng thái cần l�?c
>>>>>>> Stashed changes
     * @return Danh sách BookingService phù hợp
     */
    public ArrayList<BookingService> getAllBookingService(LocalDate date, int status) {
        ArrayList<BookingService> result = new ArrayList<>();
        String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status],[StaffID],[Note] "
                + "FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE [ServiceDate] = ? AND [Status] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, date);
            ps.setInt(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                    int stat = rs.getInt("Status");
                    String note = rs.getString("Note");
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, stat, note);
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy BookingService từ startDate đến endDate theo staffId và
     * status
     *
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @param staffId ID của nhân viên
     * @param status Trạng thái
     * @return Danh sách BookingService phù hợp
     */
    public ArrayList<BookingService> getAllBookingServiceBaseStartEndDate(LocalDate startDate, LocalDate endDate, int staffId, int status) {
        ArrayList<BookingService> result = new ArrayList<>();
        String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status],[StaffID],[Note] "
                + "FROM [HotelManagement].[dbo].[BOOKING_SERVICE] "
                + "WHERE [ServiceDate] >= ? AND [ServiceDate] <= ? AND [StaffID] = ? AND [Status] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, startDate);
            ps.setObject(2, endDate);
            ps.setInt(3, staffId);
            ps.setInt(4, status);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                    int stat = rs.getInt("Status");
                    String note = rs.getString("Note");
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, stat, note);
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy tất cả BookingService từ ngày hiện tại trở đi
     *
     * @param fromDate Ngày bắt đầu
     * @return Danh sách BookingService từ ngày đó trở đi
     */
    public ArrayList<BookingService> getAllBookingServiceFromToday(LocalDate fromDate) {
        ArrayList<BookingService> result = new ArrayList<>();
        String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status],[StaffID],[Note] "
                + "FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE [ServiceDate] >= ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, fromDate);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                    int status = rs.getInt("Status");
                    String note = rs.getString("Note");
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status, note);
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy tất cả BookingService theo StaffID
     *
     * @param staffId ID của nhân viên
     * @return Danh sách BookingService của nhân viên đó
     */
    public ArrayList<BookingService> getAllBookingService(int staffId) {
        ArrayList<BookingService> result = new ArrayList<>();
        String sql = "SELECT [Booking_Service_ID],[BookingID],[ServiceID],[Quantity],[ServiceDate],[Status],[StaffID],[Note] "
                + "FROM [HotelManagement].[dbo].[BOOKING_SERVICE] WHERE [StaffID] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingServiceId = rs.getInt("Booking_Service_ID");
                    int bookingId = rs.getInt("BookingID");
                    int serviceId = rs.getInt("ServiceID");
                    int quantity = rs.getInt("Quantity");
                    LocalDate serviceDate = rs.getObject("ServiceDate", LocalDate.class);
                    int status = rs.getInt("Status");
                    String note = rs.getString("Note");
                    BookingService bookingService = new BookingService(bookingServiceId, bookingId, serviceId, quantity, serviceDate, status, note);
                    bookingService.setStaffID(rs.getInt("StaffID"));
                    result.add(bookingService);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<Integer> getRoomTaskIdByBookingServiceId(int bookingServiceId) {
        ArrayList<Integer> result = new ArrayList<>();

        String sql = "SELECT DISTINCT rt.RoomTaskID FROM BOOKING_SERVICE bs JOIN BOOKING b ON bs.BookingID = b.BookingID JOIN ROOM r ON b.RoomID = r.RoomID JOIN ROOM_TASK rt ON r.RoomID = rt.RoomID WHERE bs.Booking_Service_ID = ? and rt.isSystemTask = 0";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingServiceId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    result.add(rs.getInt("RoomTaskID"));
                }
            }
        } catch (Exception e) {
            // TODO: handle exception
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }
    public void deleteByBookingId(Connection conn, int bookingId) throws SQLException {
        String sql = "UPDATE [dbo].[BOOKING_SERVICE] SET [Status] = ? WHERE BookingID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, -1);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }

    public void replaceBookingServices(Connection conn, int bookingId, String[] serviceIds, String[] quantities, String[] dates) throws SQLException {
        // X�a c?
        deleteByBookingId(conn, bookingId);

        if (serviceIds == null || serviceIds.length == 0) {
            return;
        }

        String sql = "INSERT INTO BOOKING_SERVICE (BookingID, ServiceID, Quantity, ServiceDate, Status) VALUES (?, ?, ?, ?, 0)";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < serviceIds.length; i++) {
                int sid = Integer.parseInt(serviceIds[i]);

                // Skip invalid service IDs (0 or negative)
                if (sid <= 0) {
                    continue;
                }

                int qty = Integer.parseInt(quantities[i]);
                java.sql.Date svcDate = null;

                if (dates != null && i < dates.length && dates[i] != null && !dates[i].isEmpty()) {
                    svcDate = java.sql.Date.valueOf(dates[i]); // yyyy-MM-dd
                }

                ps.setInt(1, bookingId);
                ps.setInt(2, sid);
                ps.setInt(3, qty);

                if (svcDate != null) {
                    ps.setDate(4, svcDate);
                } else {
                    ps.setNull(4, java.sql.Types.DATE);
                }

                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

}
