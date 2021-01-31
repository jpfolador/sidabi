<?php

class QuestionarioResposta
{
	public static function exportarDadosPacienteResposta($paPaciente=null, $paGrupos=null)
	{
		$db = Database::conexao();
		if (empty($paPaciente) && empty($paGrupos))
		{
			$sql = "select
					pergunta_alternativa.id                   	as pergunta_alternativa_id,
					grupo.id                                  	as grupo_id,
					grupo.descricao                           	as grupo_descricao,
					grupo.numero                              	as grupo_numero,
					pergunta.id                               	as pergunta_id,
					pergunta.titulo                           	as pergunta_titulo,
					pergunta.numero                          	as pergunta_numero,
					pergunta.contavel                         	as pergunta_contavel,
					alternativa.id                            	as alternativa_id,
					alternativa.descricao                     	as alternativa_descricao,
					alternativa.opcao                         	as alternativa_opcao_valor,
					(
						case alternativa.opcao
							when 0 then 'Normal'
							when 1 then 'Discreto'
							when 2 then 'Ligeiro'
							when 3 then 'Moderado'
							when 4 then 'Grave'
							when 5 then 'Confinado'
							when 99 then 'Não se aplica'
						end
					)                                         	as alternativa_opcao_desc,
					alternativa.tipo_alternativa,
					(
						select count(*)
						from questionario.pergunta_alternativa_tipo_aplicacao pata
						where pata.pergunta_alternativa_fk_id = pergunta_alternativa.id
					) 										  	as qtd_tipo_aplicacao,
					resposta.id as resposta_id,
					resposta.observacao,
					pergunta_alternativa_tipo_aplicacao.id 		as pergunta_alternativa_tipo_aplicacao_id,
					tipo_aplicacao.id 							as tipo_aplicacao_id,
					tipo_aplicacao.descricao 					as tipo_aplicacao_descricao,
					tipo_aplicacao.sigla 						as tipo_aplicacao_sigla,
					questionario.id 							as questionario_id,
					to_char(questionario.data_avaliacao, 'dd/mm/YYYY') as data_avaliacao, 
                    questionario.local questionario_local, 
                    questionario.investigador 					as questionario_investigador,
                    case questionario.fonte_informacao
				       	when 1 then 'Paciente'
				       	when 2 then 'cuidador'
				       	when 3 then 'Paciente e cuidador em proporções iguais'
				    end 										as questionario_fonte_informacao_descricao,
				    medicamento.descricao 						as medicamento_descricao,
				    medicamento.unidade_dosagem,
				    questionario.dosagem_dia,
				    individuo.id paciente_id,
                    individuo.nome paciente_nome,
                    individuo.sexo paciente_sexo,
                    individuo.email paciente_email,
                    individuo.data_nascimento,
                    individuo.telefone1,
                    individuo.telefone2,
                    individuo.logradouro,
                    individuo.numero,
                    individuo.bairro,
                    individuo.cidade_fk_id,
                    individuo.rg,
                    individuo.cpf,
                    individuo.diagnostico,
                    individuo.dt_diagnostico,
                    individuo.medico_responsavel,
                    individuo.telefone_medico_responsavel,
                    individuo.outras_patologias,
                    individuo.peso,
                    individuo.altura,
                    individuo.foto,
                    individuo.tipo_sangue_fk_id
				
				from
					questionario.pergunta_alternativa
                                        
					inner join questionario.alternativa
							on alternativa.id = pergunta_alternativa.alternativa_fk_id
					inner join questionario.pergunta
							on pergunta.id = pergunta_alternativa.pergunta_fk_id
					inner join questionario.grupo
							on grupo.id = pergunta.grupo_fk_id
					inner join questionario.pergunta_alternativa_tipo_aplicacao
							on pergunta_alternativa_tipo_aplicacao.pergunta_alternativa_fk_id = pergunta_alternativa.id
					inner join questionario.tipo_aplicacao
							on tipo_aplicacao.id = pergunta_alternativa_tipo_aplicacao.tipo_aplicacao_fk_id
					inner join questionario.resposta
							on resposta.pergunta_alternativa_tipo_aplicacao_fk_id = pergunta_alternativa_tipo_aplicacao.id
					inner join questionario.questionario
							on questionario.id = resposta.questionario_fk_id
                    inner join public.individuo 
                            on individuo.id = questionario.paciente_fk_id
                    inner join questionario.medicamento
                    		on medicamento.id = questionario.medicamento_fk_id
				where
					pergunta.status is true
					and alternativa.status is true
					and grupo.status is true
					and questionario.questionario_finalizado is true
					and questionario.paciente_fk_id = 1
						
				order by
					questionario.data_avaliacao, 
					grupo.numero, 
					pergunta.numero, 
					pergunta.ordem, 
					alternativa.opcao, 
					alternativa.ordem ASC";
		}

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function consultarRespostasViaQuestionarioPaciente($questionarioId, $pacienteId)
	{
		$db = Database::conexao();

		$sql = "select 
					       grupo.id                                  as grupo_id,
					       grupo.descricao                           as grupo_descricao,
					       grupo.numero                              as grupo_numero,
					       pergunta.id                               as pergunta_id,
					       pergunta.titulo                           as pergunta_titulo,
					       pergunta.numero                           as pergunta_numero,
					       alternativa.id                            as alternativa_id,
					       alternativa.descricao                     as alternativa_descricao,
					       alternativa.opcao                         as alternativa_opcao_valor,
					       (
                                case alternativa.opcao
                                     when 0 then 'Normal'
									 when 1 then 'Discreto'
									 when 2 then 'Ligeiro'
									 when 3 then 'Moderado'
									 when 4 then 'Grave'
									 when 5 then 'Confinado'
		                             when 99 then 'Não se aplica'
                                end                           
                           )                                         as alternativa_opcao_desc,
                           resposta.id as resposta_id,
                           resposta.observacao,
                           tipo_aplicacao.id as tipo_aplicacao_id,
                           tipo_aplicacao.descricao as tipo_aplicacao_descricao,
                           tipo_aplicacao.sigla as tipo_aplicacao_sigla
					       
					from
					       questionario.pergunta_alternativa
					       inner join questionario.alternativa
					               on alternativa.id = pergunta_alternativa.alternativa_fk_id
					       inner join questionario.pergunta 
					               on pergunta.id = pergunta_alternativa.pergunta_fk_id
                           inner join questionario.grupo 
					               on grupo.id = pergunta.grupo_fk_id
                           inner join questionario.pergunta_alternativa_tipo_aplicacao
                                   on pergunta_alternativa_tipo_aplicacao.pergunta_alternativa_fk_id = pergunta_alternativa.id
                           inner join questionario.tipo_aplicacao
                                   on tipo_aplicacao.id = pergunta_alternativa_tipo_aplicacao.tipo_aplicacao_fk_id
                           inner join questionario.resposta
                                   on resposta.pergunta_alternativa_tipo_aplicacao_fk_id = pergunta_alternativa_tipo_aplicacao.id
                           inner join questionario.questionario
                                   on questionario.id = resposta.questionario_fk_id
					where
					       pergunta.status is true
					       and alternativa.status is true
					       and grupo.status is true
					       and questionario.questionario_finalizado is true
				           and questionario.paciente_fk_id = $pacienteId
				           and questionario.id = $questionarioId
					
					order by
					       grupo.numero, pergunta.numero, pergunta.ordem, alternativa.opcao, alternativa.ordem ASC ";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function monstarTodasAvaliacoes($tipoQuestionarioId, $participanteId, $dataInicio="", $dataFim="")
	{
		$db = Database::conexao();
		$sqlTemp = "";
		if (!empty($dataInicio) && !empty($dataFim)) {
			$sqlTemp = " and avaliacao.data_avaliacao between '$dataInicio' and '$dataFim' ";
		}
        if (!empty($dataInicio) && empty($dataFim)) {
            $sqlTemp = " and avaliacao.data_avaliacao >= '$dataInicio'";
        }
        if (empty($dataInicio) && !empty($dataFim)) {
            $sqlTemp = " and avaliacao.data_avaliacao <= '$dataFim'";
        }
	
		$sql = "select
                    avaliacao.id as avaliacao_id,
                    to_char(avaliacao.data_avaliacao, 'dd/mm/YYYY') as data_avaliacao, 
                    avaliacao.medicamento as medicamento,
                    individuo.nome as participante_nome,
                    to_char(individuo.data_nascimento, 'dd/mm/YYYY') as participante_data_nascimento,
                    case when individuo.sexo = 'M' then 'Masculino' else 'Feminino' end participante_sexo,
                    case individuo.diagnostico
                        when 1 then 'Doença de Parkinson Idiopática'
                        when 2 then 'Parkinsonismo'
                        when 3 then 'Indivíduo Hígido'
                    end participante_diagnostico,
                    
                    tipo_questionario.id as tipo_questionario_id,
                    tipo_questionario.titulo as tipo_questionario_titulo,
                    
                    agrupamento.id as agrupamento_id,
                    agrupamento.descricao as agrupamento_descricao,
                    agrupamento.ordem as agrupamento_ordem,
                    
                    questao.id as questao_id,
                    questao.ordem as questao_ordem,
                    questao.numero as questao_numero,
                    questao.titulo as questao_titulo,
                    questao.contavel as questao_contavel,
                    
                    tipo_questao.id as tipo_questao_id,
                    
                    questao_tipo_aplicacao.id as questao_tipo_aplicacao_id,
                    tipo_aplicacao.id as tipo_aplicacao_id,
                    tipo_aplicacao.sigla as tipo_aplicacao_sigla,
                    
                    alternativa.id as alternativa_id,
                    alternativa.descricao as alternativa_descricao,
                    alternativa.valor as alternativa_valor,
                    (
                        select count(*)
                        from questionario.questao_tipo_aplicacao pata
                        where pata.questao_fk_id = questao.id
                    ) as qtd_tipo_aplicacao,
                    
                    resposta.id as resposta_id,
                    resposta.alternativa_descritiva as alternativa_descritiva
                
                from
                    questionario.tipo_questionario
                    inner join questionario.agrupamento
                            on agrupamento.tipo_questionario_fk_id = tipo_questionario.id
                    inner join questionario.questao
                            on questao.agrupamento_fk_id = agrupamento.id
                    inner join questionario.tipo_questao
			                on tipo_questao.id = questao.tipo_questao_fk_id
                    inner join questionario.questao_tipo_aplicacao
                            on questao_tipo_aplicacao.questao_fk_id = questao.id
                    inner join questionario.tipo_aplicacao
                            on tipo_aplicacao.id = questao_tipo_aplicacao.tipo_aplicacao_fk_id
                    inner join questionario.resposta
                            on resposta.questao_fk_id = questao.id
                           and resposta.tipo_aplicacao_fk_id = tipo_aplicacao.id
                           and resposta.tipo_questionario_fk_id = tipo_questionario.id
                    inner join questionario.alternativa
                            on alternativa.id = resposta.alternativa_fk_id
                    inner join questionario.avaliacao
                            on avaliacao.tipo_questionario_fk_id = tipo_questionario.id
                           and avaliacao.id = resposta.avaliacao_fk_id	
                    inner join public.individuo 
                            on individuo.id = avaliacao.participante_fk_id
                
                where
                    questao.status is true
                    and alternativa.status is true
                    and agrupamento.status is true
                    and avaliacao.finalizada is true
                    and tipo_questionario.id = $tipoQuestionarioId
                    and avaliacao.participante_fk_id = $participanteId
                    
                    $sqlTemp 
                order by
                    avaliacao.data_avaliacao, agrupamento.ordem, questao.ordem, questao.numero, tipo_aplicacao.sigla, alternativa.ordem asc";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function monstarResumoRespostas($questionarioId, $pacienteId)
	{
		$db = Database::conexao();
	
		$sql = "select 
			               pergunta_alternativa.id                   as pergunta_alternativa_id,
					       grupo.id                                  as grupo_id,
					       grupo.descricao                           as grupo_descricao,
					       grupo.numero                              as grupo_numero,
					       pergunta.id                               as pergunta_id,
					       pergunta.titulo                           as pergunta_titulo,
					       pergunta.numero                           as pergunta_numero,
					       pergunta.contavel                         as pergunta_contavel,
					       alternativa.id                            as alternativa_id,
					       alternativa.descricao                     as alternativa_descricao,
					       alternativa.opcao                         as alternativa_opcao_valor,
					       (
                                case alternativa.opcao
                                     when 0 then 'Normal'
									 when 1 then 'Discreto'
									 when 2 then 'Ligeiro'
									 when 3 then 'Moderado'
									 when 4 then 'Grave'
									 when 5 then 'Confinado'
		                             when 99 then 'Não se aplica'
                                end                           
                           )                                         as alternativa_opcao_desc,
						   alternativa.tipo_alternativa,
					       (
                                select count(*) 
                                from questionario.pergunta_alternativa_tipo_aplicacao pata 
                                where pata.pergunta_alternativa_fk_id = pergunta_alternativa.id 
                           ) 										 as qtd_tipo_aplicacao,
                           resposta.id as resposta_id,
                           resposta.observacao,
                           pergunta_alternativa_tipo_aplicacao.id as pergunta_alternativa_tipo_aplicacao_id,
                           tipo_aplicacao.id as tipo_aplicacao_id,
                           tipo_aplicacao.descricao as tipo_aplicacao_descricao,
                           tipo_aplicacao.sigla as tipo_aplicacao_sigla,
                           questionario.id as questionario_id           
					       
					from
					       questionario.pergunta_alternativa
					       inner join questionario.alternativa
					               on alternativa.id = pergunta_alternativa.alternativa_fk_id
					       inner join questionario.pergunta 
					               on pergunta.id = pergunta_alternativa.pergunta_fk_id
                           inner join questionario.grupo 
					               on grupo.id = pergunta.grupo_fk_id
                           inner join questionario.pergunta_alternativa_tipo_aplicacao
                                   on pergunta_alternativa_tipo_aplicacao.pergunta_alternativa_fk_id = pergunta_alternativa.id
                           inner join questionario.tipo_aplicacao
                                   on tipo_aplicacao.id = pergunta_alternativa_tipo_aplicacao.tipo_aplicacao_fk_id
                           inner join questionario.resposta
                                   on resposta.pergunta_alternativa_tipo_aplicacao_fk_id = pergunta_alternativa_tipo_aplicacao.id
                           inner join questionario.questionario
                                   on questionario.id = resposta.questionario_fk_id
					where
					       pergunta.status is true
					       and alternativa.status is true
					       and grupo.status is true
					       and questionario.questionario_finalizado is true
				           and questionario.paciente_fk_id = $pacienteId
				           and questionario.id = $questionarioId
					
					order by
					       grupo.numero, pergunta.numero, pergunta.ordem, alternativa.opcao, alternativa.ordem ASC ";
	
		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	
	public static function verificarRespostaExistente($tipoQuestionarioId, $avaliacaoId, $questaoId, $tipoAplicacaoId)
	{
		$db = Database::conexao();

		$sql = "select *
                from questionario.resposta
                where resposta.avaliacao_fk_id = $avaliacaoId
                    and tipo_questionario_fk_id = $tipoQuestionarioId
                    and tipo_aplicacao_fk_id = $tipoAplicacaoId
                    and questao_fk_id = $questaoId ";

		$result = $db->query($sql);
		$result = $result->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}

	public static function insert($avaliacaoId, $tipoQuestionarioId, $alternativaId, $tipoAplicacaoId,
                                  $loginId, $dataRegistro, $alternativaDescritiva, $questaoId)
	{
		$db = Database::conexao();
			
		$sql = "insert into questionario.resposta
				values (default, :avaliacao_fk_id, :tipo_questionario_fk_id, :alternativa_fk_id, 
				        :tipo_aplicacao_fk_id, :login_fk_id, :data_registro, :alternativa_descritiva, :questao_fk_id)
				returning id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":avaliacao_fk_id", $avaliacaoId, PDO::PARAM_INT);
		$stmt->bindParam(":tipo_questionario_fk_id", $tipoQuestionarioId, PDO::PARAM_INT);
		$stmt->bindParam(":alternativa_fk_id", $alternativaId, PDO::PARAM_INT);
		$stmt->bindParam(":tipo_aplicacao_fk_id", $tipoAplicacaoId, PDO::PARAM_INT);
		$stmt->bindParam(":login_fk_id", $loginId, PDO::PARAM_INT);
		$stmt->bindParam(":data_registro", $dataRegistro, PDO::PARAM_STR);
		$stmt->bindParam(":alternativa_descritiva", $alternativaDescritiva, PDO::PARAM_STR);
		$stmt->bindParam(":questao_fk_id", $questaoId, PDO::PARAM_INT);
		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result['id'];
	}

    /**
     * Apaga as respostas de uma avaliação
     * @param $avaliacaoId
     * @return int
     */
	public static function apagarTodasRespostasAvaliacao($avaliacaoId)
	{
		$db = Database::conexao();
			
		$sql = "delete from questionario.resposta
				where avaliacao_fk_id = :avaliacao_fk_id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":avaliacao_fk_id", $avaliacaoId, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}
	
	public static function delete($id)
	{
		$db = Database::conexao();
			
		$sql = "delete from questionario.resposta
				where id = :id";
			
		$stmt = $db->prepare($sql);
		$stmt->bindParam(":id", $id, PDO::PARAM_INT);
		$stmt->execute();
			
		return $stmt->rowCount();
	}
}