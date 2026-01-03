<%-- Dark Mode Script Component - Include before </body> --%>
<script>
(function() {
    // Update icons based on current state
    function updateIcons() {
        var isDark = document.documentElement.classList.contains('dark-mode');
        var buttons = document.getElementsByClassName('dark-mode-toggle');
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
    }
    
    // Attach click handlers
    var buttons = document.getElementsByClassName('dark-mode-toggle');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = toggle;
    }
    
    // Initial update
    updateIcons();
    
    // Expose globally
    window.toggleDarkMode = toggle;
})();
</script>
