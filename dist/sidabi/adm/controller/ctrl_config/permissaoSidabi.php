<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
    // não há sessão
    $json->setStatus("redir");
}
else
{
    // login já realizado
    try
    {
        $tpl = new Template("../../view/html/permissaoSidabi.html");

        $opcoes = "";
        $login = SidabiLogin::consultarLogin();
        if (!empty($login)) {
            foreach ($login as $linha) {
                $opcoes .= $linha["id"] . ":" . $linha["usuario"] . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_USUARIO = "'" . $opcoes . "'";

        $opcoes = "";
        $modulo = SidabiModulo::consultarModulo();
        if (!empty($modulo)) {
            foreach ($modulo as $linha) {
                $opcoes .= $linha["id"] . ":" . $linha["sigla"] . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_MODULO = "'" . $opcoes . "'";

        $json->setStatus("ok");
        $json->setObjeto( $tpl->parse() );
    }
    catch (Exception $ex)
    {
        $json->setStatus("erro");
        $json->setMensagem($ex->getMessage());
    }
}

$json->imprimirJSON();