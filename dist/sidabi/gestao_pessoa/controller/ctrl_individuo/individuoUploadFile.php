<?php
    include_once '../../../_classes/start.php';
    $json = new JSON();

try
{
    if(isset($_FILES))
    {
        if (isset($_FILES['foto']))
        {
            $retorno = array();
            $target_dir = $_SERVER["DOCUMENT_ROOT"] . "/sidabi/gestao_pessoa/files/individuos_fotos/";

            // Transforma o nome no arquivo para MD5, removendo espaços e ou caracteres estranhos
            $nomeArquivoMd5 = md5(basename($_FILES["foto"]["name"]));

            $target_file = $target_dir . basename($_FILES["foto"]["name"]);
            $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);

            // Concatena novamente a extensão do arquivo no nome em MD5
            $nomeArquivoMd5 .= "." . $imageFileType;
            $target_file = $target_dir . $nomeArquivoMd5;

            $allowedExts = array("gif", "jpeg", "jpg", "png");
            $temp = explode(".", $_FILES["foto"]["name"]);
            $extension = end($temp);

            if ( (($_FILES["foto"]["type"] == "image/gif")
                 || ($_FILES["foto"]["type"] == "image/jpeg")
                 || ($_FILES["foto"]["type"] == "image/jpg")
                 || ($_FILES["foto"]["type"] == "image/pjpeg")
                 || ($_FILES["foto"]["type"] == "image/x-png")
                 || ($_FILES["foto"]["type"] == "image/png"))
                 && in_array($extension, $allowedExts) )
            {
                if (file_exists($target_file)) {
                    throw new Exception("O arquivo já existe. ");
                }

                if ($_FILES["foto"]["size"] > 2000000) {
                    throw new Exception("O arquivo escolhido é muito grande, escolhe outro menor que 2.0 MB. ");
                }

                if (move_uploaded_file($_FILES["foto"]["tmp_name"], $target_file))
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
                throw new Exception("Arquivo inserido inválido. Arquivos com extensões permitidas: gif, jpeg, jpg e png");
            }
        }
        else
        {
            throw new Exception("Ocorreu um erro ao carregar a variável com a imagem. Tente atualizar a página e refazer o processo");
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