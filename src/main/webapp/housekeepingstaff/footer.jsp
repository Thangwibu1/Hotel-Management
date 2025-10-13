<%-- 
    Document  : footer
    Created on : Oct 5, 2025, 11:32:30 AM
    Author     : TranHongGam
--%>

<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%-- ĐÃ SỬA THÀNH UTF-8 --%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
        <%-- ĐÃ SỬA THÀNH UTF-8 --%>
        <title>JSP Page</title>
        <link rel="stylesheet" href="./stylehomeHouseKeeping.css"/>
    </head>
    <body>
        <%
            Staff staff = (Staff)session.getAttribute("userStaff");
        %>
        <div class="footer-info">
            <div class="info-section">
                <h3> Thống kê ca làm việc</h3>
                <div class="info-item">
                    <span class="info-label">Tổng phòng:</span>
                    <span class="info-value">8</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Đã hoàn thành:</span>
                    <span class="info-value">2</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Còn lại:</span>
                    <span class="info-value">5</span>
                </div>
            </div>
            
            <div class="info-section">
                <h3> Thông tin hệ thống</h3>
                <div class="info-item">
                    <span class="info-label">Hệ thống quản lý phòng v2.1</span>
                </div>
                <div class="info-item">
                    <span class="info-label">The current staff : <%= staff.getFullName() %></span>
                </div>
            </div>
            
            <div class="info-section">
                <h3>📞 Hỗ trợ & Liên hệ</h3>
                <div class="info-item">
                    <span class="info-label">📞 Hotline: 1800-1234</span>
                </div>
                <div class="info-item">
                    <span class="info-label">✉️ support@hotel.com</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Bộ phận IT: Ext. 2345</span>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <div>© 2024 Hệ thống quản lý phòng khách sạn. Phiên bản 2.1.0</div>
            <div>Cập nhật cuối: 15:56:35 🔄</div>
        </div>
    </body>
</html>