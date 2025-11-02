<%@ page import="java.sql.*" %>
<%@ page import="utils.ConexionBD" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Cuenta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5">

<h2>Crear Cuenta</h2>

<form method="post" action="registro.jsp?action=crear">
    <div class="mb-3">
        <input type="text" name="nombre" class="form-control" placeholder="Nombre completo" required>
    </div>
    <div class="mb-3">
        <input type="email" name="email" class="form-control" placeholder="Email" required>
    </div>
    <div class="mb-3">
        <input type="password" name="password" class="form-control" placeholder="Contraseña" required>
    </div>
    <button type="submit" class="btn btn-success">Crear cuenta</button>
</form>

<%
    String action = request.getParameter("action");
    String msg = "";
    String errorMsg = "";

    if("crear".equals(action)){
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if(nombre != null && email != null && password != null){
            try(Connection conn = utils.ConexionBD.obtenerConexion()){
                String sql = "INSERT INTO usuarios(nombre, email, password) VALUES(?, ?, ?)";

                // Usamos RETURN_GENERATED_KEYS para obtener el ID del nuevo usuario
                try(PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
                    // Ideal: encriptar la contraseña antes de guardar
                    ps.setString(1, nombre);
                    ps.setString(2, email);
                    ps.setString(3, password);
                    ps.executeUpdate();

                    // Obtenemos el id generado
                    ResultSet keys = ps.getGeneratedKeys();
                    int nuevoId = 0;
                    if(keys.next()){
                        nuevoId = keys.getInt(1);
                    }

                    // Guardamos sesión automáticamente
                    session.setAttribute("usuarioId", nuevoId);
                    session.setAttribute("usuarioNombre", nombre);

                    // Redirigimos al index donde se muestra el CRUD
                    response.sendRedirect("index.jsp");
                    return; // importante para no seguir ejecutando el resto del JSP
                }

            } catch(SQLException e){
                errorMsg = "Error al crear la cuenta: " + e.getMessage();
            }
        } else {
            errorMsg = "Todos los campos son obligatorios.";
        }
    }
%>

<!-- Mensaje de error si ocurre -->
<% if(!errorMsg.isEmpty()){ %>
<div class="alert alert-danger mt-3"><%= errorMsg %></div>
<% } %>

</body>
