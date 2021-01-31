<?php

class QuestionarioTipoAplicacao
{
	public static function listarTodosRegistros()
	{
		$db = Database::conexao();
	
		$sql = "select * from questionario.tipo_aplicacao order by id";
	
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
				$temp .= " and tipo_aplicacao.descricao ilike '%". $filtro["descricao"]."%'";
			}
			if (!empty($filtro["sigla"])) {
				$temp .= " and tipo_aplicacao.sigla ilike '%". $filtro["sigla"]."%'";
			}
			if (!empty($filtro["id"])) {
				$temp .= " and tipo_aplicacao.id = ". $filtro["id"];
			}
			if (!empty($filtro["status"])) {
				$convert = ($filtro["status"] == 'ativo') ? 'true' : 'false';
				$temp .= " and tipo_aplicacao.status = ". $convert;
			}
		}
		
		$sql = "select
					id,
					descricao,
					case when status = true then
						'ativo'
					else
						'inativo'
					end status,
					sigla
				from 
					questionario.tipo_aplicacao
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
					from questionario.tipo_aplicacao";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($descricao, $sigla, $status)
	{
		$db = Database::conexao();
			
		$sql = "insert into questionario.tipo_aplicacao
					values (default, :descricao, :sigla, :status)
					returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":sigla", $sigla, PDO::PARAM_STR);
		$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($id, $descricao, $sigla, $status)
	{
		$db = Database::conexao();

		$sql = "update questionario.tipo_aplicacao
					set descricao = :descricao,
						sigla = :sigla,
						status = :status
					where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":sigla", $sigla, PDO::PARAM_STR);
		$stmt->bindParam(":status", $status, PDO::PARAM_STR);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from questionario.tipo_aplicacao
					where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}
}