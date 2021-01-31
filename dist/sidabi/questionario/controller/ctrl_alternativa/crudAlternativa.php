<?php
header('Content-Type: application/json; charset=utf-8');

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];

$alternativa = null;
$alternativa["id"] = !empty($_POST['alternativaId']) ? $_POST['alternativaId'] : null;
$alternativa["questaoId"] = isset($_POST["formAlternativaQuestaoId"]) ? $_POST["formAlternativaQuestaoId"] : null;
$alternativa["alternativaDescricao"] = isset($_POST["alternativaDescricao"]) ? trim($_POST["alternativaDescricao"]) : null;
$alternativa["alternativaOrdem"] = isset($_POST["alternativaOrdem"]) ? trim($_POST["alternativaOrdem"]) : null;
$alternativa["alternativaValor"] = isset($_POST["alternativaValor"]) ? $_POST["alternativaValor"] : '0';
$alternativa["alternativaStatus"] = !empty($_POST["alternativaStatus"]) ? $_POST["alternativaStatus"] : '0';

try {
    if (($operacao === 'add') || ($operacao === 'edit'))
    {
        if (empty($alternativa["questaoId"])) {
            throw new Exception("O identificador da questão não foi carregado, tente atualizar a tela e refazer o processo.");
        }
        if (empty($alternativa["alternativaDescricao"])) {
            throw new Exception("A descrição da alternativa não pode ficar vazio.");
        }
        if (empty($alternativa["alternativaOrdem"])) {
            throw new Exception("A ordem da alternativa não pode ficar vazia.");
        }

        $questao = QuestionarioQuestao::buscarQuestaoPeloId($alternativa["questaoId"]);
        if (empty($questao)) {
            throw new Exception("A questão informada para inserir a alternativa nao existe.");
        }

        if (empty($alternativa["id"])) {
            // aaa
            try {
                $alternativa = QuestionarioAlternativa::insert($alternativa);
                if (!empty($alternativa)) {
                    $questaoAlternativa = QuestionarioQuestaoAlternativa::insert($questao[0]["id"], $alternativa);
                }

                $result["questao_id"] = $questao[0]["id"];
                $result["agrupamento_id"] = $questao[0]["agrupamento_fk_id"];
                $result["alternativa_id"] = $alternativa;
                $result["questao_alternativa_id"] = $questaoAlternativa;

                $json->setStatus("ok");
                $json->setObjeto($result);
            } catch (Exception $e) {
                $json->setStatus("erro");
                $json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
            }
        }else{
            // edit
            try {

                $count = QuestionarioAlternativa::update($alternativa);
                $result["agrupamento_id"] = $questao[0]["agrupamento_fk_id"];

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
            $questaoId = isset($_POST['questaoId']) ? $_POST['questaoId'] : null;
            if (empty($questaoId)) {
                throw new Exception("Questão não passada para identificação");
            }

            $questaoEncontrada = QuestionarioQuestao::buscarQuestaoPeloId($questaoId);
            if (empty($questaoEncontrada)) {
                throw new Exception("Questão não encontrada ao tentar excluir a alternativa");
            }
            $agrupamentoId = $questaoEncontrada[0]["agrupamento_fk_id"];

            // remover o vinculo em questao_alternativa
            $questaoAlternativa = QuestionarioQuestaoAlternativa::consultarTupla($questaoId, $alternativa["id"]);
            if (empty($questaoAlternativa)) {
                throw new Exception("A tupla da questao e alternativa não foi encontrada.");
            }
            $tuplaExcluida = QuestionarioQuestaoAlternativa::delete($questaoAlternativa[0]["id"]);

            // remover alternativa da tabela alternativa
            $count = QuestionarioAlternativa::delete( $alternativa["id"] );

            $retorno["agrupamento_id"] = $agrupamentoId;
            $retorno["msg"] = "Registro apagado com sucesso!";

            $json->setStatus("ok");
            $json->setObjeto($retorno);
        } catch (Exception $e) {
            $msg = $e->getMessage();
            if ($e->getCode() == '23503') {
                $msg = "A alternativa não pode ser excluida. Ela pode estar sendo usada em outro questionário. 
                        Ela foi apenas desvinculada do questionário atual.";
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