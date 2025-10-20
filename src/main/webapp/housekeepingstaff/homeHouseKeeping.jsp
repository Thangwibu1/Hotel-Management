<%-- 
    Document    : homeHouseKeeping
    Created on : Oct 5, 2025, 10:06:35 AM
    Author      : TranHongGam
--%>

<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.util.Locale" %>
<%@page import="java.time.LocalDateTime" %>
<%@page import="model.RoomTask" %>
<%@page import="utils.IConstant" %>
<%@page import="model.Room" %>
<%@page import="java.util.ArrayList" %>
<%@page import="model.Staff" %>
<%@page import="utils.IConstant" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Room Management</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
            crossorigin="anonymous"
    />
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

        .room-card:hover {
            box-shadow: 3px 3px 8px 1px #817c7c;
            transform: translateY(-5px) !important;
            border-color: #9CA3AF;
        }
    </style>
</head>
<body>

<%

    Staff staff = (Staff) session.getAttribute("userStaff");
    
    ArrayList<RoomTask> list_Display_Home = (ArrayList) request.getAttribute("LIST_DISPLAY_HOME");
    ArrayList<RoomTask> listCleaned = (ArrayList) request.getAttribute("ROOM_CLEANED");
    ArrayList<RoomTask> listPending = (ArrayList) request.getAttribute("ROOM_PENDING");
    ArrayList<RoomTask> listInProgress = (ArrayList) request.getAttribute("ROOM_IN_PROGRESS");
    ArrayList<RoomTask> listMaintenance = (ArrayList) request.getAttribute("ROOM_MATAINTENANCE");
    ArrayList<Room> listR = (ArrayList) request.getAttribute("ROOM_LIST");

    String pendingForPress = "Start Cleaning";
    String cleanedForPress = "Cleaned";
    String inProgressForPress = "In Progress Clean";
    String maintainForPress = "In Progress Maintain";
    
    
    if (list_Display_Home == null || listR == null) {
        request.getRequestDispatcher(IConstant.takeRoomForCleanController).forward(request, response);
        
    } else {
        String active = (String) request.getAttribute("ACTIVE");

%>
<jsp:include page="header.jsp"/>
<div class="container main-content">
    <div class="status-section">
        <h2 class="status-title"> Room Status</h2>

        <div class="status-filters">

            <form action= <%= IConstant.takeRoomForCleanController %> method="POST" class="filter-form-inline">
                <input type="hidden" name="active" value="all">
                <button type="submit"
                        class="filter-btn <%= (active == null || "all".equals(active)) ? "active" : "" %>  ">All Tasks
                    <span class="count"> <%= (list_Display_Home != null) ? list_Display_Home.size() : 0 %> </span></button>
            </form>

            <form action="<%= IConstant.takeRoomForCleanController %>" method="POST" class="filter-form-inline">
                <input type="hidden" name="active" value="pending">
                <button type="submit" class="filter-btn <%= "pending".equals(active) ? "active" : "" %>">Pending <span
                        class="count"><%= listPending.size()%></span></button>
            </form>

            <form action="<%= IConstant.takeRoomForCleanController %>" method="POST" class="filter-form-inline">
                <input type="hidden" name="active" value="in_progress">
                <button type="submit" class="filter-btn <%= "in_progress".equals(active) ? "active" : "" %>">In Progress
                    <span class="count"><%= listInProgress.size()%></span></button>
            </form>

            <form action="<%= IConstant.takeRoomForCleanController %>" method="POST" class="filter-form-inline">
                <input type="hidden" name="active" value="cleaned">
                <button type="submit" class="filter-btn <%= "cleaned".equals(active) ? "active" : "" %>">Cleaned <span
                        class="count"><%= listCleaned.size()%></span></button>
            </form>

            <form action="<%= IConstant.takeRoomForCleanController %>" method="POST" class="filter-form-inline">
                <input type="hidden" name="active" value="maintenance">
                <button type="submit" class="filter-btn <%= "maintenance".equals(active) ? "active" : "" %>">Maintenance
                    <span class="count"><%= listMaintenance.size()%></span></button>
            </form>

        </div>

        <div class="status-summary">
            <div class="summary-item">
                <div class="summary-number pending"><%= listPending.size() %>
                </div>
                <div class="summary-label">Pending</div>
            </div>
            <div class="summary-item">
                <div class="summary-number processing"><%= listInProgress.size() %>
                </div>
                <div class="summary-label">In Progress</div>
            </div>
            <div class="summary-item">
                <div class="summary-number completed"><%= listCleaned.size() %>
                </div>
                <div class="summary-label">Cleaned</div>
            </div>
            <div class="summary-item">
                <div class="summary-number reserved"><%= listMaintenance.size() %>
                </div>
                <div class="summary-label">Maintenance</div>
            </div>
            <div class="summary-item">
                <div class="summary-number total"><%= list_Display_Home.size()%>
                </div>
                <div class="summary-label">Total</div>
            </div>
        </div>
    </div>
    <%
    if(request.getAttribute("THONGBAO") != null){
    String msgUpdate = (String)request.getAttribute("THONGBAO");
    %>
    <h4 class="text-success pt-3 pb-3"> <%= msgUpdate %> </h4>
    <%
    }
    
    
    %>

    <h3 class="status-title"> All Tasks <span
            style="background: #e5e7eb; padding: 2px 10px; border-radius: 12px; font-size: 14px;"><%= list_Display_Home.size()%></span>
    </h3>

    <div class="rooms-grid">
        <%
            for (RoomTask r : list_Display_Home) {
                for (Room rl : listR) {
                    if (r.getRoomID() == rl.getRoomId()) {
        %>
        <div class="room-card">
            <div class="room-header">
                <div class="room-name">Room: <%= rl.getRoomNumber()%>
                </div>
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
                <div class="room-status <%= statusClass%>"><%= r.getStatusClean()%>
                </div>
            </div>
            <div class="room-details">
                <div>Staff:</div>
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
                <%
                if (r.getStatusClean().equalsIgnoreCase("Cleaned")) {
                %>
                    <div style="width: 100%">
                        <button style="width: 100%" class="btn btn-primary">
                            <%= cleanedForPress%>
                        </button>
                    </div>
                <%
                } else if (r.getStatusClean().equalsIgnoreCase("In Progress")) {
                   String roomNumber = rl.getRoomNumber();
                   int roomTaskID = r.getRoomTaskID();
                   String targetStatus = "Cleaned";

                %>
                <form action="<%= IConstant.completeHouseKeeping %>" method="POST">
                    <input type="hidden" name="room" value="<%= roomNumber%>">
                    <input type="hidden" name="status_want_update" value="<%= targetStatus%>">
                    <input type="hidden" name="room_Task_ID" value="<%= roomTaskID%>">

                    <div style="width: 100%">
                        <button style="width: 100%" type="submit" class="btn btn-primary">
                        <%= inProgressForPress%>
                        </button>
                    </div>
                </form>
                
                <%
                } else if (r.getStatusClean().equalsIgnoreCase("Pending")) {
                %>
                <form action= "<%= IConstant.updateStatusCleanRoomController %>" method="POST">
                    <input type="hidden" name="room" value="<%= r.getRoomID()%>">

                    <input type="hidden" name="status_want_update" value="In Progress">

                    <input type="hidden" name="room_Task_ID" value="<%= r.getRoomTaskID() %>">

                    <div style="width: 100%">
                        <button style="width: 100%" type="submit" class="btn btn-primary">
                            <%= pendingForPress%>
                        </button>
                    </div>
                </form>
                <%
                } else if (r.getStatusClean().equalsIgnoreCase("Maintenance")) {
                %>
                <form action="UpdateStatusCleanRoomController" method="POST">
                    <input type="hidden" name="room" value="<%= r.getRoomID()%>">

                    <input type="hidden" name="status_want_update" value="Cleaned">

                    <input type="hidden" name="room_Task_ID" value="<%= r.getRoomTaskID() %>">

                    <div style="width: 100%">
                        <button style="width: 100%" type="submit" class="btn btn-primary">
                            <%= maintainForPress%>
                        </button>
                    </div>
                </form>

                <%
                    }
                %>
            </div>
        </div>
            
        <%
                    }
                }

            }


        %>

    </div>


</div>
<jsp:include page="footer.jsp"/>

<% }
%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>