<%-- 
    Document   : homeService
    Created on : Oct 16, 2025, 8:56:17 AM
    Author     : TranHongGam
--%>

<%@page import="model.Service"%>
<%@page import="model.BookingService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utils.IConstant"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Service - Hotel Service Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            .msg_element{
                position: relative;
                padding: 1rem 1rem; 
                border: 1px solid #555555; 
                border-radius: 0.25rem;
                background-color: #f0f0f0;
                color: #555555;
                font-weight: 600;
            }
            .btn-detail {
                background: none;
                border: 1px solid #dcdcdc;
                color: #4a5568;
                font-size: 13px;
                font-weight: 500;
                padding: 4px 10px;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s ease-in-out;
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .btn-detail:hover {
                color: #ffffff;
                border-color: transparent;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }

            .btn-detail::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                z-index: -1;
                opacity: 0;
                transition: opacity 0.3s ease-in-out;
            }

            .btn-detail:hover::before {
                opacity: 1;
            }

            .btn-detail:focus {
                outline: none;
                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            }
            .status-complete-update{
                background-color: #f3e5f5;
                color: #8e24aa;
                border: 2px solid #e1bee7;
                 transition: all 0.3s ease-out;
            }
            .status-complete-update .dot {
                height: 8px;
                width: 8px;
                background-color: #8e24aa;
                border-radius: 50%;
                margin-right: 5px;
                display: inline-block;
            }

            .dot {

                height: 8px;
                width: 8px;
                border-radius: 50%;
                margin-right: 5px;
                display: inline-block;
            }
            .status-complete-update:hover {
                box-shadow: 0 6px 12px rgba(142, 36, 170, 0.4);
                transform: translateY(-2px);
                filter: brightness(105%) saturate(110%);
            }
        </style>
    </head>
    <body style="padding-top: 100px">
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");
            ArrayList<BookingService> listTask = (ArrayList) request.getAttribute("LIST_SERVICE_TASK");
            ArrayList<Service> listService = (ArrayList) request.getAttribute("LIST_SERVICE");
        %>

        <jsp:include page="headerService.jsp"/>
        <div class="container" style="padding-top: 2rem">

            <div class="tabs d-flex flex-column flex-md-row gap-2">

                <form action="<%= IConstant.registerServiceController%>" method="get" class="tab-form  w-100 w-md-auto">
                    <button type="submit" class="tab  w-100">
                        Register Service
                    </button>
                </form>

                    <form action="<%= IConstant.updateStatusServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100 active">
                        Update Status
                    </button>
                </form>

                <form action="<%= IConstant.reportServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100">
                        Statistic
                    </button>
                </form>
            </div>

 <!--=======================================================================================================-->    
 

            <div class="card">
                <div class="container main-content-area">
                    <%
                        if (listTask != null && !listTask.isEmpty()) {
                    %>
<!--=======================================================================================================-->    
                        <div class="table-responsive pt-3">
                            <table class="table service-table align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 15%;">Time booking</th>
                                        <th scope="col" style="width: 20%;">Guest</th>
                                        <th scope="col" style="width: 10%;">Room</th>
                                        <th scope="col" style="width: 30%;">Service</th>
                                        <th scope="col" style="width: 15%;">Status</th>
                                        <th scope="col" style="width: 10%;">Detail</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (BookingService serviceTask : listTask) {
                                        for (Service s : listService) {
                                            if(serviceTask.getServiceId() == s.getServiceId()){
                                           %>
                                        <tr>
                                            <td> <%= IConstant.formatDate(serviceTask.getServiceDate()) %> </td>
                                            <td>Nguyen Van A</td>
                                            <td>101</td>
                                            <td><%= s.getServiceName() %></td>
                                            <td>
                                               <%
                                               int statusTmp = serviceTask.getStatus();
                                               String statusDisplay = "";
                                               if(statusTmp == 0){
                                                    statusDisplay = IConstant.pendingText;
                                               }else if(statusTmp == 1){
                                                    statusDisplay = IConstant.inProgressText;
                                               }else if(statusTmp == 2){
                                                    statusDisplay = IConstant.completedText;
                                               }else{
                                                    statusDisplay = IConstant.canceledText;
                                                }
                                               
                                               %>
                                                <span class="status-badge status-complete-update">
                                                    <span class="dot"></span> <%= statusDisplay %>
                                                </span>
                                            </td>
                                            <td style="text-align: start ">
                                                <form action="<%=IConstant.viewBookingServiceCardController %>" method="POST">
                                                    <input type="hidden" name="bookingServiceId" value="<%= serviceTask.getBookingServiceId() %>">
                                                    
                                                    <button type="submit" class="action-link-button btn-detail">
                                                       View
                                                    </button>
                                                </form>
                                            </td> 
                                        </tr>
                                    
                                    <%
                                            }
                                        }
                                     }
                                    %> 
                                </tbody>
                            </table>
                        </div>
                    <%}else{
                            %><div class="msg_element" >No booked services require processing today.</div> <%
                    }%>
                <!--=======================================================================================================-->           
                    </div>
                </div>

            </div>

        </div>
        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>