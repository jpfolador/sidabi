<?php

class PublicIndividuo
{
    public static function consultarArquivosRelacionado()
    {
        $db = Database::conexao();

        $temp = 'where 1=1 ';
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
        if (!empty($responsavel)) {
            $temp .= " and sessao.usuario_logado  = ". $responsavel;
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
                
                $temp
                
                order by sessao.dt_sessao";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }



    
    public static function verificarNumeroRegistro($numeroRegistro)
    {
        $db = Database::conexao();

        $sql = "select *
                from individuo
                where numero_registro = '" . $numeroRegistro . "'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    // INICIO - métodos para os 'participantes'
        public static function consultarParticipante()
        {
            $db = Database::conexao();

            $sql = "select 
                           individuo.*,
                           to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento_formatada,
                           tipo_sangue.tipo tipo_sangue_descricao
                    from
                           public.individuo
                           left join public.tipo_sangue
                                   on tipo_sangue.id = individuo.tipo_sangue_fk_id
                    order by individuo.nome";

            $result = $db->query($sql);
            $result = $result->fetchAll(PDO::FETCH_ASSOC);
            return $result;
        }
    // FIM - BIODATA métodos - 'participantes'


    // INICIO - UPDRS métodos - 'paciente'
        public static function consultarPacientePeloId($pacienteId)
        {
            $db = Database::conexao();

            $sql = "select 	
                            individuo.id 									as individuo_id,
                            individuo.nome 									as individuo_nome,
                            individuo.sexo 									as individuo_sexo,
                            individuo.email,
                            to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento,
                            individuo.telefone1,
                            individuo.telefone2,
                            case when individuo.telefone1 is null then 
                                case when individuo.telefone2 is null then
                                    'contato não informado'
                                else
                                    individuo.telefone2
                                end
                            else
                                case when individuo.telefone2 is null then
                                    individuo.telefone1
                                else
                                    individuo.telefone1 || ' / ' || individuo.telefone2
                                end
                            end as telefone,
                            individuo.logradouro,
                            individuo.numero,
                            individuo.bairro,
                            cidade.id 										as cidade_id,
                            cidade.nome 									as cidade_nome,
                            estado.nome 									as estado_nome,
                            estado.sigla 									as estado_sigla,
                            individuo.rg,
                            individuo.cpf,
                            case individuo.diagnostico
                                when 1 then 'Doença de Parkinson Idiopática'
                                when 2 then 'Parkinsonismo'
                                when 3 then 'Indivíduo Hígido'
                            end 											as diagnostico,
                            to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') as dt_diagnostico,
                            individuo.medico_responsavel,
                            individuo.telefone_medico_responsavel,
                            individuo.outras_patologias,
                            individuo.tipo_sangue_fk_id,
                            tipo_sangue.tipo tipo_sangue_descricao,
                            individuo.foto,
                            individuo.numero_registro,
                            individuo.instituicao
                    from 
                            public.individuo
                            left join public.cidade 
                                   on cidade.id = individuo.cidade_fk_id
                            left join public.estado 
                                   on estado.id = cidade.estado_fk_id
                            left join public.tipo_sangue
                                   on tipo_sangue.id = individuo.tipo_sangue_fk_id
                                   
                    where 
                            individuo.id = $pacienteId";

            $result = $db->query($sql);
            $result = $result->fetchAll(PDO::FETCH_ASSOC);
            return $result;
        }
    // FIM - UPDRS métodos - 'paciente'

    public static function procurarIndividuoPeloId($individuoId)
    {
        $db = Database::conexao();

        $sql = "select individuo.*
                from public.individuo
                where individuo.id = $individuoId ";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function atualizarRemocaoFoto($id, $foto)
    {
        $db = Database::conexao();
        $sql = "update public.individuo
				   	set foto = :foto 
				 	where id = :id";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->bindParam(":foto", $foto, PDO::PARAM_STR);
        $stmt->execute();

        return $stmt->rowCount();
    }

    /**
     * @param $gsSearchParam parte do nome que se deseja procurar
     * @param $offset usado pelo componente inlineSearch para fazer paginação
     * @param $limit usado pelo componente inlineSearch para fazer paginação
     * @param $dependency deve conter o id do grupo_estudo
     * @return array|PDOStatement
     */
    public static function procurarIndividuoGrupoInlineDependency($gsSearchParam, $offset, $limit, $dependency)
    {
        $db = Database::conexao();

        $sql = "select 
                        individuo.id, 
                        individuo.nome as descricao
                from 
                        public.individuo
                        inner join biodata.grupo_estudo_participante
                                on grupo_estudo_participante.participante_fk_id = individuo.id
                        inner join biodata.grupo_estudo
                                on grupo_estudo.id = grupo_estudo_participante.grupo_estudo_fk_id
                where 
                        individuo.nome ilike '%$gsSearchParam%'
                        and grupo_estudo.id = $dependency
                
                order by individuo.nome asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarIndividuoGrupoInlineCountDependency($gsSearchParam, $dependency)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
                from 
                    public.individuo
                    inner join biodata.grupo_estudo_participante
                            on grupo_estudo_participante.participante_fk_id = individuo.id
                    inner join biodata.grupo_estudo
                            on grupo_estudo.id = grupo_estudo_participante.grupo_estudo_fk_id
                where individuo.nome ilike '%$gsSearchParam%'
                      and grupo_estudo.id = $dependency";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function procurarIndividuoInline($gsSearchParam, $offset, $limit)
    {
        $db = Database::conexao();

        $sql = "select 
                        individuo.id, 
                        individuo.nome as descricao
                from 
                        public.individuo
                where 
                        individuo.nome ilike '%$gsSearchParam%'
                
                order by individuo.nome asc
                limit $limit offset $offset";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function procurarIndividuoInlineCount($gsSearchParam)
    {
        $db = Database::conexao();

        $sql = "select count(*) as quantidade_registro
                from public.individuo
                where individuo.nome ilike '%$gsSearchParam%'";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result[0]["quantidade_registro"];
    }

    public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
    {
        $db = Database::conexao();

        $temp = 'where 1=1 ';
        if (!empty($filtro))
        {
            if (!empty($filtro["id"])) {
                $temp .= " and individuo.id = ". $filtro["id"];
            }
            if (!empty($filtro["numero_registro"])) {
                $temp .= " and individuo.numero_registro ilike '%". $filtro["numero_registro"]."%'";
            }
            if (!empty($filtro["individuo_nome"])) {
                $temp .= " and individuo.nome ilike '%". $filtro["individuo_nome"]."%'";
            }
            if (!empty($filtro["dt_diagnostico"])) {
                $temp .= " and to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') = '". $filtro["dt_diagnostico"]."'";
            }
            if (!empty($filtro["data_nascimento"])) {
                $temp .= " and to_char(individuo.data_nascimento, 'dd/mm/YYYY') ilike '%". $filtro["data_nascimento"]."%'";
            }
            if (!empty($filtro["medico_responsavel"])) {
                $temp .= " and individuo.medico_responsavel ilike '%". $filtro["medico_responsavel"]."%'";
            }
            if (!empty($filtro["individuo_sexo"])) {
                $temp .= " and individuo.sexo = '". $filtro["individuo_sexo"] . "'";
            }
            if (!empty($filtro["diagnostico"])) {
                $convert = ($filtro["diagnostico"] == 'Parkinsonismo') ? '2' : '1';
                $temp .= " and individuo.diagnostico = ". $convert;
            }
            if (!empty($filtro["telefone1"])) {
                $temp .= " and individuo.telefone1 ilike '%". $filtro["telefone1"]."%'";
            }
        }

        $sql = "select 	
                        individuo.id,
                        individuo.numero_registro,
                        individuo.instituicao,
                        individuo.nome 									as individuo_nome,
                        case when individuo.sexo = 'M' then
                            'Masculino'
                        else
                            'Feminino'
                        end 											 as individuo_sexo,
                        individuo.email,
                        to_char(individuo.data_nascimento, 'dd/mm/YYYY') as data_nascimento,
                        individuo.telefone1,
                        individuo.telefone2,
                        case when individuo.telefone1 is null then 
                            case when individuo.telefone2 is null then
                                'contato não informado'
                            else
                                individuo.telefone2
                            end
                        else
                            case when individuo.telefone2 is null then
                                individuo.telefone1
                            else
                                individuo.telefone1 || ' / ' || individuo.telefone2
                            end
                        end as telefone,
                        individuo.logradouro,
                        individuo.numero,
                        individuo.bairro,
                        cidade.id 										as cidade_id,
                        cidade.nome 									as cidade_nome,
                        estado.nome 									as estado_nome,
                        estado.sigla 									as estado_sigla,
                        individuo.rg,
                        individuo.cpf,
                        case individuo.diagnostico
                            when 1 then 'Doença de Parkinson Idiopática'
                            when 2 then 'Parkinsonismo'
                            when 3 then 'Indivíduo Hígido'
                        end 											as diagnostico,
                        to_char(individuo.dt_diagnostico, 'dd/mm/YYYY') as dt_diagnostico,
                        individuo.medico_responsavel,
                        individuo.telefone_medico_responsavel,
                        individuo.outras_patologias,
                        individuo.peso,
                        individuo.altura,
                        individuo.tipo_sangue_fk_id,
                        tipo_sangue.tipo tipo_sangue_descricao,
                        individuo.foto
                from 
                        public.individuo
                        left join public.cidade 
                               on cidade.id = individuo.cidade_fk_id
                        left join public.estado 
                               on estado.id = cidade.estado_fk_id
                        left join public.tipo_sangue
                               on tipo_sangue.id = individuo.tipo_sangue_fk_id
                $temp
                order by
                        $sidx $sord
                limit
                        $limit offset $start";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function contarTodosRegistros()
    {
        $db = Database::conexao();

        $sql = "select count(*) as count
					from public.individuo";

        $result = $db->query($sql);
        $result = $result->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function insert($dadosIndividuo)
    {
        $db = Database::conexao();

        $sql = "insert into public.individuo
					values (default, :nome, :sexo, :email, :data_nascimento, :telefone1, :telefone2,
							:logradouro, :numero, :bairro, :cidade_fk_id, :rg, :cpf, :diagnostico, :dt_diagnostico,
							:medico_responsavel, :telefone_medico_responsavel, :outras_patologias,
							:peso, :altura, :tipo_sangue_fk_id, :foto, :numero_registro, :instituicao)
					returning id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $dadosIndividuo["nome"], PDO::PARAM_STR);
        $stmt->bindParam(":sexo", $dadosIndividuo["sexo"], PDO::PARAM_STR);
        $stmt->bindParam(":email", $dadosIndividuo["email"], PDO::PARAM_STR);
        $stmt->bindParam(":data_nascimento", $dadosIndividuo["data_nascimento"], PDO::PARAM_STR);
        $stmt->bindParam(":telefone1", $dadosIndividuo["telefone1"], PDO::PARAM_STR);
        $stmt->bindParam(":telefone2", $dadosIndividuo["telefone2"], PDO::PARAM_STR);
        $stmt->bindParam(":logradouro", $dadosIndividuo["logradouro"], PDO::PARAM_STR);
        $stmt->bindParam(":numero", $dadosIndividuo["numero"], PDO::PARAM_INT);
        $stmt->bindParam(":bairro", $dadosIndividuo["bairro"], PDO::PARAM_STR);
        $stmt->bindParam(":cidade_fk_id", $dadosIndividuo["cidade_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":rg", $dadosIndividuo["rg"], PDO::PARAM_STR);
        $stmt->bindParam(":cpf", $dadosIndividuo["cpf"], PDO::PARAM_STR);
        $stmt->bindParam(":diagnostico", $dadosIndividuo["diagnostico"], PDO::PARAM_STR);
        $stmt->bindParam(":dt_diagnostico", $dadosIndividuo["dt_diagnostico"], PDO::PARAM_STR);
        $stmt->bindParam(":medico_responsavel", $dadosIndividuo["medico_responsavel"], PDO::PARAM_STR);
        $stmt->bindParam(":telefone_medico_responsavel", $dadosIndividuo["telefone_medico_responsavel"], PDO::PARAM_STR);
        $stmt->bindParam(":outras_patologias", $dadosIndividuo["outras_patologias"], PDO::PARAM_STR);
        $stmt->bindParam(":peso", $dadosIndividuo["peso"], PDO::PARAM_INT);
        $stmt->bindParam(":altura", $dadosIndividuo["altura"], PDO::PARAM_INT);
        $stmt->bindParam(":tipo_sangue_fk_id", $dadosIndividuo["tipo_sangue_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":foto", $dadosIndividuo["foto"], PDO::PARAM_STR);
        $stmt->bindParam(":numero_registro", $dadosIndividuo["numero_registro"], PDO::PARAM_STR);
        $stmt->bindParam(":instituicao", $dadosIndividuo["instituicao"], PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['id'];
    }

    public static function update($dadosIndividuo)
    {
        $db = Database::conexao();

        $sql = "update public.individuo
				   	set 
						nome = :nome, 
						sexo = :sexo, 
						email = :email, 
						data_nascimento = :data_nascimento, 
						telefone1 = :telefone1, 
						telefone2 = :telefone2,			
						logradouro = :logradouro, 
						numero = :numero, 
						bairro = :bairro, 
						cidade_fk_id = :cidade_fk_id, 
						rg = :rg, 
						cpf = :cpf, 
						diagnostico = :diagnostico, 
						dt_diagnostico = :dt_diagnostico,	
						medico_responsavel = :medico_responsavel, 
						telefone_medico_responsavel = :telefone_medico_responsavel, 
						outras_patologias = :outras_patologias,
						peso = :peso, 
						altura = :altura,
						tipo_sangue_fk_id = :tipo_sangue_fk_id, 
						foto = :foto,
						numero_registro = :numero_registro,
                        instituicao = :instituicao
				 	where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":nome", $dadosIndividuo["nome"], PDO::PARAM_STR);
        $stmt->bindParam(":sexo", $dadosIndividuo["sexo"], PDO::PARAM_STR);
        $stmt->bindParam(":email", $dadosIndividuo["email"], PDO::PARAM_STR);
        $stmt->bindParam(":data_nascimento", $dadosIndividuo["data_nascimento"], PDO::PARAM_STR);
        $stmt->bindParam(":telefone1", $dadosIndividuo["telefone1"], PDO::PARAM_STR);
        $stmt->bindParam(":telefone2", $dadosIndividuo["telefone2"], PDO::PARAM_STR);
        $stmt->bindParam(":logradouro", $dadosIndividuo["logradouro"], PDO::PARAM_STR);
        $stmt->bindParam(":numero", $dadosIndividuo["numero"], PDO::PARAM_INT);
        $stmt->bindParam(":bairro", $dadosIndividuo["bairro"], PDO::PARAM_STR);
        $stmt->bindParam(":cidade_fk_id", $dadosIndividuo["cidade_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":rg", $dadosIndividuo["rg"], PDO::PARAM_STR);
        $stmt->bindParam(":cpf", $dadosIndividuo["cpf"], PDO::PARAM_STR);
        $stmt->bindParam(":diagnostico", $dadosIndividuo["diagnostico"], PDO::PARAM_STR);
        $stmt->bindParam(":dt_diagnostico", $dadosIndividuo["dt_diagnostico"], PDO::PARAM_STR);
        $stmt->bindParam(":medico_responsavel", $dadosIndividuo["medico_responsavel"], PDO::PARAM_STR);
        $stmt->bindParam(":telefone_medico_responsavel", $dadosIndividuo["telefone_medico_responsavel"], PDO::PARAM_STR);
        $stmt->bindParam(":outras_patologias", $dadosIndividuo["outras_patologias"], PDO::PARAM_STR);
        $stmt->bindParam(":peso", $dadosIndividuo["peso"], PDO::PARAM_INT);
        $stmt->bindParam(":altura", $dadosIndividuo["altura"], PDO::PARAM_INT);
        $stmt->bindParam(":tipo_sangue_fk_id", $dadosIndividuo["tipo_sangue_fk_id"], PDO::PARAM_INT);
        $stmt->bindParam(":foto", $dadosIndividuo["foto"], PDO::PARAM_STR);
        $stmt->bindParam(":numero_registro", $dadosIndividuo["numero_registro"], PDO::PARAM_STR);
        $stmt->bindParam(":instituicao", $dadosIndividuo["instituicao"], PDO::PARAM_STR);
        $stmt->bindParam(":id", $dadosIndividuo["id"], PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

    public static function delete($id)
    {
        $db = Database::conexao();

        $sql = "delete from public.individuo
                where id = :id";

        $stmt = $db->prepare($sql);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->rowCount();
    }

}