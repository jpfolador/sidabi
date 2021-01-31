<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$descricao = isset($_POST["descricao"]) ? trim($_POST["descricao"]) : null;
$sigla = isset($_POST["sigla"]) ? trim($_POST["sigla"]) : null;
$status = isset($_POST["status"]) ? $_POST["status"] : null;

$status = ($status == 'ativo') ? 'true' : 'false';

if ($operacao == 'add')
{
	try
	{
		$idResult = QuestionarioTipoAplicacao::insert($descricao, $sigla, $status);
		$json->setStatus("ok");
		$json->setObjeto( "Registro adicionado com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
	}
}

if ($operacao == 'edit')
{
	try
	{
		$count = QuestionarioTipoAplicacao::update($id, $descricao, $sigla, $status);
		$json->setStatus("ok");
		$json->setObjeto( "Registro atualizado com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao editar os dados: " . $e->getMessage());
	}
}

if ($operacao == 'del')
{
	try
	{
		$count = QuestionarioTipoAplicacao::delete($id);
		$json->setStatus("ok");
		$json->setObjeto( "Registro apagado com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao apagar o registro " . $e->getMessage());
	}
}

$json->imprimirJSON();