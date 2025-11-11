<%-- 
    Document   : revenueReportTab
    Created on : Nov 5, 2025, 12:30:11 AM
    Author     : trinhdtu
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="model.RevenueRow"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String currentRange = (String) request.getAttribute("RANGE");
            if (currentRange == null) {
                currentRange = request.getParameter("range");
            }
            if (currentRange == null) {
                currentRange = "daily";
            }

            ArrayList<RevenueRow> list = (ArrayList<RevenueRow>) request.getAttribute("result");
        %>

        <section id="revenue" class="screen">
            <!-- Filter Section -->
            <div class="card" style="padding:16px">
                <form class="tabs" style="border-radius:12px" action="${pageContext.request.contextPath}/manager/RevenueReportController" method="get">
                    <button type="submit" name="range" value="daily"
                            class="tab <%= "daily".equals(currentRange) ? "active" : ""%>">Daily</button>
                    <button type="submit" name="range" value="monthly"
                            class="tab <%= "monthly".equals(currentRange) ? "active" : ""%>">Monthly</button>
                    <button type="submit" name="range" value="yearly"
                            class="tab <%= "yearly".equals(currentRange) ? "active" : ""%>">Yearly</button>
                </form>
            </div>

            <div class="spacer"></div>

            <!-- Main Card -->
            <div class="card" style="padding:24px">
                <div class="report-header">
                    <h2 class="report-title">
                        <% if ("daily".equals(currentRange)) { %>Daily Revenue<% } %>
                        <% if ("monthly".equals(currentRange)) { %>Monthly Revenue<% } %>
                        <% if ("yearly".equals(currentRange)) { %>Yearly Revenue<% } %>
                    </h2>
                </div>

                <div class="spacer"></div>

                <!-- Revenue Table -->
                <table class="revenue-table">
                    <thead>
                        <tr>
                            <% if ("daily".equals(currentRange)) { %>
                            <th>Date</th>
                                <% } else if ("monthly".equals(currentRange)) { %>
                            <th>Month</th>
                                <% } else { %>
                            <th>Year</th>
                                <% } %>
                            <th>Revenue</th>
                            <th>Rooms Sold</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (list != null && !list.isEmpty()) {
                                for (RevenueRow s : list) {
                        %>
                        <tr>
                            <td><%= s.getPeriod()%></td>
                            <td>$<%= s.getRevenue()%></td>
                            <td><%= s.getRoomsSold()%></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="4" style="text-align:center; padding:12px; color:#6b7280;">
                                No data found.
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>

            <div class="spacer"></div>

            <!-- Summary Grid -->
            <div class="card" style="padding:16px">
                <div class="summary-grid">
                    <div class="summary-card">
                        <div class="summary-label">Average Revenue</div>
                        <div class="summary-value">$<%= request.getAttribute("avgRevenue")%></div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">Best <%= currentRange%></div>
                        <div class="summary-value"><%= request.getAttribute("bestPeriod")%></div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">Total Revenue</div>
                        <div class="summary-value">$<%= request.getAttribute("totalRevenue")%></div>
                    </div>
                </div>
            </div>
        </section>
    </body>
</html>
