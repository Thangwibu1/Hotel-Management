<%-- 
    Document   : completeMaintain
    Created on : Oct 18, 2025, 11:54:56 PM
    Author     : TranHongGam
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report For Maintain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html {
            font-size: 62.5%;
            font-family: sans-serif;
        }
        .container {
            max-width: 1320px;
            margin: 0 auto;
        }
        body {
            background-color: #f5f5f5;
            font-family: Arial, sans-serif;
            font-size: 1.6rem;
        }
        .modal-content {
            border-radius: 8px;
        }
        .alert-warning {
            background-color: #fef3cd;
            font-size: medium;
            border-color: #fef3cd;
            color: #856404;
        }
        .warning-icon {
            color: #dc3545;
            font-size: 24px;
            font-weight: bold;
        }
        .checkbox-list {
            max-height: 70vh;
            overflow-y: auto;
            overflow-x: hidden;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 10px;
            background-color: white;
        }
        .form-check {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            margin: 0;
            display: flex;
            align-items: center;
            position: relative;
        }
        .form-check:last-child {
            border-bottom: none;
        }
        .form-check-input {
            width: 22px;
            height: 22px;
            margin: 0;
            /* ?i?u ch?nh c?n lùi */
            margin-left: 5px; 
            margin-right: 17px; 
            cursor: pointer;
            flex-shrink: 0;
            position: relative;
        }
        .form-check-label {
            font-size: 16px;
            cursor: pointer;
            margin: 0;
            user-select: none;
            flex: 1;
        }
        .modal-header {
            border-bottom: 1px solid #dee2e6;
        }
        .btn-close {
            font-size: 20px;
        }
        
        /* ?Ã XOÁ: .btn-complete, .btn-complete:hover vì ?ã thay b?ng .btn-maintenance */
        /* ?Ã XOÁ: .btn-close-left và .modal-title-group (các class này không còn trong HTML) */

        /* CSS ?ANG DÙNG: Nút Completed Maintenance */
        .btn-maintenance {
            background-color: #495057; /* Màu xám ?en */
            color: white;
            padding: 12px 30px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            font-weight: 500;
            margin-right: 10px;
        }
        .btn-maintenance:hover {
            background-color: #343a40; /* Màu xám ?en ??m h?n khi hover */
            color: white;
            box-shadow: 0 0 8px 2px rgba(108, 117, 125, 0.5);
        }
        .modal-footer {
            border-top: 1px solid #dee2e6;
            padding: 15px 20px;           
        }
        
        .form-check-input:not(:checked) {
            border-color: #6c757d; 
        }

        .form-check-input:checked {
            background-color: #343a40; 
            border-color: #343a40;
        }

        .form-check-input:checked[type=checkbox] {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='M6 10l3 3l6-6'/%3e%3c/svg%3e");
            filter: none;
        }

        .form-check-input:focus {
            border-color: #6c757d;
            box-shadow: 0 0 0 0.25rem rgba(108, 117, 125, 0.25);
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>

<div class="container mt-5">
    <div class="modal-dialog modal-dialog-centered modal-lg ">
        <div class="modal-content " >
            <div class="modal-header mb-5 " >
                <h3 class="modal-title ms-4">
                    <span class="warning-icon">?</span>
                    Malfunction Report - Room 101
                </h3>
                <button type="button" class="btn-close" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning" role="alert">
                    <strong class="ms-1">Reporting damage in Room 101</strong><br>
                    <small class="ms-1">The room will be placed under maintenance after confirmation.</small>
                </div>

                
                
                <div class="checkbox-list d-flex justify-content-center  ">
                    <form action="your-servlet-url" method="post" style="width: 55% ; padding-bottom: 4rem;">
                        <div class="card shadow-sm " style="max-width: 70rem;">
                            <div >
                                <h3 class=" p-4 text-center bg-light bg-gradient shadow rounded-3"
                                    style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 50%, #f8f9fa 100%); 
                                            color: #495057;
                                            letter-spacing: 0.5px; 
                                            font-weight: 700;
                                            border: 1px solid #b2b5b9;">
                                    Select Failure Category
                                </h3>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="airConditioner" name="damagedItems" value="air_conditioner">
                                            <label class="form-check-label" for="airConditioner">Air Conditioner</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="sink" name="damagedItems" value="sink">
                                            <label class="form-check-label" for="sink">Sink / Washbasin</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="television" name="damagedItems" value="television">
                                            <label class="form-check-label" for="television">Television</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="bed" name="damagedItems" value="bed">
                                            <label class="form-check-label" for="bed">Bed</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="bathroom" name="damagedItems" value="bathroom">
                                            <label class="form-check-label" for="bathroom">Bathroom</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="toilet" name="damagedItems" value="toilet" checked>
                                            <label class="form-check-label" for="toilet">Toilet</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="light" name="damagedItems" value="light">
                                            <label class="form-check-label" for="light">Light</label>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="window" name="damagedItems" value="window">
                                            <label class="form-check-label" for="window">Window</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-footer text-end" style="width: 100%; ">
                                <button style="width: 100%; " type="submit" class="btn btn-maintenance">Completed Maintenance</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
        </div>
    </div>
</div>
<jsp:include page="footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>