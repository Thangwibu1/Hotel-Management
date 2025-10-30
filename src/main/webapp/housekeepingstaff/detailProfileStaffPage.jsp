<%-- 
    Document   : detailProfileStaff
    Created on : Oct 20, 2025, 3:38:43 PM
    Author     : TranHongGam
--%>

<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Detail Your Profile</title>
    </head>
    <body>
        <%
        Staff staff = (Staff)session.getAttribute("userStaff");
        
        %>
        <h1>Hello World! <%= staff.getFullName() %></h1>
    </body>
</html>
