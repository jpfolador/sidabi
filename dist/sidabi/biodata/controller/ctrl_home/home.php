<?php
include_once '../../../_classes/start.php';
header('Content-Type: application/json; charset=utf-8');

$json = new JSON();

try
{
    $tpl = new Template("../../view/html/home.html");

    $json->setStatus("ok");
    $json->setObjeto($tpl->parse());
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();