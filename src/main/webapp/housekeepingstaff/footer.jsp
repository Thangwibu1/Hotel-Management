<%-- 
    Document  : footer
    Created on : Oct 5, 2025, 11:32:30 AM
    Author     : TranHongGam
--%>

<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- ĐÃ SỬA THÀNH UTF-8 --%>



<%
    Staff staff = (Staff) session.getAttribute("userStaff");
%>
<div class="footer-info bg-light border-top  pt-2 pb-3">
    <div class="container">
        <div class="row justify-content-between g-4">
            
            <div class="info-section col-12 col-md-4 text-start">
                <h3 class="fs-5 fw-bold mb-3 text-secondary border-bottom pb-1">Thống kê ca làm việc</h3>
                
                <div class="info-item d-flex justify-content-between mb-1">
                    <span class="info-label text-muted me-3">Tổng phòng:</span>
                    <span class="info-value fw-bold text-dark">8</span>
                </div>
                
                <div class="info-item d-flex justify-content-between mb-1">
                    <span class="info-label text-muted me-3">Đã hoàn thành:</span>
                    <span class="info-value fw-bold text-success">2</span>
                </div>
                
                <div class="info-item d-flex justify-content-between mb-1">
                    <span class="info-label text-muted me-3">Còn lại:</span>
                    <span class="info-value fw-bold text-warning">5</span>
                </div>
            </div>
            
            <div class="info-section col-12 col-md-4 text-start border-start border-end px-md-4">
                <h3 class="fs-5 fw-bold mb-3 text-secondary border-bottom pb-1">Thông tin hệ thống</h3>
                
                <div class="info-item mb-1">
                    <span class="info-label text-muted">Hệ thống quản lý phòng <strong class="text-dark">v2.1</strong></span>
                </div>
                
                <div class="info-item mb-1">
                    <span class="info-label text-muted">Nhân viên hiện tại: <strong class="text-success"><%= staff.getFullName()%></strong></span>
                </div>
                <div class="info-item mb-1 text-muted small mt-3">
                    © 2025 Hotel Management System
                </div>
            </div>

            <div class="info-section col-12 col-md-4 text-start">
                <h3 class="fs-5 fw-bold mb-3 text-secondary border-bottom pb-1">📞 Hỗ trợ & Liên hệ</h3>
                
                <div class="info-item mb-1">
                    <span class="info-label text-muted">📞 Hotline: <strong class="text-dark">1800-1234</strong></span>
                </div>
                
                <div class="info-item mb-1">
                    <span class="info-label text-muted">✉️ support@hotel.com</span>
                </div>
                
                <div class="info-item mb-1">
                    <span class="info-label text-muted">Bộ phận IT: <strong class="text-dark">Ext. 2345</strong></span>
                </div>
            </div>
            
        </div>
    </div>
</div>