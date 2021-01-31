<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$individuoId = $_GET['individuo_id'];

try
{
	$result = PublicIndividuoMedicamento::consultarMedicamentoPeloIndividuo($individuoId);
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