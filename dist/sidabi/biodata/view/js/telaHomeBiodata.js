var telaPrincipalBiodata = (function() {
    let publico = {};
    let privado = {};

    privado.cleanBugJqGrid = function()
    {
        $("body").find("#editmodjqGrid").find(".ui-jqdialog-titlebar-close").click();
        $("body").find("#viewhdjqGrid").find(".ui-jqdialog-titlebar-close").click();
        $("body").find("#alertmod_jqGrid").hide();
    };

    privado.home = function() {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_home/home.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        let temp = data.obj;
                        $("#conteudo").empty().html(temp);
                        break;
                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;
                    case 'erro':
                        bootbox.alert(data.msg);
                        console.log("Erro: " + data.msg);
                        break;
                }
            },
            error: function(){
                bootbox.alert("Não foi possível carregar o menu principal");
            },
            complete:function() {
                $("button.navbar-toggle").click();
            }
        });
    };

    privado.gerenciamento = function() {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_gerenciamento/gerenciamento.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        let temp = data.obj;
                        $("#conteudo").html(temp);
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        bootbox.alert(data.msg);
                        console.log("Erro: " + data.msg);
                        break;
                }
            },
            error: function(){
                bootbox.alert("Não foi possível carregar o menu de gerenciamento");
            },
            complete:function() {
                $("button.navbar-toggle").click();
            }
        });
    };

    privado.sobre = function() {
        $.ajax({
            dataType: "json",
            type: "post",
            url: "../../controller/ctrl_sobre/sobre.php",
            beforeSend: function() {},
            success: function(data) {
                switch (data.status)
                {
                    case 'ok':
                        let temp = data.obj;
                        $("#conteudo").empty().html(temp);
                        break;

                    case 'redir':
                        window.location.href = '/sidabi/index.php';
                        break;

                    case 'erro':
                        bootbox.alert("Não foi possível retornar as informação da tela sobre.");
                        console.log("Erro: " + data.msg);
                        break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível carregar o menu sobre");
            },
            complete:function() {
                $("button.navbar-toggle").click();
            }
        });
    };

    privado.sair = function() {
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
            complete:function() {}
        });
    };

    privado.alterMenuOption = function(obj)
    {
        $('.navbar-collapse').collapse('hide');
        let lis = obj.closest("ul").children('li');
        $.each(lis, function(index, value) {
            $(this).removeClass("active");
        });
        obj.parent().addClass("active");
    };

    $(document).ready(function() {

        $("#barraMenu").click(function(e) {
            if (!e) var e = window.event;

            if (window.innerWidth > 753) {
                e.cancelBubble = true;
                if (e.stopPropagation)
                    e.stopPropagation();
            }
        });

        $("#home, #gerenciamento, #sobre").click(function() {
            privado.cleanBugJqGrid();
            privado.alterMenuOption($(this));
        });

        $("#home").click(function(e) {
            privado.home();
        });
        privado.home();

        $("#gerenciamento").click(function() {
            privado.gerenciamento();
        });

        $("#sobre").click(function() {
            privado.sobre();
        });

        $("#biodataSair").click(function() {
            privado.cleanBugJqGrid();
            privado.sair();
        });
    });

    return publico;
})();