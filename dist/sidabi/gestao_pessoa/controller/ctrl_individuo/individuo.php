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
		$tpl = new Template("../../view/html/individuo.html");

		// busca permissão de acordo com cada menu clicado e habilita o CRUD definido no BD
		include_once ("../../../_classes/permissaoTela.php");

		$opcoes = "";
		$estados = PublicEstado::consultarEstados();
		if (!empty($estados)) {
			foreach ($estados as $linha) {
				$opcoes .= $linha["id"] . ":" . preg_replace("/[\n\r]/","", $linha["nome"]) . ";";
			}
			$opcoes = substr($opcoes, 0, -1);
		}
		$tpl->OPTIONS_ESTADO = "'" . $opcoes . "'";

		$opcoes = "";
		$tipoSangue = PublicTipoSangue::consultarTipoSangue();
		if (!empty($tipoSangue)) {
			foreach ($tipoSangue as $linha) {
				$opcoes .= $linha["id"] . ":" . preg_replace("/[\n\r]/","", $linha["tipo"]) . ";";
			}
			$opcoes = substr($opcoes, 0, -1);
		}
		$tpl->OPTIONS_TIPO_SANGUE = "'" . $opcoes . "'";

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