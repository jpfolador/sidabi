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
        $tpl = new Template("../../view/html/associarGrupoPesquisadoresLoginSidabi.html");
        
        $usuarios = SidabiLogin::consultarUsuariosAtivos();
        if (!empty($usuarios)) {
            foreach ($usuarios as $item) {
                $tpl->LOGIN_ID = $item["id"];
                $tpl->LOGIN_NOME = $item["nome"];
                $tpl->block("BLOCO_USUARIO_ITEM");
            }
        }else{
            $tpl->block("BLOCO_USUARIO_ITEM_VAZIO");
        }
        
        $grupos = SidabiGrupoPesquisadoresLogin::consultarUsuarioNosGrupos();

        if (!empty($grupos)) {
            $grupoPesquisadoresIdAnterior = 0;
            $nomesUsuarios = '';
            foreach ($grupos as $key => $item)
            {
                if ($item["grupo_pesquisadores_id"] !== $grupoPesquisadoresIdAnterior) {
                    if ($key !== 0) {
                        //$tpl->USUARIOS_DO_GRUPO = $nomesUsuarios;
                        $tpl->block("BLOCO_GRUPO_PESQUISADORES_ITEM");
                    }

                    $tpl->GRUPO_PESQUISADORES_LOGIN_ID = $item["grupo_pesquisadores_login_id"];
                    $tpl->GRUPO_PESQUISADORES_ID = $item["grupo_pesquisadores_id"];
                    $tpl->GRUPO_PESQUISADORES_NOME = $item["grupo_pesquisadores_nome"];
                    
                    if ($item["grupo_pesquisadores_login_id"] != null) {
                        $tpl->USUARIOS_DO_GRUPO = $item["login_nome"];
                        $tpl->block("BLOCO_USUARIO_GRUPO_ITEM");
                    }
                    $grupoPesquisadoresIdAnterior = $item["grupo_pesquisadores_id"];
                }else{
                    $tpl->GRUPO_PESQUISADORES_LOGIN_ID = $item["grupo_pesquisadores_login_id"];
                    $tpl->USUARIOS_DO_GRUPO = $item["login_nome"];
                    $tpl->block("BLOCO_USUARIO_GRUPO_ITEM");
                }
            }
            $tpl->USUARIOS_DO_GRUPO = $nomesUsuarios;
            $tpl->block("BLOCO_GRUPO_PESQUISADORES_ITEM");
        }else{
            $tpl->block("BLOCO_GRUPO_ITEM_VAZIO");
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