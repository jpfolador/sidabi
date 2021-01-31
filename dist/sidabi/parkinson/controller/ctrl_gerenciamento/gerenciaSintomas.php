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

        // tela que deve permitir gerenciar o cadastro de sindomas - usar JQGRID
        $tpl = new Template("../../view/html/gerenciaSintomas.html");

        // busca permissão de acordo com cada menu clicado e habilita o CRUD definido no BD
        include_once ("../../../_classes/permissaoTela.php");

        // Monta a itens no campo select chamado 'categoria'
        $opcoes = "";
        $resultado = ParkinsonCategoria::consultarCategoria();
        if (!empty($resultado)) {
            foreach ($resultado as $linha) {
                $opcoes .= $linha["id"] . ":" . $linha["nome"] . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_CATEGORIA = "'" . $opcoes . "'";

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