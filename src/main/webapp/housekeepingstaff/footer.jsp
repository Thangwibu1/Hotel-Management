<%-- 
    Document  : footer
    Created on : Oct 5, 2025, 11:32:30 AM
    Author     : TranHongGam
--%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Staff staff = (Staff) session.getAttribute("userStaff");
%>
<div class="footer-info bg-light border-top mt-auto py-3 container-fluid">
    <%-- container-fluid để nền kéo dài hết chiều rộng --%>
    <div class="footer-content-wrapper mx-auto" style="max-width: 1200px;"> 
        <%-- ĐÃ THAY BẰNG DIV MỚI ĐỂ CĂN GIỮA NỘI DUNG --%>
        <div class="row g-4">
            <div class="col-12 col-md-4">
                <h6 class="fw-bold text-dark mb-3">Luxury Hotel</h6>
                <p class="mb-2 text-muted">
                    <strong class="text-dark">Address:</strong> 123 Nguyen Hue Street, District 1, Ho Chi Minh City
                </p>
                <p class="mb-2 text-muted">
                    <strong class="text-dark">Email:</strong> info@luxuryhotel.com
                </p>
                <p class="mb-2 text-muted">
                    <strong class="text-dark">Phone:</strong> (84) 28 1234 5678
                </p>
                <p class="text-muted small mb-0 mt-3">
                    © 2025 Luxury Hotel. All rights reserved.
                </p>
            </div>
            <div class="col-12 col-md-4">
                <h6 class="fw-bold text-dark mb-3">Quick Links</h6>
                <ul class="list-unstyled text-muted">
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">About Us</a></li>
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Rooms & Services</a></li>
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Special Offers</a></li>
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Careers</a></li>
                </ul>
            </div>
            <div class="col-12 col-md-4">
                <h6 class="fw-bold text-dark mb-3"> Support & Contact</h6>
                <p class="mb-2 text-muted">
                    Hotline: <strong class="text-dark">1800-1234</strong>
                </p>
                <p class="mb-2 text-muted">
                    support@hotel.com
                </p>
                <p class="mb-0 text-muted">
                    IT Department: <strong class="text-dark">Ext. 2345</strong>
                </p>
            </div>
        </div>
    </div> <%-- Đóng thẻ footer-content-wrapper --%>
</div>