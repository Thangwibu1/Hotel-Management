package dao;

import model.Staff;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class StaffDAO {

    public Staff getStaffById(int staffId) {
        Staff staff = null;
        String sql = "SELECT [StaffID] ,[FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email] FROM [HotelManagement].[dbo].[STAFF] where [StaffID] = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();
            if (rs.next()) {
                String fullName = rs.getString("FullName");
                String role = rs.getString("Role");
                String username = rs.getString("Username");
                String passwordHash = rs.getString("PasswordHash");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");

                staff = new Staff(staffId, fullName, role, username, passwordHash, phone, email);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return staff;
    }

    public ArrayList<Staff> getAllStaff() {
        ArrayList<Staff> result = new ArrayList<>();
        String sql = "SELECT [StaffID] ,[FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email] FROM [HotelManagement].[dbo].[STAFF]";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int id = rs.getInt("StaffID");
                    String fullName = rs.getString("FullName");
                    String role = rs.getString("Role");
                    String username = rs.getString("Username");
                    String passwordHash = rs.getString("PasswordHash");
                    String phone = rs.getString("Phone");
                    String email = rs.getString("Email");
                    Staff staff = new Staff(id, fullName, role, username, passwordHash, phone, email);
                    result.add(staff);
                }

            }
        } catch (Exception e) {

        }
        return result;
    }

    public Staff getStaffByUsernameAndPassword(String username, String password) {
        Staff staff = null;
        String sql = "SELECT [StaffID] ,[FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email] FROM [HotelManagement].[dbo].[STAFF] where Username = ? and [PasswordHash] = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) { // Thêm rs.next()
                staff = new Staff(); // Khởi tạo object Staff

                int id = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String role = rs.getString("Role");
                String username1 = rs.getString("Username");
                String passwordHash = rs.getString("PasswordHash");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");

                staff.setStaffId(id);
                staff.setFullName(fullName);
                staff.setRole(role);
                staff.setUsername(username1);
                staff.setPasswordHash(passwordHash); // Sử dụng passwordHash thay vì password
                staff.setPhone(phone);
                staff.setEmail(email);
            }

        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi để debug
        } finally {
            // Đóng resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return staff;
    }

    public boolean addStaff(Staff staff) {
        boolean result = false;

        String sql = "INSERT INTO [HotelManagement].[dbo].[STAFF] ([FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email]) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, staff.getFullName());
            ps.setString(2, staff.getRole());
            ps.setString(3, staff.getUsername());
            ps.setString(4, staff.getPasswordHash());
            ps.setString(5, staff.getPhone());
            ps.setString(6, staff.getEmail());
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
            
            ps.close();
            con.close();
        } catch (Exception e) {
            // TODO: handle exception
        } finally {
            
        }

        return result;
    }

    public boolean updateStaff(Staff staff) {
        boolean result = false;

        String sql = "UPDATE [HotelManagement].[dbo].[STAFF] SET [FullName] = ?, [Role] = ?, [Username] = ?, [PasswordHash] = ?, [Phone] = ?, [Email] = ? WHERE [StaffID] = ?";
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, staff.getFullName());
            ps.setString(2, staff.getRole());
            ps.setString(3, staff.getUsername());
            ps.setString(4, staff.getPasswordHash());
            ps.setString(5, staff.getPhone());
            ps.setString(6, staff.getEmail());
            ps.setInt(7, staff.getStaffId());
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
            ps.close();
            con.close();

        } catch (Exception e) {
            // TODO: handle exception
        }

        return result;
    }

    public boolean deleteStaff(int staffId) {
        boolean result = false;

        String sql = "DELETE FROM [HotelManagement].[dbo].[STAFF] WHERE [StaffID] = ?";


        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, staffId);
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
            ps.close();
            con.close();
        } catch (Exception e) {
            // TODO: handle exception
        }

        return result;
    }

    public boolean isUsernameExist(String username) {
        boolean result = false;

        String sql = "SELECT COUNT(*) AS count FROM [HotelManagement].[dbo].[STAFF] WHERE [Username] = ?";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count");
                result = count > 0;
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            // TODO: handle exception
        }

        return result;
    }

    public ArrayList<Staff> getStaffsByRole(String role) {
        ArrayList<Staff> result = new ArrayList<>();
        
        String sql = "SELECT [StaffID] ,[FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email] FROM [HotelManagement].[dbo].[STAFF] where [Role] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, role);
            rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String role1 = rs.getString("Role");
                String username = rs.getString("Username");
                String passwordHash = rs.getString("PasswordHash");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");
                Staff staff = new Staff(id, fullName, role1, username, passwordHash, phone, email);
                result.add(staff);
            }
        } catch (Exception e) {
            // TODO: handle exception
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

    public ArrayList<Staff> searchStaff(String keyword) {
        ArrayList<Staff> result = new ArrayList<>();
        
        String sql = "SELECT [StaffID] ,[FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email] " +
                     "FROM [HotelManagement].[dbo].[STAFF] " +
                     "WHERE [FullName] LIKE ? OR [Username] LIKE ? OR [Email] LIKE ? OR [Phone] LIKE ? OR [Role] LIKE ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String role = rs.getString("Role");
                String username = rs.getString("Username");
                String passwordHash = rs.getString("PasswordHash");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");
                Staff staff = new Staff(id, fullName, role, username, passwordHash, phone, email);
                result.add(staff);
            }
        } catch (Exception e) {
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
}
