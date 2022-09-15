<%-- 
    Document   : confirmarDados
    Created on : 25/04/2016, 10:47:25
    Author     : Daniel Lucrédio
--%>

<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.util.NoSuchElementException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/comum.jspf"%>

<%!    int larguraAtual;
    boolean temGrupoAtivo;
    boolean temLinhaAtiva;

    String processarFormulario(HttpServletRequest request) throws FileNotFoundException, IOException, NoSuchElementException, ParseException {
        larguraAtual = 0;
        temGrupoAtivo = false;
        temLinhaAtiva = false;
        StringBuilder out = new StringBuilder();
        processarTitulo(request, out, formulario.getTitulo());

        for (ElementoFormulario ef : formulario.getElementos()) {
            if (ef instanceof Grupo) {
                processarGrupo(out, (Grupo) ef);
            } else if (ef instanceof CampoSimples) {
                processarCampoSimples(request, out, (CampoSimples) ef);
            } else if (ef instanceof CampoMultiplaEscolha) {
                processarCampoMultiplaEscolha(request, out, (CampoMultiplaEscolha) ef);
            } else if (ef instanceof CampoTextArea || ef instanceof CampoCheckbox) {
                processarCampoLarguraMaxima(request, out, ef);
            } else if (ef instanceof BotaoEnviar) {
                processarBotaoEnviar(out, (BotaoEnviar) ef);
            }
        }
        return out.toString();
    }

    void processarTitulo(HttpServletRequest request, StringBuilder out, String titulo) {
        String tituloFormatado = titulo.replaceAll("\\\\n", "<br/>");
        out.append("<div class=\"jumbotron text-center\">");
        out.append("<p>" + tituloFormatado + "</p>");
        out.append("</div>");
        out.append("\n");

        out.append("<div class=\"alert alert-warning\">");
        out.append("<strong>Atenção!</strong> Confira atentamente os dados abaixo antes de realizar a submissão!");
        out.append("</div>");
        out.append("\n");
    }

    void processarGrupo(StringBuilder out, Grupo grupo) {
        if (temGrupoAtivo) {
            out.append("\n</div>\n");
        } else {
            temGrupoAtivo = true;
        }
        out.append("<div class=\"well well-sm\">");
        out.append("<p>" + grupo.getRotulo() + "</p>");
        out.append("\n");
    }

    void processarPreLinha(StringBuilder out) {
        if (!temLinhaAtiva) {
            out.append("<div class=\"row\">");
            temLinhaAtiva = true;
        }

    }

    void processarPosLinha(StringBuilder out) {
        if (temLinhaAtiva && larguraAtual >= 12) {
            larguraAtual = 0;
            temLinhaAtiva = false;
            out.append("</div>");
            out.append("\n");
        }
    }

    void forcarFimLinha(StringBuilder out) {
        if (temLinhaAtiva) {
            larguraAtual = 0;
            temLinhaAtiva = false;
            out.append("</div>");
            out.append("\n");
        }
    }

    void imprimirCampo(StringBuilder out, String rotuloCampo, String valor, int largura) {
        out.append("<div class=\"" + BOOTSTRAP_COL_PREFIXO + largura + "\">");
        out.append("<label>" + rotuloCampo + "</label>");
        out.append("<p class=\"bg-info\">" + valor + "</p>");
        out.append("</div>");
        out.append("\n");

    }

    void processarCampoSimples(HttpServletRequest request, StringBuilder out, CampoSimples cs) throws ParseException {
        processarPreLinha(out);

        String valor = getAttribute(request, cs.getNome());
        if (cs.getTipoCampoSimples() == CampoSimples.TipoCampoSimples.Data) {
            SimpleDateFormat sdf1 = new SimpleDateFormat(FORMATO_DATA_SALVO);
            SimpleDateFormat sdf2 = new SimpleDateFormat(FORMATO_DATA_DESEJADO);
            valor = sdf2.format(sdf1.parse(valor));
        }

        imprimirCampo(out, cs.getRotulo(), valor, cs.getLargura());

        larguraAtual += cs.getLargura();
        processarPosLinha(out);
    }

    void processarCampoMultiplaEscolha(HttpServletRequest request, StringBuilder out, CampoMultiplaEscolha cme) throws IOException {
        int largura = 12;

        forcarFimLinha(out);

        out.append("<div class=\"row\">");

        imprimirCampo(out, cme.getRotulo(), getAttribute(request, cme.getNome()), largura);

        out.append("</div>");
        out.append("\n");

    }

    void processarCampoLarguraMaxima(HttpServletRequest request, StringBuilder out, ElementoFormulario ef) {
        forcarFimLinha(out);

        out.append("<div class=\"row\">");

        imprimirCampo(out, ef.getRotulo(), getAttribute(request, ef.getNome()), 12);

        out.append("</div>");
        out.append("\n");

    }

    void processarBotaoEnviar(StringBuilder out, BotaoEnviar be) {
        if (temGrupoAtivo) {
            out.append("\n</div>\n");
            temGrupoAtivo = false;
        }

        out.append("<div class=\"form-group\">");
        out.append("<a href=\"" + ACAO_FORMULARIO_PARTE3 + "?" + ID_FORMULARIO + "=" + formulario.getNomeComposto() + "\" class=\"btn btn-default\">" + be.getRotuloConfirmar() + "</a>");
        out.append("<a href=\"" + PAGINA_INICIAL + "?" + ID_FORMULARIO + "=" + formulario.getNomeComposto() + "&" + RETORNO_PARAMETRO + "=1" + "\" class=\"btn btn-default\">" + be.getRotuloVoltar() + "</a>");
        out.append("</div>");
        out.append("\n");

    }

    String getAttribute(HttpServletRequest request, String name) {
        String ret = (String) request.getSession().getAttribute(name);
        if (ret == null) {
            return "";
        }
        return ret;
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
            <div class="row">
                <div class="col-md-12">
                    <%=processarFormulario(request)%>
                </div>
            </div>
        </div>
    </body>
</html>