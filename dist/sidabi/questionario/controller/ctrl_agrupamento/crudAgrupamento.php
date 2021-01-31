<?php
header('Content-Type: application/json; charset=utf-8');

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$id = !empty($_POST['agrupamentoId']) ? $_POST['agrupamentoId'] : null;
$descricao = isset($_POST["agrupamentoDescricao"]) ? trim($_POST["agrupamentoDescricao"]) : null;
$ordem = isset($_POST["agrupamentoOrdem"]) ? trim($_POST["agrupamentoOrdem"]) : null;
$status = isset($_POST["agrupamentoStatus"]) ? $_POST["agrupamentoStatus"] : null;
$tipoQuestionario = isset($_POST["tipoQuestionario"]) ? $_POST["tipoQuestionario"] : null;

try {
    if (($operacao === 'add') || ($operacao === 'edit')) {
        if (empty($tipoQuestionario)) {
            throw new Exception("O tipo de questionário não pode ficar vazio.");
        }
        if (empty($descricao)) {
            throw new Exception("A descrição precisa ser informada.");
        }

        if (empty($id)) {
            // add
            try {
                $idResult = QuestionarioAgrupamento::insert($descricao, $ordem, $status, $tipoQuestionario);

                $json->setStatus("ok");
                $json->setObjeto("Registro adicionado com sucesso!");
            } catch (Exception $e) {
                $json->setStatus("erro");
                $json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
            }
        }else{
            // edit
            try {
                $count = QuestionarioAgrupamento::update($id, $descricao, $ordem, $status);
                $json->setStatus("ok");
                $json->setObjeto("Registro atualizado com sucesso!");
            } catch (Exception $e) {
                $json->setStatus("erro");
                $json->setMensagem("Erro ao editar os dados: " . $e->getMessage());
            }
        }
    }

    if ($operacao === 'del') {
        try {
            $msgRetorno = null;
            $questoesAgrupamento = QuestionarioAgrupamento::buscarQuestoesAgrupamento($id);
            if (empty($questoesAgrupamento)) {
                $count = QuestionarioAgrupamento::delete($id);
            }else{
                // remove todas as questões e alternativas do agrupamento passado.
                foreach ($questoesAgrupamento as $item) {
                    $alternativasQuestao = QuestionarioQuestao::buscarAlternativasQuestao($item["questao_id"]);
                    if (empty($alternativasQuestao)) {
                        $msgRetorno = "Não foi possível encontrar a questão. Tente atualizar a página e refazer o processo.";
                    } else {
                        // variável usada para carregar a página
                        $retorno["agrupamento_id"] = $alternativasQuestao[0]["questao_agrupamento_id"];

                        $tipoAplicacaoQuestao = QuestionarioQuestaoTipoAplicacao::buscarTipoAplicacaoQuestao($item["questao_id"]);
                        if (empty($tipoAplicacaoQuestao)) {
                            $msgRetorno = "Questão com problemas ao cadastrar, o tipo de aplicação não foi definido.";
                        } else {
                            // parte comum aos dois 'if' seguintes, por isso deixei aqui.
                            foreach ($tipoAplicacaoQuestao as $item2) {
                                $retorno["questao_tipo_aplicacao"] = QuestionarioQuestaoTipoAplicacao::delete($item2["questao_tipo_aplicacao_id"]);
                            }

                            if ($alternativasQuestao[0]["questao_alternativa_id"] === null) {
                                // Questão sem alternativas
                                $retorno["questao"] = QuestionarioQuestao::delete($questao["id"]);
                            } else {
                                foreach ($alternativasQuestao as $item3) {
                                    $retorno["questao_alternativa"] = QuestionarioQuestaoAlternativa::delete($item3["questao_alternativa_id"]);
                                    $retorno["alternativa"] = QuestionarioAlternativa::delete($item3["alternativa_id"]);
                                }

                                $retorno["questao"] = QuestionarioQuestao::delete($item["questao_id"]);
                            }
                        }
                    }
                }

                $count = QuestionarioAgrupamento::delete($id);
            }

            if (empty($msgRetorno)) {
                $json->setStatus("ok");
                $json->setObjeto($msgRetorno);
            }else{
                throw new Exception($msgRetorno);
            }

        } catch (Exception $e) {
            $json->setStatus("erro");
            $json->setMensagem("Erro ao apagar o registro " . $e->getMessage());
        }
    }
}catch (Exception $e) {
    $json->setStatus("erro");
    $json->setMensagem($e->getMessage());
}

$json->imprimirJSON();