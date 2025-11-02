<%@ page import="java.sql.*" %>
<%@ page import="utils.ConexionBD" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Verificamos si el usuario está logueado
    boolean logueado = session.getAttribute("usuarioId") != null;

    // Variables para mostrar mensajes
    String msg = "";
    String errorMsg = "";
    String modalTitle = "";
    String modalBody = "";
    String modalType = ""; // "success" o "danger"

    String action = request.getParameter("action");

    if (logueado) {

        // ===========================
        // GESTIÓN DE ESTUDIANTES
        // ===========================
        if ("agregar".equals(action)) {
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String direccion = request.getParameter("direccion");
            String telefono = request.getParameter("telefono");

            if (nombre != null && edadStr != null && direccion != null && telefono != null &&
                    !nombre.isEmpty() && !edadStr.isEmpty() && !direccion.isEmpty() && !telefono.isEmpty()) {

                try (Connection conn = ConexionBD.obtenerConexion()) {
                    String sqlInsert = "INSERT INTO estudiantes (nombre, edad, direccion, telefono) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                        ps.setString(1, nombre);
                        ps.setInt(2, Integer.parseInt(edadStr));
                        ps.setString(3, direccion);
                        ps.setString(4, telefono);
                        ps.executeUpdate();
                        msg = "Estudiante agregado correctamente.";
                        modalTitle = "¡Éxito!";
                        modalBody = msg;
                        modalType = "success";
                    }
                } catch (SQLException e) {
                    errorMsg = "Error al agregar estudiante: " + e.getMessage();
                    modalTitle = "Error";
                    modalBody = errorMsg;
                    modalType = "danger";
                }
            } else {
                errorMsg = "Por favor, completa todos los campos.";
                modalTitle = "Error";
                modalBody = errorMsg;
                modalType = "danger";
            }
        } else if ("eliminar".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try (Connection conn = ConexionBD.obtenerConexion()) {
                    String sqlDelete = "DELETE FROM estudiantes WHERE id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
                        ps.setInt(1, Integer.parseInt(idStr));
                        ps.executeUpdate();
                        msg = "Estudiante eliminado correctamente.";
                        modalTitle = "¡Éxito!";
                        modalBody = msg;
                        modalType = "success";
                    }
                } catch (SQLException e) {
                    errorMsg = "Error al eliminar estudiante: " + e.getMessage();
                    modalTitle = "Error";
                    modalBody = errorMsg;
                    modalType = "danger";
                }
            }
        } else if ("actualizar".equals(action)) {
            String idStr = request.getParameter("id");
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String direccion = request.getParameter("direccion");
            String telefono = request.getParameter("telefono");

            if (idStr != null && nombre != null && edadStr != null && direccion != null && telefono != null &&
                    !nombre.isEmpty() && !edadStr.isEmpty() && !direccion.isEmpty() && !telefono.isEmpty()) {

                try (Connection conn = ConexionBD.obtenerConexion()) {
                    String sqlUpdate = "UPDATE estudiantes SET nombre = ?, edad = ?, direccion = ?, telefono = ? WHERE id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                        ps.setString(1, nombre);
                        ps.setInt(2, Integer.parseInt(edadStr));
                        ps.setString(3, direccion);
                        ps.setString(4, telefono);
                        ps.setInt(5, Integer.parseInt(idStr));
                        ps.executeUpdate();
                        msg = "Estudiante actualizado correctamente.";
                        modalTitle = "¡Éxito!";
                        modalBody = msg;
                        modalType = "success";
                    }
                } catch (SQLException e) {
                    errorMsg = "Error al actualizar estudiante: " + e.getMessage();
                    modalTitle = "Error";
                    modalBody = errorMsg;
                    modalType = "danger";
                }
            } else {
                errorMsg = "Por favor, completa todos los campos para actualizar.";
                modalTitle = "Error";
                modalBody = errorMsg;
                modalType = "danger";
            }
        }

        // ===========================
        // GESTIÓN DE NOTAS
        // ===========================
        else if ("agregar_nota".equals(action)) {
            String estudianteId = request.getParameter("estudiante_id");
            String gradoId = request.getParameter("grado_id");
            String materiaId = request.getParameter("materia_id");
            String notaFinalStr = request.getParameter("nota_final");

            if(estudianteId != null && gradoId != null && materiaId != null && notaFinalStr != null &&
                    !estudianteId.isEmpty() && !gradoId.isEmpty() && !materiaId.isEmpty() && !notaFinalStr.isEmpty()) {
                try(Connection conn = ConexionBD.obtenerConexion()) {
                    String sqlInsert = "INSERT INTO notas (estudiante_id, grado_id, materia_id, nota_final) VALUES (?, ?, ?, ?)";
                    try(PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                        ps.setInt(1, Integer.parseInt(estudianteId));
                        ps.setInt(2, Integer.parseInt(gradoId));
                        ps.setInt(3, Integer.parseInt(materiaId));
                        ps.setDouble(4, Double.parseDouble(notaFinalStr));
                        ps.executeUpdate();
                        msg = "Nota registrada correctamente.";
                        modalTitle = "¡Éxito!";
                        modalBody = msg;
                        modalType = "success";
                    }
                } catch(SQLException e) {
                    errorMsg = "Error al registrar nota: " + e.getMessage();
                    modalTitle = "Error";
                    modalBody = errorMsg;
                    modalType = "danger";
                }
            } else {
                errorMsg = "Por favor completa todos los campos.";
                modalTitle = "Error";
                modalBody = errorMsg;
                modalType = "danger";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Gestión de Estudiantes y Notas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5">

<% if (!logueado) { %>
<h1>Bienvenido</h1>
<p>Por favor inicia sesión o crea una cuenta:</p>
<a href="login.jsp" class="btn btn-primary me-2">Iniciar Sesión</a>
<a href="registro.jsp" class="btn btn-success">Crear Cuenta</a>

<% } else { %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1>Gestión de Estudiantes y Notas</h1>
    <a href="logout.jsp" class="btn btn-danger">Cerrar Sesión</a>
</div>

<!-- Modal Bootstrap para mensajes -->
<div class="modal fade" id="mensajeModal" tabindex="-1" aria-labelledby="mensajeModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-<%= modalType %>">
            <div class="modal-header bg-<%= modalType %> text-white">
                <h5 class="modal-title" id="mensajeModalLabel"><%= modalTitle %></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body"><%= modalBody %></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-<%= modalType %>" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<!-- FORMULARIO AGREGAR ESTUDIANTE -->
<h3>Registrar nuevo estudiante</h3>
<form method="post" action="${pageContext.request.requestURI}?action=agregar" class="row g-3 mb-5">
    <div class="col-md-3">
        <input type="text" name="nombre" class="form-control" placeholder="Nombre completo" required />
    </div>
    <div class="col-md-2">
        <input type="number" name="edad" class="form-control" placeholder="Edad" required />
    </div>
    <div class="col-md-4">

        <input type="text" name="direccion" class="form-control" placeholder="Dirección" required />
    </div>
    <div class="col-md-2">
        <input type="text" name="telefono" class="form-control" placeholder="Teléfono" required />
    </div>
    <div class="col-md-1">
        <button type="submit" class="btn btn-primary w-100">Agregar</button>
    </div>
</form>

<!-- TABLA DE ESTUDIANTES -->
<table class="table table-striped table-bordered align-middle mb-5">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Nombre completo</th>
        <th>Edad</th>
        <th>Dirección</th>
        <th>Teléfono</th>
    </tr>
    </thead>
    <tbody>
    <%
        try(Connection conn = ConexionBD.obtenerConexion()) {
            String sql = "SELECT * FROM estudiantes ORDER BY id ASC";
            try(PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    int id = rs.getInt("id");
                    String nombre = rs.getString("nombre");
                    int edad = rs.getInt("edad");
                    String direccion = rs.getString("direccion");
                    String telefono = rs.getString("telefono");
    %>
    <tr>
        <td><%= id %></td>
        <td><%= nombre %></td>
        <td><%= edad %></td>
        <td><%= direccion %></td>
        <td><%= telefono %></td>
    </tr>
    <%
            }
        }
    } catch(SQLException e) {
    %>
    <tr>
        <td colspan="5" class="text-danger">Error al cargar estudiantes: <%= e.getMessage() %></td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

<!-- FORMULARIO AGREGAR NOTA -->
<h3>Registrar nueva nota</h3>
<form method="post" action="${pageContext.request.requestURI}?action=agregar_nota" class="row g-3 mb-5">
    <div class="col-md-3">
        <select name="estudiante_id" class="form-select" required>
            <option value="">Selecciona estudiante</option>
            <%
                try(Connection conn = ConexionBD.obtenerConexion()) {
                    String sql = "SELECT id, nombre FROM estudiantes ORDER BY nombre ASC";
                    try(PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                        while(rs.next()) {
            %>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %></option>
            <%
                        }
                    }
                } catch(SQLException e) {}
            %>
        </select>
    </div>
    <div class="col-md-3">
        <select name="grado_id" class="form-select" required>
            <option value="">Selecciona grado</option>
            <%
                try(Connection conn = ConexionBD.obtenerConexion()) {
                    String sql = "SELECT id, nombre FROM grados ORDER BY id ASC";
                    try(PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                        while(rs.next()) {
            %>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %></option>
            <%
                        }
                    }
                } catch(SQLException e) {}
            %>
        </select>
    </div>
    <div class="col-md-3">
        <select name="materia_id" class="form-select" required>
            <option value="">Selecciona materia</option>
            <%
                try(Connection conn = ConexionBD.obtenerConexion()) {
                    String sql = "SELECT id, nombre FROM materias ORDER BY nombre ASC";
                    try(PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                        while(rs.next()) {
            %>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %></option>
            <%
                        }
                    }
                } catch(SQLException e) {}
            %>
        </select>
    </div>
    <div class="col-md-2">
        <input type="number" name="nota_final" class="form-control" placeholder="Nota final" step="0.01" min="0" max="100" required />
    </div>
    <div class="col-md-1">
        <button type="submit" class="btn btn-primary w-100">Agregar</button>
    </div>
</form>

<!-- TABLA DE NOTAS -->
<table class="table table-striped table-bordered align-middle">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Estudiante</th>
        <th>Grado</th>
        <th>Materia</th>
        <th>Nota final</th>
    </tr>
    </thead>
    <tbody>
    <%
        try(Connection conn = ConexionBD.obtenerConexion()) {
            String sql = "SELECT id_nota, estudiante, grado, materia, nota_final FROM vista_notas ORDER BY id_nota ASC";
            try(PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id_nota") %></td>
        <td><%= rs.getString("estudiante") %></td>
        <td><%= rs.getString("grado") %></td>
        <td><%= rs.getString("materia") %></td>
        <td><%= rs.getDouble("nota_final") %></td>
    </tr>
    <%
            }
        }
    } catch(SQLException e) {
    %>
    <tr>
        <td colspan="5" class="text-danger">Error al cargar notas: <%= e.getMessage() %></td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%
    if (!modalBody.isEmpty()) {
%>
<script>
    var myModal = new bootstrap.Modal(document.getElementById('mensajeModal'), {});
    myModal.show();
</script>
<%
    }
%>
</body>
</html>
