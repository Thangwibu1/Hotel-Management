<%-- 
    Document   : cancelReportTab
    Created on : Nov 5, 2025, 12:27:00 AM
    Author     : trinhdtu
--%>

<%@page import="model.CancellationStat"%>
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
            ArrayList<CancellationStat> row = (ArrayList<CancellationStat>) request.getAttribute("result");

            if (row != null && !row.isEmpty()) {
                int total = 0;
                int totalBookings = 0;
                double highestRate = 0.0;
                int highestMonth = 0;
        %>
        <div class="card" style="padding: 32px;">

            <table class="cancel-table">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th style="text-align: center;">Cancellations</th>
                        <th style="text-align: center;">Total Bookings</th>
                        <th style="text-align: center;">Rate</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (CancellationStat r : row) {
                            total += r.getCanceledBookings();
                            totalBookings += r.getTotalBookings();
                            double rate = (double) r.getCanceledBookings() / r.getTotalBookings() * 100.0;
                            if (rate > highestRate) {
                                highestRate = rate;
                                highestMonth = r.getMonth();
                            }
                    %>
                    <tr>
                        <td style="font-weight: 600;"><%= r.getMonth()%>/2025</td>
                        <td style="text-align: center;"><%= r.getCanceledBookings()%></td>
                        <td style="text-align: center;"><%= r.getTotalBookings()%></td>
                        <td style="text-align: center; font-weight: 600;"><%= String.format("%.2f", rate)%>%</td>

                    </tr>
                    <%
                        }
                    %>

                </tbody>
            </table>
            <!-- Cancellation Statistics -->
            <div class="cancel-stats">
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Total Cancellations</div>
                    <div class="cancel-stat-value"><%= total%></div>
                </div>
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Average Cancellation Rate</div>
                    <div class="cancel-stat-value"><%= String.format("%.2f", (totalBookings > 0) ? (total * 100.0 / totalBookings) : 0)%>%</div>
                </div>
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Highest Month</div>
                    <div class="cancel-stat-value" style="font-size: 18px;"><%= highestMonth%>/2025 - <%= String.format("%.2f",highestRate)%>%</div>
                </div>
            </div>
        </div>
        <%            }
        %>
    </body>
</html>
