package controller.admin;

import dao.StaffDAO;
import model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/search-staff")
public class SearchStaffController extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        
        HttpSession session = req.getSession();
        Staff admin = (Staff) session.getAttribute("admin");
        req.setAttribute("admin", admin);
        
        if (keyword == null || keyword.trim().isEmpty()) {
            // If no keyword, show all staff
            ArrayList<Staff> staffs = staffDAO.getAllStaff();
            req.setAttribute("staffs", staffs);
            req.getRequestDispatcher("/admin/adminPage.jsp").forward(req, resp);
            return;
        }
        
        // Search staff by keyword
        ArrayList<Staff> staffs = staffDAO.searchStaff(keyword.trim());
        
        if (staffs.isEmpty()) {
            req.setAttribute("staffs", new ArrayList<Staff>());
            req.setAttribute("error", "No staff found for keyword: \"" + keyword + "\"");
        } else {
            req.setAttribute("staffs", staffs);
            req.setAttribute("success", "Found " + staffs.size() + " staff member(s) for keyword: \"" + keyword + "\"");
        }
        
        req.setAttribute("searchKeyword", keyword);
        req.getRequestDispatcher("/admin/adminPage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

