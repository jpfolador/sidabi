<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

try
{
    $result = SidabiLogin::consultarUsuarioPorGrupoPesquisador();
    $resultArr = null;
    if (!empty($result)) {
        foreach ($result as $linha) {
            $resultArr[] = array("grupo_pesquisadores_nome" => $linha["grupo_pesquisadores_nome"], "qtd_usuario" => (int) $linha["qtd_usuario"]);
        }
    }else{
        $resultArr = 0;
    }
    $json->setStatus("ok");
    $json->setObjeto( $resultArr );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();