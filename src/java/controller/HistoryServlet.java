/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Rei Sarah
 */

import dao.HistoryDAO;
import model.History;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class HistoryServlet extends HttpServlet {

    private final HistoryDAO historyDAO = new HistoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // BELUM LOGIN
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // AMBIL USER DARI SESSION
        User user = (User) session.getAttribute("user");
        Long userId = user.getId();

        // AMBIL HISTORY
        List<History> historyList = historyDAO.getUserHistory(userId);
        request.setAttribute("historyList", historyList);

        // FORWARD KE JSP
        request.getRequestDispatcher("/Customer/history.jsp")
               .forward(request, response);
    }
}

