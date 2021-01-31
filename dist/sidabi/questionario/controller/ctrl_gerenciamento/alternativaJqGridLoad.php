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
$filtro["id"] = isset($_GET["id"]) ? $_GET["id"] : null;
$filtro["descricao"] = isset($_GET["descricao"]) ? $_GET["descricao"] : null;
$filtro["valor"] = isset($_GET["valor"]) ? $_GET["valor"] : null;
$filtro["ordem"] = isset($_GET["ordem"]) ? $_GET["ordem"] : null; //?
$filtro["status"] = isset($_GET["status"]) ? $_GET["status"] : null;

try
{
	if (!$sidx) $sidx = 1;

	$result = QuestionarioAlternativa::contarTodosRegistros();
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
		$result = QuestionarioAlternativa::consultarAlternativasGrid($sidx, $sord, $start, $limit, $filtro);
	}else{
		$result = QuestionarioAlternativa::consultarAlternativasGrid($sidx, $sord, $start, $limit);
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