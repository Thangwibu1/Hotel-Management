<%-- 
    Document   : detailBookingPage
    Created on : Nov 3, 2025, 3:38:53 PM
    Author     : trinhdtu
--%>

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
            ArrayList<ServiceDetail> services = (ArrayList<ServiceDetail>) request.getAttribute("SERVICE_DETAILS");
            BigDecimal roomTotal = (BigDecimal) request.getAttribute("ROOM_TOTAL");
            BigDecimal serviceTotal = (BigDecimal) request.getAttribute("SERVICE_TOTAL");
            BigDecimal grandTotal = (BigDecimal) request.getAttribute("GRAND_TOTAL");
            long nights = (long) request.getAttribute("nights");

        %>
        <div class="details-container">
            <!-- Header -->
            <div class="details-header">
                <div class="header-left">
                    <svg class="header-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                    <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                    <div class="header-title-group">
                        <h1>Booking Details</h1>
                        <p class="booking-id">ID: <%= booking.getBookingId() %></p>
                    </div>
                </div>
                <div class="header-right">
                    <span class="status-badge">CONFIRMED</span>
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
                            <div class="info-value"><%= row.getGuest().getFullName()%></div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Number of Guests</div>
                            <div class="info-value">2 guests</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Email Address</div>
                            <div class="info-value">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                                <%= row.getGuest().getEmail()%>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Phone Number</div>
                            <div class="info-value">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                </svg>
                                <%= row.getGuest().getPhone()%>
                            </div>
                        </div>
                    </div>

                    <!-- Room Information -->
                    <div class="card info-card" style="margin-top: 24px;">
                        <div class="card-header">
                            <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="8" width="18" height="11" rx="2"></rect>
                            <path d="M7 8V6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2"></path>
                            </svg>
                            <h2 class="card-title">Room Information</h2>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Room Number</div>
                            <div class="info-value">Room <%= row.getRoom().getRoomNumber()%></div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Room Type</div>
                            <div class="info-value"><%= row.getRoomType().getTypeName()%></div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Rate per Night</div>
                            <div class="info-value">$<%= row.getRoomType().getPricePerNight()%></div>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div>
                    <!-- Stay Information -->
                    <div class="card info-card">
                        <div class="card-header">
                            <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <h2 class="card-title">Stay Information</h2>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Check-in Date</div>
                            <div class="info-value">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <%= row.getBooking().getCheckInDate()%>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Check-out Date</div>
                            <div class="info-value">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <%= row.getBooking().getCheckOutDate()%>
                            </div>
                        </div>

                    </div>
                    <div class="card info-card" style="margin-top:24px;">
                        <div class="card-header">
                            <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 6h18v12H3z"></path><path d="M3 10h18"></path>
                            </svg>
                            <h2 class="card-title">Service Details</h2>
                        </div>
                        <%
                            if (services != null && !services.isEmpty()) {
                        %>
                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th style="text-align:left;">Service</th>
                                    <th style="text-align:right;">Unit Price</th>
                                    <th style="text-align:center;">Qty</th>
                                    <th style="text-align:center;">Date</th>
                                    <th style="text-align:right;">Line Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ServiceDetail d : services) {%>
                                <tr>
                                    <td style="text-align:left;"><%= d.getServiceName()%></td>
                                    <td style="text-align:center;"><%= d.getPrice()%></td>
                                    <td style="text-align:center;"><%= d.getQuantity()%></td>
                                    <td style="text-align:center;"><%= d.getServiceDate() != null ? d.getServiceDate() : ""%></td>
                                    <td style="text-align:right;">$<%= d.getPrice().multiply(BigDecimal.valueOf(d.getQuantity())) %></td>
                                </tr>
                                <% }%>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="4" style="text-align:right;"><strong>Services Total</strong></td>
                                    <td style="text-align:right;"><strong>$<%= serviceTotal%></strong></td>
                                </tr>
                            </tfoot>
                        </table>
                        <%
                        } else {
                        %>
                        <p class="muted">No services used.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
                <!-- Payment Summary -->
                <div class="payment-summary" style="margin-top: 24px;">
                    <div class="summary-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                        </svg>
                        <h3 class="summary-title">Payment Summary</h3>
                    </div>

                    <div class="summary-row">
                        <span class="summary-label">Room Charges (<%= nights%>  nights)</span>
                        <span class="summary-value">$<%= roomTotal%></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Services Charges</span>
                        <span class="summary-value">$<%= serviceTotal%></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Total Amount</span>
                        <span class="summary-value">$<%= grandTotal%></span>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="http://localhost:8080/PRJ_Assignment/receptionist/receptionist?tab=bookings" class="btn-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    Back to List
                </a>
                <a href="edit-booking.jsp?id=1" class="btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                    Edit Booking
                </a>
            </div>
        </div>
    </body>
</html>
