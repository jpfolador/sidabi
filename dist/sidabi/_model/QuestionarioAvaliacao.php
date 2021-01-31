<?php

class QuestionarioAvaliacao
{

    public static function montarQuestoesAvaliacao($tipoQuestionarioId)
    {
        $db = Database::conexao();

        $sql = "select 
                       agrupamento.id as agrupamento_id,
                       agrupamento.ordem as agrupamento_ordem,
                       agrupamento.descricao as agrupamento_descricao,
                       
                       questao.id as questao_id,
                       questao.ordem as questao_ordem,
                       questao.titulo as questao_titulo,
                       questao.descricao as questao_descricao,
                       questao.instrucao as questao_instrucao,
                       questao.numero as questao_numero,
                       questao.contavel as questao_contavel,
                       tipo_questao.id as tipo_questao_id,
                       tipo_questao.descricao as tipo_questao_descricao,
                       
                       questao_alternativa.id as questao_alternativa_id,
                       alternativa.id as alternativa_id,
                       alternativa.descricao as alternativa_descricao,
                       alternativa.valor as alternativa_valor,
                       alternativa.ordem as alternativa_ordem,
                       (
                            select count(*) 
                            from questionario.questao_tipo_aplicacao qta 
                            where qta.questao_fk_id = questionario.questao.id 
                       ) as qtd_tipo_aplicacao
                       
                from 
                        questionario.tipo_questionario
                        inner join questionario.agrupamento
                                on agrupamento.tipo_questionario_fk_id = tipo_questionario.id
                        inner join questionario.questao
                                on questao.agrupamento_fk_id = agrupamento.id
                        inner join questionario.tipo_questao
                                on tipo_questao.id = questao.tipo_questao_fk_id  
                        inner join questionario.questao_alternativa
                                on questao_alternativa.questao_fk_id = questao.id
                        inner join questionario.alternativa
                                on alternativa.id = questao_alternativa.alternativa_fk_id
                
                where
                        tipo_questionario.id = $tipoQuestionarioId
                        
                order by
                        questao.ordem, questao.numero, questao.titulo, 
                        alternativa.ordem, alternativa.descricao ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function finalizarAvaliacao($avaliacaoId)
    {
        $db = Database::conexao();

        $sql = "update questionario.avaliacao
				set finalizada = true
				where id = :id ";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $avaliacaoId, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function avaliacaoEstaFinalizada($avaliacaoId)
    {
        $db = Database::conexao();

        $sql = "select avaliacao.finalizada as avaliacao
				from questionario.avaliacao
				where avaliacao.finalizada is true 
				and id = $avaliacaoId ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);

        return !empty($result) ? $result[0]["avaliacao"] : null;
    }

    public static function consultarTodasAvaliacoes()
    {
        $db = Database::conexao();

        $sql = "select *
                from questionario.avaliacao
                order by avaliacao.data_avaliacao asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarAvaliacaoRealizada($avaliacaoId)
    {
        $db = Database::conexao();

        $sql = "select 
                    avaliacao.id                          			as avaliacao_id,
                    avaliacao.investigador                			as avaliacao_investigador,
                    avaliacao.participante_fk_id           			as avaliacao_participante_fk_id,
                    to_char(avaliacao.data_avaliacao, 'dd/mm/YYYY') as avaliacao_data_avaliacao,             
                    avaliacao.fonte_informacao            			as avaliacao_fonte_informacao,
                    avaliacao.local                       			as avaliacao_local,
                    avaliacao.medicamento							as avaliacao_medicamento,
                    avaliacao.observacao                  			as avaliacao_observacao,
                    avaliacao.finalizada     						as avaliacao_finalizada,
                    avaliacao.login_fk_id                			as avaliacao_login_fk_id,
                    avaliacao.tipo_questionario_fk_id          		as avaliacao_tipo_questionario_fk_id,
                    array_to_json(array(
                    	select gp.id
                    	from questionario.avaliacao_grupo_pesquisadores_login agpl
	                    inner join sidabi.grupo_pesquisadores_login gpl
	                           on gpl.id = agpl.grupo_pesquisadores_login_fk_id
	                    inner join sidabi.grupo_pesquisadores gp
	                           on gp.id = gpl.grupo_pesquisadores_fk_id
	                    where agpl.avaliacao_fk_id = avaliacao.id
                    )) as grupo_pesquisadores,
                    json_agg(json_build_object(
                        'id', resposta.id,
                        'alternativa_fk_id', resposta.alternativa_fk_id,
                        'tipo_aplicacao_fk_id', resposta.tipo_aplicacao_fk_id,
                        'login_fk_id', resposta.login_fk_id,
                        'questao_fk_id', resposta.questao_fk_id,
                        'data_registro', resposta.data_registro,
                        'alternativa_descritiva', resposta.alternativa_descritiva,
                        'tipo_questionario_fk_id', resposta.tipo_questionario_fk_id 
                   )) AS respostas
                
                from 
                    questionario.avaliacao
                    left join questionario.resposta
                           on resposta.avaliacao_fk_id = avaliacao.id 
                
                where 
                    avaliacao.id = $avaliacaoId
                
                group by 
                    1,2,3,4,5,6,7,8,9,10,11 ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarAvaliacaoPeloParticipanteId($participanteId, $tipoQuestionarioId)
    {
        $db = Database::conexao();

        $sql = "select avaliacao.id                          			as avaliacao_id,
				       avaliacao.tipo_questionario_fk_id                as avaliacao_tipo_questionario_id,
				       avaliacao.observacao                  			as avaliacao_observacao,
				       to_char(avaliacao.data_avaliacao, 'dd/mm/YYYY') 	as avaliacao_data_avaliacao,             
				       avaliacao.fonte_informacao            			as avaliacao_fonte_informacao,
				       case avaliacao.fonte_informacao
				       		when 1 then 'Paciente'
				       		when 2 then 'cuidador'
				       		when 3 then 'Paciente e cuidador em proporções iguais'
				       end 												as avaliacao_fonte_informacao_descricao,
				       avaliacao.investigador                			as avaliacao_investigador,
				       avaliacao.local                       			as avaliacao_local,
				       avaliacao.finalizada     			            as avaliacao_finalizada,
				       avaliacao.medicamento						    as avaliacao_medicamento,
				       avaliacao.login_fk_id                            as avaliacao_login_id,
				       tipo_questionario.titulo                         as tipo_questionario_titulo
				from 
					   questionario.avaliacao
					   inner join questionario.tipo_questionario
					           on tipo_questionario.id = avaliacao.tipo_questionario_fk_id
				where 
					   avaliacao.participante_fk_id = $participanteId
					   and avaliacao.tipo_questionario_fk_id = $tipoQuestionarioId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarAvaliacaoPeloId($avaliacaoId)
    {
        $db = Database::conexao();

        $sql = "select avaliacao.id                          			as avaliacao_id,
				       avaliacao.tipo_questionario_fk_id                as avaliacao_tipo_questionario_id,
				       avaliacao.observacao                  			as avaliacao_observacao,
				       to_char(avaliacao.data_avaliacao, 'dd/mm/YYYY') 	as avaliacao_data_avaliacao,             
				       avaliacao.fonte_informacao            			as avaliacao_fonte_informacao,
				       case avaliacao.fonte_informacao
				       		when 1 then 'Paciente'
				       		when 2 then 'cuidador'
				       		when 3 then 'Paciente e cuidador em proporções iguais'
				       end 												as avaliacao_fonte_informacao_descricao,
				       avaliacao.investigador                			as avaliacao_investigador,
				       avaliacao.local                       			as avaliacao_local,
				       avaliacao.finalizada     			            as avaliacao_finalizada,
				       avaliacao.medicamento						    as avaliacao_medicamento,
				       avaliacao.login_fk_id                            as avaliacao_login_id,
				       individuo.id                                     as participante_id,
				       individuo.nome 									as participante_nome
				from 
					   questionario.avaliacao
					   inner join public.individuo 
					   		   on individuo.id = avaliacao.participante_fk_id
				where 
					   avaliacao.id = $avaliacaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($investigador, $participanteId, $dataAvaliacao, $fonteInformacao,
                                  $local, $medicamento, $observacao, $loginId, $tipoQuestionarioId)
    {
        $db = Database::conexao();

        $sql = "insert into questionario.avaliacao
				values (default, :investigador, :participanteId, :dataAvaliacao, :fonteInformacao, 
				        :local, :medicamento, :observacao, :finalizada, :loginId, :tipoQuestionario)
				returning id";

        $finalizada = "false";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":investigador", $investigador, PDO::PARAM_STR);
        $stmt->bindParam(":participanteId", $participanteId, PDO::PARAM_INT);
        $stmt->bindParam(":dataAvaliacao", $dataAvaliacao, PDO::PARAM_STR);
        $stmt->bindParam(":fonteInformacao", $fonteInformacao, PDO::PARAM_INT);
        $stmt->bindParam(":local", $local, PDO::PARAM_STR);
        $stmt->bindParam(":medicamento", $medicamento, PDO::PARAM_STR);
        $stmt->bindParam(":observacao", $observacao, PDO::PARAM_STR);
        $stmt->bindParam(":finalizada", $finalizada, PDO::PARAM_BOOL);
        $stmt->bindParam(":loginId", $loginId, PDO::PARAM_INT);
        $stmt->bindParam(":tipoQuestionario", $tipoQuestionarioId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($avaliacaoId, $investigador, $participanteId, $dataAvaliacao, $fonteInformacao,
                                  $local, $medicamento, $observacao, $loginId, $tipoQuestionarioId)
    {
        $db = Database::conexao();

        $sql = "update questionario.avaliacao
				set 
				    investigador = :investigador, 
				    participante_fk_id = :participanteId, 
				    data_avaliacao = :dataAvaliacao, 
				    fonte_informacao = :fonteInformacao, 
				    local = :local, 
				    medicamento = :medicamento, 
				    observacao = :observacao, 
				    finalizada = :finalizada, 
				    login_fk_id = :loginId, 
				    tipo_questionario_fk_id = :tipoQuestionario
				where id = :avaliacaoId ";

        $finalizada = "false";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":avaliacaoId", $avaliacaoId, PDO::PARAM_INT);
        $stmt->bindParam(":investigador", $investigador, PDO::PARAM_STR);
        $stmt->bindParam(":participanteId", $participanteId, PDO::PARAM_INT);
        $stmt->bindParam(":dataAvaliacao", $dataAvaliacao, PDO::PARAM_STR);
        $stmt->bindParam(":fonteInformacao", $fonteInformacao, PDO::PARAM_INT);
        $stmt->bindParam(":local", $local, PDO::PARAM_STR);
        $stmt->bindParam(":medicamento", $medicamento, PDO::PARAM_STR);
        $stmt->bindParam(":observacao", $observacao, PDO::PARAM_STR);
        $stmt->bindParam(":finalizada", $finalizada, PDO::PARAM_BOOL);
        $stmt->bindParam(":loginId", $loginId, PDO::PARAM_INT);
        $stmt->bindParam(":tipoQuestionario", $tipoQuestionarioId, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from questionario.avaliacao
				where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}