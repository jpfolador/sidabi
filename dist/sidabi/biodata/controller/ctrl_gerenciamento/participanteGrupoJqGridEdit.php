<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$participanteId = !empty($_POST['participante_nome']) ? $_POST['participante_nome'] : null;
$grupoEstudoId = isset($_GET["grupoEstudoId"]) ? $_GET["grupoEstudoId"] : null;
$grupoEstudoParticipanteId = isset($_POST["id"]) ? $_POST["id"] : null;
$idManual = isset($_POST["id_manual"]) ? $_POST["id_manual"] : null;

if ($operacao == 'add')
{
	try
	{
		$idResult = BiodataParticiipanteGrupo::insert($grupoEstudoId, $participanteId, $idManual);
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
		$r = BiodataParticiipanteGrupo::update($grupoEstudoId, $participanteId, $idManual, $grupoEstudoParticipanteId);
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
		$r = BiodataParticiipanteGrupo::delete($grupoEstudoParticipanteId);
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