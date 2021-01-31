var telaCriarQuestionario = (function() {
    let publico = {};
    let privado = {};

    privado.pathGerenciamento = "/sidabi/questionario/controller/ctrl_gerenciamento/";
    privado.pathAgrupamento = "/sidabi/questionario/controller/ctrl_agrupamento/";

    /*
    privado.getSubTelaAgrupamento = function() {
        return (typeof telaAgrupamento != "undefined") ? telaAgrupamento : null;
    }

    privado.inicializarSubTelaAgrupamento = function() {
        //Interface da subTela de consulta
        if ( privado.getSubTelaAgrupamento() ){
            telaAgrupamento.interfaces.selectItem = function( id , obj ){
                telaAgrupamento.popularItemObj( obj );
            }
        }
        else {
            console.warn("Objeto telaAgrupamento indefinido. Interface não implementada. ");
        }
    }
     */

    publico.carregarAgrupamentos = function() {
        let url = privado.pathAgrupamento + "agrupamento.php";
        let data = 'tipoQuestionarioId=' + $("#tipoQuestionario").val();
        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    let temp = response.obj;
                    $("#containerDadosQuestionario").empty().html(temp);
                break;

                case 'erro':
                    bootbox.alert("Não foi possível carregar os dados de agrupamentos.");
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar os agrupamentos do questionário");
        })
    };


    $(document).ready(function() {
        $("#tipoQuestionario").change(function() {
            if ($(this).val() !== '')
                publico.carregarAgrupamentos();
        });

    });

    return publico;
})();
