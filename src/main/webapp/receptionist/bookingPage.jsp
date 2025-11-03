<%-- 
    Document   : bookingPage.jsp
    Created on : Oct 16, 2025, 11:28:52 PM
    Author     : trinhdtu
--%>

<%@page import="model.Guest"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
        <!-- ====== CSS (inline) ====== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/receptionist/style.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <jsp:include page="../receptionist/components/header.jsp" />

            <!-- Tabs -->
            <jsp:include page="../receptionist/components/nav.jsp"/>

            <jsp:include page="../receptionist/components/bookingsManage.jsp"/>

            <!-- ====== JavaScript (inline) ====== -->
        </div>
        <script src="${pageContext.request.contextPath}/receptionist/style.js"></script>
        <%
            String error = (String) request.getAttribute("ERROR");
            if (error != null) {
        %>
        <jsp:include page="../receptionist/components/errorPopup.jsp"/>
        <%
            }
        %>
    </body>
</html>
