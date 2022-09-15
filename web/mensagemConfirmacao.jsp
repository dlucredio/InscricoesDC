<%-- 
    Document   : mensagemConfirmacao.jsp
    Created on : 25/04/2016, 16:21:36
    Author     : Daniel Lucrédio
--%>

<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.util.NoSuchElementException"%>
<%@page import="java.util.NoSuchElementException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/comum.jspf"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title><%=formulario.getTitulo()%></title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    </head>
    <body>
        <div class="container">
            <div class="jumbotron text-center">
                <p><%=formulario.getTitulo().replaceAll("\\\\n", "<br/>")%></p>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <p>Sua inscrição foi recebida com sucesso. Uma mensagem
                        foi automaticamente enviada para o endereço de e-mail informado
                        no formulário, apenas para informar este recebimento.</p>
                    <p><%=formulario.getMsgFinal()%></p>
                    <p>Anote o seguinte protocolo para futuras referências:</p>
                    <pre><%=(String) request.getAttribute(PROTOCOLO_REQUEST_ATTRIBUTE)%></pre> 
                </div>
            </div>
        </div>
    </body>
</html>
