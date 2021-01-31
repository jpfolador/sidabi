<?php
	session_start();
	include_once '../../../_classes/start.php';

	$tpl = new Template("../../view/html/telaHomeInova.html");

	$menu = SidabiLoginMenu::carregarMenuPermitido($_SESSION["usuario_id"], $_SESSION["modulo_id"]);
	if (!empty($menu))
	{
		foreach ($menu as $item)
		{
			if ( ($item["incluir"] != null) || ($item["editar"] != null)
				|| ($item["visualizar"] != null) || ($item["excluir"] != null) )
			{
				$tpl->MENU_ID = $item["id"];
				$tpl->MENU_NOME = $item["nome"];
				$tpl->MENU_URL = $item["url"];
				$tpl->block("BLOCO_MENU");
			}
		}
	}
	else
	{
		$tpl->block("BLOCO_SEM_PERMISSAO");
	}

	// verificar se o usuário logado é administrador para poder ver o gráfico
/*
	$usuário = SidabiLogin::consultarLoginPeloId($_SESSION["usuario_id"]);
	if (!empty($usuário))
	{
		if ($usuário[0]["administrador"]) {
			$tpl->block("INOVA_GRAPH");
		}
	}
*/
	$tpl->show();