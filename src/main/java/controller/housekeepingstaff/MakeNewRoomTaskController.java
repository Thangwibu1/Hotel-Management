package controller.housekeepingstaff;

import dao.AssignTaskDAO;
import dao.RoomDAO;
import dao.RoomTaskDAO;
import java.io.IOException;
import java.sql.Connection; 
import java.sql.SQLException; 
import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Room;
import model.RoomTask;
import utils.DBConnection;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "MakeNewRoomTaskController", urlPatterns = {"/housekeepingstaff/makeNewRoomTaskController"})
public class MakeNewRoomTaskController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        Connection con = null;
        int assignedWork = 0;

        try {
            System.out.println("co vo Make New  ");
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            AssignTaskDAO assignTaskDAO = new AssignTaskDAO();
            LocalDateTime lastAssign = assignTaskDAO.getLastTimeAssign();
            RoomTaskDAO dRoomTask = new RoomTaskDAO();
            System.out.println("MAKE ROOM STEP 1");
            ArrayList<RoomTask> listTask = dRoomTask.getAllRoomTaskBaseDate(LocalDateTime.now());
            if (listTask != null) {
                int count = 0;
                for (RoomTask roomTask : listTask) {
                    if (roomTask.getIsSystemTask() == 1) {
                        count++;
                    }
                }
                if (count > 0) {
                    request.getRequestDispatcher(IConstant.takeRoomForCleanController).forward(request, response);
                    return;
                } else {
                    System.out.println("MAKE ROOM STEP 2B CH CO PHONG");
//                System.out.println("Ko sang ma lam task moi ne");
                    RoomTaskDAO roomTaskDAO = new RoomTaskDAO();
                    RoomDAO roomDAO = new RoomDAO();

                    ArrayList<Room> roomList = roomDAO.getAllRoom();

                    int cleanableRoomsCount = 0;

                    for (Room room : roomList) {
                        if ("Maintenance".equalsIgnoreCase(room.getStatus())) {
                            System.out.println("Phòng " + room.getRoomNumber() + " ?ang Maintenance. Ko t?o task.");
                            continue;
                        }

                        cleanableRoomsCount++;

                        int rows = roomTaskDAO.insertRoomTask(
                                new RoomTask(
                                        room.getRoomId(),
                                        null,
                                        LocalDateTime.now(),
                                        null,
                                        "Pending",
                                        null, 1
                                ),
                                con
                        );

                        if (rows > 0) {
                            assignedWork++;
                        } else {
                            throw new SQLException("Insert failed for RoomID: " + room.getRoomId());
                        }
                    }

                    if (assignedWork > 0 && assignedWork == cleanableRoomsCount) {

                        boolean assignTaskUpdated = assignTaskDAO.updateAssignTaskTime("ASS01", LocalDateTime.now());

                        if (assignTaskUpdated) {
                            con.commit();
                            request.getRequestDispatcher(IConstant.takeRoomForCleanController).forward(request, response);
                        } else {
                            con.rollback();
                        }
                    } else {
                        con.rollback();
                    }
                }
            } else {
                System.out.println("MAKE ROOM STEP 2B CH CO PHONG");
//                System.out.println("Ko sang ma lam task moi ne");
                RoomTaskDAO roomTaskDAO = new RoomTaskDAO();
                RoomDAO roomDAO = new RoomDAO();

                ArrayList<Room> roomList = roomDAO.getAllRoom();

                int cleanableRoomsCount = 0;

                for (Room room : roomList) {
                    if ("Maintenance".equalsIgnoreCase(room.getStatus())) {
                        System.out.println("Phòng " + room.getRoomNumber() + " ?ang Maintenance. Ko t?o task.");
                        continue;
                    }

                    cleanableRoomsCount++;

                    int rows = roomTaskDAO.insertRoomTask(
                            new RoomTask(
                                    room.getRoomId(),
                                    null,
                                    LocalDateTime.now(),
                                    null,
                                    "Pending",
                                    null, 1
                            ),
                            con
                    );

                    if (rows > 0) {
                        assignedWork++;
                    } else {
                        throw new SQLException("Insert failed for RoomID: " + room.getRoomId());
                    }
                }

                if (assignedWork > 0 && assignedWork == cleanableRoomsCount) {

                    boolean assignTaskUpdated = assignTaskDAO.updateAssignTaskTime("ASS01", LocalDateTime.now());

                    if (assignTaskUpdated) {
                        con.commit();
                        request.getRequestDispatcher(IConstant.takeRoomForCleanController).forward(request, response);
                    } else {
                        con.rollback();
                    }
                } else {
                    con.rollback();
                }
            }

        } catch (SQLException e) {
            System.err.println("L?i SQL/Transaction: " + e.getMessage());
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                    System.err.println("Transaction Rollback thành công.");
                } catch (SQLException ex) {
                    System.err.println("L?i khi th?c hi?n Rollback: " + ex.getMessage());
                }
            }
        } catch (Exception e) {
            System.err.println("L?i chung: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    System.err.println("L?i ?óng Connection: " + e.getMessage());
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
