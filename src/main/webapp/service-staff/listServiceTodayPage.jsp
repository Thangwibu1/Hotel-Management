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
        <title>Show Booking Service Today</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            body {
                background-color: #f5f5f5;
            }
            .header {

                color: white;
                padding: 20px 0;
                margin-bottom: 30px;
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
        </style>
    </head>
    <body>
        <jsp:include page="headerService.jsp"/>

        <%
            ArrayList<BookingService> listBookingService = (ArrayList) request.getAttribute("LIST_BOOKING_SERVICE");
            ServiceDAO serviceDAO = new ServiceDAO();
            ArrayList<Service> serviceList = serviceDAO.getAllService();
            BookingDAO bookingDAO = new BookingDAO();
            ArrayList<Booking> bookingList = bookingDAO.getAllBookings();
            RoomDAO roomDAO = new RoomDAO();
            ArrayList<Room> roomList = roomDAO.getAllRoom();

            if (listBookingService == null || listBookingService.isEmpty()) {
        %>
        <p>Khong co booking service trong hom nay</p>
        <%
        } else {
        %>
        <div class="container">
            <div class="tabs d-flex flex-column flex-md-row gap-2">

                <form action="<%= IConstant.registerServiceController%>" method="get" class="tab-form  w-100 w-md-auto">
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
            <!-- Thong ke -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card stat-card text-center border-0 shadow-sm">
                        <div class="card-body">
                            <h3 class="text-secondary">6</h3>
                            <p class="mb-0 text-muted">Total Service</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center border-0 shadow-sm">
                        <div class="card-body">
                            <h3 class="text-warning">2</h3>
                            <p class="mb-0 text-muted">Pending</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center border-0 shadow-sm">
                        <div class="card-body">
                            <h3 class="text-success">3</h3>
                            <p class="mb-0 text-muted">In Progress</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center border-0 shadow-sm">
                        <div class="card-body">
                            <h3 class="text-info">1</h3>
                            <p class="mb-0 text-muted">Completed</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3"> 
                    <div class="card stat-card text-center border-0 shadow-sm">
                        <div class="card-body">
                            <h3 class="text-danger">0</h3> 
                            <p class="mb-0 text-muted">Canceled</p>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Danh sách Booking Services -->
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
                        <div class="card-header-custom d-flex justify-content-between align-items-center">
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

                                  %> status-cancelled   <%                                                                        }%>">
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
                                <span class="info-value ms-2"> <%= bs.getServiceDate()%> </span>
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
        </div>


        <%            }
        %>
        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
