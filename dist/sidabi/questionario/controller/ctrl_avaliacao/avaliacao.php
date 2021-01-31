<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include_once '../../../_classes/start.php';
header('Content-Type: application/json; charset=utf-8');
session_start();
$json = new JSON();

try
{
    $tpl = new Template("../../view/html/avaliacao.html");

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

    // Reaproveitando o método da sessao só para 'buscar os grupos de pesquisadores' da pessoa logada.
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
    $json->setObjeto($tpl->parse());
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();