<%-- 
    Document   : createGuestPopup
    Created on : Oct 23, 2025, 12:49:34 AM
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
    <body>
        <%
            String guestIdNum = (String) session.getAttribute("FLASH_ID_NUM");
            if (guestIdNum != null) {
                session.removeAttribute("FLASH_ID_NUM");

        %>
        <div class="bill-overlay" id="guestPopup">
            <div class="bill-modal">
                <div class="bill-header">
                    <div class="bill-icon">
                        <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
                        </svg>
                        <h2>Create Guest Account</h2>
                    </div>
                    <button class="bill-close" type="button">
                        <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>

                <div class="bill-content">
                    <p class="subtitle">Guest account not found. Please create a new account</p>

                    <div class="alert-box">
                        <svg class="alert-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <div class="alert-text">
                            No account found for <strong><%= guestIdNum != null ? guestIdNum : ""%></strong>. Please create a guest account first.
                        </div>
                    </div>

                    <form id="guestForm" action="CreateAccountController" method="post">
                        <div class="form-group">
                            <label class="form-label" for="idNumber">ID Number (Passport/Driver's License)</label>
                            <input type="text" id="idNumber" name="idNumber" class="form-input" value="<%= guestIdNum != null ? guestIdNum : ""%>" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-input" placeholder="John Doe" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-input" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" class="form-input" placeholder="+1 (555) 123-4567" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="address">Password</label>
                            <input type="password" id="password" name="password" class="form-input" placeholder="123 Main St, City, State" required>
                        </div>

                        <div class="bill-divider"></div>

                        <div class="payment-methods">
                            <button type="submit" class="create-guest-account complete-checkout-btn" style="display: flex; align-items: center; justify-content: center; gap: 10px;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
                                </svg>
                                Create Guest Account
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
