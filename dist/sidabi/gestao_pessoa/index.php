<?php
session_start();

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
	// não há sessão
	$json->setStatus("redir");
}
else
{
	$_SESSION["modulo_id"] = isset($_GET["moduloId"]) ? $_GET["moduloId"] : null;
	header("Location: /sidabi/gestao_pessoa/controller/ctrl_tela_principal/telaPrincipal.php");
	exit;
}