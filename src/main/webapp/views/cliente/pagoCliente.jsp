<%-- 
    Document   : pagoCliente
    Created on : 27 mar. 2025, 20:50:12
    Author     : CARLOS RIVADENEYRA
--%>

<%@page import="models.Prestamo"%>
<%@page import="dao.PrestamoDAO"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="models.Pago"%>
<%@page import="models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Carmic | Cliente</title>
        <link rel="icon" href="<%=request.getContextPath()%>/assets/img/Logo_Empresa_CARMIC.png"/>
        <title>Carmic | Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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

    <!-- Pago: Pagar Cuota del Pago -->
    <%
        String mensajePago = (String) session.getAttribute("mensajePago");
        String iconPago = (String) session.getAttribute("iconPago");
        if (mensajePago != null || iconPago != null) {

            // Eliminar mensaje de la sesion para que no aparesca al recargar la pagina
            session.removeAttribute("mensajePago");
            session.removeAttribute("iconPago");
    %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: "<%= mensajePago%>",
                icon: "<%= iconPago%>",
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
                            </div>
                        </div>
                        <div class="col-12">
                            <h2 class="mb-2 page-title">Listado de Pagos</h2>
                            <%
                                // Recuperamos la Lista de las Fechas
                                ArrayList<Pago> pagoLista = (ArrayList<Pago>) session.getAttribute("listaPagos");
                                Date fechaSeleccionado = (Date) session.getAttribute("fechaSeleccionado");
                            %>
                            <!-- Filtro por Fecha Inicio de Prestamo -->
                            <form method="GET" action="<%=request.getContextPath()%>/PagoServlet">
                                <input type="hidden" name="accion" value="listarPagosCliente">
                                <label>Filtrar por Fecha de Prestamo:</label>
                                <select class="form-control" id="fechaInicio" name="fechaInicio" style="width: 200px;" required onchange="this.form.submit()">
                                    <option value="">Seleccionar</option>
                                    <%
                                        PrestamoDAO prestamoDAO = new PrestamoDAO();
                                        ArrayList<Prestamo> listaFechas = prestamoDAO.obtenerFechasPrestamos(usuario.getIdUsuario());
                                        for (Prestamo list : listaFechas) {
                                    %>
                                    <option value="<%= list.getFechaInicio()%>"
                                            <%= (fechaSeleccionado != null && list.getFechaInicio().equals(fechaSeleccionado)) ? "selected" : ""%>>
                                        <%= list.getFechaInicio()%>
                                    </option>
                                    <% } %>
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
                                                        <th>Monto de Pago</th>
                                                        <th>Fecha de Pago</th>
                                                        <th>Estado</th>
                                                        <th>Accion</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        Pago pagoAnterior = null;
                                                        int i = 1;
                                                        if (pagoLista != null) {
                                                            for (Pago listPago : pagoLista) {
                                                                // Verificar si la cuota anterior está pagada
                                                                boolean puedePagar = false;

                                                                if (pagoAnterior != null && "PAGADO".equals(pagoAnterior.getEstado())) {
                                                                    puedePagar = true; // Solo se puede pagar si la cuota anterior está PAGADA
                                                                } else if (pagoAnterior == null) {
                                                                    puedePagar = true; // La primera cuota puede pagarse sin restricciones
                                                                }%>
                                                    <tr>
                                                        <td><%= i++%></td>
                                                        <td><%= listPago.getMontoPago()%></td>
                                                        <td><%= listPago.getFechaPago()%></td>
                                                        <td><%= listPago.getEstado()%></td>
                                                        <td>
                                                            <% if ("PENDIENTE".equals(listPago.getEstado())) {%>
                                                            <% if (puedePagar) {%>
                                                            <button class="btn btn-success btn-sm" data-toggle="modal" data-target="#pagarModal" 
                                                                    data-id="<%= listPago.getIdPago()%>"
                                                                    data-monto="<%= listPago.getMontoPago()%>"
                                                                    data-inicio="<%= listPago.getFechaInicioPrestamo() != null ? listPago.getFechaInicioPrestamo().toString() : ""%>"
                                                                    data-fecha="<%= listPago.getFechaPago()%>"
                                                                    data-estado="<%= listPago.getEstado()%>">
                                                                Pagar
                                                            </button>
                                                            <% } else { %>
                                                            <i class="fas fa-times-circle"></i>
                                                            <% } %>
                                                            <% } else { %>
                                                                <a href="<%=request.getContextPath()%>/PagoServlet?accion=generarVoucher&idPago=<%= listPago.getIdPago() %>"
                                                                   class="btn btn-primary btn-sm" target="_blank">
                                                                    Descargar Voucher
                                                                </a>
                                                                <a href="#" class="btn btn-outline-dark btn-sm" data-toggle="modal"
                                                                   data-target="#verQRModal"
                                                                   data-id="<%= listPago.getIdPago()%>">
                                                                    <i class="fas fa-qrcode"></i> Ver QR
                                                                </a>
                                                            <% }
                                                                // Actualizamos la cuota anterior
                                                                pagoAnterior = listPago;
                                                            %>
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

                            <!-- Modal -->
                            <div class="modal fade" id="pagarModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" style="max-width: 380px;">
                                    <div class="modal-content">
                                        <form action="<%=request.getContextPath()%>/PagoServlet?accion=pagarCuota" method="POST">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Confirmar Pago</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                            <div class="modal-body">
                                                <p class="form-control">Está a punto de pagar un monto de <strong id="montoPago"></strong>.</p>
                                                <p class="form-control">Fecha de límite de pago: <strong id="fechaPagoOriginalText"></strong></p>
                                                <p class="form-control">Fecha de pago: <strong id="fechaPagoActual"></strong></p>
                                                <p class="form-control">Estado: <strong id="estadoPago"></strong></p>

                                                <!-- Inputs ocultos -->
                                                <input type="hidden" name="idPago" id="idPagoInput">
                                                <input type="hidden" name="fechaPagoOriginal" id="fechaPagoOriginal">
                                                <input type="hidden" name="fechaPagoInput" id="fechaPagoInput">
                                                <input type="hidden" name="fechaInicioS" id="fechaInicioS">
                                            </div>
                                            <div class="modal-footer d-flex justify-content-center">
                                                <button type="submit" class="btn btn-success">Pagar</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- Modal para el QR -->
                            <div class="modal fade" id="verQRModal" tabindex="-1" role="dialog" aria-labelledby="verQRLabel" aria-hidden="true">
                                <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
                                    <div class="modal-content text-center">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Código QR del Pago</h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <img id="qrImagen" src="" alt="QR del pago" class="img-fluid" />
                                            <p class="mt-2">Escanea este código para ver los datos del pago.</p>
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

        <!-- Script para el Modal de Confirmar Pago -->
        <script>
            $('#pagarModal').on('show.bs.modal', function (event) {
                const hoy = new Date();
                const fechaActual = hoy.getFullYear() + '-' +
                    String(hoy.getMonth() + 1).padStart(2, '0') + '-' +
                    String(hoy.getDate()).padStart(2, '0');

                var button = $(event.relatedTarget);
                var fechaPagoOriginal = button.data('fecha');
                var idPago = button.data('id');
                var montoPago = button.data('monto');
                var estadoPago = button.data('estado');
                var fechaInicio = button.data('inicio');

                console.log("fechaPagoOriginal: " + fechaPagoOriginal);
                console.log("idPago: " + idPago);
                console.log("montoPago: " + montoPago);
                console.log("estadoPago: " + estadoPago);
                console.log("fechaInicio: " + fechaInicio);
                var modal = $(this);

                // Muestra en el modal
                modal.find('#montoPago').text(montoPago);
                modal.find('#fechaPagoOriginalText').text(fechaPagoOriginal); // Usa un span con este ID para mostrar
                modal.find('#fechaPagoActual').text(fechaActual);
                modal.find('#estadoPago').text(estadoPago);

                // Inputs ocultos que van al servlet
                modal.find('#idPagoInput').val(idPago); // input hidden
                modal.find('#fechaPagoOriginal').val(fechaPagoOriginal); // input hidden
                modal.find('#fechaPagoInput').val(fechaActual); // input hidden
                modal.find('#fechaInicioS').val(fechaInicio); // input hidden
            });
        </script>

        <!-- Script para el QR de las Cuotas Pagadas -->
        <script>
            $('#verQRModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget);
                var idPago = button.data('id');

                var qrUrl = '<%= request.getContextPath() %>/PagoServlet?accion=verQR&idPago=' + idPago;
                $('#qrImagen').attr('src', qrUrl);
            });
        </script>

        <script src="<%=request.getContextPath()%>/assets/js/apps.js"></script>
    </body>
</html>
