<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$estudo_fk_id = !empty($_POST['estudo_descricao']) ? $_POST['estudo_descricao'] : null;
$nome = isset($_POST["nome"]) ? $_POST["nome"] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;
$criterio_inclusao = isset($_POST["criterio_inclusao"]) ? $_POST["criterio_inclusao"] : null;
$criterio_exclusao = isset($_POST["criterio_exclusao"]) ? $_POST["criterio_exclusao"] : null;

if ($operacao == 'add')
{
    try
    {
        $idResult = BiodataGrupoEstudo::insert($estudo_fk_id, $nome, $descricao, $criterio_inclusao, $criterio_exclusao);
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
        $count = BiodataGrupoEstudo::update($estudo_fk_id, $nome, $descricao, $criterio_inclusao, $criterio_exclusao, $id);
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
        $count = BiodataGrupoEstudo::delete($id);
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