<?php
include_once '../../../_classes/start.php';
header('Content-Type: application/json; charset=utf-8');

$json = new JSON();
try
{
    $tpl = new Template("../../view/html/relatorioContabilizar.html");

    // carregar os 'tipos de questionários' existentes
    $tipoQuestionario = QuestionarioTipoQuestionario::consultarTipoQuestionario();
    if (!empty($tipoQuestionario)) {
        foreach ($tipoQuestionario as $linha) {
            $tpl->VAR_TIPO_QUESTIONARIO_ID = $linha["id"];
            $tpl->VAR_TIPO_QUESTIONARIO_TITULO = $linha["titulo"];
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

$json->imprimirJSON();