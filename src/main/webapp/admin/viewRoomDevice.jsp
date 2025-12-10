<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.RoomDevice" %>
<%@ page import="model.Device" %>
<%@ page import="model.Room" %>
<%@ page import="model.Staff" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Device Management - Luxury Hotel</title>
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
        
        .add-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
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
        
        /* === ROOM INFO === */
        .room-info {
            background: var(--gray-light);
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border-left: 4px solid var(--gold);
        }
        
        .room-info h3 {
            font-family: var(--font-serif);
            font-size: 1.5rem;
            color: var(--black);
            margin-bottom: 1rem;
        }
        
        .room-info p {
            margin: 0.5rem 0;
            color: var(--gray);
        }
        
        .room-info strong {
            color: var(--black);
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
        
        .status-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-working {
            background: #E8F5E9;
            color: #2E7D32;
        }
        
        .status-broken {
            background: #FFEBEE;
            color: #C62828;
        }
        
        .status-unknown {
            background: #EEEEEE;
            color: #666666;
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
            
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 0.7rem;
            }
        }
    </style>
</head>
<body>

<%
    Staff admin = (Staff) request.getAttribute("admin");
    Room room = (Room) request.getAttribute("room");
    String searchedRoomNumber = (String) request.getAttribute("searchedRoomNumber");
    if (searchedRoomNumber == null) searchedRoomNumber = "";
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
            <a href="./admin"><i class="fas fa-users"></i> Staff Management</a>
            <a href="./view-device"><i class="fas fa-tools"></i> Devices</a>
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
        <h2><i class="fas fa-cogs"></i> Room Device Management</h2>
        
        <!-- Search Bar -->
        <div class="search-container">
            <form class="search-form" action="./view-room-device" method="GET">
                <input type="text" 
                       name="roomNumber" 
                       class="search-input" 
                       placeholder="Enter room number (e.g., 101, 201)..." 
                       value="<%= searchedRoomNumber %>"
                       autocomplete="off"
                       required>
                <button type="submit" class="search-button">
                    <i class="fas fa-search"></i> Search Room
                </button>
            </form>
        </div>
        
        <% if (room != null) { %>
            <!-- Room Info -->
            <div class="room-info">
                <h3><i class="fas fa-door-open"></i> Room Information</h3>
                <p><strong>Room ID:</strong> <%= room.getRoomId() %></p>
                <p><strong>Room Number:</strong> <%= room.getRoomNumber() %></p>
                <p><strong>Status:</strong> <%= room.getStatus() %></p>
                <% if (room.getDescription() != null && !room.getDescription().isEmpty()) { %>
                    <p><strong>Description:</strong> <%= room.getDescription() %></p>
                <% } %>
            </div>
            
            <button class="add-button btn" id="addRoomDeviceBtn">
                <i class="fas fa-plus-circle"></i> Add Device to Room
            </button>
            
            <table>
                <thead>
                    <tr>
                        <th>Room Device ID</th>
                        <th>Device ID</th>
                        <th>Quantity</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        ArrayList<RoomDevice> roomDevices = (ArrayList<RoomDevice>) request.getAttribute("roomDevices");
                        if (roomDevices != null && !roomDevices.isEmpty()) {
                            for (RoomDevice rd : roomDevices) {
                    %>
                        <tr>
                            <td><%= rd.getRoomDeviceId() %></td>
                            <td><%= rd.getDeviceId() %></td>
                            <td><%= rd.getQuantity() %></td>
                            <td>
                                <% 
                                    Integer status = rd.getStatus();
                                    if (status != null) {
                                        if (status == 1) {
                                %>
                                    <span class="status-badge status-working">Working</span>
                                <%
                                        } else if (status == 0) {
                                %>
                                    <span class="status-badge status-broken">Broken</span>
                                <%
                                        } else {
                                %>
                                    <span class="status-badge status-unknown">Unknown</span>
                                <%
                                        }
                                    } else {
                                %>
                                    <span class="status-badge status-unknown">N/A</span>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="4" style="text-align: center; color: var(--gray); font-style: italic;">No devices found for this room.</td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        <% } else if (searchedRoomNumber != null && !searchedRoomNumber.isEmpty()) { %>
            <div style="text-align: center; padding: 3rem; color: var(--gray);">
                <i class="fas fa-search" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                <p style="font-size: 1.2rem;">Please search for a room to view its devices.</p>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 3rem; color: var(--gray);">
                <i class="fas fa-search" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                <p style="font-size: 1.2rem;">Please search for a room to view its devices.</p>
            </div>
        <% } %>
    </div>
</div>

<!-- Add Room Device Modal -->
<div id="roomDeviceModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-plus-circle"></i> Add Device to Room</h2>
            <span class="close">&times;</span>
        </div>
        <form id="roomDeviceForm" method="POST" action="./add-room-device">
            <div class="modal-body">
                <input type="hidden" name="roomId" value="<%= room != null ? room.getRoomId() : "" %>">
                <input type="hidden" name="roomNumber" value="<%= searchedRoomNumber %>">
                
                <div class="form-group">
                    <label for="deviceId"><i class="fas fa-tools"></i> Device *</label>
                    <select id="deviceId" name="deviceId" required>
                        <option value="">-- Select Device --</option>
                        <%
                            ArrayList<Device> allDevices = (ArrayList<Device>) request.getAttribute("allDevices");
                            if (allDevices != null) {
                                for (Device device : allDevices) {
                        %>
                            <option value="<%= device.getDeviceId() %>"><%= device.getDeviceName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="quantity"><i class="fas fa-hashtag"></i> Quantity *</label>
                    <input type="number" id="quantity" name="quantity" required min="1" value="1" placeholder="Enter quantity">
                </div>
                
                <div class="form-group">
                    <label for="status"><i class="fas fa-info-circle"></i> Status</label>
                    <select id="status" name="status">
                        <option value="">-- Not specified --</option>
                        <option value="1" selected>Working</option>
                        <option value="0">Broken</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Add Device
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Get modal
    var roomDeviceModal = document.getElementById("roomDeviceModal");

    // Get close button
    var closeButton = document.getElementsByClassName("close")[0];

    // Get form
    var roomDeviceForm = document.getElementById("roomDeviceForm");
    
    // Get add button
    var addBtn = document.getElementById("addRoomDeviceBtn");

    // Open Add modal
    if (addBtn) {
        addBtn.onclick = function() {
            roomDeviceForm.reset();
            // Set default status to 1 (Working)
            document.getElementById("status").value = "1";
            roomDeviceModal.style.display = "flex";
        }
    }

    // Close modal with close button
    if (closeButton) {
        closeButton.onclick = function() {
            roomDeviceModal.style.display = "none";
        }
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target == roomDeviceModal) {
            roomDeviceModal.style.display = "none";
        }
    }
</script>

</body>
</html>

