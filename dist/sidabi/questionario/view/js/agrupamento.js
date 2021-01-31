var telaAgrupamento = (function() {
    let publico = {};
    let privado = {};
    publico.interfaces = {};

    privado.pathAgrupamento = "/sidabi/questionario/controller/ctrl_agrupamento/";
    privado.pathQuestao = "/sidabi/questionario/controller/ctrl_questao/";
    privado.pathAlternativa = "/sidabi/questionario/controller/ctrl_alternativa/";

    /**
     * Todas as funções de CRUD de agrupamentos, quesões e alternativas
     * estão codificadas neste script
     */
    privado.limparFormAgrupamento = function() {
        $("#agrupamentoId").val("");
        $("#agrupamentoDescricao").val("");
        $("#agrupamentoOrdem").val("");
        $("#agrupamentoStatus").val(1);
    };
    privado.limparFormQuestao = function() {
        $("#formQuestaoAgrupamentoId").val("");
        $("#agrupamentoQuestaoTexto").html("");
        $("#questaoId").val("");
        $("#questaoTitulo").val("");
        $("#questaoDescricao").val("");
        $("#questaoInstrucao").val("");
        $("#questaoTipoQuestao").val("");
        $("#questaoOrdem").val("");
        $("#questaoContavel").val(1);
        $("#questaoStatus").val(1);
        // TODO - verificar isso
        $("#containerFormQuestao").find(".checkbox").attr("checked", false);
    };
    privado.limparFormAlternativa = function() {
        $("#questaoId").val("");
        $("#alternativaId").val("");
        $("#alternativaDescricao").val("");
        $("#alternativaOrdem").val("");
        $("#alternativaValor").val("");
        $("#alternativaStatus").val(1);
    };

    privado.cancelarCadastroAgrupamento = function() {
        privado.limparFormAgrupamento();

        $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
        $("#containerFormAgrupamento").addClass("hide");
    };
    privado.cancelarCadastroQuestao = function() {
        privado.limparFormQuestao();

        $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
        $("#containerFormAgrupamento").addClass("hide");
        $("#containerFormQuestao").addClass("hide");
    };
    privado.cancelarCadastroAlternativa = function() {
        privado.limparFormAlternativa();

        $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
        $("#containerFormAgrupamento").addClass("hide");
        $("#containerFormQuestão").addClass("hide");
        $("#containerFormAlternativa").addClass("hide");
    };

    privado.salvarAgrupamento = function() {
        let url = privado.pathAgrupamento + "crudAgrupamento.php";
        let params = $("#formAgrupamento").serialize();
            params += "&tipoQuestionario=" + $("#tipoQuestionario").val() + "&oper=add";
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    telaCriarQuestionario.carregarAgrupamentos();
                break;

                case "erro":
                    bootbox.alert("Não foi possível retornar as informação da tela sobre.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível salvar o agrupamento.");
        })
    };
    privado.salvarQuestao = function() {
        let url = privado.pathQuestao + "crudQuestao.php";
        let params = $("#formQuestao").serialize();
            params += "&oper=add";
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    //bootbox.alert("Dados salvos com sucesso.");
                    privado.limparFormQuestao();
                    publico.carregarQuestaoAgrupamento( response.obj.agrupamento_id );
                    $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
                    $("#containerFormQuestao").addClass("hide");
                break;

                case "erro":
                    bootbox.alert("Não foi possível salvar as informações da questão. <br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível salvar a questão.");
        })
    };
    privado.salvarAlternativa = function() {
        let url = privado.pathAlternativa + "crudAlternativa.php";
        let params = $("#formAlternativa").serialize();
            params += "&oper=add";
        $.post( url, params, function( response ) {
            console.log(response);
            switch (response.status)
            {
                case "ok":
                    //bootbox.alert("Dados salvos com sucesso.");
                    privado.limparFormAlternativa();
                    publico.carregarQuestaoAgrupamento( response.obj.agrupamento_id );
                    $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
                    $("#containerFormAlternativa").addClass("hide");
                break;

                case "erro":
                    bootbox.alert("Não foi possível salvar as informações da alternativa.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível salvar a alternativa.");
        })
    };
    privado.salvarAlternativaGrid = function(alternativaIds, questaoId) {
        let url = privado.pathAlternativa + "salvarAlternativasGrid.php";
        let params = "alternativaIds=" + alternativaIds + "&questaoId=" + questaoId;
        params += "&oper=add";
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    //bootbox.alert("Dados salvos com sucesso.");
                    privado.limparFormAlternativa();
                    publico.carregarQuestaoAgrupamento( response.obj.agrupamento_id );
                    $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
                    $("#containerFormAlternativa").addClass("hide");
                    break;

                case "erro":
                    bootbox.alert("Não foi possível salvar a(s) alternativa(s).<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível salvar a alternativa.");
        })
    };

    privado.popularFormAgrupamento = function(agrupamentoId) {
        let url = privado.pathAgrupamento + "popularAgrupamento.php";
        let params = "agrupamentoId=" + agrupamentoId;
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    $("#agrupamentoId").val(response.obj.id);
                    $("#agrupamentoDescricao").val(response.obj.descricao);
                    $("#agrupamentoOrdem").val(response.obj.ordem);
                    $("#agrupamentoStatus").val(response.obj.status === true ? 1 : 0);

                    $("#telaAgrupamento").find(".agrupamentoItem").addClass("hide");
                    $("#containerFormAgrupamento").removeClass("hide");
                    break;

                case "erro":
                    bootbox.alert("Não foi possível retornar as informação da tela.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar o agrupamento.");
        })
    };
    privado.popularFormQuestao = function(questaoId) {
        let url = privado.pathQuestao + "popularQuestao.php";
        let params = "questaoId=" + questaoId;
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    $("#questaoId").val(response.obj.id);
                    $("#formQuestaoAgrupamentoId").val(response.obj.agrupamento_fk_id);
                    $("#agrupamentoQuestaoTexto").html(response.obj.agrupamento_descricao);
                    $("#questaoNumero").val(response.obj.numero);
                    $("#questaoTitulo").val(response.obj.titulo);
                    $("#questaoDescricao").val(response.obj.descricao);
                    $("#questaoInstrucao").val(response.obj.instrucao);
                    $("#questaoTipoQuestao").val(response.obj.tipo_questao_fk_id);
                    $("#questaoOrdem").val(response.obj.ordem);
                    $("#questaoContavel").val(response.obj.contavel === true ? 1 : 0);
                    $("#questaoStatus").val(response.obj.status === true ? 1 : 0);

                    let arr = (JSON.parse(response.obj.tipo_aplicacao_array));
                    for (let i = 0; i < arr.length; i++) {
                        $("#questaoTipoAplicacao_" + arr[i]).attr("checked", true);
                    }

                    $("#telaAgrupamento").find(".agrupamentoItem").addClass("hide");
                    $("#containerFormQuestao").removeClass("hide");
                    break;

                case "erro":
                    bootbox.alert("Não foi possível retornar as informação da tela.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar a questão.");
        })
    };
    privado.popularFormAlternativa = function(alternativaId, questaoId) {
        let url = privado.pathAlternativa+ "popularAlternativa.php";
        let params = "alternativaId=" + alternativaId + "&questaoId=" + questaoId;
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    let questao = response.obj.questao;
                    let alternativa = response.obj.alternativa;

                    $("#formAlternativaQuestaoId").val(questao.id);
                    $("#alternativaQuestaoTexto").html(questao.descricao);
                    $("#alternativaId").val(alternativa.id);
                    $("#alternativaDescricao").val(alternativa.descricao);
                    $("#alternativaOrdem").val(alternativa.ordem);
                    $("#alternativaValor").val(alternativa.valor);
                    $("#alternativaStatus").val(alternativa.status === true ? 1 : 0);

                    $("#telaAgrupamento").find(".agrupamentoItem").addClass("hide");
                    $("#containerFormAlternativa").removeClass("hide");
                    break;

                case "erro":
                    bootbox.alert("Não foi possível retornar as informação da tela.<br/>" + response.msg);
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar a alternativa.");
        })
    };

    privado.excluirAgrupamento = function(agrupamentoId) {
        bootbox.confirm("Caso este agrupamento tenha questões e alternativas cadastradas, elas também serão excluídas. Você confirma a exclusão?", function(result) {
            if (result === false) {
                return;
            }else{
                let url = privado.pathAgrupamento + "crudAgrupamento.php";
                let params = "agrupamentoId=" + agrupamentoId + "&oper=del";
                $.post( url, params, function( response ) {
                    switch (response.status)
                    {
                        case "ok":
                            bootbox.alert("Dados do agrupamento excluídos com sucesso.");
                            telaCriarQuestionario.carregarAgrupamentos();
                            break;

                        case "erro":
                            bootbox.alert("Não foi possível excluir a alternativa.<br/>" + response.msg);
                            console.log("Erro: " + response.msg);
                            break;
                    }
                }).fail(function() {
                    bootbox.alert("Não foi possível excluir a alternativa.");
                });
            }
        });
    };
    privado.excluirQuestao = function(questaoId) {
        bootbox.confirm("Além da questão, todos as alternativas dela também serão excluidas. Você confirma a exclusão da questão?", function(result) {
            if (result === false) {
                return;
            }else{
                let url = privado.pathQuestao + "crudQuestao.php";
                let params = "&questaoId=" + questaoId + "&oper=del";
                $.post( url, params, function( response ) {
                    switch (response.status)
                    {
                        case "ok":
                            bootbox.alert("Dados excluídos com sucesso.");
                            publico.carregarQuestaoAgrupamento( response.obj.agrupamento_id );
                            $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
                            $("#containerFormAlternativa").addClass("hide");
                            break;

                        case "erro":
                            bootbox.alert("Não foi possível excluir a alternativa.<br/>" + response.msg);
                            console.log("Erro: " + response.msg);
                            break;
                    }
                }).fail(function() {
                    bootbox.alert("Não foi possível excluir a alternativa.");
                });
            }
        });
    };
    privado.excluirAlternativa = function(alternativaId, questaoId) {
        bootbox.confirm("Confirma a exclusão da alternativa?", function(result) {
            if (result === false) {
                return;
            }else{
                let url = privado.pathAlternativa + "crudAlternativa.php";
                let params = "alternativaId=" + alternativaId + "&questaoId=" + questaoId + "&oper=del";
                $.post( url, params, function( response ) {
                    switch (response.status)
                    {
                        case "ok":
                            bootbox.alert("Alternativa excluida com sucesso.");
                            publico.carregarQuestaoAgrupamento( response.obj.agrupamento_id );

                            $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
                            $("#containerFormAlternativa").addClass("hide");
                            break;

                        case "erro":
                            bootbox.alert("Não foi possível excluir a alternativa.<br/>" + response.msg);
                            console.log("Erro: " + response.msg);
                            break;
                    }
                }).fail(function() {
                    bootbox.alert("Não foi possível excluir a alternativa.");
                });
            }
        });
    };

    publico.carregarQuestaoAgrupamento = function(agrupamentoId) {
        let url = privado.pathQuestao + "carregarQuestaoAgrupamento.php";
        let params = "agrupamentoId=" + agrupamentoId;
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    let temp = response.obj;
                    $("#containerQuestoes_" + agrupamentoId).empty().html(temp);
                break;

                case "erro":
                    bootbox.alert("Não foi possível carregar as questões do agrupamento.");
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar as questões do agrupamento.");
        })
    };

    publico.jqGridAlternativa = function() {
        $(function() {
            "use strict";

            let $grid = $("#jqGrid");

            let getSelectedRows = function() {
                let grid = $("#jqGrid");
                let rowKey = grid.getGridParam("selrow");

                if (!rowKey)
                    bootbox.alert("Escolha as alternativas que você deseja.");
                else {
                    let selectedIDs = grid.getGridParam("selarrrow");
                    let alternativaIds = "";
                    for (let i = 0; i < selectedIDs.length; i++) {
                        if (i !== 0)
                            alternativaIds += ",";
                        alternativaIds += selectedIDs[i];
                    }
                    privado.salvarAlternativaGrid(alternativaIds, $("#formAlternativaQuestaoId").val());
                }
            };

            $grid.jqGrid({
                url: '../ctrl_gerenciamento/alternativaJqGridLoad.php',
                datatype: "json",
                mtype: "GET",
                page: 1,
                jsonReader: {
                    page: "obj.currpage",
                    total: "obj.totalpages",
                    records: "obj.totalrecords",
                    repeatitems: false,
                    root: "obj.rows",
                    cell: "cell",
                    id: "0"
                },
                colModel: [
                    {
                        label: 'ID',
                        name: 'id',
                        width: 20,
                        key: true,
                        editable: false,
                        hidden: true
                    },{
                        label: 'Descrição',
                        name: 'descricao',
                        width: 120,
                        editable: true,
                        editrules : { required: true },
                        search: true,
                        edittype: 'textarea',
                        stype: 'text'
                    },{
                        label: 'Valor',
                        name: 'valor',
                        width: 40,
                        search: true,
                        stype: 'text'
                    },{
                        label: 'Ordem',
                        name: 'ordem',
                        width: 40,
                        search: true,
                        stype: 'text'
                    },{
                        label: 'Status',
                        name: 'status',
                        align: "center",
                        width: 30,
                        search: true,
                        sortable: true,
                        stype: 'select',
                        searchoptions: {
                            value: ':Todos;ativo:Ativo;inativo:Inativo'
                        }
                    }
                ],
                guiStyle: "bootstrap",
                rownumbers: false,
                hidegrid: false,
                sortname: 'descricao',
                sortorder: 'asc',
                viewrecords: true,
                height: '300',
                rowNum: 10,
                multiselect: true,
                pager: "#jqGridPager"
            }).jqGrid('filterToolbar', { defaultSearch:'cn'});

            $("#btnAlternativasSelecionadas").click(function() {
                getSelectedRows();
            });

            $(window).on('resize.jqGrid', function () {
                $grid.jqGrid('setGridWidth', $(".freeJqgridContainer").width() - 20);
            }).triggerHandler('resize.jqGrid');
        });
    }

    $(document).ready(function() {
        // BEGIN - Controle de agrupamentos
        $("#telaAgrupamento").delegate(".btnAddAgrupamento", "click", function () {
            $("#telaAgrupamento").find(".agrupamentoItem").addClass("hide");
            $("#containerFormAgrupamento").removeClass("hide");
        });
        $("#telaAgrupamento").delegate("a.agrupamentoItemLink", "click", function () {
            let agrupamentoId = $(this).parents().eq(1).attr("data-agrupamento-id");
            publico.carregarQuestaoAgrupamento(agrupamentoId);
        });

        $("#telaAgrupamento").delegate(".liBtnEditarAgrupamento", "click", function () {
            let agrupamentoId = $(this).parents().eq(4).attr("data-agrupamento-id");
            privado.popularFormAgrupamento(agrupamentoId);
        });
        $("#telaAgrupamento").delegate(".liBtnExcluirAgrupamento", "click", function () {
            let agrupamentoId = $(this).parents().eq(4).attr("data-agrupamento-id");
            privado.excluirAgrupamento(agrupamentoId);
        });
        $("#telaAgrupamento").delegate(".liBtnAdicionarQuestao", "click", function () {
            let agrupamentoId = $(this).parents().eq(4).attr("data-agrupamento-id");
            let agrupamentoDescricao = $(this).parents().eq(4).find(".agrupamentoItemLink").html();

            $("#formQuestaoAgrupamentoId").val( agrupamentoId );
            $("#agrupamentoQuestaoTexto").html( agrupamentoDescricao );
            $("#telaAgrupamento").find(".agrupamentoItem").addClass("hide");
            $("#containerFormQuestao").removeClass("hide");
        });

        $("#btnAgrupamentoCancelar").click(function () {
            privado.cancelarCadastroAgrupamento();
        });

        $("#btnAgrupamentoSalvar").click(function () {
            privado.salvarAgrupamento();
        });
        // END - Controle de agrupamentos


        // BEGIN - Controle de questões
        $("#telaAgrupamento").delegate(".liBtnEditarQuestao", "click", function () {
            let questaoId = $(this).parents().eq(1).attr("data-questao-id");
            privado.popularFormQuestao(questaoId);
        });
        $("#telaAgrupamento").delegate(".liBtnExcluirQuestao", "click", function () {
            let questaoId = $(this).parents().eq(1).attr("data-questao-id");
            privado.excluirQuestao(questaoId);
        });
        $("#telaAgrupamento").delegate(".liBtnAdicionarAlternativa", "click", function () {
            let questaoId = $(this).parents().eq(1).attr("data-questao-id");
            let questaoTitulo = $(this).parents().eq(4).find(".tituloQuestao").html();

            $("#formAlternativaQuestaoId").val( questaoId );
            $("#alternativaQuestaoTexto").html( questaoTitulo );
            $("#telaAgrupamento").find(".agrupamentoItem").addClass("hide");
            $("#containerFormAlternativa").removeClass("hide");
        });
        $("#btnQuestaoCancelar").click(function () {
            privado.cancelarCadastroQuestao();
        });
        $("#btnQuestaoSalvar").click(function () {
           privado.salvarQuestao();
        });
        $("#questaoNumero").blur(function () {
            $("#questaoOrdem").val( $(this).val() );
        });

        // END - Controle de questões

        // BEGIN - Controle de alternativas
        $("#telaAgrupamento").delegate(".liBtnEditarAlternativa", "click", function () {
            let alternativaId = $(this).parents().eq(1).attr("data-alternativa-id");
            let questaoId = $(this).parents().eq(1).attr("data-questao-id");
            privado.popularFormAlternativa(alternativaId, questaoId);
        });
        $("#telaAgrupamento").delegate(".liBtnExcluirAlternativa", "click", function () {
            let alternativaId = $(this).parents().eq(1).attr("data-alternativa-id");
            let questaoId = $(this).parents().eq(1).attr("data-questao-id");
            privado.excluirAlternativa(alternativaId, questaoId);
        });

        $("#btnAlternativaCancelar").click(function () {
            privado.cancelarCadastroAlternativa();
        });
        $("#btnAlternativaSalvar").click(function () {
            privado.salvarAlternativa();
        });

        // END - Controle de alternativas
        $("#btnAbrirGrid").click(function () {
            $("#containerTabelaAlternativas").removeClass("hide");
            $(this).addClass("hide");
            $("#formAlternativa").addClass("hide");
            publico.jqGridAlternativa();
        });
        $("#btnFecharGrid").click(function () {
            $("#containerTabelaAlternativas").addClass("hide");
            $("#btnAbrirGrid").removeClass("hide");
            $("#formAlternativa").removeClass("hide");
        });
        $("#alternativaOrdem").blur(function () {
            $("#alternativaValor").val($(this).val() - 1);
        });

    });
    
    return publico;
})();
