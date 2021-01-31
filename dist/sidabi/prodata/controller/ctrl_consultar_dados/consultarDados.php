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
        $tpl = new Template("../../view/html/consultarDados.html");

        $opcoes = "";
        $tipoSangue = PublicTipoSangue::consultarTipoSangue();
        if (!empty($tipoSangue)) {
            foreach ($tipoSangue as $linha) {
                $tpl->TIPO_SANGUINEO_OPTION_ID =  $linha["id"];
                $tpl->TIPO_SANGUINEO_OPTION_TEXTO =  $linha["tipo"];
                $tpl->block("BLOCO_TIPO_SANGUINEO_OPTION");
            }
        }

        // Reaproveitando o método da sessao só para buscar os grupos da pessoa logada.
        $resultado = BiodataSessao::consultarGrupoPesquisadores($_SESSION['usuario_id']);
        if (!empty($resultado)) {
            $listGrupoPesquisadores = '';
            foreach ($resultado as $linha) {
                $tpl->GRUPO_PESQUISADOR_ID = $linha["grupo_pesquisadores_id"];
                $tpl->GRUPO_PESQUISADOR_NOME = $linha["grupo_pesquisadores_nome"];
                $tpl->block("BLOCO_CHECKBOX_GRUPO_PESQUISADOR");
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