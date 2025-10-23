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

            <form action="<%= IConstant.registerServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100">
                    Register Service
                </button>
            </form>

            <form action="<%= IConstant.updateStatusServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100">
                    Update Status
                </button>
            </form>

                <form action="<%= IConstant.reportServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100  active">
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
            </div>

            <div class="form-group">
                <label>Quantity</label>
                <input type="number" value="1" min="1">
            </div>

            <div class="form-group">
                <label>Additional Notes</label>
                <textarea placeholder="Special requests, preferred habits..."></textarea>
            </div>

            <button class="btn-add-service">Create Service</button>
        </div>

       
        
    </div>
    <jsp:include page="footerService.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>