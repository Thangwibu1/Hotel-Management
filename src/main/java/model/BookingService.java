package model;

/**
 * Model cho bảng BOOKING_SERVICE
 * (Đã được cập nhật để sử dụng bookingId và serviceId kiểu int)
 */
public class BookingService {
    // --- THAY ĐỔI: Thuộc tính ---
    private int bookingServiceId;
    private int bookingId; // Đổi từ 'Booking booking' thành 'int bookingId'
    private int serviceId; // Đổi từ 'Service service' thành 'int serviceId'
    private int quantity;
    private String serviceDate;

    // --- Constructors được cập nhật ---
    public BookingService() {}

    public BookingService(int bookingId, int serviceId, int quantity, String serviceDate) {
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
    }

    public BookingService(int bookingServiceId, int bookingId, int serviceId, int quantity, String serviceDate) {
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
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

    public String getServiceDate() { return serviceDate; }
    public void setServiceDate(String serviceDate) { this.serviceDate = serviceDate; }

    // --- THAY ĐỔI: toString() được cập nhật để hiển thị ID ---
    @Override
    public String toString() {
        return "BookingService{" +
                "bookingServiceId=" + bookingServiceId +
                ", bookingId=" + bookingId +         // Hiển thị bookingId
                ", serviceId=" + serviceId +         // Hiển thị serviceId
                ", quantity=" + quantity +
                ", serviceDate='" + serviceDate + '\'' +
                '}';
    }
}