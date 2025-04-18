package controllers;

import dao.PrestamoDAO;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import models.Prestamo;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelServlet  extends HttpServlet {

    PrestamoDAO prestamoDAO = new PrestamoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Tipo de Accion
        String accion = request.getParameter("accion");

        System.out.println("Accion recibida en ExcelServlet: " + accion);


        if (accion == null) {
            accion = "";
        }

        switch (accion) {

            // Metodos de Administrador
            case "exportarExcelPrestamos":
                exportarExcelPrestamos(request, response);
                break;
            default:
                response.sendRedirect("views/error.jsp");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request,response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request,response);
    }

    @Override
    public String getServletInfo() {
        return super.getServletInfo();
    }
    // </editor-fold>

    private void exportarExcelPrestamos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtenemos todos los Prestamos para el EXCEL
            ArrayList<Prestamo> listPrestamos = prestamoDAO.obtenerPrestamosExcel();

            // Crear archivo Excel
            Workbook workbook = new XSSFWorkbook();
            Sheet hoja = workbook.createSheet("Préstamos");

            // Estilo de encabezado
            CellStyle estiloEncabezado = workbook.createCellStyle();
            Font fuenteEncabezado = workbook.createFont();  // Usando Font de Apache POI
            fuenteEncabezado.setBold(true);  // Hacer la fuente en negrita
            estiloEncabezado.setFont(fuenteEncabezado);

            // Establecer color de fondo claro (naranja claro)
            XSSFColor colorNaranjaClaro = new XSSFColor(new byte[] {(byte) 255, (byte) 165, (byte) 0});
            estiloEncabezado.setFillForegroundColor(colorNaranjaClaro);
            estiloEncabezado.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // Encabezados
            Row filaEncabezado = hoja.createRow(0);
            String[] columnas = {"N°", "Cliente", "Teléfono", "Monto", "Interés (%)", "Plazo (meses)", "Estado", "Fecha Inicio", "Fecha del Préstamo", "Monto Total"};
            for (int i = 0; i < columnas.length; i++) {
                Cell celda = filaEncabezado.createCell(i);
                celda.setCellValue(columnas[i]);
                celda.setCellStyle(estiloEncabezado);
            }

            // Formato de fecha
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            // Llenar datos
            int i = 1;
            for (Prestamo prestamo : listPrestamos) {
                Row fila = hoja.createRow(i);

                fila.createCell(0).setCellValue(i);
                fila.createCell(1).setCellValue(prestamo.getNombreUsuario());
                fila.createCell(2).setCellValue(prestamo.getTelefonoUsuario());
                fila.createCell(3).setCellValue(prestamo.getMonto());
                fila.createCell(4).setCellValue(prestamo.getTasaInteres());
                fila.createCell(5).setCellValue(prestamo.getPlazoMeses());
                fila.createCell(6).setCellValue(prestamo.getEstado());

                // Fecha de inicio (siempre debería existir)
                Cell celdaInicio = fila.createCell(7);
                if (prestamo.getFechaInicio() != null) {
                    celdaInicio.setCellValue(sdf.format(prestamo.getFechaInicio()));
                } else {
                    celdaInicio.setCellValue("N/A");
                }

                // Fecha del préstamo (solo si está aprobado o rechazado)
                Cell celdaPrestamo = fila.createCell(8);
                if (prestamo.getFechaPrestamo() != null) {
                    celdaPrestamo.setCellValue(sdf.format(prestamo.getFechaPrestamo()));
                } else {
                    celdaPrestamo.setCellValue("N/A");
                }

                fila.createCell(9).setCellValue(prestamo.getMontoTotal());

                i++;
            }

            // Autoajustar columnas
            for (int j = 0; j < columnas.length; j++) {
                hoja.autoSizeColumn(j);
            }

            // Preparar la respuesta
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=prestamos.xlsx");

            // Escribir el archivo al cliente
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
                out.flush();
            }

            // Cerrar el workbook
            workbook.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
