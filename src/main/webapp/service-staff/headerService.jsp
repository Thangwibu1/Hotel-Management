
   <%@page import="model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("userStaff");
    
    %>
   
<div class="header mb-2">
    <div class="header-left">
        <div class="avatar">A</div>
        <div class="user-info">
            <h3 >Hello <%= staff.getFullName()%> </h3>
            <p>Morning Shift ID : <%= staff.getStaffId()%></p>
        </div>
    </div>
    <div class="header-right">
        
        <form action="<%= request.getContextPath()%>/logout" method="get" style="margin-right: 2rem;">
            <button class="btn-publish">Logout</button>
        </form>
    </div>
    
</div>
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
    
    Staff staff = (Staff) session.getAttribute("userStaff");
    if (staff == null) { 
        response.sendRedirect(IConstant.loginPage);
    } else {
            
        

%>

                
<div class="header" 
     style="
        padding:1.5rem 2.5rem; 
        background: white; 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        border-bottom: 0.1rem solid #e5e7eb;
        position: fixed; 
        top: 0; 
        width: 100%; 
        z-index: 1030;">
    
    <div class="employee-info" style="width: 70%" >
        <h2 style="font-size: 3rem; margin-bottom: 0.8rem; color: #1f2937;">Staff: <%= staff.getFullName()%></h2>
        <p style="color: #6b7280; font-size: 1.4rem; margin-bottom: 0;">
            <i class="bi bi-circle-fill text-success" 
               style="font-size: 1em; vertical-align: text-top; margin-right: 5px;"></i>
            is active 
        </p>
    </div>
    
    <div style="
        width: 30%; 
        display: flex; 
        justify-content: flex-end; 
        flex-wrap: wrap;">
        
        <div style="
            width: 70%; 
            flex-shrink: 0; 
            padding-right: 2rem;
			text-align: end;"> 
            <form action="<%= IConstant.detailProfileStaffController %>"  method="get">
                <button type="submit" class="export-btn filter-btn" 
                        style="
                            background: white; 
                            color: #374151; 
                            padding: 1rem 2rem; 
                            border: 1px solid #374151 !important;
                            border-radius: 0.6rem; 
                            cursor: pointer; 
                            font-size: 1.4rem;
                            font-weight: 600;
                            width: 60%;">
                    Detail Profile
                </button>
            </form>
        </div>
        
        <div style="
            width: 30%;
            flex-shrink: 0;
			text-align: end;"> 
            <form action="<%= request.getContextPath() %>/logout"  method="get">
                <button type="submit" class="export-btn" 
                        style="
                            background: #374151; 
                            color: white; 
                            padding: 1rem 2rem; 
                            border: none; 
                            border-radius: 0.6rem; 
                            cursor: pointer; 
                            font-size: 1.4rem;
                            width: 100%;">
                    Logout
                </button>
            </form>
        </div>
        
    </div>
</div>
                <%}
                %>
