<?php
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$grupoPesquisadoresLoginId	= (!empty($_POST["grupoPesquisadoresLoginId"])) ? $_POST["grupoPesquisadoresLoginId"] : null;

$retorno = array();
$json = new JSON();

try
{
    if (empty($grupoPesquisadoresLoginId)) {
        throw new Exception("O Identificador da associação entre o usuário e o grupo está vazio.");
    }

    $usuarioEncontrado = SidabiGrupoPesquisadoresLogin::consultarGrupoPesquisadoresLoginPeloId($grupoPesquisadoresLoginId);
    if (empty($usuarioEncontrado)) {
        throw new Exception("Associação entre usuaário e grupo de pesquisadores não encontrada.");
    }

    $retorno = SidabiGrupoPesquisadoresLogin::delete($grupoPesquisadoresLoginId);

    $json->setStatus("ok");
    $json->setObjeto($retorno);
}
catch (Exception $e)
{
    $msg = $e->getMessage();
    if ($e->getCode() == '23503') {
        $msg = "Este usuário possui arquivos compartilhados no grupo e não pode ser excluído. \n
                É necessário remover os arquivos dele primeiro. ";

        // TODO
        // verificar a possibilidade de desativar o usuario caso seja necessário
        // retirar do grupo e deixar os arquivos dele ativos
    }
    $json->setStatus("erro");
    $json->setMensagem($msg);
}
$json->imprimirJSON();