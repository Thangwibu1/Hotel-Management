package model;

import java.time.LocalDate; // THAY �?ỔI: Thêm import cho LocalDate

/**
 * Model cho bảng BOOKING_SERVICE
 * (�?ã được cập nhật để sử dụng LocalDate cho serviceDate)
 */
public class BookingService {
    private int bookingServiceId;
    private int bookingId;
    private int serviceId;
    private int quantity;
    private LocalDate serviceDate; 
    private int status;
    private String note;
    // --- Constructors được cập nhật ---
    public BookingService() {}

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public BookingService(int bookingServiceId, int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status, String note) {
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
        this.note = note;
    }
    
    

    public BookingService(int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status) {
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
    }

    public BookingService(int bookingServiceId, int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status) { 
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
    }

    public int getBookingServiceId() { return bookingServiceId; }
    public void setBookingServiceId(int bookingServiceId) { this.bookingServiceId = bookingServiceId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public BookingService(int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status, String note) {
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
        this.note = note;
    }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public LocalDate getServiceDate() { return serviceDate; } 
    public void setServiceDate(LocalDate serviceDate) { this.serviceDate = serviceDate; } 
    
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    // --- THAY �?ỔI: toString() được cập nhật ---
    @Override
    public String toString() {
        return "BookingService{" +
                "bookingServiceId=" + bookingServiceId +
                ", bookingId=" + bookingId +
                ", serviceId=" + serviceId +
                ", quantity=" + quantity +
                ", serviceDate=" + serviceDate + 
                ", status=" + status +
                '}';
    }
}