package dao;

import java.sql.*;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.ArrayList;

import model.Payment;
import model.PaymentWithRoomDTO;
import utils.DBConnection;

public class PaymentDAO {

    public Payment getPaymentById(int paymentId) {
        Payment result = null;
        String sql = "SELECT * FROM PAYMENT WHERE PaymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {

                    int bookingId = rs.getInt("BookingID");
                    LocalDate paymentDate = rs.getObject("PaymentDate", LocalDate.class);
                    double amount = rs.getDouble("Amount");
                    String paymentMethod = rs.getString("PaymentMethod");
                    String status = rs.getString("Status");
                    result = new Payment(paymentId, bookingId, paymentDate, amount, paymentMethod, status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    

    public ArrayList<Payment> getPaymentByBookingId(int bookingId) {
        ArrayList<Payment> result = new ArrayList<>();
        String sql = "SELECT * FROM PAYMENT WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int paymentId = rs.getInt("PaymentID");
                    LocalDate paymentDate = rs.getObject("PaymentDate", LocalDate.class);
                    double amount = rs.getDouble("Amount");
                    String paymentMethod = rs.getString("PaymentMethod");
                    String status = rs.getString("Status");
                    result.add(new Payment(paymentId, bookingId, paymentDate, amount, paymentMethod, status));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE PAYMENT SET Status = ? WHERE PaymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public ArrayList<Payment> getPaymentList() {
        ArrayList<Payment> result = new ArrayList<>();

        String sql = "SELECT TOP (1000) [PaymentID],[BookingID],[PaymentDate],[Amount],[PaymentMethod],[Status] FROM [HotelManagement].[dbo].[PAYMENT]";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("PaymentID"));
                    payment.setBookingId(rs.getInt("BookingID"));
                    payment.setPaymentDate(rs.getObject("PaymentDate", LocalDate.class));
                    payment.setAmount(rs.getDouble("Amount"));
                    payment.setPaymentMethod(rs.getString("PaymentMethod"));
                    payment.setStatus(rs.getString("Status"));
                    result.add(payment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
    
    public boolean addPayment(Payment payment) {
        boolean result = false;

        String sql = "INSERT INTO [HotelManagement].[dbo].[PAYMENT] ([BookingID], [PaymentDate], [Amount], [PaymentMethod], [Status]) VALUES (?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, payment.getBookingId());
            ps.setObject(2, payment.getPaymentDate());
            ps.setDouble(3, payment.getAmount());
            ps.setString(4, payment.getPaymentMethod());
            ps.setString(5, payment.getStatus());
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Thêm payment mới với transaction (nhận Connection từ bên ngoài)
     * @param payment Đối tượng payment cần thêm
     * @param conn Connection đã được quản lý transaction
     * @return true nếu thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi database
     */
    public boolean addPaymentWithTransaction(Payment payment, Connection conn) throws SQLException {
        String sql = "INSERT INTO [HotelManagement].[dbo].[PAYMENT] ([BookingID], [PaymentDate], [Amount], [PaymentMethod], [Status]) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setObject(2, payment.getPaymentDate());
            ps.setDouble(3, payment.getAmount());
            ps.setString(4, payment.getPaymentMethod());
            ps.setString(5, payment.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy tất cả payments kèm theo room number và guest name
     * @return ArrayList chứa PaymentWithRoomDTO
     */
    public ArrayList<PaymentWithRoomDTO> getAllPaymentsWithRoomInfo() {
        ArrayList<PaymentWithRoomDTO> result = new ArrayList<>();
        String sql = "SELECT P.PaymentID, P.BookingID, P.PaymentDate, P.Amount, P.PaymentMethod, P.Status, " +
                     "R.RoomNumber, G.FullName " +
                     "FROM PAYMENT P " +
                     "INNER JOIN BOOKING B ON P.BookingID = B.BookingID " +
                     "INNER JOIN ROOM R ON B.RoomID = R.RoomID " +
                     "INNER JOIN GUEST G ON B.GuestID = G.GuestID " +
                     "ORDER BY P.PaymentDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                PaymentWithRoomDTO dto = new PaymentWithRoomDTO();
                dto.setPaymentId(rs.getInt("PaymentID"));
                dto.setBookingId(rs.getInt("BookingID"));
                dto.setRoomNumber(rs.getString("RoomNumber"));
                dto.setPaymentDate(rs.getObject("PaymentDate", LocalDate.class));
                dto.setAmount(rs.getDouble("Amount"));
                dto.setPaymentMethod(rs.getString("PaymentMethod"));
                dto.setStatus(rs.getString("Status"));
                dto.setGuestName(rs.getString("FullName"));
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Tìm kiếm payments theo room number
     * @param roomNumber Số phòng cần tìm
     * @return ArrayList chứa PaymentWithRoomDTO
     */
    public ArrayList<PaymentWithRoomDTO> searchPaymentsByRoomNumber(String roomNumber) {
        ArrayList<PaymentWithRoomDTO> result = new ArrayList<>();
        String sql = "SELECT P.PaymentID, P.BookingID, P.PaymentDate, P.Amount, P.PaymentMethod, P.Status, " +
                     "R.RoomNumber, G.FullName " +
                     "FROM PAYMENT P " +
                     "INNER JOIN BOOKING B ON P.BookingID = B.BookingID " +
                     "INNER JOIN ROOM R ON B.RoomID = R.RoomID " +
                     "INNER JOIN GUEST G ON B.GuestID = G.GuestID " +
                     "WHERE R.RoomNumber LIKE ? " +
                     "ORDER BY P.PaymentDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + roomNumber + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                PaymentWithRoomDTO dto = new PaymentWithRoomDTO();
                dto.setPaymentId(rs.getInt("PaymentID"));
                dto.setBookingId(rs.getInt("BookingID"));
                dto.setRoomNumber(rs.getString("RoomNumber"));
                dto.setPaymentDate(rs.getObject("PaymentDate", LocalDate.class));
                dto.setAmount(rs.getDouble("Amount"));
                dto.setPaymentMethod(rs.getString("PaymentMethod"));
                dto.setStatus(rs.getString("Status"));
                dto.setGuestName(rs.getString("FullName"));
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

}
