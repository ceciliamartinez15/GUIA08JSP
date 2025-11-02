<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5">
<h2>Iniciar Sesión</h2>

<form method="post" action="login.jsp?action=login">
    <div class="mb-3">
        <input type="email" name="email" class="form-control" placeholder="Email" required>
    </div>
    <div class="mb-3">
        <input type="password" name="password" class="form-control" placeholder="Contraseña" required>
    </div>
    <button type="submit" class="btn btn-primary">Ingresar</button>
</form>

<%
    String action = request.getParameter("action");
    String msg = "";
    String errorMsg = "";

    if("login".equals(action)){
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if(email != null && password != null){
            try(Connection conn = utils.ConexionBD.obtenerConexion()){
                String sql = "SELECT id, nombre, password FROM usuarios WHERE email=?";
                try(PreparedStatement ps = conn.prepareStatement(sql)){
                    ps.setString(1, email);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()){
                        String storedPassword = rs.getString("password");
                        // Si encriptas password, aquí deberías comparar con hash
                        if(storedPassword.equals(password)){
                            // Login exitoso, guardar sesión
                            session.setAttribute("usuarioId", rs.getInt("id"));
                            session.setAttribute("usuarioNombre", rs.getString("nombre"));
                            response.sendRedirect("index.jsp"); // Página principal
                        } else {
                            errorMsg = "Contraseña incorrecta";
                        }
                    } else {
                        errorMsg = "Usuario no encontrado";
                    }
                }
            }catch(SQLException e){
                errorMsg = "Error: " + e.getMessage();
            }
        } else {
            errorMsg = "Todos los campos son obligatorios";
        }
    }
%>

<!-- Mensajes -->
<% if(!msg.isEmpty()) { %>
<div class="alert alert-success mt-3"><%= msg %></div>
<% } %>
<% if(!errorMsg.isEmpty()) { %>
<div class="alert alert-danger mt-3"><%= errorMsg %></div>
<% } %>

</body>
</html>