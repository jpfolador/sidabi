<?php
include_once '../../../_classes/start.php';
header('Content-Type: application/json; charset=utf-8');

$json = new JSON();

try
{
    $tpl = new Template("../../view/html/listaSintomas.html");

    $result = ParkinsonSintoma::listarSintomas();
    if (!empty($result))
    {
        $categoriaAnterior = null;
        foreach ($result as $item)
        {
            if ($item["categoria_id"] != $categoriaAnterior) {
                $tpl->NOME_CATEGORIA = $item["nome"];
                $categoriaAnterior = $item["categoria_id"];
                $tpl->block("BLOCO_CATEGORIA");
            }
            
            $tpl->TITULO = $item["titulo"];
            $tpl->DESCRICAO_SINTOMA = $item["descricao"];
            $tpl->URL_INFORMACAO = $item["url_informacao"];
            $tpl->CAMINHO_VIDEO = $item["caminho_video"];
            $tpl->block("BLOCO_SINTOMA");
        }
    }
    else
    {
        $tpl->block("MSG_VAZIO");
    }

    $json->setStatus("ok");
    $json->setObjeto($tpl->parse());
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();