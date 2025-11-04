<%-- 
    Document   : dashboard
    Created on : Nov 5, 2025, 12:23:24 AM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Header -->
            <div class="dashboard-header">
                <div class="header-left">
                    <div class="logo">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7"></rect>
                        <rect x="14" y="3" width="7" height="7"></rect>
                        <rect x="14" y="14" width="7" height="7"></rect>
                        <rect x="3" y="14" width="7" height="7"></rect>
                        </svg>
                    </div>
                    <div class="header-title">
                        <h1>Hotel Manager Dashboard</h1>
                        <p class="header-subtitle">Reports & Analytics</p>
                    </div>
                </div>
                <a href="logout" class="logout-btn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                    </svg>
                    Logout
                </a>
            </div>

            <!-- Tab Navigation -->
            <nav class="tabs" role="tablist">
                <form action="/manager/dashboard" method="get">
                    <%
                        String currentTab = (String) request.getAttribute("CURRENT_TAB");
                        if (currentTab == null)
                            currentTab = "dashboard";
                    %>
                    <button type="submit" name="tab" value="dashboard"
                            class="tab <%= "dashboard".equals(currentTab) ? "active" : ""%>">
                        <span class="icon"></span>Dashboard
                    </button>
                    <button type="submit" name="tab" value="revenue"
                            class="tab <%= "bookings".equals(currentTab) ? "active" : ""%>">
                        <span class="icon"></span>Revenue Report Tab
                    </button>
                    <button type="submit" name="tab" value="guests"
                            class="tab <%= "checkin".equals(currentTab) ? "active" : ""%>">
                        <span class="icon"></span>Guests Report Tab
                    </button>
                    <button type="submit" name="tab" value="services"
                            class="tab <%= "rooms".equals(currentTab) ? "active" : ""%>">
                        <span class="icon"></span>Services Report Tab
                    </button>
                    <button type="submit" name="tab" value="occupancy"
                            class="tab <%= "rooms".equals(currentTab) ? "active" : ""%>">
                        <span class="icon"></span>Occupancy Report Tab
                    </button>
                    <button type="submit" name="tab" value="cancellations"
                            class="tab <%= "rooms".equals(currentTab) ? "active" : ""%>">
                        <span class="icon"></span>Cancellations Report Tab
                    </button>
                </form>
            </nav>

            <!-- Tab Contents -->
            <div id="revenue-tab" class="tab-content active">
                <jsp:include page="revenueReportTab.jsp" />
            </div>

            <div id="guests-tab" class="tab-content">
                <jsp:include page="topGuestTab.jsp" />
            </div>

            <div id="services-tab" class="tab-content">
                <jsp:include page="servicesReportTab.jsp" />
            </div>

            <div id="occupancy-tab" class="tab-content">
                <jsp:include page="occupancyReportTab.jsp" />
            </div>

            <div id="cancellations-tab" class="tab-content">
                <jsp:include page="cancelReportTab.jsp" />
            </div>
        </div>
    </body>
</html>
