<?php

class PublicCidade
{
	public static function procurarCidadeInlineDependency($gsSearchParam, $offset, $limit, $dependency)
	{
		$db = Database::conexao();

		$sql = "select 
                        cidade.id, 
                        cidade.nome as descricao
                from 
                        public.cidade
                        inner join public.estado
                                on estado.id = cidade.estado_fk_id
                where 
                        cidade.nome ilike '%$gsSearchParam%'
                        and estado.id = $dependency
                
                order by cidade.nome asc
                limit $limit offset $offset";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function procurarCidadeInlineCountDependency($gsSearchParam, $dependency)
	{
		$db = Database::conexao();

		$sql = "select count(*) as quantidade_registro
                from 
                    public.cidade
                    inner join public.estado
                                on estado.id = cidade.estado_fk_id
                where cidade.nome ilike '%$gsSearchParam%'
                      and estado.id = $dependency";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result[0]["quantidade_registro"];
	}

	public static function procurarCidadeInline($gsSearchParam, $offset, $limit)
	{
		$db = Database::conexao();

		$sql = "select 
                        cidade.id, 
                        cidade.nome as descricao
                from 
                        public.cidade
                where 
                        cidade.nome ilike '%$gsSearchParam%'
                
                order by cidade.nome asc
                limit $limit offset $offset";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function procurarCidadeInlineCount($gsSearchParam)
	{
		$db = Database::conexao();

		$sql = "select count(*) as quantidade_registro
					from public.cidade
					where cidade.nome ilike '%$gsSearchParam%'";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result[0]["quantidade_registro"];
	}


	public static function consultarCidadesPeloIdEstado($estadoId) 
	{
		$db = Database::conexao();
		
		$sql = "select
					cidade.id,
					cidade.nome,
					cidade.codigo_ibge,
					cidade.estado_fk_id
				from
					public.cidade
					left join public.estado
						   on estado.id = cidade.estado_fk_id
				where
					estado.id = $estadoId
				order by
					cidade.nome";
		
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
				$temp .= " and cidade.nome ilike '%". $filtro["nome"]."%'";
			}
			if (!empty($filtro["estado_nome"])) {
				$temp .= " and estado.nome ilike '%". $filtro["estado_nome"]."%'";
			}
			if (!empty($filtro["id"])) {
				$temp .= " and cidade.id = ". $filtro["id"];
			}
			if (!empty($filtro["codigo_ibge"])) {
				$temp .= " and cidade.codigo_ibge =". $filtro["codigo_ibge"];
			}
		}
		
		$sql = "select 
						cidade.id, 
						cidade.nome, 
						cidade.codigo_ibge,
						cidade.estado_fk_id, 
						estado.nome as estado_nome
				from 
						public.cidade
						left join public.estado
							   on estado.id = cidade.estado_fk_id
				$temp
				order by 
						$sidx $sord
				limit 
						$limit offset $start";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function contarTodosRegistros()
	{
		$db = Database::conexao();

		$sql = "select count(*) as count
				from public.cidade";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($nome, $codigoIbge, $estadoFkId, $populacao2010, $densidadeDemo, $gentilico, $area)
	{
		$db = Database::conexao();
			
		$sql = "insert into public.cidade
				values (default, :nome, :codigo_ibge, :estado_fk_id, :populacao_2010, :densidade_demo, :gentilico, :area)
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
		$stmt->bindParam(":codigo_ibge", $codigoIbge, PDO::PARAM_INT);
		$stmt->bindParam(":estado_fk_id", $estadoFkId, PDO::PARAM_INT);
		$stmt->bindParam(":populacao_2010", $populacao2010, PDO::PARAM_INT);
		$stmt->bindParam(":densidade_demo", $densidadeDemo, PDO::PARAM_STR);
		$stmt->bindParam(":gentilico", $gentilico, PDO::PARAM_STR);
		$stmt->bindParam(":area", $area, PDO::PARAM_INT);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($nome, $codigoIbge, $estadoFkId, $populacao2010, $densidadeDemo, $gentilico, $area, $id)
	{
		$db = Database::conexao();

		$sql = "update public.cidade
				   set nome = :nome,
					   codigo_ibge = :codigo_ibge,
					   estado_fk_id = :estado_fk_id,
					   populacao_2010 = :populacao_2010,
					   densidade_demo = :densidade_demo,
					   gentilico = :gentilico,
					   area = :area
				 where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
		$stmt->bindParam(":codigo_ibge", $codigoIbge, PDO::PARAM_INT);
		$stmt->bindParam(":estado_fk_id", $estadoFkId, PDO::PARAM_INT);
		$stmt->bindParam(":populacao_2010", $populacao2010, PDO::PARAM_INT);
		$stmt->bindParam(":densidade_demo", $densidadeDemo, PDO::PARAM_STR);
		$stmt->bindParam(":gentilico", $gentilico, PDO::PARAM_STR);
		$stmt->bindParam(":area", $area, PDO::PARAM_INT);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from public.cidade
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}

}