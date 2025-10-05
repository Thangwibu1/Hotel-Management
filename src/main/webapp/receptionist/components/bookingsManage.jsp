<%-- 
    Document   : bookingsManage
    Created on : Oct 5, 2025, 11:53:14 AM
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
        <!-- BOOKINGS -->
        <section id="bookings" class="screen">
            <div class="card" style="padding:16px">
                <div style="display:flex;justify-content:space-between;align-items:center;gap:12px">
                    <h2 class="panel-title">Booking Management</h2>
                    <button class="btn primary">New Booking</button>
                </div>
                <div class="spacer"></div>
                <table>
                    <thead>
                        <tr>
                            <th>Guest</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div>John Smith</div>
                                <div class="muted" style="font-size:14px">john.smith@email.com</div>
                            </td>
                            <td>
                                <div>Room 102</div>
                                <div class="muted" style="font-size:14px">Standard Double</div>
                            </td>
                            <td>1/15/2024</td>
                            <td>1/18/2024</td>
                            <td><span class="badge gray">confirmed</span></td>
                            <td>$387</td>
                            <td>
                                <div class="actions">
                                    <button class="btn icon" title="Edit">??</button>
                                    <button class="btn icon" title="View">?</button>
                                    <button class="btn icon" title="Delete">??</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>Sarah Johnson</div>
                                <div class="muted" style="font-size:14px">sarah.j@email.com</div>
                            </td>
                            <td>
                                <div>Room 204</div>
                                <div class="muted" style="font-size:14px">Deluxe Double</div>
                            </td>
                            <td>1/14/2024</td>
                            <td>1/16/2024</td>
                            <td><span class="badge green">checked-in</span></td>
                            <td>$378</td>
                            <td class="muted">No actions available</td>
                        </tr>
                        <tr>
                            <td>
                                <div>Michael Brown</div>
                                <div class="muted" style="font-size:14px">mike.brown@email.com</div>
                            </td>
                            <td>
                                <div>Room 101</div>
                                <div class="muted" style="font-size:14px">Standard Single</div>
                            </td>
                            <td>1/10/2024</td>
                            <td>1/13/2024</td>
                            <td><span class="badge">checked-out</span></td>
                            <td>$267</td>
                            <td class="muted">No actions available</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </body>
</html>
