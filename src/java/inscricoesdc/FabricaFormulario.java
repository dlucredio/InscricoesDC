/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inscricoesdc;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/**
 *
 * @author daniellucredio
 */
public class FabricaFormulario {

    private final static String SEPARADOR = ";";
    private final static String FIM_OPCOES = "[FimOpcoes]";
    private final static String TIPO_CAMPO_TITULO = "[titulo]";
    private final static String TIPO_CAMPO_EMAILS_SECRETARIA = "[emailsSecretaria]";
    private final static String TIPO_CAMPO_GRUPO = "[grupo]";
    private final static String TIPO_CAMPO_TEXTO = "[campoTexto]";
    private final static String TIPO_CAMPO_EMAIL = "[campoEmail]";
    private final static String TIPO_CAMPO_URL = "[campoUrl]";
    private final static String TIPO_CAMPO_DATA = "[campoData]";
    private final static String TIPO_CAMPO_RADIO = "[campoRadio]";
    private final static String TIPO_CAMPO_SELECT = "[campoSelect]";
    private final static String TIPO_CAMPO_TEXTAREA = "[campoTextArea]";
    private final static String TIPO_CAMPO_CHECKBOX = "[campoCheckbox]";
    private final static String TIPO_CAMPO_ENVIAR = "[enviar]";
    private final static String TIPO_DOCUMENTO = "[documento]";
    private final static String TIPO_MSG_SECRETARIA = "[msgSecretaria]";
    private final static String TIPO_MSG_INSCRITO = "[msgInscrito]";
    private final static String TIPO_MSG_FINAL = "[msgFinal]";

    public static Formulario criarFormulario(File arquivoConfiguracao, String nomeFormulario, String nomeComposto) throws FileNotFoundException, IOException {
        String titulo = null;
        String msgSecretaria = "";
        String msgInscrito = "";
        String msgFinal = "";
        boolean temEnviar = false;
        List<ElementoFormulario> elementos = new ArrayList<ElementoFormulario>();
        List<Documento> documentos = new ArrayList<Documento>();
        List<String> emailsSecretaria = null;
        LineNumberReader lnr = new LineNumberReader(new FileReader(arquivoConfiguracao));
        String line;
        while ((line = lnr.readLine()) != null) {
            line = line.trim();
            if (line.startsWith("%")) {
                continue;
            }
            if (line.startsWith(TIPO_CAMPO_TITULO)) {
                titulo = processarTitulo(line);
            } else if (line.startsWith(TIPO_CAMPO_EMAILS_SECRETARIA)) {
                emailsSecretaria = processarEmailsSecretaria(line);
            } else if (line.startsWith(TIPO_CAMPO_GRUPO)) {
                Grupo g = processarGrupo(line);
                elementos.add(g);
            } else if (line.startsWith(TIPO_CAMPO_TEXTO)) {
                CampoSimples cs = processarCampoSimples(line, CampoSimples.TipoCampoSimples.Texto);
                elementos.add(cs);
            } else if (line.startsWith(TIPO_CAMPO_EMAIL)) {
                CampoSimples cs = processarCampoSimples(line, CampoSimples.TipoCampoSimples.Email);
                elementos.add(cs);
            } else if (line.startsWith(TIPO_CAMPO_URL)) {
                CampoSimples cs = processarCampoSimples(line, CampoSimples.TipoCampoSimples.URL);
                elementos.add(cs);
            } else if (line.startsWith(TIPO_CAMPO_DATA)) {
                CampoSimples cs = processarCampoSimples(line, CampoSimples.TipoCampoSimples.Data);
                elementos.add(cs);
            } else if (line.startsWith(TIPO_CAMPO_RADIO)) {
                CampoRadio cr = processarCampoRadio(line, lnr);
                elementos.add(cr);
            } else if (line.startsWith(TIPO_CAMPO_SELECT)) {
                CampoSelect cs = processarCampoSelect(line, lnr);
                elementos.add(cs);
            } else if (line.startsWith(TIPO_CAMPO_TEXTAREA)) {
                CampoTextArea cta = processarCampoTextArea(line);
                elementos.add(cta);
            } else if (line.startsWith(TIPO_CAMPO_CHECKBOX)) {
                CampoCheckbox cc = processarCampoCheckbox(line);
                elementos.add(cc);
            } else if (line.startsWith(TIPO_CAMPO_ENVIAR)) {
                if (temEnviar) {
                    throw new RuntimeException("Erro na configuração do formulário! Mais do que um botão enviar!");
                } else {
                    BotaoEnviar be = processarEnviar(line);
                    elementos.add(be);
                    temEnviar = true;
                }
            } else if (line.startsWith(TIPO_DOCUMENTO)) {
                Documento d = processarDocumento(line);
                documentos.add(d);
            } else if (line.startsWith(TIPO_MSG_SECRETARIA)) {
                msgSecretaria = processarMsg(line);
            } else if (line.startsWith(TIPO_MSG_INSCRITO)) {
                msgInscrito = processarMsg(line);
            } else if (line.startsWith(TIPO_MSG_FINAL)) {
                msgFinal = processarMsg(line);
            }
        }
        if (titulo == null) {
            throw new RuntimeException("Erro na configuração do formulário! Título faltando!");
        }
        if (emailsSecretaria == null) {
            throw new RuntimeException("Erro na configuração do formulário! E-mail(s) da secretaria faltando!");
        }
        if (!temEnviar) {
            throw new RuntimeException("Erro na configuração do formulário! Botão enviar faltando!");
        }

        Formulario f = new Formulario(nomeFormulario, nomeComposto, titulo, emailsSecretaria, elementos, documentos, msgSecretaria, msgInscrito, msgFinal);
        return f;
    }

    private static String processarTitulo(String line) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        return st.nextToken();
    }
    
    private static List<String> processarEmailsSecretaria(String line) {
        List<String> ret = new ArrayList<String>();
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        while(st.hasMoreTokens()) {
            ret.add(st.nextToken());
        }
        return ret;
    }


    private static Grupo processarGrupo(String line) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String txtGrupo = st.nextToken();
        return new Grupo(txtGrupo);
    }

    private static CampoSimples processarCampoSimples(String line, CampoSimples.TipoCampoSimples tipo) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String larguraTxt = st.nextToken().trim();
        int largura = Integer.parseInt(larguraTxt);
        String nome = st.nextToken().trim();
        String rotulo = st.nextToken().trim();
        String valorPadrao = "";
        if (st.hasMoreTokens()) {
            valorPadrao = st.nextToken().trim();
        }
        return new CampoSimples(tipo, nome, largura, rotulo, valorPadrao);
    }

    private static CampoRadio processarCampoRadio(String line, LineNumberReader lnr) throws IOException {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String nomeCampo = st.nextToken().trim();
        String rotuloCampo = st.nextToken().trim();

        List<String> opcoes = new ArrayList<String>();
        String linha;
        while (!(linha = lnr.readLine().trim()).equals(FIM_OPCOES)) {
            opcoes.add(linha);
        }
        return new CampoRadio(opcoes, nomeCampo, rotuloCampo);
    }

    private static CampoSelect processarCampoSelect(String line, LineNumberReader lnr) throws IOException {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String nomeCampo = st.nextToken().trim();
        String rotuloCampo = st.nextToken().trim();

        List<String> opcoes = new ArrayList<String>();
        String linha;
        while (!(linha = lnr.readLine().trim()).equals(FIM_OPCOES)) {
            opcoes.add(linha);
        }

        return new CampoSelect(opcoes, nomeCampo, rotuloCampo);
    }

    private static CampoTextArea processarCampoTextArea(String line) {

        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String nomeCampo = st.nextToken().trim();
        String rotuloCampo = st.nextToken().trim();

        return new CampoTextArea(nomeCampo, rotuloCampo);
    }

    private static CampoCheckbox processarCampoCheckbox(String line) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String nomeCampo = st.nextToken().trim();
        String rotuloCampo = st.nextToken().trim();

        return new CampoCheckbox(nomeCampo, rotuloCampo);
    }

    private static BotaoEnviar processarEnviar(String line) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String rotuloEnviar = st.nextToken().trim();
        String rotuloConfirmar = st.nextToken().trim();
        String rotuloVoltar = st.nextToken().trim();
        return new BotaoEnviar(rotuloEnviar, rotuloConfirmar, rotuloVoltar);
    }

    private static Documento processarDocumento(String line) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        String nome = st.nextToken();
        String rotulo = st.nextToken();
        String descricao = st.nextToken();
        return new Documento(nome, rotulo, descricao);
    }

    private static String processarMsg(String line) {
        StringTokenizer st = new StringTokenizer(line, SEPARADOR);
        st.nextToken();
        return st.nextToken();
    }
}
