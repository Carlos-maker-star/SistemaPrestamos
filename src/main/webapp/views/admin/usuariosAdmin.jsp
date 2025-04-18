<%-- 
    Document   : clienteAdmin
    Created on : 20 mar. 2025, 18:50:36
    Author     : CARLOS RIVADENEYRA
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8" />
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no"
            />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <link rel="icon" href="<%=request.getContextPath()%>/assets/img/Logo_Empresa_CARMIC.png"/>
        <title>Carmic | Admin</title>
        <link
            href="https://fonts.googleapis.com/css2?family=Overpass:ital,wght@0,100;0,200;0,300;0,400;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/dataTables.bootstrap4.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/simplebar.css" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/feather.css" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/daterangepicker.css" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app-light.css" id="lightTheme" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app-dark.css" id="darkTheme" disabled />

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.5.1"></script>
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

    <!-- Registrarse: Mensaje Registro -->
    <%
        String mensajeRegistro = (String) session.getAttribute("mensajeRegistro");
        String iconRegistro = (String) session.getAttribute("iconRegistro");
        if (mensajeRegistro != null || iconRegistro != null) {

            // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
            session.removeAttribute("mensajeRegistro");
            session.removeAttribute("iconRegistro");
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%= mensajeRegistro%>",
                icon: "<%= iconRegistro%>",
                timer: 2000,
                showConfirmButton: false
            });
        });
    </script>
    <%  } %>

    <!-- Eliminar Usuario: Mensaje Eliminar -->
    <%   String mensajeEliminado = (String) session.getAttribute("mensajeEliminado");
        if (mensajeEliminado != null) {

            // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
            session.removeAttribute("mensajeEliminado");
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%= mensajeEliminado%>",
                icon: "success",
                timer: 2000,
                showConfirmButton: false,
            });
        });
    </script>
    <%  } %>


    <!-- Editar Usuario: Mensaje Editado -->
    <%
        String mensajeEditado = (String) session.getAttribute("mensajeEditado");
        String icon = (String) session.getAttribute("icon");
        if (mensajeEditado != null || icon != null) {

            // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
            session.removeAttribute("mensajeEditado");
            session.removeAttribute("icon");
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%= mensajeEditado%>",
                icon: "<%= icon%>",
                timer: 2000,
                showConfirmButton: false
            });
        });
    </script>
    <%  }%>
    <body class="vertical light">
        <div class="wrapper">

            <!-- Sub Menu Admin-->
            <%@include file="subMenuAdmin.jsp"%>

            <main role="main" class="main-content">
                <div class="container-fluid">
                    <div class="row justify-content-center">
                        <div class="col-12">
                            <h2 class="h5 page-title">Informaciones Adicionales: <%= usuario.getNombre()%></h2>
                            <p>
                                Aquí podrás administrar el listado de clientes de manera sencilla y eficiente. Agrega, edita o elimina clientes según sea necesario, manteniendo siempre la información organizada 🚀
                            </p>
                            <div class="row">
                                <div class="col-md-6 col-xl-3 mb-4">
                                    <div class="card shadow bg-primary text-white">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-3 text-center">
                                                    <span class="circle circle-sm bg-primary-light">
                                                        <i
                                                            class="fe fe-user fe-shopping-bag text-white mb-0"
                                                            ></i>
                                                    </span>
                                                </div>
                                                <div class="col pr-0">
                                                    <p class="small text-light mb-0">Clientes</p>
                                                    <span class="h3 mb-0 text-white">10</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-xl-3 mb-4">
                                    <div class="card shadow">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-3 text-center">
                                                    <span class="circle circle-sm bg-primary">
                                                        <i
                                                            class="fe fe-16 fe-shopping-cart text-white mb-0"
                                                            ></i>
                                                    </span>
                                                </div>
                                                <div class="col pr-0">
                                                    <p class="small text-muted mb-0">Orders</p>
                                                    <span class="h3 mb-0">1,869</span>
                                                    <span class="small text-success">+16.5%</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-xl-3 mb-4">
                                    <div class="card shadow">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-3 text-center">
                                                    <span class="circle circle-sm bg-primary">
                                                        <i class="fe fe-16 fe-filter text-white mb-0"></i>
                                                    </span>
                                                </div>
                                                <div class="col">
                                                    <p class="small text-muted mb-0">Conversion</p>
                                                    <div class="row align-items-center no-gutters">
                                                        <div class="col-auto">
                                                            <span class="h3 mr-2 mb-0"> 86.6% </span>
                                                        </div>
                                                        <div class="col-md-12 col-lg">
                                                            <div
                                                                class="progress progress-sm mt-2"
                                                                style="height: 3px"
                                                                >
                                                                <div
                                                                    class="progress-bar bg-success"
                                                                    role="progressbar"
                                                                    style="width: 87%"
                                                                    aria-valuenow="87"
                                                                    aria-valuemin="0"
                                                                    aria-valuemax="100"
                                                                    ></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-xl-3 mb-4">
                                    <div class="card shadow">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-3 text-center">
                                                    <span class="circle circle-sm bg-primary">
                                                        <i class="fe fe-16 fe-activity text-white mb-0"></i>
                                                    </span>
                                                </div>
                                                <div class="col">
                                                    <p class="small text-muted mb-0">AVG Orders</p>
                                                    <span class="h3 mb-0">$80</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <div>
                                        <!-- Button trigger modal -->
                                        <button type="button" class="btn mb-2 btn-outline-success" data-toggle="modal" data-target="#verticalModal">
                                            <i class="fe fe-user mr-2"></i>Registrar Cliente
                                        </button>
                                        <!-- Modal -->
                                        <div
                                            class="modal fade"
                                            id="verticalModal"
                                            tabindex="-1"
                                            role="dialog"
                                            aria-labelledby="verticalModalTitle"
                                            aria-hidden="true"
                                            >
                                            <div
                                                class="modal-dialog modal-dialog-centered"
                                                role="document"
                                                >
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="verticalModalTitle">
                                                            Modal title
                                                        </h5>
                                                        <button
                                                            type="button"
                                                            class="close"
                                                            data-dismiss="modal"
                                                            aria-label="Close"
                                                            >
                                                            <span aria-hidden="true">&times;</span>
                                                        </button>
                                                    </div>
                                                    <div class="card-body">
                                                        <form action="<%=request.getContextPath()%>/UsuarioServlet?accion=registrar" method="POST">
                                                            <div class="form-row">
                                                                <div class="form-group col-md-6">
                                                                    <label>Nombres Completos</label>
                                                                    <input
                                                                        type="text"
                                                                        class="form-control"
                                                                        placeholder="Nombres Completos" 
                                                                        name="nombres"
                                                                        required
                                                                        />
                                                                </div>
                                                                <div class="form-group col-md-6">
                                                                    <label>Telefono</label>
                                                                    <input
                                                                        type="tel"
                                                                        class="form-control"
                                                                        placeholder="Telefono" 
                                                                        name="telefono"
                                                                        maxlength="9"
                                                                        required
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label>Correo</label>
                                                                <input
                                                                    type="text"
                                                                    class="form-control"
                                                                    placeholder="Correo" 
                                                                    name="correo"
                                                                    required
                                                                    />
                                                            </div>
                                                            <div class="form-group">
                                                                <label>Password</label>
                                                                <input
                                                                    type="password"
                                                                    class="form-control"
                                                                    placeholder="Password" 
                                                                    name="password" 
                                                                    required
                                                                    />
                                                            </div>
                                                            <button type="submit" class="btn btn-primary">Registrar</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <h2 class="mb-2 page-title">Listado de Clientes</h2>
                            <%
                                // Recuperamos la Lista de Usuario
                                ArrayList<Usuario> usuarioLista = (ArrayList<Usuario>) session.getAttribute("listaUsuarios");
                                String rolSeleccionado = (String) session.getAttribute("rolSeleccionado");
                            %>
                            <!-- Filtro por Rol -->
                            <form method="GET" action="<%=request.getContextPath()%>/UsuarioServlet">
                                <input type="hidden" name="accion" value="listarUsuarios">
                                <label for="rol">Filtrar por Rol:</label>
                                <select class="form-control" name="rol" id="rol" onchange="this.form.submit()" style="width: 200px;">
                                    <option value="" disabled <%= (rolSeleccionado == null) ? "selected" : ""%>>Seleccionar</option>
                                    <option value="CLIENTE"<%= "CLIENTE".equals(rolSeleccionado) ? "selected" : ""%>>Cliente</option>
                                    <option value="ADMIN"<%= "ADMIN".equals(rolSeleccionado) ? "selected" : ""%>>Admin</option>
                                </select>
                            </form>
                            <div class="row my-4">
                                <div class="col-md-12">
                                    <div class="card shadow">
                                        <div class="card-body">
                                            <table class="table datatables" id="dataTable-1">
                                                <thead>
                                                    <tr>
                                                        <th>Id</th>
                                                        <th>Nombre</th>
                                                        <th>Telefono</th>
                                                        <th>Correo</th>
                                                        <th>Rol</th>
                                                        <th>Estado</th>
                                                        <th>Acciones</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        int i = 1;
                                                        if (usuarioLista != null) {
                                                            for (Usuario listUser : usuarioLista) {%>
                                                    <tr>
                                                        <td><%= i++%></td>
                                                        <td><%= listUser.getNombre()%></td>
                                                        <td><%= listUser.getTelefono()%></td>
                                                        <td><%= listUser.getCorreo()%></td>
                                                        <td><%= listUser.getRol()%></td>
                                                        <td><%= listUser.getEstado()%></td>
                                                        <td>
                                                            <button class="btn btn-sm dropdown-toggle more-horizontal" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <span class="text-muted sr-only">Action</span>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-right">
                                                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#editClientModal" 
                                                                   onclick="editarCliente('<%= listUser.getIdUsuario()%>',
                                                                                   '<%= listUser.getNombre()%>',
                                                                                   '<%= listUser.getTelefono()%>',
                                                                                   '<%= listUser.getCorreo()%>',
                                                                                   '<%= listUser.getEstado()%>')">Editar</a>
                                                                <a class="dropdown-item" href="<%=request.getContextPath()%>/UsuarioServlet?accion=eliminar&id=<%= listUser.getIdUsuario()%>">Eliminar</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%  } %>
                                                    <% }%>
                                                </tbody>
                                            </table>
                                            <!-- Modal para Editar Cliente -->
                                            <div class="modal fade" id="editClientModal" tabindex="-1" role="dialog" aria-labelledby="editClientModalTitle" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editClientModalTitle">Editar Cliente</h5>
                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                <span aria-hidden="true">&times;</span>
                                                            </button>
                                                        </div>
                                                        <div class="card-body">
                                                            <form action="<%=request.getContextPath()%>/UsuarioServlet?accion=editar" method="POST">
                                                                <input type="hidden" id="editId" name="idUsuario">
                                                                <div class="form-group">
                                                                    <label for="editName">Nombre</label>
                                                                    <input type="text" class="form-control" id="editName" name="nombre" placeholder="Nombre" required>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="editPhone">Teléfono</label>
                                                                    <input type="text" class="form-control" id="editPhone" name="telefono" placeholder="Teléfono" maxlength="9" required>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="form-group col-md-6">
                                                                        <label for="editEmail">Correo</label>
                                                                        <input type="email" class="form-control" id="editEmail" name="correo" placeholder="Correo" required>
                                                                    </div>
                                                                    <div class="form-group col-md-6">
                                                                        <label for="editEstado">Estado</label>
                                                                        <select class="form-control" id="editEstado" name="estado">
                                                                            <option value="ACTIVO">Activo</option>
                                                                            <option value="SUSPENDIDO">Suspendido</option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                                <!-- Otros campos que necesites -->
                                                                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
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

                    </div>
                </div>
            </main>
        </div>

        <!-- Script Oblitorios -->
        <script src="<%=request.getContextPath()%>/assets/js/jquery.min.js"></script>  
        <script src="<%=request.getContextPath()%>/assets/js/popper.min.js"></script>  
        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.min.js"></script>  
        <script src="<%=request.getContextPath()%>/assets/js/jquery.dataTables.min.js"></script>  
        <script src="<%=request.getContextPath()%>/assets/js/dataTables.bootstrap4.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tinycolor-min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/config.js"></script>

        <!-- Formato de la Tabla -->
        <script>
                                                                       $(document).ready(function () {
                                                                           $('#dataTable-1').DataTable({
                                                                               responsive: true,
                                                                               autoWidth: true,
                                                                               "lengthMenu": [
                                                                                   [16, 32, 64, -1],
                                                                                   [16, 32, 64, "Todos"]
                                                                               ],
                                                                               language: {
                                                                                   "sProcessing": "Procesando...",
                                                                                   "sLengthMenu": "Mostrar _MENU_ registros",
                                                                                   "sZeroRecords": "No se encontraron resultados",
                                                                                   "sEmptyTable": "Ningún dato disponible en esta tabla",
                                                                                   "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                                                                                   "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                                                                                   "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
                                                                                   "sInfoPostFix": "",
                                                                                   "sSearch": "Buscar:",
                                                                                   "sUrl": "",
                                                                                   "sInfoThousands": ",",
                                                                                   "sLoadingRecords": "Cargando...",
                                                                                   "oPaginate": {
                                                                                       "sFirst": "Primero",
                                                                                       "sLast": "Último",
                                                                                       "sNext": "Siguiente",
                                                                                       "sPrevious": "Anterior"
                                                                                   },
                                                                                   "oAria": {
                                                                                       "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                                                                                       "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                                                                                   }
                                                                               },
                                                                               columnDefs: [
                                                                                   {targets: 'no-sort', orderable: false}
                                                                               ]
                                                                           });
                                                                       });
        </script>

        <!-- Modo Oscuro -->
        <script>
            var uptarg = document.getElementById('drag-drop-area');
            if (uptarg)
            {
                var uppy = Uppy.Core().use(Uppy.Dashboard,
                        {
                            inline: true,
                            target: uptarg,
                            proudlyDisplayPoweredByUppy: false,
                            theme: 'dark',
                            width: 770,
                            height: 210,
                            plugins: ['Webcam']
                        }).use(Uppy.Tus,
                        {
                            endpoint: 'https://master.tus.io/files/'
                        });
                uppy.on('complete', (result) =>
                {
                    console.log('Upload complete! We’ve uploaded these files:', result.successful)
                });
            }
        </script>

        <!-- JS Editar Cliente -->
        <script>
            function editarCliente(id, nombre, telefono, correo, estado) {
                // Establecer un campo oculto para el ID
                document.getElementById('editId').value = id;
                // Rellenar los campos del formulario con los datos del cliente
                document.getElementById('editName').value = nombre;
                document.getElementById('editPhone').value = telefono;
                document.getElementById('editEmail').value = correo;
                document.getElementById('editEstado').value = estado;
            }
        </script>
        <script src="<%=request.getContextPath()%>/assets/js/apps.js"></script>
    </body>
</html>

