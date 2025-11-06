/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author trinhdtu
 */
public class CancellationStat {
     private int month;         
    private int canceledBookings;
    private int totalBookings; 

    public CancellationStat() {
    }

    public CancellationStat(int month, int canceledBookings, int totalBookings) {
        this.month = month;
        this.canceledBookings = canceledBookings;
        this.totalBookings = totalBookings;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getCanceledBookings() {
        return canceledBookings;
    }

    public void setCanceledBookings(int canceledBookings) {
        this.canceledBookings = canceledBookings;
    }

    public int getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }
}
