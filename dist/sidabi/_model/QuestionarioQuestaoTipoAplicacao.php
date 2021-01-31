<?php

class QuestionarioQuestaoTipoAplicacao
{
    public static function buscarAssociacaoCadastrada($questaoId)
    {
        $db = Database::conexao();

        $sql = "select 
				      questao_tipo_aplicacao.id as questao_tipo_aplicacao_id,
				      tipo_aplicacao.id as tipo_aplicacao_id,
				      tipo_aplicacao.descricao as tipo_aplicacao_descricao,
				      tipo_aplicacao.sigla as tipo_aplicacao_sigla
				from 
				      questionario.questao_tipo_aplicacao 
				      inner join questionario.tipo_aplicacao
				              on tipo_aplicacao.id = questao_tipo_aplicacao.tipo_aplicacao_fk_id
				where 
				      questao_tipo_aplicacao.questao_fk_id = $questaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function verificarAssociacaoCadastrada($perguntaAlternativasIdsString)
    {
        $db = Database::conexao();

        $sql = "select pata.id
				from updrs.pergunta_alternativa_tipo_aplicacao pata
				where pata.pergunta_alternativa_fk_id in ($perguntaAlternativasIdsString)";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function buscarTipoAplicacaoQuestao($questaoId)
    {
        $db = Database::conexao();

        $sql = "select questao.id as questao_id,
                       questao_tipo_aplicacao.id as questao_tipo_aplicacao_id
                from 
                     questionario.questao
                     inner join questionario.questao_tipo_aplicacao
                     on questao_tipo_aplicacao.questao_fk_id = questao.id
                
                where
                     questao.id = $questaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($questaoId, $tipoAplicacaoId)
    {
        $db = Database::conexao();

        $sql = "insert into questionario.questao_tipo_aplicacao 
                values (default, :questao_id, :tipo_aplicacao_id)
                returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":questao_id", $questaoId, PDO::PARAM_INT);
        $stmt->bindParam(":tipo_aplicacao_id", $tipoAplicacaoId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($id, $questaoId, $tipoAplicacaoId)
    {
        $db = Database::conexao();

        $sql = "update questionario.questao_tipo_aplicacao 
				   set questao_fk_id = :questao_id, 
				       tipo_aplicacao_fk_id = :tipo_aplicacao_id,
                 where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":questao_id", $questaoId, PDO::PARAM_INT);
        $stmt->bindParam(":tipo_aplicacao_id", $tipoAplicacaoId, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from questionario.questao_tipo_aplicacao 
				where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}