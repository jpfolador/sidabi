<?php

class PublicIndividuoMedicamento
{
	public static function consultarIndividuoMedicamento()
	{
		$db = Database::conexao();
	
		$sql = "select individuo_medicamento.*
				from public.individuo_medicamento
					 inner join public.individuo
							 on individuo.id = individuo_medicamento.individuo_fk_id
				order by individuo.nome asc";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function consultarMedicamentoPeloIndividuo($individuoId)
	{
		$db = Database::conexao();

		$sql = "select 
						individuo_medicamento.id 		as individuo_medicamento_id,
						individuo_medicamento.observacao, 
						individuo_medicamento.dosagem, 
						individuo.id 					as individuo_id,
						individuo.nome					as paciente_nome,
						medicamento.id					as medicamento_id,
						medicamento.descricao			as medicamento_descricao,
						medicamento.nome				as medicamento_nome,
						medicamento.fabricante			as medicamento_fabricante
						
				from 
						public.individuo_medicamento
						inner join public.individuo
								on individuo.id = individuo_medicamento.individuo_fk_id
						inner join public.medicamento
								on medicamento.id = individuo_medicamento.medicamento_fk_id
				where 
						individuo_medicamento.individuo_fk_id = $individuoId ";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function contarTodosRegistros()
	{
		$db = Database::conexao();

		$sql = "select count(*) as count
				from public.individuo_medicamento";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($individuoId, $medicamentoId, $dosagem, $observacao)
	{
		$db = Database::conexao();
			
		$sql = "insert into public.individuo_medicamento
				values (default, :individuoId, :medicamentoId, :dosagem, :observacao)
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":individuoId", $individuoId, PDO::PARAM_INT);
		$stmt->bindParam(":medicamentoId", $medicamentoId, PDO::PARAM_INT);
		$stmt->bindParam(":dosagem", $dosagem, PDO::PARAM_STR);
		$stmt->bindParam(":observacao", $observacao, PDO::PARAM_STR);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($individuoId, $medicamentoId, $dosagem, $observacao, $id)
	{
		$db = Database::conexao();

		$sql = "update public.individuo_medicamento
				   set individuo_fk_id = :individuoId,
					   medicamento_fk_id = :medicamentoId,
					   dosagem = :dosagem,
					   observacao = :observacao
				 where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":individuoId", $individuoId, PDO::PARAM_INT);
		$stmt->bindParam(":medicamentoId", $medicamentoId, PDO::PARAM_INT);
		$stmt->bindParam(":dosagem", $dosagem, PDO::PARAM_STR);
		$stmt->bindParam(":observacao", $observacao, PDO::PARAM_STR);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from public.individuo_medicamento
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}
}