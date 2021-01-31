<?php
	
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;
$status = isset($_POST["status"]) ? $_POST["status"] : null;

if ($status == 'ativo') {
	$status = true;
}else{
	$status = false;
}

if ($operacao == 'add')
{
	try 
	{
		$idResult = SidabiGrupoPesquisadores::insert($nome, $descricao, $status);
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
		$count = SidabiGrupoPesquisadores::update($nome, $descricao, $status, $id);
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
		$count = SidabiGrupoPesquisadores::delete($id);
		$json->setStatus("ok");
		$json->setObjeto( "Registro apagado com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao apagar o registro: " . $e->getMessage());
	}
}

$json->imprimirJSON();