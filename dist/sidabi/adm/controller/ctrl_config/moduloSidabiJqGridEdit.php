<?php
	
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$sigla = isset($_POST["sigla"]) ? $_POST["sigla"] : null;
$titulo = isset($_POST["titulo"]) ? $_POST["titulo"] : null;
$status = isset($_POST["status"]) ? $_POST["status"] : null;
$caminho_imagem = isset($_POST["caminho_imagem"]) ? $_POST["caminho_imagem"] : null;
$caminho_modulo = isset($_POST["caminho_modulo"]) ? $_POST["caminho_modulo"] : null;

if ($status == 'ativo') {
	$status = true;
}else{
	$status = false;
}

if ($operacao == 'add')
{
	try 
	{
		$idResult = SidabiModulo::insert($sigla, $titulo, $status, $caminho_imagem, $caminho_modulo);
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
		$count = SidabiModulo::update($sigla, $titulo, $status, $caminho_imagem, $caminho_modulo, $id);
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
		$count = SidabiModulo::delete($id);
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