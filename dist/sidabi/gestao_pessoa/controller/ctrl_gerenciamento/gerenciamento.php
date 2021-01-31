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
        $tpl = new Template("../../view/html/gerenciamento.html");

        $menu = SidabiLoginMenu::carregarMenuPermitido($_SESSION["usuario_id"], $_SESSION["modulo_id"]);
        if (!empty($menu))
        {
            foreach ($menu as $item)
            {
                if ( ($item["incluir"] != null) || ($item["editar"] != null)
                    || ($item["visualizar"] != null) || ($item["excluir"] != null) )
                {
                    $tpl->MENU_ID = $item["id"];
                    $tpl->MENU_NOME = $item["nome"];
                    $tpl->MENU_URL = $item["url"];
                    $tpl->block("BLOCO_MENU");
                }
            }
        }
        else
        {
            $tpl->block("BLOCO_SEM_PERMISSAO");
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