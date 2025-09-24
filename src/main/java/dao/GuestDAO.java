package dao;

import model.Guest;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
}
