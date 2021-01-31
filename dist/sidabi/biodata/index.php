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
	header("Location: /sidabi/biodata/controller/ctrl_home_biodata/telaHomeBiodata.php");
	exit;
}
