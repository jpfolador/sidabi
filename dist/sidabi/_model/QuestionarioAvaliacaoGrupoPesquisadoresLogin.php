<?php

class QuestionarioAvaliacaoGrupoPesquisadoresLogin
{
    public static function consultarAvaliacaoGrupoPesquisadores($avaliacaoId)
    {
        $db = Database::conexao();

        $sql = "select * 
                from questionario.avaliacao_grupo_pesquisadores_login
				where avaliacao_fk_id = $avaliacaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($avaliacaoFkId, $grupoPesquisadoresLoginFkId)
    {
        $db = Database::conexao();

        $sql = "insert into questionario.avaliacao_grupo_pesquisadores_login
				values (default, :avaliacao_fk_id, :grupo_pesquisadores_login_fk_id)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":avaliacao_fk_id", $avaliacaoFkId, PDO::PARAM_INT);
        $stmt->bindParam(":grupo_pesquisadores_login_fk_id", $grupoPesquisadoresLoginFkId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function insertBatch($avaliacaoFkId, $grupoPesquisadoresLoginIds)
    {
        $db = Database::conexao();
        $db->beginTransaction();
        $output = '';
        
        $sql = "insert into questionario.avaliacao_grupo_pesquisadores_login
				values (default, :avaliacao_fk_id, :grupo_pesquisadores_login_fk_id)
				returning id";
        $stmt = $db->prepare($sql);

        try {
            foreach ($grupoPesquisadoresLoginIds as $id) {
                $id = (int) $id;
                $stmt->bindParam(":avaliacao_fk_id", $avaliacaoFkId, PDO::PARAM_INT);
                $stmt->bindParam(":grupo_pesquisadores_login_fk_id", $id, PDO::PARAM_INT);
                $stmt->execute();
            }
            $db->commit();

            $output = "Grupo de pesquisadores por avaliação criados com sucesso.";
        }catch(PDOExecption $e) {
            $db->rollback();
            $output = "Error ao vincular grupos de pesquisadores à avaliação. <br/>" . $e->getMessage();
        }

        return $output;
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from questionario.avaliacao_grupo_pesquisadores_login
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    /**
     * APAGAR todos os registros que tiverem o id da avaliação
     * @param $idAvaliacao - deve conter o id da sessão de coleta
     * @return int
     */
    public static function deletePeloAvaliacaoId($avaliacaoId)
    {
        $db = Database::conexao();

        $sql = "delete from questionario.avaliacao_grupo_pesquisadores_login
				where avaliacao_fk_id = :avaliacao_id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":avaliacao_id", $avaliacaoId, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}