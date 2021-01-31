var telaCriarQuestionario = (function() {
    let publico = {};
    let privado = {};

    privado.pathAvaliacao = "/sidabi/questionario/controller/ctrl_avaliacao/";
    privado.respostas = null;

    publico.carregarQuestoesAvaliacao = function(avaliacaoJaFinalizada) {
        let url = privado.pathAvaliacao + "montarQuestoesAvaliacao.php";
        let data = 'tipoQuestionarioId=' + $("#avaliacaoTipoQuestionario").val();
            data += '&avaliacaoId=' + $("#avaliacaoId").val();

        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    $("#containerQuestoesAvaliacao").empty().html(response.obj);

                    // Preencher as respostas caso elas existam.
                    if (privado.respostas !== null) {
                        $.each(privado.respostas, function(index, value) {
                            let elementId = "#alternativa-" + value.questao_fk_id + "-" + value.tipo_aplicacao_fk_id + "-" + value.alternativa_fk_id;

                            if ($("#containerQuestoesAvaliacao").find(elementId).attr("type") === 'radio') {
                                $("#containerQuestoesAvaliacao").find(elementId).attr("checked", true);
                            }else{
                                $("#containerQuestoesAvaliacao").find(elementId).val(value.alternativa_descritiva);
                            }
                        });
                    }
                    if (avaliacaoJaFinalizada === '1') {
                        publico.desabilitarForm("formQuestionario");
                    }
                    break;

                case 'erro':
                    bootbox.alert("Não foi possível carregar as questões. Tente atualizar e página e refazer o processo.");
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar as questões do questinário para essa avaliação.");
        });
    };

    privado.finalizarAvaliacao = function() {
        let url = privado.pathAvaliacao + "finalizarAvaliacao.php";
        let data = 'avaliacaoId=' + $("#avaliacaoId").val();
        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    bootbox.alert("Questionário finalizado com sucesso!", function () {
                        $("#msgAvaliacaoFinalizada").find(".msgNaoFinalizado").addClass("hide").end()
                                                    .find(".msgFinalizado").removeClass("hide");
                        publico.desabilitarForm("formQuestionario");
                    });

                    break;

                case 'erro':
                    bootbox.alert("Não foi possível finalizar o questionário.");
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível finalizar o questionário.");
        });
    };

    privado.cancelarAvaliacao = function() {
        let url = privado.pathAvaliacao + "cancelarAvaliacao.php";
        let data = 'avaliacaoId=' + $("#avaliacaoId").val();
        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    bootbox.alert("Avaliação apagada com sucesso!", function () {
                        privado.limparFormAvaliacao();
                        $("#containerQuestoesAvaliacao").empty();
                    });

                    break;

                case 'erro':
                    bootbox.alert("Não foi possível finalizar o questionário.");
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível finalizar o questionário.");
        });
    };

    privado.limparFormAvaliacao = function(flag) {
        $("#avaliacaoId").val('');
        if (flag === undefined)
            if ($("#fk_avaliacaoParticipante").val() !== '')
                $("#avaliacaoParticipante").find(".selected-remove").click();

        $("#avaliacaoLocal").val('');
        $("#avaliacaoDataAvaliacao").val('');
        $("#avaliacaoInvestigador").val('');
        $('#avaliacaoFontePrimaria').val('');
        $("#avaliacaoObservacao").val('');
        $("#avaliacaoMedicamento").val('');

        $("#grupo_pesquisadores input[type='checkbox']").prop("checked", false);
        $("#dadosParticipante").addClass("hide");
        $("#containerAvaliacoesRealizadas").addClass("hide");
    };

    /**
     * Ao carregar ou trocar o participante, se faz a busca por participantes
     */
    privado.bucarParticipante = function(participanteId, tipoQuestionarioId) {
        let url = privado.pathAvaliacao + "consultarParticipantePeloId.php";
        let params = "participanteId=" + participanteId + "&tipoQuestionarioId=" + tipoQuestionarioId;

        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    let participante = response.obj["participante"][0];
                    let avaliacao = response.obj["avaliacao"];

                    if ((avaliacao !== undefined) && (avaliacao.length > 0))
                    {
                        let option = null;
                        $("#selAvaliacoesRealizadas").empty().append("<option value=''> Escolha uma opção... </option>");
                        for (let i = 0; i < avaliacao.length; i++)
                        {
                            let desc = avaliacao[i].avaliacao_data_avaliacao + " - " + avaliacao[i].tipo_questionario_titulo + " - " + avaliacao[i].avaliacao_investigador;
                            option = "<option value='" + avaliacao[i].avaliacao_id + "'> " + desc + "</option>\n";
                            $("#selAvaliacoesRealizadas").append(option);
                        }

                        $("#containerAvaliacoesRealizadas").removeClass("hide");
                        $("#btnNovaAvaliacao").removeClass("hide");
                    }
                    else
                    {
                        $("#participanteDtNascimnto").html(participante.data_nascimento);
                        $("#participanteTelefone").html(participante.telefone);
                        $("#participanteDiagnostico").html(participante.diagnostico);
                        $("#participanteDtDiagnostico").html(participante.dt_diagnostico);
                        $("#participanteMedicoResponsavel").html(participante.medico_responsavel);
                        $("#participanteContatoMedico").html(participante.telefone_medico_responsavel);

                        $("#dadosParticipante").removeClass("hide");
                        $("#containerAvaliacoesRealizadas").addClass("hide");
                        $("#btnNovaAvaliacao").addClass("hide");
                    }
                    break;

                case "erro":
                    bootbox.alert("Não foi possível retornar as informação do participante.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar os dados do participante.");
        });
    };

    /**
     * Metodo para consultar a avaliação que já foi realizada e trazer seus dados e as respostas
     * @param avaliacaoId
     * @returns {boolean}
     */
    privado.buscarAvaliacaoRealizada = function(avaliacaoId)
    {
        let url = privado.pathAvaliacao + "buscarAvaliacaoRealizada.php";
        let params = "avaliacaoId=" + avaliacaoId;

        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    $("#grupo_pesquisadores input[type='checkbox']").prop("checked", false);
                    let avaliacao = response.obj;
                    // repassa as respostas para a variável deste script, montar após carregar o questionário.
                    privado.respostas = JSON.parse(avaliacao[0].respostas);

                    if ((avaliacao !== undefined) && (avaliacao.length > 0))
                    {
                        $("#avaliacaoLocal").val( avaliacao[0].avaliacao_local );
                        $("#avaliacaoDataAvaliacao").val( avaliacao[0].avaliacao_data_avaliacao );
                        $("#avaliacaoInvestigador").val( avaliacao[0].avaliacao_investigador );
                        $("#avaliacaoFontePrimaria").val( avaliacao[0].avaliacao_fonte_informacao );
                        $("#avaliacaoMedicamento").val( avaliacao[0].avaliacao_medicamento );
                        $("#avaliacaoObservacao").val( avaliacao[0].avaliacao_observacao );
                        $("#avaliacaoId").val( avaliacao[0].avaliacao_id );

                        if (avaliacao[0].grupo_pesquisadores !== undefined) {
                            let grupoPesquisadores = JSON.parse(avaliacao[0].grupo_pesquisadores);
                            if (grupoPesquisadores.length > 0) {
                                $.each(grupoPesquisadores, function (i, v) {
                                    $("#chkGrupoPesquisador_" + v).prop("checked", true);
                                });
                            }else{
                                $("#chkGrupoPesquisadorIndividual").prop("checked", true);
                            }
                        }

                        // Se o questionario já foi finalizado
                        if (avaliacao[0].avaliacao_finalizada === true) {
                            $("#msgAvaliacaoFinalizada").find(".msgFinalizado").removeClass("hide")
                                .end().find(".msgNaoFinalizado").addClass("hide");

                            publico.carregarQuestoesAvaliacao('1');
                            $("#btnContinuar").addClass("hide");
                            $("#btnComecar").addClass("hide");

                            $("#formAvaliacao #avaliacaoParticipante .result-selected .selected-remove").addClass("hide");
                            publico.desabilitarForm("formAvaliacao");
                            $("#btnNovaAvaliacao").prop("disabled", false);
                        }else{
                            $("#msgAvaliacaoFinalizada").find(".msgFinalizado").addClass("hide")
                                .end().find(".msgNaoFinalizado").removeClass("hide");

                            $("#btnContinuar").removeClass("hide");
                            $("#btnComecar").addClass("hide");
                        }
                    }
                    else
                    {
                        $("#btnContinuar").addClass("hide");
                        $("#btnComecar").removeClass("hide");
                    }
                    break;

                case "erro":
                    bootbox.alert("Não foi possível retornar as informação da avaliação.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar os dados da avaliação..");
        });
    };

    publico.desabilitarForm = function(nomeFormulario) {
        $("#" + nomeFormulario + " :input").prop("disabled", true);
    };

    publico.habilitarForm = function(nomeFormulario) {
        $("#" + nomeFormulario + " :input").prop("disabled", false);
    };

    privado.salvarQuestaoAlternativa = function(tipoQuestionarioId, avaliacaoId, questaoId,
                                                tipoAplicacaoId, alternativaId, textoQuestaoDescritiva)
    {
        let url = privado.pathAvaliacao + "salvarResposta.php";
        let data = 'tipoQuestionarioId=' + tipoQuestionarioId + '&avaliacaoId=' + avaliacaoId + '&questaoId=' + questaoId +
                   '&tipoAplicacaoId=' + tipoAplicacaoId + '&alternativaId=' + alternativaId + '&textoQuestaoDescritiva=' + textoQuestaoDescritiva;

        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    console.log(response.obj);
                    break;

                case 'erro':
                    bootbox.alert("Não foi possível salvar sua resposta.");
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível salvar sua resposta.");
        })
    };

    privado.ready2Submit = function(elements) {
        let ready = true;
        $.each(elements, function() {
            let el = $('[name=' + this + ']');
            switch( el[0].type ) {
                case 'checkbox':
                case 'radio':
                    if ( el.filter(':checked').length === 0 ) {
                        ready = false;
                    }
                    break;
                case 'text':
                    if ( el[0].value.trim().length === 0 ) {
                        ready = false;
                    }
                    break;
            }
        });

        return ready;
    };

    $(document).ready(function() {

        $("#avaliacaoDataAvaliacao").mask("99/99/9999");

        $("#avaliacaoParticipante").delegate(".selected-remove", "click", function() {
            privado.limparFormAvaliacao();
        });

        $("#selAvaliacoesRealizadas").change(function() {
            privado.buscarAvaliacaoRealizada( $(this).val() );
        });

        $("#formAvaliacao").delegate("#fk_avaliacaoParticipante", "change", function() {
            let tipoQuestionarioId = $("#avaliacaoTipoQuestionario").val();

            if (tipoQuestionarioId === '') {
                bootbox.alert("É preciso selecionar o 'tipo da avaliação'");
            }else{
                let participanteId = $(this).val();
                if (participanteId !== "")
                    privado.bucarParticipante(participanteId, tipoQuestionarioId);
            }
        });

        $("#btnComecar").click(function(e) {
            e.preventDefault();
            e.stopPropagation();
            // pegar os grupos de pesquisadores marcados
            let temp = $("#formAvaliacao input[name='chkGrupoPesquisador']:checked");
            let ids = '';
            if (temp.length > 0) {
                $.each(temp, function (i, v) {
                    ids += v.value + ',';
                });
                ids = ids.substring(0, (ids.length - 1));
            }
            let avaliacaoId = $("#avaliacaoId").val();
            let avaliacaoParticipanteId = $("#fk_avaliacaoParticipante").val();
            let avaliacaoTipoQuestionario = $('#avaliacaoTipoQuestionario option:selected').val();
            let avaliacaoLocal = $("#avaliacaoLocal").val();
            let avaliacaoDataAvaliacao = $("#avaliacaoDataAvaliacao").val();
            let avaliacaoInvestigador = $("#avaliacaoInvestigador").val();
            let avaliacaoFontePrimaria = $('#avaliacaoFontePrimaria option:selected').val();
            let avaliacaoMedicamento = $("#avaliacaoMedicamento").val();
            let avaliacaoObservacao = $("#avaliacaoObservacao").val();
            let chkGrupoPesquisadorIndividual = $("#chkGrupoPesquisadorIndividual").is(":checked") ? $("#chkGrupoPesquisadorIndividual").val() : '';
            let chkGrupoPesquisadores = ids;

            if ((avaliacaoTipoQuestionario === '') || (avaliacaoTipoQuestionario === undefined)) {
                bootbox.alert("É preciso escolher o tipo de questionário");
                return false;
            }
            if ((avaliacaoParticipanteId === '') || (avaliacaoParticipanteId === undefined)) {
                bootbox.alert("É preciso escolher um Participante / Paciente");
                return false;
            }
            if ((avaliacaoLocal === '') || (avaliacaoLocal === undefined)) {
                bootbox.alert("Informe o local");
                return false;
            }
            if ((avaliacaoDataAvaliacao === '') || (avaliacaoDataAvaliacao === undefined)) {
                bootbox.alert("A data da avaliação não pode ficar vazia!");
                return false;
            }
            if ((avaliacaoInvestigador === '') || (avaliacaoInvestigador === undefined)) {
                bootbox.alert("Informe o nome do investigador");
                return false;
            }
            if ((avaliacaoFontePrimaria === '') || (avaliacaoFontePrimaria === undefined)) {
                bootbox.alert("Escolha uma opção para fonte primária");
                return false;
            }
            if ((avaliacaoMedicamento === '') || (avaliacaoMedicamento === undefined)) {
                bootbox.alert("É preciso informar se está utilizando algum medicamento.");
                return false;
            }
            if ((chkGrupoPesquisadorIndividual === '') && (chkGrupoPesquisadores === '')) {
                bootbox.alert("É preciso informar se a avaliação será compartilhada com algum grupo de pesquisadores ou se permanecerá individual.");
                return false;
            }

            $.ajax({
                dataType: "json",
                type: "post",
                url: "../../controller/ctrl_avaliacao/salvarAvaliacao.php",
                data: {
                    avaliacaoId: avaliacaoId,
                    avaliacaoTipoQuestionario: avaliacaoTipoQuestionario,
                    avaliacaoParticipanteId: avaliacaoParticipanteId,
                    avaliacaoLocal: avaliacaoLocal,
                    avaliacaoDataAvaliacao: avaliacaoDataAvaliacao,
                    avaliacaoInvestigador: avaliacaoInvestigador,
                    avaliacaoFontePrimaria: avaliacaoFontePrimaria,
                    avaliacaoObservacao: avaliacaoObservacao,
                    avaliacaoMedicamento: avaliacaoMedicamento,
                    grupoPesquisadorIndividual: chkGrupoPesquisadorIndividual,
                    grupoPesquisadores: chkGrupoPesquisadores
                },
                beforeSend: function() {},
                success: function(data) {
                    switch (data.status)
                    {
                        case 'ok':
                            bootbox.alert("Avaliação salva com sucesso.", function () {
                                $("#formAvaliacao #avaliacaoParticipante .result-selected .selected-remove").addClass("hide");
                                publico.desabilitarForm("formAvaliacao");

                                // carregar a questionario
                                publico.carregarQuestoesAvaliacao('0');
                            });
                            $("#avaliacaoId").val(data.obj);
                            break;

                        case 'erro':
                            bootbox.alert(data.msg);
                            console.log("Erro: " + data.msg);
                            break;
                    }
                },
                error: function(){
                    bootbox.alert("Não foi possível começar a avaliação! Tente atualizar a página e refazer o processo");
                },
                complete:function() {
                    //$("#formAvaliacao").removeClass("hide");
                }
            });
        });

        $("#btnContinuar").click(function() {
            $("#btnComecar").click();
        });

        $("#btnNovaAvaliacao").click(function() {
            // esta flag serve para não recarregar o input do participante.
            privado.limparFormAvaliacao(1);
            publico.habilitarForm("formAvaliacao");
            $("#containerAvaliacoesRealizadas").addClass("hide");
            $("#containerQuestoesAvaliacao").empty();
            $("#msgAvaliacaoFinalizada").addClass("hide");

            $("#btnNovaAvaliacao").addClass("hide");
            $("#btnContinuar").addClass("hide");
            $("#btnComecar").removeClass("hide");
        });

        $("#btnCancelar").click(function() {
            bootbox.confirm("Ao apagar esta avaliação, as informações dela serão excluídas. Deseja realmente apagar esta avaliação?", function (result) {
                if (result === false) {
                    return;
                } else {
                    privado.cancelarAvaliacao($("#avaliacaoId").val());
                }
            });
        });

        $("#btnFinalizar").click(function() {
            // verifica se alguma questão ficou sem resposta
            let elements = $("#formQuestionario").find("input, select, textarea")
                .map( function(v, i) { return this.name; }).get();
            $.unique( elements );

            let pronto = privado.ready2Submit(elements);
            console.log( pronto );

            if ( !pronto )
            {
                bootbox.alert("Existe alguma questão sem resposta, verifique!", function () {
                    return;
                });
            }
            else
            {
                bootbox.confirm("Ao finalizar a avaliação ela não poderá mais ser alterada. Deseja finalizar esta avaliação?", function (result) {
                    if (result === false) {
                        return;
                    }else{
                        privado.finalizarAvaliacao($("#avaliacaoId").val());
                    }
                });
            }
        });

        $("#grupo_pesquisadores input").on('click', function() {
            $(this).trigger('click');

            if ($(this).attr("class") == 'chkIndividual') {
                if ( $(this).is(":checked") ) {
                    $("#grupo_pesquisadores").find(".chkGrupoPesq").prop("checked", false);
                }
            }
            if ($(this).attr("class") == 'chkGrupoPesq') {
                if ( $(this).is(":checked") ) {
                    $("#grupo_pesquisadores").find(".chkIndividual").prop("checked", false);
                }
            }
        });

        $("#formQuestionario").delegate(".altertivaRadio", "click", function() {
            let tipoQuestionarioId = $("#avaliacaoTipoQuestionario").val();
            let avaliacaoId = $("#avaliacaoId").val();
            let questaoId = $(this).attr("data-questao-id");
            let tipoAplicacaoId = $(this).attr("data-tipo-aplicacao-id");
            let alternativaId = $(this).attr("data-alternativa-id");
            let textoQuestaoDescritiva = "";

            privado.salvarQuestaoAlternativa(tipoQuestionarioId, avaliacaoId, questaoId, tipoAplicacaoId, alternativaId, textoQuestaoDescritiva);
        });

        $("#formQuestionario").delegate(".altertivaTexto", "blur", function() {
            let tipoQuestionarioId = $("#avaliacaoTipoQuestionario").val();
            let avaliacaoId = $("#avaliacaoId").val();
            let questaoId = $(this).attr("data-questao-id");
            let tipoAplicacaoId = $(this).attr("data-tipo-aplicacao-id");
            let alternativaId = $(this).attr("data-alternativa-id");
            let textoQuestaoDescritiva = $(this).val();

            privado.salvarQuestaoAlternativa(tipoQuestionarioId, avaliacaoId, questaoId, tipoAplicacaoId, alternativaId, textoQuestaoDescritiva);
        });
    });

    return publico;
})();
