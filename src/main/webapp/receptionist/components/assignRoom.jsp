<%@page import="model.RoomInformation"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BookingActionRow"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>

<div>
    <div class="card info-card">
        <div class="card-header">
            <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="8" width="18" height="11" rx="2"></rect>
            <path d="M7 8V6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2"></path>
            </svg>
            <h2 class="card-title">Room Information</h2>
        </div>

        <%
            BookingActionRow row = (BookingActionRow) request.getAttribute("DETAIL_ROW");
            ArrayList<RoomInformation> rooms = (ArrayList<RoomInformation>) request.getAttribute("AVAILABLE_ROOMS");

            int currentRoomId = row.getRoom().getRoomId();
            String currentRoomNo = row.getRoom().getRoomNumber();
            String typeName = row.getRoomType().getTypeName();
            String typePrice = String.valueOf(row.getRoomType().getPricePerNight());

            boolean allowAssignRoom = Boolean.parseBoolean(request.getParameter("ALLOW_ASSIGN_ROOM"));
        %>

        <!-- Room Type (readonly display) -->
        <div class="info-item">
            <div class="info-label">Room Type</div>
            <input type="text" class="form-input" value="<%= typeName%>" readonly>
        </div>

        <!-- Room Number (select) -->
        <div class="info-item">
            <div class="info-label">Room Number</div>
            <select id="roomSelect" name="roomId" class="form-input" <%= allowAssignRoom ? "" : "disabled"%>>
                <option value="" disabled>-- Choose a room --</option>
                <%
                    if (rooms != null && !rooms.isEmpty()) {
                        for (RoomInformation r : rooms) {
                            boolean selected = (r.getRoom().getRoomId() == currentRoomId);
                %>
                <option value="<%= r.getRoom().getRoomId()%>"
                        data-rate="<%= typePrice%>"
                        <%= selected ? "selected" : ""%>>
                    Room <%= r.getRoom().getRoomNumber()%>
                </option>
                <%
                    }
                } else {
                %>
                <option value="<%= currentRoomId%>" selected>
                    Room <%= currentRoomNo%>
                </option>
                <%
                    }
                %>
            </select>

            <%
                if (!allowAssignRoom) {
            %>
            <input type="hidden" name="roomId" value="<%= currentRoomId%>">
            <%
                }
            %>
        </div>

        <div class="info-item">
            <div class="info-label">Rate per Night</div>
            <input type="text" id="ratePerNight" class="form-input" value="$<%= typePrice%>" readonly>
        </div>
    </div>
</div>

<script>
    (function () {
        var sel = document.getElementById('roomSelect');
        var rate = document.getElementById('ratePerNight');
        if (!sel || !rate)
            return;

        function syncRate() {
            var opt = sel.options[sel.selectedIndex];
            var r = opt ? opt.getAttribute('data-rate') : null;
            if (r)
                rate.value = '$' + r;
        }
        sel.addEventListener('change', syncRate);
        syncRate();
    })();
</script>
