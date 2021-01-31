<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$grupoEstudoId = (isset($_POST["grupoEstudoId"]))? $_POST["grupoEstudoId"] : null;

$retorno = array();
$json = new JSON();

try
{
    if (empty($grupoEstudoId)) {
        throw new Exception("O identificador do 'grupo de estudo' não foi informado!");
    }

    $retorno = BiodataGrupoEstudo::consultarParticipantesPeloGrupoEstudo($grupoEstudoId);

    $json->setStatus("ok");
    $json->setObjeto($retorno);
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();