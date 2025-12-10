/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author TranHongGam
 */
public class AssignTask {
    private String assignTaskID;
    private LocalDateTime lastTimeAssign;

    public AssignTask(String assignTaskID, LocalDateTime lastTimeAssign) {
        this.assignTaskID = "ASS01";
        this.lastTimeAssign = lastTimeAssign;
    }

    public String getAssignTaskID() {
        return assignTaskID;
    }

    public void setAssignTaskID(String assignTaskID) {
        this.assignTaskID = assignTaskID;
    }

    public LocalDateTime getLastTimeAssign() {
        return lastTimeAssign;
    }

    public void setLastTimeAssign(LocalDateTime lastTimeAssign) {
        this.lastTimeAssign = lastTimeAssign;
    }

    @Override
    public String toString() {
        return "AssignTask{" + "assignTaskID=" + assignTaskID + ", lastTimeAssign=" + lastTimeAssign + '}';
    }

    public AssignTask() {
        this.assignTaskID = "ASS01";
        this.lastTimeAssign = null;
    }

    public AssignTask(LocalDateTime lastTimeAssign) {
        this.assignTaskID = "ASS01";
        this.lastTimeAssign = lastTimeAssign;
    }
    
    
}
