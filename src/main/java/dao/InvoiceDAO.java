package dao;

import model.Invoice;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public List<Invoice> getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM INVOICE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                invoices.add(mapResultSetToInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT * FROM INVOICE WHERE InvoiceID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Invoice getInvoiceByBookingId(int bookingId) {
        String sql = "SELECT * FROM INVOICE WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Invoice> getInvoicesByDate(Date issueDate) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM INVOICE WHERE IssueDate = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, issueDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapResultSetToInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    public boolean addInvoice(Invoice invoice) {
        String sql = "INSERT INTO INVOICE (BookingID, IssueDate, Price, Discount, Tax, TotalAmount, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoice.getBookingId());
            ps.setDate(2, invoice.getIssueDate());
            ps.setDouble(3, invoice.getPrice());
            ps.setDouble(4, invoice.getDiscount());
            ps.setDouble(5, invoice.getTax());
            ps.setDouble(6, invoice.getTotalAmount());
            ps.setString(7, invoice.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Invoice mapResultSetToInvoice(ResultSet rs) throws SQLException {
        return new Invoice(
                rs.getInt("InvoiceID"),
                rs.getInt("BookingID"),
                rs.getDate("IssueDate"),
                rs.getDouble("Price"),
                rs.getDouble("Discount"),
                rs.getDouble("Tax"),
                rs.getDouble("TotalAmount"),
                rs.getString("Status")
        );
    }
}