package dao;

import model.Service;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ServiceDAO {
    public ArrayList<Service> getAllService() {
        ArrayList<Service> result = new ArrayList<>();
//        cbi sql
        String sql = "SELECT [ServiceID] ,[ServiceName] ,[ServiceType] ,[Price] FROM [HotelManagement].[dbo].[SERVICE]";
//        xu li logic
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int serviceId = rs.getInt("ServiceID");
                    String serviceName = rs.getString("ServiceName");
                    String serviceType = rs.getString("ServiceType");
                    java.math.BigDecimal price = rs.getBigDecimal("Price");
                    Service service = new Service(serviceId, serviceName, serviceType, price);
                    result.add(service);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;

    }

    public Service getServiceById(int serviceId) {
        Service service = null;
        String sql = "SELECT [ServiceID] ,[ServiceName] ,[ServiceType] ,[Price] FROM [HotelManagement].[dbo].[SERVICE] where ServiceID = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                if (rs.next()) {
                    String serviceName = rs.getString("ServiceName");
                    String serviceType = rs.getString("ServiceType");
                    java.math.BigDecimal price = rs.getBigDecimal("Price");
                    service = new Service(serviceId, serviceName, serviceType, price);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return service;
    }

    public boolean updateService(int serviceId, String serviceName, String serviceType, java.math.BigDecimal price) {
        boolean result = false;
        String sql = "UPDATE [HotelManagement].[dbo].[SERVICE] SET [ServiceName] = ?, [ServiceType] = ?, [Price] = ? WHERE [ServiceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, serviceName);
            ps.setString(2, serviceType);
            ps.setBigDecimal(3, price);
            ps.setInt(4, serviceId);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    public boolean deleteService(int serviceId) {
        boolean result = false;
        String sql = "DELETE FROM [HotelManagement].[dbo].[SERVICE] WHERE [ServiceID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }

    public boolean addService(String serviceName, String serviceType, java.math.BigDecimal price) {
        boolean result = false;
        String sql = "INSERT INTO [HotelManagement].[dbo].[SERVICE] ([ServiceName], [ServiceType], [Price]) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, serviceName);
            ps.setString(2, serviceType);
            ps.setBigDecimal(3, price);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return result;
    }
}
