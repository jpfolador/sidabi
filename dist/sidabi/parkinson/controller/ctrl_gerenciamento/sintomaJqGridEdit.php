<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$categoria_fk_id = !empty($_POST['categoria_nome']) ? $_POST['categoria_nome'] : null;
$titulo = isset($_POST["titulo"]) ? $_POST["titulo"] : null;
$descricao = isset($_POST["descricao"]) ? $_POST["descricao"] : null;
$caminho_video = isset($_POST["caminho_video"]) ? $_POST["caminho_video"] : null;
$url_informacao = isset($_POST["url_informacao"]) ? $_POST["url_informacao"] : null;

if ($operacao == 'add')
{
    try
    {
        $idResult = ParkinsonSintoma::insert($categoria_fk_id, $titulo, $descricao, $caminho_video, $url_informacao);
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
        $count = ParkinsonSintoma::update($categoria_fk_id, $titulo, $descricao, $caminho_video, $url_informacao, $id);
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
        $count = ParkinsonSintoma::delete($id);
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