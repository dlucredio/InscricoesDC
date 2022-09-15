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
<%!
    private final static String CONFIG_FORMULARIO = "/home/daniel/Projects/formularioWorkspace/configFormulario.txt";

    int larguraAtual;

    String processarFormulario() throws FileNotFoundException, IOException, NoSuchElementException {
        StringBuilder out = new StringBuilder();
        File f = new File(CONFIG_FORMULARIO);
        LineNumberReader lnr = new LineNumberReader(new FileReader(f));
        String line = null;
        while ((line = lnr.readLine()) != null) {
            line = line.trim();
            if (line.startsWith("%")) {
                continue;
            }
            if (line.startsWith("[grupo]")) {
                processarGrupo(out, line);
            } else if (line.startsWith("[texto]")) {
                processarTexto(out, line);
            } else if (line.startsWith("[campoTexto]")) {
                processarCampoTexto(out, line);
            } else if (line.startsWith("[campoData]")) {
                processarCampoData(out, line);
            } else if (line.startsWith("[campoRadio]")) {
                processarCampoRadio(out, line, lnr);
            } else if (line.startsWith("[campoSelect]")) {
                processarCampoSelect(out, line, lnr);
            } else if (line.startsWith("[campoTextArea]")) {
                processarCampoTextArea(out, line);
            } else if (line.startsWith("[campoCheckbox]")) {
                processarCampoCheckbox(out, line);
            }
        }
        return out.toString();
    }

    void processarGrupo(StringBuilder out, String line) {
    }

    void processarTexto(StringBuilder out, String line) {
    }

    void processarCampoTexto(StringBuilder out, String line) {
    }

    void processarCampoData(StringBuilder out, String line) {
    }

    void processarCampoRadio(StringBuilder out, String line, LineNumberReader lnr) {
    }

    void processarCampoSelect(StringBuilder out, String line, LineNumberReader lnr) {
    }

    void processarCampoTextArea(StringBuilder out, String line) {
    }

    void processarCampoCheckbox(StringBuilder out, String line) {
    }

    String getAttribute(HttpServletRequest request, String name) {
        String ret = (String) request.getAttribute(name);
        if (ret == null) {
            return "";
        }
        return ret;
    }

    String getAttributeSelected(HttpServletRequest request, String name, String value) {
        String ret = (String) request.getAttribute(name);
        if (ret == null) {
            return "";
        }
        if (!ret.equals(value)) {
            return "";
        }
        return "selected";
    }

    String getAttributeChecked(HttpServletRequest request, String name, String value) {
        String ret = (String) request.getAttribute(name);
        if (ret == null) {
            return "";
        }
        if (!ret.equals(value)) {
            return "";
        }
        return "checked";
    }

    String errorPart(HttpServletRequest request, String fieldName, String errorText) {
        String msg = (String) request.getAttribute("erro:" + fieldName);
        if (msg != null) {
            if (errorText != null) {
                return errorText;
            } else {
                return "(" + msg + ")";
            }
        }
        return "";
    }

    String errorParts(HttpServletRequest request, String[] fieldNames, String errorText) {
        for (String fn : fieldNames) {
            String ep = errorPart(request, fn, errorText);
            if (ep.length() != 0) {
                return ep;
            }
        }
        return "";
    }

    String printField(HttpServletRequest request, String fieldName, String label, String placeHolder) throws IOException {
        String ret = "";
        ret += "<div class=\"form-group"
                + errorPart(request, fieldName, " has-error has-feedback")
                + "\">";

        ret += "<label for=\"" + fieldName + "\" "
                + errorPart(request, fieldName, "class=\"text-danger\"")
                + ">" + label + " " + errorPart(request, fieldName, null)
                + "</label>";

        String inputType = "text";
        String placeHolderTxt = "placeholder=\"" + placeHolder + "\"";
        if (placeHolder.equals("date")) {
            inputType = "date";
            placeHolderTxt = "";
        }

        ret += "<input type=\"" + inputType + "\" class=\"form-control\" name=\"" + fieldName + "\" id=\"" + fieldName + "\" " + placeHolderTxt + " value=\""
                + getAttribute(request, fieldName)
                + "\">";
        ret += errorPart(request, fieldName, "<span class=\"glyphicon glyphicon-warning-sign form-control-feedback\"></span>");
        ret += "</div>";
        return ret;
    }

    String printFields(HttpServletRequest request, String label, String[] fieldNames, String[] placeHolders, int[] colSpans) throws IOException {
        String ret = "";
        ret += "<div class=\"form-group\">";
        ret += "<label for=\"rua\" "
                + errorParts(request, fieldNames, "class=\"text-danger\"")
                + ">" + label + " " + errorParts(request, fieldNames, " (Os campos destacados são obrigatórios!)") + "</label>";
        ret += "<div class=\"row\">";
        int sumSpans = 0;
        for (int i = 0; i < fieldNames.length; i++) {

            String inputType = "text";
            String placeHolderTxt = "placeholder=\"" + placeHolders[i] + "\"";
            if (placeHolders[i].equals("date")) {
                inputType = "date";
                placeHolderTxt = "";
            }

            ret += "<div class=\"col-md-" + colSpans[i] + errorPart(request, fieldNames[i], " has-error") + "\">";
            ret += "<input type=\"" + inputType + "\" class=\"form-control\" name=\""
                    + fieldNames[i]
                    + "\" id=\""
                    + fieldNames[i]
                    + "\" " + placeHolderTxt + " value=\"" + getAttribute(request, fieldNames[i]) + "\">";
            ret += "</div>";
            sumSpans += colSpans[i];
            if (sumSpans >= 12) {
                sumSpans = 0;
                ret += "</div>";
                ret += "<div class=\"row\">";
            }
        }
        ret += "</div>";
        ret += "</div>";
        return ret;
    }

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>:: UFSCar - Programa de Pós-Graduação em Ciências da Computação - Mestrado::</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    </head>
    <body>


        <div class="container">
            <div class="jumbotron text-center">
                <p>Formulário de Inscrição - Edital 02/2016 - PPG-CC/UFSCar</p>
                <p>Processo Seletivo para Ingresso Regular no Curso
                    de Mestrado em Ciência da Computação</p> 
            </div>
            <% String msg = (String) request.getAttribute("msg");
                if (msg != null) {%>
            <div class="alert alert-danger">
                <strong>Atenção!</strong> <%=msg%>
            </div>
            <% } else {%>
            <div class="alert alert-info">
                <strong>Atenção!</strong> Os campos marcados com * são obrigatórios!
            </div>
            <% }%>

            <div class="row">
                <div class="col-md-12">
                    <form role="form" action="validarFormulario.jsp" method="post" enctype="multipart/form-data">
                        <div class="well well-sm">
                            <p>1. Dados pessoais:</p>
                            <%=printField(request, "nome", "*Nome:", "Digite seu nome")%>
                            <%=printField(request, "email", "*E-mail:", "Digite seu e-mail")%>
                            <%=printField(request, "skype", "*Usuário skype (para entrevista via webconferência):", "Digite seu usuário skype")%>
                            <%=printFields(request, "*Endereço completo (*rua, *número, complemento, *cidade, estado, *país e *código postal):",
                                    new String[]{"rua", "numero", "complemento", "cidade", "estado", "pais", "cep"},
                                    new String[]{"Nome da rua", "Número", "Complemento", "Cidade", "Estado", "País", "Código Postal"},
                                    new int[]{8, 2, 2, 4, 2, 4, 2})%>
                            <%=printField(request, "telefones", "*Telefones:", "Digite um ou mais telefones para contato")%>
                            <%=printFields(request, "*Documento de Identidade (número, data de expedição e órgão expedidor):",
                                    new String[]{"identidade", "dataIdentidade", "orgaoIdentidade"},
                                    new String[]{"Digite o documento de identidade", "date", "Órgão expedidor"},
                                    new int[]{6, 3, 3})%>
                            <%=printFields(request, "*Data de nascimento e nacionalidade:",
                                    new String[]{"dataNascimento", "nacionalidade"},
                                    new String[]{"date", "Nacionalidade"},
                                    new int[]{6, 6})%>
                            <%=printField(request, "lattes", "*Link do currículo na plataforma Lattes (o cadastramento na <a target=\"_blank\" href=\"http://lattes.cnpq.br\">plataforma Lattes</a> é obrigatório):",
                                    "Digite o link para seu currículo na plataforma Lattes")%>
                        </div>
                        <div class="well well-sm">
                            <p>2. Dados do exame utilizado</p>
                            <div class="form-group <%=errorPart(request, "tipoExame", "has-error text-danger")%>">
                                <label for="tipoExame">*Qual exame deseja utilizar no processo seletivo? <%=errorPart(request, "tipoExame", null)%></label>
                                <label class="radio-inline"><input type="radio" name="tipoExame" value="poscomp" <%=getAttributeChecked(request, "tipoExame", "poscomp")%>>POSCOMP</label>
                                <label class="radio-inline"><input type="radio" name="tipoExame" value="outro" <%=getAttributeChecked(request, "tipoExame", "outro")%>>Outro exame equivalente</label>
                            </div>
                            <div class="form-group <%=errorPart(request, "anoExame", "has-error text-danger")%>">
                                <label for="anoExame">*Ano de realização do exame <%=errorPart(request, "anoExame", null)%></label>
                                <label class="radio-inline"><input type="radio" name="anoExame" value="2016" <%=getAttributeChecked(request, "anoExame", "2016")%>>2016</label>
                                <label class="radio-inline"><input type="radio" name="anoExame" value="2015" <%=getAttributeChecked(request, "anoExame", "2015")%>>2015</label>
                                <label class="radio-inline"><input type="radio" name="anoExame" value="2014" <%=getAttributeChecked(request, "anoExame", "2014")%>>2014</label>
                            </div>
                        </div>
                        <div class="well well-sm">
                            <p>3. Linhas de pesquisa nas quais peiteia vaga (Ver Anexo I do edital):</p>
                            <div class="form-group <%=errorPart(request, "primeiraOpcao", "has-error text-danger")%>">
                                <label for="primeiraOpcao">*Primeira opção: <%=errorPart(request, "primeiraOpcao", null)%></label>
                                <select class="form-control" name="primeiraOpcao" id="primeiraOpcao">
                                    <option>Nenhuma</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Aprendizado de Máquina e Processamento de Línguas Naturais")%>>Aprendizado de Máquina e Processamento de Línguas Naturais</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Arquitetura de Computadores")%>>Arquitetura de Computadores</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Automação Industrial")%>>Automação Industrial</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Banco de Dados")%>>Banco de Dados</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Engenharia de Software")%>>Engenharia de Software</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Interação Humano-Computador")%>>Interação Humano-Computador</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Processamento de Imagens e Sinais")%>>Processamento de Imagens e Sinais</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Sistemas de automação e robótica")%>>Sistemas de automação e robótica</option>
                                    <option <%=getAttributeSelected(request, "primeiraOpcao", "Sistemas Distribuídos e Redes de Computadores")%>>Sistemas Distribuídos e Redes de Computadores</option>
                                </select>
                            </div>
                            <div class="form-group <%=errorPart(request, "segundaOpcao", "has-error text-danger")%>">
                                <label for="segundaOpcao">Segunda opção: <%=errorPart(request, "segundaOpcao", null)%></label>
                                <select class="form-control" name="segundaOpcao" id="segundaOpcao">
                                    <option>Nenhuma</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Aprendizado de Máquina e Processamento de Línguas Naturais")%>>Aprendizado de Máquina e Processamento de Línguas Naturais</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Arquitetura de Computadores")%>>Arquitetura de Computadores</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Automação Industrial")%>>Automação Industrial</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Banco de Dados")%>>Banco de Dados</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Engenharia de Software")%>>Engenharia de Software</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Interação Humano-Computador")%>>Interação Humano-Computador</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Processamento de Imagens e Sinais")%>>Processamento de Imagens e Sinais</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Sistemas de automação e robótica")%>>Sistemas de automação e robótica</option>
                                    <option <%=getAttributeSelected(request, "segundaOpcao", "Sistemas Distribuídos e Redes de Computadores")%>>Sistemas Distribuídos e Redes de Computadores</option>
                                </select>
                            </div>
                        </div>
                        <div class="well well-sm">
                            <p>4. Relações ou vínculos com a Comissão de Seleção, conforme Artigo 20 do edital:</p>
                            <div class="form-group <%=errorPart(request, "possuiVinculo", "has-error text-danger")%>">
                                <label for="possuiVinculo">*Possui vínculo com algum membro da Comissão de Seleção? <%=errorPart(request, "possuiVinculo", null)%></label>
                                <label class="radio-inline"><input type="radio" name="possuiVinculo" value="sim" <%=getAttributeChecked(request, "possuiVinculo", "sim")%>>Sim, possuo vínculo</label>
                                <label class="radio-inline"><input type="radio" name="possuiVinculo" value="nao" <%=getAttributeChecked(request, "possuiVinculo", "nao")%>>Não</label>
                            </div>
                            <div class="form-group">
                                <label for="descricaoVinculo">Se sim, qual(is) vínculo(s) e com quem?</label>
                                <textarea class="form-control" rows="5" name="descricaoVinculo" id="descricaoVinculo"><%=getAttribute(request, "descricaoVinculo")%></textarea>
                            </div>
                        </div>

                        <div class="well well-sm">
                            <p>5. Necessidades especiais:</p>
                            <div class="form-group <%=errorPart(request, "possuiNecessidadesEspeciais", "has-error text-danger")%>">
                                <label for="possuiNecessidadesEspeciais">*Possui necessidades especiais, amparado pelo Decreto 3.298 de 20/12/1999? <%=errorPart(request, "possuiNecessidadesEspeciais", null)%></label>
                                <label class="radio-inline"><input type="radio" name="possuiNecessidadesEspeciais" value="sim" <%=getAttributeChecked(request, "possuiNecessidadesEspeciais", "sim")%>>Sim, possuo necessidades especiais</label>
                                <label class="radio-inline"><input type="radio" name="possuiNecessidadesEspeciais" value="nao" <%=getAttributeChecked(request, "possuiNecessidadesEspeciais", "nao")%>>Não</label>
                            </div>
                            <div class="form-group">
                                <label for="descricaoNecessidadesEspeciais">Se sim, qual o tipo de necessidade especial possui e qual atendimento diferenciado julga ser necessário (ver Artigo 17 do edital)?</label>
                                <textarea class="form-control" rows="5" name="descricaoNecessidadesEspeciais" id="descricaoNecessidadesEspeciais"><%=getAttribute(request, "descricaoNecessidadesEspeciais")%></textarea>
                            </div>
                        </div>

                        <p class="text-justify">De acordo com o Art. 19 do Edital 02/2016 - PPG-CC/UFSCar,
                            ao realizar a inscrição no Processo Seletivo para Ingresso
                            como Aluno Regular no Curso de Mestrado em Ciência da Computação,
                            o candidato assume total responsabilidade pela veracidade
                            das informações fornecidas neste formulário de inscrição
                            e demais documentos enviados. Assume, ainda, estar ciente
                            de que não serão permitidas alterações posteriores ao
                            prazo estabelecido. A inscrição do candidato implica
                            também no pleno conhecimento de todo o conteúdo do referido
                            edital, assim como seus anexos, e a tácita aceitação
                            das normas e condições nele estabelecidas.</p>

                        <div class="form-group <%=errorPart(request, "acordo", "has-error text-danger")%>"> 
                            <div class="checkbox">
                                <label><input type="checkbox" name="acordo" value="sim" <%=getAttributeChecked(request, "acordo", "sim")%>> *Li e concordo com todas as informações contidas neste formulário.  <%=errorPart(request, "acordo", null)%></label>
                            </div>
                        </div>                        

                        <div class="form-group"> 
                            <button type="submit" class="btn btn-default">Realizar inscrição</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>