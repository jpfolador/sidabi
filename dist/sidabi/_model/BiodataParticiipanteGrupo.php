<?php

class BiodataParticiipanteGrupo
{
    public static function consultarParticipantePeloGrupoEstudo($grupoId)
    {
        $db = Database::conexao();

        $sql = "select 
                    grupo_estudo_participante.id grupo_estudo_participante_id,
                    grupo_estudo_participante.grupo_estudo_fk_id,
                    grupo_estudo_participante.id_manual,
                    individuo.id participante_id,
                    individuo.nome participante_nome,
                    individuo.telefone2 participante_celular,
                    individuo.email participante_email
                from 
                    biodata.grupo_estudo_participante
                    inner join biodata.grupo_estudo
                            on grupo_estudo.id = grupo_estudo_participante.grupo_estudo_fk_id
                    inner join public.individuo
                            on individuo.id = grupo_estudo_participante.participante_fk_id
                where 
                    grupo_estudo_participante.grupo_estudo_fk_id = $grupoId
                order by 
                    grupo_estudo_participante.id asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro)){
            if (!empty($filtro["grupo_estudo_fk_id"])) {
                $temp .= " and grupo_estudo_participante.grupo_estudo_fk_id = ". $filtro["grupo_estudo_fk_id"];
            }
            if (!empty($filtro["participante_fk_id"])) {
                $temp .= " and grupo_estudo_participante.participante_fk_id = ". $filtro["participante_fk_id"];
            }
            if (!empty($filtro["id_manual"])) {
                $temp .= " and grupo_estudo_participante.id_manual ilike '%". $filtro["id_manual"] . "%'";
            }
        }
        $sql = "select 
                      grupo_estudo_participante.*,
                      grupo_estudo.nome grupo_estudo_nome,
                      individuo.nome participante_nome
                from 
                      biodata.grupo_estudo_participante
                      inner join biodata.grupo_estudo
                              on grupo_estudo.id = grupo_estudo_participante.grupo_estudo_fk_id
                      inner join public.individuo
                              on individuo.id = grupo_estudo_participante.participante_fk_id
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
					from biodata.grupo_estudo_participante";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($grupo_estudo_id, $participante_id, $idManual)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.grupo_estudo_participante 
					values (default, :grupo_estudo_id, :participante_id, :id_manual)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":grupo_estudo_id", $grupo_estudo_id, PDO::PARAM_INT);
        $stmt->bindParam(":participante_id", $participante_id, PDO::PARAM_INT);
        $stmt->bindParam(":id_manual", $idManual, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($grupo_estudo_id, $participante_id, $idManual, $id)
    {
        $db = Database::conexao();

        $sql = "update biodata.grupo_estudo_participante
				   set grupo_estudo_id = :grupo_estudo_id,
					   participante_id = :participante_id,
					   id_manual = :id_manual
				 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":grupo_estudo_id", $grupo_estudo_id, PDO::PARAM_INT);
        $stmt->bindParam(":participante_id", $participante_id, PDO::PARAM_INT);
        $stmt->bindParam(":id_manual", $idManual, PDO::PARAM_STR);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.grupo_estudo_participante
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}