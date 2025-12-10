<%-- 
    Document   : viewBookingServiceCardPage
    Created on : Nov 1, 2025, 10:31:16 PM
    Author     : TranHongGam
--%>

<%@page import="java.time.LocalDate"%>
<%@page import="utils.IConstant"%>
<%@page import="model.Guest"%>
<%@page import="model.Room"%>
<%@page import="model.Booking"%>
<%@page import="model.Service"%>
<%@page import="model.BookingService"%>
<%@page import="model.Staff"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Service Details - Hotel Service Management </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: #f0f2f5;
                min-height: 100vh;
            }
            
            /* Main Content */
            .main-content {
                max-width: 800px;
                margin: 0px auto;
                padding: 0 10px;
            }

            /* Detail Card */
            .detail-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                overflow: hidden;
                animation: fadeIn 0.4s ease;
            }

          

            /* Card Header */
            .card-header-custom {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-header-custom h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
            }

            .close-btn {
                background: rgba(255, 255, 255, 0.2);
                border: none;
                color: white;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                cursor: pointer;
                font-size: 20px;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .close-btn:hover {
                background: rgba(255, 255, 255, 0.3);
                transform: rotate(90deg);
            }

            /* Card Body */
            .card-body-custom {
                padding: 30px;
            }

            /* Section Groups */
            .section-group {
                background: #f3f1f8;
                padding: 25px;
                border-radius: 12px;
                margin-bottom: 20px;
                border-left: 4px solid #764ba2;
                transition: all 0.3s ease-in-out;
            }
            .section-group:hover {
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
                transform: translateY(-3px);
                transition: all 0.3s ease-in-out;
            }
            .section-title {
                font-size: 15px;
                color: #764ba2;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #d8d4e4;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 14px 0;
                border-bottom: 1px solid #e8e5f0;
            }

            .info-row:last-child {
                border-bottom: none;
                padding-bottom: 0;
            }

            .info-label {
                font-size: 13px;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-weight: 600;
            }
            .info-label-form{
                width: 30%;
                font-size: 13px;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-weight: 600;
            }
            .info-value {
                font-size: 15px;
                color: #2c3e50;
                font-weight: 600;
                text-align: right;
            }
            .info-value-form {
                width: 70%;
                font-size: 15px;
                color: #2c3e50;
                font-weight: 600;
                text-align: right;
            }

            /* Status Badge */
            .status-badge {
                display: inline-block;
                padding: 8px 18px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            

            .status-0 {
                background: #f39c12;
                color: white;
                border: 1px solid #c87f0b;
            }

            .status-1 {
                background: #3498db;
                color: white;
                border: 1px solid #2980b9;
            }

            .status-2 {
                background: #2ecc71;
                color: white;
                border: 1px solid #27ae60;
            }

            .status--1 {
                background: #95a5a6;
                color: white;
                border: 1px solid #7f8c8d;
            }

            /* Note Content */
            .note-content {
                color: #555;
                line-height: 1.7;
                font-size: 14px;
                padding: 15px;
                background: white;
                border-radius: 8px;
            }
            .btn-submit:hover {
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
                transform: translateY(-2px) scale(1.02);
                filter: brightness(110%);
                transition: all 0.3s ease;
            }

            .btn-submit {
                transition: all 0.3s ease;
            }
            .class-form{
                display: flex;
                justify-content: space-around;
                flex-wrap: nowrap;  /* ĐỔI từ wrap thành nowrap */
                align-items: center; 
            }
            .btn-submit.status-badge .status-form{
                padding: 4px 12px;  /* Chỉ áp dụng cho nút có cả 2 class */
                font-size: 12px;
                
            }
            .btn-back {
                background: rgba(255, 255, 255, 0.2);
                color: white;
                padding: 8px 15px;
                border-radius: 20px;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
                display: inline-block;
                margin-left: 15px;
                border: 1px solid rgba(255, 255, 255, 0.4);
            }

            .btn-back:hover {
                background: rgba(255, 255, 255, 0.4);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>
        <jsp:include page="headerService.jsp"/>
        <%
            String thongBao = (String) request.getAttribute("THONGBAO");
            if (thongBao != null && !thongBao.isEmpty()) {
            String color_Text = (String) request.getAttribute("COLOR_TEXT");
            
            
        %>
        <div style="max-width: 800px; margin: 20px auto; padding: 0 10px;">
            <div class="alert <%= color_Text %> alert-dismissible fade show" role="alert">
                <strong>Notification:</strong> <%= thongBao%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
        <% } %>

        <%
        Staff staff =(Staff) session.getAttribute("userStaff");
        BookingService bookingService = (BookingService) request.getAttribute("BOOKING_SERVICE_DETAIL");
        Service service = (Service) request.getAttribute("SERVICE_IMPLEMENT");
        Booking booking = (Booking) request.getAttribute("BOOKING_IMPLEMENT");
        Room room_implement = (Room) request.getAttribute("ROOM_REGISTER");
        int staffPressID = staff.getStaffId();
        int status_Current = bookingService.getStatus();
        Guest guest =(Guest) request.getAttribute("GUEST_REGISTER");
        %>
        <!--//main-->
        <div class="main-content">
            <div class="detail-card">
                <!-- Card Header -->
                <div class="card-header-custom">
                    <h2>Booking Service Details</h2>
                    <a class="btn-back" href="<%= IConstant.updateStatusServiceController %>">Go Back</a>
                </div>

                <!-- Card Body -->
                <div class="card-body-custom">
<!--//================================================================================================-->
                    <!-- Booking Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Booking Information</h3>
                        <div class="info-row">
                            <div class="info-label">Booking Service ID</div>
                            <div class="info-value"><%= bookingService.getBookingServiceId()%></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Service Date</div>
                            <div class="info-value"><%= IConstant.formatDate(bookingService.getServiceDate())%></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label-form">Status</div>
                            <div class="info-value-form ">
                                <form action="<%= IConstant.editStatusServiceController%>" method="POST" id="statusForm">

                                    <div class="class-form">
                                        <%
                                        String statusText = "";
                                        if(bookingService.getStatus() == 0){
                                            statusText = IConstant.pendingText;
                                        }else if(bookingService.getStatus() == 1){
                                            statusText = IConstant.inProgressText;
                                        }else if(bookingService.getStatus() == 2){
                                            statusText = IConstant.completedText;
                                        }else {
                                            statusText = IConstant.canceledText;
                                        }

                                        %>

                                        <span class="btn-submit status-badge status-form status-<%=bookingService.getStatus()%>">
                                            <%= statusText %>
                                        </span>

                                        <input type="hidden"  name="booking_Service_ID" value="<%= bookingService.getBookingServiceId()%>" />
                                        <input type="hidden"  name="status_Curent" value="<%= bookingService.getStatus()%>" />
                                        <input type="hidden"  name="staff_implement" value="<%= staff.getStaffId()%>" />

                                        <%
                                        if(!bookingService.getServiceDate().isAfter(LocalDate.now())){
                                            if( bookingService.getStatus() == 1 || bookingService.getStatus() == 0 ){
                                                if(bookingService.getServiceId() != 3 ){
                                            %>
                                                    <div>
                                                        <div>
                                                            <select name="status_Update" class="form-select form-select-sm" style="width: 180px; margin-right: 6px; margin: 10px 0;" required>
                                                                <option value="" selected disabled>Choose Status </option>
                                                                <% if(bookingService.getStatus() == 0 ){
                                                                    %>
                                                                 <option value="1" >In Progress </option>
                                                                 <option value="-1" >Canceled </option>
                                                                    <%
                                                                }else{
                                                                    %>
                                                                    <option value="2" >Completed </option>
                                                                    <%
                                                                }%>

                                                            </select>
                                                        </div>
                                                        <div>
                                                            <button type="submit" class="btn-submit status-badge">
                                                                <- Edit Status 
                                                            </button>
                                                        </div>
                                                    </div>
                                        <%
                                                }else{
                                                %>
                                                <div>
                                                    <div>
                                                        <select name="status_Update" class="form-select form-select-sm" style="width: 180px; margin-right: 6px; margin: 10px 0;" required>
                                                            <option value="" selected disabled>Choose Status </option>
                                                            <% if (bookingService.getStatus() == 0) {
                                                            %>
                                                            
                                                            <option value="-1" >Canceled </option>
                                                            <%
                                                            } else {
                                                            %>
                                                            <option value="2" >Completed </option>
                                                            <%
                                                                        }%>

                                                        </select>
                                                    </div>
                                                    <div>
                                                        <button type="submit" class="btn-submit status-badge">
                                                            <- Edit Status 
                                                        </button>
                                                    </div>
                                                </div>
                                                <%
                                                }
                                            }
                                        }else{
                                            if(bookingService.getStatus() ==  0){
                                                %>
                                        <!--=====================-->
                                        <div>
                                            <div>
                                                <select name="status_Update" class="form-select form-select-sm" style="width: 180px; margin-right: 6px; margin: 10px 0;" required>
                                                    <option value="" selected disabled>Choose Status </option> 
                                                    <option value="-1"> Canceled </option>
                                                </select>
                                            </div>
                                            <div>
                                                <button type="submit" class="btn-submit status-badge">
                                                    <- Edit Status 
                                                </button>
                                            </div>
                                        </div>
        
                                        <!--====================-->
                                                <%
                                            }
                                        }
                                        %>   
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
<!--=================================================================================================================-->
                    <!-- Guest Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Guest Information</h3>
                        <div class="info-row">
                            <div class="info-label">Guest's Name</div>
                            <div class="info-value"><%= guest.getFullName() %></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Room Number</div>
                            <div class="info-value"><%= room_implement.getRoomNumber() %></div>
                        </div>
                    </div>

                    <!-- Service Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Service Information</h3>
                        
                        <div class="info-row">
                            <div class="info-label">Service Name</div>
                            <div class="info-value"><%= service.getServiceName() %></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Quantity</div>
                            <div class="info-value"><%= bookingService.getQuantity() %> Portions</div>
                        </div>
                    </div>

                    <!-- Staff Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Staff Information</h3>
                        <div class="info-row">
                            <div class="info-label">Staff ID</div>
                                <div class="info-value">
                                <% 
                                  Integer staffId = bookingService.getStaffID();
                                  if (staffId == null || staffId.intValue() == 0) {
                                    out.print("No one has done it yet.");
                                  } else {
                                    out.print(staffId);
                                  }
                                %>
                            </div>
                        </div>
                    </div>

                    <!-- Note Section -->
                    <div class="section-group">
                        <h3 class="section-title">Notes</h3>
                        <div class="note-content">
                            <%
                                String noteContent = bookingService.getNote();
                                if(noteContent == null || noteContent.trim().isEmpty() || noteContent.trim().equalsIgnoreCase("NULL")){
                                %> N/A <%
                                }else{
                                    %>
                                    <%= noteContent %>
                                    <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
