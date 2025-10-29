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
            String guestIdNum = (String) request.getAttribute("FLASH_ID_NUM");
            if (guestIdNum != null) {

        %>
        <div class="create-guest-container">
            <div class="card create-guest-card">
                <h1 class="page-title">Create Guest Account</h1>

                <!-- Alert Box -->
                <div class="info-alert">
                    <svg class="info-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                    </svg>
                    <p class="info-text">
                        No account found for <strong id="displayEmail"><%= guestIdNum%></strong>. Please create a guest account first.
                    </p>
                </div>

                <!-- Form -->
                <form id="createGuestForm" action="CreateAccountController" method="POST">
                    <!-- Full Name -->
                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name</label>
                        <input 
                            type="text" 
                            id="fullName" 
                            name="fullName" 
                            class="form-input" 
                            placeholder="John Doe"
                            required
                            >
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            class="form-input" 
                            placeholder="abc@gmail.com"
                            required=""
                            >
                        <!-- Hidden input to submit email -->
                        <input type="hidden" name="emailValue" id="emailValue" value="abc@gmail.com">
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label class="form-label" for="phone">Phone</label>
                        <input 
                            type="tel" 
                            id="phone" 
                            name="phone" 
                            class="form-input" 
                            placeholder="+1 (555) 123-4567"
                            required
                            >
                    </div>
                    <!-- ID Number -->
                    <div class="form-group">
                        <label class="form-label" for="idNumber">ID Number (Passport/Driver's License)</label>
                        <input 
                            type="text" 
                            id="idNumber" 
                            name="idNumber" 
                            class="form-input" 
                            placeholder="DL123456 or PP987654"
                            value="<%= guestIdNum%>"
                            readonly
                            >
                    </div>
                    <!-- pw -->
                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            class="form-input" 
                            required
                            >
                    </div>
                    <!-- Buttons -->
                    <div class="button-group">
                        <button type="button" class="btn-back">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            Back
                        </button>
                        <button type="submit" class="btn-create">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <line x1="19" y1="8" x2="19" y2="14"></line>
                            <line x1="22" y1="11" x2="16" y2="11"></line>
                            </svg>
                            Create Account
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
