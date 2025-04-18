<%-- 
    Document   : perfilCliente
    Created on : 26 mar. 2025, 22:10:16
    Author     : CARLOS RIVADENEYRA
--%>

<%@page import="models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <!-- *** RECUPERAR DATOS DE LA SESSION Y MOSTRAR MENSAJES *** -->
    <%
        // Obtener usuario de la sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Si no ha iniciado sesión, redirigir al index principal
        if (usuario == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        // Obtener URL actual
        String paginaActual = request.getRequestURI();
        String rol = usuario.getRol();

        // Definir rutas específicas para cada rol
        boolean esPaginaAdmin = paginaActual.contains("/admin/");
        boolean esPaginaCliente = paginaActual.contains("/cliente/");

        // Evitar que un ADMIN acceda a páginas de CLIENTE y viceversa
        if (esPaginaCliente && "ADMIN".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/views/admin/indexAdmin.jsp");
            return;
        }

        if (esPaginaAdmin && "CLIENTE".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/views/cliente/indexCliente.jsp");
            return;
        }
    %>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
