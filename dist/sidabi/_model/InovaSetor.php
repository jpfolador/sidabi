<?php

class InovaSetor
{
    public static function consultarSetor()
    {
        $db = Database::conexao();

        $sql = "select *
				from inova.setor
				order by setor.nome asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro='')
    {
        $db = Database::conexao();
        $temp = ' where 1=1 ';
        if (!empty($filtro))
        {
            if (!empty($filtro["nome"])) {
                $temp .= " and setor.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["chefe"])) {
                $temp .= " and setor.chefe ilike '%". $filtro["chefe"]."%'";
            }
            if (!empty($filtro["id"])) {
                $temp .= " and setor.id = ". $filtro["id"];
            }
            if (!empty($filtro["ramal"])) {
                $temp .= " and setor.ramal ilike '%". $filtro["ramal"]."%'";
            }
        }

        $sql = "select *
				from inova.setor 
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
				from inova.setor";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($nome, $chefe, $ramal)
    {
        $db = Database::conexao();

        $sql = "insert into inova.setor 
				values (default, :nome, :chefe, :ramal) 
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":chefe", $chefe, PDO::PARAM_STR);
        $stmt->bindParam(":ramal", $ramal, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($nome, $chefe, $ramal, $id)
    {
        $db = Database::conexao();

        $sql = "update inova.setor
				   set nome = :nome,
					   chefe = :chefe,
					   ramal = :ramal
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":chefe", $chefe, PDO::PARAM_STR);
        $stmt->bindParam(":ramal", $ramal, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from inova.setor
				where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}