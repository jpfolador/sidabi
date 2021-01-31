<?php

include_once '../../../_classes/start.php';

$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;

if ($operacao == 'add')
{
    try
    {
        $idResult = BiodataProtocolo::insert($nome, $descricao);
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
        $count = BiodataProtocolo::update($nome, $descricao, $id);
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
        $count = BiodataProtocolo::delete($id);
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