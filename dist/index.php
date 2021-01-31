<?php
	$recuperarAcesso = isset($_GET["h"]) ? ("?h=" . $_GET["h"]) : null;
	$recuperarAcesso .= isset($_GET["u"]) ? ("&u=" . $_GET["u"]) : null;
	header("Location: /sidabi/adm/controller/ctrl_tela_modulos/telaModulos.php" . $recuperarAcesso);
	exit;
?>
