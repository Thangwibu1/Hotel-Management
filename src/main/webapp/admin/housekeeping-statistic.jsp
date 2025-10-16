<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RoomTask" %>
<%@ page import="model.Staff" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Housekeeping Staff Statistics</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f4f4f4; }
        .header { background-color: #333; color: white; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header .admin-info { font-size: 1.1em; }
        .header .header-actions a { color: white; text-decoration: none; margin-left: 15px; padding: 8px 12px; border: 1px solid white; border-radius: 5px; }
        .header .header-actions a:hover { background-color: white; color: #333; }
        .container { padding: 20px; }
        .card { background-color: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 20px; }
        h1, h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #f1f1f1; }
        .back-button { background-color: #6c757d; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px; display: inline-block; margin-bottom: 20px; cursor: pointer; }
        .back-button:hover { background-color: #5a6268; }
    </style>
</head>
<body>

<%
    Staff admin = (Staff) request.getAttribute("admin");
%>

<div class="header">
    <div class="admin-info">
        <% if (admin != null) { %>
            Welcome, <strong><%= admin.getFullName() %></strong> (<%= admin.getRole() %>)
        <% } else { %>
            Welcome, Admin
        <% } %>
    </div>
    <div class="header-actions">
        <a href="<%= request.getContextPath() %>/admin/system">Change System Info</a>
        <a href="<%= request.getContextPath() %>/admin/housekeeping-statistic">Housekeeping Statistic</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>Housekeeping Staff Statistics</h2>
        <a href="<%= request.getContextPath() %>/admin/admin" class="back-button">Back to Admin Page</a>
        <%
            HashMap<Integer, ArrayList<RoomTask>> roomTaskByStaff = (HashMap<Integer, ArrayList<RoomTask>>) request.getAttribute("roomTaskByStaff");
            ArrayList<Staff> staffs = (ArrayList<Staff>) request.getAttribute("staffs");
        %>

        <table>
            <thead>
                <tr>
                    <th>Staff Name</th>
                    <th>Number of Tasks</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (staffs != null && !staffs.isEmpty() && roomTaskByStaff != null) {
                        for (Staff staff : staffs) {
                            ArrayList<RoomTask> tasks = roomTaskByStaff.get(staff.getStaffId());
                            int taskCount = (tasks != null) ? tasks.size() : 0;
                %>
                <tr>
                    <td><%= staff.getFullName() %></td>
                    <td><%= taskCount %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="2" style="text-align: center;">No housekeeping staff or task data found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>