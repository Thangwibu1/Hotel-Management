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
        <% String MSG = (String)request.getAttribute("MSG"); 
            if(MSG != null){
            String color = (String) request.getAttribute("color");
            if(color.equalsIgnoreCase("red")){
              color = "text-danger";
            }else{
              color = "text-success";
            }
            %>
            <div class="search-box">
                <h4 class="<%= color %>"><%= MSG %></h4>
            </div>
            <%
            }
        %>
        

        <div class="tabs d-flex flex-column flex-md-row gap-2">

            <form action="<%= IConstant.registerServiceController %>" method="get" class="tab-form  w-100 w-md-auto">
                <button type="submit" class="tab w-100 active">
                    Register Service
                </button>
            </form>

            <form action="<%= IConstant.updateStatusServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100">
                    Update Status
                </button>
            </form>

                <form action="<%= IConstant.reportServiceController %>" method="get" class="tab-form w-100 w-md-auto">
                <button type="submit" class="tab w-100  ">
                    Reports
                </button>
            </form>
        </div>

                <div class="card">
                    <div class="section-title">Register New Service for Guest</div>
                    <form action="<%= IConstant.makeNewServiceController %>" method="POST">

                        <div class="form-row">
                            <div class="form-group">
                                    <label for="roomNumber">Room Number *</label>

                                    <select id="roomNumber" name="room_number" required>
                                        <option value="" disabled selected>E.g., 101, 205</option> 

                                        <option value="101">101</option>
                                        <option value="102">102</option>
                                        <option value="103">103</option>
                                        <option value="201">201</option>
                                        <option value="202">202</option>
                                        <option value="203">203</option>
                                        <option value="301">301</option>
                                        <option value="302">302</option>
                                        <option value="303">303</option>
                                        <option value="401">401</option>
                                        <option value="402">402</option>
                                        <option value="501">501</option>
                                    </select> 
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="row">
                                <div class="col-md-6 mb-3 form-group">
                                    <label for="dateInput" class="form-label">Time Register *</label>
                                    <input type="date" class="form-control" id="dateInput" name="register_Date" required>
                                </div>

                                <div class="col-md-6 mb-3 form-group">
                                    <label for="timeInput" class="form-label">Start at *</label>
                                    <input type="time" class="form-control" id="timeInput" name="start_Time" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="serviceId">Service Type *</label>
                                <select id="serviceId" name="service_Id" required>
                                    <option value="">Select service type</option> <option value="Massage">Massage</option>
                                    <option value="1">Breakfast</option>
                                    <option value="3">Laundry</option>
                                    <option value="5">Housekeeping</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="quantity">Quantity</label>
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="10">
                        </div>

                        <div class="form-group">
                            <label for="note">Additional Notes</label>
                            <textarea id="note" name="note" placeholder="Special requests, preferred habits..."></textarea>
                        </div>

                        <button type="submit" class="btn-add-service" style="width: 100%">Create Service</button>

                    </form>
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