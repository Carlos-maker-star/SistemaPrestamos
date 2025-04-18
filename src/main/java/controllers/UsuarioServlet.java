/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import org.mindrot.jbcrypt.BCrypt;
import models.Usuario;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class UsuarioServlet extends HttpServlet {

    UsuarioDAO usuarioDAO = new UsuarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Crear Session
        HttpSession session = request.getSession();
        
        // Tipo de Accion
        String accion = request.getParameter("accion");

        switch (accion) {
            case "login":
                iniciarSesion(request, response);
                break;

            // FUNCIONES ADMINISTRADOR
            case "listarUsuarios":
                listarUsuariosAdmin(request, response);
                break;
            case "registrar":
                registrarUsuarioAdmin(request, response);
                break;
            case "eliminar":
                eliminarUsuarioAdmin(request, response);
                break;
            case "editar":
                editarUsuarioAdmin(request, response);
                break;

            // FUNCIONES CLIENTE
            case "registrarCliente":
                registrarUsuarioCliente(request, response);
                break;
            default:
                session.setAttribute("mensaje", "Error en la eleccion");
                response.sendRedirect("views/error/.jsp");
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
    private void listarUsuariosAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rol = request.getParameter("rol");

        // Crear Session
        HttpSession session = request.getSession();

        if (rol == null) {
            // Valor por Defecto
            rol = "CLIENTE";
        }
        System.out.println(rol);
        session.setAttribute("rolSeleccionado", rol);

        // Lista de Usuarios
        ArrayList<Usuario> usuariosLista = usuarioDAO.listaUsuarios(rol);
        session.setAttribute("listaUsuarios", usuariosLista);
        response.sendRedirect("views/admin/usuariosAdmin.jsp");
    }

    private void registrarUsuarioAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mensajeRegistro = "";
        String iconRegistro = "";

        // Crear Session
        HttpSession session = request.getSession();

        // Datos
        String nombres = request.getParameter("nombres");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        // Hashear la contraseña
        String passwordHasheada = BCrypt.hashpw(password, BCrypt.gensalt());
        
        // Validar Correo
        if (usuarioDAO.validarCorreo(correo)) {
            mensajeRegistro = "Correo ya existente";
            iconRegistro = "warning";
            session.setAttribute("mensajeRegistro", mensajeRegistro);
            session.setAttribute("iconRegistro", iconRegistro);
            response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
            return;
        }

        // Llenar datos a Usuario
        Usuario usuario = new Usuario(nombres, telefono, correo, passwordHasheada);

        // Registramos Usuario
        boolean registradoUsuario = usuarioDAO.registroUsuario(usuario);

        if (registradoUsuario) {
            mensajeRegistro = "Cuenta Creada Exitosamente";
            iconRegistro = "success";
        } else {
            mensajeRegistro = "Error al crear la cuenta";
            iconRegistro = "error";
        }

        session.setAttribute("mensajeRegistro", mensajeRegistro);
        session.setAttribute("iconRegistro", iconRegistro);

        // Redirigir al servlet que carga la lista de usuarios
        response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
    }

    private void eliminarUsuarioAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mensaje = "";

        // Crear Session
        HttpSession session = request.getSession();

        // Datos
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuario = new Usuario(id);
        boolean eliminadoUsuario = usuarioDAO.eliminarUsuario(usuario);

        if (eliminadoUsuario) {
            mensaje = "Cliente eliminado correctamente";
            session.setAttribute("mensajeEliminado", mensaje);
        }
        response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
    }

    private void editarUsuarioAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mensaje = "";
        String icon = "";

        // Crear Session
        HttpSession session = request.getSession();

        // Datos
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        String nombres = request.getParameter("nombre");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String estado = request.getParameter("estado");

        // Buscar Usuario id para verificar los datos para editar
        Usuario usuario = new Usuario(idUsuario);
        Usuario usuarioActual = usuarioDAO.buscarUsuario(usuario);

        // Si no se edita nada, no se actualizara
        if (nombres.equals(usuarioActual.getNombre()) && telefono.equals(usuarioActual.getTelefono()) && correo.equals(usuarioActual.getCorreo()) && estado.equals(usuarioActual.getEstado())) {
            mensaje = "No se edito ningun campo correspondiente";
            icon = "warning";
            session.setAttribute("mensajeEditado", mensaje);
            session.setAttribute("icon", icon);
            response.sendRedirect("views/admin/usuariosAdmin.jsp");
            return;
        }

        // Si algun campo esta vacio se mantiene los datos del Usuario
        if (nombres.isEmpty()) {
            nombres = usuarioActual.getNombre();
        }
        if (telefono.isEmpty()) {
            telefono = usuarioActual.getTelefono();
        }
        if (correo.isEmpty()) {
            correo = usuarioActual.getCorreo();
        }
        if (estado.isEmpty()) {
            estado = usuarioActual.getEstado();
        }

        // Usuario a editar
        Usuario usuarioEditar = new Usuario(idUsuario, nombres, telefono, correo, estado);
        boolean editadoUsuario = usuarioDAO.editarUsuario(usuarioEditar);

        if (editadoUsuario) {
            mensaje = "Editado Correctamente";
            icon = "success";
            session.setAttribute("mensajeEditado", mensaje);
            session.setAttribute("icon", icon);
        } else {
            mensaje = "Error al Editar el Cliente";
            icon = "error";
            session.setAttribute("mensajeEditado", mensaje);
            session.setAttribute("icon", icon);
        }

        response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
    }

    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mensajeLogin = "";
        String redirigir = "";

        // Crear Session
        HttpSession session = request.getSession();

        // Datos
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        
        // Rellenar Datos al Usuario
        Usuario usuario = new Usuario(correo, password);

        // Login Usuario
        Usuario loginUsuario = usuarioDAO.iniciarSesion(usuario);

        if (loginUsuario != null) {
            mensajeLogin = "Iniciando Sesion";
            session.setAttribute("mensajeLoginExitoso", mensajeLogin);
            session.setAttribute("usuario", loginUsuario);

            // Verificar Estado
            if ("ACTIVO".equals(loginUsuario.getEstado())) {

                // Verificar Rol
                if (loginUsuario.getRol().equals("ADMIN")) {
                    redirigir = "admin/indexAdmin.jsp";
                    session.setAttribute("paginaIndex", redirigir);
                    response.sendRedirect("views/login.jsp");
                } else {
                    redirigir = "cliente/indexCliente.jsp";
                    session.setAttribute("paginaIndex", redirigir);
                    response.sendRedirect("views/login.jsp");
                }
            } else {
                mensajeLogin = "Estas Suspendido";
                session.setAttribute("mensajeLoginError", mensajeLogin);
                response.sendRedirect("views/login.jsp");
            }
        } else {
            mensajeLogin = "Datos incorrectos";
            session.setAttribute("mensajeLoginError", mensajeLogin);
            response.sendRedirect("views/login.jsp");
        }
    }

    // **************************************************** FUNCIONES DE CLIENTE *****************************************************************
    private void registrarUsuarioCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mensajeRegistro = "";
        String iconRegistro = "";

        // Crear Session
        HttpSession session = request.getSession();

        // Datos
        String nombres = request.getParameter("nombres");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        
        // Hashear la contraseña
        String passwordHasheada = BCrypt.hashpw(password, BCrypt.gensalt());

        // Validar Correo
        if (usuarioDAO.validarCorreo(correo)) {
            mensajeRegistro = "Correo ya existente";
            iconRegistro = "warning";
            session.setAttribute("mensajeRegistro", mensajeRegistro);
            session.setAttribute("iconRegistro", iconRegistro);
            response.sendRedirect("views/login.jsp");
            return;
        }

        Usuario usuario = new Usuario(nombres, telefono, correo, passwordHasheada);

        // Registramos Usuario
        boolean registradoUsuario = usuarioDAO.registroUsuario(usuario);

        if (registradoUsuario) {
            mensajeRegistro = "Cuenta Creada Exitosamente";
            iconRegistro = "success";
        } else {
            mensajeRegistro = "Error al crear la cuenta";
            iconRegistro = "error";
        }

        session.setAttribute("mensajeRegistro", mensajeRegistro);
        session.setAttribute("iconRegistro", iconRegistro);

        // Redirigir al servlet que carga la lista de usuarios
        response.sendRedirect("views/login.jsp");
    }
}
