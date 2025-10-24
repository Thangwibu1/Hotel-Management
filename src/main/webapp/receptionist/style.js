
// Show today's date
const fmt = new Intl.DateTimeFormat(undefined, {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'});
document.getElementById('today').textContent = fmt.format(new Date());

// Main tabs
//const mainTabs = document.querySelectorAll('.tabs .tab:not([data-subtab])');
//mainTabs.forEach(btn => {
//    btn.addEventListener('click', () => {
//        // deactivate all in this nav
//        btn.closest('.tabs').querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
//        btn.classList.add('active');
//        // switch screen
//        document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
//        document.getElementById(btn.dataset.target).classList.add('active');
//    });
//});

// Sub tabs inside Check-in/Out
document.querySelectorAll('.tabs .tab[data-subtab]').forEach(btn => {
    btn.addEventListener('click', () => {
        const container = btn.closest('.tabs');
        container.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
    });
});

// Simple client-side search for pending check-ins
const searchInput = document.getElementById('searchInput');
if (searchInput) {
    searchInput.addEventListener('input', (e) => {
        const q = e.target.value.toLowerCase();
        document.querySelectorAll('#tblCheckins tbody tr').forEach(tr => {
            tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    });
}

document.querySelectorAll('.status .badge').forEach(badge => {
    const s = badge.textContent.trim().toLowerCase();
    badge.classList.remove('green', 'gray', 'yellow', 'red');
    if (s === 'available')
        badge.classList.add('green');
    else if (s === 'occupied')
        badge.classList.add('gray');
    else if (s === 'dirty')
        badge.classList.add('yellow');
    else if (s === 'maintenance')
        badge.classList.add('red');
    else
        badge.classList.add('gray');
});

document.querySelectorAll('.booking-status .badge').forEach(badge => {
    const s = badge.textContent.trim().toLowerCase();
    badge.classList.remove('green', 'gray', 'yellow', 'red');

    if (s === 'reserved')
        badge.classList.add('yellow');
    else if (s === 'checked-in')
        badge.classList.add('green');
    else if (s === 'checked-out')
        badge.classList.add('gray');
    else if (s === 'canceled')
        badge.classList.add('red');
    else
        badge.classList.add('gray');
});

function initPopup(popupId, openButtonClass = null, onCloseCallback = null) {
    const popup = document.getElementById(popupId);
    if (!popup)
        return;
    const modal = popup.querySelector('.bill-modal');
    const closeBtn = popup.querySelector('.bill-close');

    function openPopup(e) {
        if (e)
            e.preventDefault();
        popup.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
    
    function closePopup(e) {
        if (e)
            e.preventDefault();
        popup.style.display = 'none';
        document.body.style.overflow = 'auto';

        // Gui callback neu có (VD: reload trang)
        if (onCloseCallback && typeof onCloseCallback === 'function') {
            onCloseCallback();
        }
    }

    // Gan cho tat ca nút mo popup
    if (openButtonClass) {
        const openButtons = document.querySelectorAll('.' + openButtonClass);
        openButtons.forEach(btn => {
            btn.addEventListener('click', openPopup);
        });
    }

    // G?n nút ?óng
    if (closeBtn) {
        closeBtn.addEventListener('click', closePopup);
    }

    // ?óng khi click n?n
    popup.addEventListener('click', function (e) {
        if (e.target === popup)
            closePopup(e);
    });

    // Ch?n click trong modal
    if (modal) {
        modal.addEventListener('click', e => e.stopPropagation());
    }

    // ?óng b?ng ESC
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && popup.style.display === 'flex') {
            closePopup(e);
        }
    });

    // Expose open/close functions globally
    window['open' + capitalizeFirstLetter(popupId)] = openPopup;
    window['close' + capitalizeFirstLetter(popupId)] = closePopup;
}

// Helper function ?? vi?t hoa ch? cái ??u
function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

// Khoi tao tat ca popups khi DOM loaded
document.addEventListener('DOMContentLoaded', function () {
    // Khoi tao Bill Popup
    initPopup('billPopup', 'btnGenerateBill');

    // Khoi tao Verify Guest Popup
    initPopup('verifyGuestPopup', 'btnNewBooking');

    // Khoi taoo Booking Popup v?i reload khi ?óng
    initPopup('bookingPopup', null, function () {
        // Reload trang ?? xóa flash session
        window.location.href = window.location.pathname + '?tab=bookings';
    });

    // Khoi tao Create Guest Popup v?i reload khi ?óng (n?u có)
    initPopup('guestPopup', null, function () {
        // chi reload neu popup thuc su duocc dóng (không back)
        window.location.href = window.location.pathname + '?tab=bookings';
    });
});