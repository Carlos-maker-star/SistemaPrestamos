/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dao.Interfaces.IUsuarioDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import models.Usuario;
import org.mindrot.jbcrypt.BCrypt;
import utils.ConexionMysql;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class UsuarioDAO implements IUsuarioDAO {

    @Override
    public Usuario iniciarSesion(Usuario usuario) {
        Usuario user = null;
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT id_usuario, nombre, telefono, correo, password, rol, estado FROM usuario WHERE correo = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, usuario.getCorreo());
            rs = ps.executeQuery();

            if (rs.next()) {
                
                // Almacenamos el password de la Base de Datos
                String passwordHash = rs.getString("password");
                
                // Obtenemos el password ingresada
                String passwordIngresada = usuario.getPassword();

                // Hasheamos el password ingresada por el usuario y lo compara con el passwordHash
                if (BCrypt.checkpw(passwordIngresada, passwordHash)) {
                    user = new Usuario();
                    user.setIdUsuario(rs.getInt("id_usuario"));
                    user.setNombre(rs.getString("nombre"));
                    user.setTelefono(rs.getString("telefono"));
                    user.setCorreo(rs.getString("correo"));
                    user.setRol(rs.getString("rol"));
                    user.setEstado(rs.getString("estado"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return user;
    }

    @Override
    public boolean registroUsuario(Usuario usuario) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "INSERT INTO usuario (nombre, telefono, correo, password) VALUES (?, ?, ?, ?)";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getTelefono());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getPassword());
            ps.execute();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    @Override
    public ArrayList<Usuario> listaUsuarios(String rol) {
        ArrayList<Usuario> usuariosLista = new ArrayList<>();
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT * FROM usuario WHERE rol = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, rol);
            rs = ps.executeQuery();

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEstado(rs.getString("estado"));

                // Agregamos los usuarios a la lista
                usuariosLista.add(usuario);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return usuariosLista;
    }

    @Override
    public boolean eliminarUsuario(Usuario usuario) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "DELETE FROM usuario WHERE id_usuario = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, usuario.getIdUsuario());
            ps.execute();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    @Override
    public boolean editarUsuario(Usuario usuario) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "UPDATE usuario SET nombre = ?, telefono = ?, correo = ?, estado = ? WHERE id_usuario = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getTelefono());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getEstado());
            ps.setInt(5, usuario.getIdUsuario());
            ps.execute();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    @Override
    public Usuario buscarUsuario(Usuario usuario) {
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT * FROM usuario WHERE id_usuario = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, usuario.getIdUsuario());
            rs = ps.executeQuery();

            while (rs.next()) {
                usuario.setNombre(rs.getString("nombre"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setEstado(rs.getString("estado"));
                return usuario;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    @Override
    public boolean validarCorreo(String correo) {
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT COUNT(*) FROM usuario WHERE correo = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0; // Si retorna mayor de 0 el correo existe
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexionBD.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return false;
    }

}
