<?php
session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$dadosSessao = array();
$dadosSessao["id"] = !empty($_POST['id']) ? $_POST['id'] : null;
$dadosSessao["nome"] = isset($_POST["nome"]) ? $_POST["nome"] : null;
$dadosSessao["dt_sessao"] = isset($_POST["dt_sessao"]) ? $_POST["dt_sessao"] : null;
$dadosSessao["hora"] = isset($_POST["hora"]) ? $_POST["hora"] : null;
$dadosSessao["medicacao"] = isset($_POST["medicacao"]) ? $_POST["medicacao"] : null;
$dadosSessao["nome_arquivo"] = isset($_POST["nomeArquivo"]) ? $_POST["nomeArquivo"] : null;
$dadosSessao["protocolo_fk_id"] = isset($_POST["protocolo_nome"]) ? $_POST["protocolo_nome"] : null;
$dadosSessao["grupo_estudo_fk_id"] = isset($_POST["grupo_estudo_nome"]) ? $_POST["grupo_estudo_nome"] : null;
$dadosSessao["equipamento_fk_id"] = isset($_POST["equipamento_nome"]) ? $_POST["equipamento_nome"] : null;
$dadosSessao["participante_fk_id"] = isset($_POST["participante_nome"]) ? $_POST["participante_nome"] : null;
$dadosSessao["observacao"] = isset($_POST["observacao"]) ? $_POST["observacao"] : null;
$dadosSessao["usuario_logado"] = $_SESSION["usuario_id"];

// Checkbox com a lista de pesquisadores
$grupoPesquisadores = isset($_POST["grupo_pesquisadores"]) ? $_POST["grupo_pesquisadores"] : null;

if ($operacao == 'add' || $operacao == 'edit') {
    try {
        if (!empty($dadosSessao["dt_sessao"])) {
            $result = DataHora::validarData($dadosSessao["dt_sessao"]);

            if (!$result) {
                throw new InvalidArgumentException("A data da sessão informada não é válida");
            }
        } else {
            throw new InvalidArgumentException("A data da sessão está vazia.");
        }

        if (!empty($dadosSessao["hora"])) {
            $result = DataHora::hora24($dadosSessao["hora"]);

            if (!$result) {
                throw new InvalidArgumentException("A hora da sessão informada não é válida");
            }
        } else {
            throw new InvalidArgumentException("A hora da sessão está vazia.");
        }

        if (empty($grupoPesquisadores)) {
            throw new InvalidArgumentException("É preciso escolher um grupo de pesquisadores.");
        }
    } catch (Exception $e) {
        $json->setStatus("erro");
        $json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
        $json->imprimirJSON();
    }
}

if ($operacao == 'add')
{
    try
    {
        $result = '';
        $idResult = BiodataSessao::insert($dadosSessao);
        if (!empty($idResult)) {
            // insere a tupla de sessao_grupo_pesquisador_login
            if ($grupoPesquisadores != 'i') {
                /**
                 * buscar os registros de grupo_pesquisadores passados por param. e encontrar os ids
                 * relacionados e trazer os ids dos registros da tabela 'grupo_pesquisadores_login'
                 */
                $gpl = SidabiGrupoPesquisadoresLogin::buscarGrupoPesquisadoresLogin($_SESSION["usuario_id"], $grupoPesquisadores);
                if (!empty($gpl)) {
                    $arrayGlpIds = null;
                    foreach ($gpl as $linha) {
                        // pega o ID da tabela grupo_pesquisadores_login dos registros encontrados
                        $arrayGlpIds[] = $linha["id"];
                    }

                    $result = BiodataSessaoGrupoPesquisadoresLogin::insertBatch($idResult, $arrayGlpIds);
                } else {
                    throw new InvalidArgumentException("Usuário não possui grupo de pesquisadores vinculado.");
                }
            }else{
                // se for igual a 'i' o arquivo da sessão será individual sem tuplas da tabela sessao_grupo_pesquisadores_login
            }
        }else{
            throw new InvalidArgumentException("Os dados da sessão não foram criados.");
        }

        $json->setStatus("ok");
        $json->setObjeto( $result );
    }
    catch (Exception $e)
    {
        $json->setStatus("erro");
        $json->setMensagem("Erro ao adicionar os dados: " . $e->getMessage());
    }
}

if ($operacao == 'edit')
{
    try
    {
        if ( !empty( $dadosSessao["id"] )) {
            // apagar os ids de grupo_pesquisadores_login anteriormente gerados
            $result = BiodataSessaoGrupoPesquisadoresLogin::deletePeloSessaoId( $dadosSessao["id"] );

            if ($grupoPesquisadores != 'i') {
                // para os items vindos POR CHECKBOX
                // buscar os ids do grupos_pesquisadores e retornar os registros relacionados em grupo_pesquisadores_login
                $gpl = SidabiGrupoPesquisadoresLogin::buscarGrupoPesquisadoresLogin($_SESSION["usuario_id"], $grupoPesquisadores);
                if (!empty($gpl)) {
                    $arrayGlpIds = null;
                    foreach ($gpl as $linha) {
                        // pega o ID da tabela grupo_pesquisadores_login dos registros encontrados
                        $arrayGlpIds[] = $linha["id"];
                    }
                    $result = BiodataSessaoGrupoPesquisadoresLogin::insertBatch($dadosSessao["id"], $arrayGlpIds);
                } else {
                    throw new InvalidArgumentException("Usuário não possui grupo de pesquisadores vinculado.");
                }
            }else{
                // Se for 'i' é individual, não salvar nada.
            }
            // atualiza os dados da sessao de coleta
            $count = BiodataSessao::update($dadosSessao);
            
        }else{
            throw new InvalidArgumentException("O identificador da sessão não foi passado.");
        }

        $json->setStatus("ok");
        $json->setObjeto( "Registro atualizado com sucesso!" );
    }
    catch (Exception $e)
    {
        $json->setStatus("erro");
        $json->setMensagem("Erro ao editar os dados: " . $e->getMessage());
    }
}

if ($operacao == 'del')
{
    try
    {
        // Procurar o nome do arquivo e apagar o arquivo de coleta
        $resultado = BiodataSessao::consultarSessaoPeloId( $dadosSessao["id"] );
        if (!empty($resultado))
        {
            $nomeArquivo = $resultado[0]["nome_arquivo"];
            $caminho = "../../files/sessao_arquivos/";
            if ($nomeArquivo != null) {
                if (file_exists($caminho . $nomeArquivo)) {
                    unlink($caminho . $nomeArquivo);
                }
            }
        }

        // Apagar os registros da tabela 'sessao_grupo_pesquisadores_login'
        $resultSgpl = BiodataSessaoGrupoPesquisadoresLogin::deletePeloSessaoId( $dadosSessao["id"] );

        // Apagar o registro na tabela
        $count = BiodataSessao::delete($dadosSessao["id"]);

        $json->setStatus("ok");
        $json->setObjeto( "Registros apagado com sucesso!" );
    }
    catch (Exception $e)
    {
        $json->setStatus("erro");
        $json->setMensagem("Erro ao apagar o registro " . $e->getMessage());
    }
}

$json->imprimirJSON();