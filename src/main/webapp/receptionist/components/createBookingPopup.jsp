<%-- 
    Document   : createBooking
    Created on : Oct 23, 2025, 9:10:58 AM
    Author     : trinhdtu
--%>

<%@page import="model.Guest"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>

        <%
            Guest guest = (Guest) request.getAttribute("GUEST");
            if (guest != null) {

        %>
        
        <div class="dates-container">
            <div class="card dates-card">
                <h1 class="page-title">Select Stay Dates</h1>

                <!-- Verified Box -->
                <div class="verified-box">
                    <svg class="verified-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    <p class="verified-text">
                        Guest account verified: <strong id="verifiedName"><%= guest.getFullName()%></strong>
                    </p>
                </div>

                <!-- Form -->
                <form id="datesForm" action="CheckAvailabilityRoomController" method="POST">
                    <input type="hidden" name="guestId" value="<%= guest.getGuestId()%>">
                    <h1><%= guest.getGuestId()%></h1>
                    <!-- Guest Info Row -->
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="guestName">Guest Name</label>
                            <input 
                                type="text" 
                                id="guestName" 
                                name="guestName" 
                                class="form-input" 
                                value="<%= guest.getFullName()%>"
                                readonly
                                >
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="numberOfGuests">Number of Guests</label>
                            <select 
                                id="numberOfGuests" 
                                name="numberOfGuests" 
                                class="form-select"
                                required
                                >
                                <option value="1">1 Guest</option>
                                <option value="2">2 Guests</option>
                                <option value="3">3 Guests</option>
                                <option value="4">4 Guests</option>
                                <option value="5">5 Guests</option>
                                <option value="6">6 Guests</option>
                            </select>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            class="form-input" 
                            value="<%= guest.getEmail()%>"
                            readonly
                            disabled
                            >
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label class="form-label" for="phone">Phone</label>
                        <input 
                            type="tel" 
                            id="phone" 
                            name="phone" 
                            class="form-input" 
                            value="<%= guest.getPhone()%>"
                            readonly
                            disabled
                            >
                    </div>

                    <!-- Dates Row -->
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="checkinDate">Check-in Date</label>
                            <input 
                                type="date" 
                                id="checkinDate" 
                                name="checkinDate" 
                                class="form-input"
                                required
                                >
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="checkoutDate">Check-out Date</label>
                            <input 
                                type="date" 
                                id="checkoutDate" 
                                name="checkoutDate" 
                                class="form-input"
                                required
                                >
                        </div>
                    </div>
                    <p style="color: red"><%
                        if (request.getAttribute("ERROR") != null) {
                            out.print(request.getAttribute("ERROR"));
                        }
                        %>
                    </p>
                    <!-- Hidden fields for guest info -->
                    <input type="hidden" name="guestId" id="guestId" value="<%= guest.getGuestId()%>">

                    <!-- Buttons -->
                    <div class="button-group">
                        <button type="submit" class="btn-primary">
                            Check Availability
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>
