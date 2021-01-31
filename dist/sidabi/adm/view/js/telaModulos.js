var telaModulos = (function() {
	let publico = {};
	let privado = {};

	privado.pathTelaModulos = "/sidabi/adm/controller/ctrl_tela_modulos/";

	privado.sairModulo = function ()
	{
		$.ajax({
			dataType: "html",
			type: "post",
			url: "../../controller/ctrl_login/loginSair.php",
			beforeSend: function() {},
			success: function(data) {
				console.log("Sessão Finalizada");
				window.location = "/sidabi/index.php";
			},
			error: function(){
				bootbox.alert("Não foi possível finalizar a sessão");
			},
			complete:function() {}
		});
	};

	privado.configSidabi = function ()
	{
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_config/configSidabi.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudoModulo").empty().html(temp);
						break;
					case 'redir':
						window.location.href = '/sidabi/index.php';
						break;
					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível carregar o menu home");
			},
			complete:function() {}
		});
	};

	privado.dadosUsuario = function ()
	{
		$.ajax({
			dataType: "json",
			type: "post",
			url: privado.pathTelaModulos + "telaModuloDadosUsuario.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudoModulo").empty().html(temp);
						break;
					case 'redir':
						window.location.href = '/sidabi/index.php';
						break;
					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível 'abrir' os dados do usuário! Atualize a página e tente refazer o processo.");
			},
			complete:function() {}
		});
	};

	privado.salvarDadosUsuario = function () {
		let params = $("#formDadosUsuario").serialize();
		$.ajax({
			dataType: "json",
			type: "post",
			url: privado.pathTelaModulos + "telaModuloDadosUsuarioSalvar.php",
			data: params,
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						bootbox.alert({
							message: "Seus dados foram salvos com sucesso!",
							callback: function () {
								window.location.href = '/sidabi/index.php';
							}
						});
						break;
					case 'redir':
						window.location.href = '/sidabi/index.php';
						break;
					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível 'salvar' os dados do usuário! Atualize a página e tente refazer o processo.");
			},
			complete:function() {}
		});
	};

	$(document).ready(function() {

		$("#barraMenu").click(function(e) {
			if (!e) var e = window.event;

			if (window.innerWidth > 753) {
				e.cancelBubble = true;
				if (e.stopPropagation)
					e.stopPropagation();
			}
		});

		$("#sidabiModulo").click(function () {
			window.location.href = '/sidabi/index.php';
		});

		$("#usuarioLogado, #usuarioLogadoInicial").click(function () {
			privado.dadosUsuario();
		});

		$("#conteudoModulo").delegate(".modulo", "click", function() {
			$(location).attr('href', $(this).attr("data-modulo") + "?moduloId=" + $(this).attr("data-modulo-id"));
		});

		$("#sairModulo").click(function() {
			privado.sairModulo();
		});

		$("#configSidabi").click(function() {
			$("#alertmod_jqGridDetails").hide();
			privado.configSidabi();
		});

		$("#conteudoModulo").delegate("#btnCancelar", "click", function() {
			window.location.href = '/sidabi/index.php';
		});

		$("#conteudoModulo").delegate("#btnSalvar", "click", function() {
			privado.salvarDadosUsuario();
		});
	});

	return publico;
})();