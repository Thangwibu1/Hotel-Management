<%-- 
    Document   : guest
    Created on : Nov 5, 2025, 10:48:53 PM
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
        
        <!--hahah-->
        <div class="dashboard-container">
            <jsp:include page="components/header.jsp" />

            <jsp:include page="components/navbar.jsp" />

            <div id="guests-tab" class="tab-content">
                <jsp:include page="components/topGuestTab.jsp" />
            </div></div>
        <script src="./style.js"></script>
    </body>
</html>
