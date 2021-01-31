var telaHomeBiodata = (function() {
    let publico = {};
    let privado = {};

    privado.randomColorGenerator = function(qtd) {
        let arr = [];
        for (let i = 0; i < qtd; i++) {
            arr.push( '#' + (Math.random().toString(16) + '0000000').slice(2, 8) );
        }
        return arr;
    };

    privado.showGraphSessaoPorEquipamentos = function() {
        $.post("../ctrl_home/dadosGraficoSessaoPorEquipamentos.php",function (response) {
            let data = response.obj;
            let name = [];
            let marks = [];

            if (data.length > 0) {
                for (let i in data) {
                    name.push(data[i].equipamento_nome);
                    marks.push(data[i].qtd_sessao);
                }
            }else{
                name = ['Equipamento 1', 'Equipamento 2', 'Equipamento 3'];
                marks = [3, 5, 2];
            }

            let arrColor = privado.randomColorGenerator(marks.length);
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

            let graficoSessaoPorEquipamentos = new Chart($("#graficoSessaoPorEquipamentos"), {
                type: 'horizontalBar',
                data: chartdata,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: false,
                    }
                }
            });
        });
    };

    privado.showGraphParticipantePorEstudo = function() {

        $.post("../ctrl_home/dadosGraficoParticipantePorGrupoEstudo.php",function (response) {
            let data = response.obj;
            let name = [];
            let marks = [];

            if (data.length > 0) {
                for (let i in data) {
                    name.push(data[i].grupo_estudo_nome);
                    marks.push(data[i].qtd_participante);
                }
            }else{
                name = ['Estudo A', 'Estudo B', 'Estudo C'];
                marks = [5, 7, 4];
            }

            let arrColor = privado.randomColorGenerator(marks.length);
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

            let graficoParticipantePorEstudo = new Chart( $("#graficoParticipantePorEstudo"), {
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

    privado.showGraphSessaoPorMeses = function() {

        $.post("../ctrl_home/dadosGraficoSessaoPorMeses.php",function (response) {
            let data = response.obj;
            let name = [];
            let marks = [];

            for (let i in data) {
                name.push(data[i].mes);
                marks.push(data[i].qtd_sessao);
            }

            let arrColor = privado.randomColorGenerator(marks.length);
            let chartdata = {
                labels: name,
                borderWidth: 3,

                datasets: [
                    {
                        borderColor: 'rgba(20,108,232,0.6)',
                        fill: false,
                        backgroundColor: arrColor,
                        data: marks
                    }
                ]
            };

            let graficoSessaoPorMeses = new Chart( $("#graficoSessaoPorMeses"), {
                type: 'line',
                data: chartdata,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: false
                    }
                }
            });
        });
    };

    $(document).ready(function() {
        privado.showGraphSessaoPorEquipamentos();
        privado.showGraphParticipantePorEstudo();
        privado.showGraphSessaoPorMeses();
    });

    return publico;
})();