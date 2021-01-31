<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
include_once '../../../_classes/start.php';

$avaliacaoId				= (!empty($_POST["avaliacaoId"]))			    ? $_POST["avaliacaoId"] : null;
$avaliacaoParticiipanteId 	= (!empty($_POST["avaliacaoParticipanteId"]))	? $_POST["avaliacaoParticipanteId"] : null;
$avaliacaoLocal 			= (!empty($_POST["avaliacaoLocal"]))			? $_POST["avaliacaoLocal"] : null;
$avaliacaoDataAvaliacao 	= (!empty($_POST["avaliacaoDataAvaliacao"]))	? $_POST["avaliacaoDataAvaliacao"] : null;
$avaliacaoInvestigador 	    = (!empty($_POST["avaliacaoInvestigador"]))	    ? $_POST["avaliacaoInvestigador"] : null;
$avaliacaoFontePrimaria 	= (!empty($_POST["avaliacaoFontePrimaria"]))	? $_POST["avaliacaoFontePrimaria"] : null;
$avaliacaoObservacao 	    = (!empty($_POST["avaliacaoObservacao"]))	    ? $_POST["avaliacaoObservacao"] : null;
$avaliacaoMedicamento 	    = (!empty($_POST["avaliacaoMedicamento"]))	    ? $_POST["avaliacaoMedicamento"] : null;
$avaliacaoTipoQuestionario  = (!empty($_POST["avaliacaoTipoQuestionario"]))	? $_POST["avaliacaoTipoQuestionario"] : null;

// Checkbox com a lista de pesquisadores
$grupoPesquisadorIndividual = isset($_POST["grupoPesquisadorIndividual"])   ? $_POST["grupoPesquisadorIndividual"] : null;
$grupoPesquisadores         = isset($_POST["grupoPesquisadores"])           ? $_POST["grupoPesquisadores"] : null;

// pega o usuario logado da sessão
$loginId = $_SESSION['usuario_id'];

if (!empty($avaliacaoDataAvaliacao)) {
    $date = $avaliacaoDataAvaliacao;
    $date = explode("/", $date);
    $date = new DateTime($date[2]."-".$date[1]."-".$date[0]);
    $avaliacaoDataAvaliacao = $date->format('Y-m-d');
}

$retorno = $retornoGrupoPEsq = null;
$json = new JSON();

try
{
    if (empty($avaliacaoParticiipanteId)) {
        throw new Exception("O id do participante/paciente não foi informado");
    }
    if (empty($avaliacaoLocal)) {
        throw new Exception("Informe o local da avaliação.");
    }
    if (empty($avaliacaoDataAvaliacao)) {
        throw new Exception("A data da avaliação não pode ficar vazia.");
    }
    if (empty($avaliacaoInvestigador)) {
        throw new Exception("Informe o nome do investigador.");
    }
    if (empty($avaliacaoFontePrimaria)) {
        throw new Exception("Escolha uma opção para fonte primária.");
    }
    if (empty($avaliacaoMedicamento)) {
        throw new Exception("Informe o medicamento.");
    }
    if (empty($avaliacaoTipoQuestionario)) {
        throw new Exception("O tipo de questionário não pode ficar vazio.");
    }
    if (empty($grupoPesquisadorIndividual) && empty($grupoPesquisadores)) {
        throw new Exception("É preciso informar se a avaliação será compartilhada com algum grupo de pesquisadores ou se permanecerá individual.");
    }

    if ($avaliacaoId != null)
    {
        $dadosAvaliacao = QuestionarioAvaliacao::consultarAvaliacaoPeloId($avaliacaoId);
        if (!empty($dadosAvaliacao))
        {
            $retorno = QuestionarioAvaliacao::update($avaliacaoId, $avaliacaoInvestigador, $avaliacaoParticiipanteId, $avaliacaoDataAvaliacao,
                                                     $avaliacaoFontePrimaria,  $avaliacaoLocal, $avaliacaoMedicamento,
                                                     $avaliacaoObservacao, $loginId, $avaliacaoTipoQuestionario);

            // Apaga as tuplas que já existiam, para inserir as novas, como não será muito usado,
            // é mais simples fazer assim do que controlar quem já estava cadastrado e atualizar.

            $del = QuestionarioAvaliacaoGrupoPesquisadoresLogin::deletePeloAvaliacaoId($avaliacaoId);

            if (!empty($grupoPesquisadores)) {
                /**
                 * buscar os registros de grupo_pesquisadores passados por param. e encontrar os ids
                 * relacionados e trazer os ids dos registros da tabela 'grupo_pesquisadores_login'
                 */
                $gpl = SidabiGrupoPesquisadoresLogin::buscarGrupoPesquisadoresLogin($_SESSION["usuario_id"], $grupoPesquisadores);
                if (!empty($gpl)) {
                    $arrayGlpIds = array();
                    foreach ($gpl as $linha) {
                        // pega o ID da tabela grupo_pesquisadores_login dos registros encontrados
                        $arrayGlpIds[] = $linha["id"];
                    }
                    $retornoGrupoPesq = QuestionarioAvaliacaoGrupoPesquisadoresLogin::insertBatch($avaliacaoId, $arrayGlpIds);
                } else {
                    throw new InvalidArgumentException("Usuário não possui grupo de pesquisadores vinculado.");
                }
            }else{
                // se vazio, a avaliação será individual sem tuplas da tabela sessao_grupo_pesquisadores_login
            }

            $json->setObjeto($avaliacaoId);
        }
    }
    else
    {
        $idInserido = QuestionarioAvaliacao::insert($avaliacaoInvestigador, $avaliacaoParticiipanteId, $avaliacaoDataAvaliacao,
                                                 $avaliacaoFontePrimaria,  $avaliacaoLocal, $avaliacaoMedicamento,
                                                 $avaliacaoObservacao, $loginId, $avaliacaoTipoQuestionario);

        if (!empty($grupoPesquisadores)) {
            /**
             * buscar os registros de grupo_pesquisadores passados por param. e encontrar os ids
             * relacionados e trazer os ids dos registros da tabela 'grupo_pesquisadores_login'
             */
            $gpl = SidabiGrupoPesquisadoresLogin::buscarGrupoPesquisadoresLogin($_SESSION["usuario_id"], $grupoPesquisadores);
            if (!empty($gpl)) {
                $arrayGlpIds = array();
                foreach ($gpl as $linha) {
                    // pega o ID da tabela grupo_pesquisadores_login dos registros encontrados
                    $arrayGlpIds[] = $linha["id"];
                }

                $retornoGrupoPEsq = QuestionarioAvaliacaoGrupoPesquisadoresLogin::insertBatch($idInserido, $arrayGlpIds);
            } else {
                throw new InvalidArgumentException("Usuário não possui grupo de pesquisadores vinculado.");
            }
        }else{
            // se vazio, a avaliação será individual sem tuplas da tabela sessao_grupo_pesquisadores_login
        }

        $json->setObjeto($idInserido);
    }
    $json->setStatus("ok");
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}
$json->imprimirJSON();