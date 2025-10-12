<%-- 
    Document   : checkManage
    Created on : Oct 5, 2025, 11:54:32 AM
    Author     : trinhdtu
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.BookingActionRow"%>
<%@page import="model.Guest"%>
<%@page import="model.Booking"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- CHECK-IN / OUT -->
        <section id="checkin" class="screen">
            <div class="card" style="padding:16px">
                <div class="search">
                    <span>?</span>
                    <input id="searchInput" placeholder="Search by guest name, email, or room number..." />
                </div>
            </div>

            <div class="spacer"></div>

            <div>
                <form class="tabs" style="border-radius:12px" action="GetPendingCheckinController" method="get">
                    <%
                        String currentTab = (String) request.getAttribute("CURRENT_TAB");
                        if (currentTab == null)
                            currentTab = "in";
                    %>

                    <button type="submit" name="tab" value="in"
                            class="tab <%= "in".equals(currentTab) ? "active" : ""%>">
                        Check-in
                    </button>

                    <button type="submit" name="tab" value="out"
                            class="tab <%= "out".equals(currentTab) ? "active" : ""%>">
                        Check-out
                    </button>
                </form>
            </div>

            <div class="spacer"></div>

            <div class="card" style="padding:16px">
                <h3 style="margin-top:0">Pending Check-ins</h3>
                <table id="tblCheckins">
                    <thead><tr><th>Guest</th><th>Room</th><th>Check-in Date</th><th>Action</th></tr></thead>
                    <tbody>

                        <%
                            ArrayList<BookingActionRow> bookings = (ArrayList<BookingActionRow>) request.getAttribute("PENDING_CHECKIN");
                            if (bookings != null && !bookings.isEmpty()) {
                                for (BookingActionRow row : bookings) {
                        %>
                        <tr>
                            <td>
                                <div><%= row.getGuest().getFullName()%></div>
                                <div class="muted" style="font-size:14px"><%= row.getGuest().getEmail()%></div>
                                <div class="muted" style="font-size:14px"><%= row.getGuest().getPhone()%></div>
                            </td>
                            <td>
                                <div><%= row.getRoom().getRoomNumber()%></div>
                                <div class="muted" style="font-size:14px"><%= row.getRoomType().getTypeName()%></div>
                            </td>
                            <td><%= row.getBooking().getCheckInDate().format(DateTimeFormatter.ofPattern("MM-dd-yyyy"))%></td>
                            <td><button class="btn primary">Check In</button></td>
                        </tr>
                        <%
                                }
                            }
                        %>

                    </tbody>
                </table>
            </div>
        </section>
    </body>
</html>
