<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$dadosParticipante = array();
$id   = !empty($_POST['id']) ? $_POST['id'] : null;
$arquivo = isset($_POST["arquivo"]) ? $_POST["arquivo"] : null;

try
{
    $resultado = BiodataSessao::atualizarRemocaoArquivo($id, $arquivo);

    $json->setStatus("ok");
    $json->setObjeto( $resultado );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();