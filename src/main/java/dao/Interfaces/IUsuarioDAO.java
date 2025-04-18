/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao.Interfaces;

import java.util.ArrayList;
import models.Usuario;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public interface IUsuarioDAO {

    Usuario iniciarSesion(Usuario usuario);

    boolean registroUsuario(Usuario usuario);

    ArrayList<Usuario> listaUsuarios(String rol);

    boolean eliminarUsuario(Usuario usuario);

    boolean editarUsuario(Usuario usuario);

    Usuario buscarUsuario(Usuario usuario);

    boolean validarCorreo(String correo);
}
