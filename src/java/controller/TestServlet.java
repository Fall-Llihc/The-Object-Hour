package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TestServlet", urlPatterns = {"/test", "/admin/test-connection"})
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<!DOCTYPE html>");
        response.getWriter().println("<html>");
        response.getWriter().println("<head>");
        response.getWriter().println("<title>Connection Test - PBO Project</title>");
        response.getWriter().println("<style>body{font-family:Arial;padding:20px;} .success{color:green;} .info{color:blue;}</style>");
        response.getWriter().println("</head>");
        response.getWriter().println("<body>");
        
        response.getWriter().println("<h1 class='success'>✅ Server & Context Working!</h1>");
        response.getWriter().println("<h2>Connection Information:</h2>");
        response.getWriter().println("<p><strong>Context Path:</strong> <span class='info'>" + request.getContextPath() + "</span></p>");
        response.getWriter().println("<p><strong>Servlet Path:</strong> <span class='info'>" + request.getServletPath() + "</span></p>");
        response.getWriter().println("<p><strong>Request URL:</strong> <span class='info'>" + request.getRequestURL() + "</span></p>");
        response.getWriter().println("<p><strong>Server Info:</strong> <span class='info'>" + request.getServletContext().getServerInfo() + "</span></p>");
        
        response.getWriter().println("<h2>Expected URLs:</h2>");
        response.getWriter().println("<ul>");
        response.getWriter().println("<li><a href='" + request.getContextPath() + "/'>Home Page</a></li>");
        response.getWriter().println("<li><a href='" + request.getContextPath() + "/auth/login'>Login Page</a></li>");
        response.getWriter().println("<li><a href='" + request.getContextPath() + "/admin/reports'>Admin Reports (needs login)</a></li>");
        response.getWriter().println("</ul>");
        
        response.getWriter().println("<h2>Troubleshooting Checklist:</h2>");
        response.getWriter().println("<ol>");
        response.getWriter().println("<li>✅ Server is running (you see this page)</li>");
        response.getWriter().println("<li>✅ Context path is: " + request.getContextPath() + "</li>");
        response.getWriter().println("<li>⚠️ Check if admin reports URL matches context path above</li>");
        response.getWriter().println("<li>⚠️ Make sure you're logged in as admin for /admin/reports</li>");
        response.getWriter().println("</ol>");
        
        response.getWriter().println("</body>");
        response.getWriter().println("</html>");
    }
}