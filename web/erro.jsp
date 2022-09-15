<%-- 
    Document   : erro
    Created on : 28/11/2016, 18:20:49
    Author     : daniellucredio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Erro!</title>
    </head>
    <body>
        Erro: <%=(String)request.getAttribute("stackTrace")%>
    </body>
</html>
