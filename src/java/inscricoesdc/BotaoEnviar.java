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
public class BotaoEnviar extends ElementoFormulario {
    private final String rotuloConfirmar;
    private final String rotuloVoltar;

    public BotaoEnviar(String rotuloEnviar, String rotuloConfirmar, String rotuloVoltar) {
        super(null, 0, rotuloEnviar, null);
        this.rotuloConfirmar = rotuloConfirmar;
        this.rotuloVoltar = rotuloVoltar;
    }

    public String getRotuloConfirmar() {
        return rotuloConfirmar;
    }

    public String getRotuloVoltar() {
        return rotuloVoltar;
    }    
}
