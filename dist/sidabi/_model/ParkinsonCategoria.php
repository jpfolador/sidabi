<?php

class ParkinsonCategoria
{
    public static function procurarCategoriaInline($gsSearchParam, $offset, $limit)
    {
        $db = Database::conexao();

        $sql = "select 
                        categoria.id, 
                        categoria.nome, 
                        categoria.ordem,
						categoria.status
                from 
                        parkinson.categoria
                where 
                        categoria.nome ilike '%$gsSearchParam%'
                
                order by categoria.nome asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarCategoriaInlineCount($gsSearchParam)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
                from parkinson.categoria
                where parkinson.nome ilike '%$gsSearchParam%'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function consultarCategoria()
    {
        $db = Database::conexao();

        $sql = "select *
                from parkinson.categoria
                order by nome asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro))
        {
            if (!empty($filtro["status"])) {
                $temp .= " and categoria.status = ". $filtro["status"];
            }
            if (!empty($filtro["nome"])) {
                $temp .= " and categoria.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["ordem"])) {
                $temp .= " and categoria.ordem = ". $filtro["ordem"];
            }
            if (!empty($filtro["id"])) {
                $temp .= " and categoria.id = ". $filtro["id"];
            }
        }

        $sql = "select 
                       id, 
                       nome, 
                       ordem,
					   case when status = true then 
					      'Ativo' 
					   else 
					      'Inativo' 
					   end status
                from 
                      parkinson.categoria
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
					from parkinson.categoria";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($status, $nome, $ordem)
    {
        $db = Database::conexao();

        $sql = "insert into parkinson.categoria 
                values (default, :nome, :status, :ordem)
                returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":ordem", $ordem, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($status, $nome, $id, $ordem)
    {
        $db = Database::conexao();

        $sql = "update parkinson.categoria
                set status = :status, nome = :nome, ordem = :ordem
                where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":ordem", $ordem, PDO::PARAM_INT);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from parkinson.categoria
                where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}