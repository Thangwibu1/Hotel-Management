/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author trinhdtu
 */
public class FrequentGuest {
    private int guestId;
    private String fullName;
    private String email;
    private int bookingCount;
    private int totalNights;

    public FrequentGuest() {
    }

    public FrequentGuest(int guestId, String fullName, String email, int bookingCount, int totalNights) {
        this.guestId = guestId;
        this.fullName = fullName;
        this.email = email;
        this.bookingCount = bookingCount;
        this.totalNights = totalNights;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getBookingCount() {
        return bookingCount;
    }

    public void setBookingCount(int bookingCount) {
        this.bookingCount = bookingCount;
    }

    public int getTotalNights() {
        return totalNights;
    }

    public void setTotalNights(int totalNights) {
        this.totalNights = totalNights;
    }
    
    
}
