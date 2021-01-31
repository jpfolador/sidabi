var telaPrincipalGestaoPessoas = (function() {
	let publico = {};
	let privado = {};

	privado.cleanBugJqGrid = function()
	{
		$("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#alertmod_jqGrid").hide();
	};

	privado.telaPrincipal = function(toggle) {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_home/home.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudo").empty().html(temp);
						break;
					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
						break;
				}

			},
			error: function(){
				bootbox.alert("Não foi possível carregar a tela principal");
			},
			complete:function() {
				if (toggle) {
					$("button.navbar-toggle").click();
				}
			}
		});
	};

	privado.gerenciamento = function() {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_gerenciamento/gerenciamento.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudo").empty().html( temp );
						break;
					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível carregar as opções de gerenciamento de pessoas.");
			},
			complete:function() {
				$("button.navbar-toggle").click();
			}
		});
	};

	privado.sobre = function() {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_sobre/sobre.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudo").empty().html(temp);
						break;

					case 'erro':
						bootbox.alert("Não foi possível retornar as informação da tela sobre.");
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível carregar o menu sobre");
			},
			complete:function() {
				$("button.navbar-toggle").click();
			}
		});
	};

	privado.sair = function() {
		$.ajax({
			dataType: "html",
			type: "post",
			url: "/sidabi/adm/controller/ctrl_login/loginSair.php",
			beforeSend: function() {},
			success: function(data) {
				console.log("sessão finalizada");
				window.location = "/sidabi/index.php";
			},
			error: function(){
				bootbox.alert("Não foi possível sair do sistema");
			},
			complete:function() {}
		});
	};

	privado.alterMenuOption = function(obj)
	{
		let lis = obj.closest("ul").children('li');
		$.each(lis, function(index, value) {
			$(this).removeClass("active");
		});
		obj.parent().addClass("active");
	};

	$(document).ready(function() {

		$("#barraMenu").click(function(e) {
			if (!e) e = window.event;

			if (window.innerWidth > 753) {
				e.cancelBubble = true;
				if (e.stopPropagation)
					e.stopPropagation();
			}
		});

		$("#avaliacao, #gerenciamento, #sobre").click(function() {
			privado.cleanBugJqGrid();
			privado.alterMenuOption($(this));
		});

		$("#telaPrincipal").click(function() {
			privado.telaPrincipal(true);
		});

		$("#gerenciamento").click(function() {
			privado.gerenciamento();
		}).click();

		$("#sobre").click(function() {
			privado.sobre();
		});

		$("#sair").click(function() {
			privado.cleanBugJqGrid();
			privado.sair();
		});
	});

	return publico;
})();