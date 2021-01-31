<?php
include_once '../../../_classes/start.php';
$json = new JSON();

define('_KB', 1024);
define('_MB', 1048576);
define('_GB', 1073741824);

/*
    Alterar no php.ini do servidor:

    memory_limit = 2048M
    post_max_size = 2048M
    file_uploads = On
    upload_max_filesize = 1024M
    max_input_time = 4000
    max_execution_time = 4000
    session.gc_maxlifetime = 4000
*/

try
{
    if(isset($_FILES))
    {
        if (isset($_FILES['nome_arquivo']))
        {
            if ($_FILES["nome_arquivo"]["size"] > _GB) { // 1 GB
                throw new Exception("O arquivo escolhido é muito grande, escolhe outro com até 1024 MB (1 GB). ");
            }

            $retorno = array();
            $target_dir = "../../files/sessao_arquivos/";

            // Transforma o nome no arquivo para MD5, removendo espaços e ou caracteres estranhos
            $nomeArquivoMd5 = md5(basename( $_FILES["nome_arquivo"]["name"] . time() ));

            $target_file = $target_dir . basename($_FILES["nome_arquivo"]["name"]);
            $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);

            // Concatena novamente a extensão do arquivo no nome em MD5
            $nomeArquivoMd5 .= "." . $imageFileType;
            $target_file = $target_dir . $nomeArquivoMd5;

            $allowedExts = array("edf", "txt", "csv", "xml", "png", "jpg", "zip", "rar", "pdf");
            $temp = explode(".", $_FILES["nome_arquivo"]["name"]);
            $extension = end($temp);

            if ( in_array($extension, $allowedExts) )
            {
                if (file_exists($target_file)) {
                    throw new Exception("O arquivo já existe. ");
                }

                if (move_uploaded_file($_FILES["nome_arquivo"]["tmp_name"], $target_file))
                {
                    $retorno["ok"] = "O arquivo ". $nomeArquivoMd5. " foi carregado com sucesso.";
                    $retorno["file_name"] = $nomeArquivoMd5;

                    $json->setStatus("ok");
                    $json->setObjeto( $retorno );
                }
                else
                {
                    throw new Exception("Desculpe, ocorreu um erro ao mover o arquivo para a pasta de destino.");
                }
            }
            else
            {
                throw new Exception("Arquivo inserido inválido. Arquivos com extensões permitidas: .edf, .txt, .csv, .xml, .png, .jpg, .zip e .rar");
            }
        }
        else
        {
            throw new Exception("Ocorreu um erro ao carregar a variável com o arquivo. Tente atualizar a página e refazer o processo");
        }
    }
    else
    {
        throw new Exception("Nenhum arquivo foi carregado. Tente atualizar a página e refazer o processo.");
    }
}
catch (Exception $ex)
{
    $json->setStatus("erro");
    $json->setMensagem($ex->getMessage());
}

$json->imprimirJSON();