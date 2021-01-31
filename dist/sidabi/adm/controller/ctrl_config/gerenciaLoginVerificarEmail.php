<?php

header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$email = isset($_POST["email"]) ? trim($_POST["email"]) : null;

try
{
    if (empty($email)) {
        throw new Exception("E-mail não informado!");
    }

    $login = SidabiLogin::verificarEmail($email);
    if (!empty($login)) {
        throw new Exception("O e-mail informado já foi cadastrado em outra conta! Informe outro.");
    }

    $json->setStatus("ok");
    $json->setObjeto("E-mail válido.");
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem( $ex->getMessage() );
}

$json->imprimirJSON();