<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

try
{
    $result = InovaIdeia::consultarIdeiaPorSetor();
    $ideiaSetor = null;
    if (!empty($result)) {
        foreach ($result as $linha) {
            $ideiaSetor[] = array("setor_nome" => $linha["setor_nome"], "qtd_ideia" => (int) $linha["qtd_ideia"]);
        }
    }else{
        $ideiaSetor = 0;
    }
    $json->setStatus("ok");
    $json->setObjeto($ideiaSetor);
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();