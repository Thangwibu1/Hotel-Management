<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Room" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="utils.IConstant" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Waiting Rooms - Luxury Hotel</title>
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
        
        .complete-link { 
            background: #2E7D32;
            border: 2px solid #2E7D32;
        }
        
        .complete-link:hover {
            background: transparent;
            color: #2E7D32;
        }
        
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        
        .status-waiting {
            background: #FFF3E0;
            color: #F57C00;
            border: 2px solid #F57C00;
        }
        
        /* === ANIMATIONS === */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
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
            <a href="./admin"><i class="fas fa-home"></i> Admin Home</a>
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
        <h2><i class="fas fa-clock"></i> Waiting Rooms Management</h2>
        <a href="./admin" class="back-button btn">
            <i class="fas fa-arrow-left"></i> Back to Admin Dashboard
        </a>
        <table>
            <thead>
                <tr>
                    <th>Room ID</th>
                    <th>Room Number</th>
                    <th>Room Type ID</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ArrayList<Room> waitingRooms = (ArrayList<Room>) request.getAttribute("waitingRooms");
                    if (waitingRooms != null && !waitingRooms.isEmpty()) {
                        for (Room room : waitingRooms) {
                %>
                    <tr>
                        <td><%= room.getRoomId() %></td>
                        <td><%= room.getRoomNumber() %></td>
                        <td><%= room.getRoomTypeId() %></td>
                        <td><%= room.getDescription() != null ? room.getDescription() : "N/A" %></td>
                        <td><span class="status-badge status-waiting"><%= room.getStatus() %></span></td>
                        <td class="action-links">
                            <a href="./completeRoom?roomId=<%= room.getRoomId() %>" class="complete-link">
                                <i class="fas fa-check"></i> Mark as Complete
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" style="text-align: center; color: var(--gray); font-style: italic;">No waiting rooms found.</td>
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

