<%-- 
    Document   : checkExistGuest
    Created on : Oct 20, 2025, 5:43:34 PM
    Author     : trinhdtu
--%>

<%@page import="model.RoomInformation"%>
<%@page import="java.util.ArrayList"%>
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
            String idNum = (String) request.getAttribute("FLASH_ID_NUM");
            Guest guest = (Guest) request.getAttribute("GUEST");

        %>
        <div class="booking-header">
            <h1 class="booking-title">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                New Booking
            </h1>
            <a href="${pageContext.request.contextPath}/receptionist/BookingsController" class="back-link">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                </svg>
                Back to List
            </a>
        </div>

        <!-- Verification Form -->
        <div class="card verification-card">
            <h2 class="verification-title">Verify Guest Account</h2>
            <p class="verification-subtitle">Enter guest email to check if account exists</p>
            <form id="verificationForm" action="CheckGuestController" method="POST">
                <div class="verify">
                    <div class="form-group">
                        <input 
                            type="text" 
                            id="guestId" 
                            name="guestId" 
                            class="form-input form-input-large" 
                            placeholder="012345678"
                            required
                            value="<%= idNum != null ? idNum : ""%>"
                            >
                    </div>

                    <button type="submit" class="btn primary submit-btn" style="display: flex; align-items: center; justify-content: center; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        Check Guest Account
                    </button>
                </div>
            </form>

            <%            if (guest != null) {
            %>
            <jsp:include page="../components/createBookingPopup.jsp"/>
            <%
            } else {
            %>
            <jsp:include page="../components/createGuestPopup.jsp"/>
            <%
                }
            %>
        </div>



    </body>
</html>
