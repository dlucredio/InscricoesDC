<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    private final static String msgErros = "Houve erros no preenchimento no formulário. Verifique os campos destacados abaixo!";
    private final static String msgCampoObrigatorio = "Este campo é obrigatório!";
    private final static String msgEscolhasDuplicadas = "Você deve escolher linhas de pesquisa diferentes!";

    HashMap<String, String> validarFormulario(HashMap<String, String> formulario) {
        HashMap<String, String> mensagens = new HashMap<String, String>();

        List<String[]> todosOsCampos = new ArrayList<String[]>();

        // Significado do array abaixo
        // Posição 0: nome do campo
        // Posição 1: obrigatorio ou opcional
        todosOsCampos.add(new String[]{"nome", "obrigatorio"});
        todosOsCampos.add(new String[]{"email", "obrigatorio"});
        todosOsCampos.add(new String[]{"skype", "obrigatorio"});
        todosOsCampos.add(new String[]{"rua", "obrigatorio"});
        todosOsCampos.add(new String[]{"numero", "obrigatorio"});
        todosOsCampos.add(new String[]{"complemento", "opcional"});
        todosOsCampos.add(new String[]{"cidade", "obrigatorio"});
        todosOsCampos.add(new String[]{"estado", "opcional"});
        todosOsCampos.add(new String[]{"pais", "obrigatorio"});
        todosOsCampos.add(new String[]{"cep", "obrigatorio"});
        todosOsCampos.add(new String[]{"telefones", "obrigatorio"});
        todosOsCampos.add(new String[]{"identidade", "obrigatorio"});
        todosOsCampos.add(new String[]{"dataIdentidade", "obrigatorio"});
        todosOsCampos.add(new String[]{"orgaoIdentidade", "obrigatorio"});
        todosOsCampos.add(new String[]{"dataNascimento", "obrigatorio"});
        todosOsCampos.add(new String[]{"nacionalidade", "obrigatorio"});
        todosOsCampos.add(new String[]{"lattes", "obrigatorio"});
        todosOsCampos.add(new String[]{"tipoExame", "obrigatorio"});
        todosOsCampos.add(new String[]{"anoExame", "obrigatorio"});
        todosOsCampos.add(new String[]{"primeiraOpcao", "obrigatorio"});
        todosOsCampos.add(new String[]{"segundaOpcao", "opcional"});
        todosOsCampos.add(new String[]{"possuiVinculo", "obrigatorio"});
        todosOsCampos.add(new String[]{"descricaoVinculo", "opcional"});
        todosOsCampos.add(new String[]{"possuiNecessidadesEspeciais", "obrigatorio"});
        todosOsCampos.add(new String[]{"descricaoNecessidadesEspeciais", "opcional"});
        todosOsCampos.add(new String[]{"acordo", "obrigatorio"});

        for (String[] campo : todosOsCampos) {
            String valor = formulario.get(campo[0]);
            if (campo[1].equals("obrigatorio") && valor == null) {
                mensagens.put(campo[0], msgCampoObrigatorio);
            }
        }

        String valorPrimeiraOpcao = formulario.get("primeiraOpcao");
        if (valorPrimeiraOpcao == null || valorPrimeiraOpcao.equals("Nenhuma")) {
            mensagens.put("primeiraOpcao", msgCampoObrigatorio);
        } else {
            String valorSegundaOpcao = formulario.get("segundaOpcao");
            if (valorSegundaOpcao != null && valorSegundaOpcao.equals(valorPrimeiraOpcao)) {
                mensagens.put("segundaOpcao", msgEscolhasDuplicadas);
            }
        }
        return mensagens;
    }
%>

<%
// Obs: estou assumindo que é um formulaŕio multipart
// Caso contrário precisaria testar

    HashMap<String, String> formulario = new HashMap<String, String>();
    String caminho = "/home/cursos/ppg/inscricoes/ppgcc/"; //irá conter o endereço onde o arquivo deverá ser gravado
    String caminhoTemp = caminho + "temp/";

    out.println("Validando formulário...<br/>");
// Create a factory for disk-based file items
    DiskFileItemFactory factory = new DiskFileItemFactory();

    File pastaTemporaria = new File(caminhoTemp);
    factory.setRepository(pastaTemporaria);

// Create a new file upload handler
    ServletFileUpload upload = new ServletFileUpload(factory);

// Parse the request
    List<FileItem> items = upload.parseRequest(request);

// Process the uploaded items
    Iterator<FileItem> iter = items.iterator();
    while (iter.hasNext()) {
        FileItem item = iter.next();

        if (item.isFormField()) {
            String name = item.getFieldName();
            String value = item.getString();

            if (value != null && value.trim().length() != 0) {
                formulario.put(name, new String(value.getBytes("iso-8859-1"), "UTF-8"));
            }

            //String txt = value.replaceAll("\\W+", "");
        } else {
            String fieldName = item.getFieldName();
            String fileName = item.getName();
            String contentType = item.getContentType();
            boolean isInMemory = item.isInMemory();
            long sizeInBytes = item.getSize();
        }
    }

    HashMap<String, String> mensagens = validarFormulario(formulario);

    if (!mensagens.isEmpty()) {
        for (String k : mensagens.keySet()) {
            request.setAttribute("erro:" + k, mensagens.get(k));
        }
        for (String k : formulario.keySet()) {
            request.setAttribute(k, formulario.get(k));
        }
        request.setAttribute("msg", msgErros);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }


%>