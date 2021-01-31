<?php

class ProdataAvaliaTremor
{

	public static function consultarAvaliaTremorPeloId($avaliaTremorId)
	{
		$db = Database::conexao();
	
		$sql = "select *
				from prodata.avalia_tremor
				where id = $avaliaTremorId";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro='')
	{
		$db = Database::conexao();
		$temp = 'where 1=1';
		if (!empty($filtro)){
			if (!empty($filtro["individuoId"] )) {
				$temp .= " and avalia_tremor.individuo_fk_id = ". $filtro["individuoId"];
			}
            if (!empty($filtro["data"])) {
                $temp .= " and to_char(avalia_tremor.data_hora, 'dd/MM/YYYY') ilike '%". $filtro["data"]."%'";
            }
			if (!empty($filtro["individuo_nome"])) {
				$temp .= " and individuo.nome ilike '%". $filtro["individuo_nome"]."%'";
			}
			if (!empty($filtro["tipo_desenho"])) {
				$temp .= " and avalia_tremor.tipo_desenho ilike '%". $filtro["tipo_desenho"]."%'";
			}
			if (!empty($filtro["desenho"])) {
				$temp .= " and avalia_tremor.desenho ilike '%". $filtro["desenho"]."%'";
			}
			if (!empty($filtro["classificador"])) {
				$temp .= " and avalia_tremor.classificador ilike '%". $filtro["classificador"]."%'";
			}
            if (!empty($filtro["proba_saudavel"])) {
                $temp .= " and avalia_tremor.proba_saudavel ilike '%". $filtro["proba_saudavel"]."%'";
            }
            if (!empty($filtro["proba_tremor"])) {
                $temp .= " and avalia_tremor.proba_tremor ilike '%". $filtro["proba_tremor"]."%'";
            }
            if (!empty($filtro["data_hora"])) {
                $temp .= " and avalia_tremor.data_hora ilike '%". $filtro["data_hora"]."%'";
            }
            if (!empty($filtro["observacao"])) {
                $temp .= " and avalia_tremor.observacao ilike '%". $filtro["observacao"]."%'";
            }
			if (!empty($filtro["id"])) {
				$temp .= " and avalia_tremor.id = ". $filtro["id"];
			}

		}

		$sql = "select 
                    avalia_tremor.id,
                    avalia_tremor.individuo_fk_id,
                    avalia_tremor.tipo_desenho,
                    avalia_tremor.desenho,
                    avalia_tremor.classificador,
                    to_char(avalia_tremor.proba_saudavel::real, '999D99') || ' %' as proba_saudavel,
                    to_char(avalia_tremor.proba_tremor::real, '999D99') || ' %' as proba_tremor,
                    to_char(avalia_tremor.data_hora, 'dd/MM/YYYY HH24:MI') as data_hora,
                    avalia_tremor.observacao,
                    individuo.nome as individuo_nome
				from prodata.avalia_tremor
				    join public.individuo
				    on individuo.id = avalia_tremor.individuo_fk_id
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
				from prodata.avalia_tremor";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($individuo_fk_id, $tipo_desenho, $desenho, $classificador,
                                  $proba_saudavel, $proba_tremor, $data_hora, $observacao)
	{
		$db = Database::conexao();
			
		$sql = "insert into prodata.avalia_tremor
				values (default, :individuo_fk_id, :tipo_desenho, :desenho, :classificador, 
				                 :proba_saudavel, :proba_tremor, :data_hora, :observacao)
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":individuo_fk_id", $individuo_fk_id, PDO::PARAM_INT);
		$stmt->bindParam(":tipo_desenho", $tipo_desenho, PDO::PARAM_STR);
		$stmt->bindParam(":desenho", $desenho, PDO::PARAM_STR);
		$stmt->bindParam(":classificador", $classificador, PDO::PARAM_STR);
		$stmt->bindParam(":proba_saudavel", $proba_saudavel, PDO::PARAM_STR);
		$stmt->bindParam(":proba_tremor", $proba_tremor, PDO::PARAM_STR);
		$stmt->bindParam(":data_hora", $data_hora, PDO::PARAM_STR);
		$stmt->bindParam(":observacao", $observacao, PDO::PARAM_STR);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($id, $individuo_fk_id, $tipo_desenho, $desenho, $classificador,
                                  $proba_saudavel, $proba_tremor, $data_hora, $observacao)
	{
		$db = Database::conexao();

		$sql = "update prodata.avalia_tremor
				   set individuo_fk_id = :individuo_fk_id,
				       tipo_desenho = :tipo_desenho,
				       desenho = :desenho,
				       classificador = :classificador,
                       proba_saudavel = :proba_saudavel,
				       proba_tremor = :proba_tremor,
				       data_hora = :data_hora,
				       observacao = :observacao
				 where id = :id";

		$stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":individuo_fk_id", $individuo_fk_id, PDO::PARAM_INT);
        $stmt->bindParam(":tipo_desenho", $tipo_desenho, PDO::PARAM_STR);
        $stmt->bindParam(":desenho", $desenho, PDO::PARAM_STR);
        $stmt->bindParam(":classificador", $classificador, PDO::PARAM_STR);
        $stmt->bindParam(":proba_saudavel", $proba_saudavel, PDO::PARAM_STR);
        $stmt->bindParam(":proba_tremor", $proba_tremor, PDO::PARAM_STR);
        $stmt->bindParam(":data_hora", $data_hora, PDO::PARAM_STR);
        $stmt->bindParam(":observacao", $observacao, PDO::PARAM_STR);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from prodata.avalia_tremor
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}

}