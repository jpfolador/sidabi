<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$avaliacaoId = !empty($_POST["avaliacaoId"]) ? $_POST["avaliacaoId"] : null;

$retorno = array();
$json = new JSON();

try
{
	if (empty($avaliacaoId)) {
		throw new Exception("O identificador da avaliação está vazio. Não é possível descartá-la");
	}

    $avaliacao = QuestionarioAvaliacao::consultarAvaliacaoPeloId($avaliacaoId);
    if (empty($avaliacao)) {
        throw new Exception("Avaliação não cadastrado!");
    }

    // Procura pelos grupos de pesquisadores para o qual a avaliação foi compartilhada e apaga.
    $avaliacaoGrupoPesquisadores = QuestionarioAvaliacaoGrupoPesquisadoresLogin::consultarAvaliacaoGrupoPesquisadores($avaliacaoId);
    if (!empty($avaliacaoGrupoPesquisadores)) {
        $retorno["avaliacaoGrupoPesquisadores"] = QuestionarioAvaliacaoGrupoPesquisadoresLogin::deletePeloAvaliacaoId($avaliacaoId);
    }

    // Apaga as respostas já criadas para a avaliação.
    $retorno["resposta"] = QuestionarioResposta::apagarTodasRespostasAvaliacao($avaliacaoId);

    // Apaga a avaliação.
	$retorno["avaliacao"] = QuestionarioAvaliacao::delete($avaliacaoId);

	$json->setStatus("ok");
	$json->setObjeto($retorno);
}
catch (Exception $ex)
{
	$json->setStatus("erro");
	$json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();