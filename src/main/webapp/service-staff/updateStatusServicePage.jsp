<%-- 
    Document   : homeService
    Created on : Oct 16, 2025, 8:56:17 AM
    Author     : TranHongGam
--%>

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
    </head>
    <body>
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");

        %>

        <jsp:include page="headerService.jsp"/>
        <div class="container">

            <div class="tabs d-flex flex-column flex-md-row gap-2">

                <form action="<%= IConstant.registerServiceController%>" method="get" class="tab-form  w-100 w-md-auto">
                    <button type="submit" class="tab  w-100">
                        Register Service
                    </button>
                </form>

                <form action="/UpdateStatusController" method="get" class="tab-form w-100 w-md-auto">
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



            <div class="card">
                <div class="container main-content-area">
                    
                        <div class="table-responsive pt-3">
                            <table class="table service-table align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 15%;">Time booking</th>
                                        <th scope="col" style="width: 25%;">Guest</th>
                                        <th scope="col" style="width: 10%;">Room</th>
                                        <th scope="col" style="width: 30%;">Service</th>
                                        <th scope="col" style="width: 15%;">Status</th>
                                        <th scope="col" style="width: 5%;">Detail</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>08:30</td>
                                        <td>Nguyen Van A</td>
                                        <td>101</td>
                                        <td>Breakfast buffet</td>
                                        <td>
                                            <span class="status-badge status-complete">
                                                <span class="dot"></span> Complete
                                            </span>
                                        </td>
                                        <td>
                                            <a href="#" class="action-link">...</a> </td>
                                    </tr>
                                    <tr>
                                        <td>09:00</td>
                                        <td>Mai Anh Bon</td>
                                        <td>205</td>
                                        <td>Giat la (3 món)</td>
                                        <td>
                                            
                                            <span class="status-badge" style="background-color: #fff3cd; color: #ffc107; border: 1px solid #ffeeba;">
                                                Pending
                                            </span>
                                        </td>
                                        <td>
                                            <a href="#" class="action-link">...</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>10:15</td>
                                        <td>La Van Van</td>
                                        <td>310</td>
                                        <td>HouseKeeping</td>
                                        <td>
                                            <span class="status-badge" style="background-color: #cfe2ff; color: #0d6efd; border: 1px solid #b6d4fe;">
                                                In Progress
                                            </span>
                                        </td>
                                        <td>
                                            <a href="#" class="action-link">...</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

        </div>
        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>