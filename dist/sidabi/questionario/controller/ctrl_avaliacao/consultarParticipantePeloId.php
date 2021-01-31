<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$tipoQuestionarioId = (isset($_POST["tipoQuestionarioId"]))? $_POST["tipoQuestionarioId"] : null;
$participanteId = (isset($_POST["participanteId"]))? $_POST["participanteId"] : null;

$retorno = array();
$json = new JSON();

try
{
    if (empty($participanteId)) {
        throw new Exception("O identificador do 'participante' não foi informado");
    }
    if (empty($tipoQuestionarioId)) {
        throw new Exception("O identificador do 'tipo de avaliação' não foi informado");
    }

    $retorno["participante"] = PublicIndividuo::consultarPacientePeloId($participanteId);
    $retorno["avaliacao"] = QuestionarioAvaliacao::consultarAvaliacaoPeloParticipanteId($participanteId, $tipoQuestionarioId);

    $json->setStatus("ok");
    $json->setObjeto($retorno);
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();