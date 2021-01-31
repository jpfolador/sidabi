<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$avaliacaoId = (isset($_POST["avaliacaoId"])) ? $_POST["avaliacaoId"] : null;

$retorno = array();
$json = new JSON();

try
{
    if(empty($avaliacaoId)) {
        throw new Exception("O questionário não foi informado.");
    }

    $retorno = QuestionarioAvaliacao::consultarAvaliacaoRealizada($avaliacaoId);

    $json->setStatus("ok");
    $json->setObjeto($retorno);
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();