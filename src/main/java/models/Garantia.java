/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class Garantia {
    
    private int idGarantia;
    private int prestamoId;
    private String tipo;
    private String descripcion;
    private double valorGarantia;
    private String estado;
    
    // Constructor vacio
    public Garantia () {}
    
    // Constructor para registrar Garantia
    public Garantia(int prestamoId, String tipo, String descripcion, double valorGarantia) {
        this.prestamoId = prestamoId;
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.valorGarantia = valorGarantia;
    }
    
    // Actualizar Estado Garantia
    public Garantia(int prestamoId, String estado) {
        this.prestamoId = prestamoId;
        this.estado = estado;
    }
    
    // Getters and Setters
    public int getIdGarantia() {
        return idGarantia;
    }

    public void setIdGarantia(int idGarantia) {
        this.idGarantia = idGarantia;
    }

    public int getPrestamoId() {
        return prestamoId;
    }

    public void setPrestamoId(int prestamoId) {
        this.prestamoId = prestamoId;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getValorGarantia() {
        return valorGarantia;
    }

    public void setValorGarantia(double valorGarantia) {
        this.valorGarantia = valorGarantia;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
}
