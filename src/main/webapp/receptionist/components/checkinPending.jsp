<%-- 
    Document   : checkinPending
    Created on : Oct 12, 2025, 5:45:50 PM
    Author     : trinhdtu
--%>

<%@page import="utils.IConstant"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.BookingActionRow"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>

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
            <td><%= row.getBooking().getCheckInDate().format(IConstant.dateFormat)%></td>

            <td>
                <form action="CheckInController" method="post">
                    <input type="hidden" name="bookingId" value="<%= row.getBooking().getBookingId()%>">
                    <button type="submit" value="checkIn" class="btn primary">Check In</button>
                </form>
            </td>
        </tr>
        <%
                }
            }
        %>

    </tbody>
</table>
