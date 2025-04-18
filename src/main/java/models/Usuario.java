/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class Usuario {
    
    private int idUsuario;
    private String nombre;
    private String telefono;
    private String correo;
    private String password;
    private String rol;
    private String estado;
    
    // Constructor Vacio
    public Usuario () {}

    // Iniciar Sesion
    public Usuario(String correo, String password) {
        this.correo = correo;
        this.password = password;
    }
    
    // Registro Usuario - CLIENTE y ADMIN
    public Usuario(String nombre, String telefono, String correo, String password) {
        this.nombre = nombre;
        this.telefono = telefono;
        this.correo = correo;
        this.password = password;
    }

    // Eliminar o Buscar Usuario por Id
    public Usuario(int idUsuario) {    
        this.idUsuario = idUsuario;
    }

    // Editar Usuario
    public Usuario(int idUsuario, String nombre, String telefono, String correo, String estado) {
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.telefono = telefono;
        this.correo = correo;
        this.estado = estado;
    }

    // Getters and Setters
    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
}
