<?php

class SidabiLoginModulo
{
    public static function verificarTuplaUsuarioModulo($loginFkId, $moduloFkId)
    {
        $db = Database::conexao();

        $sql = "select *
                from sidabi.login_modulo
                where login_modulo.login_fk_id = $loginFkId
                      and login_modulo.modulo_fk_id = $moduloFkId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function inserirPermissaoPadraoNoModulo($loginFkId, $paTelas)
    {
        $db = Database::conexao();

        $values = array();
        foreach($paTelas as $linha)
        {
            $menuId = $linha['id'];
            $_value = "(default, $loginFkId , $menuId, true, true, false, true)";
            array_push($values, $_value);
        }
        $values_ = implode(",", $values);

        $sql = "insert into sidabi.login_menu VALUES " . $values_;
        $stmt = $db->prepare($sql);

        return $stmt->execute();
        /*
        $sql = "";
        foreach ($paTelas as $linha)
        {
            $menuId = $linha['id'];
            $sql .= "insert into sidabi.login_menu
                     values (default, $loginFkId , $menuId, true, true, false, true); ";
        }
print_r($paTelas);
echo $sql;
exit;
        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
        */
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();
        $temp = 'where 1=1';
        if (!empty($filtro)){
            if (!empty($filtro["usuario"])) {
                $temp .= " and login_modulo.login_fk_id = ". $filtro["usuario"];
            }
            if (!empty($filtro["sigla"])) {
                $temp .= " and login_modulo.modulo_fk_id = ". $filtro["sigla"];
            }
            if (!empty($filtro["id"])) {
                $temp .= " and login_modulo.id = ". $filtro["id"];
            }
        }
        $sql = "select 
                     login_modulo.*,
                     login.usuario,
                     modulo.sigla
                from sidabi.login_modulo
                     inner join sidabi.login
                             on login.id = login_modulo.login_fk_id
                     inner join sidabi.modulo
                             on modulo.id = login_modulo.modulo_fk_id
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
                from sidabi.login_modulo";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($loginFkId, $moduloFkId)
    {
        $db = Database::conexao();

        $sql = "insert into sidabi.login_modulo 
				values (:login_fk_Id, :modulo_fk_id, default)
				returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":login_fk_Id", $loginFkId, PDO::PARAM_INT);
        $stmt->bindParam(":modulo_fk_id", $moduloFkId, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($loginFkId, $moduloFkId, $id)
    {
        $db = Database::conexao();

        $sql = "update sidabi.login_modulo 
					set login_fk_Id = :login_fk_Id, 
						modulo_fk_id = :modulo_fk_id
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":login_fk_Id", $loginFkId, PDO::PARAM_INT);
        $stmt->bindParam(":modulo_fk_id", $moduloFkId, PDO::PARAM_INT);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from sidabi.login_modulo where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

}