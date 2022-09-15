<%-- 
    Document   : validarFormulario.jsp
    Created on : 20/04/2016
    Author     : Daniel Lucrédio
--%>

<%@page import="java.io.File"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="inscricoesdc.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/comum.jspf"%>

<%!    HashMap<String, String> validarFormulario(HttpServletRequest request) throws FileNotFoundException, IOException {
        HashMap<String, String> mensagens = new HashMap<String, String>();

        for (ElementoFormulario ef : formulario.getElementos()) {
            String valor = request.getParameter(ef.getNome());
            if (valor != null && valor.trim().length() == 0) {
                valor = null;
            } else if (valor != null) {
                valor = new String(valor.getBytes("iso-8859-1"), "UTF-8");
                ef.setValor(valor);
            }
            boolean isObrigatorio = ef.getRotulo().startsWith("*");
            if (isObrigatorio && valor == null) {
                mensagens.put(ef.getNome(), MSG_CAMPO_OBRIGATORIO);
            }
        }

        return mensagens;
    }
%>

<%
    HashMap<String, String> mensagens = validarFormulario(request);
    for (ElementoFormulario ef : formulario.getElementos()) {
        if(ef.getNome() != null) {
            request.getSession().setAttribute(ef.getNome(), ef.getValor());
        }
    }

    if (!mensagens.isEmpty()) {
        for (String k : mensagens.keySet()) {
            request.setAttribute(MENSAGEM_ERRO_PREFIXO + k, mensagens.get(k));
        }
        request.setAttribute(MENSAGEM_REQUEST_ATTRIBUTE, MSG_ERROS);
        request.getRequestDispatcher(PAGINA_INICIAL + "?" + RETORNO_PARAMETRO + "=1").forward(request, response);
    } else {
        request.getRequestDispatcher(ACAO_FORMULARIO_PARTE2).forward(request, response);
    }
%>