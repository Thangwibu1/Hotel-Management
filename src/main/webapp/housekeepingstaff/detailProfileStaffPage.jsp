<%-- 
    Document   : detailProfileStaff
    Created on : Oct 20, 2025, 3:38:43 PM
    Author     : TranHongGam
--%>

<%@page import="model.Room"%>
<%@page import="dao.RoomDAO"%>
<%@page import="java.time.LocalDate"%>
<%@page import="model.RoomTask"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utils.IConstant"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Detail Your Profile</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
            crossorigin="anonymous"
            />
        <link rel="stylesheet" href="./../housekeepingstaff/stylehomeHouseKepping.css"/>
        <style>
            .btn-outline-secondary {
                transition: color 0.3s ease-in-out, background-color 0.3s ease-in-out, border-color 0.3s ease-in-out;
            }

        </style>
    </head>
    <body>

        <%
            Staff staff = (Staff) session.getAttribute("userStaff");
            String startDate = (String) request.getAttribute("START");
            String endDate = (String) request.getAttribute("END");
            ArrayList<RoomTask> listPerformance = (ArrayList) request.getAttribute("LIST_REPORT");
            String FLAG = (String) request.getAttribute("FLAG");
            RoomDAO roomD = new RoomDAO();
            ArrayList<Room> listRoom = roomD.getAllRoom();
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
                    <form action="<%= IConstant.takeRoomForCleanController%>"  method="get">
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
                            Back Home
                        </button>
                    </form>
                </div>

                <div style="
                     width: 30%;
                     flex-shrink: 0;
                     text-align: end;"> 
                    <form action="<%= request.getContextPath()%>/logout"  method="get">
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
        <div class="container main-content" style="margin-top: 6.5rem;">
            <main class="container-fluid py-4">
                <div class="card shadow-sm mb-4">
                    <div class="card-body" >
                        <div class="row align-items-center p-3" >
                            <div class="col-2 col-md-auto text-center text-md-start mb-3 mb-md-0 ">
                                <div class="rounded-circle overflow-hidden d-inline-block" style="width: 60px; height: 60px;">
                                    <img src="https://png.pngtree.com/background/20210714/original/pngtree-luxury-background-with-sparkling-elements-vector-image-picture-image_1238565.jpg" 
                                         alt="img lap lanh" 
                                         class="img-fluid" 
                                         style="width: 100%; height: 100%; object-fit: cover;">
                                </div>
                            </div>
                            <div class="col-10 col-md text-center text-md-start ">
                                <h4 class="mb-1"><i class="fas fa-user-tie me-3"></i><%= staff.getFullName()%></h4>
                                <hr>
                                <p class="text-muted mb-0">Housekeeping Staff - Morning Shift</p>
                            </div>
                        </div>
                        <div style="padding-left: 85px;">
                            <p><i class="fas fa-phone me-3"></i> Phone: <%= staff.getPhone() %></p>    
                            <p><i class="fas fa-user-tag me-3"></i>Role: <%= staff.getRole() %></p>    
                            <p><i class="fas fa-envelope me-4"></i>Email: <%= staff.getEmail() %></p>    
                        </div>
                    </div>
                </div>
                <div class="card shadow-sm mb-4">
                    <div class="card-body p-5">
                        <h5 class="card-title mb-3">
                            <i class="fas fa-calendar-alt text-dark me-2"></i>
                            Select Report Time Period
                        </h5>
                        <hr>
                        <form action="<%= IConstant.reportByTimeHKController%>" method="POST">
                            <div class="row g-3">

                                <div class="col-12 col-md-4" style="padding: 5px;">
                                    <label class="form-label">Start Date</label>
                                    <input type="date" class="form-control form-control-lg " value="<%= startDate == null ? "" : startDate%>" id="startDate" name="start_date" required>
                                </div>
                                <div class="col-12 col-md-4" style="padding: 5px;">
                                    <label class="form-label">End Date</label>
                                    <input type="date" class="form-control form-control-lg" value="<%= endDate == null ? "" : endDate%>" id="endDate" name="end_date" required>
                                </div>
                                <div class="col-12 col-md-2 d-flex align-items-end">
                                    <button class="btn btn-primary btn-lg w-100" type="submit">
                                        <i class="fas fa-search me-2"></i>View
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!---------------------------------------------------------------------------------------------------->
                <%
                    if (FLAG != null && FLAG.equals("true")) {
                        if (listPerformance == null || listPerformance.isEmpty()) {
                        %>
                        <div class="alert alert-danger" role="alert">
                            <h4 class="mb-0">Do not work on this task during <%= IConstant.formatDate(LocalDate.parse(startDate)) %> - <%= IConstant.formatDate(LocalDate.parse(endDate)) %></h4>
                        </div>
                        <%
                        } else {
                %>
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-list-check text-info me-2"></i>
                            Work Report
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive ">
                            <table class="table table-hover table-striped mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Rooms Cleaned</th>
                                        <th class="d-none d-md-table-cell">Working Shift</th>
                                        <th class="d-none d-lg-table-cell">Staff Implement</th>
                                        <th class="d-none d-lg-table-cell">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (RoomTask roomTask : listPerformance) {
                                            for (Room room : listRoom) {
                                                if(roomTask.getRoomID() == room.getRoomId()){
                                               
                                    %>
                                    <tr>
                                        <td><strong><%= IConstant.formatDate(roomTask.getStartTime().toLocalDate()) %></strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6"><%= room.getRoomNumber() %></span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Basic Shift</td>
                                        <td class="d-none d-lg-table-cell"><%= roomTask.getStaffID() %></td>
                                        <td class="d-none d-lg-table-cell">
                                            <%if(roomTask.getStatusClean().equalsIgnoreCase("Cleaned")){
                                                %>
                                                <span class="badge bg-success"><%= roomTask.getStatusClean() %></span>
                                                <%
                                            }else{
                                                %>
                                                <span class="badge bg-secondary"><%= roomTask.getStatusClean() %></span>
                                                <%
                                            }
                                            %>
                                            
                                        </td>
                                    </tr>
                                    <%          }
                                            }
                                        }
                                    %>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td><strong>Total</strong></td>
                                        <td><strong class="text-primary"><%= listPerformance.size() %> rooms</strong></td>
                                        <td class="d-none d-md-table-cell" colspan="3">
                                            <strong>Avg. Time: 26 minutes/room</strong>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }else if(FLAG != null && !FLAG.equals("true")){
                         %>
                         <div class="alert alert-danger" role="alert">
                             <h4 class="mb-0"><%= FLAG%></h4>
                         </div>
                        <%
                    }
                %>


                <!---------------------------------------------------------------------------------------------------->
            </main>
                
        </div>

        <jsp:include page="footer.jsp"/>
        <script async defer
                src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap">
        </script>
    </body>
</html>
