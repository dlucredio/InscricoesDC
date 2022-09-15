/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inscricoesdc;

import java.util.List;

/**
 *
 * @author daniellucredio
 */
public class Formulario {
    private final String nome;
    private final String nomeComposto;
    private final String titulo;
    private final List<String> emailsSecretaria;
    private final List<ElementoFormulario> elementos;
    private final List<Documento> documentos;
    private final String msgSecretaria;
    private final String msgInscrito;
    private final String msgFinal;

    public Formulario(String nome, String nomeComposto, String titulo, List<String> emailsSecretaria, List<ElementoFormulario> elementos, List<Documento> documentos, String msgSecretaria, String msgInscrito, String msgFinal) {
        this.nome = nome;
        this.nomeComposto = nomeComposto;
        this.titulo = titulo;
        this.emailsSecretaria = emailsSecretaria;
        this.elementos = elementos;
        this.documentos = documentos;
        this.msgSecretaria = msgSecretaria;
        this.msgInscrito = msgInscrito;
        this.msgFinal = msgFinal;
    }

    public String getNome() {
        return nome;
    }
    
    public String getNomeComposto() {
        return nomeComposto;
    }

    public String getTitulo() {
        return titulo;
    }

    public List<String> getEmailsSecretaria() {
        return emailsSecretaria;
    }

    public List<ElementoFormulario> getElementos() {
        return elementos;
    }

    public List<Documento> getDocumentos() {
        return documentos;
    }

    public String getMsgSecretaria() {
        return msgSecretaria;
    }

    public String getMsgInscrito() {
        return msgInscrito;
    }

    public String getMsgFinal() {
        return msgFinal;
    }
    
    
}
