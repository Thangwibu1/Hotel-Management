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
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;

import model.RoomTask;
import utils.DBConnection;

/**
 *
 * @author TranHongGam
 */
public class RoomTaskDAO {

    public HashMap<Integer, Integer> getRoomIdAndGuestIdByRoomTaskId(int roomTaskId) {
        HashMap<Integer, Integer> result = new HashMap<>();

        String sql = "select r.RoomID, b.GuestID from ROOM_TASK r join BOOKING b on r.RoomID = b.RoomID where r.RoomTaskID = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomTaskId);
            rs = ps.executeQuery();
            if (rs != null && rs.next()) {
                int roomId = rs.getInt("RoomID");
                int guestId = rs.getInt("GuestID");
                result.put(roomId, guestId);
            }
        } catch (Exception e) {
            System.err.println("General error in getRoomIdAndGuestIdByRoomTaskId: " + e.getMessage());
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

    // public boolean deleteRoomTaskForServiceByRoomId(int roomTaskId) {
    //     String sql = "DELETE FROM [HotelManagement].[dbo].[ROOM_TASK] WHERE [RoomTaskID] = ?";
    //     Connection con = null;
    //     PreparedStatement ps = null;
    //     int rowsAffected = 0;
    //     try {
    //         con = DBConnection.getConnection();
    //         ps = con.prepareStatement(sql);
    //         ps.setInt(1, roomTaskId);
    //         rowsAffected = ps.executeUpdate();
    //     } catch (Exception e) {
    //         System.err.println("General error in deleteRoomTaskForService: " + e.getMessage());
    //         e.printStackTrace();
    //     }
    //     return rowsAffected > 0;
    // }
    public boolean insertRoomTaskForServiceForTransaction(RoomTask roomTask, Connection conn) {
        String sql = "INSERT INTO [HotelManagement].[dbo].[ROOM_TASK] ([RoomID], [StartTime], [EndTime], [StatusClean], [Notes], [isSystemTask]) VALUES (?, ?, ?, ?, ?, ?)";

        int rowsAffected = 0;
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTask.getRoomID());
            ps.setObject(2, roomTask.getStartTime());
            ps.setObject(3, roomTask.getEndTime());
            ps.setString(4, roomTask.getStatusClean());
            ps.setString(5, null);
            ps.setInt(6, 0);
            rowsAffected = ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("General error in insertRoomTaskForService: " + e.getMessage());
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }

    public boolean insertRoomTaskForService(RoomTask roomTask) {
        String sql = "INSERT INTO [HotelManagement].[dbo].[ROOM_TASK] ([RoomID], [StartTime], [EndTime], [StatusClean], [Notes], [isSystemTask]) VALUES (?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomTask.getRoomID());
            ps.setObject(2, roomTask.getStartTime());
            ps.setObject(3, roomTask.getEndTime());
            ps.setString(4, roomTask.getStatusClean());
            ps.setString(5, null);
            ps.setInt(6, 0);
            rowsAffected = ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("General error in insertRoomTaskForService: " + e.getMessage());
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }

    public RoomTask getRoomTaskById(int roomTaskId) {
        RoomTask roomTask = null;
        String sql = "SELECT [RoomTaskID] ,[RoomID],[StaffID],[StartTime],[EndTime],[StatusClean],[Notes],[isSystemTask] FROM [HotelManagement].[dbo].[ROOM_TASK] WHERE [RoomTaskID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomTaskId);
            rs = ps.executeQuery();
            if (rs.next()) {
                int roomId = rs.getInt("RoomID");
                int staffId = rs.getInt("StaffID");
                LocalDateTime startTime = rs.getObject("StartTime", LocalDateTime.class);
                LocalDateTime endTime = rs.getObject("EndTime", LocalDateTime.class);
                String statusClean = rs.getString("StatusClean");
                String notes = rs.getString("Notes");
                int isSystemTask = rs.getInt("isSystemTask");
                roomTask = new RoomTask(roomTaskId, roomId, staffId, startTime, endTime, statusClean, notes, isSystemTask);
            }
        } catch (Exception e) {
            System.err.println("General error in getRoomTaskById: " + e.getMessage());
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
        return roomTask;
    }

    public ArrayList<RoomTask> getAllRoom() {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID] ,[RoomID],[StaffID],[StartTime],[EndTime],[StatusClean],[Notes],[isSystemTask] FROM [HotelManagement].[dbo].[ROOM_TASK]";
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
                room.setIsSystemTask(rs.getInt("isSystemTask"));
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
    //ham nay lay het theo 

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
                room.setStartTime(LocalDateTime.parse(rs.getString("StartTime")));
                room.setEndTime(LocalDateTime.parse(rs.getString("EndTime")));
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

    public ArrayList<RoomTask> getRoomBaseStatus(String statusClean) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean],[StaffID],[StartTime],[EndTime],[Notes],[isSystemTask] FROM [HotelManagement].[dbo].[ROOM_TASK] ";
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
                room.setStaffID(rs.getObject("StaffID", Integer.class));
                room.setStartTime(rs.getObject("StartTime", LocalDateTime.class));
                room.setEndTime(rs.getObject("EndTime", LocalDateTime.class));
                room.setNotes(rs.getString("Notes"));
                room.setIsSystemTask(rs.getInt("isSystemTask"));
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

    //ham lay rm dua vao status va ngay
    public ArrayList<RoomTask> getRoomBaseStatus(String statusClean, LocalDateTime dayToGetTask) {
//        System.out.println("getRoomBaseStatus(String statusClean, LocalDateTime dayToGetTask) ");
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID], [RoomID], [StaffID], [StartTime], [EndTime], [StatusClean], [Notes],[isSystemTask] "
                + "FROM [HotelManagement].[dbo].[ROOM_TASK] "
                + "WHERE [StatusClean] = ? AND CAST([StartTime] AS DATE) = CAST(? AS DATE)";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, statusClean);
            ps.setObject(2, dayToGetTask.toLocalDate());
            rs = ps.executeQuery();

            while (rs.next()) {
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStatusClean(rs.getString("StatusClean"));
                room.setStaffID(rs.getObject("StaffID", Integer.class));
                room.setStartTime(rs.getObject("StartTime", LocalDateTime.class));
                room.setEndTime(rs.getObject("EndTime", LocalDateTime.class));
                room.setNotes(rs.getString("Notes"));
                room.setIsSystemTask(rs.getInt("isSystemTask"));
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

    public ArrayList<RoomTask> getAllRoomTaskBaseDate(LocalDateTime dayToGetTask) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean],[StaffID],[StartTime],[EndTime],[Notes],[isSystemTask] FROM [HotelManagement].[dbo].[ROOM_TASK] "
                + "WHERE CAST([StartTime] AS DATE) = CAST(? AS DATE)";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, dayToGetTask.toLocalDate());
            rs = ps.executeQuery();

            while (rs.next()) {
//                System.out.println("VO VO");
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStatusClean(rs.getString("StatusClean"));
                room.setStaffID(rs.getObject("StaffID", Integer.class));
                room.setStartTime(rs.getObject("StartTime", LocalDateTime.class));
                room.setEndTime(rs.getObject("EndTime", LocalDateTime.class));
                room.setNotes(rs.getString("Notes"));
                room.setIsSystemTask(rs.getInt("isSystemTask"));
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
        if (result.isEmpty()) {
            System.out.println("Ko lay duoc phong");
            result = null;

        } else {
            System.out.println("Lay duoc nha");
        }
        return result;
    }

    public ArrayList<RoomTask> getAllRoomTaskByDateRangeAndStatus(LocalDate startDate, LocalDate endDate, String statusClean, int staffID) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean],[StaffID],[StartTime],[EndTime],[Notes],[isSystemTask] FROM [HotelManagement].[dbo].[ROOM_TASK] "
                + "WHERE CAST([StartTime] AS DATE) BETWEEN ? AND ? AND [StatusClean] = ? AND [StaffID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, startDate);
            ps.setObject(2, endDate);
            ps.setString(3, statusClean);
            ps.setInt(4, staffID);
            rs = ps.executeQuery();
            while (rs.next()) {
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStatusClean(rs.getString("StatusClean"));
                room.setStaffID(rs.getObject("StaffID", Integer.class));
                room.setStartTime(rs.getObject("StartTime", LocalDateTime.class));
                room.setEndTime(rs.getObject("EndTime", LocalDateTime.class));
                room.setNotes(rs.getString("Notes"));
                room.setIsSystemTask(rs.getInt("isSystemTask"));
                result.add(room);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllRoomTaskByDateRangeAndStatus: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getAllRoomTaskByDateRangeAndStatus: " + e.getMessage());
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
        if (result.isEmpty()) {
            System.out.println("Ko lay duoc phong");
        } else {
            System.out.println("Lay duoc nha");
        }
        return result;
    }

    public ArrayList<RoomTask> getAllRoomTaskBaseDate(LocalDateTime dayToGetTask, int status) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean],[StaffID],[StartTime],[EndTime],[Notes],[isSystemTask] FROM [HotelManagement].[dbo].[ROOM_TASK] "
                + "WHERE CAST([StartTime] AS DATE) = CAST(? AS DATE) and isSystemTask = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, dayToGetTask.toLocalDate());
            ps.setInt(2, status);
            rs = ps.executeQuery();

            while (rs.next()) {
//                System.out.println("VO VO");
                RoomTask room = new RoomTask();
                room.setRoomTaskID(rs.getInt("RoomTaskID"));
                room.setRoomID(rs.getInt("RoomID"));
                room.setStatusClean(rs.getString("StatusClean"));
                room.setStaffID(rs.getObject("StaffID", Integer.class));
                room.setStartTime(rs.getObject("StartTime", LocalDateTime.class));
                room.setEndTime(rs.getObject("EndTime", LocalDateTime.class));
                room.setNotes(rs.getString("Notes"));
                room.setIsSystemTask(rs.getInt("isSystemTask"));
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
        if (result.isEmpty()) {
            System.out.println("Ko lay duoc phong");
            result = null;

        } else {
            System.out.println("Lay duoc nha");
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

    public int updateStatusRoomTask(int staffId, int roomTaskID, String statusCleanUpdate) {
        String sql = "UPDATE [HotelManagement].[dbo].[ROOM_TASK] SET [StatusClean] = ?, staffId = ? WHERE [RoomTaskID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, statusCleanUpdate);
            ps.setInt(2, staffId);
            ps.setInt(3, roomTaskID);

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

    public int updateStatusRoomTaskToCleand(int staffID, String statusCleanUpdate, int roomTaskID) {
        String sql = "UPDATE [HotelManagement].[dbo].[ROOM_TASK] SET [StaffID] = ?,[StatusClean] = ?,[EndTime] = ? WHERE [RoomTaskID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;
        Timestamp endTimestamp = Timestamp.valueOf(LocalDateTime.now());
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, staffID);
            ps.setString(2, statusCleanUpdate);
            ps.setTimestamp(3, endTimestamp);
            ps.setInt(4, roomTaskID);
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
                RoomTask roomTask = new RoomTask(id, roomId, staffId, java.time.LocalDateTime.parse(startTime), endTime != null ? java.time.LocalDateTime.parse(endTime) : null, statusClean, notes, 0);
                result.add(roomTask);
            }
        } catch (Exception e) {

        }

        return result;
    }

    public int insertRoomTask(RoomTask roomTask, Connection con) throws SQLException {

        // Thm 'throws SQLException' ?? ??y l?i ra ngoi
        String sql = "INSERT INTO [HotelManagement].[dbo].[ROOM_TASK] "
                + "([RoomID], [StaffID], [StartTime], [EndTime], [StatusClean], [Notes], [isSystemTask]) "
                + "VALUES (?, ?, ?, ?, ?, ?,?)";

        int rowsAffected = 0;

        // B? khai bo Connection con ? ?y (v n l tham s?)
        PreparedStatement ps = null;

        try {
            // ? b? dng con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, roomTask.getRoomID());

            if (roomTask.getStaffID() != null) {
                ps.setInt(2, roomTask.getStaffID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setObject(3, roomTask.getStartTime());
            ps.setObject(4, roomTask.getEndTime());

            ps.setString(5, roomTask.getStatusClean());
            ps.setString(6, roomTask.getNotes());
            ps.setInt(7, roomTask.getIsSystemTask());

            rowsAffected = ps.executeUpdate();

        } catch (SQLException e) {
            throw e;

        } catch (Exception e) {
            System.err.println("General error in insertRoomTask: " + e.getMessage());
            e.printStackTrace();

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return rowsAffected;
    }


    public int getBookingServiceIdByRoomTaskId(int roomTaskId) {
        int result = 0;

        String sql = "SELECT bs.Booking_Service_ID FROM ROOM_TASK rt JOIN BOOKING b ON rt.RoomID = b.RoomID AND b.Status IN ('Reserved', 'Checked-in') JOIN BOOKING_SERVICE bs ON b.BookingID = bs.BookingID WHERE rt.RoomTaskID = ?  AND rt.isSystemTask = 0";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, roomTaskId);
            ResultSet rs = ps.executeQuery();
            if (rs != null && rs.next()) {
                result = rs.getInt("Booking_Service_ID");
            }
        } catch (Exception e) {

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
                
            }
        }


        return result;
    }
}
