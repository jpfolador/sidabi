<?php

class ParkinsonSintoma
{
    /**
     * Função usada na tela de Sintomas, deve carregar todos os sintomas cadastrados na base
     * @return array bidimensional com os dados 
     */
    public static function listarSintomas()
    {
        $db = Database::conexao();
        $sql = "select 
                       sintoma.id sintoma_id,
                       sintoma.titulo,
                       sintoma.descricao,
                       sintoma.caminho_video,
                       sintoma.url_informacao,
                       categoria.id categoria_id,
                       categoria.nome,
                       categoria.status
                from 
                       parkinson.sintoma
                       inner join parkinson.categoria
                               on categoria.id = sintoma.categoria_fk_id
                where 
                       categoria.status is true
                order by               
                       categoria.ordem, sintoma.titulo";
        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarSintomaPelaCategoria($categoriaId)
    {
        $db = Database::conexao();

        $sql = "select
                      sintoma.id, 
                      sintoma.titulo
                from
                      parkinson.sintoma
                      inner join parkinson.categoria
                              on categoria.id = sintoma.categoria_fk_id
                where
                      categoria.id = $categoriaId
                order by 
                      sintoma.titulo";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }
    
    public static function procurarSintomaInline($gsSearchParam, $offset, $limit)
    {
        $db = Database::conexao();

        $sql = "select 
                        sintoma.id, 
                        sintoma.titulo
                from 
                        parkinson.sintoma
                where 
                        sintoma.titulo ilike '%$gsSearchParam%'
                
                order by sintoma.titulo asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarSintomaInlineCount($gsSearchParam)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
                from parkinson.sintoma
                where parkinson.titulo ilike '%$gsSearchParam%'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function consultarSintoma()
    {
        $db = Database::conexao();

        $sql = "select *
                from parkinson.sintoma
                order by sintoma.titulo asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro)){
            if (!empty($filtro["id"])) {
                $temp .= " and sintoma.id = ". $filtro["id"];
            }
            if (!empty($filtro["categoria_nome"])) {
                $temp .= " and sintoma.categoria_fk_id = ". $filtro["categoria_nome"];
            }
            if (!empty($filtro["titulo"])) {
                $temp .= " and sintoma.titulo ilike '%". $filtro["titulo"]."%'";
            }
            if (!empty($filtro["descricao"])) {
                $temp .= " and sintoma.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["caminho_video"])) {
                $temp .= " and sintoma.caminho_video ilike '%". $filtro["caminho_video"]."%'";
            }
            if (!empty($filtro["url_informacao"])) {
                $temp .= " and sintoma.url_informacao ilike '%". $filtro["url_informacao"]."%'";
            }
        }
        $sql = "select 
                      sintoma.*,
                      categoria.nome categoria_nome
                from 
                      parkinson.sintoma
                      inner join parkinson.categoria
                              on categoria.id = sintoma.categoria_fk_id
                $temp
                order by $sidx $sord 
                limit $limit offset $start";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function contarTodosRegistros()
    {
        $db = Database::conexao();

        $sql = "select count(*) as count
                from parkinson.sintoma";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($categoria_fk_id, $titulo, $descricao, $caminho_video, $url_informacao)
    {
        $db = Database::conexao();

        $sql = "insert into parkinson.sintoma 
					values (default, :titulo, :descricao, :caminho_video, :categoria_fk_id,:url_informacao)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":categoria_fk_id", $categoria_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":titulo", $titulo, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":caminho_video", $caminho_video, PDO::PARAM_STR);
        $stmt->bindParam(":url_informacao", $url_informacao, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($categoria_fk_id, $titulo, $descricao, $caminho_video, $url_informacao, $id)
    {
        $db = Database::conexao();

        $sql = "update parkinson.sintoma
				   set categoria_fk_id = :categoria_fk_id,
					   titulo = :titulo, 
					   descricao = :descricao, 
					   caminho_video = :caminho_video, 
					   url_informacao = :url_informacao
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":categoria_fk_id", $categoria_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":titulo", $titulo, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":caminho_video", $caminho_video, PDO::PARAM_STR);
        $stmt->bindParam(":url_informacao", $url_informacao, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from parkinson.sintoma
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}