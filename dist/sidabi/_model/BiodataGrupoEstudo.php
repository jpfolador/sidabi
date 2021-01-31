<?php

class BiodataGrupoEstudo
{
    public static function consultarParticipantePorGrupoEstudo()
    {
        $db = Database::conexao();

        $sql = "select 
                       count(sessao.participante_fk_id) as qtd_participante,
                       grupo_estudo.nome as grupo_estudo_nome
                from
                       biodata.sessao
                       inner join biodata.grupo_estudo
                       on biodata.grupo_estudo.id = biodata.sessao.grupo_estudo_fk_id                     
                group by
                       grupo_estudo.nome
                order by
                       grupo_estudo.nome";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarParticipantesPeloGrupoEstudo($grupoEstudoId)
    {
        $db = Database::conexao();

        $sql = "select
                      individuo.id, 
                      individuo.nome
                from
                      public.individuo
                      inner join biodata.grupo_estudo_participante
                              on grupo_estudo_participante.participante_fk_id = individuo.id
                      inner join biodata.grupo_estudo
                              on grupo_estudo.id = grupo_estudo_participante.grupo_estudo_fk_id
                where
                      grupo_estudo.id = $grupoEstudoId
                order by 
                      individuo.nome";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }
    
    public static function procurarGrupoEstudoInline($gsSearchParam, $offset, $limit)
    {
        $db = Database::conexao();

        $sql = "select 
                        grupo_estudo.id, 
                        grupo_estudo.nome as descricao
                from 
                        biodata.grupo_estudo
                where 
                        grupo_estudo.nome ilike '%$gsSearchParam%'
                
                order by grupo_estudo.nome asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarGrupoEstudoInlineCount($gsSearchParam)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
					from biodata.grupo_estudo
					where grupo_estudo.nome ilike '%$gsSearchParam%'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function consultarGrupoEstudo()
    {
        $db = Database::conexao();

        $sql = "select *
					from biodata.grupo_estudo
					order by grupo_estudo.nome asc";

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
                $temp .= " and grupo_estudo.id = ". $filtro["id"];
            }
            /*
            if (!empty($filtro["estudo_descricao"])) {
                $temp .= " and grupo_estudo.estudo_fk_id = ". $filtro["estudo_descricao"];
            }
            */
            if (!empty($filtro["estudo_descricao"])) {
                $temp .= " and estudo.descricao ilike '%" . $filtro["estudo_descricao"] . "%'";
            }
            if (!empty($filtro["nome"])) {
                $temp .= " and grupo_estudo.nome ilike '%". $filtro["nome"]."%'";
            }
            if (!empty($filtro["descricao"])) {
                $temp .= " and grupo_estudo.descricao ilike '%". $filtro["descricao"]."%'";
            }
            if (!empty($filtro["criterio_inclusao"])) {
                $temp .= " and grupo_estudo.criterio_inclusao ilike '%". $filtro["criterio_inclusao"]."%'";
            }
            if (!empty($filtro["criterio_exclusao"])) {
                $temp .= " and grupo_estudo.criterio_exclusao ilike '%". $filtro["criterio_exclusao"]."%'";
            }
        }
        $sql = "select 
                      grupo_estudo.*,
                      estudo.descricao estudo_descricao
                from 
                      biodata.grupo_estudo
                      inner join biodata.estudo
                              on estudo.id = grupo_estudo.estudo_fk_id
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
					from biodata.grupo_estudo";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($estudo_fk_id, $nome, $descricao, $criterio_inclusao, $criterio_exclusao)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.grupo_estudo 
					values (default, :estudo_fk_id, :nome, :descricao, :criterio_inclusao, :criterio_exclusao)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":estudo_fk_id", $estudo_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":criterio_inclusao", $criterio_inclusao, PDO::PARAM_STR);
        $stmt->bindParam(":criterio_exclusao", $criterio_exclusao, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($estudo_fk_id, $nome, $descricao, $criterio_inclusao, $criterio_exclusao, $id)
    {
        $db = Database::conexao();

        $sql = "update biodata.grupo_estudo
				   set estudo_fk_id = :estudo_fk_id,
					   nome = :nome, 
					   descricao = :descricao, 
					   criterio_inclusao = :criterio_inclusao, 
					   criterio_exclusao = :criterio_exclusao
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":estudo_fk_id", $estudo_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
        $stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
        $stmt->bindParam(":criterio_inclusao", $criterio_inclusao, PDO::PARAM_STR);
        $stmt->bindParam(":criterio_exclusao", $criterio_exclusao, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.grupo_estudo
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}