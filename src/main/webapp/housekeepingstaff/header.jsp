<%-- 
    Document   : header
    Created on : Oct 5, 2025, 10:38:36 AM
    Author     : TranHongGam
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.Staff"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.Locale"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
    <link rel="stylesheet" href="./../housekeepingstaff/stylehomeHouseKepping.css"/>

</head>
<body>
<%

    LocalDateTime now = LocalDateTime.now();
    Locale vietnamLocale = new Locale("vi", "VN");
    String pattern = "EEEE, d 'tháng' M, yyyy - HH:mm:ss";
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern, vietnamLocale);
    String formattedDateTime = now.format(formatter);
    Staff staff = (Staff)session.getAttribute("userStaff");

%>
<div class="header">
    <div class="employee-info">
        <h2>Staff: <%= staff.getFullName() %></h2>
        <p>Start at: <%= formattedDateTime %> </p>
    </div>
    <form action="<%= request.getContextPath() %>/logout" method="get" style="margin-right: 2rem;">
        <button type="submit" class="export-btn">Logout</button>
    </form>
</div>
</body>
</html>
