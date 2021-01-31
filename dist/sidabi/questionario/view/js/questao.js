var telaQuestao = (function() {
    let publico = {};
    let privado = {};
    publico.interfaces = {};

    privado.pathQuestao = "/sidabi/questionario/controller/ctrl_questao/";

    // TODO - considerar apagar este arquivo

    privado.cancelarCadastroQuestao = function() {
        /*
        $("#agrupamentoDescricao").val("");
        $("#agrupamentoOrdem").val("");
        $("#agrupamentoStatus").val(1);

        $("#telaAgrupamento").find(".agrupamentoItem").removeClass("hide");
        $("#containerFormAgrupamento").addClass("hide");
         */
    };

    privado.salvarQuestao = function() {
        let url = privado.pathAgrupamento + "crudQuestao.php";
        let params = $("#formQuestao").serialize();
        //params += "&tipoQuestionario=" + $("#tipoQuestionario").val() + "&oper=add";
        $.post( url, params, function( response ) {
            switch (response.status)
            {
                case "ok":
                    let temp = response.obj;
                    telaCriarQuestionario.carregarAgrupamentos();
                break;

                case "erro":
                    bootbox.alert("Não foi possível salvar a questão");
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível salvar a questão.");
        })
    };

    $(document).ready(function() {

        //$("#telaQuestao").delegate(".liBtnEditarQuestao", "click", function () {
            //let agrupamentoId = $(this).parents().eq(1).attr("data-agrupamento-id");
            //alert("editar questao " );
       // });


    });

    return publico;
})();