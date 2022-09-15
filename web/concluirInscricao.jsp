<%-- 
    Document   : concluirInscricao.jsp
    Created on : 25/04/2016, 15:41:35
    Author     : Daniel Lucrédio
--%>

<%@page import="java.util.Random"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.io.FileWriter"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.internet.AddressException"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="processadorFormulario.jsp"%>

<%!    String gerarProtocolo(Date data) {
        String letras = "ACEFGHIJKLRQSUVWXYZ";
        int tamanho = letras.length();
        String protocolo = "";

        Random random = new Random();

        Calendar cal = Calendar.getInstance();
        cal.setTime(data);

        protocolo += letras.charAt(cal.get(Calendar.DAY_OF_MONTH) % tamanho);
        protocolo += letras.charAt(cal.get(Calendar.HOUR_OF_DAY) % tamanho);
        protocolo += ".";
        protocolo += letras.charAt(cal.get(Calendar.MINUTE) % tamanho);
        protocolo += letras.charAt(cal.get(Calendar.SECOND) % tamanho);
        protocolo += ".";
        protocolo += letras.charAt(cal.get(Calendar.MILLISECOND) % tamanho);
        protocolo += letras.charAt(random.nextInt(tamanho));
        protocolo += ".";
        protocolo += letras.charAt(random.nextInt(tamanho));
        protocolo += letras.charAt(random.nextInt(tamanho));
        protocolo += ".";
        protocolo += letras.charAt(random.nextInt(tamanho));
        protocolo += letras.charAt(random.nextInt(tamanho));

        return protocolo;
    }

    void enviarEmailSecretaria(Date dataSubmissao, String nomeInscrito, String emailInscrito, String protocoloInscricao, File pastaInscricao, String emailSecretaria) throws AddressException, MessagingException {
        String assunto = "Nova Inscrição " + formulario.getNome() + " - " + nomeInscrito;

        String mensagem = formulario.getTitulo() + "\n";
        mensagem += "Nova Inscrição\n\n";

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");

        mensagem += "Data da inscrição: " + sdf.format(dataSubmissao) + "\n\n";

        mensagem += "Nome do inscrito: " + nomeInscrito + "\n";
        mensagem += "E-mail do inscrito " + emailInscrito + "\n";
        mensagem += "Protocolo: " + protocoloInscricao + "\n";
        mensagem += "Pasta: " + pastaInscricao.getAbsolutePath() + "\n\n";

        mensagem += formulario.getMsgSecretaria() + "\n\n";

        mensagem += "Atenciosamente,\n\n";
        mensagem += "Sistema de inscrições do DC";

        Properties p = new Properties();
        p.put("mail.host", "mail.dc.ufscar.br");
        Session session1 = Session.getInstance(p, null);
        MimeMessage msg = new MimeMessage(session1);

        msg.setFrom(new InternetAddress(emailSecretaria));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(emailSecretaria));
        msg.setContent(mensagem.toString(), "text/html");
        msg.setSentDate(new Date());
        msg.setSubject(assunto);

        msg.setText(mensagem);

        Transport.send(msg);
    }

    void enviarEmailInscrito(Date dataSubmissao, String nomeInscrito, String emailInscrito, String protocoloInscricao, String emailSecretaria) throws AddressException, MessagingException {
        String assunto = "Inscrição Recebida - " + formulario.getTitulo();

        String mensagem = formulario.getTitulo() + "\n";
        mensagem += "Inscrição Recebida\n\n";

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");

        mensagem += "Data da inscrição: " + sdf.format(dataSubmissao) + "\n\n";
        mensagem += "Nome do inscrito " + nomeInscrito + "\n";
        mensagem += "E-mail do inscrito " + emailInscrito + "\n";
        mensagem += "Protocolo: " + protocoloInscricao + "\n\n";

        mensagem += formulario.getMsgInscrito() + "\n\n";

        mensagem += "Atenciosamente,\n\n";
        mensagem += "Sistema de inscrições do DC";

        Properties p = new Properties();
        p.put("mail.host", "mail.dc.ufscar.br");
        Session session1 = Session.getInstance(p, null);
        MimeMessage msg = new MimeMessage(session1);

        msg.setFrom(new InternetAddress(emailSecretaria));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(emailInscrito));
        msg.setContent(mensagem.toString(), "text/html");
        msg.setSentDate(new Date());
        msg.setSubject(assunto);

        msg.setText(mensagem);

        Transport.send(msg);
    }

    void gravarFormularioFormatoTxt(HttpServletRequest request, File arquivoFormulario, Date dataSubmissao, String protocoloInscricao, File pastaInscricao) throws IOException, ParseException {
        arquivoFormulario.createNewFile();
        FileWriter fw = new FileWriter(arquivoFormulario);

        String form = processarFormularioTxt(request, dataSubmissao, protocoloInscricao, pastaInscricao);

        fw.write(form);
        fw.flush();
        fw.close();
    }

    void gravarFormularioFormatoPdf(HttpServletRequest request, File arquivoFormulario, Date dataSubmissao, String protocoloInscricao, File pastaInscricao) throws Exception {
        arquivoFormulario.createNewFile();

        processarFormularioPdf(request, arquivoFormulario, dataSubmissao, protocoloInscricao, pastaInscricao);

    }

    String getNomeDocumento(String nomeCampo) {
        for (Documento d : formulario.getDocumentos()) {
            if (d.getNome().equals(nomeCampo)) {
                return d.getRotulo();
            }
        }
        return null;
    }
%>

<%
// Obs: estou assumindo que é um formulário multipart
// Caso contrário precisaria testar

// Create a factory for disk-based file items
    DiskFileItemFactory factory = new DiskFileItemFactory();

    File pastaTemporaria = new File(strPastaTemporaria);
    factory.setRepository(pastaTemporaria);

// Create a new file upload handler
    ServletFileUpload upload = new ServletFileUpload(factory);

// Parse the request
    List<FileItem> items = upload.parseRequest(request);

// Process the uploaded items
    Iterator<FileItem> iter = items.iterator();

    List<String> mensagens = new ArrayList<String>();

    while (iter.hasNext()) {
        FileItem item = iter.next();

        if (!item.isFormField()) {
            String fieldName = item.getFieldName();
            String fileName = item.getName();
            String contentType = item.getContentType();
            boolean isInMemory = item.isInMemory();
            long sizeInBytes = item.getSize();

            if (sizeInBytes == 0) {
                mensagens.add("É obrigatório enviar " + getNomeDocumento(fieldName) + "!");
            } else if (sizeInBytes > 4 * 1024 * 1024) {
                mensagens.add("O documento " + getNomeDocumento(fieldName) + " tem mais do que 4 Mbytes!");
            }
        }
    }

    if (!mensagens.isEmpty()) {
        request.setAttribute(MENSAGEM_REQUEST_ATTRIBUTE, mensagens);
        request.getRequestDispatcher(ACAO_FORMULARIO_PARTE3).forward(request, response);

    } else {
        String nomeInscrito = (String) request.getSession().getAttribute("nome");
        String emailInscrito = (String) request.getSession().getAttribute("email");
        String nomeArquivo = nomeInscrito.replaceAll("\\W+", "");

        File pastaInscricoes = new File(strPastaInscricoes, formulario.getNome());
        if (!pastaInscricoes.exists()) {
            pastaInscricoes.mkdir();
        }

        File pastaInscricao = new File(pastaInscricoes, nomeArquivo);
        int indice = 1;
        while (pastaInscricao.exists()) {
            pastaInscricao = new File(pastaInscricoes, nomeArquivo + (indice++));
        }
        pastaInscricao.mkdir();

        iter = items.iterator();

        while (iter.hasNext()) {
            FileItem item = iter.next();

            if (!item.isFormField()) {
                String fieldName = item.getFieldName();

                File documento = new File(pastaInscricao, item.getName());

                item.write(documento);
            }
        }

        Date dataSubmissao = new Date();
        String protocoloInscricao = gerarProtocolo(dataSubmissao);

        File arquivoFormularioTxt = new File(pastaInscricao, "formularioTexto.txt");
        File arquivoFormularioPdf = new File(pastaInscricao, "formulario.pdf");
        gravarFormularioFormatoTxt(request, arquivoFormularioTxt, dataSubmissao, protocoloInscricao, pastaInscricao);
        gravarFormularioFormatoPdf(request, arquivoFormularioPdf, dataSubmissao, protocoloInscricao, pastaInscricao);

        String emailSecretaria1 = formulario.getEmailsSecretaria().get(0);
        enviarEmailInscrito(dataSubmissao, nomeInscrito, emailInscrito, protocoloInscricao, emailSecretaria1);

        for (String es : formulario.getEmailsSecretaria()) {
            enviarEmailSecretaria(dataSubmissao, nomeInscrito, emailInscrito, protocoloInscricao, pastaInscricao, es);
        }

        request.setAttribute(PROTOCOLO_REQUEST_ATTRIBUTE, protocoloInscricao);
        request.getRequestDispatcher(ACAO_FORMULARIO_FINAL).forward(request, response);

    }
%>