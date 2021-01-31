<?php

include_once '../../../_classes/start.php';

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
	$tpl = new Template("../../view/html/login.html");
	$tpl->block("BLOCO_AUTENTICACAO");
	$tpl->show();
}
else
{
	// login já realizado
	redirect("../../controller/ctrl_tela_modulos/telaModulos.php");
}