<%-- 
    Document   : bookingsManage
    Created on : Oct 5, 2025, 11:53:14 AM
    Author     : trinhdtu
--%>

<%@page import="utils.IConstant"%>
<%@page import="utils.IConstant"%>
<%@page import="model.BookingActionRow"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- BOOKINGS -->
        <%
            String step = (String) request.getAttribute("CURRENT_STEP");
            if (step == null) {
                step = "manage";
            }
            if ("manage".equalsIgnoreCase(step)) {
        %>
        <div class="card" style="padding:16px; margin-bottom: 16px">
            <div class="search">
                <span><svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="16" height="16" viewBox="0 0 50 50">
                    <path d="M 21 3 C 11.601563 3 4 10.601563 4 20 C 4 29.398438 11.601563 37 21 37 C 24.355469 37 27.460938 36.015625 30.09375 34.34375 L 42.375 46.625 L 46.625 42.375 L 34.5 30.28125 C 36.679688 27.421875 38 23.878906 38 20 C 38 10.601563 30.398438 3 21 3 Z M 21 7 C 28.199219 7 34 12.800781 34 20 C 34 27.199219 28.199219 33 21 33 C 13.800781 33 8 27.199219 8 20 C 8 12.800781 13.800781 7 21 7 Z"></path>
                    </svg></span>
                <input id="searchInput" placeholder="Search by guest name, email, or room number..." />
            </div>
        </div>
        <section id="bookings" class="screen">
            <div class="card" style="padding:16px">
                <div style="display:flex;justify-content:space-between;align-items:center;gap:12px">
                    <h2 class="panel-title">Booking Management</h2>
                    <form action="NewBookingController">
                        <button class="btn primary btnNewBooking" type="submit">New Booking</button>
                    </form>
                </div>
                <div class="spacer"></div>
                <table id="tblCheckins">
                    <thead>
                        <tr>
                            <th>Guest</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%                            ArrayList<BookingActionRow> listRow = (ArrayList<BookingActionRow>) request.getAttribute("RESULT");
                            if (listRow != null && !listRow.isEmpty()) {
                                for (BookingActionRow row : listRow) {
                        %>
                        <tr>
                            <td>
                                <div><%= row.getGuest().getFullName()%> </div>
                                <div class="muted" style="font-size:14px"><%= row.getGuest().getEmail()%></div>
                            </td>
                            <td>
                                <div><%= row.getRoom().getRoomNumber()%></div>
                                <div class="muted" style="font-size:14px"><%= row.getRoomType().getTypeName()%></div>
                            </td>
                            <td><%= row.getBooking().getCheckInDate().format(IConstant.dateFormat)%></td>
                            <td><%= row.getBooking().getCheckOutDate().format(IConstant.dateFormat)%></td>
                            <td class="booking-status"><span class="badge"><%= row.getBooking().getStatus()%></span></td>
                            <td>
                                <form action="ActionBookingController">
                                    <div class="actions">

                                        <input type="hidden" name="bookingId" value="<%= row.getBooking().getBookingId()%>">
                                        <button class="btn icon" type="submit" name="action" value="view" title="Edit"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pencil-icon lucide-pencil"><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/></svg></button>

                                        <button class="btn icon" type="submit" name="action" value="delete"
                                                title="Delete" onclick="return confirm('Delete this booking?');"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2-icon lucide-trash-2"><path d="M10 11v6"/><path d="M14 11v6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></button>

                                    </div>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>

        </section>
        <%
        } else if ("checkGuest".equalsIgnoreCase(step)) {
        %>
        <jsp:include page="../components/checkExistGuest.jsp"/>
        <%
        } else if ("selectRoom".equalsIgnoreCase(step)) {
        %>
        <jsp:include page="../components/showRooms.jsp"/>
        <%
        } else if ("addServices".equalsIgnoreCase(step)) {
        %>
        <jsp:include page="../components/addServicePage.jsp"/>
        <%
        } else if ("detail".equalsIgnoreCase(step)) {
        %>
        <jsp:include page="../components/detailBookingPage.jsp"/>
        <%
        } else if ("edit".equalsIgnoreCase(step)) {
        %>
        <jsp:include page="../components/editBookingPage.jsp"/>
        <%
            }
        %>
    </body>
</html>
