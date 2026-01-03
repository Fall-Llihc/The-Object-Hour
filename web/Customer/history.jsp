<%-- 
    Document   : history
    Created on : Jan 3, 2026, 10:11:59 PM
    Author     : Rei Sarah
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.util.*, model.History" %>
<h2>History Pembelian</h2>

<%
    List<History> list = (List<History>) request.getAttribute("historyList");
    if (list == null || list.isEmpty()) {
%>
    <p>Belum ada pembelian.</p>
<%
    } else {
%>
<table border="1" cellpadding="6">
    <tr>
        <th>ID</th>
        <th>Total</th>
        <th>Metode</th>
        <th>Tanggal</th>
        <th>Alamat</th>
    </tr>
<%
    for (History h : list) {
%>
    <tr>
        <td><%= h.getId() %></td>
        <td><%= h.getTotalAmount() %></td>
        <td><%= h.getPaymentMethod() %></td>
        <td><%= h.getPaidAt() %></td>
        <td><%= h.getShippingAddress() %></td>
    </tr>
<%
    }
%>
</table>
<%
    }
%>

