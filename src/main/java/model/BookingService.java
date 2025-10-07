package model;

import java.time.LocalDate; // THAY ĐỔI: Thêm import cho LocalDate

/**
 * Model cho bảng BOOKING_SERVICE
 * (Đã được cập nhật để sử dụng LocalDate cho serviceDate)
 */
public class BookingService {
    private int bookingServiceId;
    private int bookingId;
    private int serviceId;
    private int quantity;
    private LocalDate serviceDate; // THAY ĐỔI: Kiểu dữ liệu thành LocalDate
    private int status;

    // --- Constructors được cập nhật ---
    public BookingService() {}

    public BookingService(int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status) { // THAY ĐỔI
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
    }

    public BookingService(int bookingServiceId, int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status) { // THAY ĐỔI
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
    }

    // --- Getters and Setters được cập nhật ---
    public int getBookingServiceId() { return bookingServiceId; }
    public void setBookingServiceId(int bookingServiceId) { this.bookingServiceId = bookingServiceId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public LocalDate getServiceDate() { return serviceDate; } // THAY ĐỔI
    public void setServiceDate(LocalDate serviceDate) { this.serviceDate = serviceDate; } // THAY ĐỔI
    
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    // --- THAY ĐỔI: toString() được cập nhật ---
    @Override
    public String toString() {
        return "BookingService{" +
                "bookingServiceId=" + bookingServiceId +
                ", bookingId=" + bookingId +
                ", serviceId=" + serviceId +
                ", quantity=" + quantity +
                ", serviceDate=" + serviceDate + // Bỏ dấu nháy đơn, sẽ tự gọi .toString() của LocalDate
                ", status=" + status +
                '}';
    }
}