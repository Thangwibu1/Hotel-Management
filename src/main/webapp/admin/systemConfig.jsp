<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.SystemConfig" %>
<%@ page import="model.Staff" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Configuration</title>
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
        <a href="<%= request.getContextPath() %>/admin">Staff Management</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">
     <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
    %>
    <% if (error != null && !error.isEmpty()) { %>
        <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
            <strong>Error:</strong> <%= error %>
        </div>
    <% } %>
    <% if (success != null && !success.isEmpty()) { %>
        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
            <strong>Success:</strong> <%= success %>
        </div>
    <% } %>
    <div class="card">
        <h2>System Configuration</h2>
        <a class="add-button" id="addConfigBtn">Add New Config</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Config Name</th>
                    <th>Config Value</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ArrayList<SystemConfig> systemConfigs = (ArrayList<SystemConfig>) request.getAttribute("systemConfigs");
                    if (systemConfigs != null && !systemConfigs.isEmpty()) {
                        for (SystemConfig configg : systemConfigs) {
                %>
                    <tr>
                        <td><%= configg.getConfigId() %></td>
                        <td><%= configg.getConfigName() %></td>
                        <td><%= configg.getConfigValue() %></td>
                        <td class="action-links">
                            <a class="edit-link"
                               data-id="<%= configg.getConfigId() %>"
                               data-name="<%= configg.getConfigName() %>"
                               data-value="<%= configg.getConfigValue() %>">Edit</a>
                            <a class="delete-link" data-id="<%= configg.getConfigId() %>" data-name="<%= configg.getConfigName() %>">Delete</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="4" style="text-align: center;">No system configurations found.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add/Update Config Modal -->
<div id="configModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="close">&times;</span>
            <h2 id="modalTitle">Add Config</h2>
        </div>
        <form id="configForm" method="POST">
            <div class="modal-body">
                <input type="hidden" id="configId" name="configId">
                <div class="form-group">
                    <label for="configName">Config Name</label>
                    <input type="text" id="configName" name="configName" required="">
                </div>
                <div class="form-group">
                    <label for="configValue">Config Value</label>
                    <input type="number" id="configValue" name="configValue" required="">
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
            <p>Are you sure you want to delete config <strong id="configNameToDelete"></strong>?</p>
        </div>
        <div class="modal-footer">
            <form id="deleteForm" action="./remove-system-config" method="POST" style="display: inline;">
                <input type="hidden" id="deleteConfigId" name="configId">
                <button type="submit" class="btn btn-danger">Delete</button>
            </form>
            <a class="btn btn-secondary" id="cancelDelete">Cancel</a>
        </div>
    </div>
</div>

<script>
    // Get modals
    var configModal = document.getElementById("configModal");
    var deleteModal = document.getElementById("deleteModal");

    // Get close buttons
    var closeButtons = document.getElementsByClassName("close");

    // Get form and elements
    var configForm = document.getElementById("configForm");
    var modalTitle = document.getElementById("modalTitle");
    var configIdInput = document.getElementById("configId");
    var configNameInput = document.getElementById("configName");
    var configValueInput = document.getElementById("configValue");

    // --- Event Listeners ---

    // Open Add modal
    document.getElementById("addConfigBtn").onclick = function() {
        configForm.reset();
        configForm.action = './add-system-config';
        modalTitle.textContent = "Add New Config";
        configIdInput.value = "";
        configNameInput.readOnly = false;
        configModal.style.display = "block";
    }

    // Open Edit modal
    document.querySelectorAll('.edit-link').forEach(function(button) {
        button.onclick = function() {
            configForm.reset();
            configForm.action = './edit-system-config';
            modalTitle.textContent = "Edit Config";

            // Populate form
            configIdInput.value = this.dataset.id;
            configNameInput.value = this.dataset.name;
            configValueInput.value = this.dataset.value;

            // Config name should not be editable
            configNameInput.readOnly = true;

            configModal.style.display = "block";
        }
    });

    // Open Delete modal
    document.querySelectorAll('.delete-link').forEach(function(button) {
        button.onclick = function() {
            var configId = this.dataset.id;
            var configName = this.dataset.name;
            document.getElementById('configNameToDelete').textContent = configName;
            document.getElementById('deleteConfigId').value = configId;
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
        if (event.target == configModal) {
            configModal.style.display = "none";
        }
        if (event.target == deleteModal) {
            deleteModal.style.display = "none";
        }
    }
</script>

</body>
</html>