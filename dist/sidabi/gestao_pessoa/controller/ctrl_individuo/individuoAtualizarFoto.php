<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$dadosParticipante = array();
$id   = !empty($_POST['id']) ? $_POST['id'] : null;
$foto = isset($_POST["foto"]) ? $_POST["foto"] : null;

try
{
    $resultado = PublicIndividuo::atualizarRemocaoFoto($id, $foto);

    $json->setStatus("ok");
    $json->setObjeto( $resultado );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();