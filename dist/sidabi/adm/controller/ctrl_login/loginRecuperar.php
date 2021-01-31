<?php
include_once '../../../_classes/start.php';

$email = !empty($_POST['email']) ? $_POST['email'] : null;
$json = new JSON();
$retorno = array();

try
{
    if ($email == null) {
        throw new Exception("O email para recuperação não foi informado!");
    }

    $login = SidabiLogin::verificarEmail($email);
    if ($login["email"] == $email)
    {
        $to      = $email;
        $subject = "NIATS | SIDABI - Solicitação para recuperação de acesso";

        $message = "<html>
                        <head>
                        <title> Recuperar senha - NIATS | SIDABI </title>
                        </head>
                    <body style='font-size: 14px;'> <div>";
        $message .= "<p>Este é um email automático solicitando a recuperação de sua senha. Portanto, NÃO responda este email.</p> <p> <strong>"
                    . $login["nome"] . "</strong>, para recuperar a autenticação no SIDABI clique no link a seguir: </p>
                    <p><a href='http://biodata.feelt.ufu.br/?h=" . $login["senha"] . "&u=" . $login["id"] . "'> Recuperar acesso no SIDABI </a> </p> 
                    <p>
                        Caso o link não funcione, copie a url abaixo e cole na barra de endereço do seu navegador: <br/>
                        <strong>http://biodata.feelt.ufu.br/?h=". $login["senha"] . "&u=" . $login["id"] ."</strong></p>";
        $message .= "</div> </body> </html>";

        $headers = "MIME-Version: 1.0" . "\r\n";
        $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
        $headers .= 'From: niats.sidabi@gmail.com' . "\r\n";

        if (mail($to, $subject, $message, $headers))
        {
            $retorno = 'Email enviado com sucesso!';
        }
        else
        {
            throw new Exception('Falha ao enviar email de recuparação de senha!');
        }

        $json->setStatus("ok");
        $json->setObjeto( $retorno );
    }else{
        throw new Exception("O email informado não possui cadastro!");
    }
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getTraceAsString());
}

$json->imprimirJSON();