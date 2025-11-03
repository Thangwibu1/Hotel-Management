<%-- 
    Document   : showRooms
    Created on : Oct 30, 2025, 12:25:45 PM
    Author     : trinhdtu
--%>

<%@page import="model.Guest"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="model.RoomInformation"%>
<%@page import="java.util.ArrayList"%>
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
            ArrayList<RoomInformation> result = (ArrayList<RoomInformation>) request.getAttribute("AVAIL_LIST");
            LocalDate ciDate = (LocalDate) request.getAttribute("CHECKIN");
            LocalDate coDate = (LocalDate) request.getAttribute("CHECKOUT");
            Guest guest = (Guest) request.getAttribute("GUEST");

            long nights = 0;
            if (request.getAttribute("NIGHT") != null) {
                nights = (long) request.getAttribute("NIGHT");
            }
            if (guest != null) {


        %>
        <div class="room-selection-container">
            <div class="card selection-card">
                <h1 class="page-title">Select Room</h1>

                <!-- Booking Info -->
                <div class="booking-info-box">
                    <div class="info-item">
                        <span class="info-label">Check-in:</span>
                        <span class="info-value" id="displayCheckin"><%= ciDate%></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Check-out:</span>
                        <span class="info-value" id="displayCheckout"><%= coDate%></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Duration:</span>
                        <span class="info-value" id="displayDuration"><%= nights%></span>
                    </div>
                </div>

                <!-- Rooms Grid -->

                <form id="bookingForm" action="BookRoomController" method="POST">
                    <input type="hidden" name="selectedRoomId" id="selectedRoomId">
                    <input type="hidden" name="guestId" value="<%=guest.getGuestId()%>">
                    <input type="hidden" name="checkInTime" value="<%=ciDate%>">
                    <input type="hidden" name="checkOutTime" value="<%= coDate%>">
                    <input type="hidden" name="bookingDate" id="bookingDate">
                    <div class="rooms-grid">
                        <%
                            if (result != null && !result.isEmpty()) {
                                for (RoomInformation room : result) {
                                    java.math.BigDecimal price = room.getRoomType().getPricePerNight();
                                    java.math.BigDecimal total = price.multiply(java.math.BigDecimal.valueOf(nights));
                        %>
                        <div class="room-card"
                             data-room-id="<%=room.getRoom().getRoomId()%>"
                             data-room-type-id="<%=room.getRoomType().getRoomTypeId()%>"
                             data-price="<%=price%>">
                            <div class="room-header">
                                <svg class="room-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="8" width="18" height="11" rx="2"></rect>
                                <path d="M7 8V6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2"></path>
                                </svg>
                                <h3 class="room-title"><%= room.getRoom().getRoomNumber()%></h3>
                            </div>
                            <p class="room-type"><%= room.getRoomType().getTypeName()%></p>

                            <div class="room-pricing">
                                <div class="pricing-item">
                                    <span class="pricing-label">Price</span>
                                    <span class="pricing-value">$<%= price%>/night</span>
                                </div>
                                <div class="pricing-item">
                                    <span class="pricing-label">Total</span>
                                    <span class="pricing-value total-value">$<%= total%></span>
                                </div>
                            </div>
                        </div>
                        <%
                                    }
                                } // end for
                            } // end if
                        %>
                    </div>  

                    <!-- Buttons -->
                    <div class="button-group">

                        <button type="button" class="btn-back" >
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            Back
                        </button>
                        <button type="submit" class="btn-continue" id="continueBtn" disabled>
                            Continue to Services
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
