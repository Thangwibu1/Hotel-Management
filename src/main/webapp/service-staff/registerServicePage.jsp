<%-- Document : homeService Created on : Oct 16, 2025, 8:56:17 AM Author :
TranHongGam --%> 
<%@page import="utils.IConstant"%> 
<%@page import="model.Staff"%> 
<%@page import="model.Room"%> 
<%@page import="model.Service"%> 
<%@page import="java.util.ArrayList"%> 
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Booking Service - Hotel Service Management</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="./style.css" />
    <style>
      .text-dangerRed {
        background-color: #f8d7da;
        color: #842029;
        border: 1px solid #f5c2c7;
        border-radius: 0.375rem;
        padding: 1rem;
        font-weight: 700;
      }

      .text-successGreen {
        background-color: #d1e7dd;
        color: #0f5132;
        border: 1px solid #badbcc;
        border-radius: 0.375rem;
        padding: 1rem;
        font-weight: 700;
      }
    </style>
  </head>
  <body style="padding-top: 100px">
    <% 
        Staff staff = (Staff) session.getAttribute("userStaff"); 
        ArrayList<Room> rooms = (ArrayList<Room>) request.getAttribute("rooms");
        ArrayList<Service> services = (ArrayList<Service>) request.getAttribute("services");
    %>

    <jsp:include page="headerService.jsp" />
    <div
      class="container"
      style="max-width: 1200px; margin: 0 auto; padding: 2rem"
    >
      <% String MSG = (String)request.getAttribute("MSG"); if(MSG != null){
      String color = (String) request.getAttribute("color"); if(color != null &&
      color.equalsIgnoreCase("red")){ color = "text-dangerRed"; }else{ color =
      "text-successGreen"; } %>
      <div class="search-box">
        <h5 class="<%= color %>"><%= MSG %></h5>
      </div>
      <% } %>

      <div class="tabs d-flex flex-column flex-md-row gap-2">
        <form
          action="<%= IConstant.registerServiceController %>"
          method="get"
          class="tab-form w-100 w-md-auto"
        >
          <button type="submit" class="tab w-100 active">
            Register Service
          </button>
        </form>

        <form
          action="<%= IConstant.updateStatusServiceController %>"
          method="get"
          class="tab-form w-100 w-md-auto"
        >
          <button type="submit" class="tab w-100">Update Status</button>
        </form>

        <form
          action="<%= IConstant.reportServiceController %>"
          method="get"
          class="tab-form w-100 w-md-auto"
        >
          <button type="submit" class="tab w-100">Statistic</button>
        </form>
      </div>

      <div class="card">
        <div class="section-title">Register New Service for Guest</div>
        <form action="<%= IConstant.makeNewServiceController %>" method="POST">
          <div class="form-row">
            <div class="form-group">
              <label for="roomNumber">Room Number *</label>

              <select id="roomNumber" name="room_number" required>
                <option value="" disabled selected>Select room number</option>
                <% 
                  if (rooms != null && !rooms.isEmpty()) {
                    for (Room room : rooms) {
                %>
                  <option value="<%= room.getRoomNumber() %>">
                    <%= room.getRoomNumber() %> - <%= room.getStatus() %>
                  </option>
                <% 
                    }
                  } else {
                %>
                  <option value="" disabled>No rooms available</option>
                <% 
                  }
                %>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="row">
              <div class="col-md-6 mb-3 form-group">
                <label for="dateInput" class="form-label"
                  >Time Register *</label
                >
                <input
                  type="date"
                  class="form-control"
                  id="dateInput"
                  name="register_Date"
                  required
                />
              </div>

              <div class="col-md-6 mb-3 form-group">
                <label for="timeInput" class="form-label">Start at *</label>
                <input
                  type="time"
                  class="form-control"
                  id="timeInput"
                  name="start_Time"
                  required
                />
              </div>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="serviceId">Service Type *</label>
              <select id="serviceId" name="service_Id" required>
                <option value="">Select service type</option>
                <% 
                  if (services != null && !services.isEmpty()) {
                    for (Service service : services) {
                %>
                  <option value="<%= service.getServiceId() %>">
                    <%= service.getServiceName() %> - $<%= service.getPrice() %>
                  </option>
                <% 
                    }
                  } else {
                %>
                  <option value="" disabled>No services available</option>
                <% 
                  }
                %>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="quantity">Quantity</label>
            <input
              type="number"
              id="quantity"
              name="quantity"
              value="1"
              min="1"
              max="10"
            />
          </div>

          <div class="form-group">
            <label for="note">Additional Notes</label>
            <textarea
              id="note"
              name="note"
              placeholder="Special requests, preferred habits..."
            ></textarea>
          </div>

          <button type="submit" class="btn-add-service" style="width: 100%">
            Create Service
          </button>
        </form>
      </div>
    </div>
    <jsp:include page="footerService.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
