<?php

class Database
{
    protected static $db;

    private function __construct()
    {
        $db_host = "127.0.0.1";
        $db_nome = "postgres";
        $db_usuario = "postgres";
        $db_senha = "your_password_here";
        $db_driver = "pgsql";

        try
        {
            self::$db = new PDO("$db_driver:host=$db_host; dbname=$db_nome", $db_usuario, $db_senha);
            self::$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            //self::$db->exec('SET NAMES utf8');
        }
        catch (PDOException $e)
        {
            die("Connection Error: " . $e->getMessage());
        }
    }
    
    public static function conexao()
    {
        if (!self::$db)
        {
            new Database();
        }
        return self::$db;
    }
}