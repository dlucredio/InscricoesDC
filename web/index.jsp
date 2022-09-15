<%--
    Document   : index.jsp
    Created on : 20/04/2016
    Author     : Daniel Lucrédio
--%>

<%@page import="java.io.StringWriter"%>
<%@page import="inscricoesdc.BotaoEnviar"%>
<%@page import="inscricoesdc.CampoCheckbox"%>
<%@page import="inscricoesdc.CampoTextArea"%>
<%@page import="inscricoesdc.CampoSelect"%>
<%@page import="inscricoesdc.CampoRadio"%>
<%@page import="inscricoesdc.CampoSimples.TipoCampoSimples"%>
<%@page import="inscricoesdc.CampoSimples"%>
<%@page import="inscricoesdc.Grupo"%>
<%@page import="inscricoesdc.ElementoFormulario"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.PrintStream"%>
<%@page import="inscricoesdc.FabricaFormulario"%>
<%@page import="inscricoesdc.Formulario"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.NoSuchElementException"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="javax.servlet.ServletConfig"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/comum.jspf"%>
<%!    
    int larguraAtual;
    boolean temGrupoAtivo;
    boolean temLinhaAtiva;

    String processarFormulario(HttpServletRequest request) throws FileNotFoundException, IOException, NoSuchElementException {
        larguraAtual = 0;
        temGrupoAtivo = false;
        temLinhaAtiva = false;
        StringBuilder out = new StringBuilder();
        processarNomeFormulario(request, out, formulario.getNomeComposto());
        processarTitulo(request, out, formulario.getTitulo());

        for (ElementoFormulario ef : formulario.getElementos()) {
            if (ef instanceof Grupo) {
                processarGrupo(out, (Grupo) ef);
            } else if (ef instanceof CampoSimples) {
                processarCampoSimples(request, out, (CampoSimples) ef);
            } else if (ef instanceof CampoRadio) {
                processarCampoRadio(request, out, (CampoRadio) ef);
            } else if (ef instanceof CampoSelect) {
                processarCampoSelect(request, out, (CampoSelect) ef);
            } else if (ef instanceof CampoTextArea) {
                processarCampoTextArea(request, out, (CampoTextArea) ef);
            } else if (ef instanceof CampoCheckbox) {
                processarCampoCheckbox(request, out, (CampoCheckbox) ef);
            } else if (ef instanceof BotaoEnviar) {
                processarBotaoEnviar(out, (BotaoEnviar) ef);
            }
        }
        return out.toString();
    }

    void processarNomeFormulario(HttpServletRequest request, StringBuilder out, String nomeCompostoFormulario) {
        out.append("<input type=\"hidden\" name=\""+ID_FORMULARIO+"\" value=\""+nomeCompostoFormulario+"\" />");
    }
    
    void processarTitulo(HttpServletRequest request, StringBuilder out, String titulo) {
        out.append("<div class=\"jumbotron text-center\">");
        String tituloFormatado = titulo.replaceAll("\\\\n", "<br/>");
        out.append("<p>" + tituloFormatado + "</p>");
        out.append("</div>");
        out.append("\n");

        String msg = (String) request.getAttribute(MENSAGEM_REQUEST_ATTRIBUTE);
        if (msg != null) {
            out.append("<div class=\"alert alert-danger\"><strong>Atenção!</strong> " + msg + "</div>");
        } else {
            out.append("<div class=\"alert alert-warning\"><strong>Atenção!</strong> Os campos marcados com * são obrigatórios!</div>");
        }
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

    void processarCampoSimples(HttpServletRequest request, StringBuilder out, CampoSimples cs) {
        processarPreLinha(out);

        out.append("<div class=\"form-group " + BOOTSTRAP_COL_PREFIXO + cs.getLargura()
                + errorPart(request, cs.getNome(), " has-error")
                + "\">");

        out.append("<label for=\"" + cs.getNome() + "\" "
                + errorPart(request, cs.getNome(), "class=\"text-danger\"")
                + ">" + cs.getRotulo() + " " + errorPart(request, cs.getNome(), null)
                + "</label>");

        String placeHolderTxt = "placeholder=\"" + cs.getValorPadrao() + "\"";

        String requiredTxt = "";
        if (cs.getRotulo().startsWith("*")) {
            requiredTxt = REQUIRED_TXT;
        }

        String tipo = "";
        if (cs.getTipoCampoSimples() == TipoCampoSimples.Data) {
            tipo = "date";
        } else if (cs.getTipoCampoSimples() == TipoCampoSimples.Email) {
            tipo = "email";
        } else if (cs.getTipoCampoSimples() == TipoCampoSimples.URL) {
            tipo = "url";
        } else if (cs.getTipoCampoSimples() == TipoCampoSimples.Texto) {
            tipo = "text";
        }

        out.append("<input type=\"" + tipo + "\" " + requiredTxt + " class=\"form-control\" name=\"" + cs.getNome() + "\" id=\"" + cs.getNome() + "\" " + placeHolderTxt + " value=\""
                + getAttribute(request, cs.getNome())
                + "\">");
        out.append("</div>");
        out.append("\n");

        larguraAtual += cs.getLargura();
        processarPosLinha(out);
    }

    void processarCampoRadio(HttpServletRequest request, StringBuilder out, CampoRadio cr) throws IOException {

        String requiredTxt = "";
        if (cr.getRotulo().startsWith("*")) {
            requiredTxt = REQUIRED_TXT;
        }

        forcarFimLinha(out);

        out.append("<div class=\"form-group " + errorPart(request, cr.getNome(), "has-error text-danger") + "\">");
        out.append("<label for=\"" + cr.getNome() + "\">" + cr.getRotulo() + " " + errorPart(request, cr.getNome(), null) + "</label>");
        out.append("<br/>\n");
        for (String op : cr.getOpcoes()) {
            out.append("<label class=\"radio-inline\">");
            out.append("<input type=\"radio\" " + requiredTxt + " name=\"" + cr.getNome() + "\" "
                    + "value=\"" + op + "\" " + isAttributeChecked(request, cr.getNome(), op) + ">" + op + "</label><br/>");

        }
        out.append("</div>");
        out.append("\n");

    }

    void processarCampoSelect(HttpServletRequest request, StringBuilder out, CampoSelect cs) throws IOException {
        forcarFimLinha(out);

        String requiredTxt = "";
        if (cs.getRotulo().startsWith("*")) {
            requiredTxt = REQUIRED_TXT;
        }

        out.append("<div class=\"form-group " + errorPart(request, cs.getNome(), "has-error text-danger") + "\">");
        out.append("<label for=\"" + cs.getNome() + "\">" + cs.getRotulo() + " " + errorPart(request, cs.getNome(), null) + "</label>");
        out.append("<select " + requiredTxt + " class=\"form-control\" name=\"" + cs.getNome() + "\" id=\"" + cs.getNome() + "\">");
        for (String op : cs.getOpcoes()) {
            out.append("<option " + isAttributeSelected(request, cs.getNome(), op) + ">" + op + "</option>");
        }
        out.append("</select>");
        out.append("</div>");
        out.append("\n");

    }

    void processarCampoTextArea(HttpServletRequest request, StringBuilder out, CampoTextArea cta) {
        forcarFimLinha(out);

        String requiredTxt = "";
        if (cta.getRotulo().startsWith("*")) {
            requiredTxt = REQUIRED_TXT;
        }

        out.append("<div class=\"form-group\">");
        out.append("<label for=\"" + cta.getNome() + "\">" + cta.getRotulo() + "</label>");
        out.append("<textarea " + requiredTxt + " class=\"form-control\" rows=\"" + TAMANHO_TEXTAREA + "\" name=\"" + cta.getNome() + "\" id=\"" + cta.getNome() + "\">" + getAttribute(request, cta.getNome()) + "</textarea>");
        out.append("</div>");
        out.append("\n");
    }

    void processarCampoCheckbox(HttpServletRequest request, StringBuilder out, CampoCheckbox cc) {
        forcarFimLinha(out);

        String requiredTxt = "";
        if (cc.getRotulo().startsWith("*")) {
            requiredTxt = REQUIRED_TXT;
        }

        out.append("<div class=\"form-group " + errorPart(request, cc.getNome(), "has-error text-danger") + "\">");
        out.append("<div class=\"checkbox\">");
        out.append("<label><input type=\"checkbox\" " + requiredTxt + " name=\"" + cc.getNome() + "\" value=\"" + VALOR_CHECKBOX_SELECIONADO + "\" " + isAttributeChecked(request, cc.getNome(), VALOR_CHECKBOX_SELECIONADO) + "> " + cc.getRotulo() + " " + errorPart(request, cc.getNome(), null) + "</label>");
        out.append("</div>");
        out.append("</div>");
        out.append("\n");
    }

    void processarBotaoEnviar(StringBuilder out, BotaoEnviar be) {
        if (temGrupoAtivo) {
            out.append("\n</div>\n");
            temGrupoAtivo = false;
        }

        out.append("<div class=\"form-group\">");
        out.append("<button type=\"submit\" class=\"btn btn-default\">" + be.getRotulo() + "</button>");
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

    String isAttributeSelected(HttpServletRequest request, String name, String value) {
        String ret = (String) request.getSession().getAttribute(name);
        if (ret == null) {
            return "";
        }
        if (!ret.equals(value)) {
            return "";
        }
        return "selected";
    }

    String isAttributeChecked(HttpServletRequest request, String name, String value) {
        String ret = (String) request.getSession().getAttribute(name);
        if (ret == null) {
            return "";
        }
        if (!ret.equals(value)) {
            return "";
        }
        return "checked";
    }

    String errorPart(HttpServletRequest request, String fieldName, String errorText) {
        String msg = (String) request.getAttribute(MENSAGEM_ERRO_PREFIXO + fieldName);
        if (msg != null) {
            if (errorText != null) {
                return errorText;
            } else {
                return "(" + msg + ")";
            }
        }
        return "";
    }

    void limparSessao(HttpServletRequest request) {
        if (request.getParameter(RETORNO_PARAMETRO) == null) {
            request.getSession().invalidate();
        }
    }
%>

<% limparSessao(request); %>

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
                    <form role="form" action="<%=ACAO_FORMULARIO_PARTE1%>" method="post">
                        <%=processarFormulario(request)%>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>