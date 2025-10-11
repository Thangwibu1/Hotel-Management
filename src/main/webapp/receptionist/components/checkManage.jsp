<%-- 
    Document   : checkManage
    Created on : Oct 5, 2025, 11:54:32 AM
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
        <!-- CHECK-IN / OUT -->
        <section id="checkin" class="screen">
            <div class="card" style="padding:16px">
                <div class="search">
                    <span>?</span>
                    <input id="searchInput" placeholder="Search by guest name, email, or room number..." />
                </div>
            </div>

            <div class="spacer"></div>

            <div class="tabs" style="border-radius:12px">
                <button class="tab active" data-subtab="in">? Check-in (1)</button>
                <button class="tab" data-subtab="out">? Check-out (1)</button>
            </div>

            <div class="spacer"></div>

            <div class="card" style="padding:16px">
                <h3 style="margin-top:0">Pending Check-ins</h3>
                <table id="tblCheckins">
                    <thead><tr><th>Guest</th><th>Room</th><th>Check-in Date</th><th>Guests</th><th>Action</th></tr></thead>
                    <tbody>
                        <tr>
                            <td>
                                <div>John Smith</div>
                                <div class="muted" style="font-size:14px">john.smith@email.com</div>
                                <div class="muted" style="font-size:14px">+1 (555) 123-4567</div>
                            </td>
                            <td>
                                <div>Room 102</div>
                                <div class="muted" style="font-size:14px">Standard Double</div>
                            </td>
                            <td>1/15/2024</td>
                            <td>2</td>
                            <td><button class="btn primary">Check In</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </body>
</html>
