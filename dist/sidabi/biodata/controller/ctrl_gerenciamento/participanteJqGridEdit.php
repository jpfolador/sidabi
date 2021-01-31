<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$dadosParticipante = array();
$dadosParticipante["id"]							= !empty($_POST['id']) ? $_POST['id'] : null;
$dadosParticipante["nome"]							= isset($_POST["nome"]) ? $_POST["nome"] : null;
$dadosParticipante["data_nascimento_formatada"]		= isset($_POST["data_nascimento_formatada"]) ? $_POST["data_nascimento_formatada"] : null;
$dadosParticipante["sexo"]							= isset($_POST["sexo"]) ? $_POST["sexo"] : null;
$dadosParticipante["foto"]							= isset($_POST["nomeArquivo"]) ? $_POST["nomeArquivo"] : null;
$dadosParticipante["telefone"]						= isset($_POST["telefone"]) ? $_POST["telefone"] : null;
$dadosParticipante["celular"]						= isset($_POST["celular"]) ? $_POST["celular"] : null;
$dadosParticipante["email"]							= isset($_POST["email"]) ? $_POST["email"] : null;
$dadosParticipante["endereco"]					    = isset($_POST["endereco"]) ? $_POST["endereco"] : null;
$dadosParticipante["cep"]						    = isset($_POST["cep"]) ? $_POST["cep"] : null;
$dadosParticipante["tipo_sangue_descricao"]			= isset($_POST["tipo_sangue_descricao"]) ? $_POST["tipo_sangue_descricao"] : null;
$dadosParticipante["peso"]					        = !empty($_POST["peso"]) ? str_replace(",",".", $_POST["peso"]) : null;
$dadosParticipante["altura"]						= !empty($_POST["altura"]) ? str_replace(",",".", $_POST["altura"]) : null;

if ($operacao == 'add')
{
    try
    {
        $idResult = BiodataParticipante::insert($dadosParticipante);
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
        $count = BiodataParticipante::update($dadosParticipante);
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
        $count = BiodataParticipante::delete($dadosParticipante["id"]);
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