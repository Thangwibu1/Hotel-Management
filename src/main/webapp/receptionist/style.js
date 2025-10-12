
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