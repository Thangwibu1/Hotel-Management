package dao;

import model.Device;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DeviceDAO {

    /**
     * Lấy tất cả thiết bị
     * @return ArrayList chứa tất cả các Device
     */
    public ArrayList<Device> getAllDevices() {
        ArrayList<Device> result = new ArrayList<>();
        String sql = "SELECT [DeviceID], [DeviceName], [Description] FROM [HotelManagement].[dbo].[DEVICE]";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                int deviceId = rs.getInt("DeviceID");
                String deviceName = rs.getString("DeviceName");
                String description = rs.getString("Description");
                Device device = new Device(deviceId, deviceName, description);
                result.add(device);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllDevices: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getAllDevices: " + e.getMessage());
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
     * Lấy thiết bị theo ID
     * @param deviceId ID của thiết bị
     * @return Device object hoặc null nếu không tìm thấy
     */
    public Device getDeviceById(int deviceId) {
        Device device = null;
        String sql = "SELECT [DeviceID], [DeviceName], [Description] FROM [HotelManagement].[dbo].[DEVICE] WHERE [DeviceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("DeviceID");
                String deviceName = rs.getString("DeviceName");
                String description = rs.getString("Description");
                device = new Device(id, deviceName, description);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getDeviceById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in getDeviceById: " + e.getMessage());
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

        return device;
    }

    /**
     * Thêm thiết bị mới
     * @param device Device object cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean insertDevice(Device device) {
        boolean result = false;
        String sql = "INSERT INTO [HotelManagement].[dbo].[DEVICE] ([DeviceName], [Description]) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, device.getDeviceName());
            ps.setString(2, device.getDescription());
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in insertDevice: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in insertDevice: " + e.getMessage());
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
     * Cập nhật thiết bị theo ID
     * @param device Device object với thông tin mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateDeviceById(Device device) {
        boolean result = false;
        String sql = "UPDATE [HotelManagement].[dbo].[DEVICE] SET [DeviceName] = ?, [Description] = ? WHERE [DeviceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, device.getDeviceName());
            ps.setString(2, device.getDescription());
            ps.setInt(3, device.getDeviceId());
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in updateDeviceById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in updateDeviceById: " + e.getMessage());
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
     * Xóa thiết bị theo ID
     * @param deviceId ID của thiết bị cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteDeviceById(int deviceId) {
        boolean result = false;
        String sql = "DELETE FROM [HotelManagement].[dbo].[DEVICE] WHERE [DeviceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deviceId);
            
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in deleteDeviceById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in deleteDeviceById: " + e.getMessage());
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

