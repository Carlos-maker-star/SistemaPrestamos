/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author CARLOS RIVADENEYRA
 */
public class ConexionMysql {
    
    public static Connection getConexion () {
        Connection conexion = null;
        String bd = "sistemaPrestamos";
        String url = "jdbc:mysql://localhost:3306/" + bd;
        String usuario = "root";
        String password = "72731974";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection(url, usuario, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return conexion;
    }

}
