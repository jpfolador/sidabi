var telaConsultarDados = (function() {
    let publico = {};
    let privado = {};

    privado.pathConsultarDados = "/sidabi/prodata/controller/ctrl_consultar_dados/";

    privado.consultarArquivos = function() {
        let url = privado.pathConsultarDados + "consultarDadosResultado.php";
        let data = $("#formFiltrosBaixarArquivos").serialize();
        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    let temp = response.obj;
                    $("#containerResultado").empty().html(temp);
                break;

                case 'erro':
                    bootbox.alert("Não foi possível carregar os dados. Tente atualizar a página e refazer o processo.");
                    console.log("Erro: " + response.msg);
                break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível carregar os dados.");
        })
    };

    privado.limparFiltros = function() {
        $("#idadeInicio").val("");
        $("#idadeFim").val("");
        $("#selTipoDado").prop('selectedIndex',0);
        $("#selSexo").prop('selectedIndex',0);
        $("#selTipoSanguineo").prop('selectedIndex',0);
        $("#selTipoDiagnostico").prop('selectedIndex',0);
        $("#estado").find(".search-input").val("").end().find(".selected-remove").click();
        $("#cidade").find(".search-input").val("").end().find(".selected-remove").click();
        $("#formFiltrosBaixarArquivos .chkGrupoPesq").prop("checked", false);
        $("#containerResultado").empty();
    };

    $(document).ready(function() {

        $("#btnConsultar").click(function() {
            let idadeInicio = $("#idadeInicio").val();
            let idadeFim = $("#idadeFim").val();

            if ((idadeInicio.length > 0) && (idadeFim.length > 0)) {
                idadeInicio *= 1;
                idadeFim *= 1;

                if (idadeInicio <= idadeFim) {
                    privado.consultarArquivos();
                }else{
                    bootbox.alert("Idade inicial deve ser maior que idade final");
                    return false;
                }
            }else{
                privado.consultarArquivos();
            }
        });

        $("#containerResultado").delegate("#chkTodos", "click", function() {
            $('input:checkbox').not(this).prop('checked', this.checked);
        });

        $("#btnLimpar").click(function() {
            privado.limparFiltros();
        });

    });

    return publico;
})();