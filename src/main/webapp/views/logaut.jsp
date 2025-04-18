<%-- 
    Document   : logaut
    Created on : 27 mar. 2025, 21:12:01
    Author     : CARLOS RIVADENEYRA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Carmic | Logaut</title>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>

    <!-- Cerrar Sesion: Mensaje Salir -->
    <%
        String mensajeSalir = (String) session.getAttribute("mensajeSalir");
        if (mensajeSalir != null) {
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%= mensajeSalir%>",
                text: "Por favor, espera...",
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Esperar 3 segundos antes de redirigir a login.jsp
            setTimeout(() => {
                window.location.href = "login.jsp";
            }, 3000);
        });
    </script>
    <%
            // Eliminamos el mensaje de la session
            session.removeAttribute("mensajeSalir");

            // Cerrar Sesion
            session.invalidate();
        }
    %>
    <body>
    </body>
</html>
