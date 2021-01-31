<?php
	
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;

$loginId = isset($_POST["usuario"]) ? $_POST["usuario"] : null;
$menuId = isset($_POST["menu_nome"]) ? $_POST["menu_nome"] : null;
$incluir = isset($_POST["incluir"]) ? $_POST["incluir"] : null;
$editar = isset($_POST["editar"]) ? $_POST["editar"] : null;
$visualizar = isset($_POST["visualizar"]) ? $_POST["visualizar"] : null;
$excluir = isset($_POST["excluir"]) ? $_POST["excluir"] : null;

if ($operacao == 'add')
{
	try 
	{
		$idResult = SidabiLoginMenu::insert($loginId, $menuId, $incluir, $editar, $visualizar, $excluir);
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
		$count = SidabiLoginMenu::update($loginId, $menuId, $incluir, $editar, $visualizar, $excluir, $id);
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
		$count = SidabiLoginMenu::delete($id);
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