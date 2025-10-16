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
            <span>?</span>
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
