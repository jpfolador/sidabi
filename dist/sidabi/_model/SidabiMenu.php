<?php
	class SidabiMenu
	{
		public static function consultarMenu($moduloId='')
		{
			$db = Database::conexao();
			$where = '';
			if (!empty($moduloId)) {
				$where = "where modulo_fk_id = $moduloId";
			}

			$sql = "select 
						menu.*
					from 
						sidabi.menu
						inner join sidabi.modulo 
								on modulo.id = menu.modulo_fk_id and modulo.status is true
					
					$where
					
					order by 
						menu.nome asc";

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
					$temp .= " and menu.nome ilike '%". $filtro["nome"]."%'";
				}
				if (!empty($filtro["url"])) {
					$temp .= " and menu.url ilike '%". $filtro["url"]."%'";
				}
				if (!empty($filtro["id"])) {
					$temp .= " and menu.id = ". $filtro["id"];
				}
				if (!empty($filtro["modulo_descricao"])) {
					$temp .= " and menu.modulo_fk_id = ". $filtro["modulo_descricao"];
				}
				if (!empty($filtro["ordem"])) {
					$temp .= " and menu.ordem = ". $filtro["ordem"];
				}
			}
			$sql = "select menu.*,
						modulo.sigla modulo_descricao
					from 
						sidabi.menu
						inner join sidabi.modulo
								on modulo.id = menu.modulo_fk_id
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
					from sidabi.menu";
		
			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function insert($nome, $url, $modulo_fk_id, $ordem)
		{
			$db = Database::conexao();
			
			$sql = "insert into sidabi.menu 
					values (default, :nome, :url, :modulo_fk_id, :ordem)
					returning id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
			$stmt->bindParam(":url", $url, PDO::PARAM_STR);
			$stmt->bindParam(":modulo_fk_id", $modulo_fk_id, PDO::PARAM_INT);
			$stmt->bindParam(":ordem", $ordem, PDO::PARAM_INT);
			$stmt->execute();
		
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			return $result['id'];
		}
		
		public static function update($nome, $url, $modulo_fk_id, $ordem, $id)
		{
			$db = Database::conexao();
				
			$sql = "update sidabi.menu 
					set nome = :nome, 
						url = :url, 
						modulo_fk_id = :modulo_fk_id,
						ordem = :ordem
					where id = :id";
				
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
			$stmt->bindParam(":url", $url, PDO::PARAM_STR);
			$stmt->bindParam(":modulo_fk_id", $modulo_fk_id, PDO::PARAM_INT);
			$stmt->bindParam(":ordem", $ordem, PDO::PARAM_INT);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
		
			return $stmt->rowCount();
		}
		
		public static function delete($id) 
		{
			$db = Database::conexao();
			
			$sql = "delete from sidabi.menu 
					where id = :id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
			
			return $stmt->rowCount();
		}
	}