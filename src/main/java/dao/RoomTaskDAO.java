/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.RoomTask;
import utils.DBConnection;

/**
 *
 * @author TranHongGam
 */
public class RoomTaskDAO {
    public ArrayList<RoomTask> getAllRoom() {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID] ,[RoomID],[StaffID],[StartTime],[EndTime],[StatusClean],[Notes] FROM [HotelManagement].[dbo].[ROOM_TASK]";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStaffID(rs.getInt("StaffID"));
                room.setStatusClean(rs.getString("StatusClean"));
                
                result.add(room);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllRoom: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getAllRoom: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources in reverse order
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    public ArrayList<RoomTask> getAllRoomV2() {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID] ,[RoomID],[StaffID],[StartTime],[EndTime],[StatusClean],[Notes] FROM [HotelManagement].[dbo].[ROOM_TASK]";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStaffID(rs.getInt("StaffID"));
                room.setStartTime(rs.getString("StartTime"));
                room.setEndTime(rs.getString("EndTime"));
                room.setStatusClean(rs.getString("StatusClean"));
                room.setNotes(rs.getString("Notes"));
                result.add(room);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllRoom: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getAllRoom: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources in reverse order
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }
    
    public ArrayList<RoomTask> getRoomBaseStatus(String statusClean) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean] FROM [HotelManagement].[dbo].[ROOM_TASK] WHERE [StatusClean] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, statusClean);
            rs = ps.executeQuery();

            while (rs.next()) {
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStatusClean(rs.getString("StatusClean"));

                result.add(room);
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

        return result;
    }
    public int updateStatusRoomTask(int roomTaskID, String statusCleanUpdate) {
        String sql = "UPDATE [HotelManagement].[dbo].[ROOM_TASK] SET [StatusClean] = ? WHERE [RoomTaskID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, statusCleanUpdate);
            ps.setInt(2, roomTaskID);

            rowsAffected = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Database error  " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            
            System.err.println("General error " + e.getMessage());
            e.printStackTrace();
        } finally {
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

        return rowsAffected;
    }

    public ArrayList<RoomTask> getRoomTaskByStaffId(int staffId) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();

        String sql = "SELECT [RoomTaskID] ,[RoomID],[StaffID],[StartTime],[EndTime],[StatusClean],[Notes] FROM [HotelManagement].[dbo].[ROOM_TASK] where [StaffID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("RoomTaskID");
                int roomId = rs.getInt("RoomID");
                // int staffId = rs.getInt("StaffID");
                String startTime = rs.getString("StartTime");
                String endTime = rs.getString("EndTime");
                String statusClean = rs.getString("StatusClean");
                String notes = rs.getString("Notes");
                RoomTask roomTask = new RoomTask(id, roomId, staffId, startTime, endTime, statusClean, notes);
                result.add(roomTask);
            }
        } catch (Exception e) {
            
        }

        return result;
    }
}
