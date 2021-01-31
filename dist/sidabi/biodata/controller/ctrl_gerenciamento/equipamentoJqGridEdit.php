<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;

//$status = ($status == 'ativo') ? 'true' : 'false';

if ($operacao == 'add')
{
	try
	{
		$idResult = BiodataEquipamento::insert($descricao, $nome);
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
		$count = BiodataEquipamento::update($descricao, $nome, $id);
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
		$count = BiodataEquipamento::delete($id);
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