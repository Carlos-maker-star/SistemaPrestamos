/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.draw.LineSeparator;

import dao.PagoDAO;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Hashtable;

import models.Pago;
import models.Usuario;

import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class PagoServlet extends HttpServlet {

    PagoDAO pagoDao = new PagoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tipo de Accion
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "";
        }
        switch (accion) {

            // Metodos de Pago
            case "listarPagosCliente":
                listarPagosCliente(request, response);
                break;
            case "pagarCuota":
                pagarCuotaCliente(request, response);
                break;
            case "generarVoucher":
                generarVoucherCliente(request, response);
                break;
            case "verQR":
                verQRpago(request, response);
                break;
            default:
                response.sendRedirect("views/error.jsp");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
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

    private void listarPagosCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // Obtenemos la Fecha Inicio
        String fechaInicioStr = request.getParameter("fechaInicio");

        // Si la fecha es null o vacía, se asigna la fecha actual como valor por defecto
        Date fechaInicio = null;
        if (fechaInicioStr != null && !fechaInicioStr.isEmpty()) {
            fechaInicio = Date.valueOf(fechaInicioStr); // Convertir a tipo Date
        } else {
            fechaInicio = new java.sql.Date(System.currentTimeMillis()); // Fecha actual
        }

        session.setAttribute("fechaSeleccionado", fechaInicio);

        // Lista de Pagos - Mediante la fecha de Inicio del Prestamo y el idUsuario
        ArrayList<Pago> pagosLista = pagoDao.obtenerPagosCliente(idUsuario, fechaInicio);
        session.setAttribute("listaPagos", pagosLista);
        response.sendRedirect("views/cliente/pagoCliente.jsp");
    }

    private void pagarCuotaCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Crear Session
            HttpSession session = request.getSession();

            // Obtenemos los Datos
            int idPago = Integer.parseInt(request.getParameter("idPago"));
            String fechaPagoOriginalStr = request.getParameter("fechaPagoOriginal");
            String fechaPagoActualStr = request.getParameter("fechaPagoInput");
            String fechaInicioStr = request.getParameter("fechaInicioS");

            // Definir formato de fecha
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            // Fechas
            Date fechaPagoOriginal = null;
            Date fechaPagoActual = null;
            Date fechaInicioS = null;

            if (fechaPagoOriginalStr != null && !fechaPagoOriginalStr.isEmpty()) {
                fechaPagoOriginal = new Date(sdf.parse(fechaPagoOriginalStr).getTime()); // Convertir a tipo Date
            }

            if (fechaPagoActualStr != null && !fechaPagoActualStr.isEmpty()) {
                fechaPagoActual = new Date(sdf.parse(fechaPagoActualStr).getTime()); // Convertir a tipo Date
            }

            if (fechaInicioStr != null && !fechaInicioStr.isEmpty()) {
                fechaInicioS = new Date(sdf.parse(fechaInicioStr).getTime()); // Convertir a tipo Date
            }

            System.out.println(idPago);
            System.out.println(fechaPagoActual);
            System.out.println(fechaPagoOriginal);
            System.out.println(fechaInicioS);
            String estado = "";
            if (fechaPagoActual.after(fechaPagoOriginal)) {
                estado = "ATRASADO";
            } else {
                estado = "PAGADO";
            }

            // Llenar datos al Pago
            Pago pago = new Pago(estado, fechaPagoActual, idPago);

            // Actualizamos el Pago
            boolean cuotaPagada = pagoDao.pagarCouta(pago);

            String mensaje = "";
            String icon = "";
            if (cuotaPagada) {
                mensaje = "Cuota Pagada";
                icon = "success";
            } else {
                mensaje = "Error al Pagar";
                icon = "error";
            }
            session.setAttribute("mensajePago", mensaje);
            session.setAttribute("iconPago", icon);
            response.sendRedirect("PagoServlet?accion=listarPagosCliente&fechaInicio=" + fechaInicioS);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void generarVoucherCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Datos
        int idPago = Integer.parseInt(request.getParameter("idPago"));

        // Obtener los datos del pago completo
        ArrayList<Pago> listPago = pagoDao.generarVoucherPago(idPago);
        if (listPago.isEmpty()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Pago no válido o aún no realizado.");
            return;
        }

        Pago pago = listPago.get(0);

        if (!"PAGADO".equals(pago.getEstado()) && !"ATRASADO".equals(pago.getEstado())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "El pago aún no ha sido realizado.");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Voucher_Pago_" + idPago + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            Document doc = new Document();
            PdfWriter.getInstance(doc, out);
            doc.open();

            // Logo
            try {
                String logoPath = getServletContext().getRealPath("/assets/img/Logo_Empresa_CARMIC.png");
                Image logo = Image.getInstance(logoPath);
                logo.scaleAbsolute(200, 200);
                logo.setAlignment(Image.ALIGN_CENTER);
                doc.add(logo);
            } catch (Exception e) {
                // Si falla el logo, no interrumpe
            }

            // Nombre de la empresa
            Paragraph nombreEmpresa = new Paragraph("CARMIC - CARLOS RIVADENEYRA", new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD));
            nombreEmpresa.setAlignment(Element.ALIGN_CENTER);
            doc.add(nombreEmpresa);

            doc.add(new Paragraph(" "));

            // Línea separadora
            doc.add(new LineSeparator());

            // Título
            Paragraph titulo = new Paragraph("VOUCHER DE PAGO", new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
            titulo.setAlignment(Element.ALIGN_CENTER);
            doc.add(titulo);

            doc.add(new Paragraph(" "));

            // Tabla con los datos
            PdfPTable tabla = new PdfPTable(2);
            tabla.setWidthPercentage(100);
            tabla.setSpacingBefore(10f);
            tabla.setSpacingAfter(10f);

            // Estilo de la tabla
            Font labelFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
            Font valueFont = new Font(Font.FontFamily.HELVETICA, 11);

            tabla.addCell(new PdfPCell(new Phrase("N° Operación:", labelFont)));
            tabla.addCell(new PdfPCell(new Phrase(String.format("%06d", pago.getIdPago()), valueFont)));

            tabla.addCell(new PdfPCell(new Phrase("Cliente:", labelFont)));
            tabla.addCell(new PdfPCell(new Phrase(pago.getUsuario().getNombre(), valueFont)));

            tabla.addCell(new PdfPCell(new Phrase("Teléfono:", labelFont)));
            tabla.addCell(new PdfPCell(new Phrase(pago.getUsuario().getTelefono(), valueFont)));

            tabla.addCell(new PdfPCell(new Phrase("Monto Pagado:", labelFont)));
            tabla.addCell(new PdfPCell(new Phrase("S/ " + pago.getMontoPago(), valueFont)));

            tabla.addCell(new PdfPCell(new Phrase("Fecha de Pago:", labelFont)));
            tabla.addCell(new PdfPCell(new Phrase(String.valueOf(pago.getFechaPagada()), valueFont)));

            tabla.addCell(new PdfPCell(new Phrase("Estado:", labelFont)));
            tabla.addCell(new PdfPCell(new Phrase(pago.getEstado(), valueFont)));

            doc.add(tabla);

            // Confirmación de pago y otros detalles
            doc.add(new Paragraph("--------------------------------------------------"));
            doc.add(new Paragraph("Gracias por su pago.", new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC)));
            doc.add(new Paragraph("Este documento no reemplaza un comprobante electrónico oficial.", new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC)));

            doc.close();
            out.flush();
        } catch (Exception e) {
            throw new ServletException("Error generando el PDF: " + e.getMessage(), e);
        }

    }

    private void verQRpago(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idPago = Integer.parseInt(request.getParameter("idPago"));

            ArrayList<Pago> listPago = pagoDao.generarVoucherPago(idPago);
            if (listPago.isEmpty()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Pago no válido o aún no realizado.");
                return;
            }

            Pago pago = listPago.get(0);
            Usuario cliente = pago.getUsuario();

            // Construir los datos que aparecerán en el QR
            String datosQR = "Comprobante de Pago\n" +
                    "Cliente: " + cliente.getNombre() + "\n" +
                    "Monto: S/" + pago.getMontoPago() + "\n" +
                    "Fecha de Pago: " + pago.getFechaPagada() + "\n" +
                    "Estado: " + pago.getEstado();

            // Configurar la generación del código QR
            Hashtable<EncodeHintType, Object> hintMap = new Hashtable<>();
            hintMap.put(EncodeHintType.MARGIN, 1);  // Reducir el margen

            // Generar el BitMatrix para el código QR
            BitMatrix matrix = new MultiFormatWriter().encode(datosQR, BarcodeFormat.QR_CODE, 200, 200, hintMap);

            // Convertir el BitMatrix a una imagen PNG y escribirla en el OutputStream
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(matrix, "PNG", baos);

            // Enviar la imagen como respuesta
            response.setContentType("image/png");
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
