<?php

class SidabiPerfil
{
    public static function consultarPerfil()
    {
        $db = Database::conexao();

        $sql = "select *
                from sidabi.perfil
                order by perfil.descricao asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function contarTodosRegistros()
    {
        $db = Database::conexao();

        $sql = "select count(*) as count
                from sidabi.perfil";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro)){
            if (!empty($filtro["descricao"])) {
                $temp .= " and perfil.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["id"])) {
                $temp .= " and perfil.id = ". $filtro["id"];
            }
        }
        $sql = "select perfil.*
                from sidabi.perfil
                $temp
                order by $sidx $sord 
                limit $limit offset $start";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($descricao)
    {
        $db = Database::conexao();

        $sql = "insert into sidabi.perfil 
                values (default, :descricao)
                returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($id, $descricao)
    {
        $db = Database::conexao();

        $sql = "update sidabi.perfil 
                set descricao = :descricao
                where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from sidabi.perfil 
                where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}