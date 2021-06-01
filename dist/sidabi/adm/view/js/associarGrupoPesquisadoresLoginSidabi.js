$(document).ready(function() {

    cleanBugJqGrid = function()
    {
        $("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
        $("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
        $("body").find("#alertmod_jqGrid").hide();
    };

    salvarAssociacaoPesquisadores = function(usuarios, grupoPesquisadores) {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_config/salvarGrupoPesquisadoresLoginSidabi.php",
            data: {
                usuarios: usuarios,
                grupoPesquisadores: grupoPesquisadores
            },
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        bootbox.alert({
                            title: "Informação",
                            message: "A associação foi salva com sucesso.",
                            callback: function() {
                                cleanBugJqGrid();
                                telaInicialSidabiConfiguracao.associarGrupoPesquisadoresLoginSidabi();
                            }
                        });
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        //bootbox.alert("Não foi possível salvar a associação dos grupos de pesquisadores.");
                        bootbox.alert({
                            title: "Atenção",
                            message: data.msg
                        });
                        break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível salvar as informações da associação de usuários ao grupo de pesquisadores.");
            },
            complete:function() {}
        });
    };

    confirmarExclusaoUsuario = function(grupoPesquisadoresLoginId) {
        bootbox.confirm({
            message: "Você confirma a exclusão deste usuário do grupo de pesquisadores?",
            callback: function (result) {
                if (result) {
                    excluirUsuarioDoGrupo(grupoPesquisadoresLoginId);
                }
            }
        });
    };
    excluirUsuarioDoGrupo = function(grupoPesquisadoresLoginId) {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_config/excluirGrupoPesquisadoresLoginSidabi.php",
            data: {
                grupoPesquisadoresLoginId: grupoPesquisadoresLoginId
            },
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        bootbox.alert({
                            title: "Informação",
                            message: "Usuário removido com sucesso.",
                            callback: function() {
                                cleanBugJqGrid();
                                telaInicialSidabiConfiguracao.associarGrupoPesquisadoresLoginSidabi();
                            }
                        });
                    break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                    break;

                    case 'erro':
                        bootbox.alert({
                            title: "Atenção",
                            message: data.msg
                        });
                    break;
                }
            },
            error: function(){
                bootbox.alert("Não foi possível excluir o usuário do grupo de pesquisadores.");
            },
            complete:function() {}
        });
    };

    $("#btnAssociarPesquisadores").click(function() {
        let usuarios = [];
        $.each( $("#containerUsuarios input[name='chkUsuario']:checked"), function(){
            usuarios.push( $(this).attr("data-login-id") );
        });

        let grupoPesquisadores = [];
        $.each( $("#containerGrupoPesquisadores input[name='chkGrupoPesquisadores']:checked"), function(){
            grupoPesquisadores.push( $(this).attr("data-grupo-pesquisador-id") );
        });

        salvarAssociacaoPesquisadores(usuarios, grupoPesquisadores);
    });

    $("#containerGrupoPesquisadores").on( "click", ".usuarioGrupoPesquisadoresDelete", function() {
        confirmarExclusaoUsuario( $(this).attr("data-grupo-pesquisadores-login-id") );
    });
});

