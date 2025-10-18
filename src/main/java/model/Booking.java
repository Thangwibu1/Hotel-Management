package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model cho bảng BOOKING
 * (Đã được cập nhật để sử dụng LocalDate và LocalDateTime)
 */
public class Booking {
    private int bookingId;
    private int guestId;
    private int roomId;
    private LocalDateTime checkInDate;  // THAY ĐỔI: Kiểu LocalDateTime
    private LocalDateTime checkOutDate; // THAY ĐỔI: Kiểu LocalDateTime
    private LocalDate bookingDate;    // THAY ĐỔI: Kiểu LocalDate
    private String status;

    // Constructors
    public Booking() {}

    public Booking(int bookingId, int roomId, LocalDateTime checkInDate, LocalDateTime checkOutDate) {
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
    }

    public Booking(int guestId, int roomId, LocalDateTime checkInDate, LocalDateTime checkOutDate, LocalDate bookingDate, String status) {
        this.guestId = guestId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    public Booking(int bookingId, int guestId, int roomId, LocalDateTime checkInDate, LocalDateTime checkOutDate, LocalDate bookingDate, String status) {
        this.bookingId = bookingId;
        this.guestId = guestId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    // Getters and Setters được cập nhật
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public LocalDateTime getCheckInDate() { return checkInDate; } // THAY ĐỔI
    public void setCheckInDate(LocalDateTime checkInDate) { this.checkInDate = checkInDate; } // THAY ĐỔI

    public LocalDateTime getCheckOutDate() { return checkOutDate; } // THAY ĐỔI
    public void setCheckOutDate(LocalDateTime checkOutDate) { this.checkOutDate = checkOutDate; } // THAY ĐỔI

    public LocalDate getBookingDate() { return bookingDate; } // THAY ĐỔI
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; } // THAY ĐỔI

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", guestId=" + guestId +
                ", roomId=" + roomId +
                ", checkInDate=" + checkInDate + // Sẽ tự động gọi .toString() của LocalDateTime
                ", checkOutDate=" + checkOutDate +
                ", bookingDate=" + bookingDate +
                ", status='" + status + '\'' +
                '}';
    }
}