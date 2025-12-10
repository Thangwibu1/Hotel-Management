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
        <link rel="stylesheet" href="../manager/style.css">
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Header -->
            <jsp:include page="components/header.jsp" />

            <jsp:include page="components/navbar.jsp" />

            <!-- Tab Contents -->
            <div id="revenue-tab" class="tab-content active">
                <jsp:include page="components/revenueReportTab.jsp" />
            </div>
        </div>
        <script src="./style.js"></script>
    </body>
</html>
