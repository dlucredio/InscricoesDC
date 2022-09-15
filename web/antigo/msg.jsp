<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>:: UFSCar - Lato Sensu 2016 - Desenvolvimento de Software para Web ::</title>
<style type="text/css">
<!--
.texto {
       font-family: "Trebuchet MS";
       font-size: 11px;
       color: #000000;
}
-->
</style>
</head>
<body>

<%        
	String tipoErro = "";

	if (request.getParameter("info") == null) {
		tipoErro = "erroAcesso";
	}
	else {
		tipoErro = request.getParameter("info");
	}
	
	int erro=6;
	
	//CONVERTENDO tipoErro que é String em inteiro (erro) para que possa ser realizado o switch
	if (tipoErro.equals("sucesso"))
		erro = 0;
		
	if (tipoErro.equals("erroNome"))
		erro = 1;
		
	if (tipoErro.equals("erroEmail"))
		erro = 2;
		
	if (tipoErro.equals("erroTam"))
		erro = 3;
		
	if (tipoErro.equals("erroUp"))
		erro = 4;
	
	if (tipoErro.equals("erroDir"))
		erro = 5;

	if (tipoErro.equals("erroAcesso"))
		erro = 6;	
	
	switch (erro)
	{
		case 0: {
%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2>Inscri&ccedil;&atilde;o realizada com sucesso</h2></td>
  </tr>
  <tr>
	  <td class="texto"><p align="justify">Sua inscri&ccedil;&atilde;o foi realizada com sucesso.<br/>Uma mensagem de confirma&ccedil;&atilde;o de sua inscri&ccedil;&atilde;o no curso ser&aacute; enviada para o e-mail fornecido.</p>
    </td>
  </tr>
</table>
</body>
</html>
<%
					break;
				}
case 1: {
%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2>Ocorreu um erro</h2></td>
  </tr>
  <tr>
	  <td class="texto"><p align="justify">N&atilde;o foi poss&iacute;vel realizar a inscri&ccedil;&atilde;o.<br/>Por favor preencha o campo com o seu nome completo.</p>
    </td>
  </tr>
</table>
</body>
</html>
<%					break;
				}
case 2:{
%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2>Ocorreu um erro</h2></td>
  </tr>
  <tr>
    <td class="texto"><p align="justify">N&atilde;o foi poss&iacute;vel realizar a inscri&ccedil;&atilde;o.<br/>Por favor preencha o campo com o seu e-mail.</p>
    </td>
  </tr>
</table>
</body>
</html>
<%
					break;
				}
case 3: {
%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2>Ocorreu um erro</h2></td>
  </tr>
  <tr>
    <td class="texto"><p align="justify">N&atilde;o foi poss&iacute;vel realizar a inscri&ccedil;&atilde;o.<br/>Os arquivos a serem enviados possuem mais de 4MB.</p>
    </td>
  </tr>
</table>
</body>
</html>
<%
					break;
				}
case 4: {
%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2>Ocorreu um erro</h2></td>
  </tr>
  <tr>
    <td class="texto"><p align="justify">N&atilde;o foi poss&iacute;vel realizar a inscri&ccedil;&atilde;o.<br/>Erro ao criar os arquivos no servidor. Por favor, entre em contato com o administrador pelo e-mail: latosensu@dc.ufscar.br</p>
    </td>
  </tr>
</table>
</body>
</html>
<%
				break;
				}
case 5: {
%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2>Ocorreu um erro</h2></td>
  </tr>
  <tr>
    <td class="texto"><p align="justify">N&atilde;o foi poss&iacute;vel realizar a inscri&ccedil;&atilde;o.<br/>J&aacute; existe uma pessoa cadastrada com esse nome. Por favor, entre em contato com o administrador pelo e-mail: latosensu@dc.ufscar.br</p>
    </td>
  </tr>
</table>
</body>
</html>
<%
					break;
			}
		case 6: {
			out.println("");
			break;
			}
	}
%>
</body>
</html>
