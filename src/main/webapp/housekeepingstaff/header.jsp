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

<%

    LocalDateTime now = LocalDateTime.now();
    Locale vietnamLocale = new Locale("vi", "VN");
    String pattern = "EEEE, d 'tháng' M, yyyy - HH:mm:ss";
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern, vietnamLocale);
    String formattedDateTime = now.format(formatter);
    Staff staff = (Staff) session.getAttribute("userStaff");

%>
<div class="header" style="padding:1.5rem 2.5rem; background: white; display: flex; justify-content: space-between; align-items: center; border-bottom: 0.1rem solid #e5e7eb;position: fixed; top: 0; width: 100%; z-index: 1030;">
    <div class="employee-info" >
        <h2 style="font-size: 3rem; margin-bottom: 0.8rem; color: #1f2937;">Staff: <%= staff.getFullName()%></h2>
        <p style="color: #6b7280; font-size: 1.4rem; margin-bottom: 0;">Start at: <%= formattedDateTime%> </p>
    </div>
    <form action="<%= request.getContextPath() %>/logout" method="get" style="margin-right: 2rem;">
        <button type="submit" class="export-btn" style="background: #374151; color: white; padding: 1rem 2rem; border: none; border-radius: 0.6rem; cursor: pointer; font-size: 1.4rem;">Logout</button>
    </form>
</div>