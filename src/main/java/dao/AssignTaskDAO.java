/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.AssignTask;
import utils.DBConnection;
/**
 *
 * @author TranHongGam
 */
public class AssignTaskDAO {
    public LocalDateTime getLastTimeAssign(){
        String sql = "SELECT * FROM ASSIGN_TASK WHERE ID = ? ;";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        AssignTask lasstTimeAssignTask = new AssignTask();
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, "ASS01");
            rs = ps.executeQuery();

            while (rs.next()) {
                lasstTimeAssignTask.setAssignTaskID(rs.getString("ID"));
                lasstTimeAssignTask.setLastTimeAssign(rs.getObject("LastTimeAssign", java.time.LocalDateTime.class));
            }
        } catch (SQLException e) {
            System.err.println("Database error in getRoomBaseStatus: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getRoomBaseStatus: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        
        return lasstTimeAssignTask.getLastTimeAssign();
    }

public boolean updateAssignTaskTime(String assignTaskId, LocalDateTime newTimeAssign) {
    String sql = "UPDATE ASSIGN_TASK SET LastTimeAssign = ? WHERE ID = ?";
    Connection con = null;
    PreparedStatement ps = null;
    int rowsUpdated = 0;

    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement(sql);

        ps.setTimestamp(1, Timestamp.valueOf(newTimeAssign));
        
        ps.setString(2, assignTaskId);
        
        rowsUpdated = ps.executeUpdate(); 

    } catch (SQLException e) {
            System.err.println("Database error in updateAssignTaskTime: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in updateAssignTaskTime: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // ?óng tài nguyên
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        return rowsUpdated > 0;
    }
}
