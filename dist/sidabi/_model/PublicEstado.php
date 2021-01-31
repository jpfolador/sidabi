<?php

class PublicEstado
{
	public static function procurarEstadoInline($gsSearchParam, $offset, $limit)
	{
		$db = Database::conexao();

		$sql = "select 
                        estado.id, 
                        estado.nome as descricao
                from 
                        public.estado
                where 
                        estado.nome ilike '%$gsSearchParam%'
                
                order by estado.nome asc
                limit $limit offset $offset";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function procurarEstadoInlineCount($gsSearchParam)
	{
		$db = Database::conexao();

		$sql = "select count(*) as quantidade_registro
					from public.estado
					where estado.nome ilike '%$gsSearchParam%'";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result[0]["quantidade_registro"];
	}


	public static function consultarEstados()
	{
		$db = Database::conexao();
	
		$sql = "select *
				from public.estado
				order by estado.nome asc";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro='')
	{
		$db = Database::conexao();
		$temp = 'where 1=1';
		if (!empty($filtro)){
			if (!empty($filtro["nome"])) {
				$temp .= " and estado.nome ilike '%". $filtro["nome"]."%'";
			}
			if (!empty($filtro["sigla"])) {
				$temp .= " and estado.sigla ilike '%". $filtro["sigla"]."%'";
			}
			if (!empty($filtro["id"])) {
				$temp .= " and estado.id = ". $filtro["id"];
			}
			if (!empty($filtro["codigo_ibge"])) {
				$temp .= " and estado.codigo_ibge ilike '%". $filtro["codigo_ibge"]."%'";
			}
		}
		$sql = "select *
				from public.estado
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
				from public.estado";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($codigoIbge, $sigla, $nome)
	{
		$db = Database::conexao();
			
		$sql = "insert into public.estado
				values (default, :codigo_ibge, :sigla, :nome)
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":codigo_ibge", $codigoIbge, PDO::PARAM_STR);
		$stmt->bindParam(":sigla", $sigla, PDO::PARAM_STR);
		$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($codigoIbge, $sigla, $nome, $id)
	{
		$db = Database::conexao();

		$sql = "update public.estado
				   set codigo_ibge = :codigo_ibge,
					   sigla = :sigla,
					   nome = :nome
				 where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":codigo_ibge", $codigoIbge, PDO::PARAM_STR);
		$stmt->bindParam(":sigla", $sigla, PDO::PARAM_STR);
		$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from public.estado
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}

}