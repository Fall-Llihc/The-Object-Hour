<%-- Dark Mode Component - Include this in all pages --%>
<%-- In HEAD section, add: --%>
<%-- <jsp:include page="/components/darkmode.jsp" /> --%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
<script>
    // Apply dark mode immediately before render
    if (localStorage.getItem('darkMode') === 'true') {
        document.documentElement.classList.add('dark-mode');
    }
</script>
<style>
    /* Critical Dark Mode Styles - Inline for immediate effect */
    html.dark-mode body { background-color: #0f172a !important; color: #e2e8f0 !important; }
    html.dark-mode nav, html.dark-mode .navbar, html.dark-mode .bg-white { background-color: #1e293b !important; }
    html.dark-mode .bg-gray-50, html.dark-mode .bg-gray-100 { background-color: #0f172a !important; }
    html.dark-mode .text-gray-900, html.dark-mode .text-gray-800, html.dark-mode .text-gray-700 { color: #f1f5f9 !important; }
    html.dark-mode .text-gray-600, html.dark-mode .text-gray-500 { color: #94a3b8 !important; }
    html.dark-mode .border-gray-200, html.dark-mode .border-gray-300 { border-color: #334155 !important; }
    html.dark-mode .card, html.dark-mode .dropdown-menu { background-color: #1e293b !important; border-color: #334155 !important; }
    html.dark-mode input, html.dark-mode textarea, html.dark-mode select { background-color: #334155 !important; border-color: #475569 !important; color: #f1f5f9 !important; }
    html.dark-mode footer { background-color: #1e293b !important; }
</style>
