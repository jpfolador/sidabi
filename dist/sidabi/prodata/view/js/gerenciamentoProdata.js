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

    gerenciaLogin = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: "../../controller/ctrl_config/gerenciaLogin.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        let temp = data.obj;
                        $("#containerConfiguracaoSidabi").empty().html(temp);
                    break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                    break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informações da tela de usuário.");
                        console.log("Erro: " + data.msg);
                    break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Usuário'");
            },
            complete:function() {}
        });
    };

    moduloSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: "../../controller/ctrl_config/moduloSidabi.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        var temp = data.obj;
                        $("#containerConfiguracaoSidabi").empty().html(temp);
                    break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                    break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informações da tela de módulo.");
                        console.log("Erro: " + data.msg);
                    break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Módulo'");
            },
            complete:function() {}
        });
    };

    menuSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: "../../controller/ctrl_config/menuSidabi.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        var temp = data.obj;
                        $("#containerConfiguracaoSidabi").empty().html(temp);
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informações do gerenciamento de telas.");
                        console.log("Erro: " + data.msg);
                        break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Tela'");
            },
            complete:function() {}
        });
    };

    permissaoSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: "../../controller/ctrl_config/permissaoSidabi.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        var temp = data.obj;
                        $("#containerConfiguracaoSidabi").empty().html(temp);
                    break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                    break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informações da tela de Permissão aos módulos.");
                        console.log("Erro: " + data.msg);
                    break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Permissão'");
            },
            complete:function() {}
        });
    };

    permissaoMenuSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: "../../controller/ctrl_config/permissaoMenuSidabi.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        var temp = data.obj;
                        $("#containerConfiguracaoSidabi").empty().html(temp);
                    break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                    break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informações do gerenciamento de 'Permissão da tela'");
                        console.log("Erro: " + data.msg);
                    break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Permissão da tela'");
            },
            complete:function() {}
        });
    };

    $("#loginSidabi").click(function() {
        cleanBugJqGrid();
        gerenciaLogin();
    });

    $("#moduloSidabi").click(function() {
        cleanBugJqGrid();
        moduloSidabi();
    });

    $("#permissaoSidabi").click(function() {
        cleanBugJqGrid();
        permissaoSidabi();
    });

    $("#menuSidabi").click(function() {
        cleanBugJqGrid();
        menuSidabi();
    });

    $("#permissaoMenuSidabi").click(function() {
        cleanBugJqGrid();
        permissaoMenuSidabi();
    });

});