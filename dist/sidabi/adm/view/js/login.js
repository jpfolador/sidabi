$(document).ready(function() {

	//$("#alertmod_jqGrid").hide();
	loginAutenticar = function()
	{
		var usuario = $("#usuario").val();
		var senha = $("#senha").val();

		$.ajax({
	        dataType: "json",
	        type: "post",
	        url: "../../controller/ctrl_login/loginAutenticar.php",
	        data: {
	        	usuario: usuario,
	        	senha: senha
	        },
	        beforeSend: function() {},
	        success: function(data) {
	        	switch (data.status)
	        	{
	        		case 'ok':
						var temp = data.obj;
	        			window.location = temp;
						//$("#sairModulo").removeClass("hide");
	        		break;

	        		case 'erro':
	        			bootbox.alert(data.msg);
	        			console.log("Erro: " + data.msg);
	        		break;
	        	}

	        },
	        error: function(){
	        	bootbox.alert("Não foi possível realizar a autenticação. Tente atualizar a página e refazer o processo.");
	        },
	        complete:function() {}
	    });
	};

	recuperarAutenticacao = function()
	{
		var email = $("#email").val();

		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_login/loginRecuperar.php",
			data: {
				email: email
			},
			beforeSend: function() {
				$("#loader").removeClass("hide");
			},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						var temp = data.obj;
						bootbox.alert("Sua autenticação foi validada, verifique seu email!");
						$("#voltarLogin").click();
					break;

					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
					break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível processar a recuperação de sua autenticação. Tente atualizar a página e refazer o processo");
			},
			complete:function() {
				$("#loader").addClass("hide");
			}
		});
	};

	loginCadastrarNovaSenha = function (senha1, senha2, usuario) {
		$.ajax({
			dataType: "json",
			type: "post",
			url: "../../controller/ctrl_login/loginCadastrarNovaSenha.php",
			data: {
				senha1: senha1,
				senha2: senha2,
				usuario: usuario
			},
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						var temp = data.obj;
						bootbox.alert({
							message: "Sua senha foi gravada com sucesso. Faça a autenticação e acesse o sistema.",
							callback: function () {
								window.location.href = '/sidabi/index.php';
							}
						});
					break;

					case 'erro':
						bootbox.alert(data.msg);
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível processar o cadastro de sua autenticação. Tente atualizar a página e refazer o processo");
			},
			complete:function() { }
		});
	};

	$("#btnCadNovaSenha").click(function() {
		var senha1 = $.trim($("#senha1").val());
		var senha2 = $.trim($("#senha2").val());
		var usuario = $("#setUser").val();

		if (senha1 !== senha2) {
			bootbox.alert("As senhas informadas nos 2 campos devem ser identicas!");
			return false;
		}
		if (usuario == undefined || usuario.length == 0) {
			bootbox.alert("Erro ao buscar usuário! Tente recarregar o link de recuperação de senha novamente!");
			return false;
		}

		loginCadastrarNovaSenha(senha1, senha2, usuario);
	});

	$("#btnLogin").click(function() {
		loginAutenticar();
	});
	
	$("#senha").keyup(function(event){
	    if(event.keyCode == 13){
	        $("#btnLogin").click();
	    }
	});

	$("#btnRecuperar").click(function() {
		recuperarAutenticacao();
	});

	$("#voltarLogin").click(function () {
		$("#containerLogin").removeClass("hide");
		$("#esqueciSenha").removeClass("hide");
		$("#email").val('');
		$("#containerRecuperar").addClass("hide");
		$("#voltarLogin").addClass("hide");
		$("#loginTitulo").text("Autenticação");
	});

	$("#esqueciSenha").click(function() {
		$("#containerLogin").addClass("hide");
		$("#esqueciSenha").addClass("hide");
		$("#containerRecuperar").removeClass("hide");
		$("#voltarLogin").removeClass("hide");
		$("#loginTitulo").text("Recuperar senha");

		$("#email").focus();
	});
});