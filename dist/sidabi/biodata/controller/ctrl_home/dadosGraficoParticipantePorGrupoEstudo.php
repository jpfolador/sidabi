<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

try
{
    $result = BiodataGrupoEstudo::consultarParticipantePorGrupoEstudo();
    $resultArr = null;
    if (!empty($result)) {
        foreach ($result as $linha) {
            $resultArr[] = array("grupo_estudo_nome" => $linha["grupo_estudo_nome"], "qtd_participante" => (int) $linha["qtd_participante"]);
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