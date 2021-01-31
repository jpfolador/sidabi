<?php
	
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$url = isset($_POST["url"]) ? $_POST["url"] : null;
$modulo = isset($_POST["modulo_descricao"]) ? $_POST["modulo_descricao"] : null;
$ordem = isset($_POST["ordem"]) ? $_POST["ordem"] : null;

if ($operacao == 'add')
{
	try 
	{
		$idResult = SidabiMenu::insert($nome, $url, $modulo, $ordem);
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
		$count = SidabiMenu::update($nome, $url, $modulo, $ordem, $id);
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
		$count = SidabiMenu::delete($id);
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