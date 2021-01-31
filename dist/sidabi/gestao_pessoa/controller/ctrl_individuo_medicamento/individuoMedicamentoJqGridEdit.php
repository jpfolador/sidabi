<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$individuoId = !empty($_GET['individuo_id']) ? $_GET['individuo_id'] : null;

$id = isset($_POST["id"]) ? $_POST["id"] : null;
$medicamentoId = isset($_POST["medicamento_descricao"]) ? $_POST["medicamento_descricao"] : null;
$dosagem = isset($_POST["dosagem"]) ? trim($_POST["dosagem"]) : null;
$observacao = isset($_POST["observacao"]) ? trim($_POST["observacao"]) : null;

if ($operacao == 'add')
{
	try
	{
		$idResult = PublicIndividuoMedicamento::insert($individuoId, $medicamentoId, $dosagem, $observacao);
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
		$r = PublicIndividuoMedicamento::update($individuoId, $medicamentoId, $dosagem, $observacao, $id);
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
		$r = PublicIndividuoMedicamento::delete($id);
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