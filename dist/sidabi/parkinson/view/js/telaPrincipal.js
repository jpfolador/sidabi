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

	// Carrega a lista de sintomas para o usuário visualizar os videos
	sintomas = function() {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_sintomas/listaSintomas.php",
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						var temp = data.obj;
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
				bootbox.alert("Não foi possível carregar a opção sintomas");
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
						var temp = data.obj;
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
				bootbox.alert("Não foi possível carregar a opção gerenciamento");
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
	        url: "../../controller/ctrl_sobre/sobre.php",
	        beforeSend: function() {},
	        success: function(data) {
	        	switch (data.status)
	        	{
	        		case 'ok':
						var temp = data.obj;
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
		var lis = obj.closest("ul").children('li');
		$.each(lis, function(index, value) {
			$(this).removeClass("active");
		});
		obj.parent().addClass("active");
	};
	
	$("#sintomas, #gerenciamento, #sobre").click(function() {
		cleanBugJqGrid();
		alterMenuOption($(this));
	});
	
	$("#sintomas").click(function() {
		sintomas();
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

	// chama a tela que lista os sintomas ao abrir o módulo
	sintomas()
});