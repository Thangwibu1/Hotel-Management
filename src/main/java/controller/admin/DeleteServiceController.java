package controller.admin;

import dao.ServiceDAO;
import model.Staff;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/DeleteServiceController")
public class DeleteServiceController extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Staff admin = null;
        if (session != null) {
            admin = (Staff) session.getAttribute("userStaff");
        }
        
        // Redirect to login if not logged in or not an admin
        if (admin == null || !"admin".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("../" + IConstant.loginPage);
            return;
        }

        // Get serviceId from request parameter
        String serviceIdStr = req.getParameter("serviceId");

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            
            // Check if service ID is 3 (protected service)
            if (serviceId == 3) {
                session.setAttribute("error", "Service ID 3 cannot be deleted.");
                resp.sendRedirect("./GetServiceAdminController");
                return;
            }

            boolean deleteSuccess = serviceDAO.deleteService(serviceId);

            if (deleteSuccess) {
                session.setAttribute("success", "Service deleted successfully.");
            } else {
                session.setAttribute("error", "Failed to delete service.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid service ID.");
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
        }

        resp.sendRedirect("./GetServiceAdminController");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

