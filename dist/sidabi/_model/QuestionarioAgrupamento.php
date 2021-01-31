<?php

class QuestionarioAgrupamento
{
	public static function consultarAgrupamentosAtivos($tipoQuestionarioId)
	{
		$db = Database::conexao();

		$sql = "select 
                    agrupamento.id as agrupamento_id,
                    agrupamento.descricao,
                    agrupamento.ordem,
                    tipo_questionario.id as tipo_questionario_id,
                    tipo_questionario.titulo as tipo_questionario_titulo
				from 
				    questionario.agrupamento
				    inner join questionario.tipo_questionario
				            on tipo_questionario.id = agrupamento.tipo_questionario_fk_id
				where 
				    agrupamento.status is true
				    and agrupamento.tipo_questionario_fk_id = $tipoQuestionarioId
				order by 
				    agrupamento.ordem asc";

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
				$temp .= " and agrupamento.id = ". $filtro["id"];
			}
			if (!empty($filtro["descricao"])) {
				$temp .= " and agrupamento.descricao = '%". $filtro["descricao"] ."%'";
			}
			if (!empty($filtro["ordem"])) {
				$temp .= " and agrupamento.ordem = ". $filtro["ordem"];
			}
			if (!empty($filtro["status"])) {
				$convert = ($filtro["status"] == 'ativo') ? 'true' : 'false';
				$temp .= " and agrupamento.status = ". $convert;
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
				from questionario.agrupamento
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
				from questionario.agrupamento";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function buscarAgrupamentoPeloId($agrupamentoId)
	{
		$db = Database::conexao();

		$sql = "select *
                from questionario.agrupamento
                where agrupamento.id = $agrupamentoId";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

    public static function buscarQuestoesAgrupamento($agrupamentoId)
    {
        $db = Database::conexao();

        $sql = "select 
                    agrupamento.id as agrupamento_id,
                    questao.id as questao_id,
                    questao.titulo as questao_titulo
                from 
                    questionario.agrupamento
                    join questionario.questao
                    on questao.agrupamento_fk_id = agrupamento.id
                where
                    agrupamento.id = $agrupamentoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

	public static function insert($descricao, $ordem, $status, $tipoQuestionario)
	{
		$db = Database::conexao();

		$sql = "insert into questionario.agrupamento 
				values (default, :descricao, :ordem, :status, :tipoQuestionario)
				returning id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":ordem", $ordem, PDO::PARAM_INT);
		$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
		$stmt->bindParam(":tipoQuestionario", $tipoQuestionario, PDO::PARAM_INT);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

	public static function update($id, $descricao, $ordem, $status)
	{
		$db = Database::conexao();

		$sql = "update questionario.agrupamento 
				set descricao = :descricao, 
					ordem = :ordem, 
					status = :status
				where id = :id ";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->bindParam(":descricao", $descricao, PDO::PARAM_STR);
		$stmt->bindParam(":ordem", $ordem, PDO::PARAM_INT);
		$stmt->bindParam(":status", $status, PDO::PARAM_BOOL);
        //$stmt->bindParam(":tipoQuestionario", $tipoQuestionario, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}

	public static function delete($id)
	{
		$db = Database::conexao();

		$sql = "delete from questionario.agrupamento 
				where id = :id";

		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();

		return $stmt->rowCount();
	}
}