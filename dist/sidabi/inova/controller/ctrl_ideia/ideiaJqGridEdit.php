<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;
$chaves = isset($_POST["chaves"]) ? $_POST["chaves"] : null;
$setor = isset($_POST["setor_nome"]) ? $_POST["setor_nome"] : null;
$idealizador = isset($_POST["idealizador_nome"]) ? $_POST["idealizador_nome"] : null;
$status = isset($_POST["status"]) ? $_POST["status"] : null;

if ($operacao == 'add')
{
	try
	{
		$idResult = InovaIdeia::insert($descricao, $chaves, $setor, $idealizador, $status);
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
		$count = InovaIdeia::update($descricao, $chaves, $setor, $idealizador, $status, $id);
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
		$count = InovaIdeia::delete($id);
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