<%-- 
    Document   : roomStatus
    Created on : Oct 5, 2025, 11:57:08 AM
    Author     : trinhdtu
--%>

<%@page import="model.RoomType"%>
<%@page import="model.Room"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- ROOMS -->
        <section id="rooms" class="screen">
            <div class="kpi-strip">
                <div class="card kpi"><div class="muted">Available</div><div class="big"><%= request.getAttribute("COUNTAVLB")%></div></div>
                <div class="card kpi"><div class="muted">Occupied</div><div class="big"><%= request.getAttribute("COUNTOCC")%></div></div>
                <div class="card kpi"><div class="muted">Cleaning</div><div class="big">1</div></div>
                <div class="card kpi"><div class="muted">Maintenance</div><div class="big">1</div></div>
            </div>

            <div class="card" style="padding:16px">
                <h3 style="margin-top:0">Room Overview</h3>
                <div class="room-grid">
                    <%
                        ArrayList<Room> s = (ArrayList<Room>) request.getAttribute("ROOM_LIST");
                        ArrayList<RoomType> t = (ArrayList<RoomType>) request.getAttribute("TYPES_LIST");
                        for (Room room : s) {
                    %>
                    <div class="card room">
                        <h3>Room <%= room.getRoomNumber()%></h3>
                        <%
                            for (RoomType rt : t) {
                                if (room.getRoomTypeId() == rt.getRoomTypeId()) {
                        %>
                        <small><%= rt.getTypeName()%></small><br/>
                        <small>$<%= rt.getPricePerNight()%>/night</small>
                        <div class="status"><span class="badge green"><%= room.getStatus()%></span></div>
                    </div>
                    <%
                                }
                            }
                        }
                    %>
                </div>
            </div>
        </section>
    </body>
</html>
