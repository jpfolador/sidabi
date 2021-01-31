<?php
    // arquivo incluido para facilitar manutenção em todas as telas

    // Esta variável é passada no click no menu de cada tela
    $menuId = isset($_POST["menuId"]) ? $_POST["menuId"] : null;
    if (empty($menuId))
    {
        throw new Exception("O id do menu está vazio!");
    }
    $permissao = SidabiLoginMenu::listarPermissao($_SESSION["usuario_id"], $menuId);
    if (!empty($permissao))
    {
        $tpl->PERMITE_INCLUIR = $permissao[0]["incluir"] ? 'true' : 'false';
        $tpl->PERMITE_EDITAR = $permissao[0]["editar"] ? 'true' : 'false';
        $tpl->PERMITE_EXCLUIR = $permissao[0]["excluir"] ? 'true' : 'false';
        $tpl->PERMITE_VISUALIZAR = $permissao[0]["visualizar"] ? 'true' : 'false';
    }