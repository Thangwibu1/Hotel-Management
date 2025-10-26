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
            Guest guest = (Guest) session.getAttribute("GUEST");
            // N?u null, th? l?y t? session
            if (guest != null) {
                session.removeAttribute("GUEST");

        %>
        <div class="bill-overlay is-open" id="bookingPopup">
            <div class="bill-modal">
                <div class="bill-header">
                    <div class="bill-icon bill-icon-vertical">
                        <h2>Create New Booking</h2>
                        <p class="subtitle" style="margin: 0;">Creating booking for <%= (guest != null ? guest.getFullName() : "")%></p>
                    </div>
                    <button class="bill-close" onclick="closePopup()" type="button">
                        <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>

                <div class="bill-content">
                    <div class="verified-box">
                        <svg class="verified-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <div class="verified-text">Guest account verified: <%= (guest != null ? guest.getFullName() : "")%></div>
                    </div>

                    <form id="bookingForm" onsubmit="handleSubmit(event)">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="guestName">Guest Name</label>
                                <input type="text" id="guestName" name="guestName" class="form-input" value="<%= (guest != null ? guest.getFullName() : "")%>" disabled>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="numGuests">Number of Guests</label>
                                <select id="numGuests" name="numGuests" class="form-select" required>
                                    <option value="1">1 Guest</option>
                                    <option value="2">2 Guests</option>
                                    <option value="3">3 Guests</option>
                                    <option value="4">4 Guests</option>
                                    <option value="5">5+ Guests</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-input" value="<%= (guest != null ? guest.getEmail(): "")%>" disabled>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" class="form-input" value="<%= (guest != null ? guest.getPhone(): "")%>" disabled>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="room">Room</label>
                            <select id="room" name="room" class="form-select" required>
                                <option value="">Select room</option>
                                <option value="101">Room 101 - Deluxe Single</option>
                                <option value="102">Room 102 - Deluxe Double</option>
                                <option value="201">Room 201 - Suite</option>
                                <option value="202">Room 202 - Presidential Suite</option>
                                <option value="301">Room 301 - Standard Single</option>
                            </select>
                        </div>

                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="checkout">Check-in</label>
                                <input type="date" id="checkin" name="checkin" class="form-input" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="checkout">Check-out</label>
                                <input type="date" id="checkout" name="checkout" class="form-input" required>
                            </div>
                        </div>

                        <div class="payment-methods">
                            <button type="submit" class="payment-btn create-btn">
                                Create Booking
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>
