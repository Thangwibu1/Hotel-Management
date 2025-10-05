<%-- 
    Document   : dashboard
    Created on : Oct 5, 2025, 11:49:37 AM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- DASHBOARD -->
        <section id="dashboard" class="screen active">
            <div class="welcome">
                <h2 class="panel-title">Welcome back!</h2>
                <div class="muted">Here's what's happening at your hotel today.</div>
            </div>

            <div class="grid grid-4">
                <div class="card stat">
                    <h4>Today's Check-ins </h4>
                    <div class="value"><%= request.getAttribute("COUNTIN")%></div>
                    <div class="muted">Guests arriving today</div>
                </div>
                <div class="card stat">
                    <h4>Today's Check-outs</h4>
                    <div class="value"><%= request.getAttribute("COUNTOUT")%></div>
                    <div class="muted">Guests departing today</div>
                </div>
                <div class="card stat">
                    <h4>Occupancy Rate </h4>
                    <div class="value"><%= request.getAttribute("RATE") %></div>
                    <div class="muted"><%= request.getAttribute("COUNTOCC") %> of <%= request.getAttribute("COUNTROOM") %> rooms occupied</div>
                </div>
                <div class="card stat">
                    <h4>Available Rooms </h4>
                    <div class="value"><%= request.getAttribute("COUNTAVLB")%></div>
                    <div class="muted">Ready for new guests</div>
                </div>
            </div>

            <div class="spacer"></div>

            <div class="grid grid-2">
                <div class="card stat">
                    <h4>Revenue This Month <span>?</span></h4>
                    <div class="value">$267</div>
                    <div class="muted">From completed stays</div>
                    <div class="chartish"></div>
                </div>
                <div class="card stat">
                    <h4>Pending Revenue <span>?</span></h4>
                    <div class="value">$378</div>
                    <div class="muted">From current guests</div>
                    <div class="chartish"></div>
                </div>
            </div>

            <div class="spacer"></div>

            <div class="card" style="padding:16px">
                <h3 style="margin:8px 0 16px">Recent Activity</h3>
                <table>
                    <thead><tr><th>Activity</th><th style="width:120px;text-align:right">Amount</th></tr></thead>
                    <tbody>
                        <tr><td>Booking #1 – Status: confirmed</td><td style="text-align:right">$387</td></tr>
                        <tr><td>Sarah Johnson – Checked in</td><td style="text-align:right">$378</td></tr>
                        <tr><td>Michael Brown – Checked out</td><td style="text-align:right">$267</td></tr>
                    </tbody>
                </table>
            </div>
        </section>
    </body>
</html>
