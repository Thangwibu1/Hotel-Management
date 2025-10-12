<%-- 
    Document    : homeHouseKeeping
    Created on : Oct 5, 2025, 10:06:35 AM
    Author      : TranHongGam
--%>

<%@page import="model.RoomTask"%>
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
        <link rel="stylesheet" href="./../housekeepingstaff/stylehomeHouseKepping.css"/>
        <style>
            .room-card {
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                padding: 20px;
                background: white;
                transition: 0.3s;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
            }
            .room-card:hover{
                box-shadow: 3px 3px 8px 1px #817c7c;
                transform: translateY(-5px) !important;
                border-color: #9CA3AF;
            }
        </style>
    </head>
    <body>
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");
            ArrayList<RoomTask> listTask = (ArrayList) request.getAttribute("ROOM_TASK");
            ArrayList<RoomTask> listCleaned = (ArrayList) request.getAttribute("ROOM_CLEANED");
            ArrayList<RoomTask> listPending = (ArrayList) request.getAttribute("ROOM_PENDING");
            ArrayList<RoomTask> listInProgress = (ArrayList) request.getAttribute("ROOM_IN_PROGRESS");
            ArrayList<RoomTask> listMaintenance = (ArrayList) request.getAttribute("ROOM_MATAINTENANCE");
            int sizeList = 0;
            String pendingForPress = "Start Cleaning";
            String cleanedForPress = "Cleaned";
            String inProgressForPress = "In Progress Clean";
            String maintainForPress = "In Progress Maintain";
            if (listTask == null) {
                request.getRequestDispatcher(IConstant.takeRoomForCleanController).forward(request, response);
            } else {
                ArrayList<Room> listR = (ArrayList) request.getAttribute("ROOM_LIST");
                sizeList = listTask.size();
        %>
        <div class="container">
            <jsp:include page="header.jsp"/>

            <div class="status-section">
                <h3 class="status-title"> Room Status</h3>

                <div class="status-filters">
                    <button class="filter-btn active">All Tasks <span class="count"> <%= sizeList%> </span></button>
                    <button class="filter-btn">Pending <span class="count"><%= listPending.size() %></span></button>
                    <button class="filter-btn">In Progress <span class="count"><%= listInProgress.size() %></span></button>
                    <button class="filter-btn">Cleaned <span class="count"><%= listCleaned.size() %></span></button>
                    <button class="filter-btn">Maintenance <span class="count"><%= listMaintenance.size() %></span></button>
                </div>

                <div class="status-summary">
                    <div class="summary-item">
                        <div class="summary-number pending"><%= listPending.size() %></div>
                        <div class="summary-label">Pending</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number processing"><%= listInProgress.size() %></div>
                        <div class="summary-label">In Progress</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number completed"> <%= listCleaned.size() %></div>
                        <div class="summary-label">Cleaned</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number reserved"><%= listMaintenance.size() %></div>
                        <div class="summary-label">Maintenance</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number total"><%= sizeList%></div>
                        <div class="summary-label">Total</div>
                    </div>
                </div>
            </div>

            <h3 class="status-title"> All Tasks <span style="background: #e5e7eb; padding: 2px 10px; border-radius: 12px; font-size: 14px;"><%= sizeList%></span></h3>

            <div class="rooms-grid">
                <%
                    for (RoomTask r : listTask) {
                        for (Room rl : listR) {
                            if (r.getRoomID() == rl.getRoomId()) {
                %>
                <div class="room-card">
                    <div class="room-header">
                        <div class="room-name">Room: <%= rl.getRoomNumber()%></div>
                        <%
                            String status = r.getStatusClean();
                            String statusClass = "";

                            if ("Pending".equals(status)) {
                                statusClass = "status-pending-danger";
                            } else if ("In Progress".equals(status)) {
                                statusClass = "status-inprogress-warning";
                            } else if ("Cleaned".equals(status)) {
                                statusClass = "status-cleaned-success";
                            } else if ("Maintenance".equals(status)) {
                                statusClass = "status-maintenance-dark";
                            }
                        %>
                        <div class="room-status <%= statusClass%>"> <%= r.getStatusClean()%> </div> 
                    </div>
                    <div class="room-details">
                        <div>Staff: </div>
                        <div>
                            <%
                                if ("Pending".equals(r.getStatusClean())) {
                            %>
                            <span class="time-badge">Priority</span>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <div class="room-actions">
                        <button class="btn btn-primary"> 
                            <%
                            if(r.getStatusClean().equalsIgnoreCase("Cleaned")){
                            %>     <%= cleanedForPress %>      <%
                            }else if(r.getStatusClean().equalsIgnoreCase("In Progress")){
                             %>     <%= inProgressForPress %>      <%
                            }else if(r.getStatusClean().equalsIgnoreCase("Pending")){
                            %>     <%= pendingForPress %>      <%
                            }else if(r.getStatusClean().equalsIgnoreCase("Maintenance")){
                            %>     <%= maintainForPress %>      <%
                            }
                            
                            %>
                        </button>
                    </div>
                </div>
                <%
                            }
                        }

                    }


                %>

            </div>

            <jsp:include page="footer.jsp"/>

        </div>

        <%       }
        %>
    </body>
</html>