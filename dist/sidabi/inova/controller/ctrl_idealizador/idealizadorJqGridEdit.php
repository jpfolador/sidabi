<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$cargo = isset($_POST["cargo"]) ? $_POST["cargo"] : null;
$aula = isset($_POST["aula"]) ? $_POST["aula"] : null;
$desenvolvimento = isset($_POST["desenvolvimento"]) ? $_POST["desenvolvimento"] : null;
$contato = isset($_POST["contato"]) ? $_POST["contato"] : null;

if ($operacao == 'add')
{
	try
	{
		$idResult = InovaIdealizador::insert($nome, $cargo, $aula, $desenvolvimento, $contato);
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
		$count = InovaIdealizador::update($nome, $cargo, $aula, $desenvolvimento, $contato, $id);
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
		$count = InovaIdealizador::delete($id);
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