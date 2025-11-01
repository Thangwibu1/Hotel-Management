<%-- 
    Document   : serviceRevenuePage
    Created on : Oct 30, 2025, 12:49:52 PM
    Author     : TranHongGam
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="model.BookingService"%>
<%@page import="utils.IConstant"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Service Revenue - Hotel Service Management </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            body {
                background-color: #e8e9f0;
                min-height: 100vh;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            }
            .user-avatar {
                width: 50px;
                height: 50px;
                background: #7c3aed;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                font-weight: bold;
            }
            .logout-btn {
                background-color: #dc3545;
                border: none;
                padding: 10px 30px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
                transition: all 0.3s;
            }
            .logout-btn:hover {
                background-color: #c82333;
                transform: translateY(-2px);
            }
            .nav-tabs {
                background: white;
                border-radius: 15px;
                padding: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                border: none;
                margin: 20px 0;
            }
            .nav-tabs .nav-link {
                border: none;
                color: #6b7280;
                font-weight: 500;
                padding: 12px 30px;
                border-radius: 10px;
                transition: all 0.3s;
            }
            .nav-tabs .nav-link.active {
                background: linear-gradient(135deg, #7c3aed 0%, #6d28d9 100%);
                color: white;
            }
            .report-selector {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                margin-bottom: 25px;
            }
            .report-type-card {
                background: white;
                border-radius: 12px;
                padding: 20px;
                transition: all 0.3s;
                cursor: pointer;
                border: 2px solid transparent;
                height: 100%;
            }
            .report-type-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(124,58,237,0.15);
            }
            .report-type-card.active {
                border-color: #7c3aed;
                background: linear-gradient(135deg, #f5f3ff 0%, #ede9fe 100%);
            }
            .report-type-icon {
                font-size: 40px;
                margin-bottom: 15px;
            }
            .date-range-section {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                margin-bottom: 25px;
            }
            .booking-card {
                background: white;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                transition: all 0.3s;
            }
            .booking-card:hover {
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transform: translateX(5px);
            }
            .status-badge {
                padding: 6px 15px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
            }
            .status-completed {
                background-color: #d1fae5;
                color: #065f46;
            }
            .summary-card {
                background-color: #f7f0ff;
                color: #4a007b;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 4px 15px rgba(124,58,237,0.1);
            }
            .summary-value {
                font-size: 36px;
                font-weight: bold;
                margin: 10px 0;
            }
            .filter-btn {
                border: none;
                padding: 10px 30px;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3)
            }
            .filter-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(124,58,237,0.4);
            }
            .form-control:focus {
                border-color: #7c3aed;
                box-shadow: 0 0 0 0.2rem rgba(124,58,237,0.25);
            }
            .msg_element {
                padding: 1rem 1.25rem;
                margin: 15px 0;
                border-radius: 0.375rem;
                background-color: #fcebeb;
                border: 1px solid #f5c6cb;
                color: #721c24;
                font-weight: 500;
                font-size: 1rem;
            }
        </style>
    </head>
    <body>
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");
            String startDate = (String) request.getAttribute("start_date");
            String endDate = (String) request.getAttribute("end_date");

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
            <!--type service-->
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
                    <form action="<%= IConstant.serviceRevenueController%>" method="POST" class="h-100">

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
                    if(request.getAttribute("ERROR_INPUT_REVENUE") != null){
                    String msg = (String) request.getAttribute("ERROR_INPUT_REVENUE");
                    %>
                    <div class="msg_element"><%= msg %></div>
                    <%
                    }
                    %>      
            <!-- Date Range Filter -->
            <div class="date-range-section mt-4">
                <form action=" <%= IConstant.takeIncomeByTimeController%>" method="POST">
                    <h5 class="mb-4"><i class="fas fa-calendar-alt me-2"></i>Select Time Period</h5>
                    <div class="row align-items-end">
                        <input type="hidden" name="report_type" value="service_revenue">

                        <div class="col-md-4">
                            <label class="form-label fw-bold">From Date</label>
                            <input type="date" class="form-control" name="start_date" id="fromDate" value="<%= startDate != null? startDate: "" %>" required="">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">To Date</label>
                            <input type="date" class="form-control" name="end_date" id="toDate" value="<%= endDate != null? endDate: "" %>" required="">
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="filter-btn w-100">
                                <i class="fas fa-search me-2"></i>View Report
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <%
                String flag = (String) request.getAttribute("FLAG");
                if (flag != null && flag.equals("true")) {
                    ArrayList<BookingService> listB = (ArrayList) request.getAttribute("LIST_PERFORMANCE_BOOKING_SERVICE");
                    java.math.BigDecimal totalRevenueBD = (java.math.BigDecimal) request.getAttribute("TOTAL_REVENUE");
                   
                    double totalRevenueDouble = 0.0;

                    if (totalRevenueBD != null) {
                        totalRevenueDouble = totalRevenueBD.doubleValue();
                    }
            %>
                    <div class="summary-card">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h6 class="mb-0">Total Revenue (<%= startDate %> - <%= endDate %>)</h6>
                                <div class="summary-value" id="totalRevenue"><%= totalRevenueDouble %> VND</div>
                                <p class="mb-0"><i class="fas fa-check-circle me-2"></i><span id="totalServices"><%= listB == null ? 0 : listB.size() %></span> completed services</p>
                            </div>
                            <div class="col-md-4 text-end">
                                <i class="fas fa-coins" style="font-size: 80px; opacity: 0.3;"></i>
                            </div>
                        </div>
                    </div>
                    <div class="report-selector">
                        <h5 class="mb-4"><i class="fas fa-list-ul me-2"></i>Completed Booking Services</h5>
                        <%
                            if(listB != null && !listB.isEmpty()){
                                for (BookingService bookingservice : listB) {
                                %>
                                <div class="booking-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-2">
                                            <strong>#BK001</strong>
                                            <div class="text-muted small"><%= bookingservice.getServiceDate() %></div>
                                        </div>
<!--                                        <div class="col-md-3">
                                            <div><i class="fas fa-user me-2 text-primary"></i>Nguy?n V?n A</div>
                                            <div class="text-muted small">Customer</div>
                                        </div>-->
                                        <div class="col-md-3">
                                            <div><i class="fas fa-cut me-2 text-success"></i><%= bookingservice.getServiceId() %></div>
                                            <div class="text-muted small">Service</div>
                                        </div>
                                        <div class="col-md-2">
                                            <span class="status-badge status-completed"> <%= bookingservice.getStatus() %></span>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <strong class="text-success" style="font-size: 18px;">350,000 </strong>
                                        </div>
                                    </div>
                                </div>
                        
                                <%
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
