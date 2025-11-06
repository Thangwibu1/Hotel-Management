/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.CancellationStat;
import model.FrequentGuest;
import model.OccupancyRoom;
import model.RevenueRow;
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

    private static class GroupConf {

        String groupBy;
        String selectLabel;
        String orderBy;
    }

    private GroupConf conf(String range) {
        GroupConf c = new GroupConf();
        String r = range == null ? "daily" : range.toLowerCase();
        switch (r) {
            case "monthly":
                c.groupBy = "YEAR(i.IssueDate), MONTH(i.IssueDate)";
                c.selectLabel = "CONCAT(CAST(YEAR(i.IssueDate) AS varchar(4)),'-',RIGHT('0'+CAST(MONTH(i.IssueDate) AS varchar(2)),2))";
                c.orderBy = "YEAR(i.IssueDate), MONTH(i.IssueDate)";
                break;
            case "yearly":
                c.groupBy = "YEAR(i.IssueDate)";
                c.selectLabel = "CAST(YEAR(i.IssueDate) AS NVARCHAR(4))";
                c.orderBy = "MIN(i.IssueDate)";
                break;
            default: // daily
                c.groupBy = "CAST(i.IssueDate AS DATE)";
                c.selectLabel = "FORMAT(i.IssueDate,'yyyy-MM-dd')";
                c.orderBy = "MIN(i.IssueDate)";
        }
        return c;
    }

    public ArrayList<RevenueRow> getRevenueStats(String range) throws ClassNotFoundException {
        ArrayList<RevenueRow> list = new ArrayList<>();
        GroupConf c = conf(range);

        String sql
                = "SELECT " + c.selectLabel + " AS period, "
                + "       SUM(i.TotalAmount) AS revenue, "
                + "       COUNT(b.BookingID) AS roomsSold, "
                + "       " + c.orderBy + " AS ord "
                + "FROM dbo.INVOICE i "
                + "JOIN dbo.BOOKING b ON b.BookingID = i.BookingID "
                + "WHERE i.Status = 'Paid' "
                + "GROUP BY " + c.groupBy + " "
                + "ORDER BY " + c.orderBy;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            BigDecimal prev = null;
            while (rs.next()) {
                String period = rs.getString("period");
                BigDecimal revenue = rs.getBigDecimal("revenue");
                int roomsSold = rs.getInt("roomsSold");

                double change = 0.0;
                if (prev != null && prev.doubleValue() != 0.0) {
                    change = (revenue.doubleValue() - prev.doubleValue()) / prev.doubleValue() * 100.0;
                }

                list.add(new RevenueRow(period, revenue, roomsSold, change));
                prev = revenue;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
        }

        return list;
    }

    // =============== 2) Average ===============
    public BigDecimal getAverage(String range) throws ClassNotFoundException {
        GroupConf c = conf(range);
        String sql
                = "SELECT AVG(x.rev) "
                + "FROM (SELECT SUM(i.TotalAmount) AS rev "
                + "      FROM dbo.INVOICE i "
                + "      WHERE i.Status='Paid' "
                + "      GROUP BY " + c.groupBy + ") x";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BigDecimal avg = BigDecimal.ZERO;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next() && rs.getBigDecimal(1) != null) {
                avg = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
        }

        return avg;
    }

    // =============== 3) Best period (label + $) ===============
    public String getBestPeriod(String range) throws ClassNotFoundException {
        GroupConf c = conf(range);
        String sql
                = "SELECT TOP 1 " + c.selectLabel + " AS label, SUM(i.TotalAmount) AS total "
                + "FROM dbo.INVOICE i "
                + "WHERE i.Status='Paid' "
                + "GROUP BY " + c.groupBy + " "
                + "ORDER BY total DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String best = "N/A";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                best = rs.getString("label") + " ($" + rs.getBigDecimal("total") + ")";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
        }

        return best;
    }

    // =============== 4) Total ===============
    public BigDecimal getTotal(String range) throws ClassNotFoundException {
        String sql = "SELECT SUM(i.TotalAmount) FROM dbo.INVOICE i WHERE i.Status='Paid'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BigDecimal total = BigDecimal.ZERO;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next() && rs.getBigDecimal(1) != null) {
                total = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
        }

        return total;
    }
}
