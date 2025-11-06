<%-- 
    Document   : occupancyReportTab
    Created on : Nov 5, 2025, 12:27:56 AM
    Author     : trinhdtu
--%>

<%@page import="java.time.YearMonth"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="model.OccupancyRoom"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            ArrayList<OccupancyRoom> result = (ArrayList<OccupancyRoom>) request.getAttribute("result");
            if (result != null && !result.isEmpty()) {
                long totalRoomsSold = 0;
                long totalCapacityNights = 0;
                int totalRooms = 0;
                double peakPct = -1;
                int peakMonth = 0, peakYear = 0;
        %>
        <div class="card" style="padding: 32px;">
            <div class="occupancy-header">
                <h2 class="occupancy-title">Monthly Occupancy Rate</h2>
            </div>

            <table class="occupancy-table">
                <thead>
                    <tr>
                        <th>Month</th>

                        <th style="text-align: center;">Rooms Sold</th>
                        <th style="text-align: center;">Total Rooms</th>
                        <th>Occupancy Rate</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (OccupancyRoom row : result) {
                            int y = row.getYear();
                            int m = row.getMonth();
                            int nights = row.getTotalRoomNights();
                            int availNights = row.getAvailableRoomNights();

                            totalRoomsSold += nights;
                            totalCapacityNights += availNights;

                            if (totalRooms == 0) {
                                int daysInMonth = YearMonth.of(y, m).lengthOfMonth();
                                if (daysInMonth > 0) {
                                    int roomsThisMonth = (int) Math.round(availNights * 1.0 / daysInMonth);
                                    if (roomsThisMonth > 0) {
                                        totalRooms = roomsThisMonth;
                                    }
                                }
                            }

                            double monthPct = row.getOccupancyRatePercentage();
                            if (monthPct > peakPct) {
                                peakPct = monthPct;
                                peakMonth = m;
                                peakYear = y;
                            }
                    %>
                    <tr>
                        <td style="font-weight: 600;"><%= m%>/<%= y%></td>
                        <td style="text-align: center;"><%= nights%></td>
                        <td style="text-align: center;"><%= availNights%></td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: <%= monthPct%>%;"></div>
                                </div>
                                <span class="progress-label"><%= String.format("%.2f", monthPct)%>%</span>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <%
                double avgPct = (totalCapacityNights == 0) ? 0.0
                        : (totalRoomsSold * 100.0 / totalCapacityNights);

                NumberFormat intFmt = NumberFormat.getIntegerInstance();
            %>

            <!-- Occupancy Statistics -->
            <div class="occupancy-stats">
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Average Occupancy Rate</div>
                    <div class="occupancy-stat-value"><%= String.format("%.1f%%", avgPct)%></div>
                </div>
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Peak Month</div>
                    <div class="occupancy-stat-value" style="font-size: 18px;">
                        <%= (peakMonth == 0) ? "-" : (java.time.Month.of(peakMonth).name().substring(0, 1)
                    + java.time.Month.of(peakMonth).name().substring(1).toLowerCase())%> 
                        <%= peakYear%> (<%= String.format("%.0f%%", peakPct)%>)
                    </div>
                </div>
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Total Rooms Sold</div>
                    <div class="occupancy-stat-value"><%= intFmt.format(totalRoomsSold)%></div>
                </div>
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Available Capacity</div>
                    <div class="occupancy-stat-value"><%= intFmt.format(totalRooms)%> rooms</div>
                </div>
            </div>

        </div>
        <%
            }
        %>
    </body>
</html>
