<?php

/**
 * Created by PhpStorm.
 * User: Joao
 * Date: 11/09/2017
 * Time: 21:48
 */
class PublicTipoSangue
{
    public static function consultarTipoSangue()
    {
        $db = Database::conexao();

        $sql = "select *
                from public.tipo_sangue
                order by tipo_sangue.tipo asc";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }
}