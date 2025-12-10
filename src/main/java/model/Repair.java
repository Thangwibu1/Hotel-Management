package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Repair {
    private int repairId;
    private int roomDeviceId;
    private Integer staffId; // Có thể null
    private LocalDateTime reportDate;
    private LocalDateTime completionDate; // Có thể null
    private LocalDate nextDateMaintenance; // Có thể null
    private String description;
    private double cost;
    private String status; // Pending, In Progress, Completed, Canceled

    // Constructor mặc định
    public Repair() {
    }

    // Constructor đầy đủ
    public Repair(int repairId, int roomDeviceId, Integer staffId, LocalDateTime reportDate, 
                  LocalDateTime completionDate, LocalDate nextDateMaintenance, String description, 
                  double cost, String status) {
        this.repairId = repairId;
        this.roomDeviceId = roomDeviceId;
        this.staffId = staffId;
        this.reportDate = reportDate;
        this.completionDate = completionDate;
        this.nextDateMaintenance = nextDateMaintenance;
        this.description = description;
        this.cost = cost;
        this.status = status;
    }

    // Constructor không có repairId (dùng cho insert)
    public Repair(int roomDeviceId, Integer staffId, LocalDateTime reportDate, 
                  LocalDateTime completionDate, LocalDate nextDateMaintenance, String description, 
                  double cost, String status) {
        this.roomDeviceId = roomDeviceId;
        this.staffId = staffId;
        this.reportDate = reportDate;
        this.completionDate = completionDate;
        this.nextDateMaintenance = nextDateMaintenance;
        this.description = description;
        this.cost = cost;
        this.status = status;
    }

    // Getters and Setters
    public int getRepairId() {
        return repairId;
    }

    public void setRepairId(int repairId) {
        this.repairId = repairId;
    }

    public int getRoomDeviceId() {
        return roomDeviceId;
    }

    public void setRoomDeviceId(int roomDeviceId) {
        this.roomDeviceId = roomDeviceId;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public LocalDateTime getReportDate() {
        return reportDate;
    }

    public void setReportDate(LocalDateTime reportDate) {
        this.reportDate = reportDate;
    }

    public LocalDateTime getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(LocalDateTime completionDate) {
        this.completionDate = completionDate;
    }

    public LocalDate getNextDateMaintenance() {
        return nextDateMaintenance;
    }

    public void setNextDateMaintenance(LocalDate nextDateMaintenance) {
        this.nextDateMaintenance = nextDateMaintenance;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Repair{" +
                "repairId=" + repairId +
                ", roomDeviceId=" + roomDeviceId +
                ", staffId=" + staffId +
                ", reportDate=" + reportDate +
                ", completionDate=" + completionDate +
                ", nextDateMaintenance=" + nextDateMaintenance +
                ", description='" + description + '\'' +
                ", cost=" + cost +
                ", status='" + status + '\'' +
                '}';
    }
}

