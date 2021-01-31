<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

try
{
    $result = BiodataSessao::consultarSessaoPorMeses(18);
    $resultArr = null;
    if (!empty($result)) {
        foreach ($result as $linha) {
            $resultArr[] = array("mes" => $linha["mes"], "qtd_sessao" => (int) $linha["qtd_sessao"]);
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