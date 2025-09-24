package model;

import java.math.BigDecimal;

/**
 * Model cho bảng INVOICE
 */
public class Invoice {
    private int invoiceId;
    private Booking booking; // Quan hệ khóa ngoại đến BOOKING
    private String issueDate;
    private BigDecimal totalAmount;
    private String status;

    // Constructors
    public Invoice() {}

    public Invoice(int invoiceId, Booking booking, String issueDate, BigDecimal totalAmount, String status) {
        this.invoiceId = invoiceId;
        this.booking = booking;
        this.issueDate = issueDate;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    // Getters and Setters
    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public String getIssueDate() { return issueDate; }
    public void setIssueDate(String issueDate) { this.issueDate = issueDate; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Invoice{" + "invoiceId=" + invoiceId + ", bookingId=" + booking.getBookingId() + ", totalAmount=" + totalAmount + ", status='" + status + '\'' + '}';
    }
}