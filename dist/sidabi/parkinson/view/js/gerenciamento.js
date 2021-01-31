$(document).ready(function() {
	
	$('#containerPrincipal').delegate("#verticalMenuIcon", 'click', function () {
		$("#wrapper").toggleClass(function() {
			if ( $(this).is(".toggled") ) {
				$("#verticalMenuIcon").find("span")
					.removeClass("glyphicon-chevron-left")
					.addClass("glyphicon-chevron-right");

				$("#verticalMenuIcon").css({
					"left": "3px",
					"height": $(window).height() - 52,
					'background-color': "#E7E6D8",
					'margin': "-7px -3px",
					'padding': "3px",
					'position': "absolute",
					'top': "58px"
				});

				$("#page-content-wrapper").css("left", "25px");
			} else {
				$("#verticalMenuIcon").find("span")
					.removeClass("glyphicon-chevron-right")
					.addClass("glyphicon-chevron-left");

				$("#verticalMenuIcon").css({
					"left": "207px",
					"height": "28px",
					'background-color': "none",
					'margin': "1px",
					'padding': "1px",
					'position': "relative",
					'top': "18px"
				});

				$("#page-content-wrapper").css("left", "0");
			}

			$("#containerGerencimento").find(".ui-jqgrid").css({"margin": "0 10px", "right":"12px"});
			$( window ).resize();
		});
	});

	cleanBugJqGrid = function() 
	{	
		$("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#alertmod_jqGrid").hide();
	};

	carregarMenu = function(menuId, menuNome, menuUrl) {
		$.ajax({
			dataType: "json",
			type: "post",
			url: menuUrl,
			data: {
				menuId: menuId
			},
			beforeSend: function() {},
			success: function(data) {
				switch (data.status)
				{
					case 'ok':
						var temp = data.obj;
						$("#containerGerencimento").empty().html(temp);
						break;

					case 'redir':
						window.location.href = '/sidabi/index.php';
						break;

					case 'erro':
						bootbox.alert("Não foi possível retornar as informação da tela de " + menuNome.trim());
						console.log("Erro: " + data.msg);
						break;
				}
			},
			error: function(){
				bootbox.alert("Não foi possível realização a ação da opção: " + menuNome.trim());
			},
			complete:function() {}
		});
	};

	$("#sidebar-wrapper").delegate(".itemMenu", "click", function () {
		var menuId = $(this).attr("data-menu-id");
		var menuNome = $(this).text();
		var menuUrl = $(this).attr("data-menu-url");

		carregarMenu(menuId, menuNome, menuUrl);
	});

});