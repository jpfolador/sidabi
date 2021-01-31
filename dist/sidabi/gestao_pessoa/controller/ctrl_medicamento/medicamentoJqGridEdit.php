<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? trim($_POST["nome"]) : null;
$descricao = isset($_POST["descricao"]) ? trim($_POST["descricao"]) : null;
$fabricante = !empty($_POST["fabricante"]) ? trim($_POST["fabricante"]) : null;

if ($operacao == 'add')
{
	try
	{
		$idResult = PublicMedicamento::insert($nome, $descricao, $fabricante);
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
		$count = PublicMedicamento::update($nome, $descricao, $fabricante, $id);
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
		$count = PublicMedicamento::delete($id);
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