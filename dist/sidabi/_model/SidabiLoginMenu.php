<?php

class SidabiLoginMenu
{
    /*
     * Função para buscar as telas e suas permimssão de um dado módulo e usuário
     */
    public static function buscarTelasPermitidasModulo($loginFkId, $moduloFkId)
    {
        $db = Database::conexao();
        $sql = "select 
                      login_menu.*
                from 
                      sidabi.login_menu
                where 
                      login_menu.menu_fk_id in 
                      (
                            select 
                                   menu.id
                            from
                                   sidabi.menu
                                   inner join sidabi.modulo 
                                           on modulo.id = menu.modulo_fk_id and modulo.status is true
                            where
                                   menu.modulo_fk_id = $moduloFkId
                      )
                      and login_menu.login_fk_id = $loginFkId ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * Lista as permissão para atribuir na tela
     */
    public static function listarPermissao($loginId, $menuId)
    {
        $db = Database::conexao();
        $sql = "select 
                       login_menu.*
                from
                       sidabi.login_menu
                       inner join sidabi.login
                               on login.id = login_menu.login_fk_id
                       inner join sidabi.menu
                               on menu.id = login_menu.menu_fk_id
                where
                       login.id = $loginId
                       and menu.id = $menuId
                order by
                       menu.ordem";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * buscar todos os menus que o usuário tem permissão
     */
    public static function carregarMenuPermitido($loginId, $moduloId)
    {
        $db = Database::conexao();
        $sql = "select 
                       menu.*,
                       login_menu.incluir,
                       login_menu.editar,
                       login_menu.visualizar,
                       login_menu.excluir
                from
                       sidabi.login_menu
                       inner join sidabi.login
                               on login.id = login_menu.login_fk_id
                       inner join sidabi.menu
                               on menu.id = login_menu.menu_fk_id
                where
                       login.id = $loginId
                       and menu.modulo_fk_id = $moduloId
                order by
                       menu.ordem";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro)){
            if (!empty($filtro["usuario"])) {
                $temp .= " and login_menu.login_fk_id = ". $filtro["usuario"];
            }
            if (!empty($filtro["menu_nome"])) {
                $temp .= " and login_menu.menu_fk_id = ". $filtro["menu_nome"];
            }
            if (!empty($filtro["incluir"])) {
                $temp .= " and login_menu.incluir = ". $filtro["incluir"];
            }
            if (!empty($filtro["editar"])) {
                $temp .= " and login_menu.editar = ". $filtro["editar"];
            }
            if (!empty($filtro["visualizar"])) {
                $temp .= " and login_menu.visualizar = ". $filtro["visualizar"];
            }
            if (!empty($filtro["excluir"])) {
                $temp .= " and login_menu.excluir = ". $filtro["excluir"];
            }
            if (!empty($filtro["id"])) {
                $temp .= " and login_menu.id = ". $filtro["id"];
            }
            if (!empty($filtro["moduloId"])) {
                $temp .= " and modulo.id = ". $filtro["moduloId"];
            }
        }
        $sql = "select 
                     login_menu.id,
                     case when login_menu.incluir = true then 'sim' else 'não' end incluir,
                     case when login_menu.visualizar = true then 'sim' else 'não' end visualizar,
                     case when login_menu.editar = true then 'sim' else 'não' end editar,
                     case when login_menu.excluir = true then 'sim' else 'não' end excluir,
                     login.usuario,
                     menu.id menu_id,
                     menu.nome menu_nome,
                     menu.url menu_url
                from sidabi.login_menu
                     inner join sidabi.login
                             on login.id = login_menu.login_fk_id
                     inner join sidabi.menu
                             on menu.id = login_menu.menu_fk_id
                     inner join sidabi.modulo
                             on modulo.id = menu.modulo_fk_id
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
                from sidabi.login_menu";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($loginFkId, $menuFkId, $incluir, $editar, $visualizar, $excluir)
    {
        $db = Database::conexao();

        $sql = "insert into sidabi.login_menu 
				values (default, :loginFkId, :menuFkId, :incluir, :editar, :visualizar, :excluir)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":loginFkId", $loginFkId, PDO::PARAM_INT);
        $stmt->bindParam(":menuFkId", $menuFkId, PDO::PARAM_INT);
        $stmt->bindParam(":incluir", $incluir, PDO::PARAM_BOOL);
        $stmt->bindParam(":editar", $editar, PDO::PARAM_BOOL);
        $stmt->bindParam(":visualizar", $visualizar, PDO::PARAM_BOOL);
        $stmt->bindParam(":excluir", $excluir, PDO::PARAM_BOOL);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($loginFkId, $menuFkId, $incluir, $editar, $visualizar, $excluir, $id)
    {
        $db = Database::conexao();

        $sql = "update sidabi.login_menu 
					set login_fk_id = :loginFkId, 
						menu_fk_id = :menuFkId,
						incluir = :incluir,
						editar = :editar,
						visualizar = :visualizar,
						excluir = :excluir
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":loginFkId", $loginFkId, PDO::PARAM_INT);
        $stmt->bindParam(":menuFkId", $menuFkId, PDO::PARAM_INT);
        $stmt->bindParam(":incluir", $incluir, PDO::PARAM_BOOL);
        $stmt->bindParam(":editar", $editar, PDO::PARAM_BOOL);
        $stmt->bindParam(":visualizar", $visualizar, PDO::PARAM_BOOL);
        $stmt->bindParam(":excluir", $excluir, PDO::PARAM_BOOL);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from sidabi.login_menu where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

}