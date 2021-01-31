<?php

include_once '../../../_classes/start.php';
header('Content-Type: application/json; charset=utf-8');

$json = new JSON();

$tipoQuestionarioId = (isset($_POST["tipoQuestionarioId"])) ? $_POST["tipoQuestionarioId"] : null;
$avaliacaoId = (isset($_POST["avaliacaoId"])) ? $_POST["avaliacaoId"] : null;

try {
    if (empty($tipoQuestionarioId)) {
        throw new Exception("O identificador do questionário está vazio. Tente atualizar a página e refazer o processo.");
    }
    if (empty($avaliacaoId)) {
        throw new Exception("O identificador da avaliação está vazio. Tente atualizar a página e refazer o processo.");
    }

    /**
     * MONTAR o questionário
     */
    $tpl = new Template("../../view/html/avaliacaoMontarQuestoes.html");
    $questoesAvaliacao = QuestionarioAvaliacao::montarQuestoesAvaliacao($tipoQuestionarioId);

    $alternativaIdAnterior = 0;
    $questaoIdAnterior = 0;
    $agrupamentoIdTemp = 0;
    $sinalizaQtdTh = 0;
    $contAgrupamento = 1;

    foreach ($questoesAvaliacao as $key => $linha)
    {
        // Se o agrupamento for diferente, mostra a descrição do novo agrupamento
        if ($linha["agrupamento_id"] != $agrupamentoIdTemp)
        {
            $tpl->AGRUPAMENTO_DESCRICAO = $linha["agrupamento_descricao"];
            $tpl->AGRUPAMENTO_ORDEM = $linha["agrupamento_ordem"];
            $agrupamentoIdTemp = $linha["agrupamento_id"];

            $tpl->block("BLOCO_AGRUPAMENTO_DESCRICAO");
        }

        // se a pergunta mudou, cria o cabeçalho da pergunta
        if ($linha["questao_id"] != $questaoIdAnterior)
        {
            $tpl->AGRUPAMENTO_ORDEM = $linha["agrupamento_ordem"];
            $tpl->QUESTAO_NUMERO = $linha["questao_numero"];
            $tpl->QUESTAO_TITULO = $linha["questao_titulo"];
            $tpl->QUESTAO_DESCRICAO = $linha["questao_descricao"];
            $tpl->QUESTAO_INSTRUCAO = $linha["questao_instrucao"];
            $questaoIdAnterior = $linha["questao_id"];
            $tpl->block("BLOCO_PERGUNTA");
        }

        if ($linha["qtd_tipo_aplicacao"] == 1)
        {
            $questaoTipoAplicacao = QuestionarioQuestaoTipoAplicacao::buscarAssociacaoCadastrada( $linha["questao_id"] );
            if (!empty($questaoTipoAplicacao))
            {
                $tpl->ALTERNATIVA_DESCRICAO = $linha["questao_contavel"] == true ? $linha["alternativa_valor"] . ': ' . $linha["alternativa_descricao"] : $linha["alternativa_descricao"];

                $tpl->ALTERNATIVA_ID = $linha["alternativa_id"];
                $tpl->TIPO_APLICACAO_ID = $questaoTipoAplicacao[0]["tipo_aplicacao_id"];
                $tpl->QUESTAO_ID = $linha["questao_id"];

                if ($linha["tipo_questao_id"] == 1) {
                    // multipla escolha
                    $tpl->block("BLOCO_ALTERNATIVA_MULTIPLA_ESCOLHA_UMA_APLICACAO");
                }elseif ($linha["tipo_questao_id"] == 2) {
                    // text curto
                    $tpl->block("BLOCO_ALTERNATIVA_TEXTO_CURTO");
                }else{
                    // texto longo
                    $tpl->block("BLOCO_ALTERNATIVA_TEXTO_LONGO");
                }
            }
            else
            {
                throw new Exception("'Questão e tipo aplicação' parece não ter sido associada.");
            }
        }
        else
        {
            $questaoTipoAplicacao = QuestionarioQuestaoTipoAplicacao::buscarAssociacaoCadastrada( $linha["questao_id"] );
            if (!empty($questaoTipoAplicacao))
            {
                $flagFirst = 1;
                foreach ($questaoTipoAplicacao as $linhaQta)
                {
                    if ($sinalizaQtdTh < $linha["qtd_tipo_aplicacao"] )
                    {
                        $tpl->TH_SIGLA = !empty($linhaQta["tipo_aplicacao_sigla"]) ? $linhaQta["tipo_aplicacao_sigla"] : $linhaQta["tipo_aplicacao_descricao"];
                        $tpl->TH_TITLE = $linhaQta["tipo_aplicacao_descricao"];
                        $tpl->block("TH_TIPO_APLICACAO_SIGLA");
                        $sinalizaQtdTh++;
                    }

                    if ($flagFirst) {
                        $tpl->ALTERNATIVA_DESCRICAO = $linha["questao_contavel"] == true ? $linha["alternativa_valor"] . ': ' . $linha["alternativa_descricao"] : $linha["alternativa_descricao"];
                        $flagFirst = 0;
                    }

                    $tpl->ALTERNATIVA_ID = $linha["alternativa_id"];
                    $tpl->TIPO_APLICACAO_ID = $linhaQta["tipo_aplicacao_id"];
                    $tpl->QUESTAO_ID = $linha["questao_id"];

                    $tpl->block("TD_INPUT_ALTERNATIVA_MULTI");
                }
                $tpl->block("TR_ALTERNATIVA_MULTI");

                // se a próxima questão for diferente, fecha o bloco da questão, pois vai começar outra pergunta
                if ( isset($questoesAvaliacao[$key+1]) )
                {
                    if ($linha["questao_id"] != $questoesAvaliacao[$key+1]["questao_id"])
                    {
                        $tpl->block("BLOCO_ALTERNATIVA_MULTIPLA_ESCOLHA_MULTIPLA_APLICACAO");
                        $sinalizaQtdTh = 0;
                    }
                }else{
                    $tpl->block("BLOCO_ALTERNATIVA_MULTIPLA_ESCOLHA_MULTIPLA_APLICACAO");
                    $sinalizaQtdTh = 0;
                }
            }
            else
            {
                throw new Exception("Multiplas 'Questões e tipo de aplicação' parece não ter sido associadas.");
            }
        }

        if ( isset($questoesAvaliacao[$key+1]) )
        {
            if ($linha["questao_id"] != $questoesAvaliacao[$key+1]["questao_id"])
            {
                $tpl->block("BLOCO_QUESTAO");
            }
        }
        else
        {
            $tpl->block("BLOCO_QUESTAO");
        }

        if ( isset($questoesAvaliacao[$key+1]) )
        {
            if ($linha["agrupamento_id"] != $questoesAvaliacao[$key+1]["agrupamento_id"])
            {
                $tpl->block("CONTAINER_AGRUPAMENTO");
            }
        }
        else
        {
            $tpl->block("CONTAINER_AGRUPAMENTO");
        }
    }

    $avaliacaoEstaFinalizada = QuestionarioAvaliacao::avaliacaoEstaFinalizada($avaliacaoId);

    if ($avaliacaoEstaFinalizada) {
        $tpl->block("BLOCO_AVALIACAO_FINALIZADA");
    }else{
        $tpl->block("BLOCO_BTN_SALVAR");
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