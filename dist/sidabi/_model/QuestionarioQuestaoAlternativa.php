<?php

class QuestionarioQuestaoAlternativa
{
    public static function consultarTupla($questaoId, $alternativaId) {
        $db = Database::conexao();

        $sql = "select * 
                from questionario.questao_alternativa 
                where questao_fk_id = $questaoId 
                and alternativa_fk_id = $alternativaId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($questaoId, $alternativaId)
    {
        $db = Database::conexao();

        $sql = "insert into questionario.questao_alternativa 
                values (default, :questao_id, :alternativa_id)
                returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":questao_id", $questaoId, PDO::PARAM_INT);
        $stmt->bindParam(":alternativa_id", $alternativaId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($id, $questaoId, $alternativaId)
    {
        $db = Database::conexao();

        $sql = "update questionario.questao_alternativa 
					set questao_fk_id = :questao_id, 
						alternativa_fk_id = :alternativa_id,
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":questao_id", $questaoId, PDO::PARAM_INT);
        $stmt->bindParam(":alternativa_id", $alternativaId, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from questionario.questao_alternativa 
                where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}