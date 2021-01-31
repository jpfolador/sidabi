<?php
header('Content-Type: application/json; charset=utf-8');

include_once '../../../_classes/start.php';
$json = new JSON();

$id = !empty($_POST['questaoId']) ? $_POST['questaoId'] : null;

try {
    if (empty($id)) {
        throw new Exception("O identificador da questão está vazio.");
    }

    $result = QuestionarioQuestao::buscarQuestaoPeloId($id);
    if (empty($result)) {
        throw new Exception("Questão sem dados. Tente atualizar a página e refazer o processo.");
    }

    $json->setStatus("ok");
    $json->setObjeto($result[0]);
}catch (Exception $e) {
    $json->setStatus("erro");
    $json->setMensagem($e->getMessage());
}

$json->imprimirJSON();