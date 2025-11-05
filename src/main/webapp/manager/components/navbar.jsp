<%-- 
    Document   : navbar
    Created on : Nov 5, 2025, 10:44:58 PM
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
        <!-- Tab Navigation -->
        <nav class="tabs" role="tablist">
            <form action="${pageContext.request.contextPath}/manager/dashboard" method="get">
                <%
                    String currentTab = (String) request.getAttribute("CURRENT_TAB");
                    if (currentTab == null)
                        currentTab = "dashboard";
                %>
                <button type="submit" name="tab" value="dashboard"
                        class="tab <%= "dashboard".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Revenue Report Tab
                </button>
                <button type="submit" name="tab" value="guests"
                        class="tab <%= "guests".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Guests Report Tab
                </button>
                <button type="submit" name="tab" value="services"
                        class="tab <%= "services".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Services Report Tab
                </button>
                <button type="submit" name="tab" value="occupancy"
                        class="tab <%= "occupancy".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Occupancy Report Tab
                </button>
                <button type="submit" name="tab" value="cancellations"
                        class="tab <%= "cancellations".equals(currentTab) ? "active" : ""%>">
                    <span class="icon"></span>Cancellations Report Tab
                </button>
            </form>
        </nav>
    </body>
</html>
