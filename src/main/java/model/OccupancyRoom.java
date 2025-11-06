/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author trinhdtu
 */
public class OccupancyRoom {

    private int year, month;
    private int totalRoomNights, availableRoomNights;
    private double occupancyRatePercentage;

    public OccupancyRoom() {
    }

    public OccupancyRoom(int year, int month, int totalRoomNights, int availableRoomNights, double occupancyRatePercentage) {
        this.year = year;
        this.month = month;
        this.totalRoomNights = totalRoomNights;
        this.availableRoomNights = availableRoomNights;
        this.occupancyRatePercentage = occupancyRatePercentage;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getTotalRoomNights() {
        return totalRoomNights;
    }

    public void setTotalRoomNights(int totalRoomNights) {
        this.totalRoomNights = totalRoomNights;
    }

    public int getAvailableRoomNights() {
        return availableRoomNights;
    }

    public void setAvailableRoomNights(int availableRoomNights) {
        this.availableRoomNights = availableRoomNights;
    }

    public double getOccupancyRatePercentage() {
        return occupancyRatePercentage;
    }

    public void setOccupancyRatePercentage(double occupancyRatePercentage) {
        this.occupancyRatePercentage = occupancyRatePercentage;
    }

}
