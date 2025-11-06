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
    LocalDateTime now = LocalDateTime.now();
    Staff staff = (Staff) session.getAttribute("userStaff");
    if (staff == null) { 
        response.sendRedirect(IConstant.loginPage);
        return;
    }
%>

<div class="header" 
     style="
        padding: 1rem 2rem; 
        background: white; 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        border-bottom: 0.1rem solid #e5e7eb;
        position: fixed; 
        top: 0; 
        left: 0;
        right: 0;
        width: 100%; 
        z-index: 1030;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
    
    <div class="employee-info" style="width: 70%; flex-shrink: 0;" >
        <h2 style="font-size: 1.5rem; margin-bottom: 0.3rem; color: #1f2937; font-weight: 600;">Staff: <%= staff.getFullName()%></h2>
        <p style="color: #6b7280; font-size: 0.875rem; margin-bottom: 0;">
            <i class="bi bi-circle-fill text-success" 
               style="font-size: 0.6rem; vertical-align: middle; margin-right: 5px;"></i>
            is active 
        </p>
    </div>
    
    <div style="
        width: 30%; 
        display: flex; 
        justify-content: flex-end; 
        flex-wrap: wrap;">
        
        <div style="
            flex-shrink: 0; 
            padding-right: 1rem;
			text-align: end;"> 
            <form action="<%= IConstant.detailProfileStaffController %>"  method="get" style="display: inline;">
                <button type="submit" class="export-btn filter-btn" 
                        style="
                            background: white; 
                            color: #374151; 
                            padding: 0.5rem 1.2rem; 
                            border: 1px solid #374151 !important;
                            border-radius: 0.5rem; 
                            cursor: pointer; 
                            font-size: 0.875rem;
                            font-weight: 600;
                            white-space: nowrap;
                            transition: all 0.2s;">
                    Detail Profile
                </button>
            </form>
        </div>
        
        <div style="
            flex-shrink: 0;
			text-align: end;"> 
            <form action="<%= request.getContextPath() %>/logout"  method="get" style="display: inline;">
                <button type="submit" class="export-btn" 
                        style="
                            background: #374151; 
                            color: white; 
                            padding: 0.5rem 1.2rem; 
                            border: none; 
                            border-radius: 0.5rem; 
                            cursor: pointer; 
                            font-size: 0.875rem;
                            font-weight: 600;
                            white-space: nowrap;
                            transition: all 0.2s;">
                    Logout
                </button>
            </form>
        </div>
        
    </div>
</div>
