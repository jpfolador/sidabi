<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$alternativaIds = isset($_POST["alternativaIds"]) ? $_POST["alternativaIds"] : null;
$questaoId = isset($_POST["questaoId"]) ? $_POST["questaoId"] : null;

try
{
    if (empty($alternativaIds)) {
        throw new Exception("Alternativas não informadas para inserção no banco de dados.");
    }
    if (empty($questaoId)) {
        throw new Exception("Questão não informada. Tente atualizar a página e refazer o processo.");
    }

    $questao = QuestionarioQuestao::buscarQuestaoPeloId($questaoId);
    if (empty($questao)) {
        throw new Exception("Questão não encontrada. Tente atualizar a página e refazer o processo.");
    }

    $arrayAlternativa = explode(",", $alternativaIds);
    foreach ($arrayAlternativa as $id) {
        // Salvar as tuplas
        $questaoAlternativa = QuestionarioQuestaoAlternativa::insert($questao[0]["id"], $id);
    }

    $result["questao_id"] = $questao[0]["id"];
    $result["agrupamento_id"] = $questao[0]["agrupamento_fk_id"];

	$json->setStatus("ok");
	$json->setObjeto( $result );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();