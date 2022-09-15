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
public abstract class CampoMultiplaEscolha extends ElementoFormulario {
    private final List<String> opcoes;

    public CampoMultiplaEscolha(List<String> opcoes, String nome, int largura, String rotulo, String valorPadrao) {
        super(nome, largura, rotulo, valorPadrao);
        this.opcoes = opcoes;
    }

    public List<String> getOpcoes() {
        return opcoes;
    }
}
