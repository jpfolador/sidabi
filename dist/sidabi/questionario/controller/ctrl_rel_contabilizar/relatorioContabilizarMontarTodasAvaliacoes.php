<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include_once '../../../_classes/start.php';
header('Content-Type: application/json; charset=utf-8');

$tipoQuestionarioId = (!empty($_POST["tipoQuestionarioId"])) ? $_POST["tipoQuestionarioId"] : null;
$participanteId = (!empty($_POST["participanteId"])) ? $_POST["participanteId"] : null;
$dataInicio = (!empty($_POST["dataInicio"])) ? $_POST["dataInicio"] : null;
$dataFim = (!empty($_POST["dataFim"])) ? $_POST["dataFim"] : null;

$json = new JSON();

try {
    if (empty($tipoQuestionarioId)) {
        throw new Exception("O tipo de questionário não foi informado.");
    }
    if (empty($participanteId)) {
        throw new Exception("O participante não foi informado.");
    }

    if (!empty($dataInicio) && !empty($dataFim)) {
        $dataInicio = DateTime::createFromFormat("d/m/Y", $dataInicio);
        $dataFim = DateTime::createFromFormat("d/m/Y", $dataFim);

        if ($dataInicio > $dataFim) {
            throw new Exception("A data inicial deve ser menor ou igual a data final!");
        }

        $dataInicio = !empty($dataInicio) ? $dataInicio->format("d/m/Y") : "";
        $dataFim = !empty($dataFim) ? $dataFim->format("d/m/Y") : "";
    }
    if (!empty($dataInicio) && empty($dataFim)) {
        $dataInicio = DateTime::createFromFormat("d/m/Y", $dataInicio);
        $dataInicio = $dataInicio->format("d/m/Y");
    }
    if (empty($dataInicio) && !empty($dataFim)) {
        $dataFim = DateTime::createFromFormat("d/m/Y", $dataFim);
        $dataFim = $dataFim->format("d/m/Y");
    }

    $tpl = new Template("../../view/html/relatorioContabilizarMontarTodasAvaliacoes.html");

    $resposta = QuestionarioResposta::monstarTodasAvaliacoes($tipoQuestionarioId, $participanteId, $dataInicio, $dataFim);

    if (count($resposta) > 0)
    {
        /**
         * Para facilitar a montagem do relatório os dados previamente vão ser distribuidos em vetor
         */

        /**
         * vetor com todos as avaliações obtidos na consulta
         * as quais o índice é o atributo avaliacao.id
         * para garantir a unicidade do questionário respondido
         */
        $avaliacao = array();

        /**
         * Vetor com todas as questoes obtidos na consulta
         * as quais o índice é os atributos questao.id e tipo_aplicacao.id
         * para garantir a unicidade da questao
         */
        $questao_tipo_aplicacao = array();

        /**
         * Vetor com todas as questao/alternativa/resposta obtidos na consulta
         * as quais o índice é os atributos avaliacao.id, questao.id e tipo_aplicacao.id
         * para garantir a unicidade da questao/alternativa/resposta
         */
        $avaliacao_questao_tipo_aplicacao = array();

        // vetor com o VALOR DA RESPOSTA por avaliacao/questao
        $q_valor_alternativa_totalgeral = array();

        // vetor com o SOMA DAS RESPOSTAS por avaliacao/agrupamento
        $qg_valor_alternativa_subtotal = array();

        // vetor com o SOMA DAS RESPOSTAS por avaliacao/questao
        $pta_valor_alternativa_totalgeral = array();

        // vetor com o SOMA DAS RESPOSTAS por agrupamento
        $g_valor_alternativa_totalgeral = array();

        // variável com o SOMAS RESPOSTAS GERAL
        $valor_alternativa_totalgeral = null;

        /**
         * Percorre todos os registros retornados na consulta e distribui previamente em vetores
         */
        foreach ($resposta as $resposta_linha)
        {
            $avaliacao_key = $resposta_linha["avaliacao_id"];
            $agrupamento_key = $resposta_linha["agrupamento_id"];
            $questao_tipo_aplicacao_key = $resposta_linha["questao_id"] . $resposta_linha["tipo_aplicacao_id"];

            if (!array_key_exists($resposta_linha["avaliacao_id"], $avaliacao)) {
                $avaliacao[$resposta_linha["avaliacao_id"]] = $resposta_linha;
            }

            if (!array_key_exists($questao_tipo_aplicacao_key, $questao_tipo_aplicacao)) {
                $questao_tipo_aplicacao[$resposta_linha["questao_id"] . $resposta_linha["tipo_aplicacao_id"]] = $resposta_linha;
            }

            if (!array_key_exists($avaliacao_key . $questao_tipo_aplicacao_key, $avaliacao_questao_tipo_aplicacao)) {
                $avaliacao_questao_tipo_aplicacao[$resposta_linha["avaliacao_id"] . $resposta_linha["questao_id"] . $resposta_linha["tipo_aplicacao_id"]] = $resposta_linha;
            }

            // se questão for contável
            if ($resposta_linha["questao_contavel"]) {

                if (!isset($pta_valor_alternativa_totalgeral[$questao_tipo_aplicacao_key])) {
                    $pta_valor_alternativa_totalgeral[$questao_tipo_aplicacao_key] = (float) $resposta_linha["alternativa_valor"];
                } else {
                    $pta_valor_alternativa_totalgeral[$questao_tipo_aplicacao_key] += (float) $resposta_linha["alternativa_valor"];
                }

                if (!isset($qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamento_key])) {
                    $qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamento_key] = (float) $resposta_linha["alternativa_valor"];
                } else {
                    $qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamento_key] += (float) $resposta_linha["alternativa_valor"];
                }

                if (!isset($q_valor_alternativa_totalgeral[$avaliacao_key])) {
                    $q_valor_alternativa_totalgeral[$avaliacao_key] = (float) $resposta_linha["alternativa_valor"];
                } else {
                    $q_valor_alternativa_totalgeral[$avaliacao_key] += (float) $resposta_linha["alternativa_valor"];
                }

                if (!isset($g_valor_alternativa_totalgeral[$agrupamento_key])) {
                    $g_valor_alternativa_totalgeral[$agrupamento_key] = (float) $resposta_linha["alternativa_valor"];
                } else {
                    $g_valor_alternativa_totalgeral[$agrupamento_key] += (float) $resposta_linha["alternativa_valor"];
                }

                if (empty($valor_alternativa_totalgeral)) {
                    $valor_alternativa_totalgeral = (float) $resposta_linha["alternativa_valor"];
                } else {
                    $valor_alternativa_totalgeral += (float) $resposta_linha["alternativa_valor"];
                }
            }
        }

        if (count($avaliacao) > 0) {

            /**
             * Cria o cabecalho da tabela com as informações de cada questionário
             */
            foreach ($avaliacao as $avaliacao_key => $avaliacao_linha)
            {
                $tpl->TIPO_QUESTIONARIO_TITULO = $avaliacao_linha["tipo_questionario_titulo"];
                $tpl->PARTICIPANTE_NOME = $avaliacao_linha["participante_nome"];
                $tpl->PARTICIPANTE_DT_NASCIMENTO = $avaliacao_linha["participante_data_nascimento"];
                $tpl->DATA_AVALIACAO = $avaliacao_linha["data_avaliacao"];
                $tpl->PARTICIPANTE_SEXO = $avaliacao_linha["participante_sexo"];
                $tpl->PARTICIPANTE_DIAGNOSTICO = $avaliacao_linha["participante_diagnostico"];
            	$tpl->MEDICAMENTO_DIA = $avaliacao_linha["medicamento"];
                $tpl->block("QUESTIONARIO_BLOCK_CABECALHO");
            }

            if (count($questao_tipo_aplicacao) > 0)
            {
                /**
                 * Cria as linhas da tabela com as questões e distribui nas colunas o valor das respostas por avaliação
                 */
                $agrupamentoIdTemp = 0;
                foreach ($questao_tipo_aplicacao as $questao_tipo_aplicacao_key => $questao_tipo_aplicacao_linha)
                {
                    /**
                     * ao mudar de agrupamento cria uma linha com o subtotal do agrupamento anterior
                     */
                    if ($questao_tipo_aplicacao_linha["agrupamento_id"] != $agrupamentoIdTemp)
                    {
                        if (!empty($agrupamentoIdTemp))
                        {
                            /**
                             * percorre todos os questionários para colocar o subtotal 
                             */
                            foreach ($avaliacao as $avaliacao_key => $avaliacao_linha) {
                                /**
                                 * subtotal do agrupamento por questionário
                                 */
                                $tpl->VALOR_ALTERNATIVA_SUBTOTAL = isset($qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamentoIdTemp]) ? $qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamentoIdTemp] : '-';
                                $tpl->block("VALOR_ALTERNATIVA_SUBTOTAL_BLOCK");
                            }

                            /**
                             * soma do total geral do agrupamento listado
                             */
                            $tpl->block("AGRUPAMENTO_SUBTOTAL_BLOCK");
                            $tpl->block("AGRUPAMENTO_BLOCK");
                        }

                        $tpl->ESCORE_COLSPAN = count($avaliacao);
                        $tpl->AGRUPAMENTO_ORDEM = $questao_tipo_aplicacao_linha["agrupamento_ordem"];
                        $tpl->AGRUPAMENTO_DESCRICAO = $questao_tipo_aplicacao_linha["agrupamento_descricao"];
                        $tpl->AGRUPAMENTO_DESCRICAO_COLSPAN = count($avaliacao) + 1;

                        $tpl->block("AGRUPAMENTO_DESCRICAO_BLOCK");

                        $agrupamentoIdTemp = $questao_tipo_aplicacao_linha["agrupamento_id"];
                        $questao_tipo_aplicacao_key_anterior = $questao_tipo_aplicacao_key;
                    }

                    $tpl->NUMERO_QUESTAO = $questao_tipo_aplicacao_linha["agrupamento_ordem"] . "." . $questao_tipo_aplicacao_linha["questao_numero"];

                    $titulo_questao_temp = "";
                    $titulo_questao_temp = $questao_tipo_aplicacao_linha["questao_titulo"];
                    if ($questao_tipo_aplicacao_linha["tipo_aplicacao_id"] != 9) {
                        $titulo_questao_temp .= " - " . mb_strtoupper($questao_tipo_aplicacao_linha["tipo_aplicacao_sigla"],"UTF-8");
                    }

                    $tpl->TITULO_QUESTAO = ucfirst($titulo_questao_temp);

                    /**
                     * percorre todos as avaliações para colocar o valor da resposta por questao
                     */
                    foreach ($avaliacao as $avaliacao_key => $avaliacao_linha)
                    {
                        if (isset($avaliacao_questao_tipo_aplicacao[$avaliacao_key . $questao_tipo_aplicacao_key]))
                            $avaliacao_questao_tipo_aplicacao_linha = $avaliacao_questao_tipo_aplicacao[$avaliacao_key . $questao_tipo_aplicacao_key];

                        $valor_alternativa_temp = "";
                        if ($avaliacao_questao_tipo_aplicacao_linha["questao_contavel"]) {
                            $valor_alternativa_temp = (float) $avaliacao_questao_tipo_aplicacao_linha["alternativa_valor"];
                        } else {
                            if ($avaliacao_questao_tipo_aplicacao_linha['tipo_questao_id'] == 1) {
                                $valor_alternativa_temp = ucfirst($avaliacao_questao_tipo_aplicacao_linha["alternativa_descricao"]);
                            } else {
                                $valor_alternativa_temp = ucfirst($avaliacao_questao_tipo_aplicacao_linha["alternativa_descritiva"]);
                            }
                        }

                        $tpl->VALOR_ALTERNATIVA = $valor_alternativa_temp;

                        $tpl->block("QUESTIONARIO_BLOCK");
                    }

                    /**
                     * total geral da questao
                     */
                    $tpl->block("QUESTAO_TIPO_APLICACAO_BLOCK");
                }

                /**
                 * no final da tabela cria uma linha com o subtotal do último agrupamento e com o total geral
                 * percorre todos os questionários para colocar o subtotal e o total geral  
                 */
                foreach ($avaliacao as $avaliacao_key => $avaliacao_linha) {
                    //subtotal do último agrupamento por questionário
                    $tpl->VALOR_ALTERNATIVA_SUBTOTAL = isset($qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamentoIdTemp]) ? $qg_valor_alternativa_subtotal[$avaliacao_key . $agrupamentoIdTemp] : '&nbsp;';
                    $tpl->block("VALOR_ALTERNATIVA_SUBTOTAL_BLOCK");

                    //total geral por questionário
                    $tpl->VALOR_ALTERNATIVA_TOTALGERAL = isset($q_valor_alternativa_totalgeral[$avaliacao_key]) ? $q_valor_alternativa_totalgeral[$avaliacao_key] : '&nbsp;';
                    $tpl->block("VALOR_ALTERNATIVA_TOTALGERAL_BLOCK");
                }

                /**
                 * soma do total geral 
                 */
                $tpl->block("AGRUPAMENTO_SUBTOTAL_BLOCK");
                
                $tpl->block("AGRUPAMENTO_BLOCK");

                $tpl->block("AGRUPAMENTO_TOTALGERAL_BLOCK");
            }

            $tpl->block("RESPOSTA_BLOCK");
        } else {
            $tpl->block("MSG_VAZIO");
        }
    } else {
        $tpl->block("MSG_VAZIO");
    }

    $json->setStatus("ok");
    $json->setObjeto($tpl->parse());
} catch (Exception $ex) {
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();