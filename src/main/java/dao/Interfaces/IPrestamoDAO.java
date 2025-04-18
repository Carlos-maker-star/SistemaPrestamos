/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao.Interfaces;

import java.util.ArrayList;
import java.util.Date;

import models.Prestamo;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public interface IPrestamoDAO {

    int registrarPrestamos(Prestamo prestamo);

    ArrayList<Prestamo> obtenerTodosPrestamos(String estado);

    boolean actualizarEstadoPrestamo(Prestamo prestamo);

    ArrayList<Prestamo> obtenerTodosPrestamosCliente(int idUsuario, String estado);
    
    ArrayList<Prestamo> obtenerFechasPrestamos(int idUsuario);

    boolean actualizarFechaPrestamo(Date fechaPrestamo, int idPrestamo);

    boolean verificarPrestamoFecha(int idUsuario, Date fechaInicio);

    Prestamo obtenerPrestamoPorId(int idPrestamo);

    ArrayList<Prestamo> obtenerPrestamosExcel();

    boolean clienteYaTienePrestamoAprobadoHoy(int idUsuario);
}
