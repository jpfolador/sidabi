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
		$tpl = new Template("../../view/html/ideia.html");

		// busca permissão de acordo com cada menu clicado e habilita o CRUD definido no BD
		include_once ("../../../_classes/permissaoTela.php");

		$opcoes = "";
		$setor = InovaSetor::consultarSetor();
		if (!empty($setor)) {
			foreach ($setor as $linha) {
				$opcoes .= $linha["id"] . ":" . $linha["nome"] . ";";
			}
			$opcoes = substr($opcoes, 0, -1);
		}
		$tpl->OPTIONS_SETOR = "'" . $opcoes . "'";
		
		$opcoes = "";
		$solicitante = InovaIdealizador::consultarIdealizador();
		if (!empty($solicitante)) {
			foreach ($solicitante as $linha) {
				$opcoes .= $linha["id"] . ":" . $linha["nome"] . ";";
			}
			$opcoes = substr($opcoes, 0, -1);
		}
		$tpl->OPTIONS_IDEALIZADOR = "'" . $opcoes . "'";
		

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