<?php

/**
 * Created by PhpStorm.
 * User: Joao
 * Date: 02/02/2020
 * Time: 10:30
 */
class DataHora
{
    /**
     * Verifica se uma data é válida ou não
     * @param deve conter a data no formato BR string. Ex.: dd/mm/YYYY
     * @return bool
     */
    public static function validarData($data) {
        $data = explode("/", $data);
        $dia = $data[0];
        $mes = $data[1];
        $ano = $data[2];
        return checkdate($mes, $dia, $ano);
    }

    /**
     * Verifica se o formato de 24 é válido.
     * @param $hora - deve conter a hora no formato hh:mm
     * @return int
     */
    public static function hora24($hora) {
        return preg_match("/^(?:2[0-3]|[01][0-9]):[0-5][0-9]$/", $hora);
    }
}