<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$codigoIbge = isset($_POST["codigo_ibge"]) ? $_POST["codigo_ibge"] : null;
$estadoFkId = isset($_POST["estado_nome"]) ? $_POST["estado_nome"] : null;
$populacao2010 = isset($_POST["populacao_2010"]) ? $_POST["populacao_2010"] : null;
$densidadeDemo = isset($_POST["densidade_demo"]) ? $_POST["densidade_demo"] : null;
$gentilico = isset($_POST["gentilico"]) ? $_POST["gentilico"] : null;
$area = isset($_POST["area"]) ? $_POST["area"] : null;

if ($operacao == 'add')
{
	try
	{
		$idResult = PublicCidade::insert($nome, $codigoIbge, $estadoFkId, $populacao2010, $densidadeDemo, $gentilico, $area);
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
		$count = PublicCidade::update($nome, $codigoIbge, $estadoFkId, $populacao2010, $densidadeDemo, $gentilico, $area, $id);
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
		$count = PublicCidade::delete($id);
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