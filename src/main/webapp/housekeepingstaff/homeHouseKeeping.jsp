<%-- 
    Document    : homeHouseKeeping
    Created on : Oct 5, 2025, 10:06:35 AM
    Author      : TranHongGam
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.Room"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Room Management</title>
    <link rel="stylesheet" href="../housekeepingstaff/stylehomeHouseKepping.css"/>
    </head>
    <body>
        <%
        Staff staff =(Staff)session.getAttribute("userStaff");
        ArrayList<Room> list = (ArrayList) request.getAttribute("ROOM_CLEAN");
        if(list == null){
        System.out.println("hehe");
            request.getRequestDispatcher(IConstant.takeRoomForCleanController).forward(request, response);
        }else{
        %>
    <div class="container">
        <jsp:include page="header.jsp"/>

        <div class="status-section">
            <h3 class="status-title"> Room Status</h3>
            
            <div class="status-filters">
                <button class="filter-btn active">All Rooms <span class="count">8</span></button>
                <button class="filter-btn">Pending <span class="count">3</span></button>
                <button class="filter-btn">In Progress <span class="count">2</span></button>
                <button class="filter-btn">Cleaned <span class="count">2</span></button>
                <button class="filter-btn">Maintenance <span class="count">1</span></button>
            </div>
            
            <div class="status-summary">
                <div class="summary-item">
                    <div class="summary-number pending">3</div>
                    <div class="summary-label">Pending</div>
                </div>
                <div class="summary-item">
                    <div class="summary-number processing">2</div>
                    <div class="summary-label">In Progress</div>
                </div>
                <div class="summary-item">
                    <div class="summary-number completed">2</div>
                    <div class="summary-label">Cleaned</div>
                </div>
                <div class="summary-item">
                    <div class="summary-number reserved">1</div>
                    <div class="summary-label">Maintenance</div>
                </div>
                <div class="summary-item">
                    <div class="summary-number total">8</div>
                    <div class="summary-label">Total</div>
                </div>
            </div>
        </div>
        
        <h3 class="status-title"> All Rooms <span style="background: #e5e7eb; padding: 2px 10px; border-radius: 12px; font-size: 14px;">8</span></h3>
        
        <div class="rooms-grid">
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 101</div>
                    <div class="room-status status-pending">Pending</div>
                </div>
                <div class="room-details">
                    <div>Floor 1 • Deluxe</div>
                    <div>Staff: </div>
                    <div>⏰ 3h ago <span class="time-badge">Priority</span></div>
                    <div>Last Cleaned: 09/28/2024 14:30</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">Start Cleaning</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 201</div>
                    <div class="room-status status-pending">Pending</div>
                </div>
                <div class="room-details">
                    <div>Floor 2 • Deluxe</div>
                    <div>Staff: </div>
                    <div>⏰ 3h ago <span class="time-badge">Priority</span></div>
                    <div>Last Cleaned: 09/27/2024 09:15</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">Start Cleaning</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 203</div>
                    <div class="room-status status-pending">Pending</div>
                </div>
                <div class="room-details">
                    <div>Floor 2 • Deluxe</div>
                    <div>Staff: </div>
                    <div>⏰ 3h ago <span class="time-badge">Priority</span></div>
                    <div>Last Cleaned: 09/28/2024 14:30</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">Start Cleaning</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 102</div>
                    <div class="room-status status-processing">In Progress</div>
                </div>
                <div class="room-details">
                    <div>Floor 1 • Standard</div>
                    <div>Staff: Nguyen Van B</div>
                    <div>⏰ 2h ago - Est. time: 45 mins</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">Complete</button>
                    <button class="btn btn-danger">Report Damage</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 204</div>
                    <div class="room-status status-processing">In Progress</div>
                </div>
                <div class="room-details">
                    <div>Floor 2 • Standard</div>
                    <div>Staff: Nguyen Thi E</div>
                    <div>⏰ 2h ago - Est. time: 45 mins</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">Complete</button>
                    <button class="btn btn-danger">Report Damage</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 104</div>
                    <div class="room-status status-reserved">Maintenance</div>
                </div>
                <div class="room-details">
                    <div>Floor 1 • Deluxe</div>
                    <div>Issue: AC broken</div>
                    <div>⏰ 4h ago - Est. time: 30 mins</div>
                    <div>Last Cleaned: 09/28/2024 16:20</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">Update Maintenance</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 103</div>
                    <div class="room-status status-completed">Cleaned</div>
                </div>
                <div class="room-details">
                    <div>Floor 1 • Deluxe</div>
                    <div>Staff: Tran Thi C</div>
                    <div>⏰ 4h ago - Est. time: 30 mins</div>
                    <div>Last Cleaned: 09/28/2024 11:45</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">View Report</button>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-header">
                    <div class="room-name"> Room 202</div>
                    <div class="room-status status-completed">Cleaned</div>
                </div>
                <div class="room-details">
                    <div>Floor 2 • Deluxe</div>
                    <div>Staff: Le Van D</div>
                    <div>⏰ 4h ago - Est. time: 30 mins</div>
                    <div>Last Cleaned: 09/28/2024 13:15</div>
                </div>
                <div class="room-actions">
                    <button class="btn btn-primary">View Report</button>
                </div>
            </div>
        </div>
           <jsp:include page="footer.jsp"/>
        
    </div>
    
   <%
   
       }
   %>
</body>
</html>