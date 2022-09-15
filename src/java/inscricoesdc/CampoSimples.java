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
public class CampoSimples extends ElementoFormulario {
    public enum TipoCampoSimples {
        Texto,
        Email,
        URL,
        Data
    }
    
    private final TipoCampoSimples tipoCampoSimples;

    public CampoSimples(TipoCampoSimples tipoCampoSimples, String nome, int largura, String rotulo, String valorPadrao) {
        super(nome, largura, rotulo, valorPadrao);
        this.tipoCampoSimples = tipoCampoSimples;
    }

    public TipoCampoSimples getTipoCampoSimples() {
        return tipoCampoSimples;
    }
}
