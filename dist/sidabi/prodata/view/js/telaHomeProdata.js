
$(document).ready(function() {

	$("#barraMenu").click(function(e) {
		if (!e) var e = window.event;

		if (window.innerWidth > 753) {
			e.cancelBubble = true;
			if (e.stopPropagation)
				e.stopPropagation();
		}
	});

	cleanBugJqGrid = function()
	{
		$("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#alertmod_jqGrid").hide();
	};

	home = function() {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_main/home.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudo").empty().html(temp);
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
			complete:function() {
				$("button.navbar-toggle").click();
			}
		});
	};

	gerenciamento = function() {
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
						$("#conteudo").html(temp);
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
				bootbox.alert("Não foi possível carregar o menu de gerenciamento");
			},
			complete:function() {
				$("button.navbar-toggle").click();
			}
		});
	};

	sobre = function() {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_main/sobre.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						let temp = data.obj;
						$("#conteudo").empty().html(temp);
						break;

					case 'redir':
						window.location.href = '/sidabi/index.php';
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

	sair = function() {
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

	alterMenuOption = function(obj)
	{
		let lis = obj.closest("ul").children('li');
		$.each(lis, function(index, value) {
			$(this).removeClass("active");
		});
		obj.parent().addClass("active");
	};

	$("#home, #gerenciamento, #tutorial, #sobre").click(function() {
		cleanBugJqGrid();
		alterMenuOption($(this));
	});

	$("#home").click(function() {
		home();
	});

	$("#gerenciamento").click(function() {
		gerenciamento();
	});

	$("#sobre").click(function() {
		sobre();
	});

	$("#sair").click(function() {
		cleanBugJqGrid();
		sair();
	});

	$("#gerenciamento").click();
});