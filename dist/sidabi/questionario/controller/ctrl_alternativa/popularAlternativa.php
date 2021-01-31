<?php
header('Content-Type: application/json; charset=utf-8');

include_once '../../../_classes/start.php';
$json = new JSON();

$id = !empty($_POST['alternativaId']) ? $_POST['alternativaId'] : null;
$questaoId = !empty($_POST['questaoId']) ? $_POST['questaoId'] : null;

try {
    if (empty($id)) {
        throw new Exception("O identificador da alternativa está vazio.");
    }
    if (empty($questaoId)) {
        throw new Exception("O identificador da questão está vazio.");
    }

    $questao = QuestionarioQuestao::buscarQuestaoPeloId($questaoId);
    if (empty($questao)) {
        throw new Exception("Questão inválida. Tente atualizar a página e refazer o processo.");
    }
    $result = null;

    $alternativa = QuestionarioAlternativa::buscarAlternativaPeloId($id);
    if (empty($alternativa)) {
        throw new Exception("Alternativa sem dados. Tente atualizar a página e refazer o processo.");
    }

    $result["questao"] = $questao[0];
    $result["alternativa"] = $alternativa[0];

    $json->setStatus("ok");
    $json->setObjeto($result);
}catch (Exception $e) {
    $json->setStatus("erro");
    $json->setMensagem($e->getMessage());
}

$json->imprimirJSON();