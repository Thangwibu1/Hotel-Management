<%-- 
    Document   : addServicePage
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
            String checkIn = (String) request.getAttribute("checkIn");
            String checkOut = (String) request.getAttribute("checkOut");
            BigDecimal priceOfRoom = (BigDecimal) request.getAttribute("priceOfRoom");
            long nights = (long) request.getAttribute("nights");
            Booking booking = (Booking) request.getAttribute("BOOKING");
            Room room = (Room) request.getAttribute("room");
            BigDecimal roomTotal = (BigDecimal) request.getAttribute("ROOM_TOTAL");
            BigDecimal roomTotalBD = roomTotal == null ? BigDecimal.ZERO : roomTotal;
            BigDecimal servicesTotalBD = BigDecimal.ZERO;
            if (servicesBooked != null) {
                for (ServiceDetail d : servicesBooked) {
                    BigDecimal line = d.getPrice().multiply(new BigDecimal(d.getQuantity()));
                    servicesTotalBD = servicesTotalBD.add(line);
                }
            }
            BigDecimal grandBD = roomTotalBD.add(servicesTotalBD);
            if (services != null) {
        %>

        <div class="services-container">
            <div class="card services-card">

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
                                <% if (servicesBooked != null) {
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



                <!-- Selected Services -->
                <div class="services-header">
                    <h3 class="section-title">Add Services</h3>
                    <a href="#" id="btnAddService" class="add-service-btn">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Add Service
                    </a>
                </div>

                <form id="serviceForm" action="EditBookingController" method="POST">
                    <div id="serviceRows" class="service-rows">
                        <% if (servicesBooked != null && !servicesBooked.isEmpty()) {
                                for (ServiceDetail d : servicesBooked) {
                                    int selId = d.getServiceId();                 // ho?c d.getService().getServiceId()
                                    int qty = d.getQuantity();
                                    String dateVal = d.getServiceDate() == null ? "" : d.getServiceDate().toString(); // yyyy-MM-dd
                                    // n?u có id dòng (?? update thay vì insert) thì l?y ra
                                    //Integer bsId = d.getBookingServiceId(); // n?u model có field này
%>
                        <div class="service-row">
                            <div class="service-row-header">
                                <div class="service-field">
                                    <label class="field-label">Service</label>
                                    <select class="form-select service-select">
                                        <option value="0">Select a service</option>
                                        <% for (Service s : services) {%>
                                        <option value="<%= s.getServiceId()%>"
                                                data-name="<%= s.getServiceName().replace("\"", "&quot;")%>"
                                                data-price="<%= s.getPrice()%>"
                                                <%= (s.getServiceId() == selId ? "selected" : "")%>>
                                            <%= s.getServiceName()%> - $<%= s.getPrice()%>
                                        </option>
                                        <% }%>
                                    </select>
                                </div>

                                <div class="service-field">
                                    <label class="field-label">Quantity</label>
                                    <input type="number" class="form-input service-qty" value="<%= qty%>" min="1" max="<%= nights%>">
                                </div>

                                <div class="service-field">
                                    <label class="field-label">Date</label>
                                    <input type="date" class="form-input service-date"
                                           value="<%= dateVal%>" min="<%= checkIn%>" max="<%= checkOut%>">
                                </div>

                                <button type="button" class="remove-btn">X</button>
                            </div>

                            <div class="service-total">
                                <span class="service-total-label"></span>
                                <span class="service-total-value"></span>
                            </div>
                        </div>
                        <%   } // end for
      } // end if
%>
                    </div>

                    <input type="hidden" name="selectedRoomId" value="<%= request.getAttribute("roomId")%>">
                    <input type="hidden" name="guestId"        value="<%= request.getAttribute("guestId")%>">
                    <input type="hidden" name="checkInTime"    value="<%= checkIn%>">
                    <input type="hidden" name="checkOutTime"   value="<%= checkOut%>">
                    <input type="hidden" name="bookingDate"    value="<%= request.getAttribute("bookingDate")%>">
                </form>


                <template id="serviceRowTpl">
                    <div class="service-row">
                        <div class="service-row-header">
                            <div class="service-field">
                                <label class="field-label">Service</label>
                                <select class="form-select service-select">
                                    <option value="0">Select a service</option>
                                    <% for (Service s : services) {%>
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
                                <input type="number" class="form-input service-qty" value="1" min="1" max="<%= nights%>">
                            </div>

                            <div class="service-field">
                                <label class="field-label">Date</label>
                                <input type="date" class="form-input service-date" min="<%= checkIn%>" max="<%= checkOut%>">
                            </div>

                            <button type="button" class="remove-btn">X</button>
                        </div>

                        <div class="service-total">
                            <span class="service-total-label"></span>
                            <span class="service-total-value"></span>
                        </div>
                    </div>
                </template>


            </div>
        </div>
        <%
        } else {
        %>
        <h1>khong co giii</h1>
        <%
            }
        %>
        <script>
            (function () {
            const ROOM_TOTAL = Number("<%= roomTotalBD%>");
            const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));
            const fmt = n => "$" + (isNaN(n) ? "0.00" : Number(n).toFixed(2));
            const rowsBox = document.getElementById('serviceRows');
            const form = document.getElementById('serviceForm');
            const sumList = document.getElementById('summaryServicesList');
            const sumSvc = document.getElementById('summaryServicesTotal');
            const sumAll = document.getElementById('summaryGrandTotal');
            document.getElementById('summaryRoomTotal').textContent = fmt(ROOM_TOTAL);
            const tpl = document.getElementById('serviceRowTpl');
            function addRow() {
            const node = document.importNode(tpl.content, true);
            rowsBox.appendChild(node);
            renderSummary();
            }

            function getRowInfo(row) {
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
            if (!info) { lbl.textContent = ""; val.textContent = ""; return; }
            lbl.textContent = info.name + " - " + fmt(info.price) + " × " + info.qty + (info.date ? " (" + info.date + ")" : "");
            val.textContent = fmt(info.total);
            }

            function renderSummary() {
            let sum = 0;
            sumList.innerHTML = ""; // clear

            $$('.service-row', rowsBox).forEach(row => {
            const info = getRowInfo(row);
            renderRowTotal(row, info);
            if (!info) return;
            sum += info.total;
            const div = document.createElement('div');
            div.className = 'service-item';
            div.textContent = info.name + " × " + info.qty + (info.date ? " (" + info.date + ")" : "");
            sumList.appendChild(div);
            });
            sumSvc.textContent = fmt(sum);
            sumAll.textContent = fmt(ROOM_TOTAL + sum);
            }

            rowsBox.addEventListener('input', e => {
            if (e.target.matches('.service-qty, .service-date')) renderSummary();
            });
            rowsBox.addEventListener('change', e => {
            if (e.target.matches('.service-select, .service-qty, .service-date')) renderSummary();
            });
            rowsBox.addEventListener('click', e => {
            if (e.target.closest('.remove-btn')) { e.target.closest('.service-row')?.remove(); renderSummary(); }
            });
            document.getElementById('btnAddService').addEventListener('click', e => { e.preventDefault(); addRow(); });
            })();

        </script>
    </body>
</html>
