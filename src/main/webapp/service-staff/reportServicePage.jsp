


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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
            .profile-item {
                background: linear-gradient(135deg, #fdfdfd 0%, #ebebeb 100%);
                transition: all 0.3s;
            }

            .profile-item:hover {
                transform: translateX(5px);
                box-shadow: 0 4px 12px rgba(224, 203, 178, 0.5);
            }

            .profile-icon {
                background: linear-gradient(135deg, #596570 0%, #404951 100%);
            }

            .profile-header svg {
                fill: #667eea;
            }

        </style>
    </head>
    <body class="d-flex flex-column min-vh-100" >
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");

        %>

        <jsp:include page="headerService.jsp"/>
        <div class="container flex-grow-1" style="padding-top: 2rem; margin-top: 0">


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
            <!--detail-->       
            <div class="card shadow-sm border-0 rounded-3 mb-4 mt-4">
                <div class="card-body p-4">
                    <div class="profile-header d-flex align-items-center gap-3 pb-3 mb-4 border-bottom">
                        <i class="bi bi-person-circle ms-3" style="font-size: 32px; color: #37474F;"></i>
                        <h2 class="h4 mb-0" style="color: #37474F;">Account Profile</h2>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-6 col-xl-3">
                            <div class="profile-item d-flex align-items-start gap-3 p-3 rounded-3">
                                <div class="profile-icon rounded-3 d-flex align-items-center justify-content-center text-white" style="min-width: 50px; height: 50px; font-size: 22px;">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="text-uppercase text-muted small fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.5px;">Full Name</div>
                                    <div class="fw-semibold"><%= staff.getFullName()%></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-xl-3">
                            <div class="profile-item d-flex align-items-start gap-3 p-3 rounded-3">
                                <div class="profile-icon rounded-3 d-flex align-items-center justify-content-center text-white" style="min-width: 50px; height: 50px; font-size: 22px;">
                                    <i class="bi bi-envelope-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="text-uppercase text-muted small fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.5px;">Email Address</div>
                                    <div class="fw-semibold text-break " style="font-size: 11px;"><%= staff.getEmail()%></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-xl-3">
                            <div class="profile-item d-flex align-items-start gap-3 p-3 rounded-3">
                                <div class="profile-icon rounded-3 d-flex align-items-center justify-content-center text-white" style="min-width: 50px; height: 50px; font-size: 22px;">
                                    <i class="bi bi-telephone-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="text-uppercase text-muted small fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.5px;">Phone Number</div>
                                    <div class="fw-semibold"><%= staff.getPhone()%></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-xl-3">
                            <div class="profile-item d-flex align-items-start gap-3 p-3 rounded-3">
                                <div class="profile-icon rounded-3 d-flex align-items-center justify-content-center text-white" style="min-width: 50px; height: 50px; font-size: 22px;">
                                    <i class="bi bi-person-badge-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="text-uppercase text-muted small fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.5px;">Employee ID</div>
                                    <div class="fw-semibold"><%= staff.getStaffId()%></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>               
            <!--done-->


            <div class="container-fluid mt-4">

                <div class="row g-4 justify-content-center">


                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <form action="<%= IConstant.listServiceTodayController%>" method="POST" class="h-100"> 

                            <input type="hidden" name="report_type" value="today_services">
                            <button type="submit" 
                                    class="card report-card shadow-sm w-100 border-0 h-100" 
                                    style="cursor: pointer; background-color: white;"> 

                                <div class="card-body text-center d-flex flex-column justify-content-center align-items-center">
                                    <i class="bi bi-list-ul mb-3" 
                                       style="width: 40px; height: 40px; font-size: 40px; color: #37474F;">
                                    </i>
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

                                    <i class="bi bi-people-fill mb-3" 
                                       style="width: 40px; height: 40px; font-size: 40px; color: #37474F;">
                                    </i>

                                    <h4 class="card-title fw-bold text-dark" style="color: #37474F;">Employee Performance</h4>
                                    <p class="card-text text-muted mb-4" style="color: #37474F;">Statistics of work performance by shift/day</p>

                                </div>

                            </button>

                        </form>
                    </div>

                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <form action="<%= IConstant.serviceRevenueController%>" method="POST" class="h-100">

                            <input type="hidden" name="report_type" value="service_revenue">

                            <button type="submit"
                                    class="card report-card shadow-sm w-100 border-0 h-100"
                                    style="cursor: pointer; background-color: white;">

                                <div class="card-body text-center d-flex flex-column justify-content-center align-items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="#fbc531" class="bi bi-currency-dollar mb-3" viewBox="0 0 16 16">
                                    <path d="M4 10.78a.5.5 0 0 0 .5.5h2a.5.5 0 0 1 0 1h-2.5a.5.5 0 0 0 0 1h2.5a1.5 1.5 0 0 0 0-3H5.5a.5.5 0 0 1 0-1h2.5a.5.5 0 0 0 0-1h-2.5a1.5 1.5 0 0 1 0-3H12a.5.5 0 0 0 0-1h-2.5a.5.5 0 0 1 0-1H12a1.5 1.5 0 0 0 0-3H4.5a.5.5 0 0 0 0 1h2a.5.5 0 0 1 0 1H4.5a.5.5 0 0 0 0 1h2.5a1.5 1.5 0 0 1 0 3H4z"/>
                                    </svg>
                                    <h4 class="card-title fw-bold text-dark" style="color: #37474F;">Service Revenue</h4>
                                    <p class="card-text text-muted mb-4" style="color: #37474F;">Total revenue value by time period</p>

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