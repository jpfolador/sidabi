$(document).ready(function () {
    //Transforma cada div da classe .inline-search em um componente funcional
    $(".inline-search").each(function(){
        //Pega as opções definidas no elemento
        let inlineSearchName = $(this).attr("id");
        let resultsLimit =  $(this).attr("data-limit");
        let obrigatorio = $(this).attr("data-obrigatorio");
        //let inputWidth = $(this).attr("data-input-width-px") + "px";
        let inputWidthClass = $(this).attr("data-input-width-class");

        //Carrega a marcação do arquivo modelo
        $(this).load("../../../_resources/inlineSearch/inlineSearch.html", function() {
            //Altera as propriedades de acordo com as opções definidas
            $(this).find(".hidden-selected-id").attr("id", "fk_" + inlineSearchName);
            $(this).find(".hidden-selected-id").attr("name", "fk_" + inlineSearchName);
            $(this).find(".inline-search-paginator").attr("data-limit", resultsLimit);
            $(this).find(".search-bar").find(".input-group").addClass(inputWidthClass);
            $(this).find(".search-results").addClass(inputWidthClass);
            //$(this).find(".search-input").css("width", inputWidth);
            //$(this).find(".search-results").css("width", inputWidth);
            if (obrigatorio == "true"){
                $(this).find(".hidden-selected-id").addClass("obrigatorio");
                $(this).find(".hidden-selected-id").attr('required', true);
            }
        });
    });

    //Previne que os botões paginadores acionem o submit de formulário (ação padrão em alguns navegadores)
    $(".inline-search").delegate(".search-results .inline-search-paginator", "click", function(e){
        e.preventDefault();
    });
    
    //Ação do botão de pesquisa
    $(".inline-search").delegate(".search-button", "click", function(){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if (inlineSearchId){
            //Zera o offset do paginador e desabilita o botão "anterior"
            $("#"+inlineSearchId+" .inline-search-paginator .btn-prev").attr("disabled","disabled");
            $("#"+inlineSearchId+" .inline-search-paginator .btn-next").removeAttr("disabled");
            $("#"+inlineSearchId+" .inline-search-paginator").attr("data-offset", 0);
            $("#"+inlineSearchId+" .inline-search-paginator").attr("data-pages", "");
            let pageLimit = parseInt($("#"+inlineSearchId+" .inline-search-paginator").attr("data-limit"));
            let searchParam = $("#"+inlineSearchId+" .search-bar .search-input").val();
            let controllerUrl = $("#"+inlineSearchId).attr("data-controller-url");

            //Prepara as possíveis dependencias de pesquisa
            let dependencies = $("#"+inlineSearchId).attr("data-dependency");
            let searchDependencies = null;
            if(dependencies){
                searchDependencies = $(dependencies).serialize();
            }

            //Faz a busca a partir do inicio
            inlineSearchRequest(inlineSearchId, searchParam, 0, pageLimit, controllerUrl, searchDependencies);
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }
    });

    //Permite fechar os campos de pesquisa de chave estrangeira clicando fora do elemento
    $("body").click(function(event) {
        //Verifica se o elemento clicado é filho do container de resultados, senão, limpa os resultados e oculta a lista
        if (!$(event.target).closest('.inline-search .search-results').length) {
            $(".inline-search .search-results .results-list .result").remove();
            $(".inline-search .search-results").addClass("hide");
        }
    });

    //Seleciona um elemento usando o mouse
    $(".inline-search").delegate(".search-results .results-list .result", "mouseover", function(){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if (inlineSearchId) {
            $("#"+inlineSearchId+" .search-results .results-list .result").removeClass("selected");
            $(this).addClass("selected");
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }
    });

    //Ações do teclado na pesquisa
    $(".inline-search").delegate(".search-bar .search-input", "keydown", function(event){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if(inlineSearchId){
            //Mapeamento da tecla ENTER(13) para pesquisar
            if(event.keyCode == 13){
                //Impede que a tecla ENTER ative outros elementos
                event.preventDefault();
                //Se existe elemento selecionado, clica no elemento
                if ($("#"+inlineSearchId+" .search-results .results-list .result.selected").length) {
                    $("#"+inlineSearchId+" .search-results .results-list .result.selected").click();
                //Se não existe elemento selecionado, dispara nova pesquisa
                }else{
                    $("#"+inlineSearchId+" .search-bar .search-button").click();
                }
            }
            //Mapeamento da tecla ESC(27) para fechar os resultados da pesquisa
            if (event.keyCode == 27){
                //Limpa a lista de resultados e oculta a lista
                $("#"+inlineSearchId+" .search-results .results-list .result").remove();
                $("#"+inlineSearchId+" .search-results").addClass("hide");
            }
            //Tecla para esquerda
            if (event.keyCode == 37) {
                if ($("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-prev").is(":enabled")){
                    $("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-prev").click();
                }
            }
            //Tecla para pra direita
            if (event.keyCode == 39) {
                if ($("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-next").is(":enabled")){
                    $("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-next").click();
                }
            }
            //Tecla para cima
            if (event.keyCode == 38) {
                //Se nenhum elemento está selecionado, começa no final da lista
                if(!$("#"+inlineSearchId+" .search-results .results-list .result.selected").length){
                    //Marca o ultimo elemento como selecionado via teclado
                    $("#"+inlineSearchId+" .search-results .results-list .result").last(".result").addClass("selected");
                //Se existe elemento selecionado, seleciona o anterior
                }else{
                    //Armazena o elemento atualmente selecionado
                    let selected = $("#"+inlineSearchId+" .search-results .results-list .result.selected");
                    //Limpa o marcador de seleção de todos os resultados
                    $("#"+inlineSearchId+" .search-results .results-list .result").removeClass("selected");
                    //Se o elemento selecionado é o primeiro da lista
                    if (selected.prev(".result").length == 0) {
                        //Seleciona o ultimo elemento da lista
                        selected.siblings(".result").last(".result").addClass("selected");
                    //Se não é o primeiro
                    } else {
                        //Seleciona o anterior
                        selected.prev(".result").addClass("selected");
                    }
                }
            }
            //Tecla para baixo
            if (event.keyCode == 40) {
                //Se nenhum elemento está selecionado, começa no começo da lista
                if(!$("#"+inlineSearchId+" .search-results .results-list .result.selected").length){
                    //Marca o primeiro elemento como selecionado via teclado
                    $("#"+inlineSearchId+" .search-results .results-list .result").first(".result").addClass("selected");
                //Se existe elemento selecionado, seleciona o anterior
                }else{
                    //Armazena o elemento atualmente selecionado
                    let selected = $("#"+inlineSearchId+" .search-results .results-list .result.selected");
                    //Limpa o marcador de seleção de todos os resultados
                    $("#"+inlineSearchId+" .search-results .results-list .result").removeClass("selected");
                    //Se o elemento selecionado é o último da lista
                    if (selected.next(".result").length == 0) {
                        //Seleciona o ultimo elemento da lista
                        selected.siblings(".result").first(".result").addClass("selected");
                    //Se não é o último
                    } else {
                        //Seleciona o próximo
                        selected.next(".result").addClass("selected");
                    }
                }
            }
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }


    });

    //Ação do botão "Anterior"
    $(".inline-search").delegate(".search-results .inline-search-paginator .btn-prev", "click", function(){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if(inlineSearchId){
            let offsetAtual = parseInt($("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-offset")) || 0;
            let limitePagina = parseInt($("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-limit")) || 10;
            //Subtrai do novo offset o número de registros a serem mostrados
            let offsetNovo = offsetAtual - limitePagina;
            //Coloca o novo offset no paginador
            $("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-offset", offsetNovo);
            //habilita o botão "Próximo"
            if($("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-next").attr("disabled") !== undefined){
                $("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-next").removeAttr("disabled");
            }
            //Se o offset atual é menor que o limite, indica inicio da lista, desabilita o botão "Anterior"
            if (offsetAtual <= limitePagina){
                $("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-prev").attr("disabled","disabled");
            }
            //Faz a pesquisa passando o Offset atual menos o limite
            let searchParam = $("#"+inlineSearchId+" .search-bar .search-input").val();
            let controllerUrl = $("#"+inlineSearchId).attr("data-controller-url");

            //Prepara as possíveis dependencias de pesquisa
            let dependencies = $("#"+inlineSearchId).attr("data-dependency");
            let searchDependencies = null;
            if(dependencies){
                searchDependencies = $(dependencies).serialize();
            }

            inlineSearchRequest(inlineSearchId, searchParam, offsetNovo, limitePagina, controllerUrl, searchDependencies);
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }
    });

    //Ação do botão "Próximo"
    $(".inline-search").delegate(".search-results .inline-search-paginator .btn-next", "click", function(){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if(inlineSearchId){
            let offsetAtual = parseInt($("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-offset")) || 0;
            let limitePagina = parseInt($("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-limit")) || 10;
            let totalPaginas = $("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-pages");
            //Adiciona ao offset o número de registros a serem mostrados
            let offsetNovo = offsetAtual + limitePagina;
            $("#"+inlineSearchId+" .search-results .inline-search-paginator").attr("data-offset", offsetNovo);
            //Se a pagina atual for igual ao total de paginas, desabilita o botão "Próximo"
            if (((offsetNovo/limitePagina)+1) == totalPaginas){
                $("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-next").attr("disabled","disabled");
            }
            //Habilita o botão "Anterior"
            if($("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-prev").attr("disabled") !== undefined){
                $("#"+inlineSearchId+" .search-results .inline-search-paginator .btn-prev").removeAttr("disabled");
            }
            //Faz a pesquisa passando o Offset novo
            let searchParam = $("#"+inlineSearchId+" .search-bar .search-input").val();
            let controllerUrl = $("#"+inlineSearchId).attr("data-controller-url");

            //Prepara as possíveis dependencias de pesquisa
            let dependencies = $("#"+inlineSearchId).attr("data-dependency");
            let searchDependencies = null;
            if (dependencies){
                searchDependencies = $(dependencies).serialize();
            }

            inlineSearchRequest(inlineSearchId, searchParam, offsetNovo, limitePagina, controllerUrl, searchDependencies);
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }
    });

    //Seleção de um resultado da pesquisa
    $(".inline-search").delegate(".search-results .results-list .result", "click", function(){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if(inlineSearchId){
            //Separa numa variavel o id (pk) do elemento selecionado
            let resultadoClicado = $(this);
            let idResultadoClicado = resultadoClicado.attr("data-result-id");

            //Monta o elemento com a descrição do elemento selecionado e preenche o ID no campo oculto
            if ($("#"+inlineSearchId).attr("data-selected-complement") == "show"){
                $("#"+inlineSearchId+" .result-selected .selected-info").html(resultadoClicado.find(".result-content").html());
                $("#"+inlineSearchId+" .result-selected .selected-complement").html(resultadoClicado.attr("data-result-complement"));
                $("#"+inlineSearchId+" .hidden-selected-id").val(idResultadoClicado);
            }else{
                $("#"+inlineSearchId+" .result-selected .selected-info").html(resultadoClicado.find(".result-content").html());
                $("#"+inlineSearchId+" .hidden-selected-id").val(idResultadoClicado);
            }

            //Dispara o evento "change" do input hidden para ser usado por outros Scripts
            $("#"+inlineSearchId+" .hidden-selected-id").change();

            //Esconde o input e a lista de resultados
            $("#"+inlineSearchId+" .search-results").addClass("hide");
            $("#"+inlineSearchId+" .search-bar").addClass("hide");
            //Exibe o elemento selecionado
            $("#"+inlineSearchId+" .result-selected").removeClass("hide");
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }
    });

    //Ação do botão X que desfaz a seleção
    $(".inline-search").delegate(".result-selected .selected-remove", "click", function(){
        //Pega o ID do componente para delimitar a ação
        let inlineSearchId = $(this).closest(".inline-search").attr("id");
        if(inlineSearchId){
            //Separa numa variavel o elemento selecionado
            let selectedElement = $(this).closest(".result-selected");
            //Limpa o elemento removendo a seleção
            selectedElement.find(".selected-info").empty();
            selectedElement.find(".selected-complement").empty();
            //Limpa o input hidden com o valor selecionado
            $("#"+inlineSearchId+" .hidden-selected-id").val("");

            //Dispara o evento "change" do input hidden para ser usado por outros Scripts
            $("#"+inlineSearchId+" .hidden-selected-id").change();

            //Exibe o input de pesquisa
            $("#"+inlineSearchId+" .search-bar").removeClass("hide");  
            //Oculta o container de elemento selecionado
            $("#"+inlineSearchId+" .result-selected").addClass("hide");
            
            //Limpa a lista de resultados
            $("#"+inlineSearchId+" .search-results .results-list .result").remove();
        }else{
            alert("Não foi possível detectar o identificador do componente de pesquisa");
        }  
    });
});

//Função para selecionar (popular) automaticamente um elemento
inlineSearchSelect = function(inlineSearchId, selectedId, selectedData, selectedComplement) {
    //Monta um unico resultado de pesquisa usando os dados populados
    let model = $("#"+inlineSearchId+" .search-results .results-list .result-model");
    //Tranforma o modelo num item de resultado
    let temp = model.clone().removeClass("result-model");
    temp.addClass("result");                                    
    //Preenche os dados do resultado
    temp.attr("data-result-id", selectedId);
    if ($("#"+inlineSearchId).attr("data-selected-complement") == "show"){
        temp.attr("data-result-complement", selectedComplement);
    }
    temp.html(selectedData);
    //Marca o resultado como selecionado
    temp.addClass("selected");
    //Adiciona o resultado na lista de resultados
    $("#"+inlineSearchId+" .results-list").append(temp);
    //Clica no resultado selecionado
    $("#"+inlineSearchId+" .search-results .results-list .result.selected").click(); 
};

//********************************************************************************************************************************************
//* REQUISIÇÃO AJAX
//********************************************************************************************************************************************
inlineSearchRequest = function(srInlineSearchId, srSearchParam, srOffset, srLimit, srControllerUrl, srSearchDependencies) {
    $.ajax({
        dataType: 'json',
        url: srControllerUrl,
        type: "post",
        data: {
            searchParam: srSearchParam,
            offset: srOffset,
            limit: srLimit,
            dependenciesParam: srSearchDependencies
        },
        cache: false,
        beforeSend: function() {},
        success: function(data) {
            switch (data.status) {                        
                case "ok":                    
                    //Se foram encontrados resultados
                    if (data.obj.results.length > 0){   
                        //Remove a lista de resultados anteriores
                        $("#"+srInlineSearchId+" .results-empty").addClass("hide");
                        $("#"+srInlineSearchId+" .search-results .results-list .result").remove();

                        //Coloca numa variável a marcação modelo do resultado
                        let model = $("#"+srInlineSearchId+" .search-results .results-list .result-model");
                        //Percorre a lista de resultados encontrados
                        $.each(data.obj.results, function(key, value) {
                            //Tranforma o modelo num item de resultado
                            let temp = model.clone().removeClass("result-model");
                            temp.addClass("result");

                            //Preenche os dados do resultado
                            if($("#"+srInlineSearchId).attr("data-results-complement") == "show"){
                                //Preenche o conteúdo e complemento em colunas
                                temp.attr("data-result-id", value.id);
                                temp.find(".result-content").html(value.descricao);
                                temp.find(".result-complement").html(value.complemento);
                                temp.attr("data-result-complement", value.complemento);
                            }else{
                                //Preenche o conteúdo e oculta o complemento
                                temp.attr("data-result-id", value.id);
                                temp.find(".result-content").html(value.descricao);
                                temp.attr("data-result-complement", value.complemento);
                            }

                            //Adiciona o resultado na lista de resultados
                            $("#"+srInlineSearchId+" .results-list").append(temp);
                        });
                        
                        //Preenche as propriedades do paginador
                        $("#"+srInlineSearchId+" .search-results .inline-search-paginator").attr("data-pages", data.obj.total_pages);
                        $("#"+srInlineSearchId+" .search-results .inline-search-paginator").removeClass("hide");
                        if (data.obj.total_pages == 1){
                            $("#"+srInlineSearchId+" .search-results .inline-search-paginator button").attr("disabled", "disabled");
                            $("#"+srInlineSearchId+" .search-results .inline-search-paginator").addClass("hide");
                        }else{
                            $("#"+srInlineSearchId+" .search-results .inline-search-paginator .button").removeAttr("disabled");
                        }

                        //Mostra a lista de resultados
                        $("#"+srInlineSearchId+" .search-results").removeClass("hide");                                  
                    }                                        
                    //Se nenhum resultado foi encontrado, limpa os resultados e exibe mensagem de resultados vazios
                    else{
                        $("#"+srInlineSearchId+" .search-results .results-list .result").remove();
                        $("#"+srInlineSearchId+" .results-empty").removeClass("hide"); 
                    }                  
                    break;

                case "erro":
                    bootbox.alert(data.msg);
                    break;                            
            }
        },
        complete: function() {},
        error: function() {}
    });   
};