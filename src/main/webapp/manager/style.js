document.querySelectorAll('.tabs .tab[data-subtab]').forEach(btn => {
    btn.addEventListener('click', () => {
        const container = btn.closest('.tabs');
        container.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
    });
});
