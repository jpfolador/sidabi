<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

$responsavel = !empty($_POST["responsavel"]) ? $_POST["responsavel"] : null;
$protocolo = !empty($_POST["protocolo"]) ? $_POST["protocolo"] : null;
$grupoEstudo = !empty($_POST["grupoEstudo"]) ? $_POST["grupoEstudo"] : null;
$participante = !empty($_POST["participante"]) ? $_POST["participante"] : null;
$equipamento = !empty($_POST["equipamento"]) ? $_POST["equipamento"] : null;
$dataInicio = !empty($_POST["dataInicio"]) ? $_POST["dataInicio"] : null;
$dataFim = !empty($_POST["dataFim"]) ? $_POST["dataFim"] : null;
// controle dos checkboxes, individual = i
$grupoPesquisadoresIndividual = !empty($_POST["grupoPesquisadoresIndividual"]) ? $_POST["grupoPesquisadoresIndividual"] : null;
// o grupo pesquisadores conterá os id dos grupos de pesquisadores
$grupoPesquisadores = !empty($_POST["grupoPesquisadores"]) ? $_POST["grupoPesquisadores"] : null;

try
{
    $tpl = new Template("../../view/html/baixarArquivosConsultar.html");
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
        // individual e algum grupo marcado
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

    $json->setStatus("ok");
    $json->setObjeto( $tpl->parse() );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();