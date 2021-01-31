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
        $tpl = new Template("../../view/html/baixarArquivos.html");
        $usuário = SidabiLogin::consultarLoginPeloId($_SESSION["usuario_id"]);
        if (!empty($usuário))
        {
            if ($usuário[0]["administrador"]) {
                $tpl->block("BLOCO_RESPONSAVEL");
            }
        }

        $resultado = BiodataSessao::consultarGrupoPesquisadores($_SESSION['usuario_id']);
        if (!empty($resultado)) {
            $listGrupoPesquisadores = '';
            foreach ($resultado as $linha) {
                $tpl->GRUPO_PESQUISADOR_ID = $linha["grupo_pesquisadores_id"];
                $tpl->GRUPO_PESQUISADOR_NOME = $linha["grupo_pesquisadores_nome"];
                $tpl->block("BLOCO_CHECKBOX_GRUPO_PESQUISADOR");
            }
        }
        // busca permissão de acordo com cada menu clicado e habilita o CRUD definido no BD
        //include_once ("./permissaoTela.php");

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