<%-- 
    Document   : viewBookingServiceCardPage
    Created on : Nov 1, 2025, 10:31:16 PM
    Author     : TranHongGam
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Booking Service Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./style.css"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: #f0f2f5;
                min-height: 100vh;
            }
            
            /* Main Content */
            .main-content {
                max-width: 1000px;
                margin: 0px auto;
                padding: 0 10px;
            }

            /* Detail Card */
            .detail-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                overflow: hidden;
                animation: fadeIn 0.4s ease;
            }

          

            /* Card Header */
            .card-header-custom {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-header-custom h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
            }

            .close-btn {
                background: rgba(255, 255, 255, 0.2);
                border: none;
                color: white;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                cursor: pointer;
                font-size: 20px;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .close-btn:hover {
                background: rgba(255, 255, 255, 0.3);
                transform: rotate(90deg);
            }

            /* Card Body */
            .card-body-custom {
                padding: 30px;
            }

            /* Section Groups */
            .section-group {
                background: #f3f1f8;
                padding: 25px;
                border-radius: 12px;
                margin-bottom: 20px;
                border-left: 4px solid #764ba2;
            }

            .section-title {
                font-size: 15px;
                color: #764ba2;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #d8d4e4;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 14px 0;
                border-bottom: 1px solid #e8e5f0;
            }

            .info-row:last-child {
                border-bottom: none;
                padding-bottom: 0;
            }

            .info-label {
                font-size: 13px;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-weight: 600;
            }

            .info-value {
                font-size: 15px;
                color: #2c3e50;
                font-weight: 600;
                text-align: right;
            }

            /* Status Badge */
            .status-badge {
                display: inline-block;
                padding: 6px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-0 {
                background: #f39c12;
                color: white;
            }

            .status-1 {
                background: #3498db;
                color: white;
            }

            .status-2 {
                background: #2ecc71;
                color: white;
            }

            .status-3 {
                background: #e74c3c;
                color: white;
            }

            /* Note Content */
            .note-content {
                color: #555;
                line-height: 1.7;
                font-size: 14px;
                padding: 15px;
                background: white;
                border-radius: 8px;
            }

          

        </style>
    </head>
    <body>
        <jsp:include page="headerService.jsp"/>
        
        <!--//main-->
        <div class="main-content">
            <div class="detail-card">
                <!-- Card Header -->
                <div class="card-header-custom">
                    <h2>Booking Service Details</h2>
                    <button class="close-btn" onclick="closeModal()">×</button>
                </div>

                <!-- Card Body -->
                <div class="card-body-custom">
                    <!-- Booking Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Booking Information</h3>
                        <div class="info-row">
                            <div class="info-label">Booking Service ID</div>
                            <div class="info-value">#BS-10245</div>
                        </div>
                        
                        <div class="info-row">
                            <div class="info-label">Service Date</div>
                            <div class="info-value">01/11/2025</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status</div>
                            <div class="info-value">
                                <span class="status-badge status-0">Pending</span>
                            </div>
                        </div>
                    </div>

                    <!-- Guest Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Guest Information</h3>
                        <div class="info-row">
                            <div class="info-label">Room Number</div>
                            <div class="info-value">Room 101</div>
                        </div>
                    </div>

                    <!-- Service Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Service Information</h3>
                        
                        <div class="info-row">
                            <div class="info-label">Service Name</div>
                            <div class="info-value">Set Menu Lunch</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Quantity</div>
                            <div class="info-value">2 Portions</div>
                        </div>
                    </div>

                    <!-- Staff Information Section -->
                    <div class="section-group">
                        <h3 class="section-title">Staff Information</h3>
                        <div class="info-row">
                            <div class="info-label">Staff ID</div>
                            <div class="info-value">#ST-7892</div>
                        </div>
                    </div>

                    <!-- Note Section -->
                    <div class="section-group">
                        <h3 class="section-title">Notes</h3>
                        <div class="note-content">
                            Customer requested service exactly at 12:00 PM. No onions and garlic. Service to be delivered to the room with full cutlery. Need extra water and wet towels.
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footerService.jsp"/>
        <script>
        function closeModal() {
            window.history.back();
        }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
