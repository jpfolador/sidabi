<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

try
{
    $tpl = new Template("../../view/html/consultarDadosResultado.html");

    // controle dos checkboxes, individual = i
    $grupoPesquisadoresIndividual = !empty($_POST["chkGrupoPesquisadorIndividual"]) ? $_POST["chkGrupoPesquisadorIndividual"] : null;
    // o grupo pesquisadores conterá os id dos grupos de pesquisadores
    $grupoPesquisadores = !empty($_POST["chkGrupoPesquisador"]) ? implode(",", $_POST["chkGrupoPesquisador"]) : null;

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

    $resultado = ProdataConsultas::consultarDadosSidabi($_POST, $grupoPesquisadores, $op, $tipoUsuario);
    if (!empty($resultado))
    {
        foreach ($resultado as $linha)
        {
            $tpl->ARQUIVO = $linha["arquivo"];
            if ($linha["tipo_dado"] == 'arquivo') {
                if ($linha["arquivo"] == '-') {
                    $tpl->block("BLOCO_INFORMACAO");
                }else{
                    $tpl->block("BLOCO_ARQUIVO_LINK");
                }
            }else{
                $tpl->block("BLOCO_INFORMACAO");
            }
            $tpl->NOME = $linha["individuo_nome"];
            $tpl->IDADE = $linha["idade"];
            $tpl->SEXO = $linha["individuo_sexo"];
            $tpl->DIAGNOSTICO = $linha["diagnostico"];
            $tpl->CIDADE_ESTADO = $linha["cidade_estado"];
            $tpl->DATA_CADASTRO = $linha["data_cadastro"];

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