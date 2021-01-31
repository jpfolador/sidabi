$(document).ready(function() {
	let cleanBugJqGrid = function()
	{
		$("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#alertmod_jqGrid").hide();
	};
	
	let avaliacao = function(toggle) {
		$.ajax({
	        dataType: "json",
	        type: "post",
	        url: "../../controller/ctrl_avaliacao/avaliacao.php",
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
	        			bootbox.alert(data.msg);
	        			console.log("Erro: " + data.msg);
	        		break;
	        	}
					
	        },
	        error: function(){
	        	bootbox.alert("Não foi possível carregar o menu home");
	        },
	        complete:function() {
	        	if (toggle) {
	        		$("button.navbar-toggle").click();
	        	}
            }
	    });
	};
	
	let gerenciamento = function() {
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
	        			$("#conteudo").empty().html( temp );
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
	        	bootbox.alert("Não foi possível carregar o questionário.");
	        },
	        complete:function() {
				$("button.navbar-toggle").click();
            }
	    });
	};

	let sobre = function() {
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

	let sair = function() {
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

	let alterMenuOption = function(obj)
	{
		var lis = obj.closest("ul").children('li');
		$.each(lis, function(index, value) {
			$(this).removeClass("active");
		});
		obj.parent().addClass("active");
	};

	$("#barraMenu").click(function(e) {
		if (!e) e = window.event;

		if (window.innerWidth > 753) {
			e.cancelBubble = true;
			if (e.stopPropagation)
				e.stopPropagation();
		}
	});
	
	$("#avaliacao, #gerenciamento, #sobre").click(function() {
		cleanBugJqGrid();
		alterMenuOption($(this));
	});
	
	$("#avaliacao").click(function() {
		avaliacao(true);
	});
		
	$("#gerenciamento").click(function() {
		gerenciamento();
	}).click();

	$("#sobre").click(function() {
		sobre(); 
	});

	$("#sair").click(function() {
		cleanBugJqGrid();
		sair();
	});
});