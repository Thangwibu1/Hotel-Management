<%-- 
    Document   : editServices
    Created on : Nov 3, 2025, 11:06:13 AM
    Author     : trinhdtu
--%>

<%@page import="model.Room"%>
<%@page import="model.Booking"%>
<%@page import="model.ServiceDetail"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.RoomType"%>
<%@page import="dao.RoomTypeDAO"%>
<%@page import="dao.RoomDAO"%>
<%@page import="model.Service"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            ArrayList<ServiceDetail> servicesBooked = (ArrayList<ServiceDetail>) request.getAttribute("SERVICE_DETAILS");
            ArrayList<Service> services = (ArrayList<Service>) request.getAttribute("SERVICES");
            ArrayList<Service> servicesReal = (ArrayList<Service>) request.getAttribute("SERVICESofHOTEL");
            String checkIn = (String) request.getAttribute("checkIn");
            String checkOut = (String) request.getAttribute("checkOut");
            BigDecimal priceOfRoom = (BigDecimal) request.getAttribute("priceOfRoom");
            long nights = (long) request.getAttribute("nights");
            Booking booking = (Booking) request.getAttribute("BOOKING");
            Room room = (Room) request.getAttribute("room");
            BigDecimal roomTotal = (BigDecimal) request.getAttribute("ROOM_TOTAL");
            BigDecimal roomTotalBD = roomTotal == null ? BigDecimal.ZERO : roomTotal;
            
            // Tính t?ng services ?ã book
            BigDecimal servicesTotalBD = BigDecimal.ZERO;
            if (servicesBooked != null) {
                for (ServiceDetail d : servicesBooked) {
                    BigDecimal line = d.getPrice().multiply(new BigDecimal(d.getQuantity()));
                    servicesTotalBD = servicesTotalBD.add(line);
                }
            }
            BigDecimal grandBD = roomTotalBD.add(servicesTotalBD);
            
            boolean allowServices = false;
            Object allowSvAttr = request.getAttribute("ALLOW_SERVICES");
            if (allowSvAttr instanceof Boolean) {
                allowServices = (Boolean) allowSvAttr;
            } else {
                String p = request.getParameter("ALLOW_SERVICES");
                if (p != null) {
                    allowServices = Boolean.parseBoolean(p);
                }
            }
        %>

        <div class="card services-card" style="margin-top: 24px">

            <!-- Booking Summary -->
            <h3 class="summary-title">Services Summary</h3>
            <div class="booking-summary">
                <div class="summary-row">
                    <span class="summary-label">Room <%= room.getRoomNumber()%> (<%= nights%> nights)</span>
                    <span class="summary-value" id="summaryRoomTotal">$<%= roomTotalBD%></span>
                </div>

                <div class="summary-row">
                    <div>
                        <div class="summary-label">Services:</div>
                        <div class="services-list" id="summaryServicesList">
                            <% if (servicesBooked != null && !servicesBooked.isEmpty()) {
                                    for (ServiceDetail s : servicesBooked) {
                                        String dt = s.getServiceDate() == null ? "" : " (" + s.getServiceDate().toString() + ")";
                            %>
                            <div class="service-item"><%= s.getServiceName()%> × <%= s.getQuantity()%><%= dt%></div>
                            <% }
                                }%>
                        </div>
                    </div>
                    <span class="summary-value" id="summaryServicesTotal">$<%= servicesTotalBD%></span>
                </div>

                <div class="summary-row total-row">
                    <span class="summary-label">Total Amount</span>
                    <span class="summary-value" id="summaryGrandTotal">$<%= grandBD%></span>
                </div>
            </div>

            <% if (servicesBooked != null && !servicesBooked.isEmpty()) { %>
            <div class="services-header" style="margin-top: 24px;">
                <h3 class="section-title">Booked Services</h3>
                <span style="color: #666; font-size: 14px;">? Cannot be modified</span>
            </div>
            
            <div class="service-rows">
                <% for (ServiceDetail d : servicesBooked) {
                    String dateVal = d.getServiceDate() == null ? "" : d.getServiceDate().toString();
                    BigDecimal lineTotal = d.getPrice().multiply(new BigDecimal(d.getQuantity()));
                %>
                <div class="service-row" style="background-color: #f9f9f9; border-left: 3px solid #999;">
                    <div class="service-row-header">
                        <div class="service-field">
                            <label class="field-label">Service</label>
                            <input type="text" class="form-input" 
                                   value="<%= d.getServiceName()%> - $<%= d.getPrice()%>" 
                                   readonly disabled style="background-color: #f5f5f5; cursor: not-allowed;">
                        </div>

                        <div class="service-field">
                            <label class="field-label">Quantity</label>
                            <input type="number" class="form-input" 
                                   value="<%= d.getQuantity()%>" 
                                   readonly disabled style="background-color: #f5f5f5; cursor: not-allowed;">
                        </div>

                        <div class="service-field">
                            <label class="field-label">Date</label>
                            <input type="date" class="form-input" 
                                   value="<%= dateVal%>" 
                                   readonly disabled style="background-color: #f5f5f5; cursor: not-allowed;">
                        </div>

                        <div style="width: 40px; display: flex; align-items: center; justify-content: center;">
                            <span style="font-size: 4px; color: #999;"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="#000000" d="M16 11H8a1 1 0 0 1-1-1V7a5 5 0 0 1 10 0v3a1 1 0 0 1-1 1ZM9 9h6V7a3 3 0 0 0-6 0Z" opacity=".5"/><rect width="16" height="13" x="4" y="9" fill="#000000" rx="3"/></svg></span>
                        </div>
                    </div>

                    <div class="service-total">
                        <span class="service-total-label"><%= d.getServiceName()%> - $<%= d.getPrice()%> × <%= d.getQuantity()%><%= dateVal.isEmpty() ? "" : " (" + dateVal + ")"%></span>
                        <span class="service-total-value">$<%= lineTotal%></span>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>

            <div class="services-header" style="margin-top: 32px;">
                <h3 class="section-title">Add New Services</h3>
                <% if (allowServices) { %>
                <a href="#" id="btnAddService" class="add-service-btn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    Add Service
                </a>
                <% } else { %>
                <span class="add-service-btn" style="opacity:.5;cursor:not-allowed;">Cannot add services in this status</span>
                <% } %>
            </div>

            <div id="serviceRows" class="service-rows">
                <% if (allowServices) { %>
                <div class="service-row" data-new-service="true">
                    <div class="service-row-header">
                        <div class="service-field">
                            <label class="field-label">Service</label>
                            <select class="form-select service-select" name="serviceId[]">
                                <option value="0">Select a service</option>
                                <% for (Service s : servicesReal) {%>
                                <option value="<%= s.getServiceId()%>"
                                        data-name="<%= s.getServiceName().replace("\"", "&quot;")%>"
                                        data-price="<%= s.getPrice()%>">
                                    <%= s.getServiceName()%> - $<%= s.getPrice()%>
                                </option>
                                <% }%>
                            </select>
                        </div>

                        <div class="service-field">
                            <label class="field-label">Quantity</label>
                            <input type="number" class="form-input service-qty" name="quantity[]" value="1" min="1" max="<%= nights%>">
                        </div>

                        <div class="service-field">
                            <label class="field-label">Date</label>
                            <input type="date" class="form-input service-date" name="serviceDate[]" min="<%= checkIn%>" max="<%= checkOut%>">
                        </div>

                        <button type="button" class="remove-btn">×</button>
                    </div>

                    <div class="service-total">
                        <span class="service-total-label"></span>
                        <span class="service-total-value"></span>
                    </div>
                </div>
                <% } else { %>
                <p style="color: #999; padding: 20px; text-align: center;">No new services can be added in current booking status.</p>
                <% } %>
            </div>

            <input type="hidden" name="selectedRoomId" value="<%= booking.getRoomId()%>">
            <input type="hidden" name="guestId"        value="<%= booking.getGuestId()%>">
            <input type="hidden" name="checkInTime"    value="<%= checkIn%>">
            <input type="hidden" name="checkOutTime"   value="<%= checkOut%>">
            <input type="hidden" name="bookingDate"    value="<%= booking.getBookingDate()%>">

            <template id="serviceRowTpl">
                <div class="service-row" data-new-service="true">
                    <div class="service-row-header">
                        <div class="service-field">
                            <label class="field-label">Service</label>
                            <select class="form-select service-select" name="serviceId[]">
                                <option value="0">Select a service</option>
                                <% if (servicesReal != null) {
                                    for (Service s : servicesReal) {%>
                                <option value="<%= s.getServiceId()%>"
                                        data-name="<%= s.getServiceName().replace("\"", "&quot;")%>"
                                        data-price="<%= s.getPrice()%>">
                                    <%= s.getServiceName()%> - $<%= s.getPrice()%>
                                </option>
                                <% }
                                }%>
                            </select>
                        </div>

                        <div class="service-field">
                            <label class="field-label">Quantity</label>
                            <input type="number" class="form-input service-qty" name="quantity[]" value="1" min="1" max="<%= nights%>">
                        </div>

                        <div class="service-field">
                            <label class="field-label">Date</label>
                            <input type="date" class="form-input service-date" name="serviceDate[]" min="<%= checkIn%>" max="<%= checkOut%>">
                        </div>

                        <button type="button" class="remove-btn">×</button>
                    </div>

                    <div class="service-total">
                        <span class="service-total-label"></span>
                        <span class="service-total-value"></span>
                    </div>
                </div>
            </template>
            
            <!-- Action Buttons -->
            <div class="action-buttons" style="margin-top: 24px">
                <a href="http://localhost:8080/PRJ_Assignment/receptionist/receptionist?tab=bookings" class="btn-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    Back to List
                </a>
                <button type="submit" form="bookingForm" class="btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                    Save Update Booking
                </button>
            </div>
        </div>

        <script>
            (function () {
                const ROOM_TOTAL = Number("<%= roomTotalBD%>");
                const BOOKED_SERVICES_TOTAL = Number("<%= servicesTotalBD%>");
                const CAN_EDIT = <%= allowServices ? "true" : "false"%>;
                
                const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));
                const fmt = n => "$" + (isNaN(n) ? "0.00" : Number(n).toFixed(2));
                
                const rowsBox = document.getElementById('serviceRows');
                const sumList = document.getElementById('summaryServicesList');
                const sumSvc = document.getElementById('summaryServicesTotal');
                const sumAll = document.getElementById('summaryGrandTotal');
                const tpl = document.getElementById('serviceRowTpl');
                const btnAdd = document.getElementById('btnAddService');
                
                // Set initial room total
                document.getElementById('summaryRoomTotal').textContent = fmt(ROOM_TOTAL);
                
                function addRow() {
                    if (!CAN_EDIT) return;
                    const node = document.importNode(tpl.content, true);
                    rowsBox.appendChild(node);
                    renderSummary();
                }
                
                function getRowInfo(row) {
                    if (!row.hasAttribute('data-new-service')) {
                        return null;
                    }
                    
                    const selEl = row.querySelector('.service-select');
                    if (!selEl || selEl.value === "0") return null;
                    
                    const opt = selEl.options[selEl.selectedIndex];
                    const rawTxt = (opt.textContent || "").trim();
                    const name = (opt.dataset?.name?.trim()) || (rawTxt.split(' - $')[0] || "").trim();
                    
                    let price = Number(opt.dataset?.price);
                    if (!Number.isFinite(price)) {
                        const m = rawTxt.match(/\$(\d+(?:\.\d+)?)/);
                        price = Number(m ? m[1] : "0");
                    }

                    let qty = parseInt(row.querySelector('.service-qty').value, 10);
                    if (!Number.isFinite(qty) || qty < 1) qty = 1;
                    
                    const date = row.querySelector('.service-date').value || "";
                    return { id: selEl.value, name, price, qty, date, total: price * qty };
                }

                function renderRowTotal(row, info) {
                    const lbl = row.querySelector('.service-total-label');
                    const val = row.querySelector('.service-total-value');
                    if (!info) { 
                        lbl.textContent = ""; 
                        val.textContent = ""; 
                        return; 
                    }
                    lbl.textContent = info.name + " - " + fmt(info.price) + " × " + info.qty + (info.date ? " (" + info.date + ")" : "");
                    val.textContent = fmt(info.total);
                }

                function renderSummary() {
                    let newServicesSum = 0; 
                    
                    // Ch? tính các row m?i thêm
                    $$('.service-row[data-new-service]', rowsBox).forEach(row => {
                        const info = getRowInfo(row);
                        renderRowTotal(row, info);
                        if (!info) return;
                        newServicesSum += info.total;
                    });
                    
                    const totalServices = BOOKED_SERVICES_TOTAL + newServicesSum;
                    sumSvc.textContent = fmt(totalServices);
                    sumAll.textContent = fmt(ROOM_TOTAL + totalServices);
                }

                // Event listeners
                if (rowsBox) {
                    rowsBox.addEventListener('input', e => {
                        if (e.target.matches('.service-qty, .service-date')) {
                            renderSummary();
                        }
                    });
                    
                    rowsBox.addEventListener('change', e => {
                        if (e.target.matches('.service-select, .service-qty, .service-date')) {
                            renderSummary();
                        }
                    });
                    
                    rowsBox.addEventListener('click', e => {
                        const removeBtn = e.target.closest('.remove-btn');
                        if (removeBtn) {
                            const row = removeBtn.closest('.service-row');
                            if (row && row.hasAttribute('data-new-service')) {
                                row.remove();
                                renderSummary();
                            } else {
                                e.preventDefault();
                            }
                        }
                    });
                }
                
                if (btnAdd) {
                    btnAdd.addEventListener('click', e => { 
                        e.preventDefault(); 
                        if (CAN_EDIT) {
                            addRow();
                        }
                    });
                }
                
                // Initialize summary
                renderSummary();
            })();
        </script>
    </body>
</html>