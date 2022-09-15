<%-- 
    Document   : documentosAdicionais,jsp
    Created on : 25/04/2016, 11:28:26
    Author     : Daniel Lucrédio
--%>

<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.util.NoSuchElementException"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/comum.jspf"%>

<%!    String processarTitulo() {
        StringBuilder out = new StringBuilder();
        out.append("");
        String titulo = formulario.getTitulo().replaceAll("\\\\n", "<br/>");
        out.append("<p>" + titulo + "</p>");
        out.append("</div>");
        out.append("\n");

        out.append("<div class=\"alert alert-warning\">");
        out.append("<strong>Atenção!</strong> TODOS os documentos listados a seguir são necessários para a inscrição!");
        out.append("</div>");
        out.append("\n");
        return out.toString();
    }

    String processarDocumentosFormulario() {
        StringBuilder out = new StringBuilder();
        
        for(Documento doc:formulario.getDocumentos()) {
            out.append("<div class=\"well well-sm\">");
            out.append("<p>");
            out.append(doc.getRotulo());
            out.append("</p>");
            out.append("<label for=\""+doc.getNome()+"\">");
            out.append(doc.getDescricao());
            out.append("</label>");
            out.append("<input type=\"file\" name=\""+doc.getNome()+"\" id=\""+doc.getNome()+"\"/>");
            out.append("</div>");
        }
        
        return out.toString();
    }

%>

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
                <p><%=formulario.getTitulo().replaceAll("\\\\n", "<br/>")%>;
            </div>

            <div class="alert alert-warning">
                <strong>Atenção!</strong> TODOS os documentos listados a seguir são necessários para a inscrição!
                O tamanho máximo permitido é 4 Mbytes por documento!
            </div>


            <%
                List<String> mensagens = (List<String>) request.getAttribute(MENSAGEM_REQUEST_ATTRIBUTE);
                if (mensagens != null && !mensagens.isEmpty()) {
                    for (String msg : mensagens) {%>
            <div class="alert alert-danger">
                <strong>Atenção!</strong> <%=msg%>
            </div>

            <%      }
                }
            %>
            <div class="col-md-12">
                <form role="form" action="<%=ACAO_FORMULARIO_PARTE4%>?<%=ID_FORMULARIO%>=<%=formulario.getNomeComposto()%>" method="post" enctype="multipart/form-data" >
                    <%=processarDocumentosFormulario()%>

                    <div class="well well-sm">
                        <p>Atenção. Certifique-se de que todos os documentos enviados
                            estejam completos, no formato especificado e com boa
                            qualidade. Caso existam documentos em formato errado,
                            incompletos ou ilegíveis a inscrição poderá ser indeferida.</p>
                    </div>
                    <div class="form-group"> 
                        <button type="submit" class="btn btn-default">Concluir inscrição</button>
                        <a href="<%=PAGINA_INICIAL%>?<%=ID_FORMULARIO%>=<%=formulario.getNomeComposto()%>&<%=RETORNO_PARAMETRO%>=1" class="btn btn-default">Voltar para o formulário</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>