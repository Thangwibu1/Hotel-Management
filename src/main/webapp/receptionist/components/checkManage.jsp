<%-- 
    Document   : checkManage
    Created on : Oct 5, 2025, 11:54:32 AM
    Author     : trinhdtu
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.BookingActionRow"%>
<%@page import="model.Guest"%>
<%@page import="model.Booking"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>

<!-- CHECK-IN / OUT -->
<section id="checkin" class="screen">
    <div class="card" style="padding:16px">
        <div class="search">
            <span><svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="16" height="16" viewBox="0 0 50 50">
<path d="M 21 3 C 11.601563 3 4 10.601563 4 20 C 4 29.398438 11.601563 37 21 37 C 24.355469 37 27.460938 36.015625 30.09375 34.34375 L 42.375 46.625 L 46.625 42.375 L 34.5 30.28125 C 36.679688 27.421875 38 23.878906 38 20 C 38 10.601563 30.398438 3 21 3 Z M 21 7 C 28.199219 7 34 12.800781 34 20 C 34 27.199219 28.199219 33 21 33 C 13.800781 33 8 27.199219 8 20 C 8 12.800781 13.800781 7 21 7 Z"></path>
</svg></span>
            <input id="searchInput" placeholder="Search by guest name, email, or room number..." />
        </div>
    </div>

    <div class="spacer"></div>
    <%
        String currentSub = (String) request.getAttribute("SUB_TAB");
    %>
    <div>

        <form class="tabs" style="border-radius:12px" action="GetPendingCheckinController" method="get">
            <%
                if (currentSub == null)
                    currentSub = "in";
            %>

            <button type="submit" name="tab" value="in"
                    class="tab <%= "in".equals(currentSub) ? "active" : ""%>">Check-in</button>

            <button type="submit" name="tab" value="out"
                    class="tab <%= "out".equals(currentSub) ? "active" : ""%>">Check-out</button>
        </form>
    </div>

    <div class="spacer"></div>

    <div class="card" style="padding:16px">
        <%
            if (currentSub.equalsIgnoreCase("in")) {
        %>
        <jsp:include page="../components/checkinPending.jsp" />
        <%
        } else {
        %>
        <jsp:include page="../components/checkoutPending.jsp" />
        <%
            }
        %>
    </div>
</section>
