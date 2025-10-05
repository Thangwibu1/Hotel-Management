package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, IOException {
        req.getSession().invalidate(); // XÃ³a session
        resp.sendRedirect("home"); // Redirect vá»? home
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, IOException {
        req.getSession().invalidate(); // XÃ³a session
        System.out.println("toi day r");
        resp.sendRedirect("home"); // Redirect vá»? home
    }
}
