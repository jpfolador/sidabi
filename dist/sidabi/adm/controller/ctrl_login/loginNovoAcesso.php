<?php
include_once '../../../_classes/start.php';

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
    $tpl = new Template("../../view/html/loginNovoAcesso.html");
    $tpl->block("BLOCO_NOVA_SENHA");
    $tpl->show();
}
else
{
    // login já realizado
    redirect("../../controller/ctrl_tela_modulos/telaModulos.php");
}