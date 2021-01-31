<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
    $usuario = $_POST['usuario'];
    $senha = $_POST['senha'];

    $usuario = htmlspecialchars(trim($usuario));
    $senha = htmlspecialchars(trim($senha));

    $login = SidabiLogin::verificarLogin($usuario, $senha);

    if (!empty($login))
    {
        if ($login[0]["ativo"] == 'ativo')
        {
            $_SESSION['usuario'] = $usuario;
            $_SESSION['usuario_id'] = $login[0]["id"];
            $_SESSION['usuario_nome'] = $login[0]["nome"];

            $json->setStatus("ok");
            $json->setObjeto("../../controller/ctrl_tela_modulos/telaModulos.php");
        }
    }
    else
    {
        $json->setStatus("erro");
        if (!empty($login)) {
            if ($login[0]["ativo"] == 'inativo') {
                $json->setMensagem("Este usuário está inativo no sistema!");
            }
        }else{
            $json->setMensagem("Usuário ou senha incorretos!");
        }
    }
}
else
{
    // login já realizado
    $json->setStatus("ok");
    $json->setObjeto( "../../controller/ctrl_tela_modulos/telaModulos.php" );
}

$json->imprimirJSON();