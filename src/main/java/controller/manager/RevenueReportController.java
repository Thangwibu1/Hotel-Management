/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager;

import dao.ManageReportDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.RevenueRow;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "RevenueReportController", urlPatterns = {"/manager/RevenueReportController"})
public class RevenueReportController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private String normalizeRange(String range) {
        if (range == null) {
            return "daily";
        }
        String r = range.toLowerCase();
        switch (r) {
            case "monthly":
            case "yearly":
                return r;
            default:
                return "daily";
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String range = normalizeRange(request.getParameter("range"));

        try {
            ManageReportDAO reportDao = new ManageReportDAO();

            ArrayList<RevenueRow> result = reportDao.getRevenueStats(range);
            BigDecimal avgRevenue = reportDao.getAverage(range);
            String bestPeriod = reportDao.getBestPeriod(range);
            BigDecimal totalRevenue = reportDao.getTotal(range);

            // G?n attribute cho JSP
            request.setAttribute("RANGE", range);
            request.setAttribute("result", result);
            request.setAttribute("avgRevenue", avgRevenue);
            request.setAttribute("bestPeriod", bestPeriod);
            request.setAttribute("totalRevenue", totalRevenue);

            request.getRequestDispatcher("/manager/dashboard.jsp").forward(request, response);

        } catch (Exception ex) {
            // Log và show trang l?i ??n gi?n
            ex.printStackTrace();
            request.setAttribute("RANGE", range);
            request.setAttribute("result", new ArrayList<RevenueRow>());
            request.setAttribute("avgRevenue", BigDecimal.ZERO);
            request.setAttribute("bestPeriod", "N/A");
            request.setAttribute("totalRevenue", BigDecimal.ZERO);
            request.setAttribute("error", "Không tai duoc du lieu báo cáo. Vui lòng thu lai.");
            request.getRequestDispatcher("/manager/dashboard.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
