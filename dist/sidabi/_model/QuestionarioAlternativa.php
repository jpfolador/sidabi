<?php
	class QuestionarioAlternativa
	{
		public static function consultarTodasAlternativas()
		{
			$db = Database::conexao();
		
			$sql = "select *
					from questionario.alternativa
					order by alternativa.descricao asc";
		
			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

        public static function buscarAlternativaPeloId($alternativaId)
        {
            $db = Database::conexao();

            $sql = "select *
                    from questionario.alternativa
                    where alternativa.id = $alternativaId";

            $result = $db->query($sql);
            $result = $result->fetchAll(PDO::FETCH_ASSOC);
            return $result;
        }

		public static function consultarAlternativasGrid($sidx, $sord, $start, $limit, $filtro=array())
		{
			$db = Database::conexao();
			
			$temp = 'where 1=1';
			if (!empty($filtro)){
				if (!empty($filtro["id"])) {
					$temp .= " and alternativa.id = ". $filtro["id"];
				}
				if (!empty($filtro["descricao"])) {
					$temp .= " and alternativa.descricao ilike '%". $filtro["descricao"]."%'";
				}
				if (!empty($filtro["valor"]))
				{
					$temp .= " and alternativa.valor = " . $filtro["valor"];
				}
				if (!empty($filtro["status"])) {
					$convert = ($filtro["status"] == 'ativo') ? 'true' : 'false';
					$temp .= " and alternativa.status = ". $convert;
				}
				if (!empty($filtro["ordem"])) {
					$temp .= " and alternativa.ordem = ". $filtro["ordem"];
				}
			}
			
			$sql = "select 
						id, descricao, valor, ordem,
						case when status = true then 
							'ativo' 
						else 
							'inativo' 
						end status
					from questionario.alternativa
					
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
					from questionario.alternativa";
		
			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function insert($alternativa)
		{
			$db = Database::conexao();
			
			$sql = "insert into questionario.alternativa 
					values (default, :descricao, :valor, :ordem, :status)
					returning id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":descricao", $alternativa["alternativaDescricao"], PDO::PARAM_STR);
			$stmt->bindParam(":valor", $alternativa["alternativaValor"], PDO::PARAM_INT);
			$stmt->bindParam(":ordem", $alternativa["alternativaOrdem"], PDO::PARAM_INT);
			$stmt->bindParam(":status", $alternativa["alternativaStatus"], PDO::PARAM_BOOL);
			$stmt->execute();
		
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			return $result['id'];
		}
		
		public static function update($alternativa)
		{
			$db = Database::conexao();
				
			$sql = "update questionario.alternativa 
					set descricao = :descricao, 
						valor = :valor,
						ordem = :ordem,
						status = :status
					where id = :id";
				
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":id", $alternativa["id"], PDO::PARAM_INT);
            $stmt->bindParam(":descricao", $alternativa["alternativaDescricao"], PDO::PARAM_STR);
            $stmt->bindParam(":valor", $alternativa["alternativaValor"], PDO::PARAM_INT);
            $stmt->bindParam(":ordem", $alternativa["alternativaOrdem"], PDO::PARAM_INT);
            $stmt->bindParam(":status", $alternativa["alternativaStatus"], PDO::PARAM_BOOL);
			$stmt->execute();
		
			return $stmt->rowCount();
		}
		
		public static function delete($id) 
		{
			$db = Database::conexao();
			
			$sql = "delete from questionario.alternativa 
					where id = :id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
			
			return $stmt->rowCount();
		}
		
	}