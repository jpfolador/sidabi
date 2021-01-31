<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
    // não há sessão
    $json->setStatus("redir");
}
else
{
    // login já realizado
    try
    {
        $tpl = new Template("../../view/html/telaModuloDadosUsuario.html");

        $usuário = SidabiLogin::consultarLoginPeloId($_SESSION["usuario_id"]);
        if (!empty($usuário))
        {
            $tpl->USUARIO_ID = $usuário[0]["id"];
            $tpl->NOME_COMPLETO = $usuário[0]["nome"];
            $tpl->USUARIO = $usuário[0]["usuario"];
            $tpl->SENHA = $usuário[0]["senha"];
            $tpl->EMAIL = $usuário[0]["email"];
            if ($usuário[0]["administrador"]) {
                $tpl->USUARIO_ADM = "checked='checked'";
                $tpl->USUARIO_COMUM = "";
            }else {
                $tpl->USUARIO_COMUM = "checked='checked'";
                $tpl->USUARIO_ADM = "";
            }
            if ($usuário[0]["ativo"]) {
                $tpl->USUARIO_ATIVO = "checked='checked'";
                $tpl->USUARIO_INATIVO = "";
            }else {
                $tpl->USUARIO_ATIVO = "";
                $tpl->USUARIO_INATIVO = "checked='checked'";
            }

            $perfil = SidabiPerfil::consultarPerfil();
            if (!empty($perfil))
            {
                foreach ($perfil as $linha)
                {
                    $tpl->OPTION_VALUE_PERFIL = $linha["id"];
                    $tpl->OPTION_TEXTO_PERFIL = $linha["descricao"];
                    if ($linha["id"] == $usuário[0]["perfil"]) {
                        $tpl->PERFIL_CHECKED = "selected='selected'";
                    }else{
                        $tpl->PERFIL_CHECKED = "";
                    }
                    $tpl->block("BLOCO_OPTION_PERFIL");
                }
            }

            if ($usuário[0]["administrador"]) {
                $tpl->block("DATA_ADMIN_ATIVO");
            }
        }

        $json->setStatus("ok");
        $json->setObjeto( $tpl->parse() );
    }
    catch (Exception $ex)
    {
        $json->setStatus("erro");
        $json->setMensagem($ex->getMessage());
    }
}

$json->imprimirJSON();