<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$avaliacaoId = (!empty($_POST["avaliacaoId"])) ? $_POST["avaliacaoId"] : null;

$retorno = array();
$json = new JSON();

try
{
	if (empty($avaliacaoId)) {
		throw new Exception("O identificador da avaliação está vazio. Não é possível finalizá-la");
	}

	$avaliacao = QuestionarioAvaliacao::consultarAvaliacaoPeloId($avaliacaoId);
	if (empty($avaliacao)) {
		throw new Exception("Avaliação não cadastrado!");
	} 
	
	$retorno = QuestionarioAvaliacao::finalizarAvaliacao($avaliacaoId);
	
	$json->setStatus("ok");
	$json->setObjeto($retorno);
}
catch (Exception $ex)
{
	$json->setStatus("erro");
	$json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();