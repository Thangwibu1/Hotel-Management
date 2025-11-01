


<%-- 
    Document   : homeService
    Created on : Oct 16, 2025, 8:56:17 AM
    Author     : TranHongGam
--%>

<%@page import="java.time.LocalDate"%>
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
           
            .report-card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: 1px solid #e9ecef; 
                border-radius: 0.75rem !important;
            }

            .report-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important; 
                cursor: pointer;
            }

           
            .bi-people-fill {
                color: #8a2be2; 
            }

            .bi-currency-dollar {
                color: #ffc107;
            }

            .badge.bg-primary {
                background-color: #0d6efd !important;
            }

            .badge.bg-success {
                background-color: #198754 !important;
            }
        </style>
    </head>
    <body>
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");

        %>

        <jsp:include page="headerService.jsp"/>
        <div class="container">


            <div class="tabs d-flex flex-column flex-md-row gap-2">

                <form action="<%= IConstant.registerServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100">
                        Register Service
                    </button>
                </form>

                <form action="<%= IConstant.updateStatusServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100">
                        Update Status
                    </button>
                </form>

                <form action="<%= IConstant.reportServiceController%>" method="get" class="tab-form w-100 w-md-auto">
                    <button type="submit" class="tab w-100  active">
                        Statistic
                    </button>
                </form>
            </div>

            <div class="container-fluid mt-4">

                <div class="card shadow-sm mb-4 border-1">
                    <div class="card-body py-3">
                        <h5 class="card-title text-muted mb-0 d-flex align-items-center ">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bar-chart-fill me-2" viewBox="0 0 16 16">
                            <path d="M1 11a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1v-3zm5-4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7zm5-5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1V2z"/>
                            </svg>
                            Select Report Type
                        </h5>
                    </div>
                </div>

                <div class="row g-4 justify-content-center">

                   
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
            </div>



        </div>
        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>