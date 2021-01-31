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
$filtro["id"]							= !empty($_GET['id']) ? $_GET['id'] : null;
$filtro["nome"]							= isset($_GET["nome"]) ? $_GET["nome"] : null;
$filtro["data_nascimento_formatada"]	= isset($_GET["data_nascimento_formatada"]) ? $_GET["data_nascimento_formatada"] : null;
$filtro["celular"]						= isset($_GET["celular"]) ? $_GET["celular"] : null;
$filtro["email"]						= isset($_GET["email"]) ? $_GET["email"] : null;

try
{
    if (!$sidx) $sidx = 1;

    $result = BiodataParticipante::contarTodosRegistros();
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
        $result = BiodataParticipante::consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro);
    }else{
        $result = BiodataParticipante::consultarTodosRegistros($sidx, $sord, $start, $limit);
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