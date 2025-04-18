<%-- 
    Document   : index
    Created on : 7 mar. 2025, 12:03:06
    Author     : CARLOS RIVADENEYRA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="es">
    <head>
        <title>Login</title>

        <!-- Favicons -->
        <link href="<%=request.getContextPath()%>/Logo_Empresa_CARMIC.png" rel="icon">

        <!-- Links -->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="https://unicons.iconscout.com/release/v2.1.9/css/unicons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/styles.css">

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.5.1"></script>
    </head>

    <body>

        <!-- *** RECUPERAR DATOS DE LA SESSION Y MOSTRAR MENSAJES *** -->
        <!-- Iniciar Sesion: Mensaje Login Error -->
        <%
            String mensajeLoginError = (String) session.getAttribute("mensajeLoginError");
            if (mensajeLoginError != null) { 
                
                // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
                session.removeAttribute("mensajeLoginError"); 
        %>
                <script>
                    Swal.fire({
                        icon: "error",
                        title: "Error de inicio de sesión",
                        text: "<%=mensajeLoginError%>"
                    });
                </script>
        <%  } %>

        <!-- Iniciar Sesion: Mensaje Login Exitoso -->
        <%
            String mensajeLoginExitoso = (String) session.getAttribute("mensajeLoginExitoso");
            String redirigirIndex = (String) session.getAttribute("paginaIndex");
            if (mensajeLoginExitoso != null && redirigirIndex != null) { 
                
                // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
                session.removeAttribute("mensajeLoginExitoso");
                session.removeAttribute("paginaIndex");
        %>
                
                <script>
                    Swal.fire({
                        title: "<%=mensajeLoginExitoso%>...",
                        text: "Por favor, espera...",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        showConfirmButton: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    // Redirigir a Pagina Index después de 3 segundos
                    setTimeout(() => {
                        window.location.href = "<%=redirigirIndex%>";
                    }, 3000);
                </script>
        <%  } %>
        
        <!-- Registrarse: Mensaje Registro Existoso -->
        <%   
            String mensajeRegistro = (String) session.getAttribute("mensajeRegistro");
            String iconRegistro = (String) session.getAttribute("iconRegistro");
            if (mensajeRegistro != null || iconRegistro != null) {

                // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
                session.removeAttribute("mensajeRegistro");
                session.removeAttribute("iconRegistro");
        %>
                <script>
                    if ("<%= iconRegistro %>" === "success") {
                        // Primera alerta
                        Swal.fire({
                            title: "Creando cuenta...",
                            text: "Un momento por favor...",
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            showConfirmButton: false,
                            timer: 3000,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        }).then(() => {
                            // Segunda Alerta con Cofeti
                            Swal.fire({
                                icon: "success",
                                title: "¡Felicidades!",
                                text: "<%=mensajeRegistro%>",
                                timer: 3000, 
                                showConfirmButton: false,
                                didOpen: () => {
                                    // Disparar confeti 🎉
                                    confetti({
                                        particleCount: 100,  // Cantidad de confeti
                                        spread: 70,          // Ángulo de dispersión
                                        origin: { y: 0.6 }   // Altura desde donde cae
                                    });
                                }
                            });
                        });
                    } else if ("<%= iconRegistro %>" === "warning") {
                        Swal.fire({
                            icon: "<%= iconRegistro %>",
                            title: "¡Intentar de Nuevo!",
                            text: "<%= mensajeRegistro %>",
                            showConfirmButton: true
                        });
                    } else if ("<%= iconRegistro %>" === "error") {
                        Swal.fire({
                            icon: "<%= iconRegistro %>",
                            title: "¡Error!",
                            text: "<%= mensajeRegistro %>",
                            showConfirmButton: true
                        });
                    }
                </script>
        <%  } %>

        <div class="section">
            <div class="container">
                <div class="row full-height justify-content-center">
                    <div class="col-12 text-center align-self-center py-5">
                        <div class="section pb-5 pt-5 pt-sm-2 text-center">
                            <h6 class="mb-0 pb-3"><span>Log In </span><span>Sign Up</span></h6>
                            <input class="checkbox" type="checkbox" id="reg-log" name="reg-log"/>
                            <label for="reg-log"></label>
                            <div class="card-3d-wrap mx-auto">
                                <div class="card-3d-wrapper">
                                    <div class="card-front">
                                        <div class="center-wrap">
                                            <form class="section text-center" action="<%=request.getContextPath()%>/UsuarioServlet?accion=login" method="POST">
                                                <h4 class="mb-4 pb-3">Iniciar Sesion</h4>
                                                <div class="form-group">
                                                    <input type="email" class="form-style" placeholder="Correo" name="correo" required>
                                                    <i class="input-icon uil uil-at"></i>
                                                </div>	
                                                <div class="form-group mt-2">
                                                    <input type="password" class="form-style" placeholder="Password" name="password" required>
                                                    <i class="input-icon uil uil-lock-alt"></i>
                                                </div>
                                                <button type="submit" class="btn mt-4">Login</button>
                                                <p class="mb-0 mt-4 text-center"><a href="" class="link">Te olvidaste tu contraseña?</a></p>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="card-back">
                                        <div class="center-wrap">
                                            <form class="section text-center" action="<%=request.getContextPath()%>/UsuarioServlet?accion=registrarCliente" method="POST">
                                                <h4 class="mb-3 pb-3">Registrate</h4>
                                                <div class="form-group">
                                                    <input type="text" class="form-style" placeholder="Nombres Completos" name="nombres" required>
                                                    <i class="input-icon uil uil-user"></i>
                                                </div>	
                                                <div class="form-group mt-2">
                                                    <input type="tel" class="form-style" placeholder="Telefono" name="telefono" maxlength="9" required>
                                                    <i class="input-icon uil uil-phone"></i>
                                                </div>	
                                                <div class="form-group mt-2">
                                                    <input type="email" class="form-style" placeholder="Correo" name="correo" required>
                                                    <i class="input-icon uil uil-at"></i>
                                                </div>
                                                <div class="form-group mt-2">
                                                    <input type="password" class="form-style" placeholder="Password" name="password" required>
                                                    <i class="input-icon uil uil-lock-alt"></i>
                                                </div>
                                                <button type="submit" class="btn mt-4">Crear Cuenta</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

