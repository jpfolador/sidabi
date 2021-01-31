<?php

class InovaIdeia
{
    public static function consultarIdeiaPorSetor()
    {
        $db = Database::conexao();

        $sql = "select 
                       count(ideia.id) as qtd_ideia,
                       setor.nome as setor_nome
                from
                       inova.ideia
                       inner join inova.setor
                               on setor.id = ideia.setor_fk_id
                group by
                       setor.nome
                order by
                       setor.nome";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarIdeia()
    {
        $db = Database::conexao();

        $sql = "select *
				from inova.ideia
				order by descricao asc";

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
            if (!empty($filtro["descricao"])) {
                $temp .= " and ideia.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["chaves"])) {
                $temp .= " and ideia.chaves ilike '%". $filtro["chaves"]."%'";
            }
            if (!empty($filtro["id"])) {
                $temp .= " and ideia.id = ". $filtro["id"];
            }
            if (!empty($filtro["setor_nome"])) {
                $temp .= " and ideia.setor_fk_id = ". $filtro["setor_nome"];
            }
            if (!empty($filtro["idealizador_nome"])) {
                $temp .= " and ideia.idealizador_fk_id = ". $filtro["idealizador_nome"];
            }
            if (!empty($filtro["status"])) {
                $temp .= " and ideia.status ilike '%". $filtro["status"] ."%'";
            }
        }

        $sql = "select 
                      ideia.*, 
                      case when setor.nome is null then '-' else setor.nome end setor_nome,
                      case when idealizador.nome is null then '-' else idealizador.nome end idealizador_nome
				from 
				      inova.ideia 
				      left join inova.setor
				              on setor.id = ideia.setor_fk_id
				      left join inova.idealizador
				              on idealizador.id = ideia.idealizador_fk_id
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
				from inova.ideia";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($descricao, $chaves, $setor_fk_id, $idealizador_fk_id, $status)
    {
        $db = Database::conexao();

        $sql = "insert into inova.ideia
				values (default, :descricao, :chaves, :setor_fk_id, :idealizador_fk_id, :status)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":chaves", $chaves, PDO::PARAM_STR);
        $stmt->bindParam(":setor_fk_id", $setor_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":idealizador_fk_id", $idealizador_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":status", $status, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($descricao, $chaves, $setor_fk_id, $idealizador_fk_id, $status, $id)
    {
        $db = Database::conexao();

        $sql = "update inova.ideia
				   set descricao = :descricao,
					   chaves = :chaves,
					   setor_fk_id = :setor_fk_id,
					   idealizador_fk_id = :idealizador_fk_id,
					   status = :status
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":chaves", $chaves, PDO::PARAM_STR);
        $stmt->bindParam(":setor_fk_id", $setor_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":idealizador_fk_id", $idealizador_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":status", $status, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from inova.ideia
				where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}