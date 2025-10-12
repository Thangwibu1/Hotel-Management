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
}
