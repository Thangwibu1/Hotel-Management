
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

document.querySelectorAll('.status .badge').forEach(badge=>{
  const s = badge.textContent.trim().toLowerCase();
  badge.classList.remove('green','gray','yellow','red');
  if (s === 'available')      badge.classList.add('green');
  else if (s === 'occupied')  badge.classList.add('gray');
  else if (s === 'dirty')     badge.classList.add('yellow');
  else if (s === 'maintenance') badge.classList.add('red'); // ho?c gray
  else                        badge.classList.add('gray');
});

// ====== M? POPUP ======
document.addEventListener('DOMContentLoaded', function() {
  const popup = document.getElementById('billPopup');
  if (!popup) return; // N?u popup ch?a t?n t?i, d?ng luôn (tránh l?i)

  const modal = popup.querySelector('.bill-modal');
  const openButtons = document.querySelectorAll('.btnGenerateBill');
  const closeBtn = popup.querySelector('.bill-close');

  function openBillPopup(e) {
    e.preventDefault();
    popup.style.display = 'flex';
    document.body.style.overflow = 'hidden';
  }

  function closeBillPopup(e) {
    e.preventDefault();
    popup.style.display = 'none';
    document.body.style.overflow = 'auto';
  }

  // G?n cho t?t c? nút m? popup
  openButtons.forEach(btn => {
    btn.addEventListener('click', openBillPopup);
  });

  // G?n nút ?óng n?u có
  if (closeBtn) closeBtn.addEventListener('click', closeBillPopup);

  // ?óng khi click n?n
  popup.addEventListener('click', function(e) {
    if (e.target === popup) closeBillPopup(e);
  });

  // Ch?n click trong modal
  if (modal) modal.addEventListener('click', e => e.stopPropagation());

  // ?óng b?ng ESC
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeBillPopup(e);
  });
});

