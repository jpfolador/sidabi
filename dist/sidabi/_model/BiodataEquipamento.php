<?php

class BiodataEquipamento
{
    public static function procurarEquipamentoInline($gsSearchParam, $offset, $limit)
    {
        $db = Database::conexao();

        $sql = "select 
                        equipamento.id, 
                        equipamento.nome descricao
                from 
                        biodata.equipamento
                where 
                        equipamento.descricao ilike '%$gsSearchParam%'
                
                order by equipamento.descricao asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarEquipamentoInlineCount($gsSearchParam)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
					from biodata.equipamento
					where equipamento.descricao ilike '%$gsSearchParam%'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function consultarEquipamento()
    {
        $db = Database::conexao();

        $sql = "select *
					from biodata.equipamento
					order by equipamento.descricao asc";

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
            if (!empty($filtro["descricao"])) {
                $temp .= " and equipamento.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["nome"])) {
                $temp .= " and equipamento.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["id"])) {
                $temp .= " and equipamento.id = ". $filtro["id"];
            }
        }

        $sql = "select *
                from biodata.equipamento
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
					from biodata.equipamento";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($descricao, $nome)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.equipamento 
					values (default, :descricao, :nome)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($descricao, $nome, $id)
    {
        $db = Database::conexao();

        $sql = "update biodata.equipamento
					set descricao = :descricao, nome = :nome
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.equipamento
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}