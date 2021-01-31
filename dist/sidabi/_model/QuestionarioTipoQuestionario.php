<?php

class QuestionarioTipoQuestionario
{
	public static function consultarTipoQuestionario()
	{
		$db = Database::conexao();

		$sql = "select *
				from questionario.tipo_questionario
				order by tipo_questionario.titulo asc";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
	{
		$db = Database::conexao();
		$temp = 'where 1=1';
		if (!empty($filtro)) {
			if (!empty($filtro["id"])) {
				$temp .= " and tipo_questionario.id = ". $filtro["id"];
			}
			if (!empty($filtro["titulo"])) {
				$temp .= " and tipo_questionario.titulo = '%". $filtro["titulo"] ."%'";
			}
			if (!empty($filtro["descricao"])) {
				$temp .= " and tipo_questionario.descricao = '%". $filtro["descricao"] ."%'";
			}
			if (!empty($filtro["endereco_eletronico"])) {
				$temp .= " and tipo_questionario.endereco_eletronico = '%". $filtro["endereco_eletronico"] ."%'";
			}
			if (!empty($filtro["status"])) {
				$convert = ($filtro["status"] == 'ativo') ? 'true' : 'false';
				$temp .= " and tipo_questionario.status = ". $convert;
			}
		}

		$sql = "select 
					id, 
					titulo,
					descricao, 
					case when status = true then 
						'ativo' 
					else 
						'inativo' 
					end status,
					endereco_eletronico
				from questionario.tipo_questionario
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
				from questionario.tipo_questionario";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($titulo, $descricao, $enderecoEletronico, $status)
	{
		$db = Database::conexao();

		$sql = "insert into questionario.tipo_questionario 
				values (default, :titulo, :descricao, :endereco_eletronico, :status)
				returning id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":titulo", $titulo, PDO::PARAM_STR);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":endereco_eletronico", $enderecoEletronico, PDO::PARAM_STR);
		$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($id, $titulo, $descricao, $enderecoEletronico, $status)
	{
		$db = Database::conexao();

		$sql = "update questionario.tipo_questionario 
				set titulo = :titulo, 
					descricao = :descricao, 
					endereco_eletronico = :endereco_eletronico, 
					status = :status
				where id = :id ";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":titulo", $titulo, PDO::PARAM_STR);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":endereco_eletronico", $enderecoEletronico, PDO::PARAM_STR);
		$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();

		$sql = "delete from questionario.tipo_questionario 
				where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}
}