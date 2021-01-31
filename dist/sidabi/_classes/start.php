<?php
	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	// controle de sessão deve vir aqui
	define("_CLASSES", $_SERVER["DOCUMENT_ROOT"] . "/sidabi/_classes/");
	define("_MODELO", $_SERVER["DOCUMENT_ROOT"] . "/sidabi/_model/");
	
	function autoload($class)
	{
		if (file_exists(_CLASSES . $class . '.php')) {
			require_once(_CLASSES . $class . '.php');
		}
		if (file_exists(_MODELO . $class . '.php')) {
			require_once(_MODELO . $class . '.php');
		}
		return true;
	}
	
	function redirect($url, $statusCode=303)
	{
		header('Location: ' . $url, true, $statusCode);
		die();
	}

	spl_autoload_register('autoload');

	