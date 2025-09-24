package model;

/**
 * Model cho bảng BOOKING
 */
public class Booking {
    private int bookingId;
    private Guest guest; // Quan hệ khóa ngoại đến GUEST
    private Room room;   // Quan hệ khóa ngoại đến ROOM
    private String checkInDate;
    private String checkOutDate;
    private String bookingDate;
    private String status;

    // Constructors
    public Booking() {}

    public Booking(int bookingId, Guest guest, Room room, String checkInDate, String checkOutDate, String bookingDate, String status) {
        this.bookingId = bookingId;
        this.guest = guest;
        this.room = room;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public Guest getGuest() { return guest; }
    public void setGuest(Guest guest) { this.guest = guest; }

    public Room getRoom() { return room; }
    public void setRoom(Room room) { this.room = room; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Booking{" + "bookingId=" + bookingId + ", guest=" + guest.getFullName() + ", room=" + room.getRoomNumber() + ", status='" + status + '\'' + '}';
    }
}