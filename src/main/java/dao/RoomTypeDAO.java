package dao;

import model.Room;
import model.RoomType;
import utils.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class RoomTypeDAO {
    public ArrayList<RoomType> getAllRoomType() {
        ArrayList<RoomType> result = new ArrayList<RoomType>();

        String sql = "  SELECT [RoomTypeID] ,[TypeName], [Capacity] ,[PricePerNight] FROM [HotelManagement].[dbo].[ROOM_TYPE]";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("RoomTypeID");
                String typeName = rs.getString("TypeName");
                int capacity = rs.getInt("Capacity");
                BigDecimal pricePerNight = rs.getBigDecimal("PricePerNight");
                RoomType roomType = new RoomType(id, typeName, capacity, pricePerNight);

                result.add(roomType);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllRoomType: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getAllRoomType: " + e.getMessage());
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

    public RoomType getRoomTypeById(int roomTypeId) {
        RoomType roomType = null;
        String sql = "SELECT [TypeID], [TypeName], [Capacity], [PricePerNight] FROM ROOM_TYPE WHERE [TypeID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomTypeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("TypeID");
                String typeName = rs.getString("TypeName");
                int capacity = rs.getInt("Capacity");
                BigDecimal pricePerNight = rs.getBigDecimal("PricePerNight");
                roomType = new RoomType(id, typeName, capacity, pricePerNight);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getRoomTypeById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getRoomTypeById: " + e.getMessage());
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

        return roomType;
    }
}