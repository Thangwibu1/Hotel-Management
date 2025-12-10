<%-- 
    Document   : topGuestTab
    Created on : Nov 5, 2025, 12:29:16 AM
    Author     : trinhdtu
--%>

<%@page import="model.FrequentGuest"%>
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
            ArrayList<FrequentGuest> result = (ArrayList<FrequentGuest>) request.getAttribute("topGuests");
            if (result != null && !result.isEmpty()) {


        %>
        <div class="card" style="padding: 32px;">
            <div class="guests-header">
                <svg class="guests-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                <h2 class="guests-title">Top 10 Frequent Guests</h2>
            </div>

            <table class="guests-table">
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Guest Name</th>
                        <th>Email</th>
                        <th style="text-align: center;">Total Bookings</th>
                        <th style="text-align: center;">Total night</th>
                        <th style="text-align: center;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%                        int count = 0;
                        for (FrequentGuest guest : result) {
                            count++;
                    %>
                    <tr>
                        <td><span class="rank-badge"><%= count%></span></td>
                        <td style="font-weight: 600;"><%= guest.getFullName()%></td>
                        <td style="color: var(--muted);"><%= guest.getEmail()%></td>
                        <td style="text-align: center; font-weight: 600;"><%= guest.getBookingCount()%></td>
                        <td style="text-align: center; font-weight: 600;"><%= guest.getTotalNights()%></td>
                        <td style="text-align: center;">
                            <%
                                if (count <= 3) {
                            %>
                            <span class="status-badge status-vip">VIP</span>
                            <%
                            } else if (count > 3 && count <= 6) {
                            %>
                            <span class="status-badge status-gold">Gold</span>
                            <%
                            } else {
                            %>
                            <span class="status-badge status-silver">Silver</span>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <%                        }
                    %>

                </tbody>
            </table>
        </div>
        <%        } else {
        %>
        <h1 style="color: red">hong co ai het</h1>
        <%
            }
        %>
    </body>
</html>
