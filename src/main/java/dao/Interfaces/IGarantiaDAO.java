/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao.Interfaces;

import models.Garantia;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public interface IGarantiaDAO {

    boolean registrarGarantia(Garantia garantia);
    boolean actualizarEstadoGarantia (Garantia garantia);
}
