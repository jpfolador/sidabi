<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

$id             = !empty($_POST['usuarioId']) ? $_POST['usuarioId'] : null;
$nome           = isset($_POST["nomeCompleto"]) ? $_POST["nomeCompleto"] : null;
$usuario        = isset($_POST["usuario"]) ? $_POST["usuario"] : null;
$senha          = isset($_POST["senha"]) ? $_POST["senha"] : null;
$confirmarSenha = isset($_POST["confirmarSenha"]) ? $_POST["confirmarSenha"] : null;
$email          = isset($_POST["email"]) ? $_POST["email"] : null;
$ativo          = isset($_POST["ativo"]) ? $_POST["ativo"] : null;
$administrador  = isset($_POST["administrador"]) ? $_POST["administrador"] : null;
$perfil         = isset($_POST["perfil"]) ? $_POST["perfil"] : null;

try
{
    if (trim($senha) !== trim($confirmarSenha)) {
        throw new Exception("Você precisa informar a senha examente igual nos dois campos (Senha e Confirmar senha) para prosseguir.");
    }

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
    // se não for administrador, os campos estão ocultos, regastar os valores e salvar para permanecer inalterado.
    if (!$login["administrador"]) {
        $administrador = $login["administrador"];
        $ativo = $login["ativo"];
    }

    $count = SidabiLogin::update($usuario, $senha, $email, $nome, $ativo, $perfil, $administrador, $id);

    $json->setStatus("ok");
    $json->setObjeto( "Registro atualizado com sucesso!" );
}
catch (Exception $e)
{
    $json->setStatus("erro");
    $json->setMensagem("Erro ao salvar os dados: " . $e->getMessage());
}

$json->imprimirJSON();