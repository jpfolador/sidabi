<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$page = $_GET['page'];
$limit = $_GET['rows'];
$sidx = $_GET['sidx'];
$sord = $_GET['sord'];

$_search = $_GET['_search'];
$filtro = array();
$filtro["id"] 					= isset($_GET["id"]) ? $_GET["id"] : null;
$filtro["numero_registro"] 		= isset($_GET["numero_registro"]) ? $_GET["numero_registro"] : null;
$filtro["individuo_nome"] 		= isset($_GET["individuo_nome"]) ? $_GET["individuo_nome"] : null;
$filtro["dt_diagnostico"] 		= isset($_GET["dt_diagnostico"]) ? $_GET["dt_diagnostico"] : null;
$filtro["medico_responsavel"] 	= isset($_GET["medico_responsavel"]) ? $_GET["medico_responsavel"] : null;
$filtro["individuo_sexo"] 		= isset($_GET["individuo_sexo"]) ? $_GET["individuo_sexo"] : null;
$filtro["diagnostico"] 			= isset($_GET["diagnostico"]) ? $_GET["diagnostico"] : null;
$filtro["telefone1"] 			= isset($_GET["telefone1"]) ? $_GET["telefone1"] : null;
$filtro["data_nascimento"] 		= isset($_GET["data_nascimento"]) ? $_GET["data_nascimento"] : null;

try
{
	if (!$sidx) $sidx = 1;

	$result = PublicIndividuo::contarTodosRegistros();
	$qtdRegistros = $result[0]['count'];

	if ($qtdRegistros > 0 && $limit > 0) {
		$total_pages = ceil($qtdRegistros / $limit);
	} else {
		$total_pages = 0;
	}

	if ($page > $total_pages) $page = $total_pages;

	$start = $limit*$page - $limit;
	if ($start < 0) $start = 0;

	$result = null;
	$saida = null;

	if ($_search) {
		$result = PublicIndividuo::consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro);
	}else{
		$result = PublicIndividuo::consultarTodosRegistros($sidx, $sord, $start, $limit);
	}

	$saida["rows"] = $result;
	$saida["totalrecords"] = "$qtdRegistros";
	$saida["currpage"] = "$page";
	$saida["totalpages"] = "$total_pages";

	$json->setStatus("ok");
	$json->setObjeto( $saida );
}
catch (Exception $ex)
{
	$json->setStatus("erro");
	$json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();