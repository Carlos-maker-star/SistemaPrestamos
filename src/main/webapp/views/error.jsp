<%-- 
    Document   : error
    Created on : 3 abr. 2025, 14:43:53
    Author     : CARLOS RIVADENEYRA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        <!-- MENSAJE DE SESSION DE ERROR - HOLA CAMBIO GITHUT -->
        <% String mensaje = (String) session.getAttribute("mensaje"); %>    
        <h1>Error: <%= mensaje %></h1>
    </body>
</html>
