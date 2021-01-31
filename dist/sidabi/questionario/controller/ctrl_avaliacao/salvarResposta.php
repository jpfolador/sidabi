<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$loginId = !empty($_SESSION["usuario_id"]) ? $_SESSION["usuario_id"] : null;
$tipoQuestionarioId = isset($_POST["tipoQuestionarioId"]) ? $_POST["tipoQuestionarioId"] : null;
$avaliacaoId = isset($_POST["avaliacaoId"]) ? $_POST["avaliacaoId"] : null;
$questaoId = isset($_POST["questaoId"]) ? $_POST["questaoId"] : null;
$tipoAplicacaoId = isset($_POST["tipoAplicacaoId"]) ? $_POST["tipoAplicacaoId"] : null;
$alternativaId = isset($_POST["alternativaId"]) ? $_POST["alternativaId"] : null;
$textoQuestaoDescritiva = !empty($_POST["textoQuestaoDescritiva"]) ? $_POST["textoQuestaoDescritiva"] : null;

$json = new JSON();

try
{
    if (empty($loginId)) {
        throw new Exception("O usuário logado parece não estar ativo. Tente atualizar a página e refazer o processo.");
    }
    if (empty($tipoQuestionarioId)) {
        throw new Exception("O identificador do tipo do questionário não pode ficar vazio.");
    }
    if (empty($avaliacaoId)) {
        throw new Exception("O identificador da avaliação não pode ficar vazio.");
    }
    if (empty($questaoId)) {
        throw new Exception("A questão não pode ficar vazia.");
    }
    if (empty($tipoAplicacaoId)) {
        throw new Exception("O tipo de aplicação não foi informado.");
    }
    if (empty($alternativaId)) {
        throw new Exception("A alternativa não foi informada.");
    }

    // Busca a resposta exitente, e apaga
    $respostaExistente = QuestionarioResposta::verificarRespostaExistente($tipoQuestionarioId, $avaliacaoId, $questaoId, $tipoAplicacaoId, $alternativaId);
    if (!empty($respostaExistente))
    {
        foreach ($respostaExistente as $linha)
        {
            $respostaApagada = QuestionarioResposta::delete( $linha["id"] );
        }
    }

    // Salva a nova opção escolhida
    $dataRegistro = date("Y-m-d");
    $retorno = QuestionarioResposta::insert($avaliacaoId, $tipoQuestionarioId, $alternativaId, $tipoAplicacaoId,
                                            $loginId, $dataRegistro, $textoQuestaoDescritiva, $questaoId);

    $json->setStatus("ok");
    $json->setObjeto("Resposta salva com sucesso - " . $retorno);
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();