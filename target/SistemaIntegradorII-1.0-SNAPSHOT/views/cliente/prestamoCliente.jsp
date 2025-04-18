<%-- 
    Document   : prestamoCliente
    Created on : 26 mar. 2025, 22:10:00
    Author     : CARLOS RIVADENEYRA
--%>

<%@page import="models.Prestamo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Carmic | Cliente</title>
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
    
    <!-- *** RECUPERAR DATOS DE LA SESSION Y MOSTRAR MENSAJES *** -->
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

    <body class="vertical light">
        <div class="wrapper">

            <!-- Sub Menu Cliente -->
            <%@include file="subMenuCliente.jsp"%>

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
                                                            Registra tu Prestamo
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
                                                        <form action="<%=request.getContextPath()%>/PrestamoServlet?accion=registrarPrestamoCliente" method="POST">
                                                            <div class="form-row">
                                                                <input type="hidden" id="idUsuario" name="idUsuario" value="<%= usuario.getIdUsuario()%>">
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
                                <input type="hidden" name="accion" value="listarPrestamosCliente">
                                <label for="estado">Filtrar por estado:</label>
                                <select class="form-control" name="estado" id="estado" onchange="this.form.submit()" style="width: 200px;">
                                    <option value="" disabled <%= (estadoSeleccionado == null) ? "selected" : ""%>>Seleccionar</option>
                                    <option value="PENDIENTE"<%= "PENDIENTE".equals(estadoSeleccionado) ? "selected" : ""%>>Pendiente</option>
                                    <option value="APROBADO"<%= "APROBADO".equals(estadoSeleccionado) ? "selected" : ""%>>Aprobado</option>
                                    <option value="RECHAZADO"<%= "RECHAZADO".equals(estadoSeleccionado) ? "selected" : ""%>>Rechazado</option>
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
                                                        <th>Usuario</th>
                                                        <th>Telefono</th>
                                                        <th>Monto</th>
                                                        <th>Tasa de Interes</th>
                                                        <th>Plazo de Meses</th>
                                                        <th>Estado</th>
                                                        <th>Fecha Inicio</th>
                                                        <th>Monto Total</th>
                                                        <th>Accion</th>
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
                                                            <a href="#" class="btn btn-info btn-sm verDetalle"
                                                               data-toggle="modal" data-target="#detalleModal"
                                                               data-id="<%= listPrestamo.getIdPrestamo() %>"
                                                               data-monto="<%= listPrestamo.getMontoTotal() %>"
                                                               data-interes="<%= listPrestamo.getTasaInteres() %>"
                                                               data-plazo="<%= listPrestamo.getPlazoMeses() %>"
                                                               data-estado="<%= listPrestamo.getEstado() %>"
                                                               data-fecha="<%= listPrestamo.getFechaInicio() %>"
                                                               data-fecha-prestamo="<%= listPrestamo.getFechaPrestamo() != null ? listPrestamo.getFechaPrestamo() : "" %>">
                                                                Ver Detalles
                                                            </a>
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
                        <!-- Modal Detalle del Préstamo -->
                        <div class="modal fade" id="detalleModal" tabindex="-1" role="dialog" aria-labelledby="detalleModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered" role="document">
                                <div class="modal-content text-left">
                                    <div class="modal-header" id="modalHeaderEstado">
                                        <h5 class="modal-title">
                                            <span id="iconoEstado" class="icono-estado"></span> Detalle del Préstamo
                                        </h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Monto:</strong> S/ <span id="detalleMonto"></span></p>
                                        <p><strong>Interés:</strong> <span id="detalleInteres"></span>%</p>
                                        <p><strong>Plazo:</strong> <span id="detallePlazo"></span> meses</p>
                                        <p><strong>Estado:</strong> <span id="detalleEstado"></span></p>
                                        <p><strong>Fecha de Solicitud:</strong> <span id="detalleFecha"></span></p>
                                        <p><strong>Fecha de Aprobación:</strong> <span id="detalleFechaPrestamo"></span></p>
                                        <div id="mensajeEstado" class="mt-2 font-weight-bold"></div>

                                        <!-- Botón para generar PDF, solo se muestra si el estado es "APROBADO" -->
                                        <div class="mt-3" id="btnGenerarPDF" style="display:none;">
                                            <a href="#" id="descargarPDF" class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-file-pdf"></i> Descargar PDF
                                            </a>
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

        <!-- Script para Rellenar Datos de Detalle Prestamo -->
        <script>
            document.querySelectorAll('.verDetalle').forEach(btn => {
                btn.addEventListener('click', function () {
                    const monto = this.dataset.monto;
                    const interes = this.dataset.interes;
                    const plazo = this.dataset.plazo;
                    const estado = this.dataset.estado;
                    const fecha = this.dataset.fecha;
                    const fechaPrestamo = this.dataset.fechaPrestamo;
                    const idPrestamo = this.dataset.id;

                    // Insertar datos
                    document.getElementById('detalleMonto').textContent = monto;
                    document.getElementById('detalleInteres').textContent = interes;
                    document.getElementById('detallePlazo').textContent = plazo;
                    document.getElementById('detalleEstado').textContent = estado;
                    document.getElementById('detalleFecha').textContent = fecha;

                    const fechaPrestamoElem = document.getElementById('detalleFechaPrestamo');
                    const mensajeEstadoElem = document.getElementById('mensajeEstado');
                    const header = document.getElementById('modalHeaderEstado');
                    const icono = document.getElementById('iconoEstado');

                    // Reset estilos y mensaje
                    header.classList.remove("bg-aprobado", "bg-pendiente", "bg-rechazado");
                    icono.textContent = "";
                    mensajeEstadoElem.textContent = "";

                    if (estado === "APROBADO") {
                        header.classList.add("bg-aprobado");
                        icono.textContent = "✅";
                        fechaPrestamoElem.textContent = fechaPrestamo || "—";
                        mensajeEstadoElem.textContent = "¡Préstamo aprobado!";
                        mensajeEstadoElem.className = "mt-2 text-light";

                        // Mostrar el botón de descargar PDF
                        document.getElementById('btnGenerarPDF').style.display = 'block';

                        // Agregar link al botón de PDF
                        document.getElementById('descargarPDF').href = "<%= request.getContextPath() %>/PrestamoServlet?accion=generarPDFPrestamo&idPrestamo=" + idPrestamo;

                    } else if (estado === "PENDIENTE") {
                        header.classList.add("bg-pendiente");
                        icono.textContent = "⏳";
                        fechaPrestamoElem.textContent = "EN LISTA DE ESPERA";
                        mensajeEstadoElem.textContent = "Tu solicitud está en evaluación.";
                        mensajeEstadoElem.className = "mt-2 text-dark";

                    } else if (estado === "RECHAZADO") {
                        header.classList.add("bg-rechazado");
                        icono.textContent = "❌";
                        fechaPrestamoElem.textContent = "—";
                        mensajeEstadoElem.textContent = "PRÉSTAMO RECHAZADO";
                        mensajeEstadoElem.className = "mt-2 text-dark";
                    }
                });
            });
        </script>

        <script src="<%=request.getContextPath()%>/assets/js/apps.js"></script>
    </body>
</html>
