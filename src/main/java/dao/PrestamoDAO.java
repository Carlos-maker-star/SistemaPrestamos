/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dao.Interfaces.IPrestamoDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;

import models.Prestamo;
import models.Usuario;
import utils.ConexionMysql;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class PrestamoDAO implements IPrestamoDAO {

    @Override
    public int registrarPrestamos(Prestamo prestamo) {
        int idPrestamo = -1;
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        ResultSet rs;
        String sql = "INSERT INTO prestamo (usuario_id, monto, tasa_interes, plazo_meses, fecha_inicio, monto_total) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            ps = conexionBD.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, prestamo.getUsuarioId());
            ps.setDouble(2, prestamo.getMonto());
            ps.setDouble(3, prestamo.getTasaInteres());
            ps.setInt(4, prestamo.getPlazoMeses());
            ps.setDate(5, new java.sql.Date(prestamo.getFechaInicio().getTime()));
            ps.setDouble(6, prestamo.getMontoTotal());
            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    idPrestamo = rs.getInt(1);
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

        return idPrestamo;
    }

    @Override
    public ArrayList<Prestamo> obtenerTodosPrestamos(String estado) {
        ArrayList<Prestamo> prestamos = new ArrayList<>();
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        ResultSet rs;
        String sql = "SELECT \n"
                + "    p.id_prestamo, \n"
                + "    u.id_usuario, \n"
                + "    u.nombre, \n"
                + "    u.telefono, \n"
                + "    p.monto, \n"
                + "    p.tasa_interes,"
                + "    p.monto_total, \n"
                + "    p.plazo_meses, \n"
                + "    p.estado, \n"
                + "    p.fecha_inicio \n"
                + "FROM prestamo p \n"
                + "INNER JOIN usuario u ON p.usuario_id = u.id_usuario "
                + "WHERE p.estado = ? AND u.estado = 'ACTIVO'";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, estado);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Prestamo
                Prestamo prestamo = new Prestamo();
                prestamo.setIdPrestamo(rs.getInt("p.id_prestamo"));

                // Usuario
                prestamo.setUsuarioId(rs.getInt("u.id_usuario"));
                prestamo.setNombreUsuario(rs.getString("u.nombre"));
                prestamo.setTelefonoUsuario(rs.getString("u.telefono"));

                // Prestamo
                prestamo.setMonto(rs.getDouble("p.monto"));
                prestamo.setTasaInteres(rs.getDouble("p.tasa_interes"));
                prestamo.setMontoTotal(rs.getDouble("p.monto_total"));
                prestamo.setPlazoMeses(rs.getInt("p.plazo_meses"));
                prestamo.setEstado(rs.getString("p.estado"));
                prestamo.setFechaInicio(rs.getDate("p.fecha_inicio"));

                // Agregamos los prestamos a la lista
                prestamos.add(prestamo);
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

        return prestamos;
    }

    @Override
    public boolean actualizarEstadoPrestamo(Prestamo prestamo) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "UPDATE prestamo SET estado = ? WHERE id_prestamo = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, prestamo.getEstado());
            ps.setInt(2, prestamo.getIdPrestamo());

            return ps.executeUpdate() > 0;

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
    public ArrayList<Prestamo> obtenerTodosPrestamosCliente(int idUsuario, String estado) {
        ArrayList<Prestamo> prestamos = new ArrayList<>();
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        ResultSet rs;
        String sql = "SELECT \n"
                + "    p.id_prestamo, \n"
                + "    u.nombre, \n"
                + "    u.telefono, \n"
                + "    p.monto, \n"
                + "    p.tasa_interes,"
                + "    p.monto_total, \n"
                + "    p.plazo_meses, \n"
                + "    p.estado, \n"
                + "    p.fecha_inicio, \n"
                + "    p.fecha_prestamo \n"
                + "FROM prestamo p \n"
                + "INNER JOIN usuario u ON p.usuario_id = u.id_usuario "
                + "WHERE u.id_usuario = ? AND p.estado = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setString(2, estado);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Prestamo
                Prestamo prestamo = new Prestamo();
                prestamo.setIdPrestamo(rs.getInt("p.id_prestamo"));

                // Usuario
                prestamo.setNombreUsuario(rs.getString("u.nombre"));
                prestamo.setTelefonoUsuario(rs.getString("u.telefono"));

                // Prestamo
                prestamo.setMonto(rs.getDouble("p.monto"));
                prestamo.setTasaInteres(rs.getDouble("p.tasa_interes"));
                prestamo.setMontoTotal(rs.getDouble("p.monto_total"));
                prestamo.setPlazoMeses(rs.getInt("p.plazo_meses"));
                prestamo.setEstado(rs.getString("p.estado"));
                prestamo.setFechaInicio(rs.getDate("p.fecha_inicio"));
                prestamo.setFechaPrestamo(rs.getDate("p.fecha_prestamo"));

                // Agregamos los prestamos a la lista
                prestamos.add(prestamo);
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

        return prestamos;
    }

    @Override
    public ArrayList<Prestamo> obtenerFechasPrestamos(int idUsuario) {
        ArrayList<Prestamo> prestamos = new ArrayList<>();
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT "
                   + "  p.fecha_prestamo \n"
                   + "FROM prestamo p \n"
                   + "INNER JOIN usuario u ON p.usuario_id = u.id_usuario "
                   + "WHERE p.estado = 'APROBADO' AND p.usuario_id = ?";
        
        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Prestamo prestamo = new Prestamo();
                prestamo.setFechaInicio(rs.getDate("p.fecha_prestamo"));
                
                // Agregamos las Fechas de Inicio a la Lista
                prestamos.add(prestamo);
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
        
        return prestamos;
    }

    @Override
    public boolean actualizarFechaPrestamo(Date fechaPrestamo, int idPrestamo) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "UPDATE prestamo SET fecha_prestamo = ? WHERE id_prestamo = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(fechaPrestamo.getTime()));
            ps.setInt(2, idPrestamo);

            return ps.executeUpdate() > 0;

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
    public boolean verificarPrestamoFecha(int idUsuario, Date fechaInicio) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        ResultSet rs;
        String sql = "SELECT COUNT(*) FROM prestamo WHERE usuario_id = ? AND fecha_inicio = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setDate(2, new java.sql.Date(fechaInicio.getTime()));
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
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

    @Override
    public Prestamo obtenerPrestamoPorId(int idPrestamo) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        ResultSet rs;
        String sql = "SELECT\n" +
                "    u.nombre,\n" +
                "    u.telefono,\n" +
                "    p.plazo_meses,\n" +
                "    p.tasa_interes,\n" +
                "    p.monto,\n" +
                "    p.monto_total,\n" +
                "    p.fecha_inicio,\n" +
                "    p.fecha_prestamo,\n" +
                "    p.estado\n" +
                "FROM prestamo p " +
                "INNER JOIN usuario u ON p.usuario_id = u.id_usuario " +
                "WHERE p.id_prestamo = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idPrestamo);
            rs = ps.executeQuery();

            if (rs.next()) {
                Prestamo prestamo = new Prestamo();
                prestamo.setNombreUsuario(rs.getString("u.nombre"));
                prestamo.setTelefonoUsuario(rs.getString("u.telefono"));
                prestamo.setPlazoMeses(rs.getInt("p.plazo_meses"));
                prestamo.setTasaInteres(rs.getDouble("p.tasa_interes"));
                prestamo.setMonto(rs.getDouble("p.monto"));
                prestamo.setMontoTotal(rs.getDouble("p.monto_total"));
                prestamo.setFechaInicio(rs.getDate("p.fecha_inicio"));
                prestamo.setFechaPrestamo(rs.getDate("p.fecha_prestamo"));
                prestamo.setEstado(rs.getString("p.estado"));

                return prestamo;
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
    public ArrayList<Prestamo> obtenerPrestamosExcel() {
        ArrayList<Prestamo> prestamos = new ArrayList<>();
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT\n" +
                "    u.nombre,\n" +
                "    u.telefono,\n" +
                "    p.monto,\n" +
                "    p.tasa_interes,\n" +
                "    p.plazo_meses,\n" +
                "    p.monto_total,\n" +
                "    p.fecha_inicio,\n" +
                "    p.fecha_prestamo,\n" +
                "    p.estado\n" +
                "FROM prestamo p " +
                "INNER JOIN usuario u ON p.usuario_id = u.id_usuario";

        try {
            ps = conexionBD.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Prestamo prestamo = new Prestamo();
                prestamo.setNombreUsuario(rs.getString("u.nombre"));
                prestamo.setTelefonoUsuario(rs.getString("u.telefono"));
                prestamo.setMonto(rs.getDouble("p.monto"));
                prestamo.setTasaInteres(rs.getDouble("p.tasa_interes"));
                prestamo.setPlazoMeses(rs.getInt("p.plazo_meses"));
                prestamo.setMontoTotal(rs.getDouble("p.monto_total"));
                prestamo.setFechaInicio(rs.getDate("p.fecha_inicio"));
                prestamo.setFechaPrestamo(rs.getDate("p.fecha_prestamo"));
                prestamo.setEstado(rs.getString("p.estado"));

                prestamos.add(prestamo);
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

        return prestamos;
    }

    @Override
    public boolean clienteYaTienePrestamoAprobadoHoy(int idUsuario) {
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT COUNT(*) \n"
                     + "FROM prestamo p \n"
                     + "INNER JOIN usuario u ON p.usuario_id = u.id_usuario "
                     + "WHERE p.estado = 'APROBADO' "
                     + "AND p.fecha_prestamo = CURRENT_DATE "
                     + "AND u.id_usuario = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
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
