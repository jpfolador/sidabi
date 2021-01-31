<?php
include_once '../../../_classes/start.php';

$senha1 = !empty($_POST['senha1']) ? trim($_POST['senha1']) : null;
$senha2 = !empty($_POST['senha2']) ? trim($_POST['senha2']) : null;
$usuarioId = !empty($_POST['usuario']) ? $_POST['usuario'] : null;

$json = new JSON();
$retorno = array();

try
{
    if ($usuarioId === null) {
        throw new Exception("O usuário não foi carregado!");
    }
    if ($senha1 === null) {
        throw new Exception("A 1ª senha está vazia!");
    }
    if ($senha2 === null) {
        throw new Exception("A 2ª senha está vazia!");
    }
    if ($senha1 !== $senha2) {
        throw new Exception("As senhas informadas devem ser identicas!");
    }

    $login = SidabiLogin::consultarLoginPeloId($usuarioId);
    $login = array_filter($login);
    if ( !empty($login) )
    {
        $retorno = SidabiLogin::atualizarSenha($senha1, $usuarioId);
    }
    else
    {
        throw new Exception("O usuário não encontrado!");
    }

    $json->setStatus("ok");
    $json->setObjeto( "Senha atualizada com sucesso." );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();