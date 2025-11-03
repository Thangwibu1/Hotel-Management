package model;

import java.time.LocalDateTime;
// B?n c?n import java.time.LocalDateTime

public class RoomTask {
    private int roomTaskID;
    private int roomID;
    private Integer staffID;
    private LocalDateTime startTime; 
    private LocalDateTime endTime;   
    private String statusClean;
    private String notes;
    private int isSystemTask;

    public RoomTask() {
    }

    public RoomTask(
        int roomID,            
        Integer staffID,       
        LocalDateTime startTime,
        LocalDateTime endTime,  
        String statusClean,     
        String notes,
        int isSystemTask
    ) {
        this.roomID = roomID;
        this.staffID = staffID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.statusClean = statusClean;
        this.notes = notes;
        this.isSystemTask = isSystemTask;
       
    }

    public RoomTask(int roomTaskID, int roomID, int staffID, LocalDateTime startTime, LocalDateTime endTime, String statusClean, String notes, int isSystemTask) {
        this.roomTaskID = roomTaskID;
        this.roomID = roomID;
        this.staffID = staffID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.statusClean = statusClean;
        this.notes = notes;
        this.isSystemTask = isSystemTask;
    }
//[RoomID], [StaffID], [StartTime], [EndTime], [StatusClean], [Notes])
    public RoomTask(int roomID, String statusClean , LocalDateTime startTime) {
        this.roomTaskID = 0;
        this.roomID = roomID;
        this.staffID = null;
        this.startTime = startTime;
        this.endTime = null;
        this.statusClean = statusClean;
        this.notes = "";
        this.isSystemTask = 0;
        
    }

    public RoomTask(int roomId, Object object, LocalDateTime now, Object object0, String pending, Object object1) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


    public LocalDateTime getStartTime() {
        return startTime;
    }


    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public int getRoomTaskID() {
        return roomTaskID;
    }

    public void setRoomTaskID(int roomTaskID) {
        this.roomTaskID = roomTaskID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public Integer getStaffID() {
        return staffID;
    }

    public void setStaffID(Integer staffID) {
        this.staffID = staffID;
    }

    public String getStatusClean() {
        return statusClean;
    }

    public void setStatusClean(String statusClean) {
        this.statusClean = statusClean;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public int getIsSystemTask() {
        return isSystemTask;
    }

    public void setIsSystemTask(int isSystemTask) {
        this.isSystemTask = isSystemTask;
    }

    @Override
    public String toString() {
        return "RoomTask{" + "roomTaskID=" + roomTaskID + ", roomID=" + roomID + ", staffID=" + staffID + ", startTime=" + startTime + ", endTime=" + endTime + ", statusClean=" + statusClean + ", notes=" + notes + ", isSystemTask=" + isSystemTask + '}';
    }
    

}