package model;

import java.io.Serializable;
import java.time.LocalDate; 


public class BookingService implements Serializable{
    private int bookingServiceId;
    private int bookingId;
    private int serviceId;
    private int quantity;
    private LocalDate serviceDate; 
    private int status;
    private String note;
    private int staffID;

 

    public int getStaffID() {
        return staffID;
    }

    public BookingService(int bookingServiceId, int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status, String note, int staffID) {
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
        this.note = note;
        this.staffID = staffID;
    }

    public BookingService(int bookingServiceId, int bookingId, int serviceId, int quantity, LocalDate serviceDate, int status, int staffID) {
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
        this.staffID = staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }
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
        this.staffID = 0;
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
                ", staffID=" + staffID +
                '}';
    }
}