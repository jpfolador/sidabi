<?php

header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$gsSearchParam = (isset($_POST["searchParam"])) ? $_POST["searchParam"] : null;
$dependenciesParam = (isset($_POST["dependenciesParam"])) ? $_POST["dependenciesParam"] : null;
$offset = (isset($_POST["offset"])) ? $_POST["offset"] : null;
$limit = (isset($_POST["limit"])) ? $_POST["limit"] : null;
$retorno = array();
$json = new JSON();

try
{
    // É preciso quebrar o parametro de dependencia, pois ele traz uma string contendo fk_estado=4, se vazio, fk_estado=
    $temp = explode("=", $dependenciesParam);
    if (empty($temp[1])) {
        throw new Exception("É preciso informar o Estado primeiro.");
    }

    // o parametro vem como fk_esatado=5, tem que quebrar e pegar só o valor.
    if (!empty($dependenciesParam)) {
        $temp = explode("=", $dependenciesParam);
        $dependenciesParam = $temp[1];
    }
    $retorno["results"] = PublicCidade::procurarCidadeInlineDependency($gsSearchParam, $offset, $limit, $dependenciesParam);
    $liTotalLinhas = PublicCidade::procurarCidadeInlineCountDependency($gsSearchParam, $dependenciesParam);
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