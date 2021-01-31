<?php

include_once '../../../_classes/start.php';
$json = new JSON();
$nomeArquivo = isset($_POST["nomeArquivo"]) ? $_POST["nomeArquivo"] : null;
$caminho = "../../files/sessao_arquivos/";

try
{
    if ($nomeArquivo != null)
    {
        if (file_exists($caminho . $nomeArquivo))
        {
            unlink($caminho . $nomeArquivo);
            $json->setStatus("ok");
            $json->setObjeto("$nomeArquivo removido!");
        }
        else
        {
            throw new Exception("Arquivo não encontrado");
        }
    }
    else
    {
        throw new Exception("O nome do arquivo não foi passado");
    }
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();