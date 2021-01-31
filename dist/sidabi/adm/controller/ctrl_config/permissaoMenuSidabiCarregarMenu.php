<?php

header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$moduloId = isset($_GET["moduloId"]) ? $_GET["moduloId"] : null;

try
{
    if (empty($moduloId)) {
        throw new Exception("O módulo não foi escolhido.");
    }

    $menu = SidabiMenu::consultarMenu($moduloId);
    $temp = array();
    if (!empty($menu)) {
        foreach ($menu as $linha) {
            $temp[$linha["id"]] = $linha["nome"];
        }
    }

    $json->setStatus("ok");
    $json->setObjeto( $temp );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();