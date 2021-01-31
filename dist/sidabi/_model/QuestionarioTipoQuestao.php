<?php


class QuestionarioTipoQuestao
{
    public static function consultarTodosRegistros()
    {
        $db = Database::conexao();

        $sql = "select *
				from questionario.tipo_questao";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);

        return $result;
    }
}