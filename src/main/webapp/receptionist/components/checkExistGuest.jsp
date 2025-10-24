<%-- 
    Document   : checkExistGuest
    Created on : Oct 20, 2025, 5:43:34 PM
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
        <div id="verifyGuestPopup" class="bill-overlay" style="display: none;">
            <div class="bill-modal">
                <div class="bill-header">
                    <div class="bill-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <h2>Verify Guest Account</h2>
                    </div>
                    <button class="bill-close" onclick="closeVerifyGuestPopup()">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
                <div class="bill-content">
                    <div class="hotel-info">
                        <p style="color: #6b7280; margin-bottom: 20px;">Enter guest ID Number to check</p>
                    </div>

                    <form id="verifyGuestForm" method="post" action="${pageContext.request.contextPath}/CheckGuestController">
                        <div style="margin-bottom: 20px;">
                            <label for="guestId" style="display: block; margin-bottom: 8px; font-weight: 600; color: #374151; font-size: 14px;">
                                ID Number (Passport/Driver's License)
                            </label>
                            <div class="search" style="margin: 0;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                                <input 
                                    type="idNum" 
                                    id="guestId" 
                                    name="guestId" 
                                    placeholder="012345600001"
                                    required
                                    />
                            </div>
                        </div>

                        <button type="submit" class="complete-checkout-btn" style="display: flex; align-items: center; justify-content: center; gap: 10px;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            Check Guest Account
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <%
            String action = (String) session.getAttribute("FLASH_NEXT_WAY");
            if (action != null) {
                if (action.equalsIgnoreCase("booking")) {
        %>
        <jsp:include page="../components/createBookingPopup.jsp" />
        <%
        } else if (action.equalsIgnoreCase("createAcc")) {
        %>
        <jsp:include page="../components/createGuestPopup.jsp" />
        <%
                }
            }
            HttpSession ss = request.getSession(false);
            if (ss != null) {
                ss.removeAttribute("FLASH_ID_NUM");
                ss.removeAttribute("FLASH_NEXT_WAY");
            }
        %>


    </body>
</html>
