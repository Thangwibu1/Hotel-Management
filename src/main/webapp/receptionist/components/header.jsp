<%-- 
    Document   : header
    Created on : Oct 5, 2025, 10:59:10 AM
    Author     : trinhdtu
--%>

<%@page import="model.Guest"%>
<%@page import="model.Staff"%>
<%@page import="utils.IConstant"%>
<%@page import="utils.IConstant"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <div class="topbar">
            <div>
                <div class="brand"><h1>Luxury Hotel</h1></div>
                <div class="subtitle">Receptionist Management System</div>
            </div>
            
            <div class="topbar-right">
                <div class="date" id="today"></div>
                <a href="<%= request.getContextPath()%>/logout" class="btn primary">Logout</a>
            </div>
        </div>

    </body>
</html>
