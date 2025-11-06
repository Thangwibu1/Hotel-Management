<%-- 
    Document   : errorPopup
    Created on : Nov 3, 2025, 10:44:15 PM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error Popup</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Error Popup Overlay */
        .error-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .error-overlay.show {
            display: flex;
        }

        /* Error Modal */
        .error-modal {
            background: white;
            border-radius: 12px;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        /* Error Header */
        .error-header {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 20px 24px;
            background: #fef2f2;
            border-bottom: 1px solid #fecaca;
        }

        .error-icon {
            flex-shrink: 0;
            width: 24px;
            height: 24px;
            color: #dc2626;
        }

        .error-title {
            font-size: 18px;
            font-weight: 600;
            color: #991b1b;
            margin: 0;
        }

        /* Error Body */
        .error-body {
            padding: 24px;
        }

        .error-message {
            font-size: 15px;
            line-height: 1.5;
            color: var(--ink);
            margin: 0 0 16px;
        }

        .error-details {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 13px;
            color: var(--muted);
            font-family: 'Courier New', monospace;
        }

        /* Error Footer */
        .error-footer {
            display: flex;
            gap: 12px;
            padding: 0 24px 24px;
            justify-content: flex-end;
        }

        .error-btn {
            padding: 10px 24px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-close {
            background: var(--panel);
            border: 1px solid var(--line);
            color: var(--ink);
        }

        .btn-close:hover {
            background: var(--bg);
        }

        .btn-retry {
            background: #dc2626;
            border: none;
            color: white;
        }

        .btn-retry:hover {
            background: #b91c1c;
        }

        /* Responsive */
        @media (max-width: 640px) {
            .error-modal {
                width: 95%;
            }

            .error-footer {
                flex-direction: column-reverse;
            }

            .error-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <% 
        String errorMessage = (String) request.getAttribute("ERROR");
        boolean hasError = errorMessage != null && !errorMessage.trim().isEmpty();
    %>
    
    <div class="error-overlay <%= hasError ? "show" : "" %>" id="errorOverlay">
        <div class="error-modal">
            <div class="error-header">
                <svg class="error-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
                <h3 class="error-title">Error</h3>
            </div>
            
            <div class="error-body">
                <p class="error-message">
                    <%= errorMessage != null ? errorMessage : "An unexpected error occurred." %>
                </p>
                
                <% if (hasError) { %>
                    <div class="error-details">
                        <%= errorMessage %>
                    </div>
                <% } %>
            </div>
            
            <div class="error-footer">
                <button class="error-btn btn-close" onclick="closeError()">Close</button>
            </div>
        </div>
    </div>

    <script>
        function closeError() {
            document.getElementById('errorOverlay').classList.remove('show');
        }

        function retryAction() {
            window.location.reload();
        }

        document.getElementById('errorOverlay').addEventListener('click', function(e) {
            if (e.target === this) {
                closeError();
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeError();
            }
        });
    </script>
</body>
</html>