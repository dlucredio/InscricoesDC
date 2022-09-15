<%@page import="java.util.Date"%>
<%@page import="com.itextpdf.text.Element"%>
<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="com.itextpdf.text.Chunk"%>
<%@page import="com.itextpdf.text.Phrase"%>
<%@page import="com.itextpdf.text.pdf.PdfPCell"%>
<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="com.itextpdf.text.pdf.PdfContentByte"%>
<%@page import="com.itextpdf.text.pdf.PdfPageEventHelper"%>
<%@page import="com.itextpdf.text.Font"%>
<%@page import="com.itextpdf.text.FontFactory"%>
<%@page import="com.itextpdf.text.PageSize"%>
<%@page import="com.itextpdf.text.DocumentException"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.LineNumberReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.util.NoSuchElementException"%>
<%@page import="java.io.File"%>
<%@include file="/WEB-INF/jspf/comum.jspf"%>

<%!    String getAttribute(HttpServletRequest request, String name) {
        String ret = (String) request.getSession().getAttribute(name);
        if (ret == null) {
            return "";
        }
        return ret.replace('\n', ' ').replace('\r', ' ');
    }

    String processarFormularioTxt(HttpServletRequest request, Date dataSubmissao, String protocoloInscricao, File pastaInscricao) throws FileNotFoundException, IOException, NoSuchElementException, ParseException {
        StringBuilder out = new StringBuilder();

        for (ElementoFormulario ef : formulario.getElementos()) {
            if (ef instanceof CampoSimples ||
                    ef instanceof CampoTextArea ||
                    ef instanceof CampoCheckbox ||
                    ef instanceof CampoRadio ||
                    ef instanceof CampoSelect) {
                String valor = getAttribute(request, ef.getNome());
                out.append(ef.getNome() + "=" + valor + "\n");
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");
        out.append("submissao=" + sdf.format(dataSubmissao) + "\n");
        out.append("protocolo=" + protocoloInscricao + "\n");
        out.append("pasta=" + pastaInscricao.getAbsolutePath());

        return out.toString();
    }

    Font fontTitulo;
    Font fontGrupo;
    Font fontRotulo;
    Font fontValor;
    PdfPTable table;

    void processarFormularioPdf(HttpServletRequest request, File arquivoFormulario, Date dataSubmissao, String protocoloInscricao, File pastaInscricao) throws Exception {
        Document document = new Document();
        fontTitulo = FontFactory.getFont(FontFactory.HELVETICA);
        fontTitulo.setSize(9);

        fontGrupo = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE);
        fontGrupo.setSize(7);

        fontRotulo = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE);
        fontRotulo.setSize(7);

        fontValor = FontFactory.getFont(FontFactory.COURIER_BOLD);
        fontValor.setSize(8);
        PdfWriter.getInstance(document, new FileOutputStream(arquivoFormulario));

        document.open();
        document.setPageSize(PageSize.A4);
        table = new PdfPTable(12);

        processarTituloPdf(formulario.getTitulo());
        
        for (ElementoFormulario ef : formulario.getElementos()) {
            if (ef instanceof Grupo) {
                processarGrupoPdf((Grupo)ef);
            } else if (ef instanceof CampoSimples) {
                processarCampoSimplesPdf(request, (CampoSimples)ef);
            } else if (ef instanceof CampoMultiplaEscolha) {
                processarCampoMultiplaEscolhaPdf(request, (CampoMultiplaEscolha)ef);
            } else if (ef instanceof CampoTextArea ||
                    ef instanceof CampoCheckbox) {
                processarCampoLarguraFixaPdf(request, ef);
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");

        Phrase frase = new Phrase("Dados da submissão", fontGrupo);
        PdfPCell celulaGrupo = new PdfPCell(frase);
        celulaGrupo.setColspan(12);
        celulaGrupo.setBackgroundColor(BaseColor.LIGHT_GRAY);
        table.addCell(celulaGrupo);

        adicionarCampoNaTabela("Data/horário da inscrição:", sdf.format(dataSubmissao), 12);
        adicionarCampoNaTabela("Protocolo de inscrição:", protocoloInscricao, 12);
        adicionarCampoNaTabela("Pasta com a submissão:", pastaInscricao.getAbsolutePath(), 12);

        document.add(table);

        document.close();

    }

    void adicionarCampoNaTabela(String rotuloCampo, String valor, int largura) {
        if (valor.trim().length() == 0) {
            valor = "-";
        }
        Phrase frase = new Phrase();
        frase.add(new Chunk(rotuloCampo + "\n", fontRotulo));
        frase.add(new Chunk(valor, fontValor));
        PdfPCell celulaRotulo = new PdfPCell(frase);
        celulaRotulo.setColspan(largura);
        table.addCell(celulaRotulo);

    }

    void processarTituloPdf(String titulo) {
        String tituloFormatado = titulo.replaceAll("\\\\n", "\n");

        Paragraph paragrafo = new Paragraph("\n" + tituloFormatado + "\n\n", fontTitulo);
        PdfPCell celulaGrupo = new PdfPCell(paragrafo);
        celulaGrupo.setColspan(12);
        celulaGrupo.setVerticalAlignment(Element.ALIGN_MIDDLE);
        celulaGrupo.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(celulaGrupo);

    }

    void processarGrupoPdf(Grupo grupo) {
        Phrase frase = new Phrase(grupo.getRotulo(), fontGrupo);
        PdfPCell celulaGrupo = new PdfPCell(frase);
        celulaGrupo.setColspan(12);
        celulaGrupo.setBackgroundColor(BaseColor.LIGHT_GRAY);
        table.addCell(celulaGrupo);
    }

    void processarCampoSimplesPdf(HttpServletRequest request, CampoSimples cs) throws DocumentException {
        String valor = getAttribute(request, cs.getNome());

        adicionarCampoNaTabela(cs.getRotulo(), valor, cs.getLargura());
    }

    void processarCampoMultiplaEscolhaPdf(HttpServletRequest request, CampoMultiplaEscolha cme) throws DocumentException, IOException {
        String valor = getAttribute(request, cme.getNome());

        adicionarCampoNaTabela(cme.getRotulo(), valor, 12);
    }

    void processarCampoLarguraFixaPdf(HttpServletRequest request, ElementoFormulario ef) throws DocumentException {
        String valor = getAttribute(request, ef.getNome());

        Paragraph p = new Paragraph(ef.getRotulo(), fontRotulo);

        adicionarCampoNaTabela(ef.getRotulo(), valor, 12);
    }
%>