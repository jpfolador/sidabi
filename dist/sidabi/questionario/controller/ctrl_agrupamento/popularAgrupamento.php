<?php
header('Content-Type: application/json; charset=utf-8');

include_once '../../../_classes/start.php';
$json = new JSON();

$id = !empty($_POST['agrupamentoId']) ? $_POST['agrupamentoId'] : null;

try {
    if (empty($id)) {
        throw new Exception("O identificador do agrupamento está vazio.");
    }

    $agrupamento = QuestionarioAgrupamento::buscarAgrupamentoPeloId($id);
    if (empty($agrupamento)) {
        throw new Exception("Agrupamento sem dados. Tente atualizar a página e refazer o processo.");
    }

    $json->setStatus("ok");
    $json->setObjeto($agrupamento[0]);
}catch (Exception $e) {
    $json->setStatus("erro");
    $json->setMensagem($e->getMessage());
}

$json->imprimirJSON();