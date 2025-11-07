<%--
    Document   : showBookingServiceToday
    Created on : Oct 26, 2025, 12:59:39 PM
    Author     : TranHongGam
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.Room"%>
<%@page import="dao.RoomDAO"%>
<%@page import="model.Booking"%>
<%@page import="dao.BookingDAO"%>
<%@page import="model.Service"%>
<%@page import="dao.ServiceDAO"%>
<%@page import="model.BookingService"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Show Booking Service - Hotel Service Management </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            body {
                background-color: #f5f5f5;
            }
            
            .booking-card {
                transition: all 0.3s ease;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                overflow: hidden;
                background: white;
            }
            .booking-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                border-color: #d1d5db;
            }
            .status-badge {
                font-size: 0.8rem;
                padding: 6px 16px;
                border-radius: 20px;
                font-weight: 500;
                letter-spacing: 0.3px;
            }
            .status-pending {
                background-color: #fef3c7;
                color: #92400e;
            }
            .status-confirmed {
                background-color: #d1fae5;
                color: #065f46;
            }
            .status-completed {
                background-color: #dbeafe;
                color: #1e40af;
            }
            .status-cancelled {
                background-color: #f3f4f6;
                color: #4b5563;
                /*border: 1px solid  #4b5563;*/
            }
            .card-header-custom {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-weight: 600;
                padding: 15px 20px;
                font-size: 1.1rem;
                letter-spacing: 0.5px;
            }
            .card-body {
                padding: 25px;
            }
            .info-row {
                padding: 10px 0;
                border-bottom: 1px solid #f3f4f6;
                color: #374151;
            }
            .info-row:last-child {
                border-bottom: none;
            }
            .info-label {
                font-weight: 600;
                color: #6b7280;
                font-size: 0.9rem;
            }
            .info-value {
                color: #1f2937;
                font-size: 0.95rem;
            }
            .note-box {
                background-color: #f9fafb;
                border-left: 3px solid #9ca3af;
                padding: 12px 15px;
                margin-top: 15px;
                border-radius: 4px;
                color: #4b5563;
                font-size: 0.9rem;
            }
            .btn-outline-primary {
                color: #4b5563;
                border-color: #d1d5db;
            }
            .btn-outline-primary:hover {
                background-color: #4b5563;
                border-color: #4b5563;
                color: white;
            }
            .btn-outline-success {
                color: #059669;
                border-color: #d1d5db;
            }
            .btn-outline-success:hover {
                background-color: #059669;
                border-color: #059669;
                color: white;
            }
            .btn-outline-danger {
                color: #dc2626;
                border-color: #d1d5db;
            }
            .btn-outline-danger:hover {
                background-color: #dc2626;
                border-color: #dc2626;
                color: white;
            }
            .stat-card {
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                transition: all 0.2s;
            }
            .stat-card:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }
            .null-infor {
                position: relative;
                padding: 1rem 1rem; 
                border: 1px solid #555555; 
                border-radius: 0.25rem;
                background-color: #f0f0f0;
                color: #555555;
                font-weight: 600;
            }
            .stat-card-text {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                font-size: 0.9em;
                line-height: 1.2;
            }
        </style>
    </head>
    <body >
        <jsp:include page="headerService.jsp"/>

        <%
            ArrayList<BookingService> listBookingService = (ArrayList) request.getAttribute("LIST_BOOKING_SERVICE");
            ServiceDAO serviceDAO = new ServiceDAO();
            ArrayList<Service> serviceList = serviceDAO.getAllService();
            BookingDAO bookingDAO = new BookingDAO();
            ArrayList<Booking> bookingList = bookingDAO.getAllBookings();
            RoomDAO roomDAO = new RoomDAO();
            ArrayList<Room> roomList = roomDAO.getAllRoom();
           
            Integer pendingObj = (Integer) request.getAttribute("LIST_PENDING_SIZE");
            Integer completedObj = (Integer) request.getAttribute("LIST_COMPLETED_SIZE");
            Integer inprogressObj = (Integer) request.getAttribute("LIST_INPROGRESS_SIZE");
            Integer canceledObj = (Integer) request.getAttribute("LIST_CANCELED_SIZE");

           

            int pendingSize = (pendingObj == null) ? 0 : pendingObj;
            int completedSize = (completedObj == null) ? 0 : completedObj;
            int inprogressSize = (inprogressObj == null) ? 0 : inprogressObj;
            int canceledSize = (canceledObj == null) ? 0 : canceledObj;
        %>
        
        <div class="container">
            <div class="nav-main tabs d-flex flex-column flex-md-row gap-2">

                <form action="<%= IConstant.registerServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100 ">
                        Register Service
                    </button>
                </form>

                <form action="<%= IConstant.updateStatusServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100">
                        Update Status
                    </button>
                </form>

                <form action="<%= IConstant.reportServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100 active ">
                        Statistic
                    </button>
                </form>
            </div>
            <div class="type-report row g-4 justify-content-center">

                        
                <div class="col-lg-4 col-md-6 col-sm-12">
                    <form action="<%= IConstant.listServiceTodayController%>" method="POST" class="h-100"> 

                        <input type="hidden" name="report_type" value="today_services">
                        <button type="submit" 
                                class="card report-card shadow-sm w-100 border-0 h-100" 
                                style="cursor: pointer; background-color: white;"> 

                            <div class="card-body text-center d-flex flex-column justify-content-center align-items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="#007bff" class="bi bi-list-ul mb-3" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M5 11.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 0 0 1h-9a.5.5 0 0 1-.5-.5zm-3 1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm0-4a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm0-4a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                                </svg>
                                <h4 class="card-title fw-bold text-dark">Today's Services</h4>
                                <p class="card-text text-muted mb-4">List of all services provided today</p>

                            </div>

                        </button>

                    </form>
                </div>


                <div class="col-lg-4 col-md-6 col-sm-12">
                    <form action="<%= IConstant.employeePerformanceController%>" method="POST" class="h-100"> 

                        <input type="hidden" name="report_type" value="employee_performance">

                        <button type="submit" 
                                class="card report-card shadow-sm w-100 border-0 h-100" 
                                style="cursor: pointer; background-color: white;">

                            <div class="card-body text-center d-flex flex-column justify-content-center align-items-center">

                                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="#8a2be2" class="bi bi-people-fill mb-3" viewBox="0 0 16 16">
                                <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-9.975.324A.286.286 0 0 0 5 12.5V13a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-.5c0-.12-.016-.238-.046-.352zM.024 12.289V12.5l.004.148v.005c.036.702.392 1.28.883 1.636A2.887 2.887 0 0 0 2 13.064V12.5a.286.286 0 0 0-.25-.375H1.455a.299.299 0 0 0-.083.018zM3.454 13a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5zM3 12.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5zM3 12a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z"/>
                                </svg>

                                <h4 class="card-title fw-bold text-dark">Employee Performance</h4>
                                <p class="card-text text-muted mb-4">Statistics of work performance by shift/day</p>
                                
                            </div>

                        </button>

                    </form>
                </div>

                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <form action="<%= IConstant.serviceRevenueController %>" method="POST" class="h-100">

                            <input type="hidden" name="report_type" value="service_revenue">

                            <button type="submit"
                                    class="card report-card shadow-sm w-100 border-0 h-100"
                                    style="cursor: pointer; background-color: white;">

                                <div class="card-body text-center d-flex flex-column justify-content-center align-items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="#fbc531" class="bi bi-currency-dollar mb-3" viewBox="0 0 16 16">
                                    <path d="M4 10.78a.5.5 0 0 0 .5.5h2a.5.5 0 0 1 0 1h-2.5a.5.5 0 0 0 0 1h2.5a1.5 1.5 0 0 0 0-3H5.5a.5.5 0 0 1 0-1h2.5a.5.5 0 0 0 0-1h-2.5a1.5 1.5 0 0 1 0-3H12a.5.5 0 0 0 0-1h-2.5a.5.5 0 0 1 0-1H12a1.5 1.5 0 0 0 0-3H4.5a.5.5 0 0 0 0 1h2a.5.5 0 0 1 0 1H4.5a.5.5 0 0 0 0 1h2.5a1.5 1.5 0 0 1 0 3H4z"/>
                                    </svg>
                                    <h4 class="card-title fw-bold text-dark">Service Revenue</h4>
                                    <p class="card-text text-muted mb-4">Total revenue value by time period</p>
                                    
                                </div>

                            </button>

                        </form>
                    </div>
            </div>
            
            <%
                if (listBookingService == null || listBookingService.isEmpty()) {
            %>
            <div class="row mt-4">
                <div class="col-12">
                    <div class=" null-infor text-center" role="alert">
                      No booking services today.
                    </div>
                </div>
            </div>
            <%
            } else {
            %>
            
            <div class="row mb-4 mt-4 g-3 align-items-stretch">
                <div class="col-12 col-md-4">
                    <div class="card stat-card text-center border-0 shadow-sm h-100">
                        <div class="card-body">
                            <h3 class="text-secondary"><%= listBookingService.size() %></h3>
                            <p class="mb-0 text-muted stat-card-text">Total Service</p>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-md-8">
                    <div class="row g-3 d-flex flex-wrap align-items-stretch h-100"> 
                        <div class="col-6 col-md-3">
                            <div class="card stat-card text-center border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="text-warning"><%= pendingSize %></h3>
                                    <p class="mb-0 text-muted stat-card-text">Pending</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card stat-card text-center border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="text-success"><%= inprogressSize %></h3>
                                    <p class="mb-0 text-muted stat-card-text">In Progress</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card stat-card text-center border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="text-info"><%= completedSize %></h3>
                                    <p class="mb-0 text-muted stat-card-text">Completed</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card stat-card text-center border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="text-danger"><%= canceledSize %></h3>
                                    <p class="mb-0 text-muted stat-card-text">Canceled</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <%
                    for (BookingService bs : listBookingService) {
                        for (Service service : serviceList) {
                            for (Booking booking : bookingList) {
                                for (Room room : roomList) {
                                    if (bs.getBookingId() == booking.getBookingId() && 
                                        bs.getServiceId() == service.getServiceId() && 
                                        booking.getRoomId() == room.getRoomId()) {
                %>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card booking-card h-100">
                        <div class="card-header-custom d-flex justify-content-between align-items-center" style="border-radius: 10px; ">
                            <span><%= service.getServiceName()%></span>
                            <span class="badge status-badge
                                <%
                                    if (bs.getStatus() == 0) {
                                %> status-pending  <%
                                    } else if (bs.getStatus() == 1) {
                                %> status-confirmed  <%
                                    } else if (bs.getStatus() == 2) {
                                %> status-completed   <%
                                    } else {

                                %> status-cancelled   <%         
                                    }%>">
                                <%
                                    if (bs.getStatus() == 0) {
                                %> Pending  <%
                                    } else if (bs.getStatus() == 1) {
                                %> In Progress  <%
                                     } else if (bs.getStatus() == 2) {
                                %> Completed  <%
                                     } else {
                                             // = -1
                                %> Cancelled  <%
                                     }
                                %>
                            </span>
                        </div>
                        <div class="card-body">
                            <div class="info-row">
                                <span class="info-label">Room ID:</span>
                                <span class="info-value ms-2"> <%= room.getRoomNumber() %> </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Service Name:</span>
                                <span class="info-value ms-2"><%= service.getServiceName()%></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label"> Quantity:</span>
                                <span class="info-value ms-2">2</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Day:</span>
                                <span class="info-value ms-2"> <%= IConstant.formatDate(bs.getServiceDate()) %> </span>
                            </div>
                            <div class="note-box">
                                <%= bs.getNote() == null ? "" : bs.getNote()%>
                            </div>
                        </div>
                        
                    </div>
                </div>

                <%
                                    }
                                }
                            }
                        }
                    }

                %>
                
            </div>
            <%  
            }
            %>
        </div>


        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>