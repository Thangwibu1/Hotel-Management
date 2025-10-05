/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author TranHongGam
 */
public class RoomTask {
    private int roomTaskID;
    private int roomID;
    private String statusClean;

    public RoomTask(int roomTaskID, int roomID, String statusClean) {
        this.roomTaskID = roomTaskID;
        this.roomID = roomID;
        this.statusClean = statusClean;
    }

    public RoomTask() {
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

    public String getStatusClean() {
        return statusClean;
    }

    public void setStatusClean(String statusClean) {
        this.statusClean = statusClean;
    }
    
}
