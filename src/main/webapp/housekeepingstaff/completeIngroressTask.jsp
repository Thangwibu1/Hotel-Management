
<%--
    Document    : completeHouseKeeping (Complete Housekeeping)
    Created on : Oct 16, 2025, 1:08:23 PM
    Author     : TranHongGam
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Complete Task Report</title>
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
            crossorigin="anonymous"
            />
    </head>
    <body>
        
        <%
        
        String room =(String) request.getParameter("room");
        int roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID"));
        String status_want_update = (String) request.getParameter("status_want_update");
        Staff staff =(Staff) session.getAttribute("userStaff");
        if(staff == null || roomTaskID == 0 || status_want_update == null || room == null ){
            %>
            <h4>Ko co data</h4> <%
        } else{
        
        %>
       
        <div class="container" style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 90%; max-width: 700px; max-height: 90vh; overflow-y: auto; z-index: 9999;">

            <div class="modal-content shadow-lg rounded-3">

                <div class="d-flex align-items-center justify-content-between p-4 border-bottom">
                    <h5 class="modal-title h4 fw-bold text-dark ps-2" id="roomModalLabel"> Room <%= room%></h5>

                    <div class="d-flex align-items-center gap-3">
                        <span class="d-flex align-items-center gap-2 p-2 rounded-3 fw-medium" style="background: #fef3c7; color: #92400e;">
                            <svg class="status-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width: 20px; height: 20px;">
                            <circle cx="12" cy="12" r="10" stroke-width="2"/>
                            <path stroke-width="2" d="M12 6v6l4 2"/>
                            </svg>
                            In Progress
                        </span>
                        <form action="<%= IConstant.takeRoomForCleanController %>" method="GET">
                            <button type="submit" class="btn-close"></button>
                        </form>

                    </div>
                </div>

                <div class="p-4">

                    <div class="p-3 mb-4 rounded-3 border bg-light border-secondary">
                        <p class="text-dark fw-bold mb-0"> Staff: <%= staff.getFullName() %></p>
                    </div>

                    <div class="mb-4 text-secondary">
                        <p class="mb-2"><strong>Check-in/Start Time:</strong> 16:09:14 4/10/2025</p>
                        <p class="mb-0"><strong>Last Cleaned:</strong> 25/09/2024 14:30</p>
                    </div>

                    <div class="mb-4">
                        <label for="statusSelect" class="form-label text-dark fw-medium"> Update Status</label>
                        <select class="form-select" id="statusSelect">
                            <option value="inprogress" selected>Cleaned</option>
                            <option value="cleaned">In Progress</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width: 20px; height: 20px;">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"/>
                            </svg>
                            <span class="form-label mb-0 text-dark fw-medium">Photos of the Room after Cleaning</span>
                        </div>
                        <div>
                            <input type="file" required/>
                        </div>
                        
                    </div>

                   
                </div>

                <div class="p-4 border-top">
                    <div class="d-flex w-100 gap-2">
                        <form action="<%= IConstant.updateStatusCleanRoomController %>" method="POST" class="d-flex flex-fill" style="padding: 0; margin: 0;">
                            <input type="hidden" name="action" value="complete">
                            <input type="hidden" name="room_Task_ID" value="<%= roomTaskID%>">
                            <input type="hidden" name="room" value="<%= room %>">
                            <input type="hidden" name="status_want_update" value="<%= status_want_update %>">
                            <input type="submit" 
                                   value="Complete" 
                                   class="btn btn-secondary flex-fill text-white fw-medium" 
                                   style="background: #374151; color: white" 
                                   id="completeBtn">
                        </form>

                        <form action="<%= IConstant.completeMaintain %>" method="POST" class="d-flex flex-fill" style="padding: 0; margin: 0;">
                            <input type="hidden" name="action" value="report">
                            <input type="hidden" name="room_Task_ID" value="<%= roomTaskID%>">
                            <input type="hidden" name="room" value="<%= room %>">
                            <input type="hidden" name="status_want_update" value="Maintenance">
                            <input type="submit" 
                                   value="Report Issue" 
                                   class="btn btn-danger flex-fill fw-medium" 
                                   id="reportBtn">
                        </form>
                    </div>
                </div>

            </div>
        </div>
        <%}%>

    </body>
</html>