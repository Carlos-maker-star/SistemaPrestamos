<%-- 
    Document   : prestamoAdmin
    Created on : 25 mar. 2025, 10:48:16
    Author     : CARLOS RIVADENEYRA
--%>

<%@page import="models.Usuario"%>
<%@page import="dao.UsuarioDAO"%>
<%@page import="models.Prestamo"%>
<%@page import="java.util.ArrayList"%>
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
        <!-- Tables CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/dataTables.bootstrap4.css">
        <!-- Simple bar CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/simplebar.css" />
        <!-- Fonts CSS -->
        <link
            href="https://fonts.googleapis.com/css2?family=Overpass:ital,wght@0,100;0,200;0,300;0,400;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <!-- Icons CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/feather.css" />
        <!-- Date Range Picker CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/daterangepicker.css" />
        <!-- App CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app-light.css" id="lightTheme" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app-dark.css" id="darkTheme" disabled />

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

    <!-- Registrar: Mensaje Registro Prestamo -->
    <%
        String mensajePrestamo = (String) session.getAttribute("mensajePrestamo");
        String icon = (String) session.getAttribute("icon");
        if (mensajePrestamo != null || icon != null) {

            // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
            session.removeAttribute("mensajePrestamo");
            session.removeAttribute("icon");
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%= mensajePrestamo%>",
                icon: "<%= icon%>",
                timer: 2000,
                showConfirmButton: false
            });
        });
    </script>
    <%  }%>

    <!-- Actualizar Estado Prestamo: Mensaje -->
    <%
        String mensajeEstado = (String) session.getAttribute("mensajeEstado");
        String iconEstado = (String) session.getAttribute("icon");
        if (mensajeEstado != null || iconEstado != null) {

            // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
            session.removeAttribute("mensajeEstado");
            session.removeAttribute("icon");
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%=mensajeEstado%>",
                icon: "<%=icon%>",
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
                                Aquí podrás administrar el listado de Prestamos de manera sencilla y eficiente. Agrega, edita o elimina clientes según sea necesario, manteniendo siempre la información organizada 🚀
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
                                            <i class="fe fe-user mr-2"></i>Registrar Prestamo
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
                                                        <form action="<%=request.getContextPath()%>/PrestamoServlet?accion=registrar" method="POST">
                                                            <div class="form-row">
                                                                <div class="form-group col-md-6">
                                                                    <label>Cliente</label>
                                                                    <select class="form-control" id="usuario" name="idUsuario" required>
                                                                        <option value="">Seleccione un cliente</option>
                                                                        <%
                                                                            UsuarioDAO usuarioDAO = new UsuarioDAO();
                                                                            ArrayList<Usuario> listaUsuarios = usuarioDAO.listaUsuarios("CLIENTE");
                                                                            for (Usuario u : listaUsuarios) {
                                                                        %>
                                                                        <option value="<%= u.getIdUsuario()%>"><%= u.getNombre()%></option>
                                                                        <% } %>
                                                                    </select>
                                                                </div>
                                                                <div class="form-group col-md-6">
                                                                    <label>Monto del Prestamo</label>
                                                                    <input
                                                                        type="number"
                                                                        class="form-control"
                                                                        placeholder="0.00" 
                                                                        id="monto"
                                                                        name="monto"
                                                                        step="0.01"
                                                                        oninput="calcularMontoTotal()"
                                                                        required
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="form-row">
                                                                <div class="form-group col-md-6">
                                                                    <label>Tasa de Interes (%)</label>
                                                                    <input
                                                                        type="number"
                                                                        class="form-control"
                                                                        id="tasaInteres"
                                                                        name="tasaInteres"
                                                                        step="0.01"
                                                                        value="10.00"
                                                                        readonly
                                                                        required
                                                                        />
                                                                </div>
                                                                <div class="form-group col-md-6">
                                                                    <label>Plazo Meses</label>
                                                                    <input
                                                                        type="number"
                                                                        class="form-control" 
                                                                        name="plazoMeses" 
                                                                        required
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="form-row">
                                                                <div class="form-group col-md-6">
                                                                    <label for="tipoGarantia" class="form-label">Tipo de Garantía</label>
                                                                    <select class="form-control" id="tipoGarantia" name="tipoGarantia" required>
                                                                        <option value="">Seleccione un tipo</option>
                                                                        <option value="Propiedad">Propiedad</option>
                                                                        <option value="Vehículo">Vehículo</option>
                                                                        <option value="Otro">Otro</option>
                                                                    </select>
                                                                </div>
                                                                <div class="form-group col-md-6">
                                                                    <label for="montoTotal">Monto Total a Pagar:</label>
                                                                    <input class="form-control" type="number" id="montoTotal" name="montoTotal" readonly>
                                                                </div>
                                                            </div>
                                                            <div class="row">

                                                                <div class="form-group col-md-6">
                                                                    <label for="valorGarantia" class="form-label">Valor Estimado de la Garantía</label>
                                                                    <input type="number" class="form-control" id="valorGarantia" name="valorGarantia" step="0.01" required>
                                                                </div>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="descripcionGarantia" class="form-label">Descripción de la Garantía</label>
                                                                <textarea class="form-control" id="descripcionGarantia" name="descripcionGarantia" rows="2" required></textarea>
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
                            <h2 class="mb-2 page-title">Listado de Prestamos</h2>
                            <%
                                // Recuperamos la Lista de Prestamos
                                ArrayList<Prestamo> prestamoLista = (ArrayList<Prestamo>) session.getAttribute("listaPrestamos");
                                String estadoSeleccionado = (String) session.getAttribute("estadoSeleccionado");
                            %>
                            <!-- Filtro por estado -->
                            <form method="GET" action="<%=request.getContextPath()%>/PrestamoServlet">
                                <input type="hidden" name="accion" value="listarPrestamos">
                                <label for="estado">Filtrar por estado:</label>
                                <select class="form-control" name="estado" id="estado" onchange="this.form.submit()" style="width: 200px;">
                                    <option value="" disabled <%= (estadoSeleccionado == null) ? "selected" : ""%>>Seleccionar</option>
                                    <option value="PENDIENTE"<%= "PENDIENTE".equals(estadoSeleccionado) ? "selected" : ""%>>Pendiente</option>
                                    <option value="APROBADO"<%= "APROBADO".equals(estadoSeleccionado) ? "selected" : ""%>>Aprobado</option>
                                    <option value="RECHAZADO"<%= "RECHAZADO".equals(estadoSeleccionado) ? "selected" : ""%>>Rechazado</option>
                                </select>
                            </form>
                            <form action="<%=request.getContextPath()%>/ExcelServlet" method="get" class="mt-3">
                                <input type="hidden" name="accion" value="exportarExcelPrestamos">
                                <button type="submit" class="btn mb-2 btn-outline-success">Exportar a Excel</button>
                            </form>
                            <div class="row my-4">
                                <div class="col-md-12">
                                    <div class="card shadow">
                                        <div class="card-body">
                                            <table class="table datatables" id="dataTable-1">
                                                <thead>
                                                    <tr>
                                                        <th>Id</th>
                                                        <th>Usuario</th>
                                                        <th>Telefono</th>
                                                        <th>Monto</th>
                                                        <th>Tasa de Interes</th>
                                                        <th>Plazo de Meses</th>
                                                        <th>Estado</th>
                                                        <th>Fecha Inicio</th>
                                                        <th>Monto Total</th>
                                                        <th>Acciones</th>
                                                    </tr>
                                                </thead>
                                                <tbody>

                                                    <%
                                                        int i = 1;
                                                        if (prestamoLista != null) {
                                                            for (Prestamo listPrestamo : prestamoLista) {%>
                                                    <tr>
                                                        <td><%= i++%></td>
                                                        <td><%= listPrestamo.getNombreUsuario()%></td>
                                                        <td><%= listPrestamo.getTelefonoUsuario()%></td>
                                                        <td><%= listPrestamo.getMonto()%></td>
                                                        <td><%= listPrestamo.getTasaInteres()%></td>
                                                        <td><%= listPrestamo.getPlazoMeses()%></td>
                                                        <td><%= listPrestamo.getEstado()%></td>
                                                        <td><%= listPrestamo.getFechaInicio()%></td>
                                                        <td><%= listPrestamo.getMontoTotal()%></td>
                                                        <td>
                                                            <% if ("PENDIENTE".equals(listPrestamo.getEstado())) {%>
                                                            <div class="dropdown">
                                                                <button class="btn btn-sm dropdown-toggle more-horizontal" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                    <span class="text-muted sr-only">Action</span>
                                                                </button>
                                                                <div class="dropdown-menu dropdown-menu-right">
                                                                    <form id="formPrestamo">
                                                                        <input type="hidden" name="id_usuario" value="<%= listPrestamo.getUsuarioId()%>">
                                                                        <input type="hidden" name="id_prestamo" value="<%= listPrestamo.getIdPrestamo()%>">
                                                                        <input type="hidden" name="plazo_meses" value="<%= listPrestamo.getPlazoMeses()%>">
                                                                        <input type="hidden" name="monto_total" value="<%= listPrestamo.getMontoTotal()%>">
                                                                        <input type="hidden" name="fecha_inicio" value="<%= listPrestamo.getFechaInicio()%>">

                                                                        <button class="dropdown-item" type="submit" name="accionEstado" value="APROBADO">Aprobar</button>
                                                                        <button class="dropdown-item" type="submit" name="accionEstado" value="RECHAZADO">Rechazar</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                            <% } else { %>
                                                            Sin acciones
                                                            <% } %>
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                                    <% }%>
                                                </tbody>
                                            </table>
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

        <!-- Para Calcular el Monto Total en Tiempo Real -->
        <script>
            function calcularMontoTotal() {
                let monto = parseFloat(document.getElementById("monto").value) || 0;
                let tasaInteres = 10.00;
                let montoTotalInput = document.getElementById("montoTotal");

                // Validar valores negativos
                if (monto < 0 || tasaInteres < 0) {
                    alert("El monto y la tasa de interés no pueden ser negativos.");
                    montoTotalInput.value = "";
                    return;
                }

                // Calcular el monto total
                let montoTotal = monto + (monto * (tasaInteres / 100));
                montoTotalInput.value = montoTotal.toFixed(2);
            }

            // Asegurar que los eventos se vinculen correctamente
            window.onload = function () {
                document.getElementById("monto").addEventListener("input", calcularMontoTotal);
            };
        </script>

        <script src="<%=request.getContextPath()%>/assets/js/apps.js"></script>
    </body>
</html>