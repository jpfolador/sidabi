$(document).ready(function() {
    $("#alertmod_jqGrid").hide();
    var cleanBugJqGrid = function()
    {
        $("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
        $("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
        $("body").find("#alertmod_jqGrid").hide();
    };

    var validarData = function (valor){
        let date = valor;
        let ardt = new Array();
        let ExpReg = new RegExp("(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/[12][0-9]{3}");
        ardt = date.split("/");
        let flag = true;
        if ( date.search(ExpReg) == -1){
            flag = false;
        }
        else if (((ardt[1]==4)||(ardt[1]==6)||(ardt[1]==9)||(ardt[1]==11))&&(ardt[0]>30))
            flag = false;
        else if ( ardt[1]==2) {
            if ((ardt[0]>28)&&((ardt[2]%4)!=0))
                flag = false;
            if ((ardt[0]>29)&&((ardt[2]%4)==0))
                flag = false;
        }
        return flag;
    };

    var consultarArquivos = function() {
        let temp = $("#formFiltrosBaixarArquivos input[name='chkGrupoPesquisador']:checked");
        let ids = '';
        if (temp.length > 0) {
            $.each(temp, function (i, v) {
                ids += v.value + ',';
            });
            ids = ids.substring(0, (ids.length - 1));
        }
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_gerenciamento/baixarArquivosConsultar.php",
            data: {
                responsavel: $("#fk_responsavel").val(),
                protocolo: $("#fk_protocolo").val(),
                grupoEstudo: $("#fk_grupoEstudo").val(),
                equipamento: $("#fk_equipamento").val(),
                participante: $("#fk_participante").val(),
                dataInicio: $("#dataInicio").val(),
                dataFim: $("#dataFim").val(),
                grupoPesquisadoresIndividual: $("#chkGrupoPesquisadorIndividual").is(":checked") ? $("#chkGrupoPesquisadorIndividual").val() : '',
                grupoPesquisadores: ids
            },
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        let temp = data.obj;
                        $("#containerResultado").empty().html(temp);
                        $("#btnCompactar").removeClass("hide");
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informação da tela de baixar arquivos" );
                        console.log("Erro: " + data.msg);
                        break;
                }
            },
            error: function(){
                bootbox.alert("Não foi possível carregar a tela de baixar arquivos");
            },
            complete:function() {}
        });
    };

    // $arquivo deve conter o caminho + nome do arquivo
    var apagarArquivoCompactado = function(arquivo)
    {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_gerenciamento/baixarArquivosApagarArquivoCompactado.php",
            data: {
                arquivo: arquivo
            },
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        // limpo
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        bootbox.alert("Não foi possível apagar arquivo temporário" );
                        console.log("Erro: " + data.msg);
                        break;
                }
            },
            error: function(){
                bootbox.alert("Não foi possível apagar o arquivo temporário");
            },
            complete:function() {}
        });
    };
    
    var baixarArquivos = function(sessaoIds)
    {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_gerenciamento/baixarArquivosDownload.php",
            data: {
                sessaoIds: sessaoIds
            },
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        window.location.href = data.obj;
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informação da tela de baixar arquivos" );
                        console.log("Erro: " + data.msg);
                        break;
                }
            },
            error: function(){
                bootbox.alert("Não foi possível baixar os arquivos");
            },
            complete:function(data) {
                bootbox.alert("Arquivos compactados com sucesso!");
                setTimeout(function(){
                    apagarArquivoCompactado(data.responseJSON.obj);
                }, 3000);

            }
        });
    };

    var limparFiltros = function() {
        $("#responsavel").find(".selected-remove").click();
        $("#protocolo").find(".selected-remove").click();
        $("#grupoEstudo").find(".selected-remove").click();
        $("#participante").find(".selected-remove").click();
        $("#equipamento").find(".selected-remove").click();
        $("#dataInicio").val("");
        $("#dataFim").val("");

        $("#containerResultado").empty();
        $("#btnCompactar").addClass("hide");
    };

    $("#dataInicio").mask("99/99/9999");
    $("#dataFim").mask("99/99/9999");

    $("#btnConsultar").click(function() {
        let dataInicio = $("#dataInicio").val();
        let dataFim = $("#dataFim").val();

        if ((dataInicio.length > 0) && (dataFim.length > 0)) {
            if (validarData(dataInicio) && validarData(dataFim)) {
                consultarArquivos();
            }else{
                bootbox.alert("O formato da data está inválido! Verifique (dia/mês/ano)");
                return false;
            }
        }else{
            consultarArquivos();
        }
    });

    $("#containerResultado").delegate("#chkTodos", "click", function() {
        $('#containerResultado input:checkbox').not(this).prop('checked', this.checked);
    });

    $("#btnLimpar").click(function() {
        limparFiltros();
    });

    $("#btnCompactar").click(function() {
        let len = $('#containerResultado input[type=checkbox]:checked').not("#chkTodos").length;
        if (len == 0) {
            bootbox.alert("Selecione os registros que você quer baixar os arquivos");
            return false;
        }

        sessaoIds = [];
        $('#containerResultado input[type=checkbox]:checked').not("#chkTodos").each(function(i, v) {
            sessaoIds.push( $(this).attr("data-sessao-id") );
        });

        baixarArquivos(sessaoIds);
    });

    $("#toogle-left-menu").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
    }).removeClass("hidden").addClass("visible-xs-inline");
});