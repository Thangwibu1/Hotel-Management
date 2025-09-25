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
}
