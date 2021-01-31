<?php

class QuestionarioQuestao
{
	public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
	{
		$db = Database::conexao();
	
		$temp = 'where 1=1';
		if (!empty($filtro)){
			if (!empty($filtro["id"])) {
				$temp .= " and pergunta.id = ". $filtro["id"];
			}
			if (!empty($filtro["titulo"])) {
				$temp .= " and pergunta.titulo ilike '%". $filtro["titulo"]."%'";
			}
			if (!empty($filtro["descricao"])) {
				$temp .= " and pergunta.descricao ilike '%". $filtro["descricao"]."%'";
			}
			if (!empty($filtro["instrucao"])) {
				$temp .= " and pergunta.instrucao ilike '%". $filtro["instrucao"]."%'";
			}
			if (!empty($filtro["numero"])) {
				$temp .= " and pergunta.numero = ". $filtro["numero"];
			}
			if (!empty($filtro["ordem"])) {
				$temp .= " and grupo.id = ". $filtro["ordem"];
			}
			if (!empty($filtro["contavel"])) {
				$convert = ($filtro["contavel"] == 'sim') ? 'true' : 'false';
				$temp .= " and pergunta.contavel = ". $convert;
			}
			if (!empty($filtro["status"])) {
				$convert = ($filtro["status"] == 'ativo') ? 'true' : 'false';
				$temp .= " and pergunta.status = ". $convert;
			}
		}
		
		$sql = "select
					pergunta.id,
					pergunta.titulo,
					pergunta.descricao,
					pergunta.instrucao,
					pergunta.numero,
					pergunta.ordem,
					case when pergunta.contavel = true then 
						'sim' 
					else 
						'não' 
					end contavel
					case when pergunta.status = true then 
						'ativo' 
					else 
						'inativo' 
					end status,
				from
					questionario.pergunta
					
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
				from questionario.pergunta";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

    public static function buscarQuestaoPeloId($questaoId)
    {
        $db = Database::conexao();

        $sql = "select 
                    questao.*,
                    agrupamento.id as agrupamento_id,
                    agrupamento.descricao as agrupamento_descricao,
                    array_to_json(array(
                        select ta.id
                        from questionario.tipo_aplicacao ta
                        join questionario.questao_tipo_aplicacao qta
                        on qta.tipo_aplicacao_fk_id = ta.id 
                        where qta.questao_fk_id = questionario.questao.id
                    )) as tipo_aplicacao_array
                from questionario.questao
                join questionario.agrupamento
                on agrupamento.id = questao.agrupamento_fk_id
                where questao.id = $questaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function buscarAlternativasQuestao($questaoId)
    {
        $db = Database::conexao();

        $sql = "select questao.id as questao_id,
                       questao.agrupamento_fk_id as questao_agrupamento_id,
                       questao_alternativa.id as questao_alternativa_id,
                       questao_alternativa.alternativa_fk_id as alternativa_id
                from 
                     questionario.questao
                     left join questionario.questao_alternativa
                             on questao_alternativa.questao_fk_id = questao.id
                
                where
                     questao.id  = $questaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

	public static function consultarQuestaoPeloAgrupamento($agrupamentoId)
	{
		$db = Database::conexao();

		$sql = "select 
                       agrupamento.id as agrupamento_id,
                       questao.id as questao_id,
                       questao.ordem as questao_ordem,
                       case when questao.status is true then
                            'ativa'
                       else
                            'inativa' 
                       end questao_status,
                       questao.titulo as questao_titulo,
                       questao.descricao as questao_descricao,
                       questao.instrucao as questao_instrucao,
                       questao.numero as questao_numero,
                       case when questao.contavel is true then
                            'contável'
                       else
                            'não contável' 
                       end questao_contavel,                       
                       tipo_questao.id as tipo_questao_id,
                       tipo_questao.descricao as tipo_questao_descricao,
                       questao_tipo_aplicacao.id as questao_tipo_aplicacao_id,
                       tipo_aplicacao.id as tipo_aplicacao_id,
                       tipo_aplicacao.descricao as tipo_aplicacao_descricao,
                       tipo_aplicacao.sigla as tipo_aplicacao_sigla,
                       questao_alternativa.id as questao_alternativa_id,
                       alternativa.id as alternativa_id,
                       alternativa.descricao as alternativa_descricao,
                       alternativa.valor as alternativa_valor,
                       alternativa.ordem as alternativa_ordem,
                       alternativa.status as alternativa_status
                
                from 
                       questionario.agrupamento
                       inner join questionario.questao
                               on questao.agrupamento_fk_id = agrupamento.id
                       inner join questionario.tipo_questao
                               on tipo_questao.id = questao.tipo_questao_fk_id  
                       inner join questionario.questao_tipo_aplicacao
                               on questao_tipo_aplicacao.questao_fk_id = questao.id
                       inner join questionario.tipo_aplicacao
                               on tipo_aplicacao.id = questao_tipo_aplicacao.tipo_aplicacao_fk_id 
                       left join questionario.questao_alternativa
                              on questao_alternativa.questao_fk_id = questao.id
                       left join questionario.alternativa
                              on alternativa.id = questao_alternativa.alternativa_fk_id
                
                where
                       agrupamento.id = $agrupamentoId 
                order by
                       questao.ordem, questao.numero, questao.titulo, 
                       alternativa.ordem, alternativa.descricao, tipo_aplicacao.id";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	/**
	 * Método para inserir a pergunta
	 * @param $questao - um array com todos os dados da tabela
	 * @return mixed
	 */
	public static function insert($questao)
	{
		$db = Database::conexao();

		$sql = "insert into questionario.questao
				values (default, 
				        :agrupamentoId,
				        :questaoTipoQuestaoId,
						:questaoOrdem,
						:questaoStatus,
						:questaoTitulo,
						:questaoDescricao,
						:questaoInstrucao,
						:questaoNumero,
						:questaoContavel) 
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":agrupamentoId", $questao["agrupamentoId"], PDO::PARAM_INT);
		$stmt->bindParam(":questaoTipoQuestaoId", $questao["questaoTipoQuestaoId"], PDO::PARAM_INT);
		$stmt->bindParam(":questaoOrdem", $questao["questaoOrdem"], PDO::PARAM_INT);
		$stmt->bindParam(":questaoStatus", $questao["questaoStatus"], PDO::PARAM_BOOL);
		$stmt->bindParam(":questaoTitulo", $questao["questaoTitulo"], PDO::PARAM_STR);
		$stmt->bindParam(":questaoDescricao", $questao["questaoDescricao"], PDO::PARAM_STR);
		$stmt->bindParam(":questaoInstrucao", $questao["questaoInstrucao"], PDO::PARAM_STR);
		$stmt->bindParam(":questaoNumero", $questao["questaoNumero"], PDO::PARAM_INT);
		$stmt->bindParam(":questaoContavel", $questao["questaoContavel"], PDO::PARAM_BOOL);
		$stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
	}

	/**
	 * Método para atualizar a pergunta
	 * @param $questao - um array com todos os dados da tabela
	 * @return mixed
	 */
	public static function update($questao)
	{
		$db = Database::conexao();
	
		$sql = "update questionario.questao
				   set agrupamento_fk_Id = :agrupamentoId,
				        tipo_questao_fk_id = :questaoTipoQuestaoId,
					    ordem = :questaoOrdem,
						status = :questaoStatus,
						titulo = :questaoTitulo,
						descricao = :questaoDescricao,
						instrucao = :questaoInstrucao,
						numero = :questaoNumero,
						contavel = :questaoContavel
				 where id = :id";
	
		$stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $questao["id"], PDO::PARAM_INT);
        $stmt->bindParam(":agrupamentoId", $questao["agrupamentoId"], PDO::PARAM_INT);
        $stmt->bindParam(":questaoTipoQuestaoId", $questao["questaoTipoQuestaoId"], PDO::PARAM_INT);
        $stmt->bindParam(":questaoOrdem", $questao["questaoOrdem"], PDO::PARAM_INT);
        $stmt->bindParam(":questaoStatus", $questao["questaoStatus"], PDO::PARAM_BOOL);
        $stmt->bindParam(":questaoTitulo", $questao["questaoTitulo"], PDO::PARAM_STR);
        $stmt->bindParam(":questaoDescricao", $questao["questaoDescricao"], PDO::PARAM_STR);
        $stmt->bindParam(":questaoInstrucao", $questao["questaoInstrucao"], PDO::PARAM_STR);
        $stmt->bindParam(":questaoNumero", $questao["questaoNumero"], PDO::PARAM_INT);
        $stmt->bindParam(":questaoContavel", $questao["questaoContavel"], PDO::PARAM_BOOL);
		$stmt->execute();
	
		return $stmt->rowCount();
	}
	
	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from questionario.questao
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}
}

