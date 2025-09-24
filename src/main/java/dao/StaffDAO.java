package dao;

import model.Staff;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class StaffDAO {
    public ArrayList<Staff> getAllStaff() {
        ArrayList<Staff> result = new ArrayList<>();
        String sql = "SELECT TOP (1000) [StaffID] ,[FullName] ,[Role] ,[Username] ,[PasswordHash] ,[Phone] ,[Email] FROM [HotelManagement].[dbo].[STAFF]";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                    Staff staff = new Staff();
                    staff.setStaffId(rs.getInt("StaffID"));
                    staff.setFullName(rs.getString("FullName"));
                    staff.setRole(rs.getString("Role"));
                    staff.setUsername(rs.getString("Username"));
                    staff.setPasswordHash(rs.getString("PasswordHash"));
                    staff.setPhone(rs.getString("Phone"));
                    staff.setEmail(rs.getString("Email"));
                    result.add(staff);

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
}
