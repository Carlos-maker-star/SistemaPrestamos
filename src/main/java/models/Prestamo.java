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
public class Prestamo {
    
    // Atributos Prestamo
    private int idPrestamo;
    private int usuarioId; 
    private double monto;
    private double tasaInteres;
    private int plazoMeses;
    private String estado;
    private Date fechaInicio;
    private double montoTotal;
    private Date fechaPrestamo;
    
    // Atributo Usuario
    private String nombreUsuario;
    private String telefonoUsuario;
    
    // Constructor vacio
    public Prestamo () { }

    // Constructor para registrar Prestamo
    public Prestamo(int usuarioId, double monto, double tasaInteres, int plazoMeses, Date fechaInicio, double montoTotal) {
        this.usuarioId = usuarioId;
        this.monto = monto;
        this.tasaInteres = tasaInteres;
        this.plazoMeses = plazoMeses;
        this.fechaInicio = fechaInicio;
        this.montoTotal = montoTotal;
    }
    
    // Constructor para Actualizar el Estado
    public Prestamo(int idPrestamo, String estado) {
        this.idPrestamo = idPrestamo;
        this.estado = estado;
    }

    // Getters and Setters
    public int getIdPrestamo() {
        return idPrestamo;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public double getTasaInteres() {
        return tasaInteres;
    }

    public void setTasaInteres(double tasaInteres) {
        this.tasaInteres = tasaInteres;
    }

    public int getPlazoMeses() {
        return plazoMeses;
    }

    public void setPlazoMeses(int plazoMeses) {
        this.plazoMeses = plazoMeses;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public double getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(double montoTotal) {
        this.montoTotal = montoTotal;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getTelefonoUsuario() {
        return telefonoUsuario;
    }

    public void setTelefonoUsuario(String telefonoUsuario) {
        this.telefonoUsuario = telefonoUsuario;
    }

    public Date getFechaPrestamo() {
        return fechaPrestamo;
    }

    public void setFechaPrestamo(Date fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }
}
