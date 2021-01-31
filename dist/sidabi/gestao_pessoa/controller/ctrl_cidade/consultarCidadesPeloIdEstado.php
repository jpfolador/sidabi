<?php
	header('Content-Type: application/json; charset=utf-8');
	include_once '../../../_classes/start.php';
	
	$estadoId = (isset($_POST["estadoId"]))? $_POST["estadoId"] : null;
	
	$retorno = array();
	$json = new JSON();
	
	try
	{
		if(empty($estadoId)) {
			throw new Exception("O id do estado não foi informado");
		}
	
		$retorno = PublicCidade::consultarCidadesPeloIdEstado($estadoId);
	
		$json->setStatus("ok");
		$json->setObjeto($retorno);
	}
	catch (Exception $ex)
	{
		$json->setStatus("erro");
		$json->setMensagem($ex->getMessage());
	}
	$json->imprimirJSON();