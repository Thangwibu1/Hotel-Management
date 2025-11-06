<%-- 
    Document   : servicesReportTab
    Created on : Nov 5, 2025, 12:28:51 AM
    Author     : trinhdtu
--%>

<%@page import="model.ServiceUsage"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            ArrayList<ServiceUsage> result = (ArrayList<ServiceUsage>) request.getAttribute("mostUsedServices");
            if (result != null && !result.isEmpty()) {


        %>
        <div class="card" style="padding: 32px;">
            <div class="services-header">
                <h2 class="services-title">Most Used Services</h2>
            </div>

            <table class="services-table">
                <thead>
                    <tr>
                        <th>Service Name</th>
                        <th style="text-align: center;">Requests</th>
                        <th style="text-align: right;">Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <%                        for (ServiceUsage service : result) {
                    %>
                    <tr>
                        <td style="font-weight: 600;"><%= service.getServiceName()%></td>
                        <td style="text-align: center;"><%= service.getTotalUsed()%></td>
                        <td style="text-align: right; font-weight: 600;">$<%= service.getTotalRevenue()%></td>
                    </tr>
                    <%
                        }
                    %>

                </tbody>
            </table>

            <%
                }
            %>
    </body>
</html>
