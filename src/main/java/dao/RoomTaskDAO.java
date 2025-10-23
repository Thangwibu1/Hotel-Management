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
import java.time.LocalDateTime;
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
    //ham nay lay het theo 
    public ArrayList<RoomTask> getRoomBaseStatus(String statusClean) {
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean],[StaffID],[StartTime],[EndTime],[Notes] FROM [HotelManagement].[dbo].[ROOM_TASK] ";
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
    //ham lay rôm dua vao status va ngay
    public ArrayList<RoomTask> getRoomBaseStatus(String statusClean, LocalDateTime dayToGetTask) {
//        System.out.println("getRoomBaseStatus(String statusClean, LocalDateTime dayToGetTask) ");
        ArrayList<RoomTask> result = new ArrayList<RoomTask>();
        String sql = "SELECT [RoomTaskID], [RoomID], [StaffID], [StartTime], [EndTime], [StatusClean], [Notes] "
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
        String sql = "SELECT [RoomTaskID],[RoomID],[StatusClean],[StaffID],[StartTime],[EndTime],[Notes] FROM [HotelManagement].[dbo].[ROOM_TASK] "
           + "WHERE CAST([StartTime] AS DATE) = CAST(? AS DATE) ";
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
        if(result.isEmpty()){
            System.out.println("Ko lay duoc phong");
            
        }else{
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
    public int updateStatusRoomTaskToCleand(int staffID, String statusCleanUpdate,int roomTaskID) {
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
    public int updateStatusRoomTask(int staffID,int roomTaskID, String note,String statusCleanUpdate) {
        String sql = "UPDATE [HotelManagement].[dbo].[ROOM_TASK] SET [StaffID] = ? , [StatusClean] = ? , [Notes] = ? WHERE [RoomTaskID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, staffID);
            ps.setString(2, statusCleanUpdate);
            ps.setString(3, note);
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

    public int insertRoomTask(RoomTask roomTask, Connection con) throws SQLException {

        // Thêm 'throws SQLException' ?? ??y l?i ra ngoài
        String sql = "INSERT INTO [HotelManagement].[dbo].[ROOM_TASK] "
                + "([RoomID], [StaffID], [StartTime], [EndTime], [StatusClean], [Notes]) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        int rowsAffected = 0;

        // B? khai báo Connection con ? ?ây (vì nó là tham s?)
        PreparedStatement ps = null;

        try {
            // ?ã b? dòng con = DBConnection.getConnection();
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

}
