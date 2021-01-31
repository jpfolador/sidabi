<?php
/**
 * Script para pesquisar pacientes
 */

header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$gsSearchParam = (isset($_POST["searchParam"]))? $_POST["searchParam"] : null;
$dependenciesParam = (isset($_POST["dependenciesParam"]))? $_POST["dependenciesParam"] : null;
$offset = (isset($_POST["offset"]))? $_POST["offset"] : null;
$limit = (isset($_POST["limit"]))? $_POST["limit"] : null;
$retorno = array();
$json = new JSON();

try
{
    // o parametro vem como fk_grupoEstudo=5, tem que quebrar e pegar só o valor.
    if (!empty($dependenciesParam)) {
        $temp = explode("=", $dependenciesParam);
        $dependenciesParam = $temp[1];
    }
    if (empty($dependenciesParam)) {
        throw new Exception("Para usar este filtro, escolha o Grupo de estudo primeiro.");
    }
    $retorno["results"] = PublicIndividuo::procurarIndividuoGrupoInlineDependency($gsSearchParam, $offset, $limit, $dependenciesParam);
    $liTotalLinhas = PublicIndividuo::procurarIndividuoGrupoInlineCountDependency($gsSearchParam, $dependenciesParam);
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