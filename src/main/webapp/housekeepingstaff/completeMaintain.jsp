<%-- 
    Document   : completeMaintain
    Created on : Oct 18, 2025, 11:54:56 PM
    Author     : TranHongGam
--%>

<%@page import="model.Staff"%>
<%@page import="utils.IConstant"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Report For Maintain</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            html {
                font-size: 62.5%;
                font-family: sans-serif;
            }
            .container {
                padding-top: 7rem;
                max-width: 1320px;
                margin: 0 auto;
            }
            body {
                background-color: #f5f5f5;
                font-family: Arial, sans-serif;
                font-size: 1.6rem;
            }
            .modal-content {
                border-radius: 8px;
            }
            .alert-warning {
                background-color: #fef3cd;
                font-size: medium;
                border-color: #fef3cd;
                color: #856404;
            }
            .warning-icon {
                color: #dc3545;
                font-size: 24px;
                font-weight: bold;
            }
            .checkbox-list {
                max-height: 70vh;
                overflow-y: auto;
                overflow-x: hidden;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                padding: 10px;
                background-color: white;
            }
            .form-check {
                padding: 12px 15px;
                border-bottom: 1px solid #f0f0f0;
                margin: 0;
                display: flex;
                align-items: center;
                position: relative;
            }
            .form-check:last-child {
                border-bottom: none;
            }
            .form-check-input {
                width: 22px;
                height: 22px;
                margin: 0;
                /* ?i?u ch?nh c?n l�i */
                margin-left: 5px;
                margin-right: 17px;
                cursor: pointer;
                flex-shrink: 0;
                position: relative;
            }
            .form-check-label {
                font-size: 16px;
                cursor: pointer;
                margin: 0;
                user-select: none;
                flex: 1;
            }
            .modal-header {
                border-bottom: 1px solid #dee2e6;
            }
            .btn-close {
                font-size: 20px;
            }

            
            .btn-maintenance {
                background-color: #495057; /* M�u x�m ?en */
                color: white;
                padding: 12px 30px;
                font-size: 16px;
                border: none;
                border-radius: 4px;
                font-weight: 500;
                margin-right: 10px;
            }
            .btn-maintenance:hover {
                background-color: #343a40; /* M�u x�m ?en ??m h?n khi hover */
                color: white;
                box-shadow: 0 0 8px 2px rgba(108, 117, 125, 0.5);
            }
            .modal-footer {
                border-top: 1px solid #dee2e6;
                padding: 15px 20px;
            }

            .form-check-input:not(:checked) {
                border-color: #6c757d;
            }

            .form-check-input:checked {
                background-color: #343a40;
                border-color: #343a40;
            }

            .form-check-input:checked[type=checkbox] {
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='M6 10l3 3l6-6'/%3e%3c/svg%3e");
                filter: none;
            }

            .form-check-input:focus {
                border-color: #6c757d;
                box-shadow: 0 0 0 0.25rem rgba(108, 117, 125, 0.25);
            }
        </style>
    </head>
    <body>
            <%

            String room = (String) request.getParameter("room");
            int roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID"));
            String status_want_update = (String) request.getParameter("status_want_update");
            System.out.println("STATUS IN CompleteMAINTAIN" + status_want_update);

            Staff staff = (Staff) session.getAttribute("userStaff");
            
            
            Map<Integer, String> deviceMap = (Map<Integer, String>) request.getAttribute("deviceMap");
            
            if (staff == null || roomTaskID == 0 || status_want_update == null || room == null) {
                System.out.println("Do co gi do null nen do ve lai trang login a");
                response.sendRedirect(IConstant.loginPage);
            } else {
            

            %>
        <jsp:include page="header.jsp"/>

        <div class="container mt-5">
            <%
            if(request.getAttribute("THONGBAO_VI_BO_TRONG") != null){
                String msg = (String) request.getAttribute("THONGBAO_VI_BO_TRONG");
                %>
                <h4 class="text-danger text-center fw-bold"> <%= msg %> </h4>
                <%
            }
            
            %>
            <div class="modal-dialog modal-dialog-centered modal-lg ">
                <div class="modal-content " >
                    <div class="modal-header mb-5 " >
                        <h3 class="modal-title ms-4">
                            <span class="warning-icon">?</span>
                            Malfunction Report - Room 101
                        </h3>
                        <div class="d-flex align-items-center gap-3">
                            <form action="<%= IConstant.takeRoomForCleanController%>" method="GET">
                                <button type="submit" class="btn-close"></button>
                            </form>

                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-warning" role="alert">
                            <strong class="ms-1">Reporting damage in Room 101</strong><br>
                            <small class="ms-1">The room will be placed under maintenance after confirmation.</small>
                        </div>
                        <div class="checkbox-list d-flex justify-content-center  ">
                            
                            <form action="<%= IConstant.takeDeviceForNoteMaintenanceController %>" method="get" style="width: 55% ; padding-bottom: 4rem; " >
                                <input type="hidden" name="room_Task_ID" value="<%= roomTaskID%>">
                                <input type="hidden" name="room" value="<%= room%>">
                                <input type="hidden" name="status_want_update" value="<%= status_want_update%>">
                                
                                <input type="hidden" name="staff" value="<%= staff %>">
                               
                                <div class="card shadow-sm " style="max-width: 70rem;">
                                    <div >
                                        <h3 class=" p-4 text-center bg-light bg-gradient shadow rounded-3"
                                            style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 50%, #f8f9fa 100%);
                                            color: #495057;
                                            letter-spacing: 0.5px;
                                            font-weight: 700;
                                            border: 1px solid #b2b5b9;">
                                            Select Failure Category
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <div class="list-group list-group-flush">
                                            <%
                                            if (deviceMap != null && !deviceMap.isEmpty()) {
                                                for (Map.Entry<Integer, String> entry : deviceMap.entrySet()) {
                                                    int roomDeviceId = entry.getKey();
                                                    String deviceName = entry.getValue();
                                            %>
                                            <div class="list-group-item">
                                                <div class="form-check">
                                                    <input class="form-check-input" 
                                                           type="checkbox" 
                                                           id="device_<%= roomDeviceId %>" 
                                                           name="roomDeviceIds" 
                                                           value="<%= roomDeviceId %>">
                                                    <label class="form-check-label" for="device_<%= roomDeviceId %>">
                                                        <%= deviceName %>
                                                    </label>
                                                </div>
                                            </div>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <div class="list-group-item">
                                                <p class="text-center text-muted">No devices found in this room.</p>
                                            </div>
                                            <%
                                            }
                                            %>
                                        </div>
                                    </div>

                                    <div class="card-footer text-end" style="width: 100%; ">
                                        <button style="width: 100%; " type="submit" class="btn btn-maintenance">Completed Maintenance</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <%}
        %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>