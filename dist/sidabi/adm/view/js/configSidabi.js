var telaInicialSidabiConfiguracao = (function() {
    let publico = {};
    let privado = {};

    privado.pathTelaModulos = "/sidabi/adm/controller/ctrl_tela_modulos/";
    privado.pathConfig = "/sidabi/adm/controller/ctrl_config/";

    publico.gerenciaLogin = function() {
        let url = privado.pathConfig + "gerenciaLogin.php";
        let data = null;
        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    let temp = response.obj;
                    $("#containerConfiguracaoSidabi").empty().html(temp);

                    break;

                case 'erro':
                    bootbox.alert("Não foi possível retornar as informações da tela de usuário.");
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível acessar a opção 'Usuário'");
        });
    };

    publico.gerenciaPerfil = function() {
        let url = privado.pathConfig + "gerenciaPerfil.php";
        let data = null;
        $.post( url, data, function( response ) {
            switch (response.status)
            {
                case 'ok':
                    let temp = response.obj;
                    $("#containerConfiguracaoSidabi").empty().html(temp);

                    break;

                case 'erro':
                    bootbox.alert("Não foi possível retornar as informações da tela de perfil.");
                    console.log("Erro: " + response.msg);
                    break;
            }
        }).fail(function() {
            bootbox.alert("Não foi possível acessar a opção 'Usuário'");
        });
    };

    publico.moduloSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: privado.pathConfig + "moduloSidabi.php",
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

    publico.menuSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: privado.pathConfig + "menuSidabi.php",
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

    publico.permissaoSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: privado.pathConfig + "permissaoSidabi.php",
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

    publico.permissaoMenuSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: privado.pathConfig + "permissaoMenuSidabi.php",
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

    publico.grupoPesquisadoresSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: privado.pathConfig + "grupoPesquisadoresSidabi.php",
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
                        bootbox.alert("Não foi possível retornar as informações da tela de grupo de pesquisadores.");
                        console.log("Erro: " + data.msg);
                        break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Grupo de pesquisadores'");
            },
            complete:function() {}
        });
    };

    publico.associarGrupoPesquisadoresLoginSidabi = function() {
        $.ajax({
            dataType: "json",
            type: "get",
            url: privado.pathConfig + "associarGrupoPesquisadoresLoginSidabi.php",
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
                        bootbox.alert("Não foi possível retornar as informações da tela de associar grupo de pesquisadores ao usuário.");
                        console.log("Erro: " + data.msg);
                        break;
                }

            },
            error: function(){
                bootbox.alert("Não foi possível acessar a opção 'Associar grupo de pesquisadores ao usuário'");
            },
            complete:function() {}
        });
    };

    publico.randomColorGenerator = function(qtd) {
        let arr = [];
        for (let i = 0; i < qtd; i++) {
            arr.push( '#' + (Math.random().toString(16) + '0000000').slice(2, 8) );
        }
        return arr;
    };

    publico.showGraphUserPefil = function() {
        $.post("./dadosGraficoQtdAlunos.php",function (response) {
            let data = response.obj;
            let name = [];
            let marks = [];

            if (data.length > 0) {
                for (let i in data) {
                    name.push(data[i].perfil_descricao);
                    marks.push(data[i].qtd_usuario);
                }
            }else{
                name = ['Perfil 1', 'Perfil 2', 'Perfil 3'];
                marks = [2, 4, 3];
            }

            let arrColor = publico.randomColorGenerator(marks.length);
            let chartdata = {
                labels: name,
                borderWidth: 1,
                datasets: [
                    {
                        backgroundColor: arrColor,
                        data: marks
                    }
                ]
            };

            let graphPerfil = new Chart($("#graficoQtdAlunos"), {
                type: 'pie',
                data: chartdata,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: true,
                        fillStyle: arrColor,
                        position: 'bottom',
                        labels: {
                            fontColor: 'black',
                            fontSize: 14
                        }
                    },
                    plugins: {
                        labels: {
                            // render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
                            render: 'percentage',
                            precision: 1,
                            position: 'border',
                            fontSize: 16,
                            fontColor: '#000'
                        }
                    }
                }
            });
        });
    };

    publico.showGraphUserGrupo = function() {

        $.post("./dadosGraficoQtdUsuarioGrupoPesquisadores.php",function (response) {
            let data = response.obj;
            let name = [];
            let marks = [];

            if (data.length > 0) {
                for (let i in data) {
                    name.push(data[i].grupo_pesquisadores_nome);
                    marks.push(data[i].qtd_usuario);
                }
            }else{
                name = ['Grupo A', 'Grupo B', 'Grupo C'];
                marks = [5, 3, 3];
            }

            let arrColor = publico.randomColorGenerator(marks.length);
            let chartdata = {
                labels: name,
                borderWidth: 1,
                datasets: [
                    {
                        backgroundColor: arrColor,
                        data: marks
                    }
                ]
            };

            let graphGrupo = new Chart( $("#graficoQtdAlunosGrupo"), {
                type: 'doughnut',
                data: chartdata,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: true,
                        fillStyle: arrColor,
                        position: 'bottom',
                        labels: {
                            fontColor: 'black',
                            fontSize: 14
                        }
                    },
                    plugins: {
                        labels: {
                            // render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
                            render: 'percentage',
                            precision: 1,
                            position: 'border',
                            fontSize: 16,
                            fontColor: '#000'
                        }
                    }
                }
            });
        });
    };

    $(document).ready(function() {

        publico.showGraphUserPefil();

        publico.showGraphUserGrupo();

        $("#loginSidabi").click(function() {
            publico.gerenciaLogin();
        });

        $("#perfil").click(function() {
            publico.gerenciaPerfil();
        });

        $("#moduloSidabi").click(function() {
            publico.moduloSidabi();
        });

        $("#permissaoSidabi").click(function() {
            publico.permissaoSidabi();
        });

        $("#menuSidabi").click(function() {
            publico.menuSidabi();
        });

        $("#permissaoMenuSidabi").click(function() {
            publico.permissaoMenuSidabi();
        });

        $("#grupoPesquisadoresSidabi").click(function() {
            publico.grupoPesquisadoresSidabi();
        });

        $("#associarGrupoPesquisadoresLoginSidabi").click(function() {
            publico.associarGrupoPesquisadoresLoginSidabi();
        });

        $("#toogle-left-menu").click(function(e) {
            e.preventDefault();
            e.stopPropagation();
            $("#wrapper").toggleClass("toggled");
        });

        $("#toogle-left-menu").removeClass("hidden").end().addClass("visible-xs-inline");
    });

    return publico;
})();