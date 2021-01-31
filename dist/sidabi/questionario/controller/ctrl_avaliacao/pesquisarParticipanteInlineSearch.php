<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$gsSearchParam = (isset($_POST["searchParam"])) ? $_POST["searchParam"] : null;
$offset = (isset($_POST["offset"])) ? $_POST["offset"] : null;
$limit = (isset($_POST["limit"])) ? $_POST["limit"] : null;
$retorno = array();
$json = new JSON();

try
{
    $retorno["results"] = PublicIndividuo::procurarIndividuoInline($gsSearchParam, $offset, $limit);
    $liTotalLinhas = PublicIndividuo:: procurarIndividuoInlineCount($gsSearchParam);
    $retorno['total_pages'] = ceil($liTotalLinhas / $limit);

    $json->setStatus("ok");
    $json->setObjeto($retorno);
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();