const bookingForm = document.getElementById('bookingForm');
const bookingDateInput = document.getElementById('bookingDate');
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

document.addEventListener("DOMContentLoaded", () => {
    const roomCards = document.querySelectorAll(".room-card");
    const continueBtn = document.getElementById("continueBtn");
    const roomIdField = document.getElementById("selectedRoomId");

    roomCards.forEach(card => {
        card.addEventListener("click", () => {
            // B? ch?n các phòng khác
            roomCards.forEach(c => c.classList.remove("selected"));
            // Ch?n phòng này
            card.classList.add("selected");

            // L?y d? li?u t? data attributes
            const roomId = card.dataset.roomId;
//            const roomTypeId = card.dataset.roomTypeId;
            console.log( "roomiD: " +  roomId);
            // Gán vào hidden inputs
            roomIdField.value = roomId;

            continueBtn.disabled = false;
        });
    });
});

bookingForm.addEventListener('submit', function (event) {
    const todaySubmit = new Date();
    const year = todaySubmit.getFullYear();
    const month = String(todaySubmit.getMonth() + 1).padStart(2, '0');
    const day = String(todaySubmit.getDate()).padStart(2, '0');
    bookingDateInput.value = `${year}-${month}-${day}`;
});