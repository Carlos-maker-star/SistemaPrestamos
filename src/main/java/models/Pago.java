/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.sql.Date;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class Pago {
    
    private int idPago;
    private int prestamoId;
    private double montoPago;
    private Date fechaPago;
    private String estado;
    private Date fechaPagada;
    private Date fechaInicioPrestamo;
    private Usuario usuario;
    private Prestamo prestamo;

    // Constructor vacio
    public Pago () { }
    
    // Constructor para registrar Pago
    public Pago(int prestamoId, double montoPago, Date fechaPago) {
        this.prestamoId = prestamoId;
        this.montoPago = montoPago;
        this.fechaPago = fechaPago;
    }
    
    // Constructor para pagar Cuota
    public Pago(String estado, Date fechaPagada, int idPago) {
        this.estado = estado;
        this.fechaPagada = fechaPagada;
        this.idPago = idPago;
    }

    // Getters and Setters
    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public int getPrestamoId() {
        return prestamoId;
    }

    public void setPrestamoId(int prestamoId) {
        this.prestamoId = prestamoId;
    }

    public double getMontoPago() {
        return montoPago;
    }

    public void setMontoPago(double montoPago) {
        this.montoPago = montoPago;
    }

    public Date getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Date fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Date getFechaPagada() {
        return fechaPagada;
    }

    public void setFechaPagada(Date fechaPagada) {
        this.fechaPagada = fechaPagada;
    }

    public Date getFechaInicioPrestamo() {
        return fechaInicioPrestamo;
    }

    public void setFechaInicioPrestamo(Date fechaInicioPrestamo) {
        this.fechaInicioPrestamo = fechaInicioPrestamo;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Prestamo getPrestamo() {
        return prestamo;
    }

    public void setPrestamo(Prestamo prestamo) {
        this.prestamo = prestamo;
    }
}
