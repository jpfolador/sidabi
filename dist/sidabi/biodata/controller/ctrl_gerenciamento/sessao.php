<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

if (!(isset($_SESSION['usuario']) && $_SESSION['usuario'] != ""))
{
    // não há sessão
    $json->setStatus("redir");
}
else
{
    // login já realizado
    try
    {
        $tpl = new Template("../../view/html/sessao.html");

        // busca permissão de acordo com cada menu clicado e habilita o CRUD definido no BD
        include_once ("./permissaoTela.php");

        $opcoes = "";
        $resultado = BiodataProtocolo::consultarProtocolo();
        if (!empty($resultado)) {
            foreach ($resultado as $linha) {
                $opcoes .= $linha["id"] . ":" . preg_replace("/[\n\r]/","", $linha["nome"]) . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_PROTOCOLO = "'" . $opcoes . "'";

        $opcoes = "";
        $resultado = BiodataGrupoEstudo::consultarGrupoEstudo();
        if (!empty($resultado)) {
            foreach ($resultado as $linha) {
                $opcoes .= $linha["id"] . ":" . preg_replace("/[\n\r]/","", $linha["nome"]) . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_GRUPO_ESTUDO = "'" . $opcoes . "'";

        $opcoes = "";
        $resultado = BiodataEquipamento::consultarEquipamento();
        if (!empty($resultado)) {
            foreach ($resultado as $linha) {
                $opcoes .= $linha["id"] . ":" . preg_replace("/[\n\r]/","", $linha["nome"]) . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_EQUIPAMENTO = "'" . $opcoes . "'";

        $opcoes = "";
        $resultado = PublicIndividuo::consultarParticipante();
        if (!empty($resultado)) {
            foreach ($resultado as $linha) {
                $opcoes .= $linha["id"] . ":" . preg_replace("/[\n\r]/","", $linha["nome"]) . ";";
            }
            $opcoes = substr($opcoes, 0, -1);
        }
        $tpl->OPTIONS_PARTICIPANTE = "'" . $opcoes . "'";

        $opcoes = "";
        $resultado = BiodataSessao::consultarGrupoPesquisadores($_SESSION['usuario_id']);

        if (!empty($resultado)) {
            $listGrupoPesquisadores = '';
            foreach ($resultado as $linha) {
                $listGrupoPesquisadores .= $linha["grupo_pesquisadores_id"] . ":" .  $linha["grupo_pesquisadores_nome"] . ";";
            }
            $listGrupoPesquisadores .= "i:Individual"; //substr($listGrupoPesquisadores, 0, -1);
            
            $tpl->VAR_GRUPO_PESQUISADORES_LISTA = "'". $listGrupoPesquisadores . "'";
        }else{
            $tpl->VAR_GRUPO_PESQUISADORES_LISTA = "'i:Individual'";
        }

        $json->setStatus("ok");
        $json->setObjeto( $tpl->parse() );
    }
    catch (Exception $ex)
    {
        $json->setStatus("erro");
        $json->setMensagem($ex->getMessage());
    }
}

$json->imprimirJSON();