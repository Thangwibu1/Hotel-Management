<%-- 
    Document   : EmployeePerformancePage
    Created on : Oct 26, 2025, 5:46:40 PM
    Author     : TranHongGam
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.BookingService"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --tertiary-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                --dark-gradient: linear-gradient(135deg, #4a5568 0%, #2d3748 100%);
            }
            .header {
                padding-top: 16px !important;
                padding-bottom: 16px !important;
            }

            body {
                background: linear-gradient(135deg, #e3e7f1 0%, #f0f0f5 100%);
                min-height: 100vh;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }

            /* Header Custom Styles */
            .custom-header {
                background: var(--dark-gradient);
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .avatar {
                width: 50px;
                height: 50px;
                background: var(--primary-gradient);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 20px;
                font-weight: bold;
            }

            .btn-logout {
                background: #e53e3e;
                border: none;
                transition: all 0.3s;
            }

            .btn-logout:hover {
                background: #c53030;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(229, 62, 62, 0.4);
            }

            /* Navigation Custom Styles */
            .nav-pills .nav-link {
                color: #4a5568;
                font-weight: 600;
                border-radius: 8px;
                transition: all 0.3s;
            }

            .nav-pills .nav-link.active {
                background: var(--primary-gradient);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            }

            .nav-pills .nav-link:hover:not(.active) {
                background: #f7fafc;
            }

            /* Page Title */
            .page-title-icon {
                width: 40px;
                height: 40px;
                background: var(--primary-gradient);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 20px;
            }

            /* Summary Cards */
            .summary-card {
                background: var(--primary-gradient);
                border-radius: 12px;
                color: white;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
                transition: all 0.3s;
            }

            .summary-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .summary-card.secondary {
                background: var(--secondary-gradient);
                box-shadow: 0 4px 12px rgba(245, 87, 108, 0.3);
            }

            .summary-card.tertiary {
                background: var(--tertiary-gradient);
                box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
            }

            .summary-value {
                font-size: 36px;
                font-weight: bold;
            }

            /* Filter Section */
            .filter-section {
                background: #f7fafc;
                border-radius: 10px;
            }

            .btn-filter {
                background: var(--primary-gradient);
                border: none;
                transition: all 0.3s;
            }

            .btn-filter:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            }

            /* Service Cards */
            .service-card {
                border: 2px solid #e2e8f0;
                border-left: 5px solid;
                border-left-color: #667eea;
                border-radius: 12px;
                transition: all 0.3s;
                background: white;
            }

            .service-card:hover {
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
                transform: translateY(-3px);
                border-color: #667eea;
            }

            .service-id-badge {
                background: var(--primary-gradient);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 14px;
                display: inline-block;
            }

            .badge-completed {
                background-color: #c6f6d5;
                color: #22543d;
            }

            .badge-pending {
                background-color: #fef3c7;
                color: #78350f;
            }

            .badge-cancelled {
                background-color: #fed7d7;
                color: #742a2a;
            }

            .detail-label {
                font-size: 12px;
                color: #718096;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-weight: 600;
            }

            .detail-value {
                font-size: 16px;
                color: #2d3748;
                font-weight: 600;
            }

            .service-note {
                background: #f7fafc;
                border-left: 3px solid #667eea;
            }

            .note-label {
                font-size: 12px;
                color: #718096;
                font-weight: 600;
                text-transform: uppercase;
            }

            .note-text {
                color: #4a5568;
                font-size: 14px;
                line-height: 1.6;
            }
        </style>
    </head>
    <body>
        <%
            ArrayList<BookingService> bookingServiceList = (ArrayList<BookingService>) request.getAttribute("LIST_PERFORMANCE_BOOKING_SERVICE");
            if (bookingServiceList == null || bookingServiceList.isEmpty()) {
                System.out.println("Da vo thanh cong");
            }
            for (BookingService bs : bookingServiceList) {
                System.out.println(bs.toString());
            }

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
                    
                    
            <!--//type report-->
            <div class="row g-4 justify-content-center">

                   
                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <form action="<%= IConstant.listServiceTodayController%>" method="POST" class="h-100"> 

                            <input type="hidden" name="report_type" value="today_services">
                            <button type="submit" 
                                    class="card report-card shadow-sm w-100 border-0 h-100" 
                                    style="cursor: pointer; background-color: white;"> 

                                <div class="card-body text-center d-flex flex-column justify-content-center align-items-center">
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



            <div class="container-fluid px-4 mt-3 mb-4">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <!-- Page Title -->
                        <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                            <h2 class="mb-0">Employee Performance Statistics</h2>
                        </div>

                        <!-- Filter Section -->
                        <div class="filter-section p-3 mb-4 ">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-secondary">STATUS</label>
                                    <select class="form-select" id="statusFilter">
                                        <option value="all">All Status</option>
                                        <option value="1">Completed</option>
                                        <option value="0">Pending</option>
                                        <option value="-1">Cancelled</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-secondary">FROM DATE</label>
                                    <input type="date" class="form-control" id="fromDate">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-secondary">TO DATE</label>
                                    <input type="date" class="form-control" id="toDate">
                                </div>
                                <div class="col-md-3">
                                    <button class="btn btn-filter text-white w-100 fw-bold" onclick="applyFilter()">
                                        <i class="fas fa-filter me-2"></i>Apply Filter
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Services Grid -->
                        <div class="row g-3" id="servicesContainer">
                            <!-- Service Card 1 -->
                            <div class="col-12">
                                <div class="service-card p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="service-id-badge">BS-001</span>
                                        <span class="badge badge-completed px-3 py-2">COMPLETED</span>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-2">
                                            <div class="detail-label">Booking ID</div>
                                            <div class="detail-value">#BK-12345</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Service ID</div>
                                            <div class="detail-value">#SV-789</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Quantity</div>
                                            <div class="detail-value">2</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Service Date</div>
                                            <div class="detail-value">2024-10-25</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Staff ID</div>
                                            <div class="detail-value">#STAFF-007</div>
                                        </div>
                                    </div>
                                    <div class="service-note p-3 rounded">
                                        <div class="note-label mb-1">NOTE</div>
                                        <div class="note-text">Customer requested premium haircut with styling. Service completed with high satisfaction.</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Service Card 2 -->
                            <div class="col-12">
                                <div class="service-card p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="service-id-badge">BS-002</span>
                                        <span class="badge badge-pending px-3 py-2">PENDING</span>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-2">
                                            <div class="detail-label">Booking ID</div>
                                            <div class="detail-value">#BK-12346</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Service ID</div>
                                            <div class="detail-value">#SV-790</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Quantity</div>
                                            <div class="detail-value">1</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Service Date</div>
                                            <div class="detail-value">2024-10-28</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Staff ID</div>
                                            <div class="detail-value">#STAFF-007</div>
                                        </div>
                                    </div>
                                    <div class="service-note p-3 rounded">
                                        <div class="note-label mb-1">NOTE</div>
                                        <div class="note-text">Hair coloring service scheduled for this afternoon. Customer prefers natural brown tone.</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Service Card 3 -->
                            <div class="col-12">
                                <div class="service-card p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="service-id-badge">BS-003</span>
                                        <span class="badge badge-completed px-3 py-2">COMPLETED</span>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-2">
                                            <div class="detail-label">Booking ID</div>
                                            <div class="detail-value">#BK-12347</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Service ID</div>
                                            <div class="detail-value">#SV-791</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Quantity</div>
                                            <div class="detail-value">3</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Service Date</div>
                                            <div class="detail-value">2024-10-24</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Staff ID</div>
                                            <div class="detail-value">#STAFF-007</div>
                                        </div>
                                    </div>
                                    <div class="service-note p-3 rounded">
                                        <div class="note-label mb-1">NOTE</div>
                                        <div class="note-text">Full spa treatment package for family. All services completed successfully with positive feedback.</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Service Card 4 -->
                            <div class="col-12">
                                <div class="service-card p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="service-id-badge">BS-004</span>
                                        <span class="badge badge-cancelled px-3 py-2">CANCELLED</span>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-2">
                                            <div class="detail-label">Booking ID</div>
                                            <div class="detail-value">#BK-12348</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Service ID</div>
                                            <div class="detail-value">#SV-792</div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="detail-label">Quantity</div>
                                            <div class="detail-value">1</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Service Date</div>
                                            <div class="detail-value">2024-10-26</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="detail-label">Staff ID</div>
                                            <div class="detail-value">#STAFF-007</div>
                                        </div>
                                    </div>
                                    <div class="service-note p-3 rounded">
                                        <div class="note-label mb-1">NOTE</div>
                                        <div class="note-text">Customer cancelled due to emergency. Rescheduled to next week.</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>



        </div>



        <jsp:include page="footerService.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
