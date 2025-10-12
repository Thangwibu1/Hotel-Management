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
        .add-button { background-color: #28a745; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px; display: inline-block; margin-bottom: 20px; cursor: pointer; }
        .add-button:hover { background-color: #218838; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #f1f1f1; }
        .action-links a { text-decoration: none; margin-right: 10px; padding: 5px 10px; border-radius: 4px; color: white; cursor: pointer; }
        .edit-link { background-color: #007bff; }
        .delete-link { background-color: #dc3545; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
        .modal-content { background-color: #fefefe; margin: 10% auto; padding: 20px; border: 1px solid #888; width: 80%; max-width: 500px; border-radius: 8px; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; }
        .close:hover, .close:focus { color: black; text-decoration: none; cursor: pointer; }
        .modal-header { padding-bottom: 10px; border-bottom: 1px solid #ddd; }
        .modal-body { padding-top: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; }
        .form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .modal-footer { padding-top: 15px; border-top: 1px solid #ddd; text-align: right; }
        .btn { padding: 10px 15px; border-radius: 5px; text-decoration: none; color: white; cursor: pointer; border: none; }
        .btn-primary { background-color: #007bff; }
        .btn-danger { background-color: #dc3545; }
        .btn-secondary { background-color: #6c757d; }
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
    <%
        String error = "";
        try {
            error = (String) request.getAttribute("error");
        } catch (Exception e) {
            error = "";
        }

    %>
    <% if (error != null && !error.isEmpty()) { %>
        <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
            <strong>Error:</strong> <%= error %>
        </div>
    <% } %>
    <div class="card">
        <h2>Staff Management</h2>
        <a class="add-button" id="addStaffBtn">Add New Staff</a>
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
                            <a class="edit-link" 
                               data-id="<%= staff.getStaffId() %>"
                               data-fullname="<%= staff.getFullName() %>"
                               data-username="<%= staff.getUsername() %>"
                               data-email="<%= staff.getEmail() %>"
                               data-phone="<%= staff.getPhone() %>"
                               data-role="<%= staff.getRole() %>">Edit</a>
                            <a class="delete-link" data-id="<%= staff.getStaffId() %>" data-name="<%= staff.getFullName() %>">Delete</a>
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

<!-- Add/Update Staff Modal -->
<div id="staffModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="close">&times;</span>
            <h2 id="modalTitle">Add Staff</h2>
        </div>
        <form id="staffForm" method="POST">
            <div class="modal-body">
                <input type="hidden" id="staffId" name="staffId">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" required="">
                </div>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required="">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required="">
                </div>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" required="">
                </div>
                <div class="form-group">
                    <label for="role">Role</label>
                    <input type="text" id="role" name="role" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="close">&times;</span>
            <h2>Confirm Deletion</h2>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to delete staff member <strong id="staffNameToDelete"></strong>?</p>
        </div>
        <div class="modal-footer">
            <a id="confirmDeleteLink" href="#" class="btn btn-danger">Delete</a>
            <a class="btn btn-secondary" id="cancelDelete">Cancel</a>
        </div>
    </div>
</div>

<script>
    // Get modals
    var staffModal = document.getElementById("staffModal");
    var deleteModal = document.getElementById("deleteModal");

    // Get close buttons
    var closeButtons = document.getElementsByClassName("close");

    // Get form and elements
    var staffForm = document.getElementById("staffForm");
    var modalTitle = document.getElementById("modalTitle");
    var staffIdInput = document.getElementById("staffId");
    var fullNameInput = document.getElementById("fullName");
    var usernameInput = document.getElementById("username");
    var passwordInput = document.getElementById("password");
    var emailInput = document.getElementById("email");
    var phoneInput = document.getElementById("phone");
    var roleInput = document.getElementById("role");

    // --- Event Listeners ---

    // Open Add modal
    document.getElementById("addStaffBtn").onclick = function() {
        staffForm.reset();
        staffForm.action = 'AddStaffController';
        modalTitle.textContent = "Add New Staff";
        passwordInput.required = true;
        staffIdInput.value = "";
        staffModal.style.display = "block";
    }

    // Open Edit modal
    document.querySelectorAll('.edit-link').forEach(function(button) {
        button.onclick = function() {
            staffForm.reset();
            staffForm.action = 'UpdateStaffController';
            modalTitle.textContent = "Update Staff";
            
            // Populate form
            staffIdInput.value = this.dataset.id;
            fullNameInput.value = this.dataset.fullname;
            usernameInput.value = this.dataset.username;
            emailInput.value = this.dataset.email;
            phoneInput.value = this.dataset.phone;
            roleInput.value = this.dataset.role;
            
            // Password is not pre-filled for security, but can be updated.
            passwordInput.placeholder = "Leave blank to keep current password";
            passwordInput.required = false;

            staffModal.style.display = "block";
        }
    });

    // Open Delete modal
    document.querySelectorAll('.delete-link').forEach(function(button) {
        button.onclick = function() {
            var staffId = this.dataset.id;
            var staffName = this.dataset.name;
            document.getElementById('staffNameToDelete').textContent = staffName;
            document.getElementById('confirmDeleteLink').href = '<%= request.getContextPath() %>/admin/remove-staff?staffId=' + staffId;
            deleteModal.style.display = "block";
        }
    });
    
    // Cancel delete
    document.getElementById('cancelDelete').onclick = function() {
        deleteModal.style.display = "none";
    }

    // Close modals with close button
    for (var i = 0; i < closeButtons.length; i++) {
        closeButtons[i].onclick = function() {
            this.closest('.modal').style.display = "none";
        }
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target == staffModal) {
            staffModal.style.display = "none";
        }
        if (event.target == deleteModal) {
            deleteModal.style.display = "none";
        }
    }
</script>

</body>
</html>