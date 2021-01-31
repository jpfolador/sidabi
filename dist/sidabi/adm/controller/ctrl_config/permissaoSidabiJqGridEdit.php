<?php
	
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['id']) ? $_POST['id'] : null;
$login_fk_id = isset($_POST["usuario"]) ? $_POST["usuario"] : null;
$modulo_fk_id = isset($_POST["sigla"]) ? $_POST["sigla"] : null;

if ($operacao == 'add')
{
	try 
	{
		// verificar se já existe a tupla cadastrada
		$tuplaExiste = SidabiLoginModulo::verificarTuplaUsuarioModulo($login_fk_id, $modulo_fk_id);
		if (!empty($tuplaExiste)) {
			throw new Exception ("<b>O usuário já possui permissão no módulo escolhido!</b>");
		}

		// verificar se existe telas (menus) cadastrados
		$laTelas = SidabiMenu::consultarMenu($modulo_fk_id);
		if (empty($laTelas)) {
			throw new Exception("Não existe nenhuma tela cadastrada para o módulo escolhido. <br/> <b>Cadastre todas as telas antes de atribuir alguma permissão para o módulo!</b>");
		}

		// insere a tupla usuario - modulo
		$idResult = SidabiLoginModulo::insert($login_fk_id, $modulo_fk_id);

		// atribui permissão padrão para as telas do modulo
		$result = SidabiLoginModulo::inserirPermissaoPadraoNoModulo($login_fk_id, $laTelas);
		if (!$result) {
			throw new Exception ("Não foi possível atrituir as permissões padronizadas ao módulo escolhido!");
		}

		$json->setStatus("ok");
		$json->setObjeto( "Registro adicionado com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao adicionar os dados: <br/>" . $e->getMessage());
	}
}

if ($operacao == 'edit')
{
	try 
	{
		$count = SidabiLoginModulo::update($login_fk_id, $modulo_fk_id, $id);
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
		$loginId = isset($_POST["loginId"]) ? $_POST["loginId"] : null;
		$moduloId = isset($_POST["moduloId"]) ? $_POST["moduloId"] : null;
		if (empty($loginId) || empty($moduloId)) {
			throw new Exception("O identificador do usuário e módulo não forom passados. Atualize e tente novamente!");
		}

		// procurar as telas dependentes do módulo a ser excluido
		$telas = SidabiLoginMenu::buscarTelasPermitidasModulo($loginId, $moduloId);

		if (!empty($telas))
		{
			foreach ($telas as $tela)
			{
				// Apagar cada tela
				$loginMenuPermissao = SidabiLoginMenu::delete($tela["id"]);
				if ($loginMenuPermissao == 0) {
					throw new Exception("Não foi possível apagar a tela " . $tela["id"]);
				}
			}
		}

		// apagar a tupla login_módulo
		$count = SidabiLoginModulo::delete($id);

		$json->setStatus("ok");
		$json->setObjeto( "Permissões no módulo e telas dependentes apagados com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao apagar o registro " . $e->getTraceAsString());
	}
}

$json->imprimirJSON();