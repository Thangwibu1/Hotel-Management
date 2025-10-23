
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
        <div class="date-badge">12/10/2025</div>
        <form action="<%= request.getContextPath()%>/logout" method="get" style="margin-right: 2rem;">
            <button class="btn-publish">Logout</button>
        </form>
    </div>
    
</div>