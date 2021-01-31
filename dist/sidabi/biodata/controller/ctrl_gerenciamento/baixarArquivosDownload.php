<?php
header('Content-Type: application/html; charset=utf-8');
include_once '../../../_classes/start.php';
$json = new JSON();

$sessaoIds = !empty($_POST["sessaoIds"]) ? $_POST["sessaoIds"] : null;

try
{
    if ($sessaoIds == null) {
        throw new Exception("Nenhum registro de arquivo foi selecionado. \n É preciso escolher pelo menos um!");
    }
    $stringSessaoIds = implode(",", $sessaoIds);
    $resultado = BiodataSessao::consultarArquivosParaDownload($stringSessaoIds);
    $file_names = array();
    if (!empty($resultado))
    {
        foreach ($resultado as $linha)
        {
            $file_names[] = $linha["nome_arquivo"];
        }
        $file_path = $_SERVER['DOCUMENT_ROOT'] . '/sidabi/biodata/files/sessao_arquivos/';
        $archive_file_name = "sessaoArquivos_" . time() . ".zip";

        $zip = new ZipArchive();
        $tmp_file = $file_path . $archive_file_name;
        $zip->open($tmp_file, ZipArchive::CREATE);

        foreach ($file_names as $file)
        {
            $download_file = file_get_contents($file_path . $file);
            $zip->addFromString(basename($file), $file_path . $download_file);
        }

        $zip->close();
        header('Content-Type: application/zip');
        header("Content-Disposition: attachment; filename='$archive_file_name'");
        header("Content-Length: " . filesize($tmp_file));

        $json->setStatus("ok");
        $json->setObjeto( "../../files/sessao_arquivos/" . $archive_file_name );
    }
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();