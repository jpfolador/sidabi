<?php

/**
 * Created by PhpStorm.
 * User: Joao
 * Date: 11/09/2017
 * Time: 21:48
 */
class BiodataEstudo
{

    public static function consultarEstudo()
    {
        $db = Database::conexao();

        $sql = "select *
					from biodata.estudo
					order by estudo.descricao asc";

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
                $temp .= " and estudo.id = ". $filtro["id"];
            }
            if (!empty($filtro["descricao"])) {
                $temp .= " and estudo.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["dt_inicio"])) {
                $temp .= " and to_char(estudo.dt_inicio, 'dd/mm/YYYY') ilike '%". $filtro["dt_inicio"] . "%'";
            }
            if (!empty($filtro["dt_fim"])) {
                $temp .= " and to_char(estudo.dt_fim, 'dd/mm/YYYY') ilike '%". $filtro["dt_fim"] . "%'";
            }
            if (!empty($filtro["comite_etica"])) {
                $temp .= " and estudo.comite_etica ilike '%". $filtro["comite_etica"]."%'";
            }
            if (!empty($filtro["status"])) {
                $temp .= " and estudo.status ilike '%". $filtro["status"]."%'";
            }
            if (!empty($filtro["numero_sessao"])) {
                $temp .= " and estudo.numero_sessao = ". $filtro["numero_sessao"];
            }
        }
        $sql = "select 
                      estudo.id,
                      estudo.descricao,
                      to_char(estudo.dt_inicio, 'dd/mm/YYYY') as dt_inicio,
                      to_char(estudo.dt_fim, 'dd/mm/YYYY') as dt_fim,
                      estudo.comite_etica,
                      estudo.status,
                      estudo.numero_sessao                        
                from biodata.estudo
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
					from biodata.estudo";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($descricao, $dt_inicio, $dt_fim, $comite_etica, $status, $numero_sessao)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.estudo 
					values (default, :descricao, :dt_inicio, :dt_fim, :comite_etica, :status, :numero_sessao)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":dt_inicio", $dt_inicio, PDO::PARAM_STR);
        $stmt->bindParam(":dt_fim", $dt_fim, PDO::PARAM_STR);
        $stmt->bindParam(":comite_etica", $comite_etica, PDO::PARAM_STR);
        $stmt->bindParam(":status", $status, PDO::PARAM_STR);
        $stmt->bindParam(":numero_sessao", $numero_sessao, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($descricao, $dt_inicio, $dt_fim, $comite_etica, $status, $numero_sessao, $id)
    {
        $db = Database::conexao();

        $sql = "update biodata.estudo
				   set descricao = :descricao,
					   dt_inicio = :dt_inicio, 
					      dt_fim = :dt_fim, 
					comite_etica = :comite_etica, 
					      status = :status, 
				   numero_sessao = :numero_sessao
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":dt_inicio", $dt_inicio, PDO::PARAM_STR);
        $stmt->bindParam(":dt_fim", $dt_fim, PDO::PARAM_STR);
        $stmt->bindParam(":comite_etica", $comite_etica, PDO::PARAM_STR);
        $stmt->bindParam(":status", $status, PDO::PARAM_STR);
        $stmt->bindParam(":numero_sessao", $numero_sessao, PDO::PARAM_INT);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.estudo
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}