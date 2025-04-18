/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao.Interfaces;

import java.sql.Date;
import java.util.ArrayList;
import models.Pago;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public interface IPagoDAO {

    boolean generarCuotasPago(int plazoCoutas, Pago pago);

    ArrayList<Pago> obtenerPagosCliente(int idUsuario, Date fechaInicio);

    boolean pagarCouta(Pago pago);

    ArrayList<Pago> generarVoucherPago(int idPago);

    ArrayList<Pago> obtenerPagosPorIdPrestamo(int idPrestamo);
}
