<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$grupoEstudoId = $_GET['grupoEstudoId'];

try
{
	$result = BiodataParticiipanteGrupo::consultarParticipantePeloGrupoEstudo($grupoEstudoId);
	$saida["rows"] = $result;

	$json->setStatus("ok");
	$json->setObjeto( $saida );
}
catch (Exception $ex)
{
	$json->setStatus("erro");
	$json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();