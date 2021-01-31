<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

$tipoQuestionarioId = !empty($_POST["tipoQuestionarioId"]) ? $_POST["tipoQuestionarioId"] : null;

try
{
    if (empty($tipoQuestionarioId)) {
        throw new Exception("O tipo de questionário não foi selecionado.");
    }

    $tpl = new Template("../../view/html/agrupamento.html");

    $agrupamento = QuestionarioAgrupamento::consultarAgrupamentosAtivos($tipoQuestionarioId);
    if (!empty($agrupamento)) {
        foreach ($agrupamento as $linha) {
            $tpl->AGRUPAMENTO_ORDEM = $linha["ordem"];
            $tpl->AGRUPAMENTO_DESCRICAO = $linha["descricao"];
            $tpl->AGRUPAMENTO_ID = $linha["agrupamento_id"];
            $tpl->block("BLOCO_AGRUPAMENTO_LINHA");
        }
        $tpl->block("BLOCO_AGRUPAMENTO");
    }else{
        $tpl->block("BLOCO_AGRUPAMENTO_VAZIO");
    }

    // carrega o tipo de questão para o cadastro da questão
    $tipoQuestao = QuestionarioTipoQuestao::consultarTodosRegistros();
    if (!empty($tipoQuestao)) {
        foreach ($tipoQuestao as $linha) {
            $tpl->TIPO_QUESTAO_ID = $linha["id"];
            $tpl->TIPO_QUESTAO_DESCRICAO = $linha["descricao"];
            $tpl->block("BLOCO_OPTION_TIPO_QUESTAO");
        }
    }

    $tipoAplicacao = QuestionarioTipoAplicacao::listarTodosRegistros();
    if (!empty($tipoAplicacao)) {
        foreach ($tipoAplicacao as $linha) {
            $tpl->TIPO_APLICACAO_ID = $linha["id"];
            $tpl->TIPO_APLICACAO_DESCRICAO = trim($linha["descricao"]);
            $tpl->TIPO_APLICACAO_SIGLA = trim($linha["sigla"]);
            $tpl->block("BLOCO_OPTION_TIPO_APLICACAO");
        }
    }

    /*
    $op = '';
    // usuario comum
    $tipoUsuario = 'com';
    $usuario = SidabiLogin::consultarLoginPeloId($_SESSION["usuario_id"]);
    if (!empty($usuario))
    {
        $responsavel = $usuario[0]["id"];

        if ($usuario[0]["administrador"]) {
            $tpl->block("BLOCO_MSG_ADMIN");
            $tipoUsuario = 'adm';
        }
    }

    // $operador de auxilio no sql sobre os checkboxes do grupo de pesquisadores
    if (!empty($grupoPesquisadoresIndividual) && !empty($grupoPesquisadores)) {
        // individual e algum grupo marcados
        $op = 'a';
    }
    if (empty($grupoPesquisadoresIndividual) && empty($grupoPesquisadores)) {
        // nenhum checkbox marcado
        $op = 'n';
    }
    if (!empty($grupoPesquisadoresIndividual) && empty($grupoPesquisadores)) {
        // individual selecionado, nenhum grupo marcado
        $op = 'i';
    }
    if (empty($grupoPesquisadoresIndividual) && !empty($grupoPesquisadores)) {
        // individual não selecionado, algum grupo marcado
        $op = 'g';
    }

    $resultado = BiodataSessao::consultarSessao( $responsavel, $protocolo, $grupoEstudo, $participante,
        $equipamento, $dataInicio, $dataFim, $grupoPesquisadores, $op, $tipoUsuario );
    if (!empty($resultado))
    {
        $tpl->QTD_REGISTRO_ENCONTRADO = count($resultado);
        foreach ($resultado as $linha)
        {
            $tpl->SESSAO_ID = $linha["id"];
            $tpl->RESPONSAVEL = $linha["login_nome"];
            $tpl->DATA_SESSAO = $linha["dt_sessao"];
            $tpl->HORA = $linha["hora"];
            $tpl->PARTICIPANTE = $linha["participante_nome"];
            $tpl->ARQUIVO = $linha["nome_arquivo"];
            $tpl->block("LINHA_ARQUIVO");
        }
        $tpl->block("TABLE_REGISTROS");
    }else{
        $tpl->block("MSG_VAZIO");
    }
    */

    $json->setStatus("ok");
    $json->setObjeto( $tpl->parse() );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();