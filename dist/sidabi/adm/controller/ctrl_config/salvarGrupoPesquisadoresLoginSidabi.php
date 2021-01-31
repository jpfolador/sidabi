<?php
include_once '../../../_classes/start.php';

$usuarios           = isset($_POST['usuarios']) ? $_POST['usuarios'] : null;
$grupoPesquisadores = isset($_POST['grupoPesquisadores']) ? $_POST['grupoPesquisadores'] : null;

$json = new JSON();
$retorno = array();

try
{
    if (empty($usuarios)) {
        throw new Exception("Não foi selecionado nenhum usuário.");
    }
    if (empty($grupoPesquisadores)) {
        throw new Exception("Nenhum grupo de pesquisadores foi escolhido.");
    }

    foreach ($grupoPesquisadores as $grupoId)
    {
        // buscar todos os usuarios do grupo
        $usuariosDoGrupo = SidabiGrupoPesquisadoresLogin::consultarUsuariosDoGrupo($grupoId);
        if (!empty($usuariosDoGrupo)) {
            $tempUsuarioGrupo = array();
            foreach ($usuariosDoGrupo as $item) {
                $tempUsuarioGrupo[] = $item["login_fk_id"];
            }
        }else{
            $tempUsuarioGrupo = [];
        }

        // verificar nos usuários passados por param, quais não estão no grupo buscado
        $usuariosParaCadastrar = array_diff($usuarios, $tempUsuarioGrupo);

        if (count($usuariosParaCadastrar) > 0)
        {
            foreach ($usuariosParaCadastrar as $usuarioId)
            {
                // realizar insert de cada usuario no grupo corrente
                $temp = SidabiGrupoPesquisadoresLogin::insert($grupoId, $usuarioId);
                $retorno[] = $temp[0];
            }
        }
    }
    $retorno = implode(",", $retorno);
    $json->setStatus("ok");
    $json->setObjeto( "Usuários associados com sucesso ()." );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();