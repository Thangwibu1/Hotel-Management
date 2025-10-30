<%-- 
    Document   : homeService
    Created on : Oct 16, 2025, 8:56:17 AM
    Author     : TranHongGam
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>??t l?ch d?ch v? - Hotel Service Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        /* Header Styles */
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 16px 24px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 18px;
        }

        .user-info h3 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.8;
            margin: 0;
        }

        .header-right {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .time-badge,
        .date-badge {
            background: rgba(255, 255, 255, 0.1);
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
        }

        .btn-publish {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: transform 0.2s;
        }

        .btn-publish:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.4);
        }

        /* Container Styles */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
        }

        /* Search Box Styles */
        .search-box {
            background: white;
            padding: 12px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .search-box input {
            width: 100%;
            border: none;
            outline: none;
            font-size: 14px;
            color: #333;
        }

        /* Tabs Styles */
        .tabs {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
            background: white;
            padding: 8px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .tab {
            flex: 1;
            padding: 12px 24px;
            border: none;
            background: transparent;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            border-radius: 8px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        /* Card Styles */
        .card {
            background: white;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 24px;
            border: none;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-left: 8px;
            border-left: 4px solid #667eea;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            display: block;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
            background: #fafafa;
            width: 100%;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .btn-add-service {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.2s;
        }

        .btn-add-service:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(44, 62, 80, 0.3);
        }

        /* Services List Styles */
        .services-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .service-item {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 16px 20px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
        }

        .service-item:hover {
            transform: translateX(4px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .service-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-right: 16px;
            flex-shrink: 0;
        }

        .service-content {
            flex: 1;
        }

        .service-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 4px;
        }

        .service-details {
            font-size: 12px;
            color: #7f8c8d;
        }

        .service-status {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .service-time {
            font-size: 13px;
            color: #95a5a6;
            margin-left: 12px;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-waiting {
            background: #fff3cd;
            color: #856404;
        }

        .status-processing {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }

        /* Footer Styles */
        .footer {
            background: white;
            padding: 32px 0;
            margin-top: 40px;
            border-top: 1px solid #e9ecef;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .footer-section h4 {
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 16px;
        }

        .footer-section p,
        .footer-section ul {
            font-size: 13px;
            color: #7f8c8d;
            line-height: 1.8;
        }

        .footer-section ul {
            list-style: none;
            padding-left: 0;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 12px;
            }

            .service-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .tabs {
                flex-direction: column;
            }

            .service-time {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="headerService.jsp"/>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Search Box -->
        <div class="search-box">
            <input type="text" placeholder="? Tìm ki?m khách hàng, phòng ho?c d?ch v?...">
        </div>

        <!-- Tabs -->
        <div class="tabs">
            <button class="tab active">+ Ghi nh?n d?ch v?</button>
            <button class="tab ">? C?p nh?t tr?ng thái</button>
            <button class="tab">? Báo cáo</button>
        </div>

        <!-- Form Card -->
        <div class="card">
            <div class="section-title">+ Ghi nh?n vi?c s? d?ng d?ch v? (Workshop 1)</div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Tên khách hàng *</label>
                        <input type="text" placeholder="Nh?p tên khách hàng">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>S? phòng *</label>
                        <input type="text" placeholder="Ví d?: 101, 205A">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Lo?i d?ch v? *</label>
                        <select>
                            <option>Ch?n lo?i d?ch v?</option>
                            <option>Massage</option>
                            <option>B?a sáng</option>
                            <option>Gi?t ?i</option>
                            <option>??a r??c</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Tên d?ch v? c? th? *</label>
                        <input type="text" placeholder="Ví d?: Massage th? giãn, B?a sáng set">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label>S? l??ng</label>
                        <input type="number" value="1" min="1">
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Ghi chú thêm</label>
                <textarea placeholder="Yêu c?u ??c bi?t, thói quen mong mu?n..."></textarea>
            </div>

            <button class="btn-add-service">+ Ghi nh?n d?ch v?</button>
        </div>

        <!-- Services List Card -->
        <div class="card">
            <div class="section-title">D?ch v? ?ã ghi nh?n g?n ?ây</div>
            
            <div class="services-list">
                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">B?a sáng buffet</div>
                        <div class="service-details">Nguy?n V?n A • Phòng 101</div>
                    </div>
                    <span class="service-status status-completed">
                        <span class="status-dot"></span>
                        Hoàn thành
                    </span>
                    <span class="service-time">08:30</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #fab1a0 0%, #ff7675 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Massage toàn thân</div>
                        <div class="service-details">Tr?n Th? B • Phòng 205</div>
                    </div>
                    <span class="service-status status-waiting">
                        <span class="status-dot"></span>
                        Ch? x? lý
                    </span>
                    <span class="service-time">09:15</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">Gi?t ?i qu?n áo</div>
                        <div class="service-details">Lê V?n C • Phòng 312</div>
                    </div>
                    <span class="service-status status-processing">
                        <span class="status-dot"></span>
                        ?ang th?c hi?n
                    </span>
                    <span class="service-time">10:00</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #55efc4 0%, #00b894 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">D?ch v? ??c bi?t</div>
                        <div class="service-details">Ph?m Th? D • Phòng 108</div>
                    </div>
                    <span class="service-status status-completed">
                        <span class="status-dot"></span>
                        Hoàn thành
                    </span>
                    <span class="service-time">11:20</span>
                </div>

                <div class="service-item">
                    <div class="service-icon" style="background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);">?</div>
                    <div class="service-content">
                        <div class="service-name">??a ra sân bay</div>
                        <div class="service-details">Hoàng V?n E • Phòng 407</div>
                    </div>
                    <span class="service-status status-waiting">
                        <span class="status-dot"></span>
                        Ch? x? lý
                    </span>
                    <span class="service-time">14:30</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <div class="footer-content">
            <div class="row">
                <div class="col-md-4 footer-section">
                    <h4>H? th?ng qu?n lý d?ch v? khách s?n</h4>
                    <p>T?i ?u hóa quy trình làm vi?c v?i giao di?n thân thi?n và hi?u qu?.</p>
                </div>
                <div class="col-md-4 footer-section">
                    <h4>H? tr? k? thu?t</h4>
                    <ul>
                        <li>? Hotline: 1900-xxxx</li>
                        <li>? Email: support@hotel.com</li>
                        <li>? H? tr? 24/7</li>
                    </ul>
                </div>
                <div class="col-md-4 footer-section">
                    <h4>Thông tin phiên b?n</h4>
                    <ul>
                        <li>Version 3.0.0 - Workshop Edition</li>
                        <li>C?p nh?t: 12/10/2025</li>
                        <li>© 2024 Hotel Service Management</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
</body>
</html>