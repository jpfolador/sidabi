<?php
	
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$usuario = isset($_POST["usuario"]) ? $_POST["usuario"] : null;
$senha = isset($_POST["senha"]) ? $_POST["senha"] : null;
$email = isset($_POST["email"]) ? $_POST["email"] : null;
$ativo = isset($_POST["ativo"]) ? $_POST["ativo"] : null;
$administrador = isset($_POST["administrador"]) ? $_POST["administrador"] : null;
$perfil = isset($_POST["perfil_descricao"]) ? $_POST["perfil_descricao"] : null;

if ($ativo == 'ativo') {
	$ativo = true;
}else{
	$ativo = false;
}

if ($operacao == 'add')
{
	try 
	{
		if (empty($email)) {
			throw new Exception("E-mail não informado!");
		}

		$login = SidabiLogin::verificarEmail($email);
		if (!empty($login)) {
			throw new Exception("O e-mail informado já foi cadastrado em outra conta! Informe outro.");
		}

		$idResult = SidabiLogin::insert($usuario, $senha, $email, $nome, $ativo, $perfil, $administrador);
		$json->setStatus("ok");
		$json->setObjeto( "Registro adicionado com sucesso!" );
	}
	catch (Exception $e) 
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
	}
}

if ($operacao == 'edit')
{
	try 
	{
		if (empty($email)) {
			throw new Exception("E-mail não informado!");
		}

		// Verifica se o email é o mesmo que estava antes
		$login = SidabiLogin::verificarEmail($email, $id);
		if (empty($login))
		{
			// caso o email tenha se modificado, verifica se existe algum usuário com o email informado
			$login = SidabiLogin::verificarEmail($email, $id, '<>');
			if (!empty($login)) {
				throw new Exception("O e-mail informado já foi cadastrado em outra conta! Informe outro.");
			}
		}
		
		$count = SidabiLogin::update($usuario, $senha, $email, $nome, $ativo, $perfil, $administrador, $id);
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
		$count = SidabiLogin::delete($id);
		$json->setStatus("ok");
		$json->setObjeto( "Registro apagado com sucesso!" );
	}
	catch (Exception $e) 
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao apagar o registro " . $e->getMessage());
	}
}

$json->imprimirJSON();