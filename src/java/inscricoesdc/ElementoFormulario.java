/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inscricoesdc;

/**
 *
 * @author daniellucredio
 */
public abstract class ElementoFormulario {
    protected final String nome;
    protected final int largura;
    protected final String rotulo;
    protected final String valorPadrao;
    protected String valor;

    public ElementoFormulario(String nome, int largura, String rotulo, String valorPadrao) {
        this.nome = nome;
        this.largura = largura;
        this.rotulo = rotulo;
        this.valorPadrao = valorPadrao;
    }

    public String getNome() {
        return nome;
    }

    public int getLargura() {
        return largura;
    }

    public String getRotulo() {
        return rotulo;
    }

    public String getValorPadrao() {
        return valorPadrao;
    }

    public String getValor() {
        return valor;
    }
    
    public void setValor(String valor) {
        this.valor = valor;
    }
}
