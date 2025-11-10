<%-- 
    Document   : viewPayment.jsp
    Created on : Nov 10, 2025
    Author     : trinhdtu
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="model.PaymentWithRoomDTO"%>
<%@page import="utils.IConstant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Management • Grand Hotel</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/receptionist/style.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <jsp:include page="../receptionist/components/header.jsp" />

            <!-- Tabs -->
            <jsp:include page="../receptionist/components/nav.jsp"/>

            <!-- Search Bar -->
            <div class="card" style="padding:16px; margin-bottom: 16px">
                <form action="${pageContext.request.contextPath}/receptionist/ViewPayment" method="get">
                    <div class="search">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="16" height="16" viewBox="0 0 50 50">
                                <path d="M 21 3 C 11.601563 3 4 10.601563 4 20 C 4 29.398438 11.601563 37 21 37 C 24.355469 37 27.460938 36.015625 30.09375 34.34375 L 42.375 46.625 L 46.625 42.375 L 34.5 30.28125 C 36.679688 27.421875 38 23.878906 38 20 C 38 10.601563 30.398438 3 21 3 Z M 21 7 C 28.199219 7 34 12.800781 34 20 C 34 27.199219 28.199219 33 21 33 C 13.800781 33 8 27.199219 8 20 C 8 12.800781 13.800781 7 21 7 Z"></path>
                            </svg>
                        </span>
                        <input type="text" name="searchRoom" 
                               placeholder="Search by room number..." 
                               value="<%= request.getAttribute("searchRoom") != null ? request.getAttribute("searchRoom") : "" %>" />
                        <button type="submit" class="btn primary" style="margin-left: 8px;">Search</button>
                        <% if (request.getAttribute("searchRoom") != null) { %>
                            <a href="${pageContext.request.contextPath}/receptionist/ViewPayment" 
                               class="btn" style="margin-left: 8px;">Clear</a>
                        <% } %>
                    </div>
                </form>
            </div>

            <!-- Success/Error Messages -->
            <% 
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null && success.equals("true")) {
            %>
            <div class="card" style="padding:16px; margin-bottom: 16px; background-color: #f0fdf4; border-color: #bbf7d0;">
                <p style="margin: 0; color: #166534; font-weight: 600;">
                    ✓ Payment status updated successfully!
                </p>
            </div>
            <% } else if (error != null) { %>
            <div class="card" style="padding:16px; margin-bottom: 16px; background-color: #fef2f2; border-color: #fecaca;">
                <p style="margin: 0; color: #991b1b; font-weight: 600;">
                    ✗ Error: <%= error.replace("_", " ") %>
                </p>
            </div>
            <% } %>

            <!-- Payment Table -->
            <div class="card">
                <div style="padding: 20px; border-bottom: 1px solid var(--line);">
                    <h2 class="panel-title" style="margin: 0; font-size: 20px;">Payment Records</h2>
                    <p style="color: var(--muted); font-size: 14px; margin: 4px 0 0;">
                        View and manage payment transactions
                    </p>
                </div>
                
                <%
                    ArrayList<PaymentWithRoomDTO> paymentList = 
                        (ArrayList<PaymentWithRoomDTO>) request.getAttribute("paymentList");
                    
                    if (paymentList == null || paymentList.isEmpty()) {
                %>
                <div style="padding: 40px; text-align: center;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="none" 
                         viewBox="0 0 24 24" stroke="currentColor" style="color: var(--muted); margin: 0 auto 16px;">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                              d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                    </svg>
                    <p style="color: var(--muted); font-size: 16px;">No payments found</p>
                </div>
                <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Booking ID</th>
                            <th>Room Number</th>
                            <th>Guest Name</th>
                            <th>Payment Date</th>
                            <th>Amount</th>
                            <th>Method</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (PaymentWithRoomDTO payment : paymentList) { %>
                        <tr>
                            <td><strong>#<%= payment.getPaymentId() %></strong></td>
                            <td>#<%= payment.getBookingId() %></td>
                            <td><strong><%= payment.getRoomNumber() %></strong></td>
                            <td><%= payment.getGuestName() %></td>
                            <td><%= IConstant.formatDate(payment.getPaymentDate()) %></td>
                            <td style="font-weight: 700;">$<%= String.format("%.2f", payment.getAmount()) %></td>
                            <td><%= payment.getPaymentMethod() %></td>
                            <td>
                                <% 
                                    String status = payment.getStatus();
                                    String badgeClass = "gray";
                                    if (status.equals("Completed")) {
                                        badgeClass = "green";
                                    } else if (status.equals("Failed")) {
                                        badgeClass = "red";
                                    } else if (status.equals("Pending")) {
                                        badgeClass = "yellow";
                                    }
                                %>
                                <span class="badge <%= badgeClass %>"><%= status %></span>
                            </td>
                            <td>
                                <div class="actions">
                                    <% if (!status.equals("Completed")) { %>
                                    <form action="${pageContext.request.contextPath}/receptionist/UpdatePaymentStatus" 
                                          method="post" style="display: inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>" />
                                        <input type="hidden" name="status" value="Completed" />
                                        <% if (request.getAttribute("searchRoom") != null) { %>
                                            <input type="hidden" name="searchRoom" value="<%= request.getAttribute("searchRoom") %>" />
                                        <% } %>
                                        <button type="submit" class="btn" 
                                                style="background: #e7f9ef; color: #166534; border-color: #bbf7d0;"
                                                onclick="return confirm('Mark this payment as Completed?')">
                                            ✓ Complete
                                        </button>
                                    </form>
                                    <% } %>
                                    
                                    <% if (!status.equals("Failed")) { %>
                                    <form action="${pageContext.request.contextPath}/receptionist/UpdatePaymentStatus" 
                                          method="post" style="display: inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>" />
                                        <input type="hidden" name="status" value="Failed" />
                                        <% if (request.getAttribute("searchRoom") != null) { %>
                                            <input type="hidden" name="searchRoom" value="<%= request.getAttribute("searchRoom") %>" />
                                        <% } %>
                                        <button type="submit" class="btn" 
                                                style="background: #fee2e2; color: #991b1b; border-color: #fecaca;"
                                                onclick="return confirm('Mark this payment as Failed?')">
                                            ✗ Failed
                                        </button>
                                    </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>

            <div class="spacer"></div>
        </div>
        
        <script src="${pageContext.request.contextPath}/receptionist/style.js"></script>
    </body>
</html>

