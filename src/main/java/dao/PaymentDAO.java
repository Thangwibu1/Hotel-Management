package dao;

import java.sql.*;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.ArrayList;

import model.Payment;
import utils.DBConnection;

public class PaymentDAO {

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

}
