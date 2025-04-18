/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dao.Interfaces.IPagoDAO;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import models.Pago;
import models.Prestamo;
import models.Usuario;
import utils.ConexionMysql;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class PagoDAO implements IPagoDAO {

    @Override
    public boolean generarCuotasPago(int plazoCoutas, Pago pago) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "INSERT INTO pago (prestamo_id, monto_pago, fecha_pago) VALUES (?, ?, ?)";

        try {

            ps = conexionBD.prepareStatement(sql);
            LocalDate fechaInicio = pago.getFechaPago().toLocalDate();

            for (int i = 1; i <= plazoCoutas; i++) {
                LocalDate fechaPago = fechaInicio.plusMonths(i); // Generar Fechas de Pago
                Date fechaPagoSQL = Date.valueOf(fechaPago);

                ps.setInt(1, pago.getPrestamoId());
                ps.setDouble(2, pago.getMontoPago());
                ps.setDate(3, fechaPagoSQL);
                ps.addBatch();
            }

            ps.executeBatch();
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
    public ArrayList<Pago> obtenerPagosCliente(int idUsuario, Date fechaInicio) {
        ArrayList<Pago> pagos = new ArrayList<>();
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        ResultSet rs;
        String sql = "SELECT \n"
                + "pa.id_pago,\n"
                + "p.fecha_prestamo,\n"
                + "pa.monto_pago,\n"
                + "pa.fecha_pago,\n"
                + "pa.estado \n"
                + "FROM pago pa \n"
                + "INNER JOIN prestamo p ON pa.prestamo_id = p.id_prestamo "
                + "WHERE p.usuario_id = ? AND p.fecha_prestamo = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setDate(2, fechaInicio);
            rs = ps.executeQuery();

            while (rs.next()) {
                Pago pago = new Pago();
                pago.setIdPago(rs.getInt("pa.id_pago"));
                pago.setFechaInicioPrestamo(rs.getDate("p.fecha_prestamo"));
                pago.setMontoPago(rs.getDouble("pa.monto_pago"));
                pago.setFechaPago(rs.getDate("pa.fecha_pago"));
                pago.setEstado(rs.getString("pa.estado"));

                // Agregamos los pagos a la lista
                pagos.add(pago);
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

        return pagos;
    }

    @Override
    public boolean pagarCouta(Pago pago) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "UPDATE pago SET estado = ?, fecha_pagada = ? WHERE id_pago = ?";
        
        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, pago.getEstado());
            ps.setDate(2, pago.getFechaPagada());
            ps.setInt(3, pago.getIdPago());
            
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
    public ArrayList<Pago> generarVoucherPago(int idPago) {
        ArrayList<Pago> pagos = new ArrayList<>();
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT\n" +
                "    u.nombre,\n" +
                "    u.telefono,\n" +
                "    p.monto_total,\n" +
                "    p.fecha_inicio,\n" +
                "    pa.id_pago,\n" +
                "    pa.monto_pago,\n" +
                "    pa.fecha_pago,\n" +
                "    pa.fecha_pagada,\n" +
                "    pa.estado \n" +
                "FROM pago pa\n" +
                "INNER JOIN prestamo p ON pa.prestamo_id = p.id_prestamo " +
                "INNER JOIN usuario u ON u.id_usuario = p.usuario_id " +
                "WHERE pa.id_pago = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idPago);
            rs = ps.executeQuery();

            while (rs.next()) {
                Pago pago = new Pago();
                pago.setIdPago(rs.getInt("pa.id_pago"));
                pago.setMontoPago(rs.getDouble("pa.monto_pago"));
                pago.setFechaPago(rs.getDate("pa.fecha_pago"));
                pago.setFechaPagada(rs.getDate("pa.fecha_pagada"));
                pago.setEstado(rs.getString("pa.estado"));

                Usuario usuario = new Usuario();
                usuario.setNombre(rs.getString("u.nombre"));
                usuario.setTelefono(rs.getString("u.telefono"));

                Prestamo prestamo = new Prestamo();
                prestamo.setMontoTotal(rs.getDouble("p.monto_total"));
                prestamo.setFechaInicio(rs.getDate("p.fecha_inicio"));

                pago.setUsuario(usuario);
                pago.setPrestamo(prestamo);

                // Agregamos los resultados en la Lista Pagos
                pagos.add(pago);
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

        return pagos;
    }

    @Override
    public ArrayList<Pago> obtenerPagosPorIdPrestamo(int idPrestamo) {
        ArrayList<Pago> pagos = new ArrayList<>();
        PreparedStatement ps;
        ResultSet rs;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "SELECT * FROM pago WHERE prestamo_id = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, idPrestamo);
            rs = ps.executeQuery();

            while (rs.next()) {
                Pago pago = new Pago();
                pago.setIdPago(rs.getInt("id_pago"));
                pago.setMontoPago(rs.getDouble("monto_pago"));
                pago.setFechaPago(rs.getDate("fecha_pago"));
                pagos.add(pago);
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

        return pagos;
    }

}
