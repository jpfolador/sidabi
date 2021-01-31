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
        $tpl = new Template("../../view/html/criarQuestionario.html");

        // busca permissão de acordo com cada menu clicado e habilita o CRUD definido no BD
        //include_once ("./permissaoTela.php");

        // carregar os tipos de questionários existentes
        $tipoQuestionario = QuestionarioTipoQuestionario::consultarTipoQuestionario();
        if (!empty($tipoQuestionario)) {
            foreach ($tipoQuestionario as $linha) {
                $tpl->TIPO_QUESTIONARIO_ID = $linha["id"];
                $tpl->TIPO_QUESTIONARIO_TITULO = $linha["titulo"];
                $tpl->block("BLOCO_TIPO_QUESTIONARIO_OPTION");
            }
        }else{
            $tpl->block("BLOCO_TIPO_QUESTIONARIO_VAZIO");
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