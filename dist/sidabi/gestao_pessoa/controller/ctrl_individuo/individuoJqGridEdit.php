<?php
/*
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
*/
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$dadosIndividuo = array();
$dadosIndividuo["id"]							= !empty($_POST['id']) ? $_POST['id'] : null;
$dadosIndividuo["nome"]							= !empty($_POST["individuo_nome"]) ? $_POST["individuo_nome"] : null;
$dadosIndividuo["sexo"]							= !empty($_POST["individuo_sexo"]) ? $_POST["individuo_sexo"] : null;
$dadosIndividuo["email"]						= !empty($_POST["email"]) ? $_POST["email"] : null;
$dadosIndividuo["data_nascimento"]				= !empty($_POST["data_nascimento"]) ? $_POST["data_nascimento"] : '';
$dadosIndividuo["telefone1"]					= !empty($_POST["telefone1"]) ? $_POST["telefone1"] : null;
$dadosIndividuo["telefone2"]					= !empty($_POST["telefone2"]) ? $_POST["telefone2"] : null;
$dadosIndividuo["logradouro"]					= !empty($_POST["logradouro"]) ? $_POST["logradouro"] : null;
$dadosIndividuo["numero"]						= !empty($_POST["numero"]) ? $_POST["numero"] : 0;
$dadosIndividuo["bairro"]						= !empty($_POST["bairro"]) ? $_POST["bairro"] : null;
$dadosIndividuo["cidade_fk_id"]					= !empty($_POST["cidade_nome"]) ? $_POST["cidade_nome"] : null; //is name but is passing id
$dadosIndividuo["rg"]							= !empty($_POST["rg"]) ? $_POST["rg"] : null;
$dadosIndividuo["cpf"]							= !empty($_POST["cpf"]) ? $_POST["cpf"] : null;
$dadosIndividuo["diagnostico"]					= !empty($_POST["diagnostico"]) ? $_POST["diagnostico"] : null;
$dadosIndividuo["dt_diagnostico"]				= !empty($_POST["dt_diagnostico"]) ? $_POST["dt_diagnostico"] : null;
$dadosIndividuo["medico_responsavel"]			= !empty($_POST["medico_responsavel"]) ? $_POST["medico_responsavel"] : null;
$dadosIndividuo["telefone_medico_responsavel"]	= !empty($_POST["telefone_medico_responsavel"]) ? $_POST["telefone_medico_responsavel"] : null;
$dadosIndividuo["outras_patologias"]			= !empty($_POST["outras_patologias"]) ? $_POST["outras_patologias"] : null;
$dadosIndividuo["peso"]							= !empty($_POST["peso"]) ? $_POST["peso"] : 0;
$dadosIndividuo["altura"]						= !empty($_POST["altura"]) ? $_POST["altura"] : 0;
$dadosIndividuo["tipo_sangue_fk_id"]			= !empty($_POST["tipo_sangue_descricao"]) ? $_POST["tipo_sangue_descricao"] : null;
$dadosIndividuo["foto"]							= !empty($_POST["nomeArquivo"]) ? $_POST["nomeArquivo"] : null;
$dadosIndividuo["numero_registro"]				= !empty($_POST["numero_registro"]) ? $_POST["numero_registro"] : null;
$dadosIndividuo["instituicao"]					= !empty($_POST["instituicao"]) ? $_POST["instituicao"] : null;

if (!empty($dadosIndividuo["data_nascimento"])) {
	$date = $dadosIndividuo["data_nascimento"];
	$date = explode("/", $date);
	$date = new DateTime($date[2]."-".$date[1]."-".$date[0]);
	$dadosIndividuo["data_nascimento"] = $date->format('Y-m-d');
}
if (!empty($dadosIndividuo["dt_diagnostico"])) {
	$date = $dadosIndividuo["dt_diagnostico"];
	$date = explode("/", $date);
	$date = new DateTime($date[2]."-".$date[1]."-".$date[0]);
	$dadosIndividuo["dt_diagnostico"] = $date->format('Y-m-d');
}

if ($operacao == 'add')
{
	try
	{
		$idResult = PublicIndividuo::insert($dadosIndividuo);
		$json->setStatus("ok");
		$json->setObjeto( "Registro adicionado com sucesso!" );
	}
	catch (Exception $e)
	{
		$json->setStatus("erro");
		$json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage() );
	}
}

if ($operacao == 'edit')
{
	try
	{
		$count = PublicIndividuo::update($dadosIndividuo);
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
		// Procurar o nome do arquivo e apagar o arquivo de foto
		$resultado = PublicIndividuo::procurarIndividuoPeloId( $dadosIndividuo["id"] );
		if (!empty($resultado))
		{
			$nomeArquivo = $resultado[0]["foto"];
			$caminho = $_SERVER["DOCUMENT_ROOT"] . "/sidabi/gestao_pessoa/files/individuos_fotos/";
			if ($nomeArquivo != null) {
				if (file_exists($caminho . $nomeArquivo)) {
					unlink($caminho . $nomeArquivo);
				}
			}
		}
		
		$count = PublicIndividuo::delete($dadosIndividuo["id"]);
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