<%-- 
    Document   : checkPage
    Created on : Oct 12, 2025, 5:07:17 PM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
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

            <!-- ====== JavaScript (inline) ====== -->
            <script src="../receptionist/style.js"></script>
    </body>
</html>
