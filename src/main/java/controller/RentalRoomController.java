package controller;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import model.Room;
import model.RoomType;
import model.Service;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "RentalRoomController", urlPatterns = {"/rentalRoom"})
public class RentalRoomController extends HttpServlet {
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy các tham số cũ từ form
            String roomId = req.getParameter("roomId");
            String roomTypeId = req.getParameter("roomTypeId");

            // === THÊM MỚI: Lấy 2 tham số ngày tháng từ các input ẩn ===
            String checkInDate = req.getParameter("checkInDate");
            String checkOutDate = req.getParameter("checkOutDate");

            // Lấy thông tin từ DAO như cũ
            Room room = roomDAO.getRoomById(Integer.parseInt(roomId));
            RoomType roomType = roomTypeDAO.getRoomTypeById(Integer.parseInt(roomTypeId));
            ArrayList<Service> services = serviceDAO.getAllService();

            if (room != null && roomType != null) {
                // Set các attribute cũ
                req.setAttribute("room", room);
                req.setAttribute("roomType", roomType);
                req.setAttribute("services", services);

                // === THÊM MỚI: Gửi 2 giá trị ngày tháng sang JSP ===
                // Tên "checkInValue", "checkOutValue" được đặt để khớp với trang rentalPage.jsp
                req.setAttribute("checkInValue", checkInDate);
                req.setAttribute("checkOutValue", checkOutDate);

                // Forward sang trang rentalPage.jsp
                req.getRequestDispatcher(IConstant.rentalPage).forward(req, resp);

            } else {
                // Nếu không tìm thấy phòng, quay về trang chủ
                resp.sendRedirect("home");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi, quay về trang chủ
            resp.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu người dùng truy cập bằng GET, cũng có thể xử lý tương tự hoặc chuyển về trang chủ
        // Để nhất quán, bạn có thể gọi doPost
        doPost(req, resp);
    }
}