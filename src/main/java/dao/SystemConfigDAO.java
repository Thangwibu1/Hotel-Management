package dao;

import model.SystemConfig;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;

public class SystemConfigDAO {
    public ArrayList<SystemConfig> getAllSystemConfig() {
        ArrayList<SystemConfig> result = new ArrayList<>();
        String sql = "SELECT [ConfigID], [ConfigName], [ConfigValue] FROM [HotelManagement].[dbo].[SYSTEM_CONFIG]";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int configId = rs.getInt("ConfigID");
                    String configName = rs.getString("ConfigName");
                    int configValue = rs.getInt("ConfigValue");

                    SystemConfig systemConfig = new SystemConfig(configId, configName, configValue);
                    result.add(systemConfig);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public SystemConfig getSystemConfigById(int configId) {
        SystemConfig result = null;
        String sql = "SELECT [ConfigID], [ConfigName], [ConfigValue] FROM [HotelManagement].[dbo].[SYSTEM_CONFIG] WHERE [ConfigID] = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, configId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {

                    String configName = rs.getString("ConfigName");
                    int configValue = rs.getInt("ConfigValue");

                    result = new SystemConfig(configId, configName, configValue);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean updateVale(SystemConfig systemConfig) {
        String sql = "UPDATE [HotelManagement].[dbo].[SYSTEM_CONFIG] SET [ConfigValue] = ? WHERE [ConfigID] = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, systemConfig.getConfigValue());
            ps.setInt(2, systemConfig.getConfigId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addSystemConfig(SystemConfig systemConfig) {
        boolean result = false;

        String sql = "INSERT INTO [HotelManagement].[dbo].[SYSTEM_CONFIG] ([ConfigName], [ConfigValue]) VALUES (?, ?)";
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, systemConfig.getConfigName());
            ps.setInt(2, systemConfig.getConfigValue());
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean deleteSystemConfig(int configId) {

        boolean result = false;

        String sql = "DELETE FROM [HotelManagement].[dbo].[SYSTEM_CONFIG] WHERE [ConfigID] = ?";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, configId);
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public SystemConfig getSystemConfigByName(String configName) {
        SystemConfig result = null;
        String sql = "SELECT [ConfigID], [ConfigName], [ConfigValue] FROM [HotelManagement].[dbo].[SYSTEM_CONFIG] WHERE [ConfigName] = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, configName);
            ResultSet rs = ps.executeQuery();
            if (rs != null && rs.next()) {
                int configId = rs.getInt("ConfigID");
                int configValue = rs.getInt("ConfigValue");
                result = new SystemConfig(configId, configName, configValue);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
