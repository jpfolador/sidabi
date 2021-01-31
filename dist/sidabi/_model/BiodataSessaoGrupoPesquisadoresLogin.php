<?php

class BiodataSessaoGrupoPesquisadoresLogin
{
    public static function listarArquivosMeusGrupos($usuarioLogado)
    {
        $db = Database::conexao();

        $sql = "";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":usuario_logado", $usuarioLogado, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($sessaoFkId, $grupoPesquisadoresLoginFkId)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.sessao_grupo_pesquisadores_login
				values (default, :sessao_fk_id, :grupo_pesquisadores_login_fk_id)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":sessao_fk_id", $sessaoFkId, PDO::PARAM_INT);
        $stmt->bindParam(":grupo_pesquisadores_login_fk_id", $grupoPesquisadoresLoginFkId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function insertBatch($sessaoFkId, $grupoPesquisadoresLoginIds)
    {
        $db = Database::conexao();
        $db->beginTransaction();
        $output = '';
        
        $sql = "insert into biodata.sessao_grupo_pesquisadores_login
				values (default, :sessao_fk_id, :grupo_pesquisadores_login_fk_id)
				returning id";
        $stmt = $db->prepare($sql);

        try {
            foreach ($grupoPesquisadoresLoginIds as $id) {
                $id = (int) $id;
                $stmt->bindParam(":sessao_fk_id", $sessaoFkId, PDO::PARAM_INT);
                $stmt->bindParam(":grupo_pesquisadores_login_fk_id", $id, PDO::PARAM_INT);
                $stmt->execute();
            }
            $db->commit();
            $output = "Grupo de pesquisadores por sessão criados com sucesso.";
        }catch(PDOExecption $e) {
            $db->rollback();
            $output = "Error ao vincular grupos de pesquisadores à sessão de coleta. <br/>" . $e->getMessage();
        }

        return $output;
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.sessao_grupo_pesquisadores_login
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    /**
     * APAGAR todos os registros que tiverem o id da sessao
     * @param $idSessao - deve conter o id da sessão de coleta
     * @return int
     */
    public static function deletePeloSessaoId($idSessao)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.sessao_grupo_pesquisadores_login
					where sessao_fk_id = :id_sessao";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id_sessao", $idSessao, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}