<?php
header('Content-Type: application/json; charset=utf-8');

session_start();
include_once '../../../_classes/start.php';
$json = new JSON();

$page = $_GET['page'];
$limit = $_GET['rows'];
$sidx = $_GET['sidx'];
$sord = $_GET['sord'];

$_search = $_GET['_search'];
$filtro = array();
$filtro["id"]							= !empty($_GET['id']) ? $_GET['id'] : null;
$filtro["id_manual"]					= !empty($_GET['id_manual']) ? $_GET['id_manual'] : null;
$filtro["protocolo_nome"]				= isset($_GET["protocolo_nome"]) ? $_GET["protocolo_nome"] : null;
$filtro["equipamento_nome"]		        = isset($_GET["equipamento_nome"]) ? $_GET["equipamento_nome"] : null;
$filtro["grupo_estudo_nome"]			= isset($_GET["grupo_estudo_nome"]) ? $_GET["grupo_estudo_nome"] : null;
$filtro["participante_nome"]			= isset($_GET["participante_nome"]) ? $_GET["participante_nome"] : null;
$filtro["data_nascimento_formatada"]	= isset($_GET["data_nascimento_formatada"]) ? $_GET["data_nascimento_formatada"] : null;
$filtro["dt_sessao"]					= isset($_GET["dt_sessao"]) ? $_GET["dt_sessao"] : null;
$filtro["hora"]					        = isset($_GET["hora"]) ? $_GET["hora"] : null;
$filtro["login_nome"]					= isset($_GET["login_nome"]) ? $_GET["login_nome"] : null;
$filtro["usuario_logado"]               = '';

try
{
    // Carregar informações apenas de quem é do grupo de pesquisadores ou responsável pelo arquivo.
    $responsavel = "";
    $usuario = SidabiLogin::consultarLoginPeloId($_SESSION["usuario_id"]);
    if (!empty($usuario))
    {
        if (!$usuario[0]["administrador"])
        {
            $responsavel = $usuario[0]["id"];
            /*
            $gruposComUsuarios = SidabiGrupoPesquisadoresLogin::consultarGruposDoUsuario($_SESSION["usuario_id"]);
            if (!empty($gruposComUsuarios))
            {
                foreach ($gruposComUsuarios as $linha) {
                    $arr = json_decode($linha["usuarios"]);
                    $responsavel .= implode(",", $arr) . ',';
                }
                $responsavel = substr($responsavel, 0, -1);
            }else{
                $responsavel = $_SESSION['usuario_id'];
            }
            */
        }else{
            $responsavel = null;
        }
    }else{
        throw new InvalidArgumentException("Usuário não encontrado.");
    }
    
    $filtro["usuario_logado"] = $responsavel;

    if (!$sidx) $sidx = 1;

    $result = empty($responsavel) ? BiodataSessao::contarTodosRegistros() : BiodataSessao::contarMeusArquivosECompartilhados($responsavel);
    $qtdRegistros = $result[0]['count'];

    if ($qtdRegistros > 0 && $limit > 0) {
        $total_pages = ceil($qtdRegistros / $limit);
    } else {
        $total_pages = 0;
    }

    if ($page > $total_pages) $page = $total_pages;

    $start = $limit*$page - $limit;
    if ($start < 0) $start = 0;

    $result = null;
    $saida = null;
    if ($_search) {
        if (empty($responsavel)) {
            $result = BiodataSessao::consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro);
        }else{
            $result = BiodataSessao::consultarMeusArquivosECompartilhados($sidx, $sord, $start, $limit, $filtro);
        }
    }

    $saida["rows"] = $result;
    $saida["totalrecords"] = "$qtdRegistros";
    $saida["currpage"] = "$page";
    $saida["totalpages"] = "$total_pages";

    $json->setStatus("ok");
    $json->setObjeto( $saida );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();