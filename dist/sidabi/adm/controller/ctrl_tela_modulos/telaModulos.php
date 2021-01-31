<?php
	session_start();
	include_once "../../../_classes/start.php";

	$tpl = new Template("../../view/html/telaModulos.html");

	if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
	{
		$hash = isset($_GET["h"]) ? $_GET["h"] : null;
		$user = isset($_GET["u"]) ? $_GET["u"] : null;
		if ( !empty($hash) && !empty($user) )
		{
			$login = SidabiLogin::validarHashRecuperarSenha($hash, $user);
			if (!empty($login))
			{
				if ($login["senha"] == $hash)
				{
					$tpl->SETUSERID = $login["id"];
					$tpl->block("BLOCO_SETUSER");
					$tpl->addFile('TELA_LOGIN', "../../controller/ctrl_login/loginNovoAcesso.php");
				}else{
					$tpl->block("BLOCO_MSG_LINK_INVALIDO");
				}
			}
			else
			{
				$tpl->block("BLOCO_MSG_LINK_INVALIDO");
			}
		}
		else
		{
			$tpl->addFile('TELA_LOGIN', "../../controller/ctrl_login/login.php");
		}
	}
	else
	{
		// login já realizado
		$nome = explode(" ", $_SESSION["usuario_nome"]);
		$tpl->NOME_USUARIO_LOGADO = @$nome[0] . " " . @$nome[count($nome) - 1];

		$modulos = SidabiLogin::loginBuscarModulos($_SESSION["usuario"]);
		if (!empty($modulos))
		{
			foreach ($modulos as $linha)
			{
				$tpl->MODULO_ID = $linha["id"];
				$tpl->CAMINHO_MODULO = $linha["caminho_modulo"];
				$tpl->CAMINHO_IMAGEM = $linha["caminho_imagem"];
				$tpl->SIGLA = $linha["sigla"];
				$tpl->TITULO = $linha["titulo"];
				$tpl->block("BLOCO_MODULO");
			}
			
			if ($modulos[0]["login_administrador"] == true) {
				$tpl->block("BLOCO_CONFIG_SIDABI");
			}
		}
		else
		{
			$tpl->block("BLOCO_MSG_VAZIO");
		}
		$tpl->block("BLOCO_BOTAO_SAIR");
	}

	$tpl->show();