<?php

class InovaIdealizador
{
    public static function consultarIdealizador()
    {
        $db = Database::conexao();

        $sql = "select *
				from inova.idealizador
				order by idealizador.nome asc";

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
                $temp .= " and idealizador.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["cargo"])) {
                $temp .= " and idealizador.cargo ilike '%". $filtro["cargo"]."%'";
            }
            if (!empty($filtro["id"])) {
                $temp .= " and idealizador.id = ". $filtro["id"];
            }
            if (!empty($filtro["aula"])) {
                $temp .= " and idealizador.aula ilike '%". $filtro["aula"]."%'";
            }
            if (!empty($filtro["desenvolvimento"])) {
                $temp .= " and idealizador.desenvolvimento ilike '%". $filtro["desenvolvimento"]."%'";
            }
            if (!empty($filtro["contato"])) {
                $temp .= " and idealizador.contato ilike '%". $filtro["contato"]."%'";
            }
        }

        $sql = "select *
				from inova.idealizador 
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
				from inova.idealizador";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($nome, $cargo, $aula, $desenvolvimento, $contato)
    {
        $db = Database::conexao();

        $sql = "insert into inova.idealizador
				values (default, :nome, :cargo, :aula, :desenvolvimento, :contato)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":cargo", $cargo, PDO::PARAM_STR);
        $stmt->bindParam(":aula", $aula, PDO::PARAM_STR);
        $stmt->bindParam(":desenvolvimento", $desenvolvimento, PDO::PARAM_STR);
        $stmt->bindParam(":contato", $contato, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($nome, $cargo, $aula, $desenvolvimento, $contato, $id)
    {
        $db = Database::conexao();

        $sql = "update inova.idealizador
				   set nome = :nome,
					   cargo = :cargo,
					   aula = :aula,
					   desenvolvimento = :desenvolvimento,
					   contato = :contato
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":cargo", $cargo, PDO::PARAM_STR);
        $stmt->bindParam(":aula", $aula, PDO::PARAM_STR);
        $stmt->bindParam(":desenvolvimento", $desenvolvimento, PDO::PARAM_STR);
        $stmt->bindParam(":contato", $contato, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from inova.idealizador
				where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}