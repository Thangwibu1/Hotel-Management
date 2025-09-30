package dao;

import model.Room;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class RoomDAO {

    public ArrayList<Room> getAllRoom() {
        ArrayList<Room> result = new ArrayList<Room>();
        String sql = "SELECT [RoomID] ,[RoomNumber] ,[RoomTypeID] ,[Description] ,[Status] FROM [HotelManagement].[dbo].[ROOM]";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("RoomID"));
                room.setRoomNumber(rs.getString("RoomNumber"));
                room.setRoomTypeId(rs.getInt("RoomTypeID"));
                room.setDescription(rs.getString("Description"));
                room.setStatus(rs.getString("Status"));

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

    public Room getRoomById(int roomId) {
        Room room = null;
        String sql = "SELECT [RoomID] ,[RoomNumber] ,[RoomTypeID] ,[Description] ,[Status] FROM [HotelManagement].[dbo].[ROOM] WHERE [RoomID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("RoomID");
                String roomNumber = rs.getString("RoomNumber");
                int roomTypeId = rs.getInt("RoomTypeID");
                String description = rs.getString("Description");
                String status = rs.getString("Status");
                room = new Room(id, roomNumber, roomTypeId, description, status);

            }
        } catch (SQLException e) {
            System.err.println("Database error in getRoomById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getRoomById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return room;
    }

    public boolean updateRoomStatus(int roomId, String status) {
        boolean result = false;

        String sql = "UPDATE ROOM SET Status = ? WHERE RoomID = ? ";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, roomId);
            boolean rowsAffected = ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return result;
    }

}