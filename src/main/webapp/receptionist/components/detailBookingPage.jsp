<%-- 
    Document   : detailBookingPage
    Created on : Nov 3, 2025, 3:38:53 PM
    Author     : trinhdtu
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.ServiceDetail"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Service"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.Booking"%>
<%@page import="model.BookingActionRow"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            BookingActionRow row = (BookingActionRow) request.getAttribute("DETAIL_ROW");
            Booking booking = (Booking) request.getAttribute("BOOKING");
            BigDecimal serviceTotal = (BigDecimal) request.getAttribute("SERVICE_TOTAL");
            BigDecimal grandTotal = (BigDecimal) request.getAttribute("GRAND_TOTAL");
            long nights = (long) request.getAttribute("nights");
            
            String st = booking.getStatus(); // "Reserved", "Checked-in", "Check-out", "Canceled"

            boolean canEditAll = "Reserved".equalsIgnoreCase(st);
            boolean canEditCheckin = "Checked-in".equalsIgnoreCase(st);
            boolean canEditNone = "Check-out".equalsIgnoreCase(st) || "Canceled".equalsIgnoreCase(st);

            // Quy?n theo module
            boolean allowGuest = canEditAll || canEditCheckin;
            boolean allowAssignRoom = canEditAll || canEditCheckin;
            boolean allowStayDates = canEditAll;
            boolean allowServices = canEditAll || canEditCheckin;

            // Truy?n cho các file include dùng
            request.setAttribute("ALLOW_GUEST", allowGuest);
            request.setAttribute("ALLOW_ASSIGN_ROOM", allowAssignRoom);
            request.setAttribute("ALLOW_STAY_DATES", allowStayDates);
            request.setAttribute("ALLOW_SERVICES", allowServices);
        %>
        <div class="details-container">
            <form id="bookingForm" action="<%= request.getContextPath() %>/receptionist/EditBookingController" method="POST">
                <input type="hidden" name="bookingId" value="<%= booking.getBookingId()%>">
                <!-- Header -->
                <div class="details-header">
                    <div class="header-left">
                        <svg class="header-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                        <div class="header-title-group">
                            <h1>Booking Details</h1>
                            <p class="booking-id">ID: <%= booking.getBookingId()%></p>
                        </div>
                    </div>
                    <div class="header-right">
                        <span class="status-badge"><%= booking.getStatus()%></span>
                        <a href="http://localhost:8080/PRJ_Assignment/receptionist/receptionist?tab=bookings" class="back-link">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            Back to List
                        </a>
                    </div>
                </div>

                <!-- Main Content Grid -->
                <div class="details-grid">
                    <!-- Left Column -->
                    <div>
                        <!-- Guest Information -->
                        <div class="card info-card">
                            <div class="card-header">
                                <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <h2 class="card-title">Guest Information</h2>
                            </div>

                            <div class="info-item">
                                <div class="info-label">Full Name</div>
                                <input 
                                    type="text" 
                                    id="guestName" 
                                    name="guestName" 
                                    class="form-input" 
                                    value="<%= row.getGuest().getFullName()%>"
                                    <%= allowGuest ? "" : "redonly disabled"%>
                                    >
                            </div>

                            <div class="info-item">

                                <div class="info-value">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                    <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg><div class="info-label">Email Address</div>


                                </div>
                                <input 
                                    type="email" 
                                    id="email" 
                                    name="email" 
                                    class="form-input" 
                                    value="<%= row.getGuest().getEmail()%>"
                                    <%= allowGuest ? "" : "redonly disabled"%>
                                    >
                            </div>

                            <div class="info-item">

                                <div class="info-value">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                    </svg>
                                    <div class="info-label">Phone Number</div>

                                </div>
                                <input 
                                    type="tel" 
                                    id="phone" 
                                    name="phone" 
                                    class="form-input" 
                                    value="<%= row.getGuest().getPhone()%>"
                                    <%= allowGuest ? "" : "redonly disabled"%>
                                    >
                            </div>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div>
                        <!-- Room Information -->
                        <jsp:include page="../components/assignRoom.jsp">
                            <jsp:param name="ALLOW_ASSIGN_ROOM" value="<%= String.valueOf(allowAssignRoom)%>" />
                        </jsp:include>

                    </div>
                </div>
                <!-- Stay Information -->
                <div class="card info-card" style="margin-top: 24px;">
                    <div class="card-header">
                        <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                        <h2 class="card-title">Stay Information</h2>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Check-in Date</div>
                        <input 
                            type="date" 
                            id="checkinDate" 
                            name="checkinDate" 
                            class="form-input"
                            value="<%= row.getBooking().getCheckInDate().toLocalDate().toString()%>"
                            redonly disabled
                            >


                    </div>

                    <div class="info-item" >
                        <div class="info-label">Check-out Date</div>
                        <input 
                            type="date" 
                            id="checkoutDate" 
                            name="checkoutDate" 
                            class="form-input"
                            value="<%= row.getBooking().getCheckOutDate().toLocalDate().toString()%>"
                            redonly disabled
                            >
                    </div>
                </div>
                <jsp:include page="../components/editServices.jsp">
                    <jsp:param name="ALLOW_SERVICES" value="<%= String.valueOf(allowServices)%>" />
                </jsp:include>

                
            </form>
        </div>
    </body>
</html>
