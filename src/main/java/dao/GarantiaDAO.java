/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dao.Interfaces.IGarantiaDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import models.Garantia;
import utils.ConexionMysql;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class GarantiaDAO implements IGarantiaDAO {

    @Override
    public boolean registrarGarantia(Garantia garantia) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "INSERT INTO garantia (prestamo_id, tipo, descripcion, valor_garantia) VALUES (?, ?, ?, ?)";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setInt(1, garantia.getPrestamoId());
            ps.setString(2, garantia.getTipo());
            ps.setString(3, garantia.getDescripcion());
            ps.setDouble(4, garantia.getValorGarantia());
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
    public boolean actualizarEstadoGarantia(Garantia garantia) {
        PreparedStatement ps;
        Connection conexionBD = ConexionMysql.getConexion();
        String sql = "UPDATE garantia SET estado = ? WHERE prestamo_id = ?";

        try {
            ps = conexionBD.prepareStatement(sql);
            ps.setString(1, garantia.getEstado());
            ps.setInt(2, garantia.getPrestamoId());

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

}
