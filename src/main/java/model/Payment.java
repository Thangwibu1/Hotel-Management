package model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Model cho bảng PAYMENT
 */
public class Payment {
    private int paymentId;
    private Booking booking; // Quan hệ khóa ngoại đến BOOKING
    private LocalDate paymentDate;
    private BigDecimal amount;
    private String paymentMethod;
    private String status;

    // Constructors
    public Payment() {}

    public Payment(int paymentId, Booking booking, LocalDate paymentDate, BigDecimal amount, String paymentMethod, String status) {
        this.paymentId = paymentId;
        this.booking = booking;
        this.paymentDate = paymentDate;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
    }

    // Getters and Setters
    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public LocalDate getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDate paymentDate) { this.paymentDate = paymentDate; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Payment{" + "paymentId=" + paymentId + ", bookingId=" + booking.getBookingId() + ", amount=" + amount + ", status='" + status + '\'' + '}';
    }
}