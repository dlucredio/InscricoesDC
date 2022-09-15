<%@page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.File"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.internet.AddressException"%>
<%@page import="javax.mail.Transport"%>
<%@page import="java.util.Date"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.FileUpload"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% 
	boolean isMultipart = FileUpload.isMultipartContent(request);  
	if (isMultipart == true) 
	{ 
		//DECLARACAO DAS VARIAVEIS
		
			String caminho = "/home/cursos/ppg/inscricoes/ppgcc/"; //ir? conter o endere?o onde o arquivo dever? ser gravado
		//obs.: pegar o caminho da pasta no servidor
		
		String nomeArquivo = ""; //ir? conter o nome do arquivo que ser? gravado

		String nomeDir = ""; //recebe o nome da pessoa que est? realizando o cadastro (com o qual ser? criado o novo diretorio)
		String email = ""; // recebe o endere?o de e-mail para ser enviada a confirma??o
		String fieldName = ""; //recebe o nome do formField
		String temp = "";

		boolean erroVerif = false; //recebe true se ocorrer algum erro durante a verifica??o dos arquivos
		boolean erroUpload = false; //recebe true se ocorrer algum erro durante o upload dos arquivos

		long tam = 0; //receber? a somatoria dos tamanhos dos arquivos para saber se eles n?o s?o maiores que 2MB

		
		// Criando um novo upload handler  
		DiskFileUpload upload = new DiskFileUpload();  

		// Definindo uma pasta onde ser?o gravados os arquivos tempor?rios    
		upload.setRepositoryPath(caminho + "temp/");  

		// Separa os pedidos de upload em um vetor  
		List items = upload.parseRequest(request);  

		Iterator it = items.iterator();  //vari?vel que percorrer? o vetor de pedidos de upload

		Iterator it_verif = items.iterator(); //ser? utilizado para verificar o tamanho e se a formField tem ou n?o conte?do


		while (it_verif.hasNext() && erroVerif == false) 
		{  

			FileItem fitem = (FileItem) it_verif.next();


			if (fitem.isFormField()) //ve se o formFild ? do tipo que passa um texto (nome da pessoa e e-mail)
			{			
				temp = fitem.getString();

				fieldName = fitem.getFieldName();		

				if (fieldName.equals("nome"))
				{
					nomeDir = temp;
					if (nomeDir.equals("")) {
					//response.sendRedirect("upload_result.jsp?"+"info=erroNome");
						response.sendRedirect("msg.jsp?info=erroNome");
						return;
					}
				}	
				
				if (fieldName.equals("email"))
				{
					email = temp;
					if (email.equals("")) {
						//response.sendRedirect("upload_result.jsp?"+"info=erroEmail");
						response.sendRedirect("msg.jsp?info=erroEmail");
						return;
					}
				}
			}
  
	         else //o FormField ? do tipo que passa o endere?o de um arquivo
			{
				if (fitem.getSize() == 0) //verifica se o form de upload est? em branco, se estiver erro recebe true e sai do loop while
					erroVerif = true;
					
				tam = tam + fitem.getSize();
	        } 
		}		
       
		if (erroVerif == true || tam > 4*1024*1024)   //tam > 4MB
		{
			//imprime msg de erro
			//response.sendRedirect("upload_result.jsp?"+"info=erroTam");
			response.sendRedirect("msg.jsp?info=erroTam");
			return;
			
		}
		else
		{
			try
			{

				// Cria nova pasta
				boolean success = (new File(caminho+nomeDir)).mkdir();
				
				if (success) 
				{
					caminho = caminho + nomeDir + "/";
					while (it.hasNext()) 
					{  

						FileItem fitem = (FileItem) it.next();


						if (!fitem.isFormField()) //ve se o formFild ? do tipo que passa um texto (nome da pessoa e e-mail)
						{

							try
							{
								int posicao = fitem.getName().lastIndexOf('.');
								String sufixo = fitem.getName().substring(posicao);
								//nomeArquivo = caminho + fitem.getFieldName() + "_" + fitem.getName();
								nomeArquivo = caminho + fitem.getFieldName() + sufixo;
								fitem.write(new File (nomeArquivo));
							}
							catch (IOException e)
							{  
							//imprime msg de erro avisando que n?o foi possivel criar os arquivos
								//response.sendRedirect("upload_result.jsp?"+"info=erroUp");
								response.sendRedirect("msg.jsp?info=erroUp");
								return;
							}
						}					 
					}   
				}
				else
				{
					//Imprime msg de erro avisando q n?o voi possivel Criar o diret?rio pois j? existe outra pessoa cadastrada com esse nome
					//response.sendRedirect("upload_result.jsp?"+"info=erroDir");
					response.sendRedirect("msg.jsp?info=erroDir");
					return;
				}
			}
			catch (Exception e)//Catch exception if any
			{
				//imprime msg de erro: N?o foi possivel upar os arquivos
				//response.sendRedirect("upload_result.jsp?"+"info=erroUp");
				response.sendRedirect("msg.jsp?info=erroUp");
				return;
			}
			
			if (erroUpload == false)
			{			
				//ENVIANDO E-MAIL DE CONFIRMA??O PARA QUEM ACABOU DE REALIZAR A INSCRI?AO

String assunto = "Confirmacao de Inscricao - Processo de Seleção para Mestrado no PPGCC";
String mensagem1 = "Ola!\nSua inscricao no Processo de Seleção para Mestrado no PPGCC - foi realizada com sucesso.\n\nA divulgacao dos alunos selecionados sera no dia 24 de fevereiro de 2016.\n\nPara saber mais, acesse o site http://ppgcc.dc.ufscar.br.\n\nAte mais!\n\nSecretaria do PPGCC\nDepartamento de Computacao (UFSCar)\nUniversidade Federal de Sao Carlos\nRodovia Washington Luis, km 235\nCEP: 13.565-905 - Sao Carlos (SP)\nTelefone - (16) 3351-9494 /  3351-8610\nHomepage: http://ppgcc.dc.ufscar.br\nE-mail: secppgcc@dc.ufscar.br";
String mensagem2 = "Ola!\n\nMeu nome eh " + nomeDir + " e meu e-mail eh " + email + ". Sou o mais novo candidato inscrito no Processo de Seleção para Mestrado no PPGCC.\nPara conferir a lista completa de candidatos, verifique o diretorio /inscricoes/ppgcc/" + nomeDir + "/.\n\nAte mais!";

Properties p = new Properties();
p.put("mail.host", "mail.dc.ufscar.br");
Session session1 = Session.getInstance(p, null);
MimeMessage msg = new MimeMessage(session1);
try {
     // "de" e "para"!!
           msg.setFrom(new InternetAddress("secppgcc@dc.ufscar.br"));
           msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
	   msg.setContent(mensagem1.toString(), "text/html");
                         // nao esqueca da data!
                         // ou ira 31/12/1969 !!!
                              msg.setSentDate(new Date());
                                        msg.setSubject(assunto);
     
                                         msg.setText(mensagem1);
     
                                              // evniando mensagem (tentando)
                                                   Transport.send(msg);
                                                    }
                                                     catch (AddressException e) {
                                                          // nunca deixe catches vazios!
                                                           }
                                                            catch (MessagingException e) {
                                                                 // nunca deixe catches vazios!
                                                                  }
     
     
     		
				//ENVIANDO E-MAIL DE CONFIRMA??O PARA O ADMINISTRADOR AVISANDO DE UMA NOVA INSCRI??O

Properties p1 = new Properties();
p1.put("mail.host", "mail.dc.ufscar.br");
Session session2 = Session.getInstance(p1, null);
MimeMessage msg1 = new MimeMessage(session2);
try {
     // "de" e "para"!!
          msg1.setFrom(new InternetAddress(email));
               msg1.setRecipient(Message.RecipientType.TO, new InternetAddress("secppgcc@dc.ufscar.br"));
	       msg1.setContent(mensagem2.toString(), "text/html");
                     // nao esqueca da data!
                        // ou ira 31/12/1969 !!!
                              msg1.setSentDate(new Date());
                                        msg1.setSubject(assunto);
                                             msg1.setText(mensagem2);
                                                  // evniando mensagem (tentando)
                                                 Transport.send(msg1);
                                                   }
                                                    catch (AddressException e) {
                                                         // nunca deixe catches vazios!
                                                          }
                                                           catch (MessagingException e) {
                                                                // nunca deixe catches vazios!
                                                                 }
				         
     
				
				//envia mensagem de que os arquivos foram upados com sucesso
				//response.sendRedirect("upload_result.jsp?"+"info=sucesso");
				response.sendRedirect("msg.jsp?info=sucesso");
				return;
			}
	   
       		
        }
	}		
%>  
