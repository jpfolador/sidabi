
$(document).ready(function() {

	$("#barraMenu").click(function(e) {
		if (!e) var e = window.event;

		if (window.innerWidth > 753) {
			e.cancelBubble = true;
			if (e.stopPropagation)
				e.stopPropagation();
		}
	});

/*	let cleanBugJqGrid = function()
	{	
		$("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
		$("body").find("#alertmod_jqGrid").hide();
	};*/

	let carregarMenu = function(menuId, menuNome, menuUrl) {
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
						let temp = data.obj;
						$("#conteudoInova").empty().html(temp);
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

	$("#navbar").delegate(".itemMenu", "click", function () {
		let menuId = $(this).attr("data-menu-id");
		let menuNome = $(this).text();
		let menuUrl = $(this).attr("data-menu-url");

		carregarMenu(menuId, menuNome, menuUrl);
	});

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
			complete:function() {
				$("button.navbar-toggle").click();
			}
		});
	};

	let alterMenuOption = function(obj)
	{
		let lis = obj.closest("ul").children('li');
		$.each(lis, function(index, value) {
			$(this).removeClass("active");
		});
		obj.parent().addClass("active");
	};

	let randomColorGenerator = function(qtd) {
		let arr = [];
		for (let i = 0; i < qtd; i++) {
			arr.push( '#' + (Math.random().toString(16) + '0000000').slice(2, 8) );
		}
		return arr;
	};

	let showGraph = function() {
		$.post("./dataGrafico.php",function (reponse) {
			let data = reponse.obj;
			let name = [];
			let marks = [];

			if (data.length > 0) {
				for (let i in data) {
					name.push(data[i].setor_nome);
					marks.push(data[i].qtd_ideia);
				}
			}else{
				name = ['Setor A', 'Setor B', 'Setor C'];
				marks = [4, 9, 6];
			}

			let arrColor = randomColorGenerator(marks.length);
			let chartdata = {
				labels: name,
				borderWidth: 1,
				datasets: [
					{
						backgroundColor: arrColor,
						data: marks
					}
				]
			};

			let barGraph = new Chart($("#inovaGrafico"), {
				type: 'pie',
				data: chartdata,
				options: {
					legend: {
						display: true,
						fillStyle: arrColor,
						position: 'right',
						labels: {
							fontColor: 'black',
							fontSize: 14
						}
					},
					plugins: {
						labels: {
							// render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
							render: 'percentage',
							precision: 1,
							position: 'border',
							fontSize: 14,
							fontColor: '#000000'
						}
					}
				}
			});
		});
	};

	showGraph();

	$("#sairInova").click(function() {
		sair();
	});
});