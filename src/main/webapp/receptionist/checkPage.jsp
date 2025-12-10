<%-- 
    Document   : checkPage
    Created on : Oct 12, 2025, 5:07:17 PM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <!-- ====== CSS (inline) ====== -->
        <link rel="stylesheet" href="../receptionist/style.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <jsp:include page="../receptionist/components/header.jsp" />

            <!-- Tabs -->
            <jsp:include page="../receptionist/components/nav.jsp"/>

            <jsp:include page="../receptionist/components/checkManage.jsp"/>
            <%
                String error = (String) request.getAttribute("ERROR");
                if (error != null) {
            %>
            <jsp:include page="../receptionist/components/errorPopup.jsp"/>
            <%
                }
            %>
            <!-- ====== JavaScript (inline) ====== -->
        </div>
        <script src="../receptionist/style.js"></script>
    </body>
</html>
