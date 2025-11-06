package model;

import java.math.BigDecimal;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author trinhdtu
 */
public class RevenueRow {

    private String period;
    private BigDecimal revenue;
    private int roomsSold;
    private double change;

    public RevenueRow() {
    }

    public RevenueRow(String period, BigDecimal revenue, int roomsSold, double change) {
        this.period = period;
        this.revenue = revenue;
        this.roomsSold = roomsSold;
        this.change = change;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public int getRoomsSold() {
        return roomsSold;
    }

    public void setRoomsSold(int roomsSold) {
        this.roomsSold = roomsSold;
    }

    public double getChange() {
        return change;
    }

    public void setChange(double change) {
        this.change = change;
    }

    
}
