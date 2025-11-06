/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.CancellationStat;
import model.FrequentGuest;
import model.OccupancyRoom;
import model.ServiceUsage;
import utils.DBConnection;

/**
 *
 * @author trinhdtu
 */
public class ManageReportDAO {

    public ArrayList<FrequentGuest> getTopFrequentGuests(int limit) throws ClassNotFoundException {
        ArrayList<FrequentGuest> result = new ArrayList<>();

        String sql
                = "SELECT TOP (?) "
                + "    g.GuestID      AS GuestID, "
                + "    g.FullName     AS FullName, "
                + "    g.Email        AS Email, "
                + "    COUNT(b.BookingID) AS BookingCount, "
                + "    COALESCE(SUM(DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate)), 0) AS TotalNights "
                + "FROM GUEST g "
                + "JOIN BOOKING b ON g.GuestID = b.GuestID "
                + "WHERE b.Status IN ('Checked-in','Checked-out','Reserved') "
                + "GROUP BY g.GuestID, g.FullName, g.Email "
                + "ORDER BY BookingCount DESC, TotalNights DESC;";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            ps.setInt(1, limit);
            while (rs.next()) {
                int guestId = rs.getInt("GuestID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                int bookingCount = rs.getInt("BookingCount");
                int totalNights = rs.getInt("TotalNights");

                result.add(new FrequentGuest(
                        guestId, fullName, email, bookingCount, totalNights
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<ServiceUsage> getMostUsedServices(int limit) throws ClassNotFoundException {
        ArrayList<ServiceUsage> result = new ArrayList<>();

        String sql
                = "SELECT TOP (?) "
                + "    s.ServiceID AS ServiceID, "
                + "    s.ServiceName AS ServiceName, "
                + "    COALESCE(SUM(bs.Quantity), 0) AS TotalUsed, "
                + "    COUNT(DISTINCT bs.BookingID) AS TotalBookings "
                + "FROM BOOKING_SERVICE bs "
                + "JOIN SERVICE s ON bs.ServiceID = s.ServiceID "
                + "JOIN BOOKING b ON bs.BookingID = b.BookingID "
                + "WHERE b.Status IN ('Checked-in','Checked-out','Reserved') "
                + "GROUP BY s.ServiceID, s.ServiceName "
                + "ORDER BY TotalUsed DESC;";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int serviceId = rs.getInt("ServiceID");
                String serviceName = rs.getString("ServiceName");
                int totalUsed = rs.getInt("TotalUsed");
                int totalBookings = rs.getInt("TotalBookings");

                result.add(new ServiceUsage(serviceId, serviceName, totalUsed, totalBookings));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<CancellationStat> getCancellationStatsByMonth(int year) throws ClassNotFoundException {
        ArrayList<CancellationStat> result = new ArrayList<>();

        String sql = "SELECT \n"
                + "    MONTH(BookingDate) AS [Month],\n"
                + "    SUM(CASE WHEN Status = 'Canceled' THEN 1 ELSE 0 END) AS CanceledBookings,\n"
                + "    COUNT(*) AS TotalBookings\n"
                + "FROM BOOKING\n"
                + "WHERE YEAR(BookingDate) = ?\n"
                + "GROUP BY MONTH(BookingDate)\n"
                + "ORDER BY [Month];";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int month = rs.getInt("Month");
                int canceled = rs.getInt("CanceledBookings");
                int total = rs.getInt("TotalBookings");
                result.add(new CancellationStat(month, canceled, total));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<OccupancyRoom> getOccupancySimple(int year) throws ClassNotFoundException {
        ArrayList<OccupancyRoom> out = new ArrayList<>();
        String sql = "SELECT \n"
                + "            YEAR(b.CheckInDate)  AS [Year],\n"
                + "            MONTH(b.CheckInDate) AS [Month],\n"
                + "            SUM(DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate)) AS TotalRoomNights,\n"
                + "            (SELECT COUNT(*) FROM ROOM) * MAX(DAY(EOMONTH(b.CheckInDate))) AS AvailableRoomNights,\n"
                + "            ROUND(\n"
                + "                (SUM(DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate)) * 100.0) /\n"
                + "                NULLIF((SELECT COUNT(*) FROM ROOM) * MAX(DAY(EOMONTH(b.CheckInDate))), 0)\n"
                + "            , 2) AS OccupancyRatePercentage\n"
                + "        FROM BOOKING b\n"
                + "        WHERE b.CheckInDate IS NOT NULL\n"
                + "          AND b.CheckOutDate IS NOT NULL\n"
                + "          AND b.Status IN ('Checked-in','Checked-out','Reserved')\n"
                + "          AND YEAR(b.CheckInDate) = ?\n"
                + "        GROUP BY YEAR(b.CheckInDate), MONTH(b.CheckInDate)\n"
                + "        ORDER BY [Year] DESC, [Month] DESC;";
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new OccupancyRoom(
                        rs.getInt("Year"),
                        rs.getInt("Month"),
                        rs.getInt("TotalRoomNights"),
                        rs.getInt("AvailableRoomNights"),
                        rs.getDouble("OccupancyRatePercentage")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return out;
    }
}
