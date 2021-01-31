<?php

/**
 * Created by PhpStorm.
 * User: Joao
 * Date: 17/04/2019
 * Time: 08:59
 */
class SidabiGrupoPesquisadoresLogin
{

    public static function consultarUsuarioNosGrupos()
    {
        $db = Database::conexao();

        $sql = "select
                      grupo_pesquisadores_login.id as grupo_pesquisadores_login_id,
                      grupo_pesquisadores.id as grupo_pesquisadores_id,
                      grupo_pesquisadores.nome as grupo_pesquisadores_nome,
                      login.id as login_id,
                      login.nome as login_nome,
                      login.email as login_email
                from
                      sidabi.grupo_pesquisadores
                      left join sidabi.grupo_pesquisadores_login
                             on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                      left join sidabi.login
                             on login.id = grupo_pesquisadores_login.login_fk_id
                order by 
                      grupo_pesquisadores.nome, login.usuario";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * @param $loginId
     * @param $grupoPesquisadoresIds
     * @return array|PDOStatement
     */
    public static function buscarGrupoPesquisadoresLogin($loginId, $grupoPesquisadoresIds)
    {
        $db = Database::conexao();

        $sql = "select *
                from sidabi.grupo_pesquisadores_login
                where grupo_pesquisadores_login.login_fk_id = $loginId
                      and grupo_pesquisadores_fk_id in ($grupoPesquisadoresIds)";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * Função que busca os grupos de um usuario passado e retorna os grupos com seus usuários
     * @param $loginId
     * @return array|PDOStatement
     */
    public static function consultarGruposDoUsuario($loginId)
    {
        $db = Database::conexao();
        $sql = "select
                      gpl.id as grupo_pesquisadores_login_id,
                      array_to_json(array(
                          select
                               login_fk_id
                          from
                               sidabi.grupo_pesquisadores_login
                          where
                               grupo_pesquisadores_login.grupo_pesquisadores_fk_id = gpl.grupo_pesquisadores_fk_id
                      )) as usuarios
                from
                      sidabi.grupo_pesquisadores_login gpl
                where
                      gpl.login_fk_id = $loginId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarUsuariosDoGrupo($grupoPesquisadoresId)
    {
        $db = Database::conexao();

        $sql = "select
                      login_fk_id
                from
                      sidabi.grupo_pesquisadores_login
                where
                      grupo_pesquisadores_fk_id = $grupoPesquisadoresId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarGrupoPesquisadoresLoginPeloId($grupoPesquisadoresLoginId) {
        $db = Database::conexao();

        $sql = "select *
                from sidabi.grupo_pesquisadores_login
                where id = $grupoPesquisadoresLoginId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }
    
    public static function verificarTuplaLoginGrupoPesquisadores($loginFkId, $grupoPesquisadoresFkId)
    {
        $db = Database::conexao();

        $sql = "select *
                from sidabi.grupo_pesquisadores_login
                where grupo_pesquisadores_login.login_fk_id = $loginFkId
                  and grupo_pesquisadores_login.grupo_pesquisadores_fk_id = $grupoPesquisadoresFkId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro)){
            if (!empty($filtro["login_id"])) {
                $temp .= " and grupo_pesquisadores_login.login_fk_id = ". $filtro["login_id"];
            }
            if (!empty($filtro["grupo_pesquisadores_id"])) {
                $temp .= " and grupo_pesquisadores_login.grupo_pesquisadores_fk_id = ". $filtro["grupo_pesquisadores_id"];
            }
            if (!empty($filtro["id"])) {
                $temp .= " and grupo_pesquisadores_login.id = ". $filtro["id"];
            }
        }
        $sql = "select 
                     grupo_pesquisadores_login.*,
                     login.usuario,
                     grupo.nome
                from sidabi.grupo_pesquisadores_login
                     inner join sidabi.login
                             on login.id = grupo_pesquisadores_login.login_fk_id
                     inner join sidabi.grupo
                             on grupo.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                
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
                from sidabi.grupo_pesquisadores_login";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($grupoPesquisadoresFkId, $loginFkId)
    {
        $db = Database::conexao();

        $sql = "insert into sidabi.grupo_pesquisadores_login 
				values (default, :grupo_pesquisadores_fk_id, :login_fk_Id)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":grupo_pesquisadores_fk_id", $grupoPesquisadoresFkId, PDO::PARAM_INT);
        $stmt->bindParam(":login_fk_Id", $loginFkId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($loginFkId, $grupoPesquisadoresFkId, $id)
    {
        $db = Database::conexao();

        $sql = "update sidabi.grupo_pesquisadores_login 
					set login_fk_Id = :login_fk_Id, 
						grupo_pesquisadores_fk_id = :grupo_pesquisadores_fk_id
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":login_fk_Id", $loginFkId, PDO::PARAM_INT);
        $stmt->bindParam(":grupo_pesquisadores_fk_id", $grupoPesquisadoresFkId, PDO::PARAM_INT);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from sidabi.grupo_pesquisadores_login where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}