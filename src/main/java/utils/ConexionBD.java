package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    private static final String URL = "jdbc:mysql://localhost:3306/colegio_sistema?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "AnimalBonito1478!"; //

    public static Connection obtenerConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("No se encontró el driver de MySQL", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
//CREATE DATABASE colegio_sistema
//USE colegio_sistema;
//
//
//CREATE TABLE usuarios (
//  id INT AUTO_INCREMENT PRIMARY KEY,
//  nombre VARCHAR(100) NOT NULL,
//  email VARCHAR(100) UNIQUE NOT NULL,
//  password VARCHAR(255) NOT NULL
//);
//
//
//INSERT INTO usuarios (nombre, email, password) VALUES
//('Juan Pérez', 'juan.perez@mail.com', '1234'),
//('María López', 'maria.lopez@mail.com', '1234');
//
//
//  id INT AUTO_INCREMENT PRIMARY KEY,
//  nombre VARCHAR(100) NOT NULL,
//  edad INT,
//  direccion VARCHAR(255),
//  telefono VARCHAR(15)
//);
//
//
//INSERT INTO estudiantes (nombre, edad, direccion, telefono) VALUES
//('Carlos Sánchez', 15, 'Calle 123', '555-1234'),
//('Ana Gómez', 16, 'Av. Central 45', '555-5678'),
//('Luis Fernández', 17, 'Calle 10 #45', '555-9012');
//
//
//CREATE TABLE grados (
//  id INT AUTO_INCREMENT PRIMARY KEY,
//  nombre VARCHAR(50) NOT NULL
//);
//
//INSERT INTO grados (nombre) VALUES
//('1° Primaria'),
//('2° Primaria'),
//('3° Primaria'),
//('4° Primaria'),
//('5° Primaria'),
//('6° Primaria');
//
//
//CREATE TABLE materias (
//  id INT AUTO_INCREMENT PRIMARY KEY,
//  nombre VARCHAR(100) NOT NULL
//);
//
//INSERT INTO materias (nombre) VALUES
//('Matemáticas'),
//('Lengua Española'),
//('Ciencias Naturales'),
//('Estudios Sociales'),
//('Educación Física');
//
//
//CREATE TABLE notas (
//  id INT AUTO_INCREMENT PRIMARY KEY,
//  estudiante_id INT NOT NULL,
//  grado_id INT NOT NULL,
//  materia_id INT NOT NULL,
//  nota_final DECIMAL(5,2) NOT NULL CHECK (nota_final BETWEEN 0 AND 100),
//  FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id) ON DELETE CASCADE,
//  FOREIGN KEY (grado_id) REFERENCES grados(id) ON DELETE CASCADE,
//  FOREIGN KEY (materia_id) REFERENCES materias(id) ON DELETE CASCADE
//);
//
//-- Datos de ejemplo
//INSERT INTO notas (estudiante_id, grado_id, materia_id, nota_final) VALUES
//(1, 1, 1, 85.5),
//(1, 1, 2, 90.0),
//(2, 2, 3, 78.0);
//
//
//CREATE VIEW vista_notas AS
//SELECT
//  n.id AS id_nota,
//  e.nombre AS estudiante,
//  g.nombre AS grado,
//  m.nombre AS materia,
//  n.nota_final
//FROM notas n
//JOIN estudiantes e ON n.estudiante_id = e.id
//JOIN grados g ON n.grado_id = g.id
//JOIN materias m ON n.materia_id = m.id;