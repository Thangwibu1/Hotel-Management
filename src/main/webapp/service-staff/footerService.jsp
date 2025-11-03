<%@page import="java.time.LocalDate"%>
<%@page import="utils.IConstant"%>
<div class="footer bg-white border-top mt-5 pt-4 pb-3">
    <div class="container">
        <div class="row justify-content-between g-4">

            <div class="footer-section col-12 col-md-4 text-start">
                <h4 class="fs-6 mb-3 text-dark border-bottom pb-1">Hotel Service Management System</h4>
                <p class="text-muted small">Optimize workflows with a user-friendly and efficient interface.</p>
                <p class="text-muted small mb-0 mt-3">&copy; 2025 Hotel Service Management</p>
            </div>

            <div class="footer-section col-12 col-md-4 text-start border-start border-end px-md-4">
                <h4 class="fs-6  mb-3 text-dark border-bottom pb-1">Technical Support</h4>
                <ul class="list-unstyled small mb-0">
                    <li>Hotline: 1900-0000</li>
                    <li>Email: support@hotel.com</li>
                    <li>24/7 Support</li>
                </ul>
            </div>

            <div class="footer-section col-12 col-md-4 text-start">
                <h4 class="fs-6  mb-3 text-dark border-bottom pb-1">Version Information</h4>
                <ul class="list-unstyled small mb-0">
                    <li>Version 3.0.0 - Workshop Edition</li>
                    <li>Start at: <%= IConstant.formatDate(LocalDate.now()) %></li>
                </ul>
            </div>

        </div>
    </div>
</div>
