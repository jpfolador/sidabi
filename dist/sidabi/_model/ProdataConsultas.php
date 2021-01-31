<?php


class ProdataConsultas
{
    public static function consultarDadosSidabi($arrayParam, $grupoPesquisadores, $operador, $tipoUsuario)
    {
        $db = Database::conexao();
        $sql = null;
        $temp = 'where 1=1 ';
        $usuarioLogado = $_SESSION["usuario_id"];

        // Filtros gerais da tela
        if (!empty($arrayParam["idadeInicio"]) && empty($arrayParam["idadeFim"])) {
            $temp .= " and extract(year from age(individuo.data_nascimento)) >= ". $arrayParam["idadeInicio"];
        }
        if (empty($arrayParam["idadeInicio"]) && !empty($arrayParam["idadeFim"])) {
            $temp .= " and extract(year from age(individuo.data_nascimento)) <= ". $arrayParam["idadeFim"];
        }
        if (!empty($arrayParam["idadeInicio"]) && !empty($arrayParam["idadeFim"])) {
            $temp .= " and extract(year from age(individuo.data_nascimento)) between {$arrayParam["idadeInicio"]} and {$arrayParam["idadeFim"]} ";
        }

        if (!empty($arrayParam["selSexo"])) {
            $temp .= " and individuo.sexo = '". $arrayParam["selSexo"] . "'";
        }
        if (!empty($arrayParam["selTipoSanguineo"])) {
            $temp .= " and tipo_sangue.id = ". $arrayParam["selTipoSanguineo"];
        }
        if (!empty($arrayParam["selTipoDiagnostico"])) {
            $temp .= " and individuo.diagnostico = ". $arrayParam["selTipoDiagnostico"];
        }
        if (!empty($arrayParam["fk_cidade"])) {
            $temp .= " and individuo.cidade_fk_id = ". $arrayParam["fk_cidade"];
        }

        // OEPRADOR
        // a -> individual e algum grupo marcado
        // n -> nenhum checkbox marcado
        // i -> individual selecionado, nenhum grupo marcado
        // g -> individual não selecionado, algum grupo marcado

        if ($arrayParam["selTipoDado"] == 1) {
            // Qualquer tipo de dado

            // Ajustes finos nos filtros de grpos de pesquisadores
            $innerJoinSessao = '';
            $tempSessao = '';
            $innerJoinAvaliacao = '';
            $tempAvaliacao = '';
            if ( !empty($grupoPesquisadores) || (($tipoUsuario === 'com') && ($operador == 'n')) ) {
                $innerJoinSessao = " left join biodata.sessao_grupo_pesquisadores_login
                                            on sessao_grupo_pesquisadores_login.sessao_fk_id = sessao.id
                                     left join sidabi.grupo_pesquisadores_login 
                                            on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                           and grupo_pesquisadores_login.ativo is true  
                                     left join sidabi.grupo_pesquisadores
                                            on sidabi.grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id ";

                $innerJoinAvaliacao = " left join questionario.avaliacao_grupo_pesquisadores_login
                                               on avaliacao_grupo_pesquisadores_login.avaliacao_fk_id = avaliacao.id
                                        left join sidabi.grupo_pesquisadores_login 
                                               on grupo_pesquisadores_login.id = avaliacao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                              and grupo_pesquisadores_login.ativo is true  
                                        left join sidabi.grupo_pesquisadores
                                               on sidabi.grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id ";
            }
            if ($operador == 'a') {
                $tempSessao .= " and (sessao.usuario_logado = ". $usuarioLogado . " or 
                                      sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ")) ";
                $tempAvaliacao .= " and (avaliacao.login_fk_id = ". $usuarioLogado . " or 
                                         sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ")) ";
            }
            if ($operador == 'n') {
                if ($tipoUsuario === 'com') {
                    // buscar meus grupos de pesquisadores
                    $resultado = BiodataSessao::consultarGrupoPesquisadores($usuarioLogado);
                    $listGrupoPesquisadores = '';
                    foreach ($resultado as $linha) {
                        $listGrupoPesquisadores .= $linha["grupo_pesquisadores_id"] . ",";
                    }
                    $listGrupoPesquisadores = substr($listGrupoPesquisadores, 0, -1);

                    $tempSessao .= " and (sessao.usuario_logado in (". $usuarioLogado . ") or 
                                          sidabi.grupo_pesquisadores.id in (". $listGrupoPesquisadores . ")) ";
                    $tempAvaliacao .= " and (avaliacao.login_fk_id in (". $usuarioLogado . ") or 
                                             sidabi.grupo_pesquisadores.id in (". $listGrupoPesquisadores . ")) ";
                }
                // se for administrador não passa 'and' para o 'where'
            }
            if ($operador == 'i') {
                $tempSessao .= " and sessao.usuario_logado in (". $usuarioLogado . ") ";
                $tempAvaliacao .= " and avaliacao.login_fk_id in (". $usuarioLogado . ") ";
            }
            if ($operador == 'g') {
                $temp .= " and sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ") ";
            }

            $sql = "select *
                    from (
                        -- sessao
                        select 
                            individuo.id as individuo_id,
                            individuo.nome as individuo_nome,
                            individuo.sexo as individuo_sexo,
                            to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento,
                            extract(year from age(individuo.data_nascimento)) as idade,
                            cidade.id as cidade_id,
                            cidade.nome || '/' || estado.sigla as cidade_estado,
                            case individuo.diagnostico
                                when 1 then 'Doença de Parkinson Idiopática'
                                when 2 then 'Parkinsonismo'
                                when 3 then 'Indivíduo Hígido'
                            end as diagnostico,
                            to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') as dt_diagnostico,
                            individuo.tipo_sangue_fk_id,
                            tipo_sangue.tipo tipo_sangue_descricao,
                            to_char(biodata.sessao.dt_sessao, 'dd/mm/YYYY') as data_cadastro,
                            case when trim(biodata.sessao.nome_arquivo) != '' then 
                                biodata.sessao.nome_arquivo
                            else
                                '-'
                            end arquivo,
                            'arquivo' as tipo_dado
                        
                        from 
                            public.individuo
                            inner join public.cidade 
                                    on cidade.id = individuo.cidade_fk_id
                            inner join public.estado 
                                    on estado.id = cidade.estado_fk_id
                            inner join public.tipo_sangue
                                    on tipo_sangue.id = individuo.tipo_sangue_fk_id
                            inner join biodata.sessao
                                    on biodata.sessao.participante_fk_id = public.individuo.id
                            inner join sidabi.login
                                    on login.id = sessao.usuario_logado        
                            $innerJoinSessao        
                        
                        $temp
                        $tempSessao
                        
                        union  
                        
                        -- avaliacao
                        select 
                            individuo.id as individuo_id,
                            individuo.nome as individuo_nome,
                            individuo.sexo as individuo_sexo,
                            to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento,
                            extract(year from age(individuo.data_nascimento)) as idade,
                            cidade.id as cidade_id,
                            cidade.nome || '/' || estado.sigla as cidade_estado,
                            case individuo.diagnostico
                                when 1 then 'Doença de Parkinson Idiopática'
                                when 2 then 'Parkinsonismo'
                                when 3 then 'Indivíduo Hígido'
                            end as diagnostico,
                            to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') as dt_diagnostico,
                            individuo.tipo_sangue_fk_id,
                            tipo_sangue.tipo tipo_sangue_descricao,
                            to_char(questionario.avaliacao.data_avaliacao, 'dd/mm/YYYY') as data_cadastro,
                            questionario.tipo_questionario.titulo as arquivo,
                            'avaliacao' as tipo_dado
                        
                        from 
                            public.individuo
                            inner join public.cidade 
                                    on cidade.id = individuo.cidade_fk_id
                            inner join public.estado 
                                    on estado.id = cidade.estado_fk_id
                            inner join public.tipo_sangue
                                    on tipo_sangue.id = individuo.tipo_sangue_fk_id
                            inner join questionario.avaliacao
                                    on questionario.avaliacao.participante_fk_id = public.individuo.id
                            inner join questionario.tipo_questionario
                                    on questionario.tipo_questionario.id = questionario.avaliacao.tipo_questionario_fk_id
                            inner join sidabi.login
                                    on login.id = avaliacao.login_fk_id
                            $innerJoinAvaliacao
                    
                        $temp
                        $tempAvaliacao
                        
                    ) as temp
                    
                    order by 
                        individuo_nome, data_nascimento ";
        }

        if (($arrayParam["selTipoDado"] > 1) && ($arrayParam["selTipoDado"] < 9)) {
            // Condição para os formatos de arquivos

            // Ajuste finos nos filtros de grupos
            $innerJoinSessao = '';
            if ( !empty($grupoPesquisadores) || (($tipoUsuario === 'com') && ($operador == 'n')) ) {
                $innerJoinSessao = " left join biodata.sessao_grupo_pesquisadores_login
                                            on sessao_grupo_pesquisadores_login.sessao_fk_id = sessao.id
                                     left join sidabi.grupo_pesquisadores_login 
                                            on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                           and grupo_pesquisadores_login.ativo is true  
                                     left join sidabi.grupo_pesquisadores
                                            on sidabi.grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id ";
            }
            if ($operador == 'a') {
                $temp .= " and (sessao.usuario_logado = ". $usuarioLogado . " or 
                                sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ")) ";
            }
            if ($operador == 'n') {
                if ($tipoUsuario === 'com') {
                    // buscar meus grupos de pesquisadores
                    $resultado = BiodataSessao::consultarGrupoPesquisadores($usuarioLogado);
                    $listGrupoPesquisadores = '';
                    foreach ($resultado as $linha) {
                        $listGrupoPesquisadores .= $linha["grupo_pesquisadores_id"] . ",";
                    }
                    $listGrupoPesquisadores = substr($listGrupoPesquisadores, 0, -1);

                    $temp .= " and (sessao.usuario_logado in (". $usuarioLogado . ") or 
                                    sidabi.grupo_pesquisadores.id in (". $listGrupoPesquisadores . ")) ";
                }
                // se for administrador não passa 'and' para o 'where'
            }
            if ($operador == 'i') {
                $temp .= " and sessao.usuario_logado in (". $usuarioLogado . ") ";
            }
            if ($operador == 'g') {
                $temp .= " and sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ") ";
            }

            if ($arrayParam["selTipoDado"] != 2) {
                // Todos os formatos de arquivos
                $formato = null;
                switch ($arrayParam["selTipoDado"]) {
                    case 3: $formato = "'txt'"; break;
                    case 4: $formato = "'csv'"; break;
                    case 5: $formato = "'pdf'"; break;
                    case 6: $formato = "'edf'"; break;
                    case 7: $formato = "'zip','rar'"; break;
                    case 8: $formato = "'jpg','png'"; break;
                }
                $temp .= " and right(biodata.sessao.nome_arquivo, 3) in (" . $formato . ")";
            }

            $sql = "select 
                        individuo.id as individuo_id,
                        individuo.nome as individuo_nome,
                        individuo.sexo as individuo_sexo,
                        to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento,
                        extract(year from age(individuo.data_nascimento)) as idade,
                        cidade.id as cidade_id,
                        cidade.nome || '/' || estado.sigla as cidade_estado,
                        case individuo.diagnostico
                            when 1 then 'Doença de Parkinson Idiopática'
                            when 2 then 'Parkinsonismo'
                            when 3 then 'Indivíduo Hígido'
                        end as diagnostico,
                        to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') as dt_diagnostico,
                        individuo.tipo_sangue_fk_id,
                        tipo_sangue.tipo tipo_sangue_descricao,
                        to_char(biodata.sessao.dt_sessao, 'dd/mm/YYYY') as data_cadastro,
                        case when trim(biodata.sessao.nome_arquivo) != '' then 
                            biodata.sessao.nome_arquivo
                        else
                            '-'
                        end arquivo,
                        'arquivo' as tipo_dado
                        
                    from 
                        public.individuo
                        inner join public.cidade 
                                on cidade.id = individuo.cidade_fk_id
                        inner join public.estado 
                                on estado.id = cidade.estado_fk_id
                        inner join public.tipo_sangue
                                on tipo_sangue.id = individuo.tipo_sangue_fk_id
                        inner join biodata.sessao
                                on biodata.sessao.participante_fk_id = public.individuo.id 
                        inner join sidabi.login
                                on login.id = sessao.usuario_logado

                        $innerJoinSessao 
                    
                    $temp
                                        
                    order by 
                        individuo.nome, individuo.data_nascimento ";
        }

        if ($arrayParam["selTipoDado"] == 9) {
            // Avaliação Clínica

            // Ajustes finos nos filtros de grupo de pesquisadores
            $innerJoinAvaliacao = '';
            if ( !empty($grupoPesquisadores) || (($tipoUsuario === 'com') && ($operador == 'n')) ) {
                $innerJoinAvaliacao = " left join questionario.avaliacao_grupo_pesquisadores_login
                                               on avaliacao_grupo_pesquisadores_login.avaliacao_fk_id = avaliacao.id
                                        left join sidabi.grupo_pesquisadores_login 
                                               on grupo_pesquisadores_login.id = avaliacao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                              and grupo_pesquisadores_login.ativo is true  
                                        left join sidabi.grupo_pesquisadores
                                               on sidabi.grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id ";
            }
            if ($operador == 'a') {
                $temp .= " and (avaliacao.login_fk_id = ". $usuarioLogado . " or 
                                sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ")) ";
            }
            if ($operador == 'n') {
                if ($tipoUsuario === 'com') {
                    // buscar meus grupos de pesquisadores
                    $resultado = BiodataSessao::consultarGrupoPesquisadores($usuarioLogado);
                    $listGrupoPesquisadores = '';
                    foreach ($resultado as $linha) {
                        $listGrupoPesquisadores .= $linha["grupo_pesquisadores_id"] . ",";
                    }
                    $listGrupoPesquisadores = substr($listGrupoPesquisadores, 0, -1);

                    $temp .= " and (avaliacao.login_fk_id in (". $usuarioLogado . ") or 
                                    sidabi.grupo_pesquisadores.id in (". $listGrupoPesquisadores . ")) ";
                }
                // se for administrador não passa 'and' para o 'where'
            }
            if ($operador == 'i') {
                $temp .= " and avaliacao.login_fk_id in (". $usuarioLogado . ") ";
            }
            if ($operador == 'g') {
                $temp .= " and sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ") ";
            }

            $sql = "select 
                        individuo.id as individuo_id,
                        individuo.nome as individuo_nome,
                        individuo.sexo as individuo_sexo,
                        to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento,
                        extract(year from age(individuo.data_nascimento)) as idade,
                        cidade.id as cidade_id,
                        cidade.nome || '/' || estado.sigla as cidade_estado,
                        case individuo.diagnostico
                            when 1 then 'Doença de Parkinson Idiopática'
                            when 2 then 'Parkinsonismo'
                            when 3 then 'Indivíduo Hígido'
                        end as diagnostico,
                        to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') as dt_diagnostico,
                        individuo.tipo_sangue_fk_id,
                        tipo_sangue.tipo tipo_sangue_descricao,
                        to_char(questionario.avaliacao.data_avaliacao, 'dd/mm/YYYY') as data_cadastro,
                        questionario.tipo_questionario.titulo as arquivo,
                        'avaliacao' as tipo_dado                        
                    
                    from 
                        public.individuo
                        inner join public.cidade 
                                on cidade.id = individuo.cidade_fk_id
                        inner join public.estado 
                                on estado.id = cidade.estado_fk_id
                        inner join public.tipo_sangue
                                on tipo_sangue.id = individuo.tipo_sangue_fk_id
                        inner join questionario.avaliacao
                                on questionario.avaliacao.participante_fk_id = public.individuo.id
                        inner join questionario.tipo_questionario
                                on questionario.tipo_questionario.id = questionario.avaliacao.tipo_questionario_fk_id
                        inner join sidabi.login
                                on login.id = avaliacao.login_fk_id
                        $innerJoinAvaliacao
                    
                    $temp
                    
                    order by 
                            individuo.nome, individuo.data_nascimento ";
        }

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }
}