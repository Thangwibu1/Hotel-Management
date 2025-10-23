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
        <div class="search-box">
            <input type="text" placeholder="Search customer, room, or service...">
        </div>

        <div class="tabs d-flex flex-column flex-md-row gap-2">

            <form action="<%= IConstant.registerServiceController %>" method="get" class="tab-form active w-100 w-md-auto">
                <button type="submit" class="tab  w-100">
                    Register Service
                </button>
            </form>

            <form action="/UpdateStatusController" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100 active">
                    Update Status
                </button>
            </form>

                <form action="<%= IConstant.reportServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100">
                    Reports
                </button>
            </form>
        </div>

        <div class="card">
            <div class="section-title">Register New Service for Guest</div>
            
            <div class="form-row">
                
                <div class="form-group">
                    <label>Room Number *</label>
                    <input type="text" placeholder="E.g., 101, 205A">
                </div>
                <div class="form-group">
                    <label>Customer Information *</label>
                    <input type="text" placeholder="Enter customer name">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Service Type *</label>
                    <select>
                        <option>Select service type</option>
                        <option>Massage</option>
                        <option>Breakfast</option>
                        <option>Laundry</option>
                        <option>Shuttle</option>
                        <option>Housekeeping</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Specific Service Name *</label>
                    <input type="text" placeholder="E.g., Relaxation Massage, Set Breakfast">
                </div>
            </div>

            <div class="form-group">
                <label>Quantity</label>
                <input type="number" value="1" min="1">
            </div>

            <div class="form-group">
                <label>Additional Notes</label>
                <textarea placeholder="Special requests, preferred habits..."></textarea>
            </div>

            <button class="btn-add-service ">Create Service</button>
        </div>

        <div class="card">
            <div class="section-title">Recently Logged Services</div>
            
            <div class="services-list">
                
                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Buffet Breakfast</div>
                        <div class="service-details">Nguyen Van A • Room 101</div>
                    </div>
                    <span class="service-status status-completed">
                        <span class="status-dot"></span>
                        Completed
                    </span>
                    <span class="service-time">08:30</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #fab1a0 0%, #ff7675 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Full Body Massage</div>
                        <div class="service-details">Tran Thi B • Room 205</div>
                    </div>
                    <span class="service-status status-waiting">
                        <span class="status-dot"></span>
                        Pending
                    </span>
                    <span class="service-time">09:15</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Laundry Service</div>
                        <div class="service-details">Le Van C • Room 312</div>
                    </div>
                    <span class="service-status status-processing">
                        <span class="status-dot"></span>
                        In Progress
                    </span>
                    <span class="service-time">10:00</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #55efc4 0%, #00b894 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Special Service</div>
                        <div class="service-details">Pham Thi D • Room 108</div>
                    </div>
                    <span class="service-status status-completed">
                        <span class="status-dot"></span>
                        Completed
                    </span>
                    <span class="service-time">11:20</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Airport Shuttle</div>
                        <div class="service-details">Hoang Van E • Room 407</div>
                    </div>
                    <span class="service-status status-waiting">
                        <span class="status-dot"></span>
                        Pending
                    </span>
                    <span class="service-time">14:30</span>
                </div>
            </div>
        </div>
        
    </div>
    <jsp:include page="footerService.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>