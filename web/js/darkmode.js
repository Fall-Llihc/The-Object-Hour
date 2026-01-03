/**
 * Dark Mode - The Object Hour
 * Ultra Simple & Bulletproof
 */

// 1. Apply saved theme IMMEDIATELY
(function() {
    if (localStorage.getItem('darkMode') === 'true') {
        document.documentElement.classList.add('dark-mode');
    }
})();

// 2. Setup when page loads
window.onload = function() {
    
    // Get all toggle buttons
    var buttons = document.getElementsByClassName('dark-mode-toggle');
    
    // Update icons based on current state
    function updateIcons() {
        var isDark = document.documentElement.classList.contains('dark-mode');
        for (var i = 0; i < buttons.length; i++) {
            var icon = buttons[i].getElementsByTagName('i')[0];
            if (icon) {
                icon.className = isDark ? 'bi bi-sun-fill' : 'bi bi-moon-fill';
            }
        }
    }
    
    // Toggle dark mode
    function toggle() {
        var html = document.documentElement;
        if (html.classList.contains('dark-mode')) {
            html.classList.remove('dark-mode');
            localStorage.setItem('darkMode', 'false');
        } else {
            html.classList.add('dark-mode');
            localStorage.setItem('darkMode', 'true');
        }
        updateIcons();
        console.log('Dark mode toggled:', document.documentElement.classList.contains('dark-mode'));
    }
    
    // Attach click handlers to ALL buttons
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function(e) {
            e.preventDefault();
            toggle();
            return false;
        };
    }
    
    // Initial update
    updateIcons();
    console.log('Dark mode ready. Buttons found:', buttons.length);
    
    // Expose for console testing
    window.toggleDarkMode = toggle;
};