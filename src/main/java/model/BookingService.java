package model;

/**
 * Model cho bảng BOOKING_SERVICE
 */
public class BookingService {
    private int bookingServiceId;
    private Booking booking; // Quan hệ khóa ngoại đến BOOKING
    private Service service; // Quan hệ khóa ngoại đến SERVICE
    private int quantity;
    private String serviceDate;

    // Constructors
    public BookingService() {}

    public BookingService(int bookingServiceId, Booking booking, Service service, int quantity, String serviceDate) {
        this.bookingServiceId = bookingServiceId;
        this.booking = booking;
        this.service = service;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
    }

    // Getters and Setters
    public int getBookingServiceId() { return bookingServiceId; }
    public void setBookingServiceId(int bookingServiceId) { this.bookingServiceId = bookingServiceId; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public Service getService() { return service; }
    public void setService(Service service) { this.service = service; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getServiceDate() { return serviceDate; }
    public void setServiceDate(String serviceDate) { this.serviceDate = serviceDate; }

    @Override
    public String toString() {
        return "BookingService{" + "bookingServiceId=" + bookingServiceId + ", service=" + service.getServiceName() + ", quantity=" + quantity + '}';
    }
}