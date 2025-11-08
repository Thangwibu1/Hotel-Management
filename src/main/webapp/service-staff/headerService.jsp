<%-- 
    Document   : headerService
    Created on : Oct 5, 2025, 10:38:36 AM
    Author     : TranHongGam
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.Staff"%>
<%@page import="java.time.LocalDateTime"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
    Staff staff = (Staff) session.getAttribute("userStaff");
    if (staff == null) { 
        response.sendRedirect(IConstant.loginPage);
        return;
    }
%>


<%@page import="model.Staff"%>

   
<div class="header mb-2">
    <div class="header-left">
        <div class="avatar">A</div>
        <div class="user-info">
            <h3 >Hello <%= staff.getFullName()%> </h3>
            <p>Morning Shift ID : <%= staff.getStaffId()%></p>
        </div>
    </div>
    <div class="header-right">
        
        <form action="<%= request.getContextPath()%>/logout" method="get" style="margin-right: 2rem; " onsubmit="return confirm('Are you sure you want to log out of your account?')">
            <button class="btn-publish">Logout</button>
        </form>
    </div>
    
</div>