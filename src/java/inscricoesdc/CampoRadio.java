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
public class CampoRadio extends CampoMultiplaEscolha {

    public CampoRadio(List<String> opcoes, String nome, String rotulo) {
        super(opcoes, nome, 0, rotulo, null);
    }
    
}
