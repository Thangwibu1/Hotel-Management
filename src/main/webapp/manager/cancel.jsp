<%-- 
    Document   : cancel
    Created on : Nov 5, 2025, 10:52:11 PM
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
            <jsp:include page="components/header.jsp" />

            <jsp:include page="components/navbar.jsp" />

            <div id="cancellations-tab" class="tab-content">
                <jsp:include page="components/cancelReportTab.jsp" />
            </div>
        </div>
        <script src="./style.js"></script>
    </body>
</html>
