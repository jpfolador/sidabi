<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
	// não há sessão
	$json->setStatus("redir");
}
else
{
	// login já realizado
	try
	{
		$tpl = new Template("../../view/html/gerenciaLogin.html");

		$opcoes = "";
		$perfil = SidabiPerfil::consultarPerfil();
		if (!empty($perfil)) {
			foreach ($perfil as $linha) {
				$opcoes .= $linha["id"] . ":" . $linha["descricao"] . ";";
			}
			$opcoes = substr($opcoes, 0, -1);
		}
		$tpl->OPTIONS_PERFIL = "'" . $opcoes . "'";

		$json->setStatus("ok");
		$json->setObjeto( $tpl->parse() );
	}
	catch (Exception $ex)
	{
		$json->setStatus("erro");
		$json->setMensagem($ex->getMessage());
	}
}

$json->imprimirJSON();