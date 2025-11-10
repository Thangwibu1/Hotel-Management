<%-- 
    Document   : addServicePage
    Created on : Nov 3, 2025, 11:06:13 AM
    Author     : trinhdtu
--%>

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
            ArrayList<Service> services = (ArrayList<Service>) request.getAttribute("SERVICES");
            String checkIn = (String) request.getAttribute("checkIn");
            String checkOut = (String) request.getAttribute("checkOut");
            String roomNumber = (String) request.getAttribute("roomNumber");
            BigDecimal priceOfRoom = (BigDecimal) request.getAttribute("priceOfRoom");
            long nights = (long) request.getAttribute("nights");
            if (services != null) {
        %>
        <div class="services-container">
            <div class="card services-card">
                <p class="intro-text">Enhance your stay with our premium services. All services are optional.</p>

                <!-- Booking Summary -->
                <div class="booking-summary">
                    <h3 class="summary-title">Booking Summary</h3>

                    <div class="summary-row">
                        <span class="summary-label">Room <%= roomNumber%> (<%= nights%> nights)</span>
                        <span class="summary-value" id="summaryRoomTotal">$<%= priceOfRoom%></span>
                    </div>

                    <div class="summary-row">
                        <div>
                            <div class="summary-label">Services:</div>
                            <div class="services-list" id="summaryServicesList"></div>
                        </div>
                        <span class="summary-value" id="summaryServicesTotal">$0</span>
                    </div>

                    <div class="summary-row total-row">
                        <span class="summary-label">Total Amount</span>
                        <span class="summary-value" id="summaryGrandTotal">$<%= priceOfRoom%></span>
                    </div>
                </div>


                <!-- Selected Services -->
                <div class="services-header">
                    <h3 class="section-title">Selected Services</h3>
                    <a href="#" id="btnAddService" class="add-service-btn">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Add Service
                    </a>
                </div>

                <form id="serviceForm" action="CompleteBookingController" method="POST">
                    <div id="serviceRows" class="service-rows"><!-- rows --></div>

                    <input type="hidden" name="selectedRoomId" value="<%= request.getAttribute("roomId")%>">
                    <input type="hidden" name="guestId"        value="<%= request.getAttribute("guestId")%>">
                    <input type="hidden" name="checkInTime"    value="<%= checkIn%>">
                    <input type="hidden" name="checkOutTime"   value="<%= checkOut%>">
                    <input type="hidden" name="bookingDate"    value="<%= request.getAttribute("bookingDate")%>">
                    <!-- Buttons -->
                    <div class="button-group">
                        <a href="booking-step3.jsp" class="btn-back">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            Back
                        </a>
                        <button type="submit" class="btn-complete">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                            Complete Booking
                        </button>
                    </div>
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
                                <input type="number" class="form-input service-qty" value="1" min="1" >
                            </div>

                            <div class="service-field">
                                <label class="field-label">Date</label>
                                <input type="date" class="form-input service-date" min="<%= checkIn%>" max="<%= checkOut%>">
                            </div>

                            <button type="button" class="remove-btn" style="color: red"><svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="16" height="16" viewBox="0 0 30 30">
    <path d="M 7 4 C 6.744125 4 6.4879687 4.0974687 6.2929688 4.2929688 L 4.2929688 6.2929688 C 3.9019687 6.6839688 3.9019687 7.3170313 4.2929688 7.7070312 L 11.585938 15 L 4.2929688 22.292969 C 3.9019687 22.683969 3.9019687 23.317031 4.2929688 23.707031 L 6.2929688 25.707031 C 6.6839688 26.098031 7.3170313 26.098031 7.7070312 25.707031 L 15 18.414062 L 22.292969 25.707031 C 22.682969 26.098031 23.317031 26.098031 23.707031 25.707031 L 25.707031 23.707031 C 26.098031 23.316031 26.098031 22.682969 25.707031 22.292969 L 18.414062 15 L 25.707031 7.7070312 C 26.098031 7.3170312 26.098031 6.6829688 25.707031 6.2929688 L 23.707031 4.2929688 C 23.316031 3.9019687 22.682969 3.9019687 22.292969 4.2929688 L 15 11.585938 L 7.7070312 4.2929688 C 7.5115312 4.0974687 7.255875 4 7 4 z"></path>
</svg></button>
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
                const ROOM_TOTAL = Number("<%= priceOfRoom%>");
                const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));
                const fmt = n => "$" + (isNaN(n) ? "0.00" : Number(n).toFixed(2));

                const btnAdd = document.getElementById('btnAddService');
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
                    if (!selEl || selEl.value === "0")
                        return null;

                    const opt = selEl.options[selEl.selectedIndex];
                    const rawTxt = (opt.textContent || "").trim();

                    const name = (opt.dataset && opt.dataset.name && opt.dataset.name.trim())
                            || (rawTxt.split(' - $')[0] || "").trim();

                    let price = NaN;
                    if (opt.dataset && typeof opt.dataset.price !== "undefined") {
                        price = Number(opt.dataset.price);
                    }
                    if (!Number.isFinite(price)) {
                        const m = rawTxt.match(/\$(\d+(?:\.\d+)?)/);
                        price = Number(m ? m[1] : "0");
                    }

                    let qty = parseInt(row.querySelector('.service-qty').value, 10);
                    if (!Number.isFinite(qty) || qty < 1)
                        qty = 1;

                    const date = row.querySelector('.service-date').value || "";
                    return {id: selEl.value, name, price, qty, date, total: price * qty};
                }

                function renderRowTotal(row, info) {
                    const lbl = row.querySelector('.service-total-label');
                    const val = row.querySelector('.service-total-value');
                    if (!info) {
                        lbl.textContent = "";
                        val.textContent = "";
                        return;
                    }

                    lbl.textContent =
                            info.name + " - " + fmt(info.price) + " × " + info.qty +
                            (info.date ? " (" + info.date + ")" : "");
                    val.textContent = fmt(info.total);
                }


                function renderSummary() {
                    let sum = 0;
                    sumList.innerHTML = "";
                    $$('.service-row', rowsBox).forEach(row => {
                        const info = getRowInfo(row);
                        renderRowTotal(row, info);
                        if (!info)
                            return;
                        sum += info.total;

                        const div = document.createElement('div');
                        div.className = 'service-item';
                        div.textContent = info.name + " × " + info.qty + (info.date ? " (" + info.date + ")" : "");
                        summaryServicesList.appendChild(div);
                    });
                    sumSvc.textContent = fmt(sum);
                    sumAll.textContent = fmt(ROOM_TOTAL + sum);
                }

                rowsBox.addEventListener('input', (e) => {
                    if (e.target.matches('.service-qty, .service-date'))
                        renderSummary();
                });
                rowsBox.addEventListener('change', (e) => {
                    if (e.target.matches('.service-select, .service-qty, .service-date'))
                        renderSummary();
                });
                rowsBox.addEventListener('click', (e) => {
                    if (e.target.closest('.remove-btn')) {
                        const row = e.target.closest('.service-row');
                        if (row)
                            row.remove();
                        renderSummary();
                    }
                });

                document.getElementById('btnAddService').addEventListener('click', (e) => {
                    e.preventDefault();
                    addRow();
                });

                form.addEventListener('submit', () => {
                    $$('.payload', form).forEach(n => n.remove());
                    $$('.service-row', rowsBox).forEach(row => {
                        const info = getRowInfo(row);
                        if (!info)
                            return;
                        for (const [k, v] of Object.entries({
                            'serviceId[]': info.id,
                            'qty[]': info.qty,
                            'date[]': info.date || ""
                        })) {
                            const i = document.createElement('input');
                            i.type = 'hidden';
                            i.name = k;
                            i.value = v;
                            i.className = 'payload';
                            form.appendChild(i);
                        }
                    });
                });
            })();
        </script>
    </body>
</html>
