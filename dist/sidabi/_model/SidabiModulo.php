<?php
	class SidabiModulo
	{
		public static function consultarModulo()
		{
			$db = Database::conexao();

			$sql = "select *
					from sidabi.modulo
					order by modulo.sigla asc";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
		{
			$db = Database::conexao();
			$temp = 'where 1=1';
			if (!empty($filtro)){
				if (!empty($filtro["sigla"])) {
					$temp .= " and modulo.sigla ilike '%". $filtro["sigla"]."%'";
				}
				if (!empty($filtro["titulo"])) {
					$temp .= " and modulo.titulo ilike '%". $filtro["titulo"]."%'";
				}
				if (!empty($filtro["id"])) {
					$temp .= " and modulo.id = ". $filtro["id"];
				}
				if (!empty($filtro["status"])) {
					$temp .= " and modulo.status = ". $filtro["status"];
				}
				if (!empty($filtro["caminho_imagem"])) {
					$temp .= " and modulo.caminho_imagem ilike '%". $filtro["caminho_imagem"]."%'";
				}
				if (!empty($filtro["caminho_modulo"])) {
					$temp .= " and modulo.caminho_modulo ilike '%". $filtro["caminho_modulo"]."%'";
				}
			}
			$sql = "select modulo.sigla, modulo.titulo, modulo.id, 
						   case when modulo.status is true then 'ativo' else 'inativo' end status,
						   modulo.caminho_imagem, modulo.caminho_modulo
					from sidabi.modulo
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
					from sidabi.modulo";
		
			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function insert($sigla, $titulo, $status, $caminho_imagem, $caminho_modulo)
		{
			$db = Database::conexao();
			
			$sql = "insert into sidabi.modulo 
					values (default, :sigla, :titulo, :status, :caminho_imagem, :caminho_modulo)
					returning id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":sigla", $sigla, PDO::PARAM_STR);
			$stmt->bindParam(":titulo", $titulo, PDO::PARAM_STR);
			$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
			$stmt->bindParam(":caminho_imagem", $caminho_imagem, PDO::PARAM_STR);
			$stmt->bindParam(":caminho_modulo", $caminho_modulo, PDO::PARAM_STR);
			$stmt->execute();
		
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			return $result['id'];
		}
		
		public static function update($sigla, $titulo, $status, $caminho_imagem, $caminho_modulo, $id)
		{
			$db = Database::conexao();
				
			$sql = "update sidabi.modulo 
					set sigla = :sigla, 
						titulo = :titulo, 
						status = :status,
						caminho_imagem = :caminho_imagem,
						caminho_modulo = :caminho_modulo 
					where id = :id";
				
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":sigla", $sigla, PDO::PARAM_STR);
			$stmt->bindParam(":titulo", $titulo, PDO::PARAM_STR);
			$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
			$stmt->bindParam(":caminho_imagem", $caminho_imagem, PDO::PARAM_STR);
			$stmt->bindParam(":caminho_modulo", $caminho_modulo, PDO::PARAM_STR);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
		
			return $stmt->rowCount();
		}
		
		public static function delete($id) 
		{
			$db = Database::conexao();
			
			$sql = "delete from sidabi.modulo 
					where id = :id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
			
			return $stmt->rowCount();
		}
	}