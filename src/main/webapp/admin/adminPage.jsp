<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="utils.IConstant" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { 
            --gold: #c9ab81;
            --gold-dark: #b8941f;
            --black: #000000;
            --white: #FFFFFF;
            --off-white: #FAFAFA;
            --gray-light: #F5F5F5;
            --gray: #666666;
            --border: #E0E0E0;
            
            --font-serif: 'Cormorant Garamond', serif;
            --font-sans: 'Montserrat', sans-serif;
        }
        
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body { 
            font-family: var(--font-sans);
            background: var(--off-white);
            color: var(--black);
            line-height: 1.6;
        }
        
        /* === HEADER === */
        .header { 
            background: var(--black);
            border-bottom: 2px solid var(--gold);
            padding: 1.5rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header .container { 
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .admin-info { 
            font-family: var(--font-serif);
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--white);
            letter-spacing: 0.5px;
        }
        
        .admin-info strong {
            color: var(--gold);
        }
        
        .header-actions { 
            display: flex; 
            align-items: center; 
            gap: 1rem; 
        }
        
        .header-actions a { 
            color: var(--white);
            text-decoration: none;
            padding: 0.6rem 1.5rem;
            border: 2px solid var(--gold);
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .header-actions a:hover { 
            background: var(--gold);
            color: var(--black);
        }
        
        /* === MAIN CONTENT === */
        .container { 
            max-width: 1400px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }
        
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideDown 0.3s ease;
        }
        
        .alert i {
            font-size: 1.3rem;
        }
        
        .alert-error { 
            background: #FFF3F3;
            color: #C62828;
            border-left: 4px solid #C62828;
        }
        
        .alert-success {
            background: #F1F8F4;
            color: #2E7D32;
            border-left: 4px solid #2E7D32;
        }
        
        .card { 
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            padding: 2.5rem;
            margin-bottom: 2rem;
        }
        
        .card h2 { 
            font-family: var(--font-serif);
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--black);
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gold);
            letter-spacing: 1px;
        }
        
        .card h2 i {
            color: var(--gold);
            margin-right: 1rem;
        }
        
        .btn { 
            display: inline-block;
            padding: 0.75rem 2rem;
            border: 2px solid;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-family: var(--font-sans);
            text-decoration: none;
        }
        
        .add-button { 
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
            margin-bottom: 2rem;
        }
        
        .add-button:hover { 
            background: var(--gold-dark);
            border-color: var(--gold-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 171, 129, 0.3);
        }
        
        .add-button i {
            margin-right: 0.5rem;
        }
        
        /* === SEARCH BAR === */
        .search-container {
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .search-form {
            display: flex;
            gap: 1rem;
            flex: 1;
            max-width: 600px;
        }
        
        .search-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            font-family: var(--font-sans);
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            outline: none;
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201, 171, 129, 0.1);
        }
        
        .search-button {
            background: var(--gold);
            color: var(--black);
            border: 2px solid var(--gold);
            padding: 0.75rem 2rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            font-family: var(--font-sans);
            white-space: nowrap;
        }
        
        .search-button:hover {
            background: var(--gold-dark);
            border-color: var(--gold-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 171, 129, 0.3);
        }
        
        .search-button i {
            margin-right: 0.5rem;
        }
        
        .clear-search {
            background: transparent;
            color: var(--gray);
            border: 2px solid var(--gray);
        }
        
        .clear-search:hover {
            background: var(--gray);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 102, 102, 0.3);
        }
        
        /* === TABLE === */
        table { 
            width: 100%;
            border-collapse: collapse;
            background: var(--white);
        }
        
        th, td { 
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        
        th { 
            background: var(--gray-light);
            font-family: var(--font-sans);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--black);
        }
        
        td {
            color: var(--gray);
            font-size: 0.95rem;
        }
        
        tr:hover { 
            background: var(--off-white);
        }
        
        .action-links {
            display: flex;
            gap: 0.5rem;
        }
        
        .action-links a { 
            padding: 0.5rem 1rem;
            border-radius: 6px;
            color: var(--white);
            cursor: pointer;
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .edit-link { 
            background: #1565C0;
            border: 2px solid #1565C0;
        }
        
        .edit-link:hover {
            background: transparent;
            color: #1565C0;
        }
        
        .delete-link { 
            background: #C62828;
            border: 2px solid #C62828;
        }
        
        .delete-link:hover {
            background: transparent;
            color: #C62828;
        }

        /* === MODAL === */
        .modal { 
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background: rgba(0, 0, 0, 0.7);
            animation: fadeIn 0.3s ease;
        }
        
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content { 
            background: var(--white);
            margin: auto;
            padding: 0;
            width: 90%;
            max-width: 600px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.3s ease;
            overflow: hidden;
        }
        
        .close { 
            color: var(--gray);
            float: right;
            font-size: 2rem;
            font-weight: 300;
            line-height: 1;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .close:hover,
        .close:focus { 
            color: var(--black);
        }
        
        .modal-header { 
            padding: 2rem;
            border-bottom: 2px solid var(--gold);
            background: var(--off-white);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h2 {
            font-family: var(--font-serif);
            font-size: 2rem;
            font-weight: 700;
            color: var(--black);
            margin: 0;
            letter-spacing: 1px;
        }
        
        .modal-header h2 i {
            color: var(--gold);
            margin-right: 0.8rem;
        }
        
        .modal-body { 
            padding: 2rem;
        }
        
        .form-group { 
            margin-bottom: 1.5rem;
        }
        
        .form-group label { 
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--black);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-group input,
        .form-group select { 
            width: 100%;
            padding: 0.8rem;
            border: 2px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            font-family: var(--font-sans);
            transition: all 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201, 171, 129, 0.1);
        }
        
        .modal-footer { 
            padding: 1.5rem 2rem;
            border-top: 1px solid var(--border);
            text-align: right;
            background: var(--off-white);
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }
        
        .btn-primary { 
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
        }
        
        .btn-primary:hover {
            background: var(--gold-dark);
            border-color: var(--gold-dark);
        }
        
        .btn-danger { 
            background: #C62828;
            color: var(--white);
            border-color: #C62828;
        }
        
        .btn-danger:hover {
            background: #B71C1C;
            border-color: #B71C1C;
        }
        
        .btn-secondary { 
            background: transparent;
            color: var(--gray);
            border-color: var(--gray);
        }
        
        .btn-secondary:hover {
            background: var(--gray);
            color: var(--white);
        }
        
        /* === ANIMATIONS === */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideUp {
            from {
                transform: translateY(50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        /* === RESPONSIVE === */
        @media (max-width: 768px) {
            .header .container {
                flex-direction: column;
                gap: 1rem;
            }
            
            .header-actions {
                flex-direction: column;
                width: 100%;
            }
            
            .header-actions a {
                width: 100%;
                text-align: center;
            }
            
            .search-container {
                flex-direction: column;
            }
            
            .search-form {
                max-width: 100%;
                flex-direction: column;
            }
            
            .search-button,
            .clear-search {
                width: 100%;
            }
            
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 0.7rem;
            }
            
            .action-links {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<%
    Staff admin = (Staff) request.getAttribute("admin");
%>

<div class="header">
    <div class="container">
        <div class="admin-info">
            <% if (admin != null) { %>
                Welcome, <strong><%= admin.getFullName() %></strong> (<%= admin.getRole() %>)
            <% } else { %>
                Welcome, Admin
            <% } %>
        </div>
        <div class="header-actions">
            <a href="./view-device"><i class="fas fa-tools"></i> Devices</a>
            <a href="./view-room-device"><i class="fas fa-cogs"></i> Room Devices</a>
            <a href="./getRoomWaiting"><i class="fas fa-clock"></i> Waiting Rooms</a>
            <a href="./GetServiceAdminController"><i class="fas fa-concierge-bell"></i> Service Manager</a>
            <a href="./system"><i class="fas fa-cog"></i> System Config</a>
            <a href="./housekeeping-statistic"><i class="fas fa-chart-bar"></i> Housekeeping</a>
            <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <%
        String error = "";
        String success = "";
        try {
            error = (String) request.getAttribute("error");
            success = (String) request.getAttribute("success");
        } catch (Exception e) {
            error = "";
            success = "";
        }
    %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <span><strong>Error:</strong> <%= error %></span>
        </div>
    <% } %>
    
    <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span><strong>Success:</strong> <%= success %></span>
        </div>
    <% } %>
    
    <div class="card">
        <h2><i class="fas fa-users"></i> Staff Management</h2>
        
        <!-- Search Bar -->
        <div class="search-container">
            <form class="search-form" action="./search-staff" method="GET">
                <%
                    String searchKeyword = (String) request.getAttribute("searchKeyword");
                    if (searchKeyword == null) searchKeyword = "";
                %>
                <input type="text" 
                       name="keyword" 
                       class="search-input" 
                       placeholder="Search by name, username, email, phone or role..." 
                       value="<%= searchKeyword %>"
                       autocomplete="off">
                <button type="submit" class="search-button">
                    <i class="fas fa-search"></i> Search
                </button>
                <% if (!searchKeyword.isEmpty()) { %>
                    <a href="./admin" class="search-button clear-search">
                        <i class="fas fa-times"></i> Clear
                    </a>
                <% } %>
            </form>
        </div>
        
        <a class="add-button btn" id="addStaffBtn">
            <i class="fas fa-user-plus"></i> Add New Staff
        </a>
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
                               data-role="<%= staff.getRole() %>">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a class="delete-link" data-id="<%= staff.getStaffId() %>" data-name="<%= staff.getFullName() %>">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: var(--gray); font-style: italic;">No staff members found.</td>
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
            <h2 id="modalTitle"><i class="fas fa-user-plus"></i> Add Staff</h2>
            <span class="close">&times;</span>
        </div>
        <form id="staffForm" method="POST">
            <div class="modal-body">
                <input type="hidden" id="staffId" name="staffId">
                <div class="form-group">
                    <label for="fullName"><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" id="fullName" name="fullName" required>
                </div>
                <div class="form-group">
                    <label for="username"><i class="fas fa-at"></i> Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> Password</label>
                    <input type="password" id="password" name="password">
                </div>
                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="phone"><i class="fas fa-phone"></i> Phone</label>
                    <input type="text" id="phone" name="phone" required>
                </div>
                <div class="form-group">
                    <label for="role"><i class="fas fa-user-tag"></i> Role</label>
                    <input type="text" id="role" name="role" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-exclamation-triangle"></i> Confirm Deletion</h2>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <p style="font-size: 1.1rem; text-align: center; color: var(--gray);">
                Are you sure you want to delete staff member <strong id="staffNameToDelete" style="color: var(--gold);"></strong>?
            </p>
            <p style="text-align: center; color: #C62828; margin-top: 1rem;">
                <i class="fas fa-exclamation-circle"></i> This action cannot be undone.
            </p>
        </div>
        <div class="modal-footer">
            <a class="btn btn-secondary" id="cancelDelete">
                <i class="fas fa-times"></i> Cancel
            </a>
            <a id="confirmDeleteLink" href="#" class="btn btn-danger">
                <i class="fas fa-trash"></i> Delete
            </a>
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
        staffForm.action = './add-staff';
        modalTitle.innerHTML = '<i class="fas fa-user-plus"></i> Add New Staff';
        passwordInput.required = true;
        staffIdInput.value = "";
        staffModal.style.display = "flex";
    }

    // Open Edit modal
    document.querySelectorAll('.edit-link').forEach(function(button) {
        button.onclick = function() {
            staffForm.reset();
            staffForm.action = './update-staff';
            modalTitle.innerHTML = '<i class="fas fa-user-edit"></i> Update Staff';
            
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

            staffModal.style.display = "flex";
        }
    });

    // Open Delete modal
    document.querySelectorAll('.delete-link').forEach(function(button) {
        button.onclick = function() {
            var staffId = this.dataset.id;
            var staffName = this.dataset.name;
            document.getElementById('staffNameToDelete').textContent = staffName;
            document.getElementById('confirmDeleteLink').href = '<%= request.getContextPath() %>/admin/remove-staff?staffId=' + staffId;
            deleteModal.style.display = "flex";
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
