package dao;

import model.Guest;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;

public class GuestDAO {

    public ArrayList<Guest> getAllGuest() {
        ArrayList<Guest> result = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT[GuestID] ,[FullName] ,[Phone] ,[Email] ,[PasswordHash] ,[Address] ,[IDNumber] ,[DateOfBirth] FROM [HotelManagement].[dbo].[GUEST]";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int guestId = rs.getInt("GuestID");
                    String fullName = rs.getString("FullName");
                    String phone = rs.getString("Phone");
                    String email = rs.getString("Email");
                    String passwordHash = rs.getString("PasswordHash");
                    String address = rs.getString("Address");
                    String idNumber = rs.getString("IDNumber");
                    String dateOfBirth = rs.getString("DateOfBirth");
                    Guest guest = new Guest(guestId, fullName, phone, email, address, idNumber, dateOfBirth, passwordHash);
                    result.add(guest);
                }
            }
        } catch (Exception e) {
            System.out.println("Looix me roi");
        }

        return result;
    }

    public Guest getGuestByUsernameAndPassword(String username, String password) {
        Guest guest = null;

        String sql = "SELECT * FROM [HotelManagement].[dbo].[GUEST] where [IDNumber] = ? and [PasswordHash] = ?";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {

                while (rs.next()) {
                    int guestId = rs.getInt("GuestID");
                    String fullName = rs.getString("FullName");
                    String phone = rs.getString("Phone");
                    String email = rs.getString("Email");
                    String passwordHash = rs.getString("PasswordHash");
                    String address = rs.getString("Address");
                    String idNumber = rs.getString("IDNumber");
                    String dateOfBirth = rs.getString("DateOfBirth");
                    guest = new Guest();
                    guest = new Guest(guestId, fullName, phone, email, address, idNumber, dateOfBirth, passwordHash);
                }
            }

        } catch (Exception e) {

        }
        return guest;
    }

    public Guest getGuestById(int guestId) {
        Guest guest = null;

        String sql = "SELECT * FROM [HotelManagement].[dbo].[GUEST] where GuestID = ?";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, guestId);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    String fullName = rs.getString("FullName");
                    String phone = rs.getString("Phone");
                    String email = rs.getString("Email");
                    String address = rs.getString("Address");
                    String idNumber = rs.getString("IDNumber");
                    String dateOfBirth = rs.getString("DateOfBirth");
                    guest = new Guest();
                    guest = new Guest(guestId, fullName, phone, email, address, idNumber, dateOfBirth, "null");
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return guest;
    }

    public boolean checkDuplicateIdNumber(String idNumber) {
        boolean isDuplicate = false;
        String sql = "SELECT COUNT(*) AS count FROM [HotelManagement].[dbo].[GUEST] WHERE [IDNumber] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count");
                isDuplicate = count > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isDuplicate;
    }

    public boolean checkDuplicateEmail(String email) {
        boolean isDuplicate = false;
        String sql = "SELECT COUNT(*) AS count FROM [HotelManagement].[dbo].[GUEST] WHERE [Email] = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count");
                isDuplicate = count > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isDuplicate;
    }

    public boolean addGuest(Guest guest) {
        boolean result = false;
        String sql = "INSERT INTO [HotelManagement].[dbo].[GUEST] ([FullName] ,[Phone] ,[Email] ,[PasswordHash] ,[Address] ,[IDNumber] ,[DateOfBirth]) VALUES (?,?,?,?,?,?,?)";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, guest.getFullName());
            ps.setString(2, guest.getPhone());
            ps.setString(3, guest.getEmail());
            ps.setString(4, guest.getPasswordHash());
            ps.setString(5, guest.getAddress());
            ps.setString(6, guest.getIdNumber());
            ps.setObject(7, LocalDate.parse(guest.getDateOfBirth()));
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (Exception e) {
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
                e.printStackTrace();
            }
        }
        return result;
    }

    public boolean deleteStaff(int id) {
        boolean result = false;
        String sql = "DELETE FROM [HotelManagement].[dbo].[GUEST] WHERE [GuestID] = ?";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;
        } catch (Exception e) {
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
                e.printStackTrace();
            }
        }
        return result;
    }

    public Guest getGuestByIdNumber(String idNumber) {
        Guest guest = null;

        String sql = "SELECT * FROM [HotelManagement].[dbo].[GUEST] where IDNumber = ?";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, idNumber);
            ResultSet rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    String fullName = rs.getString("FullName");
                    String phone = rs.getString("Phone");
                    String email = rs.getString("Email");
                    guest = new Guest(fullName, phone, email);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return guest;
    }
}
