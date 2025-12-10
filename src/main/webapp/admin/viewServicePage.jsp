<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="utils.IConstant" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Management - Luxury Hotel</title>
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
        
        .back-button {
            background: var(--gray);
            color: var(--white);
            border-color: var(--gray);
            margin-bottom: 1rem;
        }

        .back-button:hover {
            background: var(--black);
            border-color: var(--black);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .back-button i {
            margin-right: 0.5rem;
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

        .disabled-link {
            background: #9E9E9E;
            border: 2px solid #9E9E9E;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .disabled-link:hover {
            background: #9E9E9E;
            color: var(--white);
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
    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");
    
    // Clear messages after displaying
    if (error != null) session.removeAttribute("error");
    if (success != null) session.removeAttribute("success");
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
            <a href="./admin"><i class="fas fa-home"></i> Admin Home</a>
            <a href="./getRoomWaiting"><i class="fas fa-clock"></i> Waiting Rooms</a>
            <a href="./system"><i class="fas fa-cog"></i> System Config</a>
            <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
</div>

<div class="container">
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
        <h2><i class="fas fa-concierge-bell"></i> Service Management</h2>
        <a href="./admin" class="back-button btn">
            <i class="fas fa-arrow-left"></i> Back to Admin Dashboard
        </a>
        <a class="add-button btn" id="addServiceBtn">
            <i class="fas fa-plus"></i> Add New Service
        </a>
        <table>
            <thead>
                <tr>
                    <th>Service ID</th>
                    <th>Service Name</th>
                    <th>Service Type</th>
                    <th>Price ($)</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ArrayList<Service> services = (ArrayList<Service>) request.getAttribute("services");
                    if (services != null && !services.isEmpty()) {
                        for (Service service : services) {
                            boolean isProtected = (service.getServiceId() == 3);
                %>
                    <tr>
                        <td><%= service.getServiceId() %></td>
                        <td><%= service.getServiceName() %></td>
                        <td><%= service.getServiceType() != null ? service.getServiceType() : "N/A" %></td>
                        <td>$<%= service.getPrice() %></td>
                        <td class="action-links">
                            <% if (isProtected) { %>
                                <a class="disabled-link" title="This service cannot be modified">
                                    <i class="fas fa-lock"></i> Protected
                                </a>
                            <% } else { %>
                                <a class="edit-link" 
                                   data-id="<%= service.getServiceId() %>"
                                   data-name="<%= service.getServiceName() %>"
                                   data-type="<%= service.getServiceType() != null ? service.getServiceType() : "" %>"
                                   data-price="<%= service.getPrice() %>">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: var(--gray); font-style: italic;">No services found.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Service Modal -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-plus"></i> Add New Service</h2>
            <span class="close">&times;</span>
        </div>
        <form id="addForm" method="POST" action="./AddServiceController">
            <div class="modal-body">
                <div class="form-group">
                    <label for="addServiceName"><i class="fas fa-concierge-bell"></i> Service Name</label>
                    <input type="text" id="addServiceName" name="serviceName" required>
                </div>
                <div class="form-group">
                    <label for="addServiceType"><i class="fas fa-tag"></i> Service Type</label>
                    <input type="text" id="addServiceType" name="serviceType" required>
                </div>
                <div class="form-group">
                    <label for="addPrice"><i class="fas fa-dollar-sign"></i> Price</label>
                    <input type="number" id="addPrice" name="price" step="0.01" min="0" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Add Service
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Update Service Modal -->
<div id="updateModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-edit"></i> Update Service</h2>
            <span class="close">&times;</span>
        </div>
        <form id="updateForm" method="POST" action="./UpdateServiceController">
            <div class="modal-body">
                <input type="hidden" id="updateServiceId" name="serviceId">
                <div class="form-group">
                    <label for="updateServiceName"><i class="fas fa-concierge-bell"></i> Service Name</label>
                    <input type="text" id="updateServiceName" name="serviceName" required>
                </div>
                <div class="form-group">
                    <label for="updateServiceType"><i class="fas fa-tag"></i> Service Type</label>
                    <input type="text" id="updateServiceType" name="serviceType" required>
                </div>
                <div class="form-group">
                    <label for="updatePrice"><i class="fas fa-dollar-sign"></i> Price</label>
                    <input type="number" id="updatePrice" name="price" step="0.01" min="0" required>
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

<script>
    // Get modals
    var addModal = document.getElementById("addModal");
    var updateModal = document.getElementById("updateModal");

    // Get close buttons
    var closeButtons = document.getElementsByClassName("close");

    // Open Add modal
    document.getElementById("addServiceBtn").onclick = function() {
        document.getElementById("addForm").reset();
        addModal.style.display = "flex";
    }

    // Open Update modal
    document.querySelectorAll('.edit-link').forEach(function(button) {
        button.onclick = function() {
            document.getElementById('updateServiceId').value = this.dataset.id;
            document.getElementById('updateServiceName').value = this.dataset.name;
            document.getElementById('updateServiceType').value = this.dataset.type;
            document.getElementById('updatePrice').value = this.dataset.price;
            updateModal.style.display = "flex";
        }
    });

    // Close modals with close button
    for (var i = 0; i < closeButtons.length; i++) {
        closeButtons[i].onclick = function() {
            this.closest('.modal').style.display = "none";
        }
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target == addModal) {
            addModal.style.display = "none";
        }
        if (event.target == updateModal) {
            updateModal.style.display = "none";
        }
    }
</script>

</body>
</html>

