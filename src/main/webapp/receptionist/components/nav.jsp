<%-- 
    Document   : nav
    Created on : Oct 12, 2025, 2:19:21 PM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <nav class="tabs" role="tablist">
            <form action="./receptionist" method="get">
                <%
                    String currentTab = (String) request.getAttribute("CURRENT_TAB");
                    if (currentTab == null)
                        currentTab = "dashboard";
                %>
                <button type="submit" name="tab" value="dashboard"
                        class="tab <%= "dashboard".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Dashboard
                </button>
                <button type="submit" name="tab" value="bookings"
                        class="tab <%= "bookings".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Bookings
                </button>
                <button type="submit" name="tab" value="checkin"
                        class="tab <%= "checkin".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Check-in/Out
                </button>
                <button type="submit" name="tab" value="rooms"
                        class="tab <%= "rooms".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Room Status
                </button>
                <button type="submit" name="tab" value="payment"
                        class="tab <%= "payment".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Payment
                </button>
            </form>
        </nav>
    </body>
</html>
