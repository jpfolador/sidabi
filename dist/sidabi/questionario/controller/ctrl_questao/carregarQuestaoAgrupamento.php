<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

$agrupamentoId = !empty($_POST["agrupamentoId"]) ? $_POST["agrupamentoId"] : null;

try
{
    if (empty($agrupamentoId)) {
        throw new Exception("O agrupamento não foi encontrado.");
    }

    $tpl = new Template("../../view/html/questao.html");

    // Buscar todas as questões e alternativas do agrupamento
    $questoes = QuestionarioQuestao::consultarQuestaoPeloAgrupamento($agrupamentoId);

    // Mapea os dados pra facilitar na montagem
    $dados["questoes"] = array();
    if (!empty($questoes)) {
        foreach ($questoes as $linha) {
            if (!array_key_exists($linha["questao_id"], $dados["questoes"])) {
                $dados["questoes"][$linha["questao_id"]] = array(
                    "questao_id" => $linha["questao_id"],
                    "questao_ordem" => $linha["questao_ordem"],
                    "questao_status" => $linha["questao_status"],
                    "questao_titulo" => $linha["questao_titulo"],
                    "questao_descricao" => $linha["questao_descricao"],
                    "questao_instrucao" => $linha["questao_instrucao"],
                    "questao_numero" => $linha["questao_numero"],
                    "questao_contavel" => $linha["questao_contavel"],
                    "tipo_questao_id" => $linha["tipo_questao_id"],
                    "questao_alternativa_id" => $linha["questao_alternativa_id"],
                    "tipo_questao_descricao" => $linha["tipo_questao_descricao"],
                    "questao_tipo_aplicacao_id" => $linha["questao_tipo_aplicacao_id"],
                    "tipo_aplicacao" => array(),
                    "alternativas" => array()
                );
            }

            if ($linha["tipo_aplicacao_id"] != null) {
                if (!array_key_exists($linha["tipo_aplicacao_id"], $dados["questoes"][$linha["questao_id"]]["tipo_aplicacao"])) {
                    $dados["questoes"][$linha["questao_id"]]["tipo_aplicacao"][$linha["tipo_aplicacao_id"]] = array(
                        "tipo_aplicacao_id" => $linha["tipo_aplicacao_id"],
                        "tipo_aplicacao_descricao" => $linha["tipo_aplicacao_descricao"],
                        "tipo_aplicacao_sigla" => $linha["tipo_aplicacao_sigla"]
                    );
                }
            }

            if ($linha["alternativa_id"] != null) {
                if (!array_key_exists($linha["alternativa_id"], $dados["questoes"][$linha["questao_id"]]["alternativas"])) {
                    $dados["questoes"][$linha["questao_id"]]["alternativas"][$linha["alternativa_id"]] = array(
                        "alternativa_id" => $linha["alternativa_id"],
                        "alternativa_descricao" => $linha["alternativa_descricao"],
                        "alternativa_valor" => $linha["alternativa_valor"],
                        "alternativa_ordem" => $linha["alternativa_ordem"],
                        "alternativa_status" => $linha["alternativa_status"]
                    );
                }
            }
        }
    }else{
        $dados = null;
    }

    // Monta a visão das questões e alternativas
    if (!empty($dados)) {
        foreach ($dados["questoes"] as $linha) {
            $tpl->QUESTAO_ID = $linha["questao_id"];
            $tpl->QUESTAO_ORDEM = $linha["questao_ordem"];
            $tpl->QUESTAO_TITULO = $linha["questao_titulo"];
            $tpl->QUESTAO_DESCRICAO = $linha["questao_descricao"];
            $tpl->QUESTAO_INSTRUCAO = $linha["questao_instrucao"];
            $tpl->QUESTAO_NUMERO = $linha["questao_numero"];
            $tpl->QUESTAO_CONTAVEL = $linha["questao_contavel"];
            $tpl->QUESTAO_STATUS = $linha["questao_status"];
            $tpl->TIPO_QUESTAO = $linha["tipo_questao_descricao"];

            $tipoAplicacaoQuestao = null;
            foreach ($linha["tipo_aplicacao"] as $tipoAplicacao) {
                if (!empty($tipoAplicacaoQuestao)) {
                    $tipoAplicacaoQuestao .= ', ';
                }
                $tipoAplicacaoQuestao .= $tipoAplicacao["tipo_aplicacao_descricao"];
            }
            $tpl->QUESTAO_TIPO_APLICACAO = $tipoAplicacaoQuestao;

            if (!empty($linha["alternativas"])) {
                foreach ($linha["alternativas"] as $alternativa) {
                    $tpl->ALTERNATIVA_ID = $alternativa["alternativa_id"];
                    $tpl->ALTERNATIVA_ORDEM = $alternativa["alternativa_ordem"];
                    $tpl->ALTERNATIVA_VALOR = $alternativa["alternativa_valor"];
                    $tpl->ALTERNATIVA_DESCRICAO = $alternativa["alternativa_descricao"];
                    $tpl->block("BLOCO_QUESTAO_ALTERNATIVA");
                }
            }else{
                $tpl->block("BLOCO_QUESTAO_ALTERNATIVA_VAZIA");
            }
            $tpl->block("BLOCO_QUESTAO");
        }
    }else{
        $tpl->block("BLOCO_QUESTAO_VAZI0");
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