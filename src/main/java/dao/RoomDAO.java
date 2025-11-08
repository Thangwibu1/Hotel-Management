package dao;

import java.math.BigDecimal;
import model.Room;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import model.RoomInformation;
import model.RoomType;

public class RoomDAO {

    public static Connection getConnection() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

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

        return room;
    }

    public Room getRoomByRoomNumber(String roomNumber) {
        Room room = null;
        String sql = "SELECT [RoomID] ,[RoomNumber] ,[RoomTypeID] ,[Description] ,[Status] FROM [HotelManagement].[dbo].[ROOM] WHERE [RoomNumber] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, roomNumber);
            rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("RoomID");
                String retrievedRoomNumber = rs.getString("RoomNumber");
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

        return room;
    }

    public ArrayList<Room> getRoomsByStatus(String status) {
        ArrayList<Room> result = new ArrayList<Room>();
        String sql = "SELECT [RoomID] ,[RoomNumber] ,[RoomTypeID] ,[Description] ,[Status] FROM [HotelManagement].[dbo].[ROOM] WHERE [Status] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
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
            System.err.println("Database error in getRoomsByStatus: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getRoomsByStatus: " + e.getMessage());
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

        return result;
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
            result = ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    public int getRoomTypeIdByRoomId(int roomId) {
        int result = 0;
        String sql = "SELECT RoomTypeID FROM ROOM WHERE RoomID = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomId);
            rs = ps.executeQuery();
            if (rs.next()) {
                result = rs.getInt("RoomTypeID");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    public int countAvailableRoom(String status) {
        int result = 0;
        String sql = "SELECT COUNT([RoomID]) as total\n"
                + "  FROM [HotelManagement].[dbo].[ROOM]\n"
                + "  WHERE [Status] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public int countRoom() {
        int result = 0;
        String sql = "SELECT COUNT([RoomID]) as total\n"
                + "  FROM [HotelManagement].[dbo].[ROOM]\n";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<RoomInformation> getAvailableRoomsForBookingEdit(int bookingId,
            int roomTypeId, int currentRoomId, LocalDateTime targetCheckIn, LocalDateTime targetCheckOut) throws ClassNotFoundException {

        ArrayList<RoomInformation> result = new ArrayList<>();

        String sql = "SELECT r.RoomID,\n"
                + "               r.RoomNumber,\n"
                + "               rt.TypeName,\n"
                + "               rt.PricePerNight\n"
                + "        FROM ROOM r\n"
                + "        JOIN ROOM_TYPE rt ON r.RoomTypeID = rt.RoomTypeID\n"
                + "        WHERE r.RoomTypeID = ?\n"
                + "          AND (r.Status = 'Available' OR r.RoomID = ?)\n"
                + "          AND NOT EXISTS (\n"
                + "              SELECT 1\n"
                + "              FROM BOOKING b\n"
                + "              WHERE b.RoomID = r.RoomID\n"
                + "                AND b.BookingID <> ? \n"
                + "                AND b.Status IN ('Reserved','Checked-in')\n"
                + "                AND b.CheckInDate  < ?\n"
                + "                AND b.CheckOutDate > ?\n"
                + "          )\n"
                + "        ORDER BY rt.TypeName, r.RoomNumber";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, roomTypeId);
            ps.setInt(2, currentRoomId);
            ps.setInt(3, bookingId);
            ps.setTimestamp(4, Timestamp.valueOf(targetCheckOut));
            ps.setTimestamp(5, Timestamp.valueOf(targetCheckIn));

            rs = ps.executeQuery();
            while (rs.next()) {
                int roomId = rs.getInt("RoomID");
                String roomNum = rs.getString("RoomNumber");
                String typeName = rs.getString("TypeName");
                BigDecimal price = rs.getBigDecimal("PricePerNight");
                RoomInformation room = new RoomInformation(
                        new Room(roomNum, roomId),
                        new RoomType(typeName, price)
                );
                result.add(room);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return result;
    }

}
