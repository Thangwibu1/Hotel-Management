package dao;

import model.Repair;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class RepairDAO {

    /**
     * Lấy repair theo ID
     */
    public Repair getRepairById(int repairId) {
        Repair repair = null;
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR] WHERE [RepairID] = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, repairId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                repair = extractRepairFromResultSet(rs);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repair;
    }

    /**
     * Lấy tất cả repairs
     */
    public ArrayList<Repair> getAllRepairs() {
        ArrayList<Repair> repairs = new ArrayList<>();
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR]";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = extractRepairFromResultSet(rs);
                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    /**
     * Thêm repair mới
     */
    public boolean insertRepair(Repair repair) {
        boolean result = false;
        String sql = "INSERT INTO [HotelManagement].[dbo].[REPAIR] " +
                "([RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], [NextdateMaintaince], " +
                "[Description], [Cost], [Status]) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, repair.getRoomDeviceId());
            
            // StaffID có thể null
            if (repair.getStaffId() != null) {
                ps.setInt(2, repair.getStaffId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            // Convert LocalDateTime to Timestamp
            if (repair.getReportDate() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(repair.getReportDate()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }

            // CompletionDate có thể null
            if (repair.getCompletionDate() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(repair.getCompletionDate()));
            } else {
                ps.setNull(4, Types.TIMESTAMP);
            }

            // NextDateMaintenance có thể null
            if (repair.getNextDateMaintenance() != null) {
                ps.setDate(5, Date.valueOf(repair.getNextDateMaintenance()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, repair.getDescription());
            ps.setDouble(7, repair.getCost());
            ps.setString(8, repair.getStatus());

            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Cập nhật repair
     */
    public boolean updateRepair(Repair repair) {
        boolean result = false;
        String sql = "UPDATE [HotelManagement].[dbo].[REPAIR] " +
                "SET [RoomDeviceID] = ?, [StaffID] = ?, [ReportDate] = ?, [CompletionDate] = ?, " +
                "[NextdateMaintaince] = ?, [Description] = ?, [Cost] = ?, [Status] = ? " +
                "WHERE [RepairID] = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, repair.getRoomDeviceId());

            // StaffID có thể null
            if (repair.getStaffId() != null) {
                ps.setInt(2, repair.getStaffId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            // Convert LocalDateTime to Timestamp
            if (repair.getReportDate() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(repair.getReportDate()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }

            // CompletionDate có thể null
            if (repair.getCompletionDate() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(repair.getCompletionDate()));
            } else {
                ps.setNull(4, Types.TIMESTAMP);
            }

            // NextDateMaintenance có thể null
            if (repair.getNextDateMaintenance() != null) {
                ps.setDate(5, Date.valueOf(repair.getNextDateMaintenance()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, repair.getDescription());
            ps.setDouble(7, repair.getCost());
            ps.setString(8, repair.getStatus());
            ps.setInt(9, repair.getRepairId());

            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Xóa repair theo ID
     */
    public boolean deleteRepair(int repairId) {
        boolean result = false;
        String sql = "DELETE FROM [HotelManagement].[dbo].[REPAIR] WHERE [RepairID] = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, repairId);

            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Lấy repairs theo status
     */
    public ArrayList<Repair> getRepairsByStatus(String status) {
        ArrayList<Repair> repairs = new ArrayList<>();
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR] WHERE [Status] = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = extractRepairFromResultSet(rs);
                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    /**
     * Lấy repairs theo ngày báo cáo (Report Date)
     */
    public ArrayList<Repair> getRepairsByReportDate(LocalDate reportDate) {
        ArrayList<Repair> repairs = new ArrayList<>();
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR] " +
                "WHERE CAST([ReportDate] AS DATE) = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(reportDate));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = extractRepairFromResultSet(rs);
                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    /**
     * Lấy repairs theo khoảng thời gian report date
     */
    public ArrayList<Repair> getRepairsByReportDateRange(LocalDate startDate, LocalDate endDate) {
        ArrayList<Repair> repairs = new ArrayList<>();
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR] " +
                "WHERE CAST([ReportDate] AS DATE) BETWEEN ? AND ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = extractRepairFromResultSet(rs);
                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    /**
     * Lấy repairs theo RoomDeviceID
     */
    public ArrayList<Repair> getRepairsByRoomDeviceId(int roomDeviceId) {
        ArrayList<Repair> repairs = new ArrayList<>();
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR] WHERE [RoomDeviceID] = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, roomDeviceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = extractRepairFromResultSet(rs);
                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    /**
     * Lấy repairs theo StaffID
     */
    public ArrayList<Repair> getRepairsByStaffId(int staffId) {
        ArrayList<Repair> repairs = new ArrayList<>();
        String sql = "SELECT [RepairID], [RoomDeviceID], [StaffID], [ReportDate], [CompletionDate], " +
                "[NextdateMaintaince], [Description], [Cost], [Status] " +
                "FROM [HotelManagement].[dbo].[REPAIR] WHERE [StaffID] = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = extractRepairFromResultSet(rs);
                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    /**
     * Overloaded insertRepair method với các tham số riêng lẻ
     * Để tương thích với code hiện có
     */
    public boolean insertRepair(int roomDeviceId, Integer staffId, LocalDateTime reportDate,
                                LocalDateTime completionDate, LocalDate nextDateMaintenance,
                                String description, double cost, String status) {
        Repair repair = new Repair(roomDeviceId, staffId, reportDate, completionDate,
                nextDateMaintenance, description, cost, status);
        return insertRepair(repair);
    }

    /**
     * Phương thức helper để trích xuất Repair từ ResultSet
     */
    private Repair extractRepairFromResultSet(ResultSet rs) throws SQLException {
        Repair repair = new Repair();
        
        repair.setRepairId(rs.getInt("RepairID"));
        repair.setRoomDeviceId(rs.getInt("RoomDeviceID"));
        
        // StaffID có thể null
        int staffId = rs.getInt("StaffID");
        if (!rs.wasNull()) {
            repair.setStaffId(staffId);
        } else {
            repair.setStaffId(null);
        }
        
        // Convert Timestamp to LocalDateTime
        Timestamp reportDateTs = rs.getTimestamp("ReportDate");
        if (reportDateTs != null) {
            repair.setReportDate(reportDateTs.toLocalDateTime());
        }
        
        // CompletionDate có thể null
        Timestamp completionDateTs = rs.getTimestamp("CompletionDate");
        if (completionDateTs != null) {
            repair.setCompletionDate(completionDateTs.toLocalDateTime());
        }
        
        // NextDateMaintenance có thể null
        Date nextDateMaintenanceDate = rs.getDate("NextdateMaintaince");
        if (nextDateMaintenanceDate != null) {
            repair.setNextDateMaintenance(nextDateMaintenanceDate.toLocalDate());
        }
        
        repair.setDescription(rs.getString("Description"));
        repair.setCost(rs.getDouble("Cost"));
        repair.setStatus(rs.getString("Status"));
        
        return repair;
    }
}

