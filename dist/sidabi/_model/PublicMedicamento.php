<?php

class PublicMedicamento
{
	public static function consultarMedicamentos()
	{
		$db = Database::conexao();
	
		$sql = "select *
				from public.medicamento
				order by medicamento.nome asc";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
	{
		$db = Database::conexao();
		$temp = 'where 1=1';
		if (!empty($filtro)){
			if (!empty($filtro["nome"])) {
				$temp .= " and medicamento.nome ilike '%". $filtro["nome"]."%'";
			}
			if (!empty($filtro["descricao"])) {
				$temp .= " and medicamento.descricao ilike '%". $filtro["descricao"]."%'";
			}
			if (!empty($filtro["id"])) {
				$temp .= " and medicamento.id = ". $filtro["id"];
			}
			if (!empty($filtro["fabricante"])) {
				$temp .= " and medicamento.fabricante ilike '%". $filtro["fabricante"]."%'";
			}
		}
		$sql = "select *
				from public.medicamento
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
				from public.medicamento";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($nome, $descricao, $fabricante)
	{
		$db = Database::conexao();
			
		$sql = "insert into public.medicamento
				values (default, :nome, :descricao, :fabricante)
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":fabricante", $fabricante, PDO::PARAM_STR);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($nome, $descricao, $fabricante, $id)
	{
		$db = Database::conexao();

		$sql = "update public.medicamento
				   set nome = :nome,
						descricao = :descricao,
					    fabricante = :fabricante
				 where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":fabricante", $fabricante, PDO::PARAM_STR);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from public.medicamento
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}
	
	public static function procurarMedicamentoInline($gsSearchParam, $offset, $limit)
	{
		$db = Database::conexao();
	
		$sql = "select
					medicamento.id,
					medicamento.nome
				from
					public.medicamento
				where
					medicamento.nome ilike '%$gsSearchParam%'
					
				order by medicamento.nome asc
				limit $limit offset $offset";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function procurarMedicamentoInlineCount($gsSearchParam)
	{
		$db = Database::conexao();
	
		$sql = "select count(*) as quantidade_registro
				from public.medicamento
				where medicamento.nome ilike '%$gsSearchParam%'";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result[0]["quantidade_registro"];
	}
}