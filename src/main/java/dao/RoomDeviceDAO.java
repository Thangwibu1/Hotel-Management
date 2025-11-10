package dao;

import model.RoomDevice;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class RoomDeviceDAO {

    /**
     * Lấy tất cả thiết bị trong phòng
     * @return ArrayList chứa tất cả các RoomDevice
     */
    public ArrayList<RoomDevice> getAllRoomDevices() {
        ArrayList<RoomDevice> result = new ArrayList<>();
        String sql = "SELECT [RoomDeviceID], [RoomID], [DeviceID], [Quantity], [Status] FROM [HotelManagement].[dbo].[ROOM_DEVICE]";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                int roomDeviceId = rs.getInt("RoomDeviceID");
                int roomId = rs.getInt("RoomID");
                int deviceId = rs.getInt("DeviceID");
                int quantity = rs.getInt("Quantity");
                Integer status = (Integer) rs.getObject("Status");
                RoomDevice roomDevice = new RoomDevice(roomDeviceId, roomId, deviceId, quantity, status);
                result.add(roomDevice);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllRoomDevices: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getAllRoomDevices: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    /**
     * Lấy thiết bị trong phòng theo ID
     * @param roomDeviceId ID của RoomDevice
     * @return RoomDevice object hoặc null nếu không tìm thấy
     */
    public RoomDevice getRoomDeviceById(int roomDeviceId) {
        RoomDevice roomDevice = null;
        String sql = "SELECT [RoomDeviceID], [RoomID], [DeviceID], [Quantity], [Status] FROM [HotelManagement].[dbo].[ROOM_DEVICE] WHERE [RoomDeviceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roomDeviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("RoomDeviceID");
                int roomId = rs.getInt("RoomID");
                int deviceId = rs.getInt("DeviceID");
                int quantity = rs.getInt("Quantity");
                Integer status = (Integer) rs.getObject("Status");
                roomDevice = new RoomDevice(id, roomId, deviceId, quantity, status);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getRoomDeviceById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getRoomDeviceById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return roomDevice;
    }

    /**
     * Lấy danh sách thiết bị của một phòng cụ thể
     * @param roomId ID của phòng
     * @return ArrayList chứa các RoomDevice của phòng
     */
    public ArrayList<RoomDevice> getRoomDevicesByRoomId(int roomId) {
        ArrayList<RoomDevice> result = new ArrayList<>();
        String sql = "SELECT [RoomDeviceID], [RoomID], [DeviceID], [Quantity], [Status] FROM [HotelManagement].[dbo].[ROOM_DEVICE] WHERE [RoomID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roomId);
            rs = ps.executeQuery();

            while (rs.next()) {
                int roomDeviceId = rs.getInt("RoomDeviceID");
                int rid = rs.getInt("RoomID");
                int deviceId = rs.getInt("DeviceID");
                int quantity = rs.getInt("Quantity");
                Integer status = (Integer) rs.getObject("Status");
                RoomDevice roomDevice = new RoomDevice(roomDeviceId, rid, deviceId, quantity, status);
                result.add(roomDevice);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getRoomDevicesByRoomId: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getRoomDevicesByRoomId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    /**
     * Thêm thiết bị mới vào phòng
     * @param roomDevice RoomDevice object cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean insertRoomDevice(RoomDevice roomDevice) {
        boolean result = false;
        String sql = "INSERT INTO [HotelManagement].[dbo].[ROOM_DEVICE] ([RoomID], [DeviceID], [Quantity], [Status]) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roomDevice.getRoomId());
            ps.setInt(2, roomDevice.getDeviceId());
            ps.setInt(3, roomDevice.getQuantity());
            if (roomDevice.getStatus() != null) {
                ps.setInt(4, roomDevice.getStatus());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in insertRoomDevice: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in insertRoomDevice: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    /**
     * Cập nhật thiết bị trong phòng theo ID
     * @param roomDevice RoomDevice object với thông tin mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateRoomDeviceById(RoomDevice roomDevice) {
        boolean result = false;
        String sql = "UPDATE [HotelManagement].[dbo].[ROOM_DEVICE] SET [RoomID] = ?, [DeviceID] = ?, [Quantity] = ?, [Status] = ? WHERE [RoomDeviceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roomDevice.getRoomId());
            ps.setInt(2, roomDevice.getDeviceId());
            ps.setInt(3, roomDevice.getQuantity());
            if (roomDevice.getStatus() != null) {
                ps.setInt(4, roomDevice.getStatus());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setInt(5, roomDevice.getRoomDeviceId());
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in updateRoomDeviceById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in updateRoomDeviceById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    /**
     * Xóa thiết bị trong phòng theo ID
     * @param roomDeviceId ID của RoomDevice cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteRoomDeviceById(int roomDeviceId) {
        boolean result = false;
        String sql = "DELETE FROM [HotelManagement].[dbo].[ROOM_DEVICE] WHERE [RoomDeviceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roomDeviceId);
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in deleteRoomDeviceById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in deleteRoomDeviceById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    /**
     * Xóa tất cả thiết bị của một phòng cụ thể
     * @param roomId ID của phòng
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteRoomDevicesByRoomId(int roomId) {
        boolean result = false;
        String sql = "DELETE FROM [HotelManagement].[dbo].[ROOM_DEVICE] WHERE [RoomID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roomId);
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in deleteRoomDevicesByRoomId: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in deleteRoomDevicesByRoomId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    /**
     * Cập nhật status của tất cả thiết bị trong một phòng cụ thể
     * @param roomId ID của phòng
     * @param status Status mới cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateAllRoomDevicesStatusByRoomId(int roomId, int status) {
        boolean result = false;
        String sql = "UPDATE [HotelManagement].[dbo].[ROOM_DEVICE] SET [Status] = ? WHERE [RoomID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, roomId);
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected >= 0; // >= 0 because even if no rows affected, it's still success (no devices in room)
        } catch (SQLException e) {
            System.err.println("Database error in updateAllRoomDevicesStatusByRoomId: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in updateAllRoomDevicesStatusByRoomId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }
}

