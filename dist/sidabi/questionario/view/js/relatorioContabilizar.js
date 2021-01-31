var resultadoTodasAvaliacoes = (function() {
	let publico = {};
	let privado = {};

	privado.pathRelContabilizar = "/sidabi/questionario/controller/ctrl_rel_contabilizar/";

	privado.relatorioTodasAvaliacoes = function() {
		let url = privado.pathRelContabilizar + "relatorioTodasAvaliacoes.php";
		let data = 'avaliacaoId=' + $("#avaliacaoId").val();
		$.post(url, data, function (response) {
			switch (response.status) {
				case 'ok':
					let temp = response.obj;
					$("#containerTipoRelatorio").empty().html(temp);
					break;

				case 'erro':
					bootbox.alert("Não foi possível retornar as informação da tela de relatório.");
					console.log("Erro: " + response.msg);
					break;
			}
		}).fail(function () {
			bootbox.alert("Não foi possível retornar as informação da tela de relatório.");
		});
	}

	// TODO - esta função já foi usada para buscar as avaliações do participante, verificar
	privado.bucarAvaliacao = function(participanteId)
	{
		let url = privado.pathRelContabilizar + "consultarAvaliacaoPeloParticipante.php";
		let data = 'avaliacaoId=' + $("#avaliacaoId").val();
			data += "&participanteId=" + participanteId;

		$.post(url, data, function (response) {
			switch (response.status) {
				case 'ok':
					let temp = response.obj;
					if (temp.length > 0)
					{
						let selQuestionario = $("#formFiltros #selQuestionario").empty();
						$.each(temp, function(index, value) {
							selQuestionario.append("<option value='" + value["questionario_id"] + "'>" + "Realização: " + value["questionario_data_avaliacao"] + " - Local: " + value["questionario_local"] + "</option>");
						});
					}else{
						$("#formFiltros #selQuestionario").html("<option value=''> Nenhum questionário foi respondido para o participante selecionado </option>");
					}
					break;

				case 'erro':
					bootbox.alert("Não foi possível retornar as informação da tela de relatório.");
					console.log("Erro: " + response.msg);
					break;
			}
		}).fail(function () {
			bootbox.alert("Não foi possível retornar as informação da tela de relatório.");
		});
	};

	privado.montarTodasAvaliacoes = function(tipoQuestionarioId, participanteId, dataInicio, dataFim)
	{
		let url = privado.pathRelContabilizar + "relatorioContabilizarMontarTodasAvaliacoes.php";
		let data = 'tipoQuestionarioId=' + tipoQuestionarioId + '&participanteId=' +
					participanteId + "&dataInicio=" + dataInicio + "&dataFim=" + dataFim;

		$.post(url, data, function (response) {
			switch (response.status) {
				case 'ok':
					let temp = response.obj;
					$("#containerTodasAvaliacoes").empty().html(temp);
					break;

				case 'erro':
					bootbox.alert(response.msg);
					break;
			}
		}).fail(function () {
			bootbox.alert("Não foi possível retornar as informação da tela de relatório.");
		});
	};

	$(document).ready(function() {

		$("#relatorioTodasAvaliacoes").click(function() {
			privado.relatorioTodasAvaliacoes();
		});

		$("#formFiltros #participante").delegate(".selected-remove", "click", function(e) {
			$("#containerTodasAvaliacoes").empty();
		});

		$("#btnConsultarTodasAvaliacoes").click(function() {
			let tipoQuestionarioId = $("#avaliacaoTipoQuestionario").val();
			let participanteId = $("#fk_participante").val();
			let dataInicio = $("#dataInicio").val();
			let dataFim = $("#dataFim").val();

			if (participanteId.length == 0) {
				bootbox.alert("É preciso selecionar um participante");
				return false;
			}

			privado.montarTodasAvaliacoes(tipoQuestionarioId, participanteId, dataInicio, dataFim);
		});

		$("#containerTodasAvaliacoes").delegate("#btnImprimirTodasAvaliacoes", "click", function(e) {
			e.preventDefault();
			e.stopPropagation();
			$("#areaImprimir").printThis({
				loadCSS: "/sidabi/questionario/view/css/relatorioPrint.css",
				printContainer: true
			});
		});

		$("#containerTodasAvaliacoes").delegate("#btnImprimirTodasAvaliacoesXls", "click", function(e) {
			e.preventDefault();
			e.stopPropagation();
			$("#areaImprimir").table2excel({
				name: "Relatório de avaliações",
				preserveColors: false,
				filename: "RelTodasAvaliacoes.xls"
			});
		});

		$(".date").mask("99/99/9999");
	});

	return publico;
})();