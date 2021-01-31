<?php
include_once '../../../_classes/start.php';
$json = new JSON();

$dadosParticipante = array();
$id   = !empty($_POST['id']) ? $_POST['id'] : null;
$numeroRegistro = isset($_POST["numeroRegistro"]) ? $_POST["numeroRegistro"] : null;

try
{
    $resultado = PublicIndividuo::verificarNumeroRegistro($numeroRegistro);
    if (!empty($resultado)) {
        if (!empty($id)) {
            // é edição do registro
            if ($id != $resultado[0]["id"]) {
                throw new Exception("O número de registro editado já existe. Tente outro");
            }
        } else {
            throw new Exception("O número de registro informado já existe. Tente outro");
        }
    }

    $json->setStatus("ok");
    $json->setObjeto( $resultado );
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();