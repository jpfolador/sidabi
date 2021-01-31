$(function() {
    "use strict";
    let radioelem = function (value, options)
    {
        let div = $("<div style='margin: -15px 0 2px 10px;'></div>");

        let label = $("<label class='radio-inline'></label>");
        let radio = $("<input>", { type: "radio", value: "ativo", name: "status", id: "statusAtivo", checked: (value == 'ativo') });
        label.append(radio).append("Ativo");

        let label1 = $("<label class='radio-inline'></label>");
        let radio1 = $("<input>", { type: "radio", value: "inativo", name: "status", id: "statusInativo", checked: (value == 'inativo') });
        label1.append(radio1).append("Inativo");

        div.append(label).append(label1);

        return div;
    };

    let radiovalue = function(elem, operation, value)
    {
        if (operation === "set") {
            let radioButton = $(elem).find("input:radio[value='" + value + "']");
            if (radioButton.length > 0) {
                radioButton.prop("checked", true);
            }
        }

        if (operation === "get") {
            return $(elem).find("input:radio:checked").val();
        }
    };

    let $grid = $("#jqGrid");

    $grid.jqGrid({
        url: '../ctrl_gerenciamento/tipoQuestionarioJqGridLoad.php',
        editurl: '../ctrl_gerenciamento/tipoQuestionarioJqGridEdit.php',
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
                editable: false
            },
            {
                label: 'Título',
                name: 'titulo',
                width: 90,
                editable: true,
                editrules : { required: true },
                search: true,
                stype: 'text'
            },
            {
                label: 'Descrição',
                name: 'descricao',
                width: 120,
                editable: true,
                editrules : { required: true },
                search: true,
                edittype: 'textarea',
                stype: 'text'
            },
            {
                label: 'Endereço eletrônico',
                name: 'endereco_eletronico',
                width: 80,
                editable: true,
                editrules : { required: false },
                search: true,
                stype: 'text'
            },
            {
                label: 'Status',
                name: 'status',
                align: "center",
                width: 30,
                editable: true,
                sortable: true,
                edittype: 'custom',
                editoptions: {
                    custom_element: radioelem,
                    custom_value: radiovalue
                },
                editrules : { required: true },
                search: true,
                stype: 'select',
                searchoptions: {
                    value: ':Todos;ativo:Ativo;inativo:Inativo'
                }
            }
        ],
        guiStyle: "bootstrap",
        autowidth: true,
        rownumbers: false,
        caption: 'Tipo de aplicação',
        hidegrid: false,
        loadComplete: function () {
            $(this).triggerHandler('resize.jqGrid');
        },
        sortname: 'titulo',
        sortorder: 'asc',
        viewrecords: true,
        height: 370,
        rowNum: 10,
        pager: "#jqGridPager"
    }).jqGrid('filterToolbar', {defaultSearch:'cn'});

    $grid.navGrid('#jqGridPager',
        {
            edit: {PERMITE_EDITAR},
            add: {PERMITE_INCLUIR},
            del: {PERMITE_EXCLUIR},
            search: false,
            refresh: false,
            view: {PERMITE_VISUALIZAR},
            position: "left",
            cloneToTop: false
        },
        {
            editCaption: "Editar",
            width: "650",
            height: "auto",
            top: "30",
            left: "50",
            recreateForm: true,
            closeAfterEdit: true,
            errorTextFormat: function (data) {
                return 'Error: ' + data.responseText
            }
        },
        {
            editCaption: "Adicionar",
            width: "650",
            height: "auto",
            top: "30",
            left: "50",
            closeAfterAdd: true,
            recreateForm: true,
            errorTextFormat: function (data) {
                return 'Error: ' + data.responseText
            }
        },
        {
            editCaption: "Apagar",
            width: "500",
            height: "auto",
            top: "30",
            left: "50",
            errorTextFormat: function (data) {
                return 'Error: ' + data.responseText
            }
        });

    $(window).on('resize.jqGrid', function () {
        $grid.jqGrid('setGridWidth', $(".freeJqgridContainer").width() - 20);
    }).triggerHandler('resize.jqGrid');
});