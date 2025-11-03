package controller;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.PaymentDAO;
import model.Payment;

@WebServlet("/processPayment")
public class ProcessPaymentController extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy thông tin từ form
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Kiểm tra phương thức thanh toán có hợp lệ không
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = "Cash"; // Mặc định là tiền mặt nếu không chọn
            }
            
            // Tạo payment mới
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setPaymentDate(LocalDate.now());
            payment.setAmount(amount);
            payment.setPaymentMethod(paymentMethod);
            payment.setStatus("Completed");
            
            // Thêm payment vào database
            boolean success = paymentDAO.addPayment(payment);
            
            if (success) {
                // Thanh toán thành công, redirect về trang paymentRemain để xem cập nhật
                response.sendRedirect("paymentRemain?bookingId=" + bookingId + "&success=true");
            } else {

                //fail 
                // Thanh toán thất bại
                response.sendRedirect("paymentRemain?bookingId=" + bookingId + "&error=true");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to POST
        doPost(request, response);
    }
}

