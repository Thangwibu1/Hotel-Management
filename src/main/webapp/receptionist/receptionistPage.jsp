<%-- 
    Document   : receptionistPage.jsp
    Created on : Oct 5, 2025, 9:03:44 AM
    Author     : trinhdtu
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.Guest"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Grand Hotel • Receptionist Management</title>

        <!-- ====== CSS (inline) ====== -->
        <link rel="stylesheet" href="../receptionist/style.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <jsp:include page="../receptionist/components/header.jsp" />

            <!-- Tabs -->
            <nav class="tabs" role="tablist">
                <button class="tab active" data-target="dashboard"><span class="icon">🗂️</span>Dashboard</button>
                <button class="tab" data-target="bookings"><span class="icon">📅</span>Bookings</button>
                <button class="tab" data-target="checkin"><span class="icon">➡️</span>Check-in/Out</button>
                <button class="tab" data-target="rooms"><span class="icon">🛏️</span>Room Status</button>
            </nav>

            <jsp:include page="../receptionist/components/dashboard.jsp"/>

            <jsp:include page="../receptionist/components/bookingsManage.jsp"/>

            <jsp:include page="../receptionist/components/checkManage.jsp"/>
            <jsp:include page="../receptionist/components/roomStatus.jsp" />
        </div>

        <!-- ====== JavaScript (inline) ====== -->
        <<script src="../receptionist/style.js"></script>
    </body>
</html>
