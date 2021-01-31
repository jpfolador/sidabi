<?php

include_once '../../../_classes/start.php';
$json = new JSON();

$operacao = $_POST["oper"];
$id = !empty($_POST['id']) ? $_POST['id'] : null;
$descricao = isset($_POST["descricao"]) ? trim($_POST["descricao"]) : null;
$dt_inicio = isset($_POST["dt_inicio"]) ? $_POST["dt_inicio"] : null;
$dt_fim = isset($_POST["dt_fim"]) ? $_POST["dt_fim"] : null;
$comite_etica = isset($_POST["comite_etica"]) ? trim($_POST["comite_etica"]) : null;
$status = isset($_POST["status"]) ? $_POST["status"] : null;
$numero_sessao = isset($_POST["numero_sessao"]) ? $_POST["numero_sessao"] : null;

try {
    if (($operacao == 'add') || ($operacao == 'edit')) {
        if (empty($dt_inicio)) {
            throw new Exception("A data inicial deve ser preenchida!");
        }
        if (empty($dt_fim)) {
            throw new Exception("A data final deve ser preenchida!");
        }

        if (!empty($dt_inicio) && !empty($dt_fim)) {
            $dt_inicio = DateTime::createFromFormat("d/m/Y", $dt_inicio);
            $dt_fim = DateTime::createFromFormat("d/m/Y", $dt_fim);

            if ($dt_inicio > $dt_fim) {
                throw new Exception("A data inicial deve ser menor ou igual a data final!");
            }

            $dt_inicio = !empty($dt_inicio) ? $dt_inicio->format("d/m/Y") : "";
            $dt_fim = !empty($dt_fim) ? $dt_fim->format("d/m/Y") : "";
        }

        if ($operacao == 'add') {
            $idResult = BiodataEstudo::insert($descricao, $dt_inicio, $dt_fim, $comite_etica, $status, $numero_sessao);
            $json->setStatus("ok");
            $json->setObjeto("Registro adicionado com sucesso!");
        }

        if ($operacao == 'edit') {
            $count = BiodataEstudo::update($descricao, $dt_inicio, $dt_fim, $comite_etica, $status, $numero_sessao, $id);
            $json->setStatus("ok");
            $json->setObjeto("Registro atualizado com sucesso!");
        }
    }

    if ($operacao == 'del') {
        $count = BiodataEstudo::delete($id);
        $json->setStatus("ok");
        $json->setObjeto("Registro apagado com sucesso!");
    }
}catch (Exception $e) {
    $json->setStatus("erro");
    $json->setMensagem($e->getMessage());
}

$json->imprimirJSON();