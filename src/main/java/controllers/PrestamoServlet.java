/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import dao.GarantiaDAO;
import dao.PagoDAO;
import dao.PrestamoDAO;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.OutputStream;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import models.Garantia;
import models.Pago;
import models.Prestamo;
import models.Usuario;



/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class PrestamoServlet extends HttpServlet {

    PrestamoDAO prestamoDAO = new PrestamoDAO();
    GarantiaDAO garantiaDAO = new GarantiaDAO();
    PagoDAO pagoDAO = new PagoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Tipo de Accion
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "";
        }
        switch (accion) {

            // Metodos de Administrador
            case "listarPrestamos":
                listarPrestamosAdmin(request, response);
                break;
            case "registrar":
                registrarPrestamoAdmin(request, response);
                break;
            case "estadoPrestamo":
                aprobarPrestamoAdmin(request, response);
                break;

            // Metodos de Cliente
            case "listarPrestamosCliente":
                listarPrestamosCliente(request, response);
                break;
            case "registrarPrestamoCliente":
                registrarPrestamoCliente(request, response);
                break;
            case "generarPDFPrestamo":
                generarPDFPrestamo(request, response);
                break;
            default:
                response.sendRedirect("views/error.jsp");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    // **************************************************** FUNCIONES DE ADMINISTRADOR ***********************************************************
    private void listarPrestamosAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String estado = request.getParameter("estado");

        // Crear Session
        HttpSession session = request.getSession();

        if (estado == null) {
            // Valor por Defecto
            estado = "PENDIENTE";
        }
        System.out.println(estado);
        session.setAttribute("estadoSeleccionado", estado);

        // Lista de Prestamos
        ArrayList<Prestamo> prestamosLista = prestamoDAO.obtenerTodosPrestamos(estado);
        session.setAttribute("listaPrestamos", prestamosLista);
        response.sendRedirect("views/admin/prestamoAdmin.jsp");
    }

    private void registrarPrestamoAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear Session
        HttpSession session = request.getSession();
        String mensaje = "";
        String icon = "";

        // Datos Prestamo
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        double montoPrestamo = Double.parseDouble(request.getParameter("monto"));
        double tasaInteres = Double.parseDouble(request.getParameter("tasaInteres"));
        int plazoMeses = Integer.parseInt(request.getParameter("plazoMeses"));
        Date fechaInicio = new Date(System.currentTimeMillis());
        double montoTotal = Double.parseDouble(request.getParameter("montoTotal"));

        // Datos Garantia
        String tipoGarantia = request.getParameter("tipoGarantia");
        double valorGarantia = Double.parseDouble(request.getParameter("valorGarantia"));
        String descripcionGarantia = request.getParameter("descripcionGarantia");

        // Verificar Fecha de Prestamo
        boolean existePrestamo = prestamoDAO.verificarPrestamoFecha(idUsuario, fechaInicio);

        if (!existePrestamo) {
            // Rellenar Datos a Prestamo
            Prestamo prestamo = new Prestamo(idUsuario, montoPrestamo, tasaInteres, plazoMeses, fechaInicio, montoTotal);

            // Registrar Prestamo: Retorna el idPrestamo registrado
            int idPrestamo = prestamoDAO.registrarPrestamos(prestamo);

            if (idPrestamo > 0) {

                // Rellenar Datos a Garantia
                Garantia garantia = new Garantia(idPrestamo, tipoGarantia, descripcionGarantia, valorGarantia);

                // Registrar Garantia
                boolean garantiaRegistrada = garantiaDAO.registrarGarantia(garantia);

                if (garantiaRegistrada) {
                    mensaje = "Prestamo Registrado Exitosamente";
                    icon = "success";
                } else {
                    mensaje = "Error al Registrar la Garantia";
                    icon = "error";
                }

                session.setAttribute("mensajePrestamo", mensaje);
                session.setAttribute("icon", icon);
            } else {
                response.sendRedirect("error.jsp");
            }
        } else {
            session.setAttribute("mensajePrestamo", "Este Cliente ya tiene un prestamo Existente");
            session.setAttribute("icon", "error");
        }

        response.sendRedirect("PrestamoServlet?accion=listarPrestamos");
    }

    private void aprobarPrestamoAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear Session
        HttpSession session = request.getSession();
        String mensaje = "";

        // Obtener la fecha actual directamente
        Date fechaPrestamo = new Date(System.currentTimeMillis());

        // Datos
        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
        int idPrestamo = Integer.parseInt(request.getParameter("id_prestamo"));
        String estado = request.getParameter("accionEstado");
        int plazoMeses = Integer.parseInt(request.getParameter("plazo_meses"));
        double montoTotal = Double.parseDouble(request.getParameter("monto_total"));

        // Calcular Monto para cada Cuota
        double montoCouta = montoTotal / plazoMeses;

        // Agregamos datos al Prestamo
        Prestamo prestamo = new Prestamo(idPrestamo, estado);

        boolean actualizarEstado = false;

        if ("APROBADO".equals(estado)) {

            boolean clienteYaTieneHoy = prestamoDAO.clienteYaTienePrestamoAprobadoHoy(idUsuario);

            if (clienteYaTieneHoy) {
                mensaje = "Este cliente ya tiene un préstamo aprobado hoy. Prueba Mañana.";
                session.setAttribute("mensajeEstado", mensaje);
                session.setAttribute("icon", "error");
                response.sendRedirect("PrestamoServlet?accion=listarPrestamos");
                return;
            }

            mensaje = "PRESTAMO APROBADO";
            actualizarEstado = prestamoDAO.actualizarEstadoPrestamo(prestamo);

            if (actualizarEstado) {

                // Actualizamos la fecha del Prestamo
                boolean actualizarfecha = prestamoDAO.actualizarFechaPrestamo(fechaPrestamo, idPrestamo);

                // Agregamos datos a la Garantia
                Garantia garantia = new Garantia(idPrestamo, estado);

                // Actualizar Estado Garantia
                boolean estadoGarantia = garantiaDAO.actualizarEstadoGarantia(garantia);

                if (estadoGarantia) {
                    // Rellenar Datos a Pago
                    Pago pago = new Pago(idPrestamo, montoCouta, fechaPrestamo);

                    // Generamos las Coutas de Pago para el Cliente
                    boolean pagosGenerados = pagoDAO.generarCuotasPago(plazoMeses, pago);
                    session.setAttribute("icon", "success");
                    session.setAttribute("mensajeEstado", mensaje);
                } else {
                    session.setAttribute("icon", "error");
                    session.setAttribute("mensajeEstado", "Error al Actualizar el Estado de la Garantia");
                }

            } else {
                session.setAttribute("icon", "error");
                session.setAttribute("mensajeEstado", "Error al Aprobar el Prestamo");
            }

        } else if ("RECHAZADO".equals(estado)) {
            mensaje = "PRESTAMO RECHAZADO";
            actualizarEstado = prestamoDAO.actualizarEstadoPrestamo(prestamo);

            // Actualizamos la fecha del Prestamo
            boolean actualizar_fecha = prestamoDAO.actualizarFechaPrestamo(fechaPrestamo, idPrestamo);

            // Agregamos datos a la Garantia
            Garantia garantia = new Garantia(idPrestamo, estado);

            // Actualizar Estado Garantia
            boolean estadoGarantia = garantiaDAO.actualizarEstadoGarantia(garantia);

            if (actualizarEstado) {
                session.setAttribute("icon", "success");
                session.setAttribute("mensajeEstado", mensaje);
            } else {
                session.setAttribute("icon", "error");
                session.setAttribute("mensajeEstado", "Error en al Rechazar el Prestamo");
            }
        }

        response.sendRedirect("PrestamoServlet?accion=listarPrestamos");
    }

    // **************************************************** FUNCIONES DE CLIENTE *****************************************************************
    private void listarPrestamosCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear Session
        HttpSession session = request.getSession();

        // Obtenemos el Usuario
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Verificamos si el usuario esta en sesion
        if (usuario == null) {
            response.sendRedirect("views/login.jsp");
        }

        // Obtenemos el id del Usuario
        int idUsuario = usuario.getIdUsuario();

        // Obtenemos el estado
        String estado = request.getParameter("estado");

        // Verificamos si el estado es null, se le da un valor por defecto
        if (estado == null) {
            // Valor por Defecto
            estado = "PENDIENTE";
        }

        System.out.println("Id: " + idUsuario);
        System.out.println("Estado: " + estado);
        session.setAttribute("estadoSeleccionado", estado);

        // Lista de Prestamos - Mediante el estado y el idUsuario
        ArrayList<Prestamo> prestamosLista = prestamoDAO.obtenerTodosPrestamosCliente(idUsuario, estado);
        session.setAttribute("listaPrestamos", prestamosLista);
        response.sendRedirect("views/cliente/prestamoCliente.jsp");
    }

    private void registrarPrestamoCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Crear Session
        HttpSession session = request.getSession();
        String mensaje = "";
        String icon = "";

        // Datos Prestamo
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        double montoPrestamo = Double.parseDouble(request.getParameter("monto"));
        double tasaInteres = Double.parseDouble(request.getParameter("tasaInteres"));
        int plazoMeses = Integer.parseInt(request.getParameter("plazoMeses"));
        Date fechaInicio = new Date(System.currentTimeMillis());
        double montoTotal = Double.parseDouble(request.getParameter("montoTotal"));

        // Datos Garantia
        String tipoGarantia = request.getParameter("tipoGarantia");
        double valorGarantia = Double.parseDouble(request.getParameter("valorGarantia"));
        String descripcionGarantia = request.getParameter("descripcionGarantia");

        // Verificar Fecha de Prestamo
        boolean existePrestamo = prestamoDAO.verificarPrestamoFecha(idUsuario, fechaInicio);

        if (!existePrestamo) {
            // Rellenar Datos a Prestamo
            Prestamo prestamo = new Prestamo(idUsuario, montoPrestamo, tasaInteres, plazoMeses, fechaInicio, montoTotal);

            // Registrar Prestamo: Retorna el idPrestamo registrado
            int idPrestamo = prestamoDAO.registrarPrestamos(prestamo);

            if (idPrestamo > 0) {

                // Rellenar Datos a Garantia
                Garantia garantia = new Garantia(idPrestamo, tipoGarantia, descripcionGarantia, valorGarantia);

                // Registrar Garantia
                boolean garantiaRegistrada = garantiaDAO.registrarGarantia(garantia);

                if (garantiaRegistrada) {
                    mensaje = "Prestamo Registrado Exitosamente";
                    icon = "success";
                } else {
                    mensaje = "Error al Registrar la Garantia";
                    icon = "error";
                }

                session.setAttribute("mensajePrestamo", mensaje);
                session.setAttribute("icon", icon);
            } else {
                response.sendRedirect("error.jsp");
            }
        } else {
            session.setAttribute("mensajePrestamo", "Ya existe un Prestamo, prueba para Mañana");
            session.setAttribute("icon", "error");
        }

        response.sendRedirect("PrestamoServlet?accion=listarPrestamosCliente");
    }

    private void generarPDFPrestamo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idPrestamo = Integer.parseInt(request.getParameter("idPrestamo"));

            // Obtener las Cuotas segun el idPrestamo
            ArrayList<Pago> listPagos = pagoDAO.obtenerPagosPorIdPrestamo(idPrestamo);

            Prestamo prestamo = prestamoDAO.obtenerPrestamoPorId(idPrestamo);

            if (prestamo == null || !"APROBADO".equals(prestamo.getEstado())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo se pueden generar comprobantes para préstamos aprobados.");
                return;
            }

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            // Configuración del PDF
            Document document = new Document();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, baos);
            document.open();

            // Logo de la Empresa
            String logoPath = request.getServletContext().getRealPath("/assets/img/Logo_Empresa_CARMIC.png");
            Image logo = Image.getInstance(logoPath);
            logo.scaleAbsolute(250, 250);
            logo.setAlignment(Image.ALIGN_CENTER);
            document.add(logo);

            // Título
            Paragraph titulo = new Paragraph("Comprobante de Préstamo", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16));
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingAfter(15f);
            document.add(titulo);

            // Datos del préstamo
            Paragraph datos = new Paragraph();
            datos.setAlignment(Element.ALIGN_LEFT);
            datos.setFont(FontFactory.getFont(FontFactory.HELVETICA, 12));
            datos.add("Cliente: " + prestamo.getNombreUsuario() + "\n");
            datos.add("Telefono: " + prestamo.getTelefonoUsuario() + "\n");
            datos.add("Monto del Préstamo: S/ " + prestamo.getMonto() + "\n");
            datos.add("Interés: " + prestamo.getTasaInteres() + " %\n");
            datos.add("Plazo: " + prestamo.getPlazoMeses() + " meses\n");
            datos.add("Monto Total: S/ " + prestamo.getMontoTotal() + "\n");
            datos.add("Estado: " + prestamo.getEstado() + "\n");
            datos.add("Fecha del Préstamo: " + (prestamo.getFechaPrestamo() != null ? sdf.format(prestamo.getFechaPrestamo()) : "N/A") + "\n");
            datos.setSpacingAfter(30f);
            document.add(datos);

            // **Tabla de Cuotas**
            PdfPTable tablaCuotas = new PdfPTable(3);  // 3 columnas: Fecha de Pago, Monto, Saldo Restante
            tablaCuotas.setWidthPercentage(100);

            // Cabecera de la tabla
            tablaCuotas.addCell("N° Cuota");
            tablaCuotas.addCell("Monto de Pago");
            tablaCuotas.addCell("Fecha Limite de Pago");

            // Agregar filas con los pagos (cuotas)
            int i = 1;
            for (Pago pago : listPagos) {
                tablaCuotas.addCell(String.valueOf(i++));
                tablaCuotas.addCell("S/ " + pago.getMontoPago());
                tablaCuotas.addCell(sdf.format(pago.getFechaPago()));
            }

            // Añadir la tabla al documento
            document.add(tablaCuotas);

            // Firma representativa del administrador
            Paragraph firma = new Paragraph();
            firma.setAlignment(Element.ALIGN_CENTER);
            firma.setFont(FontFactory.getFont(FontFactory.HELVETICA, 12));
            firma.add("__________________________\n");
            firma.add("Ing. Carlos Rivadeneyra\n");
            firma.add("Jefe de Créditos y Finanzas\n");
            firma.add("Empresa de Préstamos - CARMIC\n");

            // Inserta la imagen de la firma
            String firmaPath = request.getServletContext().getRealPath("/assets/img/firma_admin.png"); // Ruta de la firma
            Image firmaImagen = Image.getInstance(firmaPath);
            firmaImagen.scaleAbsolute(150, 150);
            firmaImagen.setAlignment(Image.ALIGN_CENTER);

            // Añadir la imagen al documento
            document.add(firmaImagen);

            // Espacio entre la firma y los datos de la Firma
            firma.setSpacingBefore(-40f);

            // Añadir el texto de la firma inmediatamente después de la imagen
            document.add(firma);

            // Cierre
            document.close();

            // Configuración de respuesta
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=prestamo_" + idPrestamo + ".pdf");
            response.setContentLength(baos.size());

            OutputStream os = response.getOutputStream();
            baos.writeTo(os);
            os.flush();
            os.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
