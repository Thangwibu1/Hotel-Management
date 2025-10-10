<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f4f4f4; }
        .header { background-color: #333; color: white; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header .admin-info { font-size: 1.1em; }
        .header .header-actions a { color: white; text-decoration: none; margin-left: 15px; padding: 8px 12px; border: 1px solid white; border-radius: 5px; }
        .header .header-actions a:hover { background-color: white; color: #333; }
        .container { padding: 20px; }
        .card { background-color: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 20px; }
        h1, h2 { color: #333; }
        .add-button { background-color: #28a745; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px; display: inline-block; margin-bottom: 20px; }
        .add-button:hover { background-color: #218838; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #f1f1f1; }
        .action-links a { text-decoration: none; margin-right: 10px; padding: 5px 10px; border-radius: 4px; }
        .edit-link { background-color: #007bff; color: white; }
        .delete-link { background-color: #dc3545; color: white; }
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
        <a href="#">Change System Info</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>Staff Management</h2>
        <a href="#" class="add-button">Add New Staff</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ArrayList<Staff> staffs = (ArrayList<Staff>) request.getAttribute("staffs");
                    if (staffs != null && !staffs.isEmpty()) {
                        for (Staff staff : staffs) {
                %>
                    <tr>
                        <td><%= staff.getStaffId() %></td>
                        <td><%= staff.getFullName() %></td>
                        <td><%= staff.getUsername() %></td>
                        <td><%= staff.getEmail() %></td>
                        <td><%= staff.getPhone() %></td>
                        <td><%= staff.getRole() %></td>
                        <td class="action-links">
                            <a href="#" class="edit-link">Edit</a>
                            <a href="#" class="delete-link">Delete</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" style="text-align: center;">No staff members found.</td>
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