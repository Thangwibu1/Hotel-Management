package model;

/**
 * Model cho bảng BOOKING
 * (Đã được cập nhật để sử dụng guestId và roomId kiểu int)
 */
public class Booking {
    // --- THAY ĐỔI: Thuộc tính
    private int bookingId;
    private int guestId; // Đổi từ 'Guest guest' thành 'int guestId'
    private int roomId;  // Đổi từ 'Room room' thành 'int roomId'
    private String checkInDate;
    private String checkOutDate;
    private String bookingDate;
    private String status;

    // --- Constructors được cập nhật
    public Booking() {}

    public Booking(int guestId, int roomId, String checkInDate, String checkOutDate, String bookingDate, String status) {
        this.guestId = guestId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    public Booking(int bookingId, int guestId, int roomId, String checkInDate, String checkOutDate, String bookingDate, String status) {
        this.bookingId = bookingId;
        this.guestId = guestId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    // --- Getters and Setters được cập nhật
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // --- THAY ĐỔI: toString() được cập nhật để hiển thị ID
    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", guestId=" + guestId +      // Hiển thị guestId
                ", roomId=" + roomId +        // Hiển thị roomId
                ", checkInDate='" + checkInDate + '\'' +
                ", checkOutDate='" + checkOutDate + '\'' +
                ", bookingDate='" + bookingDate + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}