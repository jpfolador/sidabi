<?php
header('Content-Type: application/json; charset=utf-8');

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$questao = null;
$questao["id"] = !empty($_POST['questaoId']) ? $_POST['questaoId'] : null;
$questao["agrupamentoId"] = isset($_POST["formQuestaoAgrupamentoId"]) ? $_POST["formQuestaoAgrupamentoId"] : null;
$questao["questaoTitulo"] = isset($_POST["questaoTitulo"]) ? trim($_POST["questaoTitulo"]) : null;
$questao["questaoDescricao"] = isset($_POST["questaoDescricao"]) ? trim($_POST["questaoDescricao"]) : null;
$questao["questaoInstrucao"] = isset($_POST["questaoInstrucao"]) ? trim($_POST["questaoInstrucao"]) : null;
$questao["questaoTipoQuestaoId"] = isset($_POST["questaoTipoQuestao"]) ? $_POST["questaoTipoQuestao"] : null;
$questao["questaoOrdem"] = isset($_POST["questaoOrdem"]) ? $_POST["questaoOrdem"] : null;
$questao["questaoContavel"] = !empty($_POST["questaoContavel"]) ? $_POST["questaoContavel"] : '0';
$questao["questaoStatus"] = !empty($_POST["questaoStatus"]) ? $_POST["questaoStatus"] : '0';
$questao["questaoNumero"] = isset($_POST["questaoNumero"]) ? $_POST["questaoNumero"] : null;
$questao["questaoTipoAplicacao"] = isset($_POST["questaoTipoAplicacao"]) ? $_POST["questaoTipoAplicacao"] : null;

try {
    if (($operacao === 'add') || ($operacao === 'edit')) {
        if (empty($questao["agrupamentoId"])) {
            throw new Exception("O identificador do agrupamento não foi carregado, tente atualizar a tela e refazer o processo.");
        }
        if (empty($questao["questaoTipoQuestaoId"])) {
            throw new Exception("O 'tipo da questão' não pode ficar vazio.");
        }
        if (empty($questao["questaoTitulo"])) {
            throw new Exception("O 'título' da questão não pode ficar vazio.");
        }
        if (empty($questao["questaoTipoAplicacao"])) {
            throw new Exception("O 'tipo de aplicação' da questão não pode ficar vazio.");
        }

        $agrupamento = QuestionarioAgrupamento::buscarAgrupamentoPeloId($questao["agrupamentoId"]);
        if (empty($agrupamento)) {
            throw new Exception("O agrupamento informado para inserir a questão nao existe.");
        }

        $result = null;

        if (empty($questao["id"])) {
            try {
                $questaoId = QuestionarioQuestao::insert($questao);
                if (!empty($questaoId)) {
                    $questaoTipoAplicacao = null;
                    foreach ($questao["questaoTipoAplicacao"] as $tipoAplicacaoId) {
                        $questaoTipoAplicacao[] = QuestionarioQuestaoTipoAplicacao::insert($questaoId, $tipoAplicacaoId);
                    }

                    $result["questao_id"] = $questaoId;
                    $result["agrupamento_id"] = $agrupamento[0]["id"];
                    $result["questao_tipo_aplicacao_ids"] = $questaoTipoAplicacao;
                } else {
                    throw new Exception("Erro ao salvar a questão.");
                }
                $json->setStatus("ok");
                $json->setObjeto($result);
            } catch (Exception $e) {
                $json->setStatus("erro");
                $json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
            }
        } else {
            // edit
            try {
                if (empty($questao["id"])) {
                    throw new Exception("O identificador da questão está vazio. Tente atualizar a página e refazer o processo.");
                }

                // apagar os quetao_tipo_aplicacao para a questao e inserir os novos.
                $tipoAplicacaoQuestao = QuestionarioQuestaoTipoAplicacao::buscarTipoAplicacaoQuestao($questao["id"]);
                if (!empty($tipoAplicacaoQuestao)) {
                    foreach ($tipoAplicacaoQuestao as $value) {
                        $resultIdApagado = QuestionarioQuestaoTipoAplicacao::delete($value["questao_tipo_aplicacao_id"]);
                    }
                }

                // inserir novos tipo aplicação passados pelos checkboxes
                foreach ($questao["questaoTipoAplicacao"] as $tipoAplicacaoId) {
                    $questaoTipoAplicacao = QuestionarioQuestaoTipoAplicacao::insert($questao["id"], $tipoAplicacaoId);
                }

                $count = QuestionarioQuestao::update($questao);
                $result["agrupamento_id"] = $agrupamento[0]["id"];

                $json->setStatus("ok");
                $json->setObjeto($result);
            } catch (Exception $e) {
                $json->setStatus("erro");
                $json->setMensagem("Erro ao editar os dados: " . $e->getMessage());
            }
        }
    }
    
    if ($operacao === 'del') {
        try {
            $retorno = array();

            if (empty($questao["id"])) {
                throw new Exception("O identificador da questão não foi carregado. Tente atualizar a página e refazer o processo.");
            }

            $alternativasQuestao = QuestionarioQuestao::buscarAlternativasQuestao( $questao["id"] );
            if (empty($alternativasQuestao)) {
                throw new Exception("Não foi possível encontrar a questão. Tente atualizar a página e refazer o processo.");
            }
            // variável usada para carregar a página
            $retorno["agrupamento_id"] = $alternativasQuestao[0]["questao_agrupamento_id"];

            $tipoAplicacaoQuestao = QuestionarioQuestaoTipoAplicacao::buscarTipoAplicacaoQuestao( $questao["id"] );
            if (empty($tipoAplicacaoQuestao)) {
                throw new Exception("Questão com problemas ao cadastrar, o tipo de aplicação não foi definido.");
            }
            // parte comum aos dois 'if' seguintes, por isso deixei aqui.
            foreach ($tipoAplicacaoQuestao as $item) {
                $retorno["questao_tipo_aplicacao"] = QuestionarioQuestaoTipoAplicacao::delete( $item["questao_tipo_aplicacao_id"] );
            }

            if ($alternativasQuestao[0]["questao_alternativa_id"] === null) {
                // Questão sem alternativas
                $retorno["questao"] = QuestionarioQuestao::delete( $questao["id"] );
            }else{
                foreach ($alternativasQuestao as $item) {
                    $retorno["questao_alternativa"] = QuestionarioQuestaoAlternativa::delete($item["questao_alternativa_id"]);
                    $retorno["alternativa"] = QuestionarioAlternativa::delete($item["alternativa_id"]);
                }

                $retorno["questao"] = QuestionarioQuestao::delete( $questao["id"] );
            }
            $json->setStatus("ok");
            $json->setObjeto($retorno);
        } catch (Exception $e) {
            $msg = $e->getMessage();
            if ($e->getCode() == '23503') {
                $msg = "A questão não pode ser excluida. Ela ou alguma de suas alernativas podem estar sendo usada em outro tipo de questionário. Tente remover as alternativas manualmente.";
            }
            $json->setStatus("erro");
            $json->setMensagem($msg);
        }
    }
}catch (Exception $e) {
    $json->setStatus("erro");
    $json->setMensagem($e->getMessage());
}

$json->imprimirJSON();