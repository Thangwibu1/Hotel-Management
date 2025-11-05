<%-- 
    Document   : detailProfileStaff
    Created on : Oct 20, 2025, 3:38:43 PM
    Author     : TranHongGam
--%>

<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Detail Your Profile</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
            crossorigin="anonymous"
            />
        <link rel="stylesheet" href="./../housekeepingstaff/stylehomeHouseKepping.css"/>
        <style>
            .btn-outline-secondary {
                transition: color 0.3s ease-in-out, background-color 0.3s ease-in-out, border-color 0.3s ease-in-out;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <%
            Staff staff = (Staff) session.getAttribute("userStaff");

        %>
        <div class="container main-content">
            <main class="container-fluid py-4">
                <div class="card shadow-sm mb-4">
                    <div class="card-body" style="display: flex; justify-content: space-between;">
                        <div class="row align-items-center ps-5">
                            <div class="col-2 col-md-auto text-center text-md-start mb-3 mb-md-0 ">
                                <div class="rounded-circle overflow-hidden d-inline-block" style="width: 60px; height: 60px;">
                                    <img src="https://png.pngtree.com/background/20210714/original/pngtree-luxury-background-with-sparkling-elements-vector-image-picture-image_1238565.jpg" 
                                         alt="Hình n?n l?p lánh" 
                                         class="img-fluid" 
                                         style="width: 100%; height: 100%; object-fit: cover;">
                                </div>
                            </div>
                            <div class="col-10 col-md text-center text-md-start ">
                                <h4 class="mb-1">Mai Anh</h4>
                                <p class="text-muted mb-0">Housekeeping Staff - Morning Shift</p>
                            </div>
                        </div>
                        <div class="row mb-3 pe-5" >
                            <div class="col-12">
                                <button class="btn btn-outline-secondary me-3 ">
                                    <span class="d-none d-md-inline">Back home </span><i class="bi bi-arrow-right me-2"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="card-title mb-3">
                            <i class="fas fa-calendar-alt text-primary me-2"></i>
                            Select Report Time Period
                        </h5>
                        <div class="row g-3">
                            <div class="col-12 col-md-5"  style="padding: 5px;">
                                <label class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="startDate">
                            </div>
                            <div class="col-12 col-md-5" style="padding: 5px;">
                                <label class="form-label">End Date</label>
                                <input type="date" class="form-control" id="endDate">
                            </div>
                            <div class="col-12 col-md-2 d-flex align-items-end">
                                <button class="btn btn-primary w-100">
                                    <i class="fas fa-search me-2"></i>View
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-list-check text-info me-2"></i>
                            Work Report
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive ">
                            <table class="table table-hover table-striped mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Rooms Cleaned</th>
                                        <th class="d-none d-md-table-cell">Working Shift</th>
                                        <th class="d-none d-lg-table-cell">Avg. Time</th>
                                        <th class="d-none d-lg-table-cell">Note</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>05/11/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">11 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">25 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-success">Excellent completion</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>04/11/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">9 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">27 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-warning">1 room incomplete</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>03/11/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">10 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">26 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-success">Good completion</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>02/11/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">12 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">24 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-success">Fastest this week</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>01/11/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">8 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">28 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-info">Normal</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>31/10/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">11 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">25 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-success">Good completion</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>30/10/2025</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">10 rooms</span>
                                        </td>
                                        <td class="d-none d-md-table-cell">Morning Shift</td>
                                        <td class="d-none d-lg-table-cell">26 minutes/room</td>
                                        <td class="d-none d-lg-table-cell">
                                            <span class="badge bg-success">Good completion</span>
                                        </td>
                                    </tr>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td><strong>Total</strong></td>
                                        <td><strong class="text-primary">71 rooms</strong></td>
                                        <td class="d-none d-md-table-cell" colspan="3">
                                            <strong>Avg. Time: 26 minutes/room</strong>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="footer.jsp"/>
    </body>
</html>
