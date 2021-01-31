<?php

class BiodataProtocolo
{
    public static function procurarProtocoloInline($gsSearchParam, $offset, $limit)
    {
        $db = Database::conexao();

        $sql = "select 
                        protocolo.id, 
                        protocolo.nome as descricao
                from 
                        biodata.protocolo
                where 
                        protocolo.nome ilike '%$gsSearchParam%'
                
                order by protocolo.nome asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarProtocoloInlineCount($gsSearchParam)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
					from biodata.protocolo
					where protocolo.nome ilike '%$gsSearchParam%'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function consultarProtocolo()
    {
        $db = Database::conexao();

        $sql = "select *
                from biodata.protocolo
                order by protocolo.nome asc";

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
                $temp .= " and protocolo.id = ". $filtro["id"];
            }
            if (!empty($filtro["nome"])) {
                $temp .= " and protocolo.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["descricao"])) {
                $temp .= " and protocolo.descricao ilike '%". $filtro["descricao"]."%'";
            }
        }
        $sql = "select *                     
                from biodata.protocolo
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
					from biodata.protocolo";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($nome, $descricao)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.protocolo 
					values (default, :nome, :descricao)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($nome, $descricao, $id)
    {
        $db = Database::conexao();

        $sql = "update biodata.protocolo
				   set nome = :nome,
				       descricao = :descricao
					   
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.protocolo
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}