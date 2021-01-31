<?php
header('Content-Type: application/html; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$arquivo = !empty($_POST["arquivo"]) ? $_POST["arquivo"] : null;

try
{
    if ($arquivo != null) {
        if (file_exists($arquivo)) {
            unlink($arquivo);
        }
    }

    $json->setStatus("ok");
    $json->setObjeto("Arquivo temporário apagado");

}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();