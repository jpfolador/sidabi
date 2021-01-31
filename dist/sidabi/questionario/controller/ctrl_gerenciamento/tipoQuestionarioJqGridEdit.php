<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$titulo = isset($_POST["titulo"]) ? $_POST["titulo"] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;
$enderecoEletronico = isset($_POST["endereco_eletronico"]) ? $_POST["endereco_eletronico"] : null;
$status = isset($_POST["status"]) ? $_POST["status"] : null;

$status = ($status == 'ativo') ? 'true' : 'false';

if ($operacao == 'add')
{
	try
	{
		$idResult = QuestionarioTipoQuestionario::insert($titulo, $descricao, $enderecoEletronico, $status);
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
		$count = QuestionarioTipoQuestionario::update($id, $titulo, $descricao, $enderecoEletronico, $status);
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
		$count = QuestionarioTipoQuestionario::delete($id);
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