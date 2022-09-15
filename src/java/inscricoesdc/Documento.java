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
public class Documento {
    private final String nome;
    private final String rotulo;
    private final String descricao;

    public Documento(String nome, String rotulo, String descricao) {
        this.nome = nome;
        this.rotulo = rotulo;
        this.descricao = descricao;
    }

    public String getNome() {
        return nome;
    }

    public String getRotulo() {
        return rotulo;
    }

    public String getDescricao() {
        return descricao;
    }

    
}
