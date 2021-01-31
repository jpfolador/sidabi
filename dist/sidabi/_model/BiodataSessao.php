<?php

class BiodataSessao
{
    public static function consultarSessaoPorEquipamento()
    {
        $db = Database::conexao();

        $sql = "select 
                       count(sessao.id) as qtd_sessao,
                       equipamento.nome as equipamento_nome
                from
                       biodata.sessao
                       inner join biodata.grupo_estudo
                       on biodata.grupo_estudo.id = biodata.sessao.grupo_estudo_fk_id
                       inner join biodata.estudo
                       on biodata.estudo.id = biodata.grupo_estudo.estudo_fk_id
                       inner join biodata.equipamento
                       on biodata.equipamento.id = biodata.sessao.equipamento_fk_id 
                       
                group by
                       equipamento.nome
                order by
                       equipamento.nome";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarSessaoPorMeses($qtdMeses=12)
    {
        $db = Database::conexao();

        $sql = "select 
                    coalesce(qtd_sessao, 0) as qtd_sessao, 
                    mes
                from
                    (
                        select to_char(temp, 'MM/YYYY') as mes
                        from generate_series(current_date - interval '$qtdMeses month', current_date, '1 month') as temp
                    ) meses_ano
                    left join ( 
                        select 
                            to_char(sessao.dt_sessao, 'MM/YYYY') as mes,
                            count(sessao.id) as qtd_sessao
                        from 
                            biodata.sessao
                        where 
                            sessao.dt_sessao > (current_date - interval '$qtdMeses months')
                        group by 1
                    ) t using (mes) ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * Métodos para listar os grupos de pesquisa do usuário logado
     * @param $usuarioLogado - deve conter o login id do usuario logado
     * @return array|PDOStatement
     */
    public static function consultarGrupoPesquisadores($usuarioLogado)
    {
        $db = Database::conexao();

        $sql = "select
                        grupo_pesquisadores_login.id as grupo_pesquisadores_login_id,
                        grupo_pesquisadores.id as grupo_pesquisadores_id,
                        grupo_pesquisadores.nome as grupo_pesquisadores_nome,
                        login.id as login_id,
                        login.nome as login_nome
                                      
                from
                        sidabi.grupo_pesquisadores_login
                                         
                        join sidabi.grupo_pesquisadores
                        on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                                      
                        join sidabi.login
                        on login.id = grupo_pesquisadores_login.login_fk_id
                
                where
                        login.id = :usuario_logado
                order by 
                        grupo_pesquisadores.nome";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":usuario_logado", $usuarioLogado, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarSessaoPeloId($sessaoId)
    {
        $db = Database::conexao();
        $sql = "select 
                       sessao.*
                from
                       biodata.sessao
                where 
                       sessao.id = $sessaoId";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarArquivosParaDownload($sessaoIds)
    {
        $db = Database::conexao();
        $sql = "select 
                       sessao.id,
                       sessao.nome_arquivo
                from
                       biodata.sessao
                where 
                       sessao.id in ($sessaoIds)";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarSessao($responsavel, $protocolo, $grupoEstudo, $participante,
                                           $equipamento, $dataInicio, $dataFim, $grupoPesquisadores,
                                           $operador, $tipoUsuario)
    {
        $db = Database::conexao();
        $temp = 'where 1=1 ';
        $innerJoin = '';
        if (!empty($dataInicio) && !empty($dataFim)) {
            $temp .= " and sessao.dt_sessao between '$dataInicio' and '$dataFim'";
        }
        if (!empty($protocolo)) {
            $temp .= " and sessao.protocolo_fk_id = ". $protocolo;
        }
        if (!empty($grupoEstudo)) {
            $temp .= " and sessao.grupo_estudo_fk_id = ". $grupoEstudo;
        }
        if (!empty($participante)) {
            $temp .= " and sessao.participante_fk_id = ". $participante;
        }
        if (!empty($equipamento)) {
            $temp .= " and sessao.equipamento_fk_id  = ". $equipamento;
        }
        if ( !empty($grupoPesquisadores) || (($tipoUsuario === 'com') && ($operador == 'n')) ) {
            $innerJoin = " left join biodata.sessao_grupo_pesquisadores_login
                                  on sessao_grupo_pesquisadores_login.sessao_fk_id = sessao.id
                           left join sidabi.grupo_pesquisadores_login 
                                  on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                 and grupo_pesquisadores_login.ativo is true  
                           left join sidabi.grupo_pesquisadores
                                  on sidabi.grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id ";
        }
        if (!empty($responsavel)) {
            if ($operador == 'a') {
                $temp .= " and (sessao.usuario_logado in (". $responsavel . ") or 
                                sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ")) ";
            }
            if ($operador == 'n') {
                if ($tipoUsuario === 'com') {
                    // buscar meus grupos de pesquisadores
                    $resultado = BiodataSessao::consultarGrupoPesquisadores($responsavel);
                    $listGrupoPesquisadores = '';
                    foreach ($resultado as $linha) {
                        $listGrupoPesquisadores .= $linha["grupo_pesquisadores_id"] . ",";
                    }
                    $listGrupoPesquisadores = substr($listGrupoPesquisadores, 0, -1);

                    $temp .= " and (sessao.usuario_logado in (". $responsavel . ") or 
                                sidabi.grupo_pesquisadores.id in (". $listGrupoPesquisadores . ")) ";
                }
                // se for administrador não passa 'and' para o 'where'
            }
            if ($operador == 'i') {
                $temp .= " and sessao.usuario_logado in (". $responsavel . ") ";
            }
            if ($operador == 'g') {
                $temp .= " and sidabi.grupo_pesquisadores.id in (". $grupoPesquisadores . ") ";
            }
        }

        $sql = "select 
                       sessao.id,
                       to_char(sessao.dt_sessao, 'dd/mm/YYYY') as dt_sessao,
                       sessao.hora,
                       sessao.medicacao,
                       sessao.nome_arquivo,
                       sessao.observacao,
                       protocolo.id protocolo_id,
                       protocolo.nome protocolo_nome,
                       grupo_estudo.id grupo_estudo_id,
                       grupo_estudo.nome grupo_estudo_nome,
                       equipamento.id equipamento_id,
                       equipamento.descricao equipamento_descricao,
                       login.id login_id,
                       login.nome login_nome,
                       individuo.id participante_id,
                       individuo.nome participante_nome
                from
                       biodata.sessao
                       inner join biodata.protocolo
                               on protocolo.id = sessao.protocolo_fk_id
                       inner join biodata.grupo_estudo
                               on grupo_estudo.id = sessao.grupo_estudo_fk_id 
                       inner join biodata.equipamento
                               on equipamento.id = sessao.equipamento_fk_id 
                       inner join sidabi.login
                               on login.id = sessao.usuario_logado
                       inner join public.individuo
                               on individuo.id = sessao.participante_fk_id
                       $innerJoin
                
                $temp

                order by sessao.dt_sessao";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();

        $temp = '';
        if (!empty($filtro))
        {
            $temp = 'where 1=1 ';
            if (!empty($filtro["id"])) {
                $temp .= " and sessao.id = ". $filtro["id"];
            }

            if (!empty($filtro["dt_sessao"])) {
                $temp .= " and to_char(sessao.dt_sessao, 'dd/mm/YYYY') ilike '%". $filtro["dt_sessao"]."%'";
            }
            if (!empty($filtro["hora"])) {
                $temp .= " and sessao.hora ilike '%". $filtro["hora"]."%'";
            }
            if (!empty($filtro["protocolo_nome"])) {
                $temp .= " and protocolo.nome ilike '%". $filtro["protocolo_nome"]."%'";
            }
            if (!empty($filtro["grupo_estudo_nome"])) {
                $temp .= " and grupo_estudo.nome ilike '%". $filtro["grupo_estudo_nome"]."%'";
            }
            if (!empty($filtro["equipamento_nome"])) {
                $temp .= " and equipamento.nome ilike '%". $filtro["equipamento_nome"]."%'";
            }
            if (!empty($filtro["participante_nome"])) {
                $temp .= " and individuo.nome ilike '%". $filtro["participante_nome"]."%'";
            }
            if (!empty($filtro["login_nome"])) {
                $temp .= " and login.nome ilike '%". $filtro["login_nome"]."%'";
            }
            if (!empty($filtro["usuario_logado"])) {
                $temp .= " and sessao.usuario_logado in (". $filtro["usuario_logado"] . ")";
            }
        }

        $sql = "select 
                       sessao.id,
                       to_char(sessao.dt_sessao, 'dd/mm/YYYY') as dt_sessao,
                       sessao.hora,
                       sessao.medicacao,
                       sessao.nome_arquivo,
                       sessao.observacao,
                       protocolo.id as protocolo_id,
                       protocolo.nome as protocolo_nome,
                       grupo_estudo.id as grupo_estudo_id,
                       grupo_estudo.nome as grupo_estudo_nome,
                       equipamento.id as equipamento_id,
                       equipamento.nome as equipamento_nome,
                       individuo.id as participante_id,
                       individuo.nome as participante_nome,
                       login.id as login_id,
                       login.nome as login_nome,
                       array_to_json(array(
                               select grupo_pesquisadores.id
                               from biodata.sessao_grupo_pesquisadores_login
                                    join sidabi.grupo_pesquisadores_login 
                                      on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                    join sidabi.grupo_pesquisadores
                                      on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                               where sessao_grupo_pesquisadores_login.sessao_fk_id = biodata.sessao.id
                        )) as grupo_pesquisadores
                from
                       biodata.sessao
                       inner join biodata.protocolo
                               on protocolo.id = sessao.protocolo_fk_id
                       inner join biodata.grupo_estudo
                               on grupo_estudo.id = sessao.grupo_estudo_fk_id 
                       inner join biodata.equipamento
                               on equipamento.id = sessao.equipamento_fk_id 
                       inner join public.individuo
                               on individuo.id = sessao.participante_fk_id
                       inner join sidabi.login
                               on login.id = sessao.usuario_logado
                
                $temp
                
                order by $sidx $sord
                limit $limit offset $start";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function consultarMeusArquivosECompartilhados($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();

        $temp = '';
        if (!empty($filtro))
        {
            $temp = 'where 1=1 ';
            if (!empty($filtro["id"])) {
                // sessao.id
                $temp .= " and id = ". $filtro["id"];
            }
            if (!empty($filtro["dt_sessao"])) {
                $temp .= " and to_char(dt_sessao, 'dd/mm/YYYY') ilike '%". $filtro["dt_sessao"]."%'";
            }
            if (!empty($filtro["hora"])) {
                $temp .= " and hora ilike '%". $filtro["hora"]."%'";
            }
            if (!empty($filtro["protocolo_nome"])) {
                $temp .= " and protocolo_nome ilike '%". $filtro["protocolo_nome"]."%'";
            }
            if (!empty($filtro["grupo_estudo_nome"])) {
                $temp .= " and grupo_estudo_nome ilike '%". $filtro["grupo_estudo_nome"]."%'";
            }
            if (!empty($filtro["equipamento_nome"])) {
                $temp .= " and equipamento_nome ilike '%". $filtro["equipamento_nome"]."%'";
            }
            if (!empty($filtro["participante_nome"])) {
                $temp .= " and participante_nome ilike '%". $filtro["participante_nome"]."%'";
            }
            if (!empty($filtro["login_nome"])) {
                $temp .= " and login_nome ilike '%". $filtro["login_nome"]."%'";
            }
            /*
            if (!empty($filtro["usuario_logado"])) {
                $temp .= " and sessao.usuario_logado in (". $filtro["usuario_logado"] . ")";
            }
            */
        }

        $usuarioLogado = $filtro["usuario_logado"];

        $sql = "select *
                from (
                    -- Arquivos compartilhados nos grupos pertencentes ao user logado
                    select 
                        sessao.id,
                        to_char(sessao.dt_sessao, 'dd/mm/YYYY') as dt_sessao,
                        sessao.hora,
                        sessao.medicacao,
                        sessao.nome_arquivo,
                        sessao.observacao,
                        protocolo.id as protocolo_id,
                        protocolo.nome as protocolo_nome,
                        grupo_estudo.id as grupo_estudo_id,
                        grupo_estudo.nome as grupo_estudo_nome,
                        equipamento.id as equipamento_id,
                        equipamento.nome as equipamento_nome,
                        individuo.id as participante_id,
                        individuo.nome as participante_nome,
                        login.id as login_id,
                        login.nome as login_nome,
                        array_to_json(array(
                               select grupo_pesquisadores.id
                               from biodata.sessao_grupo_pesquisadores_login
                                    join sidabi.grupo_pesquisadores_login 
                                      on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                     and grupo_pesquisadores_login.ativo is true  
                                    join sidabi.grupo_pesquisadores
                                      on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                               where sessao_grupo_pesquisadores_login.sessao_fk_id = biodata.sessao.id
                        ))::text as grupo_pesquisadores
                    from (
                        select 
                              distinct grupo_pesquisadores_login.id as grupo_pesquisadores_login_id, 
                              grupo_pesquisadores_login.grupo_pesquisadores_fk_id as grupo_pesquisadores_id,
                              grupo_pesquisadores_login.login_fk_id as login_id
                        from 
                              sidabi.grupo_pesquisadores_login
                        where grupo_pesquisadores_login.grupo_pesquisadores_fk_id in (
                            select grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                            from sidabi.grupo_pesquisadores_login
                            where grupo_pesquisadores_login.login_fk_id = $usuarioLogado
                        ) 
                        and grupo_pesquisadores_login.login_fk_id <> $usuarioLogado
                        and grupo_pesquisadores_login.ativo is true
                    ) as gp
                    inner join biodata.sessao_grupo_pesquisadores_login
                            on sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id = gp.grupo_pesquisadores_login_id
                    inner join biodata.sessao
                            on sessao.id = sessao_grupo_pesquisadores_login.sessao_fk_id
                    inner join biodata.protocolo
                            on protocolo.id = sessao.protocolo_fk_id
                    inner join biodata.grupo_estudo
                            on grupo_estudo.id = sessao.grupo_estudo_fk_id 
                    inner join biodata.equipamento
                            on equipamento.id = sessao.equipamento_fk_id 
                    inner join public.individuo
                            on individuo.id = sessao.participante_fk_id
                    inner join sidabi.login
                            on login.id = sessao.usuario_logado
                            
                union
                    -- Os arquivos pertencentes ao usuário logado
                    select 
                           sessao.id,
                           to_char(sessao.dt_sessao, 'dd/mm/YYYY') as dt_sessao,
                           sessao.hora,
                           sessao.medicacao,
                           sessao.nome_arquivo,
                           sessao.observacao,
                           protocolo.id as protocolo_id,
                           protocolo.nome as protocolo_nome,
                           grupo_estudo.id as grupo_estudo_id,
                           grupo_estudo.nome as grupo_estudo_nome,
                           equipamento.id as equipamento_id,
                           equipamento.nome as equipamento_nome,
                           individuo.id as participante_id,
                           individuo.nome as participante_nome,
                           login.id as login_id,
                           login.nome as login_nome,
                           array_to_json(array(
                                   select grupo_pesquisadores.id
                                   from biodata.sessao_grupo_pesquisadores_login
                                        join sidabi.grupo_pesquisadores_login 
                                          on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                         and grupo_pesquisadores_login.ativo is true 
                                        join sidabi.grupo_pesquisadores
                                          on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                                   where sessao_grupo_pesquisadores_login.sessao_fk_id = biodata.sessao.id
                            ))::text as grupo_pesquisadores
                    from
                           biodata.sessao
                           inner join biodata.protocolo
                                   on protocolo.id = sessao.protocolo_fk_id
                           inner join biodata.grupo_estudo
                                   on grupo_estudo.id = sessao.grupo_estudo_fk_id 
                           inner join biodata.equipamento
                                   on equipamento.id = sessao.equipamento_fk_id 
                           inner join public.individuo
                                   on individuo.id = sessao.participante_fk_id
                           inner join sidabi.login
                                   on login.id = sessao.usuario_logado
                    where
                           sessao.usuario_logado = $usuarioLogado
                ) as tmp
                
                $temp
                
                order by $sidx $sord
                limit $limit offset $start";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function contarMeusArquivosECompartilhados($usuarioLogado)
    {
        $db = Database::conexao();

        $sql = "select count(*) as count
                from (
                    -- Arquivos compartilhados nos grupos pertencentes ao user logado
                    select 
                        sessao.id,
                        to_char(sessao.dt_sessao, 'dd/mm/YYYY') as dt_sessao,
                        sessao.hora,
                        sessao.medicacao,
                        sessao.nome_arquivo,
                        sessao.observacao,
                        protocolo.id as protocolo_id,
                        protocolo.nome as protocolo_nome,
                        grupo_estudo.id as grupo_estudo_id,
                        grupo_estudo.nome as grupo_estudo_nome,
                        equipamento.id as equipamento_id,
                        equipamento.nome as equipamento_nome,
                        individuo.id as participante_id,
                        individuo.nome as participante_nome,
                        login.id as login_id,
                        login.nome as login_nome,
                        array_to_json(array(
                               select grupo_pesquisadores.id
                               from biodata.sessao_grupo_pesquisadores_login
                                    join sidabi.grupo_pesquisadores_login 
                                      on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                     and grupo_pesquisadores_login.ativo is true  
                                    join sidabi.grupo_pesquisadores
                                      on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                               where sessao_grupo_pesquisadores_login.sessao_fk_id = biodata.sessao.id
                        ))::text as grupo_pesquisadores
                    from (
                        select 
                              distinct grupo_pesquisadores_login.id as grupo_pesquisadores_login_id, 
                              grupo_pesquisadores_login.grupo_pesquisadores_fk_id as grupo_pesquisadores_id,
                              grupo_pesquisadores_login.login_fk_id as login_id
                        from 
                              sidabi.grupo_pesquisadores_login
                        where grupo_pesquisadores_login.grupo_pesquisadores_fk_id in (
                            select grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                            from sidabi.grupo_pesquisadores_login
                            where grupo_pesquisadores_login.login_fk_id = $usuarioLogado
                        ) 
                        and grupo_pesquisadores_login.login_fk_id <> $usuarioLogado
                        and grupo_pesquisadores_login.ativo is true
                    ) as gp
                    inner join biodata.sessao_grupo_pesquisadores_login
                            on sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id = gp.grupo_pesquisadores_login_id
                    inner join biodata.sessao
                            on sessao.id = sessao_grupo_pesquisadores_login.sessao_fk_id
                    inner join biodata.protocolo
                            on protocolo.id = sessao.protocolo_fk_id
                    inner join biodata.grupo_estudo
                            on grupo_estudo.id = sessao.grupo_estudo_fk_id 
                    inner join biodata.equipamento
                            on equipamento.id = sessao.equipamento_fk_id 
                    inner join public.individuo
                            on individuo.id = sessao.participante_fk_id
                    inner join sidabi.login
                            on login.id = sessao.usuario_logado
                            
                union 
                    -- Os arquivos pertencentes ao usuário logado
                    select 
                           sessao.id,
                           to_char(sessao.dt_sessao, 'dd/mm/YYYY') as dt_sessao,
                           sessao.hora,
                           sessao.medicacao,
                           sessao.nome_arquivo,
                           sessao.observacao,
                           protocolo.id as protocolo_id,
                           protocolo.nome as protocolo_nome,
                           grupo_estudo.id as grupo_estudo_id,
                           grupo_estudo.nome as grupo_estudo_nome,
                           equipamento.id as equipamento_id,
                           equipamento.nome as equipamento_nome,
                           individuo.id as participante_id,
                           individuo.nome as participante_nome,
                           login.id as login_id,
                           login.nome as login_nome,
                           array_to_json(array(
                                   select grupo_pesquisadores.id
                                   from biodata.sessao_grupo_pesquisadores_login
                                        join sidabi.grupo_pesquisadores_login 
                                          on grupo_pesquisadores_login.id = sessao_grupo_pesquisadores_login.grupo_pesquisadores_login_fk_id
                                         and grupo_pesquisadores_login.ativo is true 
                                        join sidabi.grupo_pesquisadores
                                          on grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                                   where sessao_grupo_pesquisadores_login.sessao_fk_id = biodata.sessao.id
                            ))::text as grupo_pesquisadores
                    from
                           biodata.sessao
                           inner join biodata.protocolo
                                   on protocolo.id = sessao.protocolo_fk_id
                           inner join biodata.grupo_estudo
                                   on grupo_estudo.id = sessao.grupo_estudo_fk_id 
                           inner join biodata.equipamento
                                   on equipamento.id = sessao.equipamento_fk_id 
                           inner join public.individuo
                                   on individuo.id = sessao.participante_fk_id
                           inner join sidabi.login
                                   on login.id = sessao.usuario_logado
                    where
                           sessao.usuario_logado = $usuarioLogado
                ) as tmp ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * Conta todos registros da sessão, usado para quem é administrador
     * @return array|PDOStatement
     */
    public static function contarTodosRegistros()
    {
        $db = Database::conexao();

        $sql = "select count(*) as count from biodata.sessao";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    /**
     * Método para contar todos os registros baseado no grupo de pesquisadores ou no responsável logado.
     * @param $usuario_logado - deve conter o ID do usuário logado ou os ids do grupo que ele faz parte.
     * @return array|PDOStatement
     */
    public static function contarTodosRegistrosResponsavel($usuario_logado)
    {
        $db = Database::conexao();

        $sql = "select 
                      count(*) as count 
                from 
                      biodata.sessao 
                      inner join sidabi.login on login.id = sessao.usuario_logado
                where 
                      sessao.usuario_logado in ($usuario_logado) ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($dadosSessao)
    {
        $db = Database::conexao();

        $sql = "insert into biodata.sessao
					values (default, :dt_sessao, :hora, :medicacao, :nome_arquivo, :protocolo_fk_id, 
					        :grupo_estudo_fk_id, :equipamento_fk_id, :participante_fk_id, 
					        :observacao, :usuario_logado)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":dt_sessao", $dadosSessao["dt_sessao"], PDO::PARAM_STR);
        $stmt->bindParam(":hora", $dadosSessao["hora"], PDO::PARAM_STR);
        $stmt->bindParam(":medicacao", $dadosSessao["medicacao"], PDO::PARAM_STR);
        $stmt->bindParam(":nome_arquivo", $dadosSessao["nome_arquivo"], PDO::PARAM_STR);
        $stmt->bindParam(":protocolo_fk_id", $dadosSessao["protocolo_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":grupo_estudo_fk_id", $dadosSessao["grupo_estudo_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":equipamento_fk_id", $dadosSessao["equipamento_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":participante_fk_id", $dadosSessao["participante_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":observacao", $dadosSessao["observacao"], PDO::PARAM_STR);
        $stmt->bindParam(":usuario_logado", $dadosSessao["usuario_logado"], PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function atualizarRemocaoArquivo($id, $arquivo)
    {
        $db = Database::conexao();
        $sql = "update biodata.sessao
				   set nome_arquivo = :nome_arquivo 
				 where id = :id";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":nome_arquivo", $arquivo, PDO::PARAM_STR);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function update($dadosSessao)
    {
        $db = Database::conexao();

        $sql = "update biodata.sessao
				   	set 
						dt_sessao = :dt_sessao, 
						hora = :hora, 
						medicacao = :medicacao, 
						nome_arquivo = :nome_arquivo, 
						protocolo_fk_id = :protocolo_fk_id, 
					    grupo_estudo_fk_id = :grupo_estudo_fk_id, 
					    equipamento_fk_id = :equipamento_fk_id, 
					    participante_fk_id = :participante_fk_id, 
					    observacao = :observacao,
					    usuario_logado = :usuario_logado
				 	where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":dt_sessao", $dadosSessao["dt_sessao"], PDO::PARAM_STR);
        $stmt->bindParam(":hora", $dadosSessao["hora"], PDO::PARAM_STR);
        $stmt->bindParam(":medicacao", $dadosSessao["medicacao"], PDO::PARAM_STR);
        $stmt->bindParam(":nome_arquivo", $dadosSessao["nome_arquivo"], PDO::PARAM_STR);
        $stmt->bindParam(":protocolo_fk_id", $dadosSessao["protocolo_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":grupo_estudo_fk_id", $dadosSessao["grupo_estudo_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":equipamento_fk_id", $dadosSessao["equipamento_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":participante_fk_id", $dadosSessao["participante_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":observacao", $dadosSessao["observacao"], PDO::PARAM_STR);
        $stmt->bindParam(":usuario_logado", $dadosSessao["usuario_logado"], PDO::PARAM_INT);
        $stmt->bindParam(":id", $dadosSessao["id"], PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from biodata.sessao
					where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }
}