<?php

/**
 * Created by PhpStorm.
 * User: Joao
 * Date: 17/04/2019
 * Time: 08:45
 */
class SidabiGrupoPesquisadores
{
    public static function consultarGrupoPesquisadores()
    {
        $db = Database::conexao();

        $sql = "select *
                from sidabi.grupo_pesquisadores
                order by grupo_pesquisadores.nome asc";

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
            if (!empty($filtro["id"])) {
                $temp .= " and grupo_pesquisadores.id = ". $filtro["id"];
            }
            if (!empty($filtro["nome"])) {
                $temp .= " and grupo_pesquisadores.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["descricao"])) {
                $temp .= " and grupo_pesquisadores.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["status"])) {
                $temp .= " and grupo_pesquisadores.status = ". $filtro["status"];
            }
        }
        $sql = "select 
                      grupo_pesquisadores.id, 
                      grupo_pesquisadores.nome, 
                      grupo_pesquisadores.descricao, 
					  case when grupo_pesquisadores.status is true then 
					    'ativo' 
					  else 
					    'inativo' 
					  end status
					  
					from sidabi.grupo_pesquisadores
					
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
					from sidabi.grupo_pesquisadores";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($nome, $descricao, $status)
    {
        $db = Database::conexao();

        $sql = "insert into sidabi.grupo_pesquisadores 
                values (default, :nome, :descricao, :status)
                returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($nome, $descricao, $status, $id)
    {
        $db = Database::conexao();

        $sql = "update sidabi.grupo_pesquisadores 
				   set nome = :nome, 
					   descricao = :descricao, 
					   status = :status
                 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from sidabi.grupo_pesquisadores 
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}