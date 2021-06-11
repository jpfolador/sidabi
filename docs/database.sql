--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: biodata; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA biodata;


ALTER SCHEMA biodata OWNER TO postgres;

--
-- Name: SCHEMA biodata; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA biodata IS 'controle de dados coletados';


--
-- Name: inova; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inova;


ALTER SCHEMA inova OWNER TO postgres;

--
-- Name: SCHEMA inova; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA inova IS 'Esquema para registro de ideia inovadoras a serem trabalhadas.';


--
-- Name: parkinson; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA parkinson;


ALTER SCHEMA parkinson OWNER TO postgres;

--
-- Name: SCHEMA parkinson; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA parkinson IS 'esquema para cadastrar os sintomas do Parkinson';


--
-- Name: prodata; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA prodata;


ALTER SCHEMA prodata OWNER TO postgres;

--
-- Name: questionario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA questionario;


ALTER SCHEMA questionario OWNER TO postgres;

--
-- Name: sidabi; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sidabi;


ALTER SCHEMA sidabi OWNER TO postgres;

--
-- Name: SCHEMA sidabi; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA sidabi IS 'esquema para controle de login e modulos';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = biodata, pg_catalog;

--
-- Name: coleta_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE coleta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coleta_id_seq OWNER TO postgres;

--
-- Name: coletores_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE coletores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coletores_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: equipamento; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE equipamento (
    id integer DEFAULT nextval(('biodata.equipamento_id_seq'::text)::regclass) NOT NULL,
    descricao character varying(255),
    nome character varying(255)
);


ALTER TABLE equipamento OWNER TO postgres;

--
-- Name: equipamento_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE equipamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE equipamento_id_seq OWNER TO postgres;

--
-- Name: estudo; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE estudo (
    id integer DEFAULT nextval(('biodata.estudos_id_seq'::text)::regclass) NOT NULL,
    descricao text NOT NULL,
    dt_inicio date,
    dt_fim date,
    comite_etica text,
    status character varying(100) NOT NULL,
    numero_sessao integer
);


ALTER TABLE estudo OWNER TO postgres;

--
-- Name: COLUMN estudo.status; Type: COMMENT; Schema: biodata; Owner: postgres
--

COMMENT ON COLUMN estudo.status IS 'Em andamento, concluido, aguardando comitê de ética, ...';


--
-- Name: estudos_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE estudos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE estudos_id_seq OWNER TO postgres;

--
-- Name: grupo_estudo; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE grupo_estudo (
    id integer DEFAULT nextval(('biodata.grupo_estudo_id_seq'::text)::regclass) NOT NULL,
    estudo_fk_id integer NOT NULL,
    nome character varying(255) NOT NULL,
    descricao character varying(255) NOT NULL,
    criterio_inclusao text,
    criterio_exclusao text
);


ALTER TABLE grupo_estudo OWNER TO postgres;

--
-- Name: grupo_estudo_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE grupo_estudo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE grupo_estudo_id_seq OWNER TO postgres;

--
-- Name: grupo_estudo_participante; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE grupo_estudo_participante (
    id integer NOT NULL,
    grupo_estudo_fk_id integer NOT NULL,
    participante_fk_id integer NOT NULL,
    id_manual character varying(100)
);


ALTER TABLE grupo_estudo_participante OWNER TO postgres;

--
-- Name: COLUMN grupo_estudo_participante.participante_fk_id; Type: COMMENT; Schema: biodata; Owner: postgres
--

COMMENT ON COLUMN grupo_estudo_participante.participante_fk_id IS 'Participante corresponde a chave estragerira na tabela public.individuo';


--
-- Name: grupo_estudo_participante_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE grupo_estudo_participante_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE grupo_estudo_participante_id_seq OWNER TO postgres;

--
-- Name: grupo_estudo_participante_id_seq; Type: SEQUENCE OWNED BY; Schema: biodata; Owner: postgres
--

ALTER SEQUENCE grupo_estudo_participante_id_seq OWNED BY grupo_estudo_participante.id;


--
-- Name: paciente_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE paciente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE paciente_id_seq OWNER TO postgres;

--
-- Name: protocolo; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE protocolo (
    id integer DEFAULT nextval(('biodata.protocolo_id_seq'::text)::regclass) NOT NULL,
    nome character varying(255) NOT NULL,
    descricao text
);


ALTER TABLE protocolo OWNER TO postgres;

--
-- Name: protocolo_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE protocolo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE protocolo_id_seq OWNER TO postgres;

--
-- Name: sessao; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE sessao (
    id integer DEFAULT nextval(('biodata.sessao_id_seq'::text)::regclass) NOT NULL,
    dt_sessao date NOT NULL,
    hora character varying(60),
    medicacao character varying(255),
    nome_arquivo character varying(255),
    protocolo_fk_id integer NOT NULL,
    grupo_estudo_fk_id integer NOT NULL,
    equipamento_fk_id integer NOT NULL,
    participante_fk_id integer NOT NULL,
    observacao text,
    usuario_logado integer
);


ALTER TABLE sessao OWNER TO postgres;

--
-- Name: COLUMN sessao.participante_fk_id; Type: COMMENT; Schema: biodata; Owner: postgres
--

COMMENT ON COLUMN sessao.participante_fk_id IS 'individuo voluntário que será avaliado na sessão de coleta';


--
-- Name: COLUMN sessao.observacao; Type: COMMENT; Schema: biodata; Owner: postgres
--

COMMENT ON COLUMN sessao.observacao IS 'Informações extras que por ventura possam ocorrer na sessão de coleta';


--
-- Name: sessao_grupo_pesquisadores_login; Type: TABLE; Schema: biodata; Owner: postgres
--

CREATE TABLE sessao_grupo_pesquisadores_login (
    id integer NOT NULL,
    sessao_fk_id integer NOT NULL,
    grupo_pesquisadores_login_fk_id integer NOT NULL
);


ALTER TABLE sessao_grupo_pesquisadores_login OWNER TO postgres;

--
-- Name: sessao_grupo_pesquisadores_login_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE sessao_grupo_pesquisadores_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sessao_grupo_pesquisadores_login_id_seq OWNER TO postgres;

--
-- Name: sessao_grupo_pesquisadores_login_id_seq; Type: SEQUENCE OWNED BY; Schema: biodata; Owner: postgres
--

ALTER SEQUENCE sessao_grupo_pesquisadores_login_id_seq OWNED BY sessao_grupo_pesquisadores_login.id;


--
-- Name: sessao_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE sessao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE sessao_id_seq OWNER TO postgres;

--
-- Name: tipo_sangue_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE tipo_sangue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE tipo_sangue_id_seq OWNER TO postgres;

--
-- Name: tipo_usuario_id_seq; Type: SEQUENCE; Schema: biodata; Owner: postgres
--

CREATE SEQUENCE tipo_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE tipo_usuario_id_seq OWNER TO postgres;

SET search_path = inova, pg_catalog;

--
-- Name: idealizador; Type: TABLE; Schema: inova; Owner: postgres
--

CREATE TABLE idealizador (
    id integer DEFAULT nextval(('inova.idealizador_id_seq'::text)::regclass) NOT NULL,
    nome character varying(255) NOT NULL,
    cargo character varying(255),
    aula character varying(10),
    desenvolvimento character varying(10),
    contato character varying(255)
);


ALTER TABLE idealizador OWNER TO postgres;

--
-- Name: idealizador_id_seq; Type: SEQUENCE; Schema: inova; Owner: postgres
--

CREATE SEQUENCE idealizador_id_seq
    START WITH 10
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idealizador_id_seq OWNER TO postgres;

--
-- Name: ideia; Type: TABLE; Schema: inova; Owner: postgres
--

CREATE TABLE ideia (
    id integer DEFAULT nextval(('inova.ideia_id_seq'::text)::regclass) NOT NULL,
    descricao character varying(5000) NOT NULL,
    chaves character varying(255) NOT NULL,
    setor_fk_id integer,
    idealizador_fk_id integer,
    status character varying(100)
);


ALTER TABLE ideia OWNER TO postgres;

--
-- Name: COLUMN ideia.status; Type: COMMENT; Schema: inova; Owner: postgres
--

COMMENT ON COLUMN ideia.status IS 'Disponível, em desenvolvimento, ...';


--
-- Name: ideia_id_seq; Type: SEQUENCE; Schema: inova; Owner: postgres
--

CREATE SEQUENCE ideia_id_seq
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ideia_id_seq OWNER TO postgres;

--
-- Name: setor; Type: TABLE; Schema: inova; Owner: postgres
--

CREATE TABLE setor (
    id integer DEFAULT nextval(('inova.setor_id_seq'::text)::regclass) NOT NULL,
    nome character varying(255) NOT NULL,
    chefe character varying(255),
    ramal character varying(30)
);


ALTER TABLE setor OWNER TO postgres;

--
-- Name: setor_id_seq; Type: SEQUENCE; Schema: inova; Owner: postgres
--

CREATE SEQUENCE setor_id_seq
    START WITH 9
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE setor_id_seq OWNER TO postgres;

SET search_path = parkinson, pg_catalog;

--
-- Name: categoria; Type: TABLE; Schema: parkinson; Owner: postgres
--

CREATE TABLE categoria (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    status boolean DEFAULT true NOT NULL,
    ordem smallint
);


ALTER TABLE categoria OWNER TO postgres;

--
-- Name: COLUMN categoria.nome; Type: COMMENT; Schema: parkinson; Owner: postgres
--

COMMENT ON COLUMN categoria.nome IS 'Nome da categoria';


--
-- Name: COLUMN categoria.status; Type: COMMENT; Schema: parkinson; Owner: postgres
--

COMMENT ON COLUMN categoria.status IS 'controlar se a categoria será mostrada ou não.';


--
-- Name: categoria_id_seq; Type: SEQUENCE; Schema: parkinson; Owner: postgres
--

CREATE SEQUENCE categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categoria_id_seq OWNER TO postgres;

--
-- Name: categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: parkinson; Owner: postgres
--

ALTER SEQUENCE categoria_id_seq OWNED BY categoria.id;


--
-- Name: sintoma; Type: TABLE; Schema: parkinson; Owner: postgres
--

CREATE TABLE sintoma (
    id integer NOT NULL,
    titulo character varying(255) NOT NULL,
    descricao text NOT NULL,
    caminho_video character varying(255),
    categoria_fk_id integer,
    url_informacao character varying(255)
);


ALTER TABLE sintoma OWNER TO postgres;

--
-- Name: COLUMN sintoma.titulo; Type: COMMENT; Schema: parkinson; Owner: postgres
--

COMMENT ON COLUMN sintoma.titulo IS 'Titulo do sintoma';


--
-- Name: COLUMN sintoma.descricao; Type: COMMENT; Schema: parkinson; Owner: postgres
--

COMMENT ON COLUMN sintoma.descricao IS 'descrever o sintoma';


--
-- Name: COLUMN sintoma.caminho_video; Type: COMMENT; Schema: parkinson; Owner: postgres
--

COMMENT ON COLUMN sintoma.caminho_video IS 'deve conter o caminho da pasta + o nome do video relativo ao sintoma';


--
-- Name: COLUMN sintoma.url_informacao; Type: COMMENT; Schema: parkinson; Owner: postgres
--

COMMENT ON COLUMN sintoma.url_informacao IS 'pode conter uma url com mais informações sobre o assunto. Ex.: um link para uma página ou artigo.';


--
-- Name: sintoma_id_seq; Type: SEQUENCE; Schema: parkinson; Owner: postgres
--

CREATE SEQUENCE sintoma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sintoma_id_seq OWNER TO postgres;

--
-- Name: sintoma_id_seq; Type: SEQUENCE OWNED BY; Schema: parkinson; Owner: postgres
--

ALTER SEQUENCE sintoma_id_seq OWNED BY sintoma.id;


SET search_path = prodata, pg_catalog;

--
-- Name: avalia_tremor; Type: TABLE; Schema: prodata; Owner: postgres
--

CREATE TABLE avalia_tremor (
    id integer NOT NULL,
    individuo_fk_id integer NOT NULL,
    tipo_desenho character varying(255),
    desenho character varying(255),
    classificador character varying(100),
    proba_saudavel real,
    proba_tremor real,
    data_hora timestamp(0) without time zone,
    observacao character varying(255)
);


ALTER TABLE avalia_tremor OWNER TO postgres;

--
-- Name: COLUMN avalia_tremor.individuo_fk_id; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.individuo_fk_id IS 'Vinculo com o participante da avaliação do tremor';


--
-- Name: COLUMN avalia_tremor.tipo_desenho; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.tipo_desenho IS 'tipo do desenho escolhido, esprial, sinusoide';


--
-- Name: COLUMN avalia_tremor.desenho; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.desenho IS 'nome do arquivo do desenho';


--
-- Name: COLUMN avalia_tremor.classificador; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.classificador IS 'menemonico do classificador usado na avaliação';


--
-- Name: COLUMN avalia_tremor.proba_saudavel; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.proba_saudavel IS 'probabilidade gerada para o desenho ser saldável';


--
-- Name: COLUMN avalia_tremor.proba_tremor; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.proba_tremor IS 'probabilidade gerada para o desenho estar com tremor';


--
-- Name: COLUMN avalia_tremor.data_hora; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.data_hora IS 'data e hora da avaliação realizada';


--
-- Name: COLUMN avalia_tremor.observacao; Type: COMMENT; Schema: prodata; Owner: postgres
--

COMMENT ON COLUMN avalia_tremor.observacao IS 'obserações extras necessárias para o dia da avaliação';


--
-- Name: avalia_tremor_id_seq; Type: SEQUENCE; Schema: prodata; Owner: postgres
--

CREATE SEQUENCE avalia_tremor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avalia_tremor_id_seq OWNER TO postgres;

--
-- Name: avalia_tremor_id_seq; Type: SEQUENCE OWNED BY; Schema: prodata; Owner: postgres
--

ALTER SEQUENCE avalia_tremor_id_seq OWNED BY avalia_tremor.id;


SET search_path = public, pg_catalog;

--
-- Name: cidade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cidade (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    codigo_ibge integer,
    estado_fk_id integer,
    populacao_2010 integer,
    densidade_demo numeric(18,0),
    gentilico character varying(255),
    area numeric(18,0)
);


ALTER TABLE cidade OWNER TO postgres;

--
-- Name: cidade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cidade_id_seq
    START WITH 5567
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cidade_id_seq OWNER TO postgres;

--
-- Name: cidade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cidade_id_seq OWNED BY cidade.id;


--
-- Name: estado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE estado (
    id integer NOT NULL,
    codigo_ibge character varying(4) NOT NULL,
    sigla character(2) NOT NULL,
    nome character varying(50) NOT NULL
);


ALTER TABLE estado OWNER TO postgres;

--
-- Name: estado_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE estado_id_seq
    START WITH 28
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE estado_id_seq OWNER TO postgres;

--
-- Name: estado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE estado_id_seq OWNED BY estado.id;


--
-- Name: individuo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE individuo_id_seq
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE individuo_id_seq OWNER TO postgres;

--
-- Name: individuo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE individuo (
    id integer DEFAULT nextval('individuo_id_seq'::regclass) NOT NULL,
    nome character varying(255) NOT NULL,
    sexo character(1) NOT NULL,
    email character varying(100),
    data_nascimento date,
    telefone1 character varying(15),
    telefone2 character varying(15),
    logradouro character varying(255),
    numero integer,
    bairro character varying(255),
    cidade_fk_id integer,
    rg character(15),
    cpf character(15),
    diagnostico smallint,
    dt_diagnostico date,
    medico_responsavel character varying(255),
    telefone_medico_responsavel character varying(15),
    outras_patologias text,
    peso numeric(5,2),
    altura numeric(5,2),
    tipo_sangue_fk_id integer,
    foto character varying(255),
    numero_registro character varying(100),
    instituicao character varying(255)
);


ALTER TABLE individuo OWNER TO postgres;

--
-- Name: COLUMN individuo.sexo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN individuo.sexo IS 'M: masculino
F: feminino';


--
-- Name: COLUMN individuo.diagnostico; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN individuo.diagnostico IS '1: Doença de Parkinson Idiopática
2: Parkinsonismo
3: Higido';


--
-- Name: COLUMN individuo.numero_registro; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN individuo.numero_registro IS 'Campo que deve conter o número do registro ou protocolo';


--
-- Name: COLUMN individuo.instituicao; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN individuo.instituicao IS 'Pode conter o nome da instituição que realizou a pesquisa';


--
-- Name: individuo_medicamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE individuo_medicamento (
    id integer NOT NULL,
    individuo_fk_id integer NOT NULL,
    medicamento_fk_id integer NOT NULL,
    dosagem character varying(255) NOT NULL,
    observacao text
);


ALTER TABLE individuo_medicamento OWNER TO postgres;

--
-- Name: individuo_medicamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE individuo_medicamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE individuo_medicamento_id_seq OWNER TO postgres;

--
-- Name: individuo_medicamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE individuo_medicamento_id_seq OWNED BY individuo_medicamento.id;


--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE medicamento (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    descricao text,
    fabricante character varying(255)
);


ALTER TABLE medicamento OWNER TO postgres;

--
-- Name: medicamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE medicamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE medicamento_id_seq OWNER TO postgres;

--
-- Name: medicamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE medicamento_id_seq OWNED BY medicamento.id;


--
-- Name: tipo_sangue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tipo_sangue (
    id integer NOT NULL,
    tipo character varying(10) DEFAULT NULL::character varying
);


ALTER TABLE tipo_sangue OWNER TO postgres;

--
-- Name: tipo_sangue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tipo_sangue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tipo_sangue_id_seq OWNER TO postgres;

--
-- Name: tipo_sangue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_sangue_id_seq OWNED BY tipo_sangue.id;


SET search_path = questionario, pg_catalog;

--
-- Name: agrupamento; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE agrupamento (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    ordem integer NOT NULL,
    status boolean DEFAULT true NOT NULL,
    tipo_questionario_fk_id integer NOT NULL
);


ALTER TABLE agrupamento OWNER TO postgres;

--
-- Name: agrupamento_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE agrupamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agrupamento_id_seq OWNER TO postgres;

--
-- Name: agrupamento_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE agrupamento_id_seq OWNED BY agrupamento.id;


--
-- Name: alternativa; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE alternativa (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor real,
    ordem integer NOT NULL,
    status boolean DEFAULT true NOT NULL
);


ALTER TABLE alternativa OWNER TO postgres;

--
-- Name: COLUMN alternativa.valor; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN alternativa.valor IS 'valor numérico que a alternativa pode assumir';


--
-- Name: alternativa_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE alternativa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alternativa_id_seq OWNER TO postgres;

--
-- Name: alternativa_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE alternativa_id_seq OWNED BY alternativa.id;


--
-- Name: avaliacao; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE avaliacao (
    id integer NOT NULL,
    investigador character varying(255) NOT NULL,
    participante_fk_id integer NOT NULL,
    data_avaliacao date NOT NULL,
    fonte_informacao integer,
    local character varying(255),
    medicamento character varying(255),
    observacao character varying(255),
    finalizada boolean,
    login_fk_id integer NOT NULL,
    tipo_questionario_fk_id integer NOT NULL
);


ALTER TABLE avaliacao OWNER TO postgres;

--
-- Name: TABLE avaliacao; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON TABLE avaliacao IS 'deve armazenar os dados do dia da avaliação e carregar o tipo de questionario para identificar as respostas';


--
-- Name: COLUMN avaliacao.fonte_informacao; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN avaliacao.fonte_informacao IS '1 - Paciente
2 - cuidador
3 - Paciente e cuidador em proporções iguais';


--
-- Name: COLUMN avaliacao.medicamento; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN avaliacao.medicamento IS 'para descrição de medicação usada no dia da avaliação';


--
-- Name: avaliacao_grupo_pesquisadores_login; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE avaliacao_grupo_pesquisadores_login (
    id integer NOT NULL,
    avaliacao_fk_id integer NOT NULL,
    grupo_pesquisadores_login_fk_id integer NOT NULL
);


ALTER TABLE avaliacao_grupo_pesquisadores_login OWNER TO postgres;

--
-- Name: avaliacao_grupo_pesquisadores_login_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE avaliacao_grupo_pesquisadores_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avaliacao_grupo_pesquisadores_login_id_seq OWNER TO postgres;

--
-- Name: avaliacao_grupo_pesquisadores_login_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE avaliacao_grupo_pesquisadores_login_id_seq OWNED BY avaliacao_grupo_pesquisadores_login.id;


--
-- Name: avaliacao_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE avaliacao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avaliacao_id_seq OWNER TO postgres;

--
-- Name: avaliacao_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE avaliacao_id_seq OWNED BY avaliacao.id;


--
-- Name: questao; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE questao (
    id integer NOT NULL,
    agrupamento_fk_id integer NOT NULL,
    tipo_questao_fk_id integer NOT NULL,
    ordem integer,
    status boolean DEFAULT true NOT NULL,
    titulo character varying(255) NOT NULL,
    descricao text,
    instrucao text,
    numero character varying(10),
    contavel boolean NOT NULL
);


ALTER TABLE questao OWNER TO postgres;

--
-- Name: COLUMN questao.status; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN questao.status IS 'Define se a questão está habilitada para uso ou não';


--
-- Name: COLUMN questao.contavel; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN questao.contavel IS 'Se a perguntar será contabilizada nos relatórios';


--
-- Name: questao_alternativa; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE questao_alternativa (
    id integer NOT NULL,
    questao_fk_id integer NOT NULL,
    alternativa_fk_id integer NOT NULL
);


ALTER TABLE questao_alternativa OWNER TO postgres;

--
-- Name: TABLE questao_alternativa; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON TABLE questao_alternativa IS 'Guardar a tupla da questao alternativa';


--
-- Name: questao_alternativa_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE questao_alternativa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questao_alternativa_id_seq OWNER TO postgres;

--
-- Name: questao_alternativa_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE questao_alternativa_id_seq OWNED BY questao_alternativa.id;


--
-- Name: questao_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE questao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questao_id_seq OWNER TO postgres;

--
-- Name: questao_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE questao_id_seq OWNED BY questao.id;


--
-- Name: questao_tipo_aplicacao; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE questao_tipo_aplicacao (
    id integer NOT NULL,
    questao_fk_id integer NOT NULL,
    tipo_aplicacao_fk_id integer NOT NULL
);


ALTER TABLE questao_tipo_aplicacao OWNER TO postgres;

--
-- Name: TABLE questao_tipo_aplicacao; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON TABLE questao_tipo_aplicacao IS 'Tabela que gardará o tipo de aplicação da questão, pois a mesma questão pode avaliar partes do corpo diferentes: mão direita, mão esquerda, etc.';


--
-- Name: questao_tipo_aplicacao_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE questao_tipo_aplicacao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questao_tipo_aplicacao_id_seq OWNER TO postgres;

--
-- Name: questao_tipo_aplicacao_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE questao_tipo_aplicacao_id_seq OWNED BY questao_tipo_aplicacao.id;


--
-- Name: resposta; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE resposta (
    id integer NOT NULL,
    avaliacao_fk_id integer NOT NULL,
    tipo_questionario_fk_id integer NOT NULL,
    alternativa_fk_id integer NOT NULL,
    tipo_aplicacao_fk_id integer NOT NULL,
    login_fk_id integer NOT NULL,
    data_registro timestamp with time zone DEFAULT now(),
    alternativa_descritiva text,
    questao_fk_id integer NOT NULL
);


ALTER TABLE resposta OWNER TO postgres;

--
-- Name: TABLE resposta; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON TABLE resposta IS 'Tabela para armazenar as respostas do questionário';


--
-- Name: COLUMN resposta.alternativa_descritiva; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN resposta.alternativa_descritiva IS 'Campo para armazenar a resposta do tipo de questão descritiva longa';


--
-- Name: resposta_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE resposta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resposta_id_seq OWNER TO postgres;

--
-- Name: resposta_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE resposta_id_seq OWNED BY resposta.id;


--
-- Name: tipo_aplicacao; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE tipo_aplicacao (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    sigla character(5),
    status boolean DEFAULT true
);


ALTER TABLE tipo_aplicacao OWNER TO postgres;

--
-- Name: COLUMN tipo_aplicacao.sigla; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN tipo_aplicacao.sigla IS 'Deve conter a sigla que aparecerá no formulário. Ex.: mão direita = D';


--
-- Name: tipo_aplicacao_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE tipo_aplicacao_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tipo_aplicacao_id_seq OWNER TO postgres;

--
-- Name: tipo_aplicacao_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE tipo_aplicacao_id_seq OWNED BY tipo_aplicacao.id;


--
-- Name: tipo_questao; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE tipo_questao (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    status boolean DEFAULT true NOT NULL
);


ALTER TABLE tipo_questao OWNER TO postgres;

--
-- Name: TABLE tipo_questao; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON TABLE tipo_questao IS 'Tabela para armazenar os tipos da questão. Ex. descritiva curta, multipla escolha, etc';


--
-- Name: tipo_questao_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE tipo_questao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tipo_questao_id_seq OWNER TO postgres;

--
-- Name: tipo_questao_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE tipo_questao_id_seq OWNED BY tipo_questao.id;


--
-- Name: tipo_questionario; Type: TABLE; Schema: questionario; Owner: postgres
--

CREATE TABLE tipo_questionario (
    id integer NOT NULL,
    titulo character varying(50) NOT NULL,
    descricao character varying(255) NOT NULL,
    endereco_eletronico character varying(255),
    status boolean DEFAULT true NOT NULL
);


ALTER TABLE tipo_questionario OWNER TO postgres;

--
-- Name: TABLE tipo_questionario; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON TABLE tipo_questionario IS 'gardará os tipos de questionário: UPDRS, PDQ-39, e qualquer outro que se queira criar';


--
-- Name: COLUMN tipo_questionario.titulo; Type: COMMENT; Schema: questionario; Owner: postgres
--

COMMENT ON COLUMN tipo_questionario.titulo IS 'Titulo curto que defina o tipo de questionário';


--
-- Name: tipo_questionario_id_seq; Type: SEQUENCE; Schema: questionario; Owner: postgres
--

CREATE SEQUENCE tipo_questionario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tipo_questionario_id_seq OWNER TO postgres;

--
-- Name: tipo_questionario_id_seq; Type: SEQUENCE OWNED BY; Schema: questionario; Owner: postgres
--

ALTER SEQUENCE tipo_questionario_id_seq OWNED BY tipo_questionario.id;


SET search_path = sidabi, pg_catalog;

--
-- Name: grupo_pesquisadores; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE grupo_pesquisadores (
    id integer DEFAULT nextval(('sidabi.grupo_pesquisadores_id_seq'::text)::regclass) NOT NULL,
    nome character varying(255) NOT NULL,
    descricao text,
    status boolean DEFAULT true
);


ALTER TABLE grupo_pesquisadores OWNER TO postgres;

--
-- Name: COLUMN grupo_pesquisadores.nome; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN grupo_pesquisadores.nome IS 'Nome do grupo de pesquisadores';


--
-- Name: COLUMN grupo_pesquisadores.descricao; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN grupo_pesquisadores.descricao IS 'Descrição objetiva sobre este grupo de pesquisadores';


--
-- Name: COLUMN grupo_pesquisadores.status; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN grupo_pesquisadores.status IS 'Se já foi utilizado por vários outros registros deve ser apenas desativado';


--
-- Name: grupo_pesquisadores_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE grupo_pesquisadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE grupo_pesquisadores_id_seq OWNER TO postgres;

--
-- Name: grupo_pesquisadores_login; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE grupo_pesquisadores_login (
    id integer DEFAULT nextval(('sidabi.grupo_pesquisadores_login_id_seq'::text)::regclass) NOT NULL,
    grupo_pesquisadores_fk_id integer NOT NULL,
    login_fk_id integer NOT NULL,
    ativo boolean DEFAULT true
);


ALTER TABLE grupo_pesquisadores_login OWNER TO postgres;

--
-- Name: COLUMN grupo_pesquisadores_login.ativo; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN grupo_pesquisadores_login.ativo IS 'Campo para controlador o usuário que está em um grupo e contém arquivos já inseridos, sendo necessário excluí-lo do grupo de pesquisadores.';


--
-- Name: grupo_pesquisadores_login_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE grupo_pesquisadores_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE grupo_pesquisadores_login_id_seq OWNER TO postgres;

--
-- Name: login; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE login (
    id integer NOT NULL,
    usuario character varying(255) NOT NULL,
    senha character varying(50) NOT NULL,
    email character varying(255),
    nome character varying(255),
    ativo boolean DEFAULT true,
    perfil integer,
    administrador boolean DEFAULT false
);


ALTER TABLE login OWNER TO postgres;

--
-- Name: COLUMN login.ativo; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login.ativo IS 'Usuário criado com ativo verdadeiro. Após aluno sair do grupo o usuário deve ser inativado, ou seja, colocar como falso';


--
-- Name: COLUMN login.administrador; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login.administrador IS 'Este campo habilita um usuário para ser um administrador do sistema, dando a ele acesso às configurações do SIDABI';


--
-- Name: login_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE login_id_seq OWNER TO postgres;

--
-- Name: login_id_seq; Type: SEQUENCE OWNED BY; Schema: sidabi; Owner: postgres
--

ALTER SEQUENCE login_id_seq OWNED BY login.id;


--
-- Name: login_menu; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE login_menu (
    id integer NOT NULL,
    login_fk_id integer NOT NULL,
    menu_fk_id integer NOT NULL,
    incluir boolean,
    editar boolean,
    visualizar boolean,
    excluir boolean
);


ALTER TABLE login_menu OWNER TO postgres;

--
-- Name: COLUMN login_menu.login_fk_id; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login_menu.login_fk_id IS 'usuário cadastrado';


--
-- Name: COLUMN login_menu.incluir; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login_menu.incluir IS 'permissão para incluir registros';


--
-- Name: COLUMN login_menu.editar; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login_menu.editar IS 'permissão para editar registros';


--
-- Name: COLUMN login_menu.visualizar; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login_menu.visualizar IS 'permissão para visualizar registros';


--
-- Name: COLUMN login_menu.excluir; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN login_menu.excluir IS 'permissão para excluir registros';


--
-- Name: login_menu_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE login_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE login_menu_id_seq OWNER TO postgres;

--
-- Name: login_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: sidabi; Owner: postgres
--

ALTER SEQUENCE login_menu_id_seq OWNED BY login_menu.id;


--
-- Name: login_modulo; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE login_modulo (
    login_fk_id integer NOT NULL,
    modulo_fk_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE login_modulo OWNER TO postgres;

--
-- Name: login_modulo_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE login_modulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE login_modulo_id_seq OWNER TO postgres;

--
-- Name: login_modulo_id_seq; Type: SEQUENCE OWNED BY; Schema: sidabi; Owner: postgres
--

ALTER SEQUENCE login_modulo_id_seq OWNED BY login_modulo.id;


--
-- Name: menu; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE menu (
    id integer NOT NULL,
    nome character varying(150) NOT NULL,
    url character varying(255),
    modulo_fk_id integer,
    ordem smallint
);


ALTER TABLE menu OWNER TO postgres;

--
-- Name: COLUMN menu.nome; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN menu.nome IS 'O nome do menu';


--
-- Name: COLUMN menu.url; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN menu.url IS 'o caminho do arquivo que o menu abrirá ao ser clicado';


--
-- Name: COLUMN menu.ordem; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN menu.ordem IS 'Usado para ordenar a posição no menu';


--
-- Name: menu_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE menu_id_seq OWNER TO postgres;

--
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: sidabi; Owner: postgres
--

ALTER SEQUENCE menu_id_seq OWNED BY menu.id;


--
-- Name: modulo; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE modulo (
    id integer DEFAULT nextval(('sidabi.modulo_id_seq'::text)::regclass) NOT NULL,
    sigla character varying(30) NOT NULL,
    titulo character varying(100) NOT NULL,
    status boolean DEFAULT true,
    caminho_imagem character varying(255),
    caminho_modulo character varying(255)
);


ALTER TABLE modulo OWNER TO postgres;

--
-- Name: COLUMN modulo.caminho_imagem; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN modulo.caminho_imagem IS 'Deve conter o caminho relativo da pasta img dentro do modulo sidabi';


--
-- Name: modulo_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE modulo_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE modulo_id_seq OWNER TO postgres;

--
-- Name: perfil; Type: TABLE; Schema: sidabi; Owner: postgres
--

CREATE TABLE perfil (
    id integer NOT NULL,
    descricao character varying(100) NOT NULL
);


ALTER TABLE perfil OWNER TO postgres;

--
-- Name: TABLE perfil; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON TABLE perfil IS 'possui o perfil dos particiipantes das pesquisas';


--
-- Name: COLUMN perfil.descricao; Type: COMMENT; Schema: sidabi; Owner: postgres
--

COMMENT ON COLUMN perfil.descricao IS 'Aluno de graduação, Aluno de mestrado, ...';


--
-- Name: perfil_id_seq; Type: SEQUENCE; Schema: sidabi; Owner: postgres
--

CREATE SEQUENCE perfil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE perfil_id_seq OWNER TO postgres;

--
-- Name: perfil_id_seq; Type: SEQUENCE OWNED BY; Schema: sidabi; Owner: postgres
--

ALTER SEQUENCE perfil_id_seq OWNED BY perfil.id;


SET search_path = biodata, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo_participante ALTER COLUMN id SET DEFAULT nextval('grupo_estudo_participante_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao_grupo_pesquisadores_login ALTER COLUMN id SET DEFAULT nextval('sessao_grupo_pesquisadores_login_id_seq'::regclass);


SET search_path = parkinson, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: parkinson; Owner: postgres
--

ALTER TABLE ONLY categoria ALTER COLUMN id SET DEFAULT nextval('categoria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: parkinson; Owner: postgres
--

ALTER TABLE ONLY sintoma ALTER COLUMN id SET DEFAULT nextval('sintoma_id_seq'::regclass);


SET search_path = prodata, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: prodata; Owner: postgres
--

ALTER TABLE ONLY avalia_tremor ALTER COLUMN id SET DEFAULT nextval('avalia_tremor_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cidade ALTER COLUMN id SET DEFAULT nextval('cidade_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estado ALTER COLUMN id SET DEFAULT nextval('estado_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo_medicamento ALTER COLUMN id SET DEFAULT nextval('individuo_medicamento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY medicamento ALTER COLUMN id SET DEFAULT nextval('medicamento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_sangue ALTER COLUMN id SET DEFAULT nextval('tipo_sangue_id_seq'::regclass);


SET search_path = questionario, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY agrupamento ALTER COLUMN id SET DEFAULT nextval('agrupamento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY alternativa ALTER COLUMN id SET DEFAULT nextval('alternativa_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao ALTER COLUMN id SET DEFAULT nextval('avaliacao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao_grupo_pesquisadores_login ALTER COLUMN id SET DEFAULT nextval('avaliacao_grupo_pesquisadores_login_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao ALTER COLUMN id SET DEFAULT nextval('questao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_alternativa ALTER COLUMN id SET DEFAULT nextval('questao_alternativa_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_tipo_aplicacao ALTER COLUMN id SET DEFAULT nextval('questao_tipo_aplicacao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta ALTER COLUMN id SET DEFAULT nextval('resposta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY tipo_aplicacao ALTER COLUMN id SET DEFAULT nextval('tipo_aplicacao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY tipo_questao ALTER COLUMN id SET DEFAULT nextval('tipo_questao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY tipo_questionario ALTER COLUMN id SET DEFAULT nextval('tipo_questionario_id_seq'::regclass);


SET search_path = sidabi, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login ALTER COLUMN id SET DEFAULT nextval('login_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_menu ALTER COLUMN id SET DEFAULT nextval('login_menu_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_modulo ALTER COLUMN id SET DEFAULT nextval('login_modulo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY menu ALTER COLUMN id SET DEFAULT nextval('menu_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY perfil ALTER COLUMN id SET DEFAULT nextval('perfil_id_seq'::regclass);


SET search_path = biodata, pg_catalog;

--
-- Name: coleta_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('coleta_id_seq', 1, false);


--
-- Name: coletores_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('coletores_id_seq', 1, false);


--
-- Data for Name: equipamento; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY equipamento (id, descricao, nome) FROM stdin;
17	Descrição teste 1	Equipamento teste 1
\.


--
-- Name: equipamento_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('equipamento_id_seq', 17, true);


--
-- Data for Name: estudo; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY estudo (id, descricao, dt_inicio, dt_fim, comite_etica, status, numero_sessao) FROM stdin;
35	Estudo teste 1	2022-08-08	2023-08-07	Estudo teste 1 aprovado pelo comitê da instituição XY sob o número 123456	Aguardando início	100
\.


--
-- Name: estudos_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('estudos_id_seq', 35, true);


--
-- Data for Name: grupo_estudo; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY grupo_estudo (id, estudo_fk_id, nome, descricao, criterio_inclusao, criterio_exclusao) FROM stdin;
13	35	Avaliação da marcha por sensores inerciais	Avaliação da marcha por sensores inerciais	Doença de Parkinson	impossibilidade de caminhar
\.


--
-- Name: grupo_estudo_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('grupo_estudo_id_seq', 13, true);


--
-- Data for Name: grupo_estudo_participante; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY grupo_estudo_participante (id, grupo_estudo_fk_id, participante_fk_id, id_manual) FROM stdin;
58	13	34	CG01
\.


--
-- Name: grupo_estudo_participante_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('grupo_estudo_participante_id_seq', 58, true);


--
-- Name: paciente_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('paciente_id_seq', 6, true);


--
-- Data for Name: protocolo; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY protocolo (id, nome, descricao) FROM stdin;
14	Protocolo XYZ	O paciente deve caminhar 5 metros em linha reta, passar por um portal, e retornar por mais 5 metros até o ponto de partida.
\.


--
-- Name: protocolo_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('protocolo_id_seq', 14, true);


--
-- Data for Name: sessao; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY sessao (id, dt_sessao, hora, medicacao, nome_arquivo, protocolo_fk_id, grupo_estudo_fk_id, equipamento_fk_id, participante_fk_id, observacao, usuario_logado) FROM stdin;
\.


--
-- Data for Name: sessao_grupo_pesquisadores_login; Type: TABLE DATA; Schema: biodata; Owner: postgres
--

COPY sessao_grupo_pesquisadores_login (id, sessao_fk_id, grupo_pesquisadores_login_fk_id) FROM stdin;
\.


--
-- Name: sessao_grupo_pesquisadores_login_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('sessao_grupo_pesquisadores_login_id_seq', 27, true);


--
-- Name: sessao_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('sessao_id_seq', 75, true);


--
-- Name: tipo_sangue_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('tipo_sangue_id_seq', 1, false);


--
-- Name: tipo_usuario_id_seq; Type: SEQUENCE SET; Schema: biodata; Owner: postgres
--

SELECT pg_catalog.setval('tipo_usuario_id_seq', 1, false);


SET search_path = inova, pg_catalog;

--
-- Data for Name: idealizador; Type: TABLE DATA; Schema: inova; Owner: postgres
--

COPY idealizador (id, nome, cargo, aula, desenvolvimento, contato) FROM stdin;
12	Maria	Enfermeira	não	não	maria@maria.com.br
\.


--
-- Name: idealizador_id_seq; Type: SEQUENCE SET; Schema: inova; Owner: postgres
--

SELECT pg_catalog.setval('idealizador_id_seq', 12, true);


--
-- Data for Name: ideia; Type: TABLE DATA; Schema: inova; Owner: postgres
--

COPY ideia (id, descricao, chaves, setor_fk_id, idealizador_fk_id, status) FROM stdin;
24	Desenvolver um equipamento para auxiliar xyz		13	12	Ideia registrada
\.


--
-- Name: ideia_id_seq; Type: SEQUENCE SET; Schema: inova; Owner: postgres
--

SELECT pg_catalog.setval('ideia_id_seq', 24, true);


--
-- Data for Name: setor; Type: TABLE DATA; Schema: inova; Owner: postgres
--

COPY setor (id, nome, chefe, ramal) FROM stdin;
13	Unidade XYZ HC	Maria	(34)3333-3333
\.


--
-- Name: setor_id_seq; Type: SEQUENCE SET; Schema: inova; Owner: postgres
--

SELECT pg_catalog.setval('setor_id_seq', 13, true);


SET search_path = parkinson, pg_catalog;

--
-- Data for Name: categoria; Type: TABLE DATA; Schema: parkinson; Owner: postgres
--

COPY categoria (id, nome, status, ordem) FROM stdin;
1	Sintomas Motores	t	2
2	Sintomas Não motores	t	3
4	Material de apoio - NIATS	t	1
\.


--
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: parkinson; Owner: postgres
--

SELECT pg_catalog.setval('categoria_id_seq', 6, true);


--
-- Data for Name: sintoma; Type: TABLE DATA; Schema: parkinson; Owner: postgres
--

COPY sintoma (id, titulo, descricao, caminho_video, categoria_fk_id, url_informacao) FROM stdin;
11	Distonia	A distonia também é um dos principais sintomas da doença de Parkinson e atinge com maior frequência as extremidades inferiores, causando postura equinovara no pé e tornozelo e enrolamento dos dedos. Nas extremidades superiores, o braço é mantido aduzido contra o tórax e flexionado no punho; quando severo, a mão pode ser mantida com o punho cerrado e a palma pode tornar-se macerada ou espessada.	https://www.youtube.com/embed/oPp0YuCBklM	1	https://www.youtube.com/watch?v=oPp0YuCBklM
8	Instabilidade Postural	Alterações de postura e equilíbrio também são sintomas principais da doença, não sendo frequente em estágios iniciais. A postura pode tornar-se mais flexionada, algumas vezes em níveis extremos. A estabilidade postural é afetada, produzindo retropulsão. Isto, algumas vezes, é óbvio sem provocação como também pode ser reconhecido através da avaliação física. Escoliose, geralmente afastando-se do lado mais afetado, é ocasionalmente observado.	https://www.youtube.com/embed/4Z9QPY5vjzM	1	http://slideplayer.com.br/slide/1565638/
2	Tremor	A história usual de quem é acometido pela doença de Parkinson consiste em um aumento gradual dos tremores, maior lentidão de movimentos, caminhar arrastando os pés e postura inclinada para frente. O tremor típico afeta os dedos ou as mãos, mas podem também afetar o queixo, a cabeça ou os pés. Pode ocorrer em um dos lados ou em ambos e ser mais intenso em um lado do que no outro. O tremor ocorre quando nenhum movimento está sendo executado, e por isso, é chamado de tremor de repouso. Por razões que ainda são desconhecidas, o tremor pode variar durante o dia e tornar-se mais intenso quando a pessoa fica nervosa, mas pode desaparecer quando a pessoa está descontraída. O tremor é mais notado quando a pessoa segura com as mãos um objeto leve como um jornal e os tremores desaparecem com o sono. O tremor é definido como movimento rítmico resultante de contrações sincronizadas involuntárias do músculo, sendo considerado um dos principais sintomas da doença de Parkinson. Observado no estágio inicial da doença, o tremor pode ser intermitente e desencadeado durante estresse e/ou ansiedade. Este sintoma está presente em aproximadamente 80% dos casos e frequentemente é assimétrico.	https://www.youtube.com/embed/3oZIB5oasMc	1	https://www.youtube.com/embed/3oZIB5oasMc
7	Bradicinesia	A bradicinesia é pobreza ou lentidão de movimentos. Nas extremidades, isto resulta em redução na amplitude e na velocidade do movimento. Com incidência de 100%, a bradicinesia é considerada um dos principais sintomas da doença. Em estágio inicial da doença a bradicinesia pode ser sutil, mas pode ser observada na redução da oscilação dos braços durante a marcha e durante hesitação para iniciar o movimento. Pode ser identificada através da avaliação física, solicitando ao paciente para bater o dedo indicador contra o polegar, fechar e abrir os punhos ou bater o calcanhar. Quando mais severa mais difícil para o paciente iniciar e manter um determinado movimento, produzindo fraqueza funcional e dor muscular. No entanto, em testes diretos de motricidade e com incentivo, a fraqueza pode ser abolida. A lentidão dos movimentos talvez seja o maior problema para o parkinsoniano, embora este sintoma não seja notado por outras pessoas. O doente demora mais tempo para realizar atividades que antes fazia com mais desenvoltura, tais como, banhar-se, vestir-se, cozinhar, etc. Normalmente, a lentidão de movimento torna-se mais acentuada e evolui mais rapidamente a medida que uma pessoa envelhece. A diferença é que para o paciente de Doença de Parkinson, perde uma certa automação dos movimentos, comparando com pessoas normais.	https://www.youtube.com/embed/4qw5qZHiQI4	1	https://www.youtube.com/embed/4qw5qZHiQI4
4	Rigidez Muscular	A rigidez muscular é outro sintoma da doença de Parkinson. O afetado pela doença pode não sentir, mas o médico pode verificar no consultório se a rigidez existe nos braços, pernas ou até mesmo no pescoço. A face torna-se rígida e parece estar congelada. Não se sabe se é a rigidez que causa a postura anormal do parkinsoniano.  A rigidez pode ser definida como o aumento da resistência ao esticar um músculo passivamente e é comumente associado com bradicinesia, sendo considerado um dos principais sintomas da doença de Parkinson.  A rigidez pode ser unilateral ou bilateral, mas frequentemente é assimétrica. Apesar de acometer as extremidades, a rigidez pode acometer o tronco, contribuindo para as alterações e como consequência deformidades posturais, vistos em muitos pacientes com DP. Comumente, é abolida ou reduzida por levo dopa ou agonistas da dopamina e, frequentemente, está presente em grau mínimo ou ausente em pacientes em tratamento medicamentoso por longo tempo.	https://www.youtube.com/embed/Ankapx8EJMg	1	https://www.youtube.com/embed/Ankapx8EJMg
9	Alterações na Marcha	As anormalidades da marcha podem incluir claudicação e redução ou ausência do balanço dos braços (em estágios iniciais da doença). À medida que ocorre a progressão da doença, o paciente perde o passo normal, o calcanhar dificilmente é encostado no chão durante a marcha, há a tendência de andar na ponta dos pés e/ou os pés tendem a deslizar ao longo do chão. Outra característica é ter giros em bloco (falta de rotação do tronco ao virar-se). Congelamento de marcha também é muito comum entre os principais sintomas da doença. Alterações da marcha é um dos fatores mais importantes que afetam a qualidade de vida dos pacientes acometidos.	https://www.youtube.com/embed/oQyxq3fH0Yk	1	https://www.youtube.com/watch?v=oQyxq3fH0Yk
10	Congelamento	Congelamento ou freezing é a incapacidade transitória de mover os membros inferiores, também é um dos principais sintomas da doença, comumente observada em passagens de portas ou em áreas estreitas. O congelamento também pode ser notável como hesitação sutil ao iniciar caminhadas depois de ficar em pé ou depois de mudar de direção.	https://www.youtube.com/embed/gnmA5j4knj0	1	https://www.youtube.com/watch?v=gnmA5j4knj0
12	Micrografia	Alteração da grafia na qual a escrita parece “apertada” com letra muito pequena é uma característica observada em muitos pacientes, sendo um dos principais sintomas da doença. Micrografia leve pode ser notável pela comparação de assinaturas antigas e recentes. Em alguns casos, o paciente tem muita dificuldade para escrever. Há casos em que o uso de medicamento(s) pode reverter ou amenizar o sintoma.	https://www.youtube.com/embed/Rk1YPIfGLkc	1	https://www.youtube.com/watch?v=Rk1YPIfGLkc
5	Hipofonia ou alterações na fala	Quase 90% dos portadores de Parkinson experimentam alguma alteração em sua fala. Essas modificações fonoaudiológicas se concentram na voz e na deglutição. Neste caso deve-se beber muita água e procurar falar mais alto. A fala e a deglutição podem ser afetadas. A fala pode ser discretamente mais baixa, abafada, e menos distinta. Quando ele se manifesta de forma mais severa, a fala é rápida, monótona e incompreensível.	https://www.youtube.com/embed/_y1YGOjiLQM	1	https://www.youtube.com/embed/_y1YGOjiLQM
13	Apatia Facial	Um dos principais sintomas da doença de Parkinson é a alteração da expressão facial, também causando redução do piscar e dos sorrisos.	https://www.youtube.com/embed/Cij1RvquGvU	2	https://www.youtube.com/watch?v=Cij1RvquGvU
14	Palilalia	a repetição da sílaba ou palavra inicial, semelhantemente à gagueira, também pode ocorrer em pacientes com doença mais avançada e pode ser um efeito colateral dos medicamentos. Sialorréia (secreção excessiva de saliva) e disfagia (dificuldade de deglutição) são problemas comuns em pacientes com doença mais avançada.	https://www.youtube.com/embed/tsZLZ0TZ_X8	2	https://www.youtube.com/watch?v=tsZLZ0TZ_X8
15	Humor	A alteração do humor é um dos sintomas não motores mais comuns na Doença de Parkinson, podendo até surgir muito antes dos sintomas.	https://www.youtube.com/embed/CTfG95JnSy8	2	https://www.youtube.com/watch?v=CTfG95JnSy8
6	Depressão	A depressão é uma comorbidade comum em função da carência da dopamina no organismo do parkinsoniano. Apresenta uma associação muito forte com outros sintomas não motores tais como a fadiga, a falta de energia, a lentificação psicomotora, a dor, a diminuição do apetite e as perturbações do sono. O tratamento da sintomatologia depressiva poderá ajudar a reduzir o impacto das mesmas.	https://www.youtube.com/embed/3yyULmp_5l0	2	https://www.youtube.com/watch?v=3yyULmp_5l0
1	Ansiedade	A ansiedade corresponde a preocupação com acontecimentos futuros e o medo é uma reação aos acontecimentos do presente. Esses sentimentos podem causar sintomas físicos, como ritmo cardíaco acelerado ou tremores.  A sintomatologia ansiosa é bastante comum na Doença de Parkinson, podendo ser independente ou concomitante à depressão. No entanto, sabemos que quando existe sintomatologia depressiva, a ansiedade é um componente proeminente. Muitas vezes está relacionada com flutuações motoras induzidas pela medicação, podendo manifestar-se como ataques de pânico, fobias e perturbação da ansiedade generalizada.	https://www.youtube.com/embed/k4IC_LfPINI	2	https://www.youtube.com/embed/k4IC_LfPINI
16	Cognição	A diminuição do funcionamento cognitivo é muito comum nesta doença. As alterações cognitivas que acompanham a Doença de Parkinson estão relacionadas ao nível da atenção, ao funcionamento executivo (dificuldade em planejar uma tarefa) e a memória (dificuldade em evocar nomes ou informação previamente memorizada). Podem existir alterações em outros domínios cognitivos, principalmente ao nível da capacidade visuo-perceptiva e da velocidade de processamento de informação. Com a evolução de doença, o paciente pode evoluir com quadros demenciais. É importante esclarecer que, apesar da sua prevalência considerável nesta população clínica, a Doença de Parkinson não é necessariamente acompanhada por um quadro demencial.	https://www.youtube.com/embed/c6fQ2O03n-I	2	https://www.youtube.com/watch?v=c6fQ2O03n-I
17	Sonolência diurna excessiva	Doentes podem adormecer ao volante, durante uma conversa ou no cinema. Em casos mais graves, a pessoa pode experienciar “ataques de sono” repentinos que não consegue controlar.	https://www.youtube.com/embed/53XNNELHwxA	2	https://www.youtube.com/watch?v=53XNNELHwxA
19	Perturbação do sono REM	caracterizada pela presença de sonhos vividos e presença de movimentos complexos durante o sono REM (movimentos rápidos dos olhos), sem a habitual “paralisia” muscular que se encontra nas pessoas saudáveis. Os doentes podem cair da cama, falar e rir à gargalhada e normalmente não se lembra dos episódios, sendo a história relatada pelo parceiro/a.	https://www.youtube.com/embed/9TJdKbMrbPQ	2	https://www.youtube.com/watch?v=9TJdKbMrbPQ
20	Constipação Intestinal	A constipação é uma das queixas mais comuns entre os pacientes com doença de Parkinson. O problema resulta de uma combinação entre o processo neurodegenerativo que afeta a motilidade gastrointestinal e os efeitos de medicamentos dopaminérgicos.	https://www.youtube.com/embed/0rXM4KESSEg	2	https://www.youtube.com/watch?v=0rXM4KESSEg
21	Dor	Entre os sintomas não motores da doença de Parkinson, a dor é frequentemente desconhecida e raramente tratada, sendo uma importante fonte de angústia para estes pacientes. Quatro diferentes tipos de dor foram categorizados nos parkinsonianos: a dor muscular (devido à rigidez), distônica, radicular-neuropática (devido à lesão radicular, neuropatia focal ou periférica) e dor central.	https://www.youtube.com/embed/NQfYofmRxVA	2	https://www.youtube.com/watch?v=NQfYofmRxVA
18	Diminuição da capacidade olfativa	É um sintoma comum, mas muitas vezes ignorado que pode ocorrer muito tempo antes dos sintomas motores.	https://www.youtube.com/embed/BBOVUYtS7lQ	2	https://www.youtube.com/watch?v=BBOVUYtS7lQ
23	Distúrbios urogenitais	O distúrbio urogenital mais comum entre os portadores da doença de Parkinson é a incontinência urinária, que é a perda involuntária da urina pela uretra.	https://www.youtube.com/embed/vy7cGWY7bGw	2	https://www.youtube.com/watch?v=vy7cGWY7bGw
24	Distúrbios respiratórios	Costumam aparecer em fases mais avançadas da doença, com queixas de incômodo para respirar (dispneia). São frequentes infecções respiratórias geradas pela falta de coordenação com a deglutição e respiração durante as refeições. Esses distúrbios também podem afetar a fala.	https://www.youtube.com/embed/NcNHI5a8f9o	2	https://www.youtube.com/watch?v=NcNHI5a8f9o
25	Distúrbios da regulação da temperatura	Os pacientes com doença de Parkinson apresentam sensações de calor e frio diferentes, além de queda da temperatura corporal e sudorese excessiva. Esse distúrbio pode ser decorrente do tratamento medicamentoso para a doença.	https://www.youtube.com/embed/uE1bpw_XMRc	2	https://www.youtube.com/watch?v=uE1bpw_XMRc
26	Hipotensão Ortostática	Alguns portadores de doença de Parkinson apresentam quadros de hipotensão (pressão baixa) ao ficarem de pé. A queda de pressão gera tonturas, fraqueza e mal-estar, podendo ocasionar tombos e tropeços.	https://www.youtube.com/embed/WrrlradG1No	2	https://www.youtube.com/watch?v=WrrlradG1No
22	Hiperidrose 	Suor excessivo, especialmente das mãos e pés.	https://www.youtube.com/embed/Q9aErE9bLXE	2	https://www.youtube.com/watch?v=Q9aErE9bLXE
27	Seborreia	Um dos quadros mais comuns nos estágios iniciais da doença de Parkinson é a seborreia. Ela provoca o aumento da oleosidade na pele, que leva à coceira e vermelhidão, e afeta principalmente cabelos e rosto. Suspeita-se que a causa seja a redução da dopamina que atua nas glândulas sebáceas sob a pele.	https://www.youtube.com/embed/dxBh208BhaA	2	https://www.youtube.com/watch?v=dxBh208BhaA
28	Aprendendo a aplicar a UPDRS	Video explicativo passo-a-passo da aplicação da escala UPDRS.	https://www.youtube.com/embed/NXfK3mBlCq4	4	https://www.movementdisorders.org/MDS-Files1/Education/Rating-Scales/MDS-UPDRS_Portuguese_Official_Translation_FINAL.pdf
\.


--
-- Name: sintoma_id_seq; Type: SEQUENCE SET; Schema: parkinson; Owner: postgres
--

SELECT pg_catalog.setval('sintoma_id_seq', 28, true);


SET search_path = prodata, pg_catalog;

--
-- Data for Name: avalia_tremor; Type: TABLE DATA; Schema: prodata; Owner: postgres
--

COPY avalia_tremor (id, individuo_fk_id, tipo_desenho, desenho, classificador, proba_saudavel, proba_tremor, data_hora, observacao) FROM stdin;
1	34	espiral	5ffe3f6668571.jpg	SVM	19.1000004	80.9000015	2021-01-12 21:31:00	teste 123
\.


--
-- Name: avalia_tremor_id_seq; Type: SEQUENCE SET; Schema: prodata; Owner: postgres
--

SELECT pg_catalog.setval('avalia_tremor_id_seq', 9, true);


SET search_path = public, pg_catalog;

--
-- Data for Name: cidade; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cidade (id, nome, codigo_ibge, estado_fk_id, populacao_2010, densidade_demo, gentilico, area) FROM stdin;
3	Brasiléia	120010	1	21398	5	brasileense	3917
5	Capixaba	120017	1	8798	5	capixabense	1703
7	Epitaciolândia	120025	1	15100	9	epitaciolandense	1655
8	Feijó	120030	1	32412	1	feijoense	27975
10	Mâncio Lima	120033	1	15206	3	mancio-limense	5453
12	Marechal Thaumaturgo	120035	1	14227	2	thaumaturguense	8192
14	Porto Acre	120080	1	14880	6	portoacrense	2605
15	Porto Walter	120039	1	9176	1	portowaltense	6444
17	Rodrigues Alves	120042	1	14389	5	rodriguesalvense	3077
19	Sena Madureira	120050	1	38029	2	sena-madureirense	23751
21	Tarauacá	120060	1	35590	2	tarauacaense	20171
22	Xapuri	120070	1	16091	3	xapuriense	5347
24	Anadia	270020	2	17424	92	anadiense	189
26	Atalaia	270040	2	44322	84	atalaiense	529
28	Barra De São Miguel	270060	2	7574	99	barrense	77
29	Batalha	270070	2	17076	53	batalhense	321
31	Belo Monte	270090	2	7030	21	belo-montense	334
33	Branquinha	270110	2	10583	64	branquinhense	166
34	Cacimbinhas	270120	2	10195	37	cacimbense	273
36	Campestre	270135	2	6598	99	camprestrense	66
38	Campo Grande	270150	2	9032	54	campo-grandense	167
40	Capela	270170	2	17077	70	capelense	243
41	Carneiros	270180	2	8290	73	carneirense	113
43	Coité Do Nóia	270200	2	10926	123	coitenense	89
45	Coqueiro Seco	270220	2	5526	139	coqueirense	40
47	Craíbas	270235	2	22641	83	craibense	271
49	Dois Riachos	270250	2	10880	77	riachense	140
50	Estrela De Alagoas	270255	2	17251	66	estrelense	260
52	Feliz Deserto	270270	2	4345	47	feliz-desertense	92
54	Girau Do Ponciano	270290	2	36600	73	ponciense	501
55	Ibateguara	270300	2	15149	57	ibateguarense	265
57	Igreja Nova	270320	2	23292	55	igreja-novense	427
59	Jacaré Dos Homens	270340	2	5413	38	jacarezeiro	142
61	Japaratinga	270360	2	7754	90	japaratinguense	86
63	Jequiá Da Praia	270375	2	12029	34	jequiaenses	352
64	Joaquim Gomes	270380	2	22575	76	juruquense	298
66	Junqueiro	270400	2	23836	99	junqueirense	242
68	Limoeiro De Anadia	270420	2	26992	85	limoeirense	316
70	Major Isidoro	270440	2	18897	42	isidorense	454
71	Mar Vermelho	270490	2	3652	39	mar-vermelhense	93
73	Maravilha	270460	2	10284	34	maravilhense	302
75	Maribondo	270480	2	13619	78	maribondense	174
77	Matriz De Camaragibe	270510	2	23785	108	matrizense	220
78	Messias	270520	2	15682	138	messiense	114
80	Monteirópolis	270540	2	6935	81	guaribense	86
82	Novo Lino	270560	2	12060	52	novo-linense	233
84	Olho D`Água Do Casado	270580	2	8491	26	casadense	323
85	Olho D`Água Grande	270590	2	4957	42	olho-grandense	119
87	Ouro Branco	270610	2	10912	53	ouro-branquense	205
89	Palmeira Dos Índios	270630	2	70368	155	palmeirense	453
91	Pariconha	270642	2	10264	40	pariconhense	259
92	Paripueira	270644	2	11347	122	paripueirense	93
94	Paulo Jacinto	270660	2	7426	63	paulo-jacintense	118
96	Piaçabuçu	270680	2	17203	72	piaçabuçuense	240
97	Pilar	270690	2	33305	133	pilarense	250
99	Piranhas	270710	2	23045	56	piranhense	408
101	Porto Calvo	270730	2	25708	83	porto-calvense	308
103	Porto Real Do Colégio	270750	2	19334	80	colegiense	242
104	Quebrangulo	270760	2	11480	36	quebrangulense	320
106	Roteiro	270780	2	6656	51	roteirense	129
108	Santana Do Ipanema	270800	2	44932	103	santanense	438
109	Santana Do Mundaú	270810	2	10961	49	mundauense	225
111	São José Da Laje	270830	2	22686	88	lajense	257
113	São Luís Do Quitunde	270850	2	32412	82	quitundense	397
114	São Miguel Dos Campos	270860	2	54577	151	miguelense	361
116	São Sebastião	270880	2	32010	102	salomeense	315
117	Satuba	270890	2	14603	343	satubense	43
119	Tanque D`Arca	270900	2	6122	47	tanquense	130
121	Teotônio Vilela	270915	2	41152	138	vilelano	298
122	Traipu	270920	2	25702	37	traipusense	698
124	Viçosa	270940	2	25407	74	viçosense	343
126	Amaturá	130006	3	9467	2	amaturaense	4759
2713	Princesa Isabel	251230	15	21283	58	princesense	368
129	Apuí	130014	3	18007	0	apuiense	54240
131	Autazes	130030	3	32135	4	autazense	7599
132	Barcelos	130040	3	25718	0	barcelense	122476
134	Benjamin Constant	130060	3	33411	4	benjamin-constantense	8793
136	Boa Vista Do Ramos	130068	3	14979	6	boa-vistense	2587
138	Borba	130080	3	34961	1	borbense	44252
140	Canutama	130090	3	12738	0	canutamense	29820
141	Carauari	130100	3	25774	1	carauariense	25768
143	Careiro Da Várzea	130115	3	23930	9	careirense-da-várzea	2631
145	Codajás	130130	3	23206	1	codajasense	18712
147	Envira	130150	3	16338	2	envirense	7499
149	Guajará	130165	3	13974	2	guajaraense	7580
150	Humaitá	130170	3	44227	1	humaitaense	33072
152	Iranduba	130185	3	40781	18	irandubense	2214
154	Itamarati	130195	3	8038	0	itamaratiense	25276
156	Japurá	130210	3	7326	0	japuraense	55792
158	Jutaí	130230	3	17992	0	jutaiense	69552
159	Lábrea	130240	3	37701	1	labrense	68234
161	Manaquiri	130255	3	22801	6	manaquirense	3976
163	Manicoré	130270	3	47017	1	manicoreense	48283
165	Maués	130290	3	52236	1	maueense	39990
166	Nhamundá	130300	3	18278	1	nhamundaense	14106
168	Novo Airão	130320	3	14723	0	novo-airãoense	37771
170	Parintins	130340	3	102033	17	parintinense	5952
171	Pauini	130350	3	18166	0	pauiniense	41610
173	Rio Preto Da Eva	130356	3	25719	4	rio-pretense	5813
175	Santo Antônio Do Içá	130370	3	24481	2	santoense	12307
177	São Paulo De Olivença	130390	3	31422	2	paulivense	19746
178	São Sebastião Do Uatumã	130395	3	10705	1	uatumaense	10741
179	Silves	130400	3	8444	2	silvense	3749
181	Tapauá	130410	3	19077	0	tapauense	89325
183	Tonantins	130423	3	17079	3	tonantinense	6433
185	Urucará	130430	3	17094	1	urucaraense	27903
187	Amapá	160010	4	8069	1	amapaense	9176
188	Calçoene	160020	4	9000	1	calçoenense	14269
190	Ferreira Gomes	160023	4	5802	1	ferreirense	5046
192	Laranjal Do Jari	160027	4	39942	1	laranjalense	30972
194	Mazagão	160040	4	17032	1	mazaganistas	13131
196	Pedra Branca Do Amaparí	160015	4	10772	1	pedrabrancanienses	9495
198	Pracuúba	160055	4	3793	1	pracuubenses	4956
199	Santana	160060	4	101262	64	santanenses	1580
201	Tartarugalzinho	160070	4	12563	2	tartarugalense	6710
203	Abaíra	290010	5	8316	16	abairense	530
206	Adustina	290035	5	15702	25	adustinense	632
208	Aiquara	290060	5	4602	29	aiquarense	160
210	Alcobaça	290080	5	21271	14	alcobacense	1481
211	Almadina	290090	5	6357	25	almadinense	251
213	Amélia Rodrigues	290110	5	25190	145	ameliense	173
215	Anagé	290120	5	25516	13	anageense	1947
217	Andorinha	290135	5	14414	12	andorinhense	1248
218	Angical	290140	5	14073	9	angicalense	1528
220	Antas	290160	5	17072	53	antense	320
222	Antônio Gonçalves	290180	5	11015	35	antônio-gonçalvense	314
224	Apuarema	290195	5	7459	48	apuaremense	155
225	Araças	290205	5	11561	24	araçaense	487
227	Araci	290210	5	51651	33	araciense	1556
229	Arataca	290225	5	10392	28	arataquense	375
231	Aurelino Leal	290240	5	13595	30	aurelinense	458
233	Baixa Grande	290260	5	20060	21	baixa-grandense	947
234	Banzaê	290265	5	11814	52	banzaêense	227
236	Barra Da Estiva	290280	5	21187	16	barrestivense	1347
238	Barra Do Mendes	290300	5	13987	9	barra-mendense	1541
239	Barra Do Rocha	290310	5	6313	30	barra-rochense	208
241	Barro Alto	290323	5	13612	33	barro-altino	417
243	Barro Preto	290330	5	6453	50	barro-pretense	128
245	Belo Campo	290350	5	16021	25	belo-campense	629
246	Biritinga	290360	5	14836	27	biritinguense	550
248	Boa Vista Do Tupim	290380	5	17991	6	tupinense	2811
250	Bom Jesus Da Serra	290395	5	10113	24	bom-jesuense	422
252	Bonito	290405	5	14834	20	bonitense	727
253	Boquira	290410	5	22037	15	boquirense	1483
255	Brejões	290430	5	14282	30	brejoense	481
2716	Quixabá	251260	15	1699	11	quixabense	157
258	Brumado	290460	5	64602	29	brumadense	2227
260	Buritirama	290475	5	19600	5	buritiramense	3942
262	Cabaceiras Do Paraguaçu	290485	5	17327	77	cabaceirense	226
264	Caculé	290500	5	22236	33	caculense	668
265	Caém	290510	5	10368	19	caenense	548
267	Caetité	290520	5	47515	19	caetiteense	2443
269	Cairu	290540	5	15374	33	cairuense	461
271	Camacan	290560	5	31472	50	camacaense	627
272	Camaçari	290570	5	242970	310	camaçariense	785
275	Campo Formoso	290600	5	66616	9	campo-formosense	7259
276	Canápolis	290610	5	9410	22	canapolense	437
278	Canavieiras	290630	5	32336	24	canavieirense	1327
279	Candeal	290640	5	8895	20	candealense	445
281	Candiba	290660	5	13210	32	candibense	418
283	Cansanção	290680	5	32908	24	cansançãoense	1345
285	Capela Do Alto Alegre	290685	5	11527	18	capelense	649
287	Caraíbas	290689	5	10222	13	caraibense	806
288	Caravelas	290690	5	21414	9	caravelense	2393
290	Carinhanha	290710	5	28380	10	carinhanhense	2737
292	Castro Alves	290730	5	25408	36	castro-alvense	712
293	Catolândia	290740	5	2612	4	catolandiano	643
295	Caturama	290755	5	8843	13	caturamense	665
297	Chorrochó	290770	5	10734	4	chorrochoense	3005
299	Cipó	290790	5	15755	123	cipoense	128
300	Coaraci	290800	5	20964	74	coaraciense	283
302	Conceição Da Feira	290820	5	20391	125	conceiçoense	163
304	Conceição Do Coité	290840	5	62040	61	coiteense	1016
306	Conde	290860	5	23620	24	condense	965
307	Condeúba	290870	5	16898	13	condeubense	1286
309	Coração De Maria	290890	5	22401	64	mariense	348
310	Cordeiros	290900	5	8168	15	cordeirense	535
312	Coronel João Sá	290920	5	17066	19	joão-saense	883
314	Cotegipe	290940	5	13636	3	cotegipano	4196
316	Crisópolis	290960	5	20046	33	crisopolense	608
317	Cristópolis	290970	5	13280	13	cristopolense	1043
319	Curaçá	290990	5	32168	5	curaçaense	6079
321	Dias D`Ávila	291005	5	66440	361	diasdavilense	184
322	Dom Basílio	291010	5	11355	17	dom-basiliense	677
324	Elísio Medrado	291030	5	7947	41	medradense	194
326	Entre Rios	291050	5	39872	33	entrerriense	1215
328	Esplanada	291060	5	32802	25	esplanadense	1321
329	Euclides Da Cunha	291070	5	56289	25	euclidense	2235
331	Fátima	291075	5	17652	49	fatimense	359
333	Feira De Santana	291080	5	556642	416	feirense	1338
334	Filadélfia	291085	5	16740	29	filadelfense	570
336	Floresta Azul	291100	5	10660	36	floresta-azulense	293
338	Gandu	291120	5	30336	125	ganduense	243
339	Gavião	291125	5	4561	12	gavionense	370
341	Glória	291140	5	15076	12	gloriense	1256
343	Governador Mangabeira	291160	5	19818	186	mangabeirense	106
344	Guajeru	291165	5	10412	11	guajeruense	936
346	Guaratinga	291180	5	22165	10	guaratinguense	2325
348	Iaçu	291190	5	25736	11	iaçuense	2451
350	Ibicaraí	291210	5	24272	105	ibicaraiense	232
352	Ibicuí	291230	5	15785	13	ibicuiense	1177
353	Ibipeba	291240	5	17008	12	ibipebense	1384
355	Ibiquera	291260	5	4866	5	ibiquerense	945
357	Ibirapuã	291280	5	7956	10	ibirapuense	788
359	Ibitiara	291300	5	15508	8	ibitiarense	1848
360	Ibititá	291310	5	17840	29	ibititaense	624
362	Ichu	291330	5	5255	41	ichuense	128
364	Igrapiúna	291345	5	13343	25	igrapiunense	527
366	Ilhéus	291360	5	184236	105	ilheuense	1760
368	Ipecaetá	291380	5	15331	41	ipecaetense	370
369	Ipiaú	291390	5	44390	166	ipiauense	267
371	Ipupiara	291410	5	9285	9	ipupiarense	1061
373	Iramaia	291430	5	11990	6	iramaense	1947
375	Irará	291450	5	27466	99	iraraense	278
376	Irecê	291460	5	66181	207	ireceense	319
378	Itaberaba	291470	5	61631	26	itaberabense	2344
380	Itacaré	291490	5	24318	33	itacareense	738
382	Itagi	291510	5	13051	50	itagiense	259
384	Itagimirim	291530	5	7110	8	itagimiriense	839
387	Itajuípe	291550	5	21081	74	itajuipense	284
389	Itamari	291570	5	7903	71	itamariense	111
391	Itanagra	291590	5	7598	15	itanagrense	491
392	Itanhém	291600	5	20216	14	itanhense	1464
394	Itapé	291620	5	10995	24	itapeense	459
396	Itapetinga	291640	5	68273	42	itapetinguense	1627
398	Itapitanga	291660	5	10207	25	itapitanguense	408
400	Itarantim	291680	5	18539	10	itarantinense	1805
401	Itatim	291685	5	14522	25	itatinhense	583
403	Itiúba	291700	5	36113	21	itiubense	1723
405	Ituaçu	291720	5	18127	15	ituaçuense	1216
407	Iuiú	291733	5	10900	7	iuiuense	1486
409	Jacaraci	291740	5	13651	11	jacaraciense	1236
410	Jacobina	291750	5	79247	34	jacobinense	2360
412	Jaguarari	291770	5	30343	12	jaguarariense	2457
414	Jandaíra	291790	5	10331	16	jandairense	641
416	Jeremoabo	291810	5	37680	8	jeremoabense	4656
417	Jiquiriçá	291820	5	14118	59	jiquiriçaense	239
420	Juazeiro	291840	5	197965	30	juazeirense	6501
421	Jucuruçu	291845	5	10290	7	jucuruçuense	1399
423	Jussari	291855	5	6474	18	jussariense	357
424	Jussiape	291860	5	8031	14	jussiapense	585
426	Lagoa Real	291875	5	13934	16	lagoa-realense	877
428	Lajedão	291890	5	3733	6	lajedãoense	616
430	Lajedo Do Tabocal	291905	5	8305	19	lagedense	432
431	Lamarão	291910	5	9560	55	lamarãoense	174
433	Lauro De Freitas	291920	5	163449	3	lauro-freitense	58
435	Licínio De Almeida	291940	5	12311	15	licínio-de-almeidense	843
437	Luís Eduardo Magalhães	291955	5	60105	15	luiseduardense	3941
438	Macajuba	291960	5	11229	17	macajubense	650
440	Macaúbas	291980	5	47051	16	macaubense	2994
442	Madre De Deus	291992	5	17376	540	madre-deusense	32
444	Maiquinique	292000	5	8782	18	maiquiniquense	492
446	Malhada	292020	5	16014	8	malhadense	2008
448	Manoel Vitorino	292040	5	14387	6	manoel-vitorinense	2254
449	Mansidão	292045	5	12592	4	mansidãoense	3177
451	Maragogipe	292060	5	42815	97	maragogipano	440
453	Marcionílio Souza	292080	5	10500	8	marcionilense	1277
455	Mata De São João	292100	5	40183	63	matense	633
456	Matina	292105	5	11145	14	matinense	776
458	Miguel Calmon	292120	5	26475	17	calmonense	1568
460	Mirangaba	292140	5	16279	10	mirangabense	1698
461	Mirante	292145	5	10507	10	mirantense	1061
463	Morpará	292160	5	8280	5	morparaense	1697
465	Mortugaba	292180	5	12477	20	mortugabense	612
467	Mucuri	292200	5	36026	20	mucuriense	1781
469	Mundo Novo	292210	5	24395	16	mundo-novense	1493
470	Muniz Ferreira	292220	5	7317	66	ferreirense	110
472	Muritiba	292230	5	28899	324	muritibano	89
473	Mutuípe	292240	5	21449	76	mutuipense	283
475	Nilo Peçanha	292260	5	12530	31	nilo-peçanhense	399
477	Nova Canaã	292270	5	16713	20	canaense	854
479	Nova Ibiá	292275	5	6648	37	nova-ibiaense	179
481	Nova Redenção	292285	5	8034	19	nova-redençoense	431
482	Nova Soure	292290	5	24136	25	nova-souriense	950
484	Novo Horizonte	292303	5	10673	18	novo-horizontino	609
486	Olindina	292310	5	24943	46	olindinense	542
488	Ouriçangas	292330	5	8298	54	ouriçanguense	155
489	Ourolândia	292335	5	16425	11	ourolandense	1488
491	Palmeiras	292350	5	8410	13	palmeirense	658
492	Paramirim	292360	5	21001	18	paramirinhense	1170
494	Paripiranga	292380	5	27778	64	paripiranguense	436
496	Paulo Afonso	292400	5	108396	69	paulo-afonsino	1580
498	Pedrão	292410	5	6876	43	pedronense	160
500	Piatã	292430	5	17982	10	piatãense	1713
501	Pilão Arcado	292440	5	32860	3	pilão-arcadense	11732
503	Pindobaçu	292460	5	20121	41	pindobaçuense	496
505	Piraí Do Norte	292467	5	9799	52	piraiense	187
506	Piripá	292470	5	12783	29	piripaense	440
508	Planaltino	292490	5	8822	10	planaltinense	927
510	Poções	292510	5	44701	54	poçoense	827
512	Ponto Novo	292525	5	15742	32	ponto-novense	497
514	Potiraguá	292540	5	9810	10	potiragüense	985
515	Prado	292550	5	27627	16	pradense	1740
518	Presidente Tancredo Neves	292575	5	23846	57	tancredense	417
519	Queimadas	292580	5	24602	12	queimadense	2024
521	Quixabeira	292593	5	9554	25	quixabeirense	388
523	Remanso	292600	5	38957	8	remansense	4684
525	Riachão Das Neves	292620	5	21937	4	riachão-nevense	5670
527	Riacho De Santana	292640	5	30646	12	riachense	2582
528	Ribeira Do Amparo	292650	5	14276	22	amparense	643
530	Ribeirão Do Largo	292665	5	8602	7	ribeirense	1271
531	Rio De Contas	292670	5	13007	12	rio-contense	1064
533	Rio Do Pires	292690	5	11918	15	rio-pirense	820
535	Rodelas	292710	5	7775	3	rodelense	2724
536	Ruy Barbosa	292720	5	29887	14	rui-barbosense	2171
538	Salvador	292740	5	2675656	4	soteropolitano	693
540	Santa Brígida	292760	5	15060	17	santa-brigidense	883
542	Santa Cruz Da Vitória	292780	5	6673	22	santa-cruzense	298
543	Santa Inês	292790	5	10363	33	santinense	316
545	Santa Maria Da Vitória	292810	5	40309	20	santa-mariense	1967
547	Santa Teresinha	292850	5	9648	14	santa-teresinhense	707
548	Santaluz	292800	5	33838	22	luzense	1560
550	Santanópolis	292830	5	8776	38	santanopolinense	231
552	Santo Antônio De Jesus	292870	5	90985	348	santo-antoniense	261
554	São Desidério	292890	5	27659	2	são-desideriano	15157
556	São Felipe	292910	5	20305	99	são-felipense	206
557	São Félix	292900	5	14098	142	são-felista	99
559	São Francisco Do Conde	292920	5	33183	126	franciscano	263
561	São Gonçalo Dos Campos	292930	5	33283	111	são-gonçalense	301
563	São José Do Jacuípe	292937	5	10180	25	jacuipense	406
564	São Miguel Das Matas	292940	5	10414	49	miguelense	214
566	Sapeaçu	292960	5	16585	142	sapeaçuense	117
567	Sátiro Dias	292970	5	18964	19	satirense	1010
569	Saúde	292980	5	11845	23	saudense	504
571	Sebastião Laranjeiras	293000	5	10371	5	sebastianense	1948
573	Sento Sé	293020	5	37425	3	sento-seense	12699
574	Serra Do Ramalho	293015	5	31638	12	serra-malhense	2593
576	Serra Preta	293040	5	15401	29	serra-pretense	536
577	Serrinha	293050	5	76762	117	serrinhense	659
579	Simões Filho	293070	5	118047	587	simões-filhense	201
581	Sítio Do Quinto	293076	5	12592	18	sítio-quintense	702
583	Souto Soares	293080	5	15899	16	souto-soarense	993
585	Tanhaçu	293100	5	20013	16	tanhaçuense	1234
586	Tanque Novo	293105	5	16128	22	tanque-novense	723
588	Taperoá	293120	5	18748	46	taperoense	411
590	Teixeira De Freitas	293135	5	138341	119	teixeirense	1164
592	Teofilândia	293150	5	21482	64	teofilandense	336
593	Teolândia	293160	5	14836	47	teolandense	318
595	Tremedal	293180	5	17029	10	tremedalense	1680
597	Uauá	293200	5	24294	8	uauaense	3035
598	Ubaíra	293210	5	19750	27	ubairense	726
600	Ubatã	293230	5	25004	93	ubatense	268
602	Umburanas	293245	5	17000	10	umburanense	1670
604	Urandi	293260	5	16466	17	urandiense	969
606	Utinga	293280	5	18173	28	utinguense	638
608	Valente	293300	5	24560	64	valentense	384
609	Várzea Da Roça	293305	5	13786	27	varzeano	514
611	Várzea Nova	293315	5	13073	11	várzea-novense	1193
613	Vera Cruz	293320	5	37567	125	vera-cruzense	300
615	Vitória Da Conquista	293330	5	306866	90	conquistense	3406
616	Wagner	293340	5	8983	21	wagnense	421
619	Xique Xique	293360	5	45536	8	xiquexiquense	5502
621	Acarape	230015	6	15338	96	acarapense	160
623	Acopiara	230030	6	51160	23	acopiarense	2254
625	Alcântaras	230050	6	10771	78	alcantarense	139
627	Alto Santo	230070	6	16359	12	alto-santense	1338
629	Antonina Do Norte	230080	6	6984	27	antonino	260
630	Apuiarés	230090	6	13925	25	apuiareense	552
632	Aracati	230110	6	69159	55	aracatiense	1247
634	Ararendá	230125	6	10491	30	ararendaense	344
636	Aratuba	230140	6	11529	100	aratubano	115
637	Arneiroz	230150	6	7650	7	arneirozense	1066
639	Aurora	230170	6	24566	28	aurorense	890
641	Banabuiú	230185	6	17315	16	banabuiense	1080
2718	Riachão	251274	15	3266	36	riachãoense	90
643	Barreira	230195	6	19573	81	barreirense	241
645	Barroquinha	230205	6	14476	38	barroquinhense	383
647	Beberibe	230220	6	49311	30	beberibense	1624
649	Boa Viagem	230240	6	52498	19	boa-viagense	2837
650	Brejo Santo	230250	6	45193	68	brejo-santense	663
652	Campos Sales	230270	6	26506	24	campos-salense	1083
654	Capistrano	230290	6	17062	77	capistranense	223
656	Cariré	230310	6	18347	24	carireense	757
658	Cariús	230330	6	18567	17	cariuense	1062
659	Carnaubal	230340	6	16746	46	carnaubalense	365
661	Catarina	230360	6	18745	39	catarinense	487
663	Caucaia	230370	6	325441	266	caucaiense	1224
665	Chaval	230390	6	12615	53	chavalense	238
666	Choró	230393	6	12853	16	choroense	816
668	Coreaú	230400	6	21954	28	coreauense	776
670	Crato	230420	6	121428	105	cratense	1158
672	Cruz	230425	6	22479	67	cruzense	334
674	Ererê	230427	6	6840	17	erereense	396
675	Eusébio	230428	6	46033	583	eusebiano	79
677	Forquilha	230435	6	21786	42	forquilhense	517
679	Fortim	230445	6	14817	53	fortinense	282
680	Frecheirinha	230450	6	12991	72	frecheirinhense	181
682	Graça	230465	6	15049	53	gracense	282
684	Granjeiro	230480	6	4629	46	granjeirense	100
686	Guaiúba	230495	6	24091	95	guaiubano	254
687	Guaraciaba Do Norte	230500	6	37775	62	guaraciabense	611
689	Hidrolândia	230520	6	19325	21	hidrolandiense	927
691	Ibaretama	230526	6	12922	15	ibaretamense	877
693	Ibicuitinga	230533	6	11335	27	ibicuitinguense	424
694	Icapuí	230535	6	18392	43	icapuiense	423
696	Iguatu	230550	6	96495	95	iguatuense	1017
698	Ipaporanga	230565	6	11343	16	ipaporanguense	702
700	Ipu	230580	6	40296	64	ipuense	629
701	Ipueiras	230590	6	37862	26	ipueirense	1477
703	Irauçuba	230610	6	22324	15	irauçubense	1451
705	Itaitinga	230625	6	35817	237	itaitiguense	151
707	Itapipoca	230640	6	116065	72	itapipoquense	1604
708	Itapiúna	230650	6	18626	32	itapiunense	589
710	Itatira	230660	6	18894	24	itatirense	783
712	Jaguaribara	230680	6	10399	16	jaguaribarense	669
714	Jaguaruana	230700	6	32236	38	jaguaruanense	847
715	Jardim	230710	6	26688	51	jardinense	519
718	Juazeiro Do Norte	230730	6	249939	1	juazeirense	248
719	Jucás	230740	6	23807	25	jucaense	937
721	Limoeiro Do Norte	230760	6	56264	75	limoeirense	752
722	Madalena	230763	6	18088	18	madalenense	1026
724	Maranguape	230770	6	113561	192	maranguapense	591
726	Martinópole	230790	6	10214	34	martinolopolitano	299
728	Mauriti	230810	6	44240	41	mauritiense	1079
729	Meruoca	230820	6	13693	91	meruoquense	150
731	Milhã	230835	6	13086	26	milhanense	502
733	Missão Velha	230840	6	34274	53	missanvelhense	651
735	Monsenhor Tabosa	230860	6	16705	19	tabosense	894
736	Morada Nova	230870	6	62065	22	morada-novense	2779
738	Morrinhos	230890	6	20700	50	morrinhense	416
740	Mulungu	230910	6	11485	120	mulunguense	96
742	Nova Russas	230930	6	30965	42	nova-russano	743
744	Ocara	230945	6	24007	31	ocarense	765
745	Orós	230950	6	21389	37	oroense	576
747	Pacatuba	230970	6	72299	498	pacatubano	145
749	Pacujá	230990	6	5986	79	pacujaense	76
750	Palhano	231000	6	8866	20	palhanense	440
752	Paracuru	231020	6	31636	107	paracuruense	296
754	Parambu	231030	6	31309	14	parambuense	2312
756	Pedra Branca	231050	6	41890	32	pedra-branquense	1303
758	Pentecoste	231070	6	35400	26	pentecostense	1378
760	Pindoretama	231085	6	18683	256	pindoretamense	73
762	Pires Ferreira	231095	6	10216	42	pires-ferreirense	243
763	Poranga	231100	6	12001	9	poranguense	1309
765	Potengi	231120	6	10276	30	potengiense	339
767	Quiterianópolis	231126	6	19921	19	quiterianopolense	1041
769	Quixelô	231135	6	15000	26	quixeloense	583
771	Quixeré	231150	6	19412	32	quixereense	611
772	Redenção	231160	6	26415	117	redencionista	226
2721	Riacho De Santo Antônio	251278	15	1722	19	riachoantoniense	91
776	Salitre	231195	6	15453	19	salitrense	804
778	Santana Do Acaraú	231200	6	29946	31	santanense-do-acaraú	969
780	São Benedito	231230	6	44178	131	beneditense	338
781	São Gonçalo Do Amarante	231240	6	43890	52	gonçalense	839
783	São Luís Do Curu	231260	6	12332	101	curuense	122
784	Senador Pompeu	231270	6	26469	28	pompeuense	956
786	Sobral	231290	6	188233	89	sobralense	2123
788	Tabuleiro Do Norte	231310	6	29204	34	tabuleirense	862
790	Tarrafas	231325	6	8910	20	tarrafense	454
791	Tauá	231330	6	55716	14	tauaense	4009
793	Tianguá	231340	6	68892	76	tianguaense	909
795	Tururu	231355	6	14408	71	tururuense	202
797	Umari	231370	6	7545	29	umariense	264
798	Umirim	231375	6	18802	59	umiriense	317
800	Uruoca	231390	6	12883	18	uruoquense	697
802	Várzea Alegre	231400	6	38434	46	varzea-alegrense	836
804	Brasília	530010	7	2570160	444	brasiliense	5788
806	Água Doce Do Norte	320016	8	11771	24	água-docense	484
807	Águia Branca	320013	8	9519	21	aguiabranquense	450
809	Alfredo Chaves	320030	8	13955	23	alfredense	616
811	Anchieta	320040	8	23902	59	anchietense	408
812	Apiacá	320050	8	7512	39	apiacaense	194
815	Baixo Guandu	320080	8	29081	32	guanduense	918
816	Barra De São Francisco	320090	8	40649	44	franciscano	934
818	Bom Jesus Do Norte	320110	8	9476	106	bom-jesuense	89
819	Brejetuba	320115	8	11915	35	brejetubense	343
821	Cariacica	320130	8	348738	1	cariaciquense	280
823	Colatina	320150	8	111788	79	colatinense	1423
825	Conceição Do Castelo	320170	8	11681	32	conceiçãoense	369
826	Divino De São Lourenço	320180	8	4516	26	são-lourencense	176
828	Dores Do Rio Preto	320200	8	6397	40	rio-pretense	159
829	Ecoporanga	320210	8	23212	10	ecoporanguense	2283
832	Guaçuí	320230	8	27851	60	guaçuiense	468
833	Guarapari	320240	8	105286	177	guarapariense	595
835	Ibiraçu	320250	8	11178	56	ibiraçuense	200
836	Ibitirama	320255	8	8957	27	ibitiranense	329
838	Irupi	320265	8	11723	64	irupiense	184
840	Itapemirim	320280	8	30988	56	itapemirinense	557
842	Iúna	320300	8	27328	59	iunense	460
843	Jaguaré	320305	8	24678	38	jaguarense	656
845	João Neiva	320313	8	15809	58	joão-neivense	273
847	Linhares	320320	8	141306	40	linharense	3502
849	Marataízes	320332	8	34140	252	marataizense	135
850	Marechal Floriano	320334	8	14262	50	florianense	286
852	Mimoso Do Sul	320340	8	25902	30	mimosense	867
854	Mucurici	320360	8	5655	11	mucuriciense	539
856	Muqui	320380	8	14396	44	muquiense	327
857	Nova Venécia	320390	8	46031	32	veneciano	1448
859	Pedro Canário	320405	8	23794	55	canariense	434
861	Piúma	320420	8	18123	243	piumense	75
862	Ponto Belo	320425	8	6979	20	pontobelense	356
864	Rio Bananal	320435	8	17530	27	ribanense	645
866	Santa Leopoldina	320450	8	12240	17	leopoldinense	716
868	Santa Teresa	320460	8	21823	31	teresense	695
869	São Domingos Do Norte	320465	8	8001	27	dominguense	299
871	São José Do Calçado	320480	8	10408	38	calçadense	273
872	São Mateus	320490	8	109028	47	mateense	2343
874	Serra	320500	8	409267	739	serrano	554
875	Sooretama	320501	8	23843	40	sooretamense	593
877	Venda Nova Do Imigrante	320506	8	20447	109	venda-novense	188
879	Vila Pavão	320515	8	8672	20	pavoense	433
881	Vila Velha	320520	8	414586	2	vila-velhense	212
882	Vitória	320530	8	327801	3	capixaba	99
884	Abadiânia	520010	9	15757	15	abadiense	1045
886	Adelândia	520015	9	2477	21	adelandense	115
888	Água Limpa	520020	9	2013	4	água-limpense	453
889	Águas Lindas De Goiás	520025	9	159378	846	águas lindense	188
891	Aloândia	520050	9	2051	20	aloandense	102
893	Alto Paraíso De Goiás	520060	9	6885	3	alto-paraisense	2594
894	Alvorada Do Norte	520080	9	8084	6	alvoradense	1259
896	Americano Do Brasil	520085	9	5508	41	americanense-do-Brasil	134
898	Anápolis	520110	9	334613	359	anapolino	933
2724	Salgadinho	251300	15	3508	19	salgadinhense	184
902	Aparecida Do Rio Doce	520145	9	2427	4	riodocense	602
903	Aporé	520150	9	3803	1	aporeano	2900
905	Aragarças	520170	9	18305	28	aragarcense	663
907	Araguapaz	520215	9	7510	3	araguapaense	2194
909	Aruanã	520250	9	7496	2	aruanense	3050
910	Aurilândia	520260	9	3650	6	aurilandense	565
912	Baliza	520310	9	3714	2	balizense	1783
914	Bela Vista De Goiás	520330	9	24554	20	bela-vistense	1255
916	Bom Jesus De Goiás	520350	9	20727	15	bom-jesuense	1405
917	Bonfinópolis	520355	9	7536	62	bonfinopolino	122
919	Brazabrantes	520360	9	3232	26	brazabrantino	123
921	Buriti Alegre	520390	9	9054	10	buriti-alegrense	895
923	Buritinópolis	520396	9	3321	13	buritinopolense	247
924	Cabeceiras	520400	9	7354	7	cabeceirense	1128
926	Cachoeira De Goiás	520420	9	1417	3	cachoeirense	423
928	Caçu	520430	9	13283	6	caçuense	2251
929	Caiapônia	520440	9	16757	2	caiaponiense	8638
931	Caldazinha	520455	9	3325	13	caldazinhense	251
933	Campinaçu	520465	9	3656	2	campinaçuense	1974
934	Campinorte	520470	9	11111	10	campinortense	1067
936	Campo Limpo De Goiás	520485	9	6241	39	campolimpense	160
938	Campos Verdes	520495	9	5020	11	campo-verdense	442
940	Castelândia	520505	9	3638	12	castelandense	297
941	Catalão	520510	9	86647	23	catalano	3821
943	Cavalcante	520530	9	9392	1	cavalcantense	6954
944	Ceres	520540	9	20722	97	ceresino	214
946	Chapadão Do Céu	520547	9	7001	3	chapadense	2185
948	Cocalzinho De Goiás	520551	9	17407	10	cocalzinhense	1789
950	Córrego Do Ouro	520570	9	2632	6	corregorino	462
951	Corumbá De Goiás	520580	9	10361	10	corumbaense	1062
953	Cristalina	520620	9	46580	8	cristalinense	6162
955	Crixás	520640	9	15760	3	crixasense	4661
957	Cumari	520660	9	2964	5	cumarino	571
958	Damianópolis	520670	9	3292	8	damianopolino	415
960	Davinópolis	520690	9	2056	4	davinopolino	481
962	Divinópolis De Goiás	520830	9	4962	6	divinopolino	831
964	Edealina	520735	9	3733	6	edealinense	604
965	Edéia	520740	9	11266	8	edeiense	1462
967	Faina	520753	9	6983	4	fainense	1946
969	Firminópolis	520780	9	11580	27	firminopolense	424
971	Formosa	520800	9	100085	17	formosense	5812
972	Formoso	520810	9	4883	6	formosense 	844
974	Goianápolis	520840	9	10695	66	goianapolino	162
975	Goiandira	520850	9	5265	9	goiandirense	565
977	Goiânia	520870	9	1302001	2	goianiense	733
979	Goiás	520890	9	24727	8	goiano	3108
981	Gouvelândia	520915	9	4949	6	gouvelandense	824
982	Guapó	520920	9	13976	27	guapoense	517
984	Guarani De Goiás	520940	9	4258	3	guaraniense	1229
986	Heitoraí	520960	9	3571	16	heitoraiense	230
988	Hidrolina	520980	9	4029	7	hidrolinense	580
989	Iaciara	520990	9	12427	8	iaciarense	1550
991	Indiara	520995	9	13687	14	indiarense	956
993	Ipameri	521010	9	24735	6	ipamerino	4369
995	Iporá	521020	9	31274	30	iporaense	1026
996	Israelândia	521030	9	2887	5	israelandense	577
998	Itaguari	521056	9	4513	31	itaguarino	147
1000	Itajá	521080	9	5062	2	itajaense	2091
1002	Itapirapuã	521100	9	7835	4	itapirapuano	2044
1003	Itapuranga	521120	9	26125	20	itapuranguense	1276
1005	Itauçu	521140	9	8575	22	itauçuense	384
1007	Ivolândia	521160	9	2663	2	ivolandense	1258
1009	Jaraguá	521180	9	41870	23	jaraguense	1850
1011	Jaupaci	521200	9	3000	6	jaupacino	527
1012	Jesúpolis	521205	9	2300	19	jesupolino	122
1014	Jussara	521220	9	19153	5	jussariano	4084
1016	Leopoldo De Bulhões	521230	9	7882	16	leopoldense	481
1018	Mairipotaba	521260	9	2374	5	mairipotabense	467
1020	Mara Rosa	521280	9	10649	6	mara-rosense	1688
1021	Marzagão	521290	9	2072	9	marzagonense	222
1023	Maurilândia	521300	9	11521	30	maurilandense	390
1025	Minaçu	521308	9	31154	11	minaçuense	2861
1027	Moiporá	521340	9	1763	4	moiporaense	461
2863	Ipojuca	260720	16	80637	151	ipojuquense	533
1029	Montes Claros De Goiás	521370	9	7987	3	montes-clarense	2899
1031	Montividiu Do Norte	521377	9	4122	3	montividense	1333
1033	Morro Agudo De Goiás	521385	9	2356	8	morro-agudense	283
1034	Mossâmedes	521390	9	5007	7	mossamedino	684
1036	Mundo Novo	521405	9	6438	3	mundo-novense	2147
1038	Nazário	521440	9	7874	29	nazarinense	269
1039	Nerópolis	521450	9	24210	119	neropolino	204
1041	Nova América	521470	9	2259	11	nova-americano	212
1043	Nova Crixás	521483	9	11927	2	nova-crixaense	7299
1045	Nova Iguaçu De Goiás	521487	9	2826	5	nova iguaçuense	628
1046	Nova Roma	521490	9	3471	2	nova-romano	2136
1048	Novo Brasil	521520	9	3519	5	novo-brasilense	650
1050	Novo Planalto	521525	9	3956	3	planaltense	1243
1052	Ouro Verde De Goiás	521540	9	4034	19	ouro-verdense	209
1054	Padre Bernardo	521560	9	27671	9	padre-bernardense	3139
1056	Palmeiras De Goiás	521570	9	23338	15	palmeirense	1540
1057	Palmelo	521580	9	2335	40	palmelino	59
1059	Panamá	521600	9	2682	6	panamenho	434
1061	Paraúna	521640	9	10863	3	paraunense	3779
1062	Perolândia	521645	9	2950	3	perolandense	1030
1064	Pilar De Goiás	521690	9	2773	3	pilarense	907
1066	Piranhas	521720	9	11266	6	piranhense	2048
1068	Pires Do Rio	521740	9	28762	27	piresino	1073
1069	Planaltina	521760	9	81649	32	planaltinense	2538
1071	Porangatu	521800	9	42355	9	porangatuense	4821
1073	Portelândia	521810	9	3839	7	portelandense	557
1074	Posse	521830	9	31419	16	possense	2025
1076	Quirinópolis	521850	9	43220	11	quirinopolino	3787
1078	Rianápolis	521870	9	4566	29	rianapolino	159
1080	Rio Verde	521880	9	176424	21	rio-verdense	8380
1081	Rubiataba	521890	9	18915	25	rubiatabense	748
1083	Santa Bárbara De Goiás	521910	9	5751	41	santa-barbarense	140
1085	Santa Fé De Goiás	521925	9	4762	4	santa-feense	1169
1087	Santa Isabel	521935	9	3686	5	santa-isabelense	807
1088	Santa Rita Do Araguaia	521940	9	6924	5	santa-ritense	1362
1090	Santa Rosa De Goiás	521950	9	2909	18	santa-rosense	164
1092	Santa Terezinha De Goiás	521970	9	10302	9	terezinhense	1202
1093	Santo Antônio Da Barra	521971	9	4423	10	santatoniense	452
1095	Santo Antônio Do Descoberto	521975	9	63248	67	descobertense	944
1096	São Domingos	521980	9	11272	3	dominicano	3296
1098	São João D`Aliança	522000	9	10257	3	são-joanense	3327
1100	São Luís De Montes Belos	522010	9	30034	36	monte-belense	826
1101	São Luíz Do Norte	522015	9	4617	8	são-luizense	586
1103	São Miguel Do Passa Quatro	522026	9	3757	7	passa-quatrense	538
1104	São Patrício	522028	9	1991	12	sampatriciense	172
1106	Senador Canedo	522045	9	84443	344	canedense	245
1108	Silvânia	522060	9	19089	8	silvaniense	2346
1109	Simolândia	522068	9	6514	19	simolandense	348
1111	Taquaral De Goiás	522100	9	3541	17	taquaralense	204
1113	Terezópolis De Goiás	522119	9	6561	61	terezopolino	107
1115	Trindade	522140	9	104488	147	trindadense	711
1116	Trombas	522145	9	3452	4	trombense	799
1118	Turvelândia	522155	9	4399	5	turvelandense	934
1120	Uruaçu	522160	9	36929	17	uruaçuense	2142
1122	Urutaí	522180	9	3074	5	urutaíno	627
1124	Varjão	522190	9	3659	7	varjãoense	519
1125	Vianópolis	522200	9	12548	13	vianopolino	954
1127	Vila Boa	522220	9	4735	4	vilaboense	1060
1128	Vila Propício	522230	9	5145	2	propiciense	2182
1130	Afonso Cunha	210010	10	5905	16	afonso-cunhense	371
1132	Alcântara	210020	10	21851	15	alcantarense	1487
1133	Aldeias Altas	210030	10	23952	12	aldeias-altense	1942
1135	Alto Alegre Do Maranhão	210043	10	24599	64	alto-alegrense 	383
1137	Alto Parnaíba	210050	10	10766	1	alto-parnaibano	11132
1138	Amapá Do Maranhão	210055	10	6431	13	amapaense	502
1140	Anajatuba	210070	10	25291	25	anajatubense	1011
1141	Anapurus	210080	10	13939	23	anapuruense	608
1143	Araguanã	210087	10	13973	17	araguanaense 	805
1145	Arame	210095	10	31702	11	aramense	3009
1147	Axixá	210110	10	11407	56	axixaense	203
1148	Bacabal	210120	10	100014	59	bacabalense	1683
1152	Balsas	210140	10	83528	6	balsense	13142
1154	Barra Do Corda	210160	10	82830	16	barra-cordense	5203
1156	Bela Vista Do Maranhão	210177	10	12049	47	bela-vistense	255
1157	Belágua	210173	10	6524	13	belaguaense 	499
1159	Bequimão	210190	10	20344	26	bequimãoense	769
1161	Boa Vista Do Gurupi	210197	10	7949	20	boa-vistense	403
1162	Bom Jardim	210200	10	39049	6	bom-jardinense	6591
1164	Bom Lugar	210207	10	14818	33	bom-lugarense	446
1166	Brejo De Areia	210215	10	5577	5	brejareiense 	1059
1167	Buriti	210220	10	27013	18	buritiense	1474
1169	Buriticupu	210232	10	65237	26	buriticupuense	2546
1171	Cachoeira Grande	210237	10	8446	12	cachoeirense	706
1173	Cajari	210250	10	18338	28	cajariense	662
1175	Cândido Mendes	210260	10	18505	11	cândido-mendense	1634
1176	Cantanhede	210270	10	20448	26	cantanhedense	773
1178	Carolina	210280	10	23959	4	carolinense	6442
1179	Carutapera	210290	10	22006	18	carutaperense	1232
1181	Cedral	210310	10	10297	36	cedralense	289
1183	Centro Do Guilherme	210315	10	12565	12	centroguilhermense	1074
1185	Chapadinha	210320	10	73350	23	chapadinhense	3247
1186	Cidelândia	210325	10	13681	9	cidelandense	1464
1188	Coelho Neto	210340	10	46750	48	coelho-netense	976
1190	Conceição Do Lago Açu	210355	10	14436	20	lagoaçuense	733
1191	Coroatá	210360	10	61725	27	coroataense	2264
1193	Davinópolis	210375	10	12579	37	davinopolitano	336
1195	Duque Bacelar	210390	10	10649	34	bacelarense	318
1197	Estreito	210405	10	35835	13	estreitense	2719
1199	Fernando Falcão	210408	10	9241	2	fernandense	5087
1200	Formosa Da Serra Negra	210409	10	17757	4	formosense	3951
1202	Fortuna	210420	10	15098	22	fortunense	695
1203	Godofredo Viana	210430	10	10635	16	godofredense	674
1205	Governador Archer	210450	10	10205	23	archense	451
1207	Governador Eugênio Barros	210460	10	15991	20	 eugênio-barrense	817
1209	Governador Newton Bello	210465	10	11921	10	newton-belense	1160
1210	Governador Nunes Freire	210467	10	25401	24	nunes-freirense	1037
1212	Grajaú	210480	10	62093	7	grajauense	8831
1213	Guimarães	210490	10	12081	20	vimaranense	595
1215	Icatu	210510	10	25145	17	icatuense	1449
1217	Igarapé Grande	210520	10	11041	30	igarapé-grandense	374
1218	Imperatriz	210530	10	247505	181	imperatrizense	1369
1220	Itapecuru Mirim	210540	10	62110	42	itapecuruense	1471
1222	Jatobá	210545	10	8526	14	jatobaense	591
1224	João Lisboa	210550	10	20381	32	joão-lisboense	637
1225	Joselândia	210560	10	15433	23	joselandense	682
1227	Lago Da Pedra	210570	10	46083	38	lago-pedrense	1223
1229	Lago Dos Rodrigues	210594	10	7794	43	lago-rodriguense	180
1230	Lago Verde	210590	10	15412	25	lago-verdense	623
1232	Lagoa Grande Do Maranhão	210596	10	10517	14	lagoa-grandense	744
1234	Lima Campos	210600	10	11423	35	lima-campense	322
1235	Loreto	210610	10	11390	3	lorentense	3597
1237	Magalhães De Almeida	210630	10	17587	41	magalhense	433
1239	Marajá Do Sena	210635	10	8051	6	marajaense	1448
1241	Mata Roma	210640	10	15150	28	mata-romense	548
1242	Matinha	210650	10	21885	54	matinhense	409
1244	Matões Do Norte	210663	10	13794	17	norte-matõense	795
1246	Mirador	210670	10	20452	2	miradoense	8451
1247	Miranda Do Norte	210675	10	24427	72	mirandense-do-norte	341
1249	Monção	210690	10	31738	24	monçonense	1302
1251	Morros	210710	10	17783	10	morroense	1715
1252	Nina Rodrigues	210720	10	12464	22	ninense	573
1254	Nova Iorque	210730	10	4590	5	nova-iorquino	977
1256	Olho D`Água Das Cunhãs	210740	10	18601	27	olho-daguense	695
1258	Paço Do Lumiar	210750	10	105121	843	luminense	125
1259	Palmeirândia	210760	10	18764	36	palmeirandense	526
1261	Parnarama	210780	10	34586	10	parnaramense	3439
1262	Passagem Franca	210790	10	17562	13	passagense	1358
1264	Paulino Neves	210805	10	14519	15	paulinoense	979
1266	Pedreiras	210820	10	39448	137	pedreirense	288
1268	Penalva	210830	10	34267	46	penalvense	738
1269	Peri Mirim	210840	10	13803	34	peri-miriense	405
1271	Pindaré Mirim	210850	10	31152	127	pindareense	245
1273	Pio Xii	210870	10	22016	40	piodocense 	545
1276	Porto Franco	210900	10	21530	15	porto-franquino	1417
1277	Porto Rico Do Maranhão	210905	10	6030	28	porto-riquense	213
1279	Presidente Juscelino	210920	10	11541	33	juscelinense	355
1281	Presidente Sarney	210927	10	17165	24	sarneyense	724
1282	Presidente Vargas	210930	10	10717	23	presidentino	459
1284	Raposa	210945	10	26327	409	raposense	64
1286	Ribamar Fiquene	210955	10	7318	10	fiquenense	751
1287	Rosário	210960	10	39576	58	rosariense	685
1290	Santa Helena	210980	10	39110	17	santa-helenense	2308
1291	Santa Inês	210990	10	77282	188	santa-inesense	410
1293	Santa Luzia Do Paruá	211003	10	22644	25	santa-luziense-do-paruá	897
1295	Santa Rita	211020	10	32366	46	santa-ritense	706
1296	Santana Do Maranhão	211023	10	11661	13	santanense	932
1298	Santo Antônio Dos Lopes	211030	10	14288	19	santo-antoense	771
1300	São Bento	211050	10	40736	89	sambentuense	459
1301	São Bernardo	211060	10	26476	26	bernardense	1007
1303	São Domingos Do Maranhão	211070	10	33607	29	são-dominguense	1152
1304	São Félix De Balsas	211080	10	4702	2	são-felense	2032
1306	São Francisco Do Maranhão	211090	10	12146	5	são-franciscano	2347
1308	São João Do Carú	211102	10	12309	20	caruense	616
1310	São João Do Soter	211107	10	17238	12	 sotense	1438
1311	São João Dos Patos	211110	10	24928	17	patoense	1501
1313	São José Dos Basílios	211125	10	7496	21	basiliense	363
1314	São Luís	211130	10	1014837	1	são-luisense	835
1316	São Mateus Do Maranhão	211150	10	39093	50	são-mateuense 	783
1317	São Pedro Da Água Branca	211153	10	12028	17	agua-braquense	720
1319	São Raimundo Das Mangabeiras	211160	10	17474	5	mangabeirense	3522
1321	São Roberto	211167	10	5957	26	são-robertense	227
1322	São Vicente Ferrer	211170	10	20863	53	vicentino	391
1324	Senador Alexandre Costa	211174	10	10256	24	alexandrecostense	426
1326	Serrano Do Maranhão	211178	10	10940	9	serranense	1207
1327	Sítio Novo	211180	10	17002	5	sitio-novense	3115
1329	Sucupira Do Riachão	211195	10	4613	8	sucupirense	565
1331	Timbiras	211210	10	27997	19	timbirense	1487
1332	Timon	211220	10	155460	89	timonense	1743
1334	Tufilândia	211227	10	5596	21	tufilandense	271
1336	Turiaçu	211240	10	33933	13	turiense	2578
1337	Turilândia	211245	10	22846	15	turilandense	1512
1339	Urbano Santos	211260	10	24573	20	urbano-santense	1208
1341	Viana	211280	10	49496	42	vianense	1168
1343	Vitória Do Mearim	211290	10	31217	44	vitoriense	717
1344	Vitorino Freire	211300	10	31658	24	vitorinense	1305
1348	Abre Campo	310030	11	13311	28	abre-campense	471
1350	Açucena	310050	11	10276	13	açucenense	815
1351	Água Boa	310060	11	15195	12	água-boense	1320
1353	Aguanil	310080	11	4054	17	aguanilense	232
1355	Águas Vermelhas	310100	11	12722	10	águas-vermelhense	1259
1357	Aiuruoca	310120	11	6162	9	aiuruocano	650
1358	Alagoa	310130	11	2709	17	alagoense	161
1360	Além Paraíba	310150	11	34349	67	além-paraíbano	510
1362	Alfredo Vasconcelos	310163	11	6075	46	vasconcelense	131
1364	Alpercata	310180	11	7172	43	alpercatense	167
1366	Alterosa	310200	11	13717	38	alterosense	362
1367	Alto Caparaó	310205	11	5297	51	alto caparoense	104
1369	Alto Rio Doce	310210	11	12159	23	alto-rio-docense	518
1371	Alvinópolis	310230	11	15261	25	alvinopolense	599
1373	Amparo Do Serra	310250	11	5053	35	serrense	146
1374	Andradas	310260	11	37270	79	andradense	469
1376	Angelândia	310285	11	8003	43	angelandense	185
1378	Antônio Dias	310300	11	9565	12	antônio-diense	787
1380	Araçaí	310320	11	2243	12	araçaiense	187
1381	Aracitaba	310330	11	2058	19	aracitabense	107
1383	Araguari	310350	11	109801	40	araguarino	2730
1384	Arantina	310360	11	2823	32	arantinense	89
1386	Araporã	310375	11	6144	21	araporense	296
1388	Araújos	310390	11	7883	32	araujense	246
1390	Arceburgo	310410	11	9509	58	arceburguense	163
1392	Areado	310430	11	13731	49	areadense	283
1393	Argirita	310440	11	2901	18	argiritense	159
1395	Arinos	310450	11	17674	3	arinense	5279
2726	Santa Cecília	251315	15	6658	29	ceciliense	228
1398	Augusto De Lima	310480	11	4960	4	augusto-limense	1255
1399	Baependi	310490	11	18307	24	baependiano	751
1401	Bambuí	310510	11	22734	16	bambuiense	1456
1403	Bandeira Do Sul	310530	11	5338	113	bandeirante-do-sul	47
1405	Barão De Monte Alto	310550	11	5720	29	monte-altense	198
1406	Barbacena	310560	11	126284	166	barbacenense	759
1408	Barroso	310590	11	19599	239	barroense	82
1410	Belmiro Braga	310610	11	3403	9	belmirense	393
1412	Belo Oriente	310630	11	23397	70	belo-orientino	335
1413	Belo Vale	310640	11	7536	21	belo-valense	366
1415	Berizal	310665	11	4370	9	berizalense	489
1417	Betim	310670	11	378089	1	betinense	343
1419	Bicas	310690	11	13653	97	biquense	140
1420	Biquinhas	310700	11	2630	6	biquinhense	459
1422	Bocaina De Minas	310720	11	5007	10	bocainense	504
1424	Bom Despacho	310740	11	45624	37	bom-despachense	1224
1426	Bom Jesus Da Penha	310760	11	3887	19	bom-jesuense	208
1427	Bom Jesus Do Amparo	310770	11	5491	28	bom-jesuense	196
1429	Bom Repouso	310790	11	10457	46	bom-repousense	230
1431	Bonfim	310810	11	6818	23	bonfinense 	302
1433	Bonito De Minas	310825	11	9673	2	bonitense	3905
1434	Borda Da Mata	310830	11	17118	57	borda-matense	301
1436	Botumirim	310850	11	6497	4	botumiriense	1569
1438	Brasilândia De Minas	310855	11	14226	6	brasilandense	2510
1440	Brasópolis	310890	11	14661	40	brasopolense	368
1441	Braúnas	310880	11	5030	13	braunense	378
1443	Bueno Brandão	310910	11	10892	31	bueno-brandense	356
1445	Bugre	310925	11	3992	25	bugrense	162
1446	Buritis	310930	11	22737	4	buritisense	5225
1448	Cabeceira Grande	310945	11	6453	6	cabeceirense	1031
1450	Cachoeira Da Prata	310960	11	3654	60	cachoeirense	61
1452	Cachoeira De Pajeú	310270	11	8959	13	cachoeirense	696
1454	Caetanópolis	310990	11	10218	65	caetanopolitano	156
1455	Caeté	311000	11	40750	75	caeteense	543
1457	Cajuri	311020	11	4047	49	cajuriense	83
1459	Camacho	311040	11	3154	14	camachense	223
1460	Camanducaia	311050	11	21080	40	camanducaiense	528
1462	Cambuquira	311070	11	12602	51	cambuquirense	246
1464	Campanha	311090	11	15433	46	campanhense	336
1466	Campina Verde	311110	11	19324	5	campina-verdense	3651
1468	Campo Belo	311120	11	51544	98	campo-belense	528
1470	Campo Florido	311140	11	6870	5	campo-floridense	1264
1471	Campos Altos	311150	11	14206	20	campos-altense	711
1473	Cana Verde	311190	11	5589	26	cana-verdense	213
1475	CanÁpolis	311180	11	11365	14	canapolense	840
1476	Candeias	311200	11	14595	20	candeense	721
1478	Caparaó	311210	11	5209	40	caparaoense	131
1480	Capelinha	311230	11	34803	36	capelinhense	965
1482	Capim Branco	311250	11	8881	93	capim-branquense	95
1484	Capitão Andrade	311265	11	4925	18	capitão andradense	279
1486	Capitólio	311280	11	8183	16	capitolino	522
1487	Caputira	311290	11	9030	48	caputirense	188
1489	Caranaíba	311310	11	3288	21	caranaibense	160
1491	Carangola	311330	11	32296	91	carangolense	353
1493	Carbonita	311350	11	9148	6	carbonitense	1456
1494	Careaçu	311360	11	6298	35	careaçuense	181
1496	Carmésia	311380	11	2446	9	carmesense	259
1498	Carmo Da Mata	311400	11	10927	31	carmense	357
1500	Carmo Do Cajuru	311420	11	20012	44	cajuruense	456
1501	Carmo Do Paranaíba	311430	11	29735	23	carmense	1308
1503	Carmópolis De Minas	311450	11	17048	43	carmopolitano	400
1504	Carneirinho	311455	11	9471	5	carneirinhense	2063
1506	Carvalhópolis	311470	11	3341	41	carvalhense	81
1508	Casa Grande	311490	11	2244	14	casa-grandense	158
1510	CÁssia	311510	11	17412	26	cassiense	666
1511	Cataguases	311530	11	69757	142	cataguasense	492
1514	Catuji	311545	11	6708	16	catujiense	420
1515	Catuti	311547	11	5102	18	catutiense	288
1517	Cedro Do Abaeté	311560	11	1210	4	cedrense	283
1518	Central De Minas	311570	11	6772	33	centralense	204
1520	ChÁcara	311590	11	2792	18	chacarense	153
1522	Chapada Do Norte	311610	11	15189	18	chapadense	831
2865	Itacuruba	260740	16	4369	10	itacurubense	430
1525	Cipotânea	311630	11	6547	43	cipotanense	153
1527	Claro Dos Poções	311650	11	7775	11	claro-pocense	720
1529	Coimbra	311670	11	7054	66	coimbraense	107
1531	Comendador Gomes	311690	11	2972	3	comendadorense	1041
1533	Conceição Da Aparecida	311710	11	9820	28	aparecidense	353
1535	Conceição Das Alagoas	311730	11	23043	17	garimpense	1340
1536	Conceição Das Pedras	311720	11	2749	27	pedrense	102
1538	Conceição Do Mato Dentro	311750	11	17908	10	conceicionense	1727
1539	Conceição Do ParÁ	311760	11	5158	21	conceição-paraense	250
1541	Conceição Dos Ouros	311780	11	10388	57	ourense	183
1543	Confins	311787	11	5936	140	confinense	42
1544	Congonhal	311790	11	10468	51	congonhalense	205
1546	Congonhas Do Norte	311810	11	4943	12	congonhense	399
1548	Conselheiro Lafaiete	311830	11	116512	315	lafaietense	370
1550	Consolação	311850	11	1727	20	consolense	86
1551	Contagem	311860	11	603442	3	contagense	195
1553	Coração De Jesus	311880	11	26033	12	corjesuense	2225
1555	Cordislândia	311900	11	3435	19	cordislandense	180
1556	Corinto	311910	11	23914	9	corintiano	2525
1558	Coromandel	311930	11	27547	8	coromandelense	3313
1560	Coronel Murta	311950	11	9117	11	murtense	815
1562	Coronel Xavier Chaves	311970	11	3301	23	xavierense	141
1563	Córrego Danta	311980	11	3391	5	córrego-dantense	657
1565	Córrego Fundo	311995	11	5790	57	corregofundense	101
1567	Couto De Magalhães De Minas	312010	11	4204	9	couto-magalhense	486
1568	Crisólita	312015	11	6047	6	crisolitense	966
1570	CristÁlia	312030	11	5760	7	cristalense	841
1572	Cristina	312050	11	10210	33	cristinense	311
1574	Cruzeiro Da Fortaleza	312070	11	3934	21	cruzeirense	188
1575	Cruzília	312080	11	14591	28	cruzilense	522
1577	Curral De Dentro	312087	11	6913	12	curraldentense	568
1579	Datas	312100	11	5211	17	datense	310
1581	Delfinópolis	312120	11	6830	5	delfinopolitano	1378
1582	Delta	312125	11	8089	79	deltense	103
1584	Desterro De Entre Rios	312140	11	7002	19	desterrense	377
1586	Diamantina	312160	11	45880	12	diamantinense	3892
1588	Dionísio	312180	11	8739	25	dionisiano	344
1589	Divinésia	312190	11	3293	28	divinesiano	117
1591	Divino Das Laranjeiras	312210	11	4937	14	divinense	342
1593	Divinópolis	312230	11	213016	301	divinopolitano	708
1594	Divisa Alegre	312235	11	5884	50	divisalegrense	118
1596	Divisópolis	312245	11	8974	16	divisopolense	573
1597	Dom Bosco	312247	11	3814	5	dom bosquense	817
1599	Dom Joaquim	312260	11	4535	11	dom-joaquinense	399
1601	Dom Viçoso	312280	11	2994	26	dom-viçosense	114
1603	Dores De Campos	312300	11	9299	74	dorense	125
1604	Dores De Guanhães	312310	11	5223	14	dorense	382
1606	Dores Do Turvo	312330	11	4462	19	dorense	231
1607	Doresópolis	312340	11	1440	9	doresopolitano	153
1609	Durandé	312352	11	7423	34	durandeense	217
1611	Engenheiro Caldas	312370	11	10280	55	engenheiro-caldense	187
1613	Entre Folhas	312385	11	5175	61	entrefolhense	85
1614	Entre Rios De Minas	312390	11	14242	31	entrerrianos	457
1616	Esmeraldas	312410	11	60271	66	esmeraldense	911
1618	Espinosa	312430	11	31113	17	espinosense	1869
1620	Estiva	312450	11	10845	44	estivense	244
1621	Estrela Dalva	312460	11	2470	19	estrela-dalvense	131
1623	Estrela Do Sul	312480	11	7446	9	estrela-sulense	822
1625	Ewbank Da Câmara	312500	11	3753	36	ewbanquense	104
1626	Extrema	312510	11	28599	117	extremense	245
1628	Faria Lemos	312530	11	3376	20	faria-lemense	165
1630	Felisburgo	312560	11	6877	12	felisburguense	596
1631	Felixlândia	312570	11	14121	9	felixlandense	1555
1633	Ferros	312590	11	10837	10	ferrense	1089
1635	Florestal	312600	11	6600	34	florestalense	191
1637	Formoso	312620	11	8177	2	formosense	3686
1638	Fortaleza De Minas	312630	11	4098	19	fortalezense	219
1640	Francisco Badaró	312650	11	10248	22	badarosense	461
1642	Francisco SÁ	312670	11	24912	9	francisco-saense	2747
1644	Frei Gaspar	312680	11	5879	9	frei-gasparense	627
1645	Frei Inocêncio	312690	11	8920	19	frei-inocenciano	470
2867	Itambé	260765	16	35398	116	itambeense 	305
1649	Fruta De Leite	312707	11	5940	8	fruta de leitense	763
1650	Frutal	312710	11	53468	22	frutalense	2427
1652	Galiléia	312730	11	6951	10	galileense	720
1654	Glaucilândia	312735	11	2962	20	glaucilandense	146
1655	Goiabeira	312737	11	3053	27	goiabeirense	112
1657	Gonçalves	312740	11	4220	23	gonçalvense	187
1659	Gouveia	312760	11	11681	13	gouveano	867
1661	Grão Mogol	312780	11	15024	4	grão-mogolense	3885
1662	Grupiara	312790	11	1373	7	grupiarense	193
1664	Guapé	312810	11	13872	15	guapense	934
1666	Guaraciama	312825	11	4718	12	guaraciamense	390
1668	Guarani	312840	11	8678	33	guaraniense	264
1669	GuararÁ	312850	11	3929	44	guararense	89
1671	Guaxupé	312870	11	49430	173	guaxupeano	286
1673	Guimarânia	312890	11	7265	20	guimaranense	367
1675	Gurinhatã	312910	11	6137	3	gurinhantense	1849
1677	Iapu	312930	11	10315	30	iapuense	341
1678	Ibertioga	312940	11	5036	15	ibertiogano	346
1680	Ibiaí	312960	11	7839	9	ibiaiense	875
1682	Ibiraci	312970	11	12176	22	ibiraciense	562
1684	Ibitiúra De Minas	312990	11	3382	50	ibitiurense	68
1686	Icaraí De Minas	313005	11	10746	17	icaraiense	626
1687	Igarapé	313010	11	34851	316	igarapeense	110
1689	Iguatama	313030	11	8029	13	iguatamense	628
1691	Ilicínea	313050	11	11488	31	ilicineaense	376
1693	Inconfidentes	313060	11	6908	46	inconfidentino	150
1694	Indaiabira	313065	11	7330	7	indaiabirense	1004
1696	Ingaí	313080	11	2629	9	ingaiense	306
1698	Inhaúma	313100	11	5760	24	inhaumense	245
1700	Ipaba	313115	11	16708	148	ipabense	113
1701	Ipanema	313120	11	18170	40	ipanemense	457
1703	Ipiaçu	313140	11	4107	9	ipiaçuense	466
1705	Iraí De Minas	313160	11	6467	18	iraiense	356
1707	Itabirinha	313180	11	10692	51	itabirense	209
1708	Itabirito	313190	11	45449	84	itabiritense	543
1710	Itacarambi	313210	11	17720	14	itacarambiense	1225
1712	Itaipé	313230	11	11798	25	itaipeense	481
1714	Itamarandiba	313250	11	32175	12	itamarandibano	2736
1716	Itambacuri	313270	11	22809	16	itambacuriense	1419
1718	Itamogi	313290	11	10349	42	itamogiense	244
1719	Itamonte	313300	11	14003	32	itamontense	432
1721	Itanhomi	313320	11	11856	24	itanhomense	489
1722	Itaobim	313330	11	21001	31	itaobinhense	679
1724	Itapecerica	313350	11	21377	21	itapecericano	1041
1726	Itatiaiuçu	313370	11	9928	34	itatiaiuçuense	295
1728	Itaúna	313380	11	85463	172	itaunense	496
1729	Itaverava	313390	11	5799	20	itaveravense	284
1731	Itueta	313410	11	5830	13	ituetano	453
1733	Itumirim	313430	11	6139	26	itumirinense	235
1735	Itutinga	313450	11	3913	11	itutinguense	372
1737	Jacinto	313470	11	12134	9	jacintense	1394
1738	Jacuí	313480	11	7502	18	jacuiense	409
1740	Jaguaraçu	313500	11	2990	18	jaguaraçuense	164
1742	Jampruca	313507	11	5067	10	jampruquense	517
1743	Janaúba	313510	11	66803	31	janaubense	2181
1745	Japaraíba	313530	11	3939	23	japaraíbano	172
1747	Jeceaba	313540	11	5395	23	jeceabense 	236
1749	Jequeri	313550	11	12848	23	jequeriense	548
1750	Jequitaí	313560	11	8005	6	jequitaiense	1268
1753	Jesuânia	313590	11	4768	31	jesuanense	154
1754	Joaíma	313600	11	14941	9	joaimense	1664
1756	João Monlevade	313620	11	73610	742	monlevadense	99
1758	Joaquim Felício	313640	11	4305	5	feliciano	791
1759	Jordânia	313650	11	10324	19	jordainense	547
1761	José Raydan	313655	11	4376	24	josé raydanense	181
1763	Juatuba	313665	11	22202	223	juatubense	99
1764	Juiz De Fora	313670	11	516247	360	juiz-forano 	1436
1766	Juruaia	313690	11	9238	42	juruaiense	220
1768	Ladainha	313700	11	16994	20	ladainhense	866
1770	Lagoa Da Prata	313720	11	45984	105	lago-pratense	440
1771	Lagoa Dos Patos	313730	11	4225	7	lagoa-patense	601
1773	Lagoa Formosa	313750	11	17161	20	lagoense	841
1775	Lagoa Santa	313760	11	52520	228	lagoa-santense	230
1776	Lajinha	313770	11	19609	45	lajinhense	432
2870	Itaquitinga	260780	16	15692	152	itaquitinguense	103
1779	Laranjal	313800	11	6465	32	laranjalense	205
1781	Lavras	313820	11	92200	163	lavrense	565
1783	Leme Do Prado	313835	11	4804	17	lemepradense	280
1785	Liberdade	313850	11	5346	13	libertense	401
1786	Lima Duarte	313860	11	16149	19	limaduartino	849
1788	Lontra	313865	11	8397	32	lontrense	259
1790	Luislândia	313868	11	6400	16	luislandense	412
1792	Luz	313880	11	17486	15	luzense	1172
1793	Machacalis	313890	11	6976	21	machacalisense	332
1795	Madre De Deus De Minas	313910	11	4904	10	madre-deusense	493
1797	Mamonas	313925	11	6321	22	mamonense	291
1799	Manhuaçu	313940	11	79574	127	manhuaçuense	628
1800	Manhumirim	313950	11	21382	117	manhumiriense	183
1802	Mar De Espanha	313980	11	11749	32	mar-de-espanhense	372
1804	Maria Da Fé	313990	11	14216	70	mariense	203
1806	Marilac	314010	11	4219	27	marilaquense	159
1808	MaripÁ De Minas	314020	11	2788	36	maripaense	77
1809	Marliéria	314030	11	4012	7	marlierense	546
1811	Martinho Campos	314050	11	12611	12	martinho-campense	1048
1813	Mata Verde	314055	11	7874	35	mataverdense	228
1815	Mateus Leme	314070	11	27856	92	mateus-lemense	303
1816	Mathias Lobato	317150	11	3370	20	matiense	172
1818	Matias Cardoso	314085	11	9979	5	matiense	1950
1820	Mato Verde	314100	11	12684	27	mato-verdense	472
1821	Matozinhos	314110	11	33955	135	matozinhense	252
1823	Medeiros	314130	11	3444	4	medeirense	946
1825	Mendes Pimentel	314150	11	6331	21	pimentelense	306
1827	Mesquita	314170	11	6069	22	mesquitense	275
1828	Minas Novas	314180	11	30794	17	minas-novense	1812
1830	Mirabela	314200	11	13042	18	mirabelense	723
1832	Miraí	314220	11	13808	43	miraiense	321
1834	Moeda	314230	11	4689	30	moedense	155
1836	Monjolos	314250	11	2360	4	monjolense	651
1838	Montalvânia	314270	11	15862	11	montalvanense	1504
1839	Monte Alegre De Minas	314280	11	19619	8	monte-alegrense	2596
1841	Monte Belo	314300	11	13061	31	monte-belano	421
1843	Monte Formoso	314315	11	4656	12	monte formosense	386
1845	Monte Sião	314340	11	21203	73	monte-sionense	292
1846	Montes Claros	314330	11	361915	101	montes-clarense	3569
1848	Morada Nova De Minas	314350	11	8255	4	moradense	2084
1850	Morro Do Pilar	314370	11	3399	7	morrense	478
1851	Munhoz	314380	11	6257	33	munhozense	192
1853	Mutum	314400	11	26661	21	mutuense	1251
1855	Nacip Raydan	314420	11	3154	14	nacipense	233
1856	Nanuque	314430	11	40834	27	nanuquense	1518
1858	Natalândia	314437	11	3280	7	natalandense	469
1860	Nazareno	314450	11	7954	24	nazarenense	329
1862	Ninheira	314465	11	9815	9	ninheirense	1108
1864	Nova Era	314470	11	17528	48	nova-erense	362
1865	Nova Lima	314480	11	80998	189	nova-limense	429
1867	Nova Ponte	314500	11	12812	12	nova-pontense	1111
1869	Nova Resende	314510	11	15374	39	resendense	390
1871	Nova União	313660	11	5555	32	nova-uniense	172
1872	Novo Cruzeiro	314530	11	30725	18	novo-cruzeirense	1703
1874	Novorizonte	314537	11	4963	18	novorizontino	272
1876	Olhos D`Água	314545	11	5267	3	olhos-d'aguense	2092
1878	Oliveira	314560	11	39466	44	oliveirense	897
1879	Oliveira Fortes	314570	11	2123	19	oliveira-fortense	111
1881	Oratórios	314585	11	4493	50	oratoriense	89
1883	Ouro Branco	314590	11	35268	136	ouro-branquense	259
1884	Ouro Fino	314600	11	31568	59	ouro-finense	534
1886	Ouro Verde De Minas	314620	11	6016	34	ouro-verdense	175
1888	Padre Paraíso	314630	11	18849	35	padre-paraisense	544
1890	Paineiras	314640	11	4631	7	paineirense	637
1891	Pains	314650	11	8014	19	painense	422
1893	Palma	314670	11	6545	21	palmense	316
1895	Papagaios	314690	11	14175	26	papagaiense	554
1897	Paracatu	314700	11	84718	10	paracatuense	8230
1898	Paraguaçu	314720	11	20245	48	paraguaçuense	424
1900	Paraopeba	314740	11	22563	36	paraopebense	626
1902	Passa Tempo	314770	11	8197	19	passa-tempense	429
1904	Passabém	314750	11	1766	19	passabenense	94
1905	Passos	314790	11	106290	79	passense	1338
2728	Santa Helena	251330	15	5369	26	santa-helenense	210
1908	Patrocínio	314810	11	82471	29	patrocinense	2874
1910	Paula Cândido	314830	11	9271	35	paula-candense	268
1912	Pavão	314850	11	8589	14	pavoense	601
1913	Peçanha	314860	11	17260	17	peçanhense	997
1915	Pedra Bonita	314875	11	6673	38	pedrabonitense	174
1917	Pedra Do IndaiÁ	314890	11	3875	11	andaiaense	348
1919	Pedralva	314910	11	11467	53	pedralvense	218
1920	Pedras De Maria Da Cruz	314915	11	10315	7	pedrense	1525
1922	Pedro Leopoldo	314930	11	58740	200	pedro-leopoldense	293
1924	Pequeri	314950	11	3165	35	pequeriense	91
1925	Pequi	314960	11	4076	20	pequiense	204
1927	Perdizes	314980	11	14404	6	perdizense	2451
1929	Periquito	314995	11	7036	31	periquitense	229
1931	Piau	315010	11	2841	15	piauense	192
1933	Piedade De Ponte Nova	315020	11	4062	49	piedadense	84
1934	Piedade Do Rio Grande	315030	11	4709	15	piedadense	323
1936	Pimenta	315050	11	8236	20	pimentense	415
1938	Pintópolis	315057	11	7211	6	pintopolense	1229
1939	Piracema	315060	11	6406	23	piracemense	280
1941	Piranga	315080	11	17232	26	piranguense	659
1943	Piranguinho	315100	11	8016	64	piranguinhense	125
1944	Pirapetinga	315110	11	10364	54	pirapetinguense	191
1946	Piraúba	315130	11	10862	75	piraubano	144
1948	Piumhi	315150	11	31883	35	piuiense	902
1950	Poço Fundo	315170	11	15959	34	poço-fundense	474
1952	Pocrane	315190	11	8986	13	pocranense	691
1953	Pompéu	315200	11	29105	11	pompeano	2551
1955	Ponto Chique	315213	11	3966	7	ponto chiquense	603
1957	Porteirinha	315220	11	37627	22	porteirinhense	1750
1958	Porto Firme	315230	11	10417	37	porto-firmense	285
1960	Pouso Alegre	315250	11	130615	241	pouso-alegrense	543
1962	Prados	315270	11	8391	32	pradense	264
1964	PratÁpolis	315290	11	8807	41	pratapolense	216
1966	Presidente Bernardes	315310	11	5537	23	bernardense	237
1968	Presidente Kubitschek	315330	11	2959	16	kubitschekano	189
1969	Presidente OlegÁrio	315340	11	18577	5	olegariense	3504
1971	Quartel Geral	315370	11	3303	6	quartelense	556
1972	Queluzito	315380	11	1861	12	queluzitano	154
1974	Raul Soares	315400	11	23818	31	raul-soarense	763
1976	Reduto	315415	11	6569	43	redutense	152
1978	Resplendor	315430	11	17089	16	resplendorense	1082
1979	Ressaquinha	315440	11	4711	26	ressaquinhense	185
1981	Riacho Dos Machados	315450	11	9360	7	riachense	1316
1983	Ribeirão Vermelho	315470	11	3826	78	ribeirense	49
1985	Rio Casca	315490	11	14201	37	rio-casquense	384
1986	Rio Do Prado	315510	11	5217	11	rio-pradense	480
1988	Rio Espera	315520	11	6070	25	rio-esperense	239
1990	Rio Novo	315540	11	8712	42	rio-novense	209
1992	Rio Pardo De Minas	315560	11	29099	9	rio-pardense	3117
1993	Rio Piracicaba	315570	11	14149	38	piracicabense	373
1995	Rio Preto	315590	11	5292	15	rio-pretense	348
1997	RitÁpolis	315610	11	4925	12	ritapolitano	405
1999	Rodeiro	315630	11	6867	94	rodeirense	73
2000	Romaria	315640	11	3596	9	romariense	408
2002	Rubelita	315650	11	7772	7	rubelitense	1110
2004	SabarÁ	315670	11	126269	418	sabaraense	302
2006	Sacramento	315690	11	23896	8	sacramentense	3073
2007	Salinas	315700	11	39178	21	salinense	1888
2009	Santa BÁrbara	315720	11	27876	41	santa-barbarense	684
2011	Santa BÁrbara Do Monte Verde	315727	11	2788	7	barbarense	418
2012	Santa BÁrbara Do Tugúrio	315730	11	4570	23	tugurense	195
2014	Santa Cruz De Salinas	315737	11	4397	7	santacruzense	590
2016	Santa Efigênia De Minas	315750	11	4600	35	santa-efigense	132
2017	Santa Fé De Minas	315760	11	3968	1	santa-feense	2917
2019	Santa Juliana	315770	11	11337	16	santa-julianense	724
2020	Santa Luzia	315780	11	202942	862	luziense	235
2022	Santa Maria De Itabira	315800	11	10552	18	santa-mariense	597
2024	Santa Maria Do Suaçuí	315820	11	14395	23	santa-mariense	624
2026	Santa Rita De Ibitipoca	315940	11	3583	11	ibitipoquense	324
2027	Santa Rita De Jacutinga	315930	11	4993	12	santa-ritense 	421
2029	Santa Rita Do Itueto	315950	11	5697	12	santa-ritense 	485
2033	Santana Da Vargem	315830	11	7231	42	vargense	172
2035	Santana De Pirapama	315850	11	8009	6	pirapamenho	1256
2036	Santana Do Deserto	315860	11	3860	21	santanense	183
2038	Santana Do Jacaré	315880	11	4607	43	santanense	106
2040	Santana Do Paraíso	315895	11	27265	99	paraisense	276
2041	Santana Do Riacho	315900	11	4023	6	riachense	677
2043	Santo Antônio Do Amparo	315990	11	17345	35	amparense	489
2045	Santo Antônio Do Grama	316010	11	4085	31	gramense	130
2046	Santo Antônio Do Itambé	316020	11	4135	14	itambeano	306
2048	Santo Antônio Do Monte	316040	11	25975	23	santo-antoniense	1126
2050	Santo Antônio Do Rio Abaixo	316050	11	1777	17	santo-antoniense	107
2051	Santo Hipólito	316060	11	3238	8	santo-hipolitense	431
2053	São Bento Abade	316080	11	4577	57	são-bentista	80
2055	São Domingos Das Dores	316095	11	5408	89	sandominguense	61
2056	São Domingos Do Prata	316100	11	17357	23	pratense	744
2058	São Francisco	316110	11	53828	16	são-franciscano	3308
2060	São Francisco De Sales	316130	11	5776	5	são-francisco-salense	1129
2062	São Geraldo	316150	11	10263	55	são-geraldense	186
2063	São Geraldo Da Piedade	316160	11	4389	29	são-geraldense	152
2065	São Gonçalo Do Abaeté	316170	11	6264	2	são-gonçalense	2692
2066	São Gonçalo Do ParÁ	316180	11	10398	39	são-gonçalense	266
2068	São Gonçalo Do Rio Preto	312550	11	3056	10	são-gonçalense	314
2070	São Gotardo	316210	11	31819	37	são-gotardense	866
2071	São João Batista Do Glória	316220	11	6887	13	gloriense	548
2073	São João Da Mata	316230	11	2731	23	são-joanense-da-mata	121
2075	São João Das Missões	316245	11	11715	17	missionense	678
2076	São João Del Rei	316250	11	84469	58	são-joanense	1464
2078	São João Do Manteninha	316257	11	5188	38	manteniense	138
2080	São João Do Pacuí	316265	11	4060	10	pacuíense	416
2081	São João Do Paraíso	316270	11	22319	12	paraisense	1926
2083	São João Nepomuceno	316290	11	25057	62	são-joanense	407
2085	São José Da Barra	316294	11	6778	22	são josé barrense	314
2086	São José Da Lapa	316295	11	19799	413	lapense	48
2088	São José Da Varginha	316310	11	4198	20	varginense-de-são-josé	206
2090	São José Do Divino	316330	11	3834	12	são-josé-divinense	329
2091	São José Do Goiabal	316340	11	5636	31	goiabalense	185
2093	São José Do Mantimento	316360	11	2592	47	mantimentense	55
2095	São Miguel Do Anta	316380	11	6760	44	são-miguelense	152
2096	São Pedro Da União	316390	11	5040	19	são-pedrense	261
2098	São Pedro Dos Ferros	316400	11	8356	21	ferrense	403
2099	São Romão	316420	11	10276	4	são-romano	2434
2101	São Sebastião Da Bela Vista	316440	11	4948	30	bela-vistense	167
2103	São Sebastião Do Anta	316447	11	5739	71	antense	81
2104	São Sebastião Do Maranhão	316450	11	10647	21	maranhense	518
2106	São Sebastião Do Paraíso	316470	11	64980	80	paraisense	815
2108	São Sebastião Do Rio Verde	316490	11	2110	23	rio-verdense	92
2109	São Thomé Das Letras	316520	11	6655	18	são-tomeense 	370
2110	São Tiago	316500	11	10561	18	são-tiaguense	572
2112	São Vicente De Minas	316530	11	7008	18	vicenciano	393
2114	SardoÁ	316550	11	5594	39	sardoense	142
2115	Sarzedo	316553	11	25814	415	sarzedense	62
2117	Senador Amaral	316557	11	5219	35	amaralense	151
2119	Senador Firmino	316570	11	7230	43	firminense	166
2121	Senador Modestino Gonçalves	316590	11	4574	5	modestinense	952
2122	Senhora De Oliveira	316600	11	5683	33	oliveirense	171
2124	Senhora Dos Remédios	316620	11	10196	43	remediense	238
2126	Seritinga	316640	11	1789	16	seritinguense	115
2127	Serra Azul De Minas	316650	11	4220	19	serra-azulense	219
2129	Serra Do Salitre	316680	11	10549	8	serralitrense 	1295
2131	Serrania	316690	11	7542	36	serraniense	209
2133	Serranos	316700	11	1995	9	serranense	213
2134	Serro	316710	11	20835	17	serrano	1218
2136	Setubinha	316555	11	10885	20	setubinhense	535
2137	Silveirânia	316730	11	2192	14	silveiranense	157
2139	Simão Pereira	316750	11	2537	19	simonense	136
2141	SobrÁlia	316770	11	5830	28	sobraliense	207
2143	Tabuleiro	316790	11	4079	19	tabuleirense	211
2144	Taiobeiras	316800	11	30917	26	taiobeirense	1195
2731	Santa Rita	251370	15	120310	166	santa-ritense	727
2147	Tapiraí	316820	11	1873	5	tapiraiense	408
2149	Tarumirim	316840	11	14293	20	tarumirinhense	732
2150	Teixeiras	316850	11	11355	68	teixeirense	167
2152	Timóteo	316870	11	81243	563	timotense	144
2154	Tiros	316890	11	6906	3	tirense	2092
2155	Tocantins	316900	11	15823	91	tocantinense	174
2157	Toledo	316910	11	5764	42	toledense	137
2159	Três Corações	316930	11	72765	88	tricordiano	828
2161	Três Pontas	316940	11	53860	78	três-pontano	690
2162	Tumiritinga	316950	11	6293	13	tumiritinguense	500
2164	Turmalina	316970	11	18055	16	turmalinense	1153
2166	UbÁ	316990	11	101519	249	ubaense	407
2167	Ubaí	317000	11	11681	14	ubaiense	821
2171	Umburatiba	317030	11	2705	7	umburatibense	406
2173	União De Minas	317043	11	4418	4	uniense	1147
2174	Uruana De Minas	317047	11	3235	5	uruanense	599
2176	Urucuia	317052	11	13604	7	urucuiano	2077
2178	Vargem Bonita	317060	11	2163	5	vargiano	410
2180	Varginha	317070	11	123081	311	varginhense	395
2181	Varjão De Minas	317075	11	6054	9	varjonense	652
2183	Varzelândia	317090	11	19116	23	varzelandense	815
2184	Vazante	317100	11	19723	10	vazantino	1913
2186	Veredinha	317107	11	5549	9	veredinhense	632
2188	Vermelho Novo	317115	11	4689	41	vermelhense	115
2190	Viçosa	317130	11	72220	241	viçosense	299
2191	Vieiras	317140	11	3731	33	vieirense	113
2193	Virgínia	317170	11	8623	26	virginense	327
2195	Virgolândia	317190	11	5658	20	virgolandense	281
2197	Volta Grande	317210	11	5070	24	volta-grandense	208
2198	Wenceslau Braz	317220	11	2553	25	wenceslauense	102
2200	Alcinópolis	500025	12	4569	1	alcinopolense	4400
2202	Anastácio	500070	12	23835	8	anastaciano	2949
2203	Anaurilândia	500080	12	8493	3	anaurilandense	3395
2205	Antônio João	500090	12	8208	7	antônio-joanense	1145
2207	Aquidauana	500110	12	45614	3	aquidauanense	16958
2209	Bandeirantes	500150	12	6609	2	bandeirantense	3116
2210	Bataguassu	500190	12	19839	8	bataguassuense	2415
2212	Bela Vista	500210	12	23181	5	bela-vistense	4893
2214	Bonito	500220	12	19587	4	bonitense	4934
2216	Caarapó	500240	12	25767	12	caarapoense	2090
2217	Camapuã	500260	12	13625	2	camapuense 	6230
2219	Caracol	500280	12	5398	2	caracolense	2940
2221	Chapadão Do Sul	500295	12	19648	5	chapadense	3851
2222	Corguinho	500310	12	4862	2	corguinhense 	2640
2224	Corumbá	500320	12	103703	2	corumbaense	64963
2226	Coxim	500330	12	32159	5	coxinense	6409
2227	Deodápolis	500345	12	12139	15	deodapolense	831
2229	Douradina	500350	12	5364	19	douradinense	281
2231	Eldorado	500375	12	11694	11	eldoradense	1018
2233	Figueirão	500390	12	2928	1	\N	4883
2234	Glória De Dourados	500400	12	9927	20	glória-douradense	492
2236	Iguatemi	500430	12	14875	5	iguatemiense	2947
2237	Inocência	500440	12	7669	1	inocentino	5776
2239	Itaquiraí	500460	12	18614	9	itaquirense 	2064
2241	Japorã	500480	12	7731	18	japoraense 	419
2243	Jardim	500500	12	24346	11	jardinense	2202
2245	Juti	500515	12	5900	4	jutiense	1585
2246	Ladário	500520	12	19617	58	ladarense	341
2248	Maracaju	500540	12	37405	7	maracajuense 	5299
2250	Mundo Novo	500568	12	17043	36	mundo-novense	478
2252	Nioaque	500580	12	14391	4	nioaquense	3924
2254	Nova Andradina	500620	12	45585	10	nova-andradinense 	4776
2255	Novo Horizonte Do Sul	500625	12	4940	6	novo horizontino do sul	849
2257	Paranhos	500635	12	12350	9	paranhense	1309
2259	Ponta Porã	500660	12	77872	15	ponta-poranense	5330
2261	Ribas Do Rio Pardo	500710	12	20946	1	rio-pardense	17308
2262	Rio Brilhante	500720	12	30663	8	rio-brilhantense	3987
2264	Rio Verde De Mato Grosso	500740	12	18890	2	rio-verdense	8154
2266	Santa Rita Do Pardo	500755	12	7259	1	santa-ritense	6143
2268	Selvíria	500780	12	6287	2	selvirense	3258
2269	Sete Quedas	500770	12	10780	13	sete-quedense	834
2271	Sonora	500793	12	14833	4	sonorense	4075
2733	Santana De Mangueira	251350	15	5331	13	santanense	402
2274	Terenos	500800	12	17146	6	terenense	2845
2276	Vicentina	500840	12	5901	19	vicentinense	310
2278	Água Boa	510020	13	20856	3	água-boense	7538
2280	Alto Araguaia	510030	13	15644	3	araguaiano 	5515
2281	Alto Boa Vista	510035	13	5247	2	alto boa vistense	2240
2283	Alto Paraguai	510050	13	10066	5	alto-paraguaiense	1846
2285	Apiacás	510080	13	8567	0	apiacaense	20380
2286	Araguaiana	510100	13	3197	1	araguaianense	6429
2288	Araputanga	510125	13	15342	10	araputanguense	1600
2290	Aripuanã	510140	13	18656	1	aripuanense	24613
2292	Barra Do Bugres	510170	13	31793	5	barrense	5993
2294	Bom Jesus Do Araguaia	510185	13	5314	1	 bom-jesuense 	4274
2295	Brasnorte	510190	13	15357	1	brasnortense	15959
2297	Campinápolis	510260	13	14305	2	campinapolense	5835
2299	Campo Verde	510267	13	31589	7	campo-verdense	4782
2300	Campos De Júlio	510268	13	5154	1	campo juliense	6802
2302	Canarana	510270	13	18754	2	canaranense	10854
2304	Castanheira	510285	13	8231	2	castanheirense	3704
2306	Cláudia	510305	13	11028	3	claudiense	3850
2307	Cocalinho	510310	13	5490	0	cocalinhense	16531
2309	Colniza	510325	13	26381	1	colnizense	27925
2310	Comodoro	510330	13	18178	1	comodorense	21774
2313	Cotriguaçu	510337	13	14983	2	cotriguaçuenses	9460
2314	Cuiabá	510340	13	551098	164	cuiabano (papa peixe)	3363
2316	Denise	510345	13	8523	7	denisiense	1307
2318	Dom Aquino	510360	13	8171	4	dom-aquinense	2204
2320	Figueirópolis D`Oeste	510380	13	3796	4	figueiropolense	899
2321	Gaúcha Do Norte	510385	13	6293	0	gauchenses-do-norte	16931
2323	Glória D`Oeste	510395	13	3135	4	glorienses-do-oeste	854
2325	Guiratinga	510420	13	13934	3	guiratinguense 	5062
2327	Ipiranga Do Norte	510452	13	5123	1	ipiranguense	3467
2328	Itanhangá	510454	13	5276	2	itanhangaense	2898
2330	Itiquira	510460	13	11478	1	itiquirense	8722
2332	Jangada	510490	13	7696	6	jangadense	1254
2334	Juara	510510	13	32791	1	juarense	22641
2335	Juína	510515	13	39255	1	juinense	26396
2337	Juscimeira	510520	13	11430	5	juscimeirense	2206
2339	Lucas Do Rio Verde	510525	13	45556	12	luquense	3664
2341	Marcelândia	510558	13	12006	1	marcelandense	12281
2342	Matupá	510560	13	14174	3	matupaense	5239
2344	Nobres	510590	13	15002	4	nobrense	3892
2346	Nossa Senhora Do Livramento	510610	13	11609	2	livramentense	5541
2348	Nova Brasilândia	510620	13	4587	1	brasilandense	3282
2349	Nova Canaã Do Norte	510621	13	12127	2	canaense	5966
2351	Nova Lacerda	510618	13	5436	1	novo-lacerdenses	4730
2353	Nova Maringá	510890	13	6590	1	nova maringaense	11557
2355	Nova Mutum	510622	13	31649	3	mutuense	9556
2356	Nova Nazaré	510617	13	3029	1	nova-nazareenses	4038
2358	Nova Santa Helena	510619	13	3468	2	nova-santa-helenenses	2205
2360	Nova Xavantina	510625	13	19643	3	nova-xavantinense	5668
2362	Novo Mundo	510626	13	7332	1	novo-mundenses	5790
2363	Novo Santo Antônio	510631	13	2005	0	novo-santo-antoniense	4394
2365	Paranaíta	510629	13	10684	2	paranaitense	4796
2367	Pedra Preta	510637	13	15755	4	pedra-pretense	4109
2369	Planalto Da Serra	510645	13	2726	1	planaltenses-da-serra	2455
2370	Poconé	510650	13	31779	2	poconeano	17271
2372	Ponte Branca	510670	13	1768	3	ponte-branquense	686
2374	Porto Alegre Do Norte	510677	13	10748	3	porto-alegrense	3972
2376	Porto Esperidião	510682	13	11031	2	portense	5808
2377	Porto Estrela	510685	13	3649	2	portoestrelense	2063
2379	Primavera Do Leste	510704	13	52066	10	primaverense	5472
2381	Reserva Do Cabaçal	510715	13	2572	2	reservense	1337
2383	Ribeirãozinho	510719	13	2199	4	ribeirãozense	626
2384	Rio Branco	510720	13	5070	9	rio-branquense	563
2386	Rondonópolis	510760	13	195476	47	rondonopolitano	4159
2388	Salto Do Céu	510775	13	3908	2	saltense	1752
2389	Santa Carmem	510724	13	4085	1	santa-carmense 	3855
2391	Santa Rita Do Trivelato	510776	13	2491	1	trivelatenses	4728
2393	Santo Afonso	510726	13	2991	3	santo-afonsense 	1174
2395	Santo Antônio Do Leverger	510780	13	18463	2	santo-antoniense (papa abóbora)	11754
2736	São Bentinho	251392	15	4138	21	sãobentinhense	196
2399	São José Do Xingu	510735	13	5240	1	São-xinguano	7460
2401	São Pedro Da Cipa	510740	13	4158	12	cipense	343
2402	Sapezal	510787	13	18094	1	sapezalense	13624
2403	Serra Nova Dourada	510788	13	1365	1	serra douradense	1500
2405	Sorriso	510792	13	66521	7	sorrisiense	9330
2407	Tangará Da Serra	510795	13	83431	7	tangaraense	11391
2409	Terra Nova Do Norte	510805	13	11291	4	terra-novense	2717
2410	Tesouro	510810	13	3418	1	tesourense	4170
2412	União Do Sul	510830	13	3760	1	União-sulense	4582
2414	Várzea Grande	510840	13	252596	284	várzea-grandense	888
2415	Vera	510850	13	10235	3	verense	2963
2417	Vila Rica	510860	13	21382	3	vila-riquense	7431
2419	Abel Figueiredo	150013	14	6780	11	abel-figueiredense	614
2421	Afuá	150030	14	35042	4	afuaense	8373
2422	Água Azul Do Norte	150034	14	25057	4	agua-azulense	7114
2424	Almeirim	150050	14	33614	0	almeiriense 	72955
2426	Anajás	150070	14	24759	4	anajaense	6922
2428	Anapu	150085	14	20543	2	anapuense	11895
2430	Aurora Do Pará	150095	14	26546	15	auroenses	1812
2431	Aveiro	150100	14	15849	1	aveirense	17074
2433	Baião	150120	14	36882	10	baionense	3758
2435	Barcarena	150130	14	99859	76	barcarenense	1310
2436	Belém	150140	14	1393399	1	belenense	1059
2438	Benevides	150150	14	51651	275	benevidense	188
2440	Bonito	150160	14	13630	23	bonitense	587
2442	Brasil Novo	150172	14	15690	2	brasil-novense	6363
2444	Breu Branco	150178	14	52493	13	breuense	3942
2445	Breves	150180	14	92860	10	brevense	9550
2447	Cachoeira Do Arari	150200	14	20443	7	cachoeirense	3102
2449	Cametá	150210	14	120896	39	cametaense	3081
2450	Canaã Dos Carajás	150215	14	26716	8	canaãnense	3146
2452	Capitão Poço	150230	14	51893	18	capitão-pocense	2900
2454	Chaves	150250	14	21005	2	chaveense	13085
2456	Conceição Do Araguaia	150270	14	45557	8	araguaiano 	5829
2457	Concórdia Do Pará	150275	14	28216	41	concordiense	691
2459	Curionópolis	150277	14	18288	8	curionopolense	2369
2461	Curuá	150285	14	12254	9	curuaense	1431
2463	Dom Eliseu	150293	14	51319	10	dom-eliseuense	5269
2465	Faro	150300	14	8177	1	farense	11771
2466	Floresta Do Araguaia	150304	14	17768	5	floresta-araguaiense	3444
2468	Goianésia Do Pará	150309	14	30436	4	goianesiense 	7024
2469	Gurupá	150310	14	29062	3	gurupaense	8540
2471	Igarapé Miri	150330	14	58077	29	igarapé-miriense	1997
2473	Ipixuna Do Pará	150345	14	51309	10	ipixunense	5216
2475	Itaituba	150360	14	97493	2	itaitubense	62040
2476	Itupiranga	150370	14	51220	7	itupiranguense	7880
2478	Jacundá	150380	14	51360	26	jacundaense	2008
2480	Limoeiro Do Ajuru	150400	14	25021	17	ajuruense	1490
2482	Magalhães Barata	150410	14	8115	25	magalhães-baratense	324
2484	Maracanã	150430	14	28376	33	maracanaense	857
2485	Marapanim	150440	14	26605	33	marapaniense	796
2487	Medicilândia	150445	14	27328	3	medicilandense	8273
2489	Mocajuba	150460	14	26731	31	mocajubense	871
2491	Monte Alegre	150480	14	55462	3	montalegrense 	18153
2492	Muaná	150490	14	34204	9	muanaense	3766
2494	Nova Ipixuna	150497	14	14645	9	nova-ipixunense	1564
2496	Novo Progresso	150503	14	25124	1	progressense	38162
2498	Óbidos	150510	14	49333	2	obidense 	28021
2499	Oeiras Do Pará	150520	14	28595	7	oeirense	3852
2501	Ourém	150540	14	16311	29	ouremense	562
2503	Pacajá	150548	14	39979	3	pacajaense	11832
2504	Palestina Do Pará	150549	14	7475	8	palestinenses	984
2506	Parauapebas	150553	14	153908	22	parauapebense	6957
2508	Peixe Boi	150560	14	7854	17	peixe-boiense	451
2509	Piçarra	150563	14	12697	4	Piçarrense	3313
2511	Ponta De Pedras	150570	14	25999	8	ponta-pedrense	3365
2513	Porto De Moz	150590	14	33956	2	porto-mozense	17423
2515	Primavera	150610	14	10268	40	primaverense	259
2517	Redenção	150613	14	75556	20	redencense	3824
2518	Rio Maria	150616	14	17697	4	rio-mariense	4115
2520	Rurópolis	150619	14	40087	6	ruropolense	7021
2522	Salvaterra	150630	14	20183	19	salvaterrense	1039
2872	Jaqueira	260795	16	11501	132	jaqueirense	87
2526	Santa Luzia Do Pará	150655	14	19424	14	santaluziense 	1356
2527	Santa Maria Das Barreiras	150658	14	17206	2	barreirense	10330
2529	Santana Do Araguaia	150670	14	56153	5	araguaiense 	11592
2530	Santarém	150680	14	294580	13	santareno 	22887
2532	Santo Antônio Do Tauá	150700	14	26674	50	tauaense	538
2534	São Domingos Do Araguaia	150715	14	23130	17	são dominguense do araguaia	1392
2536	São Félix Do Xingu	150730	14	91340	1	xinguense 	84213
2537	São Francisco Do Pará	150740	14	15060	31	franciscano	480
2539	São João Da Ponta	150746	14	5265	27	são joão pontense 	196
2541	São João Do Araguaia	150750	14	13155	10	são-joanense	1280
2542	São Miguel Do Guamá	150760	14	51567	46	guamaense	1110
2544	Sapucaia	150775	14	5047	4	sapucaiense	1298
2545	Senador José Porfírio	150780	14	13045	1	porfiriense	14374
2547	Tailândia	150795	14	79297	18	tailandense	4430
2549	Terra Santa	150797	14	16949	9	terrasantense	1897
2550	Tomé Açu	150800	14	56518	11	tomé-açuense	5145
2552	Trairão	150805	14	16875	1	trairense	11991
2554	Tucuruí	150810	14	97128	47	tucuruiense	2086
2556	Uruará	150815	14	44789	4	uruaraense	10791
2557	Vigia	150820	14	47889	89	vigiense 	539
2559	Vitória Do Xingu	150835	14	13431	4	vitoriense	3135
2561	Água Branca	250010	15	9449	40	agua branquense	237
2563	Alagoa Grande	250030	15	28479	89	alagoa-grandense	321
2565	Alagoinha	250050	15	13576	140	alagoinhense	97
2567	Algodão De Jandaíra	250057	15	2366	11	algodoense	220
2568	Alhandra	250060	15	18007	99	alhandrense	183
2570	Aparecida	250077	15	7676	26	aparecidense	296
2572	Arara	250090	15	12653	128	araraense 	99
2574	Areia	250110	15	23829	88	areiense	269
2576	Areial	250120	15	6470	195	areialense	33
2577	Aroeiras	250130	15	19082	51	aroeirense	375
2579	Baía Da Traição	250140	15	8012	78	baianense 	102
2581	Baraúna	250153	15	4220	83	baraunense	51
2583	Barra De Santana	250157	15	8206	22	barrasantense	377
2584	Barra De São Miguel	250170	15	5611	9	barrense	595
2586	Belém	250190	15	17093	171	belenense 	100
2588	Bernardino Batista	250205	15	3075	61	batistense	51
2589	Boa Ventura	250210	15	5751	34	boa-venturense	171
2591	Bom Jesus	250220	15	2400	50	bom-jesuense	48
2593	Bonito De Santa Fé	250240	15	10804	47	bonitense	228
2595	Borborema	250270	15	5111	197	borboremense 	26
2596	Brejo Do Cruz	250280	15	13123	33	brejo-cruzense 	399
2598	Caaporã	250300	15	20362	136	caaporãense	150
2600	Cabedelo	250320	15	57944	2	cabedelense	32
2602	Cacimba De Areia	250340	15	3557	16	cacimbense (de Areia) 	220
2603	Cacimba De Dentro	250350	15	16748	102	cacimbense (de Dentro)	164
2605	Caiçara	250360	15	7220	56	caiçarense	128
2607	Cajazeirinhas	250375	15	3033	11	cajazeirinhense	288
2609	Camalaú	250390	15	5749	11	camalauense	544
2610	Campina Grande	250400	15	385213	648	campinense	594
2612	Caraúbas	250407	15	3899	8	caraúbense	497
2614	Casserengue	250415	15	7058	35	cassereguense	201
2616	Catolé Do Rocha	250430	15	28759	52	catoleense	552
2617	Caturité	250435	15	4543	38	caturiteense	118
2619	Condado	250450	15	6584	23	condadense	281
2621	Congo	250470	15	4687	14	congoense	333
2623	Coxixola	250485	15	1771	10	coxixolense	170
2625	Cubati	250500	15	6866	50	cubatiense	137
2626	Cuité	250510	15	19978	27	cuiteense	742
2628	Cuitegi	250520	15	6889	175	cuitegiense	39
2630	Curral Velho	250530	15	2505	11	curral-velhense	223
2631	Damião	250535	15	4900	26	damiãoense	186
2633	Diamante	250560	15	6616	25	diamantense	269
2634	Dona Inês	250570	15	10517	63	inesense	166
2636	Emas	250590	15	3317	14	emense	241
2638	Fagundes	250610	15	11405	60	fagundense	189
2640	Gado Bravo	250625	15	8376	44	gadobravense	192
2641	Guarabira	250630	15	55326	334	guarabirense	166
2643	Gurjão	250650	15	3159	9	gurjaense	343
2645	Igaracy	250260	15	6156	32	igaraciense	192
2647	Ingá	250680	15	18180	63	ingaense	288
2648	Itabaiana	250690	15	24481	112	itabaianense	219
2714	Puxinanã	251240	15	12923	178	puxinanaense	73
2715	Queimadas	251250	15	41049	102	queimadense	402
2717	Remígio	251270	15	17581	99	remigioense 	178
2719	Riachão Do Bacamarte	251275	15	4264	111	riachonense	38
2720	Riachão Do Poço	251276	15	4164	104	riachãoense	40
2722	Riacho Dos Cavalos	251280	15	8314	31	riachoense	264
2723	Rio Tinto	251290	15	22976	49	rio-tintense	465
2725	Salgado De São Félix	251310	15	11976	59	salgadense	202
2727	Santa Cruz	251320	15	6471	31	santa-cruzense	210
2729	Santa Inês	251335	15	3539	11	santineense	324
2730	Santa Luzia	251340	15	14719	32	santa-luziense	456
2732	Santa Teresinha	251380	15	4581	13	santa-teresinhense	358
2734	Santana Dos Garrotes	251360	15	7266	21	santana-garrotense	354
2735	Santo André	251385	15	2638	12	santoandreense	225
2737	São Bento	251390	15	30879	124	são-bentense 	248
2739	São Domingos Do Cariri	251394	15	2420	11	sãodominguense	219
2740	São Francisco	251398	15	3364	35	francisquense	95
2742	São João Do Rio Do Peixe	250070	15	18201	38	são-joanense	474
2743	São João Do Tigre	251410	15	4396	5	são-joão-tigrense	816
2745	São José De Caiana	251430	15	6010	34	caianense	176
2747	São José De Piranhas	251450	15	19096	28	piranhense	677
2748	São José De Princesa	251455	15	4219	27	sãojoseense	158
2750	São José Do Brejo Do Cruz	251465	15	1684	7	sãojoseense	253
2751	São José Do Sabugi	251470	15	4010	19	sabugiense	207
2753	São José Dos Ramos	251445	15	5508	56	sanjoseense	98
2754	São Mamede	251490	15	7748	15	são-mamedense	531
2756	São Sebastião De Lagoa De Roça	251510	15	11041	221	lagoense (de Roça)	50
2758	Sapé	251530	15	50143	159	sapeense	316
2652	Jacaraú	250730	15	13942	55	jacarauense	253
2654	João Pessoa	250750	15	723515	3	pessoense	211
2656	Juarez Távora	250760	15	7459	105	tavorense	71
2657	Juazeirinho	250770	15	16776	36	juazeirinhense	468
2659	Juripiranga	250790	15	10237	130	juripiranguense	79
2660	Juru	250800	15	9826	24	juruense	403
2662	Lagoa De Dentro	250820	15	7370	87	lagoa-dentrense	85
2664	Lastro	250840	15	2841	28	lastrense	103
2666	Logradouro	250855	15	3942	104	logradourense	38
2668	Mãe D`Água	250870	15	4019	16	mãe-daguense	244
2669	Malta	250880	15	5613	36	maltense 	156
2671	Manaíra	250900	15	10759	31	manairense	353
2673	Mari	250910	15	21176	137	mariense	155
2675	Massaranduba	250920	15	12902	63	massarandubense	206
2676	Mataraca	250930	15	7407	40	mataraquense	184
2678	Mato Grosso	250937	15	2702	32	matogrossense	84
2680	Mogeiro	250940	15	12491	64	mogeirense	194
2682	Monte Horebe	250960	15	4508	39	horebense	116
2683	Monteiro	250970	15	30852	31	monteirense	986
2685	Natuba	250990	15	10566	52	natubense	205
2687	Nova Floresta	251010	15	10533	222	nova-florestense	47
2689	Nova Palmeira	251030	15	4361	14	nova-palmeirense	310
2691	Olivedos	251050	15	3627	11	olivedense	318
2693	Parari	251065	15	1256	10	parariense	128
2694	Passagem	251070	15	2233	20	passagense	112
2696	Paulista	251090	15	11788	20	paulistense 	577
2698	Pedra Lavrada	251110	15	7475	21	pedra-lavradense	352
2700	Pedro Régis	251272	15	5765	78	pedroregense	74
2701	Piancó	251130	15	15465	27	piancoense	565
2703	Pilar	251150	15	11191	109	pilarense 	102
2705	Pilõezinhos	251170	15	5155	117	pilõezinhense	44
2707	Pitimbu	251190	15	17024	125	pitimbuense	136
2708	Pocinhos	251200	15	17032	27	pocinhense	628
2710	Poço De José De Moura	251207	15	3978	39	pocense	101
2712	Prata	251220	15	3854	20	prataense	192
2759	Seridó	251540	15	10230	37	seridoense	276
2761	Serra Da Raiz	251560	15	3204	110	serra-raizense 	29
2762	Serra Grande	251570	15	2975	36	serra-grandense	83
2764	Serraria	251590	15	6238	96	serrariense	65
2766	Sobrado	251597	15	7373	119	sobradense	62
2767	Solânea	251600	15	26693	115	solanense	232
2769	Sossêgo	251615	15	3169	20	sosseguense	155
2771	Sumé	251630	15	16060	19	sumeense	838
2773	Taperoá	251650	15	14936	23	taperoaense	663
2774	Tavares	251660	15	14103	59	tavarense	237
2777	Triunfo	251680	15	9220	42	triunfense	220
2779	Umbuzeiro	251700	15	9298	51	umbuzeirense	181
2780	Várzea	251710	15	2504	13	varzense	190
2782	Vista Serrana	250550	15	3512	57	vista-serranense	61
2784	Abreu E Lima	260005	16	94429	725	abreu-limense	130
2786	Afrânio	260020	16	17586	12	afraniense	1491
2787	Agrestina	260030	16	22679	113	agrestinense	201
2789	Águas Belas	260050	16	40235	45	águas-belense	886
2791	Aliança	260070	16	37415	137	aliancense	273
2793	Amaraji	260090	16	21939	93	amarajinense 	235
2794	Angelim	260100	16	10202	86	angelinense	118
2796	Araripina	260110	16	77302	41	araripinense	1893
2798	Barra De Guabiraba	260130	16	12776	111	guabirabense	115
2800	Belém De Maria	260150	16	11353	154	belenense	74
2802	Belo Jardim	260170	16	72432	112	belo-jardinense	648
2803	Betânia	260180	16	12003	10	betaniense	1244
2805	Bodocó	260200	16	35158	22	bodocense 	1616
2807	Bom Jardim	260220	16	37826	173	bom-jardinense	218
2808	Bonito	260230	16	37566	95	bonitense	396
2810	Brejinho	260250	16	7307	69	brejinhense	106
2812	Buenos Aires	260270	16	12537	135	buenairense	93
2813	Buíque	260280	16	52105	39	buiquense	1348
2815	Cabrobó	260300	16	30873	19	cabroboense 	1658
2817	Caetés	260320	16	26577	81	caeteense	329
2818	Calçado	260330	16	11125	91	calçadense	122
2820	Camaragibe	260345	16	144466	3	camaragibense	51
2822	Camutanga	260360	16	8156	217	camutanguense	38
2823	Canhotinho	260370	16	24521	58	canhotinhense	423
2825	Carnaíba	260390	16	18574	43	carnaibano 	428
2827	Carpina	260400	16	74858	517	carpinense	145
2828	Caruaru	260410	16	314912	342	caruaruense 	921
2830	Catende	260420	16	37820	182	catendense	207
2832	Chã De Alegria	260440	16	12404	256	alegriense	48
2834	Condado	260460	16	24282	271	condadense	90
2836	Cortês	260480	16	12452	123	cortesense	101
2837	Cumaru	260490	16	17183	59	cumaruense	292
2839	Custódia	260510	16	33855	24	custodiense	1404
2841	Escada	260520	16	63517	183	escadense	347
2843	Feira Nova	260540	16	20571	191	feira-novense	108
2845	Ferreiros	260550	16	11430	128	ferreirense	89
2846	Flores	260560	16	22169	22	florense	996
2848	Frei Miguelinho	260580	16	14293	67	frei-miguelinhense	213
2850	Garanhuns	260600	16	129408	282	garanhuense	459
2852	Goiana	260620	16	75644	151	goianense	502
2853	Granito	260630	16	6855	13	granitense	522
2855	Iati	260650	16	18360	29	iatiense	635
2857	Ibirajuba	260670	16	7534	40	ibirajubense	190
2859	Iguaraci	260690	16	11779	14	iguaraciense	838
2861	Inajá	260700	16	19081	16	inajaense 	1183
2862	Ingazeira	260710	16	4496	18	ingazeirense	244
2864	Ipubi	260730	16	28120	33	ipubiense	861
2866	Itaíba	260750	16	26256	24	itaibense	1084
2868	Itapetim	260770	16	13881	34	itapetinense	405
2869	Itapissuma	260775	16	23769	320	itapissumense	74
2871	Jaboatão Dos Guararapes	260790	16	644620	2	jaboatãoense	259
2873	Jataúba	260800	16	15819	24	jataubense	672
2875	João Alfredo	260810	16	30743	222	alfredense	138
2877	Jucati	260825	16	10604	88	jucatiense	121
2878	Jupi	260830	16	13705	131	jupiense	105
2880	Lagoa Do Carro	260845	16	16007	230	lagoense do carro	70
2882	Lagoa Do Ouro	260860	16	12132	61	lagoa-do-ourense	199
2884	Lagoa Grande	260875	16	22760	12	lagoa-grandense	1852
2885	Lajedo	260880	16	36628	194	lajedense	189
2887	Macaparana	260900	16	23925	221	macaparanense 	108
2889	Manari	260915	16	18083	47	manariense	381
2891	Mirandiba	260930	16	14308	17	mirandibense	822
2893	Moreno	260940	16	56696	289	morenense	196
2894	Nazaré Da Mata	260950	16	30796	205	nazareno	150
2896	Orobó	260970	16	22878	165	orobense 	139
2898	Ouricuri	260990	16	64358	27	ouricuriense 	2423
2899	Palmares	261000	16	59526	175	palmarense	339
2901	Panelas	261020	16	25645	69	panelense	371
2903	Parnamirim	261040	16	20224	8	parnamirinense 	2596
2905	Paudalho	261060	16	51357	185	paudalhense	278
5414	Valparaíso	355630	26	22576	26	valparaisense	858
2908	Pesqueira	261090	16	62931	63	pesqueirense	996
2909	Petrolândia	261100	16	32492	31	petrolandense	1057
2911	Poção	261120	16	11242	46	poçãoense	247
2913	Primavera	261140	16	13439	122	primaverense	110
2915	Quixaba	261153	16	6739	32	quixabense	211
2916	Recife	261160	16	1537704	7	recifense	218
2918	Ribeirão	261180	16	44439	154	ribeirãoense	288
2920	Sairé	261200	16	11240	59	saireense	191
2922	Salgueiro	261220	16	56629	34	salgueirense	1687
2923	Saloá	261230	16	15309	61	saloaense	252
2925	Santa Cruz	261245	16	13594	11	santacruzense	1256
2927	Santa Cruz Do Capibaribe	261250	16	87582	261	santa-cruzense	335
2929	Santa Maria Da Boa Vista	261260	16	39435	13	boa-vistense	3001
2930	Santa Maria Do Cambucá	261270	16	13021	141	santa-mariense	92
2932	São Benedito Do Sul	261290	16	13941	87	são-beneditense	160
2934	São Caitano	261310	16	35274	92	são-caitanense	382
2935	São João	261320	16	21312	83	são-joanense	258
2937	São José Da Coroa Grande	261340	16	18180	262	são-josé-coroa-grandense	69
2939	São José Do Egito	261360	16	31829	40	egipsiense	799
2941	São Vicente Ferrer	261380	16	17000	149	são-vicentino	114
2942	Serra Talhada	261390	16	79232	27	serra-talhadense	2980
2944	Sertânia	261410	16	33787	14	sertaniense	2422
2946	Solidão	261440	16	5744	42	solidanense	138
2947	Surubim	261450	16	58515	231	surubinense	253
2949	Tacaimbó	261470	16	12725	56	tacaimboense	228
2951	Tamandaré	261485	16	20715	97	tamandareense	214
2953	Terezinha	261510	16	6737	44	terezinhense	151
2954	Terra Nova	261520	16	9278	29	terra-novense	321
2956	Toritama	261540	16	35554	1	toritamense 	26
2958	Trindade	261560	16	26116	114	trindadense	230
2960	Tupanatinga	261580	16	24425	28	tupanatinguense	884
2961	Tuparetama	261590	16	7925	44	tuparetamense	179
2963	Verdejante	261610	16	9142	19	verdejantense	476
2965	Vertentes	261620	16	18222	93	vertentense	196
2967	Vitória De Santo Antão	261640	16	129974	350	vitoriense	372
2968	Xexéu	261650	16	14093	127	xexeuense	111
2970	Agricolândia	220010	17	5098	45	agricolandiense	112
2972	Alagoinha Do Piauí	220025	17	7341	14	alagoinense	533
2974	Alto Longá	220030	17	13646	8	longaense	1738
2975	Altos	220040	17	38822	41	altoense	958
2977	Amarante	220050	17	17135	15	amarantino	1155
2979	Anísio De Abreu	220070	17	9098	27	anisiense	338
2981	Aroazes	220090	17	5779	7	aroazense	822
2982	Aroeiras Do Itaim	220095	17	2440	9	\N	257
2984	Assunção Do Piauí	220105	17	7503	4	assunçãoense	1691
2985	Avelino Lopes	220110	17	11067	8	avelino-lopense	1306
2987	Barra D`Alcântara	220117	17	3852	15	barra d?alcantarense	263
2989	Barreiras Do Piauí	220130	17	3234	2	barreirense	2028
2991	Batalha	220150	17	25774	16	batalhense	1589
2993	Belém Do Piauí	220157	17	3284	14	belenense	243
2994	Beneditinos	220160	17	9911	13	beneditinense	789
2996	Betânia Do Piauí	220173	17	6015	11	betanhense	565
2997	Boa Hora	220177	17	6296	19	boa horense	338
2999	Bom Jesus	220190	17	22629	4	bom-jesuense	5469
3001	Bonfim Do Piauí	220192	17	5393	19	bonfinense	289
3003	Brasileira	220196	17	7966	9	brasileirense	881
3004	Brejo Do Piauí	220198	17	3850	2	brejense	2183
3006	Buriti Dos Montes	220202	17	7974	3	buritiense	2652
3008	Cajazeiras Do Piauí	220207	17	3343	7	cajazerense	514
3009	Cajueiro Da Praia	220208	17	7163	26	cajueirense	272
3011	Campinas Do Piauí	220210	17	5408	7	campinense	831
3012	Campo Alegre Do Fidalgo	220211	17	4693	7	campo alegrense	658
3014	Campo Largo Do Piauí	220217	17	6803	14	campolargoense	478
3015	Campo Maior	220220	17	45177	27	campo-maiorense	1676
3018	Capitão De Campos	220240	17	10953	19	capitão-de-campense	592
3019	Capitão Gervásio Oliveira	220245	17	3878	3	gervasense	1134
3021	Caraúbas Do Piauí	220253	17	5525	12	carubense	471
3023	Castelo Do Piauí	220260	17	18336	9	castelense	2035
3024	Caxingó	220265	17	5039	10	caxingoense	488
3026	Cocal De Telha	220271	17	4525	16	cocatelhense	282
3028	Coivaras	220273	17	3811	8	coivarense	485
5416	Vargem Grande Do Sul	355640	26	39266	147	vargem-grandense	267
3032	Coronel José Dias	220285	17	4541	2	coronelino	1915
3033	Corrente	220290	17	25407	8	correntino	3048
3035	Cristino Castro	220310	17	9981	5	cristino-castrense	1846
3037	Currais	220323	17	4704	1	curralense	3157
3039	Curralinhos	220325	17	4183	12	curralinhense	346
3040	Demerval Lobão	220330	17	13278	61	morrinhense	217
3042	Dom Expedito Lopes	220340	17	6569	30	dom-expedito-lopense	219
3044	Domingos Mourão	220342	17	4264	5	domingos-mouronense	847
3046	Eliseu Martins	220360	17	4665	4	eliseu-martinino 	1090
3047	Esperantina	220370	17	37767	41	esperantinense	911
3049	Flores Do Piauí	220380	17	4366	5	florentino-do-piauí	947
3051	Floriano	220390	17	57690	17	florianense	3410
3053	Francisco Ayres	220410	17	4477	7	airense	656
3054	Francisco Macedo	220415	17	2879	19	francisco macedense	155
3056	Fronteiras	220430	17	11117	14	fronteirense	776
3058	Gilbués	220440	17	10402	3	gilbuense	3495
3059	Guadalupe	220450	17	10268	10	guadalupense	1024
3061	Hugo Napoleão	220460	17	3771	17	hugo-napoleonense	224
3063	Inhuma	220470	17	14845	15	inhumense	978
3065	Isaías Coelho	220490	17	8221	11	isaiense	776
3067	Itaueira	220510	17	10678	4	itaueirense	2554
3068	Jacobina Do Piauí	220515	17	5722	4	jacobinense	1371
3070	Jardim Do Mulato	220525	17	4309	8	jardimulatense	510
3072	Jerumenha	220530	17	4390	2	jerumenhense	1867
3073	João Costa	220535	17	2960	2	joão costense	1800
3075	Joca Marques	220545	17	5100	31	jocamarquense	166
3077	Juazeiro Do Piauí	220551	17	4757	6	juazeirense	827
3079	Jurema	220553	17	4517	4	juremense	1272
3080	Lagoa Alegre	220555	17	8008	20	lagoalegrense	395
3082	Lagoa Do Barro Do Piauí	220556	17	4523	4	lagoa do barrense	1262
3084	Lagoa Do Sítio	220559	17	4850	6	sitiolagoense	805
3085	Lagoinha Do Piauí	220554	17	2656	39	lagoinense	68
3087	Luís Correia	220570	17	28406	27	luís-correiense	1071
3089	Madeiro	220585	17	7816	44	madeirense	177
3091	Marcolândia	220595	17	7812	54	marcolandense	144
3092	Marcos Parente	220600	17	4456	7	marcos-parentense	677
3094	Matias Olímpio	220610	17	10473	46	matiense	226
3096	Miguel Leão	220630	17	1253	13	leonino	94
3098	Monsenhor Gil	220640	17	10333	18	monsenhorgilense	569
3099	Monsenhor Hipólito	220650	17	7391	18	hipolitano	401
3101	Morro Cabeça No Tempo	220665	17	4068	2	morrense	2117
3103	Murici Dos Portelas	220669	17	8464	18	muriciense	482
3104	Nazaré Do Piauí	220670	17	7321	6	nazareno-do-piauí	1316
3106	Nossa Senhora De Nazaré	220675	17	4556	13	nazareno	356
3108	Nova Santa Rita	220795	17	4187	5	Santaritense 	910
3109	Novo Oriente Do Piauí	220690	17	6498	12	novo-orientino	525
3111	Oeiras	220700	17	35640	13	oeirense	2702
3113	Padre Marcos	220720	17	6657	24	padre-marquense	272
3114	Paes Landim	220730	17	4059	10	paes-landinense	401
3116	Palmeira Do Piauí	220740	17	4993	2	palmeirino	2024
3117	Palmeirais	220750	17	13745	9	palmeirense	1499
3119	Parnaguá	220760	17	10276	3	parnaguaense	3429
3121	Passagem Franca Do Piauí	220775	17	4546	5	passagemfranquense	850
3123	Pau D`Arco Do Piauí	220779	17	3757	9	paudarquiense	431
3125	Pavussu	220785	17	3663	3	pavussuense	1091
3126	Pedro Ii	220790	17	37496	25	pedro-segundense	1518
3128	Picos	220800	17	73414	137	picoense	535
3130	Pio Ix	220820	17	17671	9	pio-nonense	1947
3132	Piripiri	220840	17	61834	44	piripiriense	1409
3133	Porto	220850	17	11897	47	portuense	253
3135	Prata Do Piauí	220860	17	3085	16	pratense	196
3137	Redenção Do Gurguéia	220870	17	8400	3	gurgueíno	2468
3139	Riacho Frio	220885	17	4241	2	riacho friense	2222
3140	Ribeira Do Piauí	220887	17	4263	4	ribeirense	1004
3142	Rio Grande Do Piauí	220900	17	6273	10	rio-grandense-do-piauí	636
3144	Santa Cruz Dos Milagres	220915	17	3794	4	santacruzense	980
3145	Santa Filomena	220920	17	6096	1	filomense 	5285
3147	Santa Rosa Do Piauí	220937	17	5149	15	santarosense	340
3149	Santo Antônio De Lisboa	220940	17	6007	16	santo-antoense	387
3273	Colorado	410590	18	22345	55	colorados	403
3152	São Braz Do Piauí	220955	17	4313	7	san-brazense	656
3154	São Francisco De Assis Do Piauí	220965	17	5567	5	sãofranciscoense 	1100
3156	São Gonçalo Do Gurguéia	220975	17	2825	2	são gonçalense	1385
3158	São João Da Canabrava	220985	17	4445	9	canabravense	480
3159	São João Da Fronteira	220987	17	5608	7	são jão fronteirense	765
3161	São João Da Varjota	220995	17	4651	12	sanjoanense	395
3163	São João Do Piauí	221000	17	19548	13	são-joanense	1528
3164	São José Do Divino	221005	17	5148	16	divinense	319
3166	São José Do Piauí	221020	17	6591	18	são-joseense	365
3167	São Julião	221030	17	5675	22	são-julianense	257
3169	São Luis Do Piauí	221037	17	2561	12	sãoluisense	220
3171	São Miguel Do Fidalgo	221039	17	2976	4	fidalguense	813
3172	São Miguel Do Tapuio	221040	17	18134	3	tapuiense	5207
3174	São Raimundo Nonato	221060	17	32327	13	são-raimundense	2416
3176	Sebastião Leal	221063	17	4116	1	sebastião-lealense	3152
3177	Sigefredo Pacheco	221065	17	9619	10	sigefredense	967
3179	Simplício Mendes	221080	17	12077	9	simplício-mendense	1346
3181	Sussuapara	221093	17	6229	30	sussuaparense	210
3183	Tanque Do Piauí	221097	17	2620	7	tanquense	399
3184	Teresina	221100	17	814230	585	teresinense	1392
3186	Uruçuí	221120	17	20149	2	uruçuiense	8412
3188	Várzea Branca	221135	17	4913	11	varzea-branquense	451
3190	Vera Mendes	221150	17	2986	9	veramendense 	342
3191	Vila Nova Do Piauí	221160	17	3076	14	vilanovense	218
3193	Abatiá	410010	18	7764	34	abatiense	229
3195	Agudos Do Sul	410030	18	8270	43	agudense-do-sul 	192
3197	Altamira Do Paraná	410045	18	4306	11	altamirense	387
3198	Alto Paraíso	412862	18	3206	3	altoparaisense	968
3200	Alto Piquiri	410070	18	10179	23	alto-piquirense	448
3201	Altônia	410050	18	20516	31	altoniano 	662
3203	Amaporã	410090	18	5443	14	amaporense	385
3205	Anahy	410105	18	2874	28	anaiense	103
3207	Ângulo	410115	18	2859	27	angulense	106
3208	Antonina	410120	18	18891	21	antoninense 	882
3210	Apucarana	410140	18	120919	217	apucaranense	558
3212	Arapoti	410160	18	25855	19	arapotiense	1360
3214	Araruna	410170	18	13419	27	ararunense	493
3215	Araucária	410180	18	119123	254	araucariano 	469
3217	Assaí	410190	18	16354	37	assaiense	440
3219	Astorga	410210	18	24698	57	astorgano 	435
3221	Balsa Nova	410230	18	11300	32	balsa-novense 	349
3222	Bandeirantes	410240	18	32184	72	bandeirantense	445
3224	Barra Do Jacaré	410270	18	2727	24	barrense	116
3226	Bela Vista Da Caroba	410275	18	3945	27	boaesperencense	148
3228	Bituruna	410290	18	15880	13	biturenense	1215
3229	Boa Esperança	410300	18	4568	15	boa-esperansense	307
3231	Boa Ventura De São Roque	410304	18	6554	11	boa venturense 	622
3233	Bocaiúva Do Sul	410310	18	10987	13	bocaiuvense 	826
3234	Bom Jesus Do Sul	410315	18	3796	22	bonjesuense	174
3236	Bom Sucesso Do Sul	410322	18	3293	17	bomsucessense do sul	196
3238	Braganey	410335	18	5735	17	braganense	343
3239	Brasilândia Do Sul	410337	18	3209	11	brasilandiense	291
3241	Cafelândia	410345	18	14662	54	cafelandense	272
3243	Califórnia	410350	18	8069	57	californiano	142
3245	Cambé	410370	18	96733	196	cambeense	495
3246	Cambira	410380	18	7236	44	cambirense	163
3248	Campina Do Simão	410395	18	4076	9	campineiro do simão 	448
3250	Campo Bonito	410405	18	4407	10	campo-bonitense	434
3252	Campo Largo	410420	18	112377	90	campo-larguense	1249
3253	Campo Magro	410425	18	24843	90	campomagrense	276
3255	Cândido De Abreu	410440	18	16655	11	cândido-abreuense	1510
3257	Cantagalo	410445	18	12952	22	cantagalense	584
3258	Capanema	410450	18	18526	44	capanemense	419
3260	Carambeí	410465	18	19163	30	carambiense	650
3262	Cascavel	410480	18	286205	136	cascavelense	2101
3263	Castro	410490	18	67084	27	castrense	2532
3265	Centenário Do Sul	410510	18	11190	30	centenariense	372
3267	Céu Azul	410530	18	11032	9	céu-azulense	1179
3269	Cianorte	410550	18	69958	86	cianortense	812
3271	Clevelândia	410570	18	17240	24	clevelandense	705
3272	Colombo	410580	18	212967	1	colombense	197
5419	Vera Cruz	355660	26	10769	43	vera-cruzense	248
3276	Contenda	410620	18	15891	53	contendense	299
3278	Cornélio Procópio	410640	18	46928	74	procopense	635
3280	Coronel Vivida	410650	18	21749	32	coronel-vividense	684
3281	Corumbataí Do Sul	410655	18	4002	24	corumbataiense	164
3283	Cruzeiro Do Iguaçu	410657	18	4278	26	cruzeirense	162
3285	Cruzeiro Do Sul	410670	18	4563	18	cruzeirense-do-sul	259
3286	Cruzmaltina	410685	18	3162	10	cruzmaltinense	312
3288	Curiúva	410700	18	13923	24	curiuvense	576
3290	Diamante Do Norte	410710	18	5516	23	diamantense 	243
3292	Dois Vizinhos	410720	18	36179	86	dois-vizinhense	419
3293	Douradina	410725	18	7445	18	douradinense	420
3295	Doutor Ulysses	412863	18	5727	7	ulyssense	781
3297	Engenheiro Beltrão	410750	18	13906	30	engenheiro-beltrense	467
3298	Entre Rios Do Oeste	410753	18	3926	32	entreriense	122
3300	Espigão Alto Do Iguaçu	410754	18	4677	14	espigãoense	326
3302	Faxinal	410760	18	16314	23	faxinalense	716
3304	Fênix	410770	18	4802	21	fenexense	234
3305	Fernandes Pinheiro	410773	18	5932	15	fernandespinheirense	407
3307	Flor Da Serra Do Sul	410785	18	4726	20	sulflorense	239
3309	Floresta	410790	18	5931	37	florestense 	158
3311	Flórida	410810	18	2543	31	floridense	83
3313	Foz Do Iguaçu	410830	18	256088	415	iguaçuense	618
3314	Foz Do Jordão	410845	18	5420	23	foz jordanense 	235
3316	Francisco Beltrão	410840	18	78943	107	francisco-beltrense	735
3318	Godoy Moreira	410855	18	3337	25	godoense	131
3319	Goioerê	410860	18	29018	51	goio-erense	564
3321	Grandes Rios	410870	18	6625	21	grande-riense	314
3323	Guairaçá	410890	18	6197	13	guairaçaense	494
3325	Guapirama	410900	18	3891	21	guapiramense	189
3326	Guaporema	410910	18	2219	11	guaporemense	200
3328	Guaraniaçu	410930	18	14582	12	guaraniaçuano 	1226
3330	Guaraqueçaba	410950	18	7871	4	guaraqueçabano	2020
3332	Honório Serpa	410965	18	5955	12	honório serpense	502
3334	Ibema	410975	18	6066	42	ibemense	145
3335	Ibiporã	410980	18	48198	162	ibiporanense	298
3337	Iguaraçu	411000	18	3982	24	iguaraçuense	165
3339	Imbaú	411007	18	11274	34	imbauense	331
3341	Inácio Martins	411020	18	10943	12	inácio-martinense 	937
3343	Indianópolis	411040	18	4299	35	indianopolitano	123
3344	Ipiranga	411050	18	14150	15	ipiranguense	927
3346	Iracema Do Oeste	411065	18	2578	32	iracemense	82
3348	Iretama	411080	18	10622	19	iretamense	570
3350	Itaipulândia	411095	18	9026	27	itaipulandiense	331
3352	Itambé	411110	18	5979	25	itambenense	244
3354	Itaperuçu	411125	18	23887	76	itaperuçuense	314
3355	Itaúna Do Sul	411130	18	3583	28	itaunense	129
3357	Ivaiporã	411150	18	31816	74	ivaiporãnense	432
3359	Ivatuba	411160	18	3010	31	ivatubense	97
3360	Jaboti	411170	18	4902	35	jabotiense	139
3362	Jaguapitã	411190	18	12225	26	jaguapitãense 	475
3364	Jandaia Do Sul	411210	18	20269	108	jandaiense-do-sul 	188
3366	Japira	411230	18	4903	26	japirense	188
3368	Jardim Alegre	411250	18	12324	30	jardim-alegrense 	405
3370	Jataizinho	411270	18	11875	75	jatainhense 	159
3371	Jesuítas	411275	18	9001	36	jesuitense	247
3373	Jundiaí Do Sul	411290	18	3433	11	jundiaiense-do-sul 	321
3375	Jussara	411300	18	6610	31	jussarense	211
3376	Kaloré	411310	18	4506	23	kaloreense	193
3378	Laranjal	411325	18	6360	11	laranjaense	559
3380	Leópolis	411340	18	4145	12	leopolense	345
3382	Lindoeste	411345	18	5361	15	lindo-estense	361
3383	Loanda	411350	18	21201	29	loandense	722
3385	Londrina	411370	18	506701	306	londrinense	1653
3387	Lunardelli	411375	18	5160	26	lunardelliense	199
3389	Mallet	411390	18	12973	18	malletense	723
3390	Mamborê	411400	18	13961	18	mamborense	788
3392	Mandaguari	411420	18	32658	97	mandaguariense	336
3394	Manfrinópolis	411435	18	3127	14	manfrinopolitano	216
3396	Manoel Ribas	411450	18	13169	23	manoel-ribense	571
3398	Maria Helena	411470	18	5956	12	maria-helenense	486
3399	Marialva	411480	18	31959	67	marialvense	476
3401	Marilena	411500	18	6858	30	marilenense	232
5556	Sucupira	172085	27	1742	2	sucupirense	1026
3404	Mariópolis	411530	18	6268	27	mariopolitano 	231
3406	Marmeleiro	411540	18	13900	36	marmeleirense	388
3408	Marumbi	411550	18	4603	22	marumbiense	208
3409	Matelândia	411560	18	16078	25	matelandiense	640
3411	Mato Rico	411573	18	3818	10	mato-riquense	395
3413	Medianeira	411580	18	41817	127	medianeirense	329
3415	Mirador	411590	18	2327	11	miradorense	222
3416	Miraselva	411600	18	1862	21	miraselvano 	90
3418	Moreira Sales	411610	18	12606	36	moreira-salense 	354
3420	Munhoz De Melo	411630	18	3672	27	munhozense	137
3422	Nova Aliança Do Ivaí	411650	18	1431	11	ivaiense	131
3424	Nova Aurora	411670	18	11866	25	nova-aurorense 	474
3425	Nova Cantu	411680	18	7425	13	nova-cantuense	555
3427	Nova Esperança Do Sudoeste	411695	18	5098	24	novaesperancense	208
3429	Nova Laranjeiras	411705	18	11241	10	nova laranjeirense	1145
3431	Nova Olímpia	411720	18	5503	40	olimpiense	136
3432	Nova Prata Do Iguaçu	411725	18	10377	29	pratense	353
3434	Nova Santa Rosa	411722	18	7626	37	nova-santa-rosense  	205
3435	Nova Tebas	411727	18	7398	14	nova-tebense	546
3437	Ortigueira	411730	18	23380	10	ortigueirense	2430
3439	Ouro Verde Do Oeste	411745	18	5692	19	ouro-verdense	293
3441	Palmas	411760	18	42888	27	palmense	1567
3442	Palmeira	411770	18	32123	22	palmeirense	1457
3444	Palotina	411790	18	28683	44	palotinense	651
3446	Paranacity	411810	18	10250	29	paranacitense	349
3448	Paranapoema	411830	18	2791	16	paranapoemense	176
3449	Paranavaí	411840	18	81590	68	paranavaiense	1202
3451	Pato Branco	411850	18	72370	134	pato-branquense	539
3453	Paulo Frontin	411870	18	6913	19	frontinense 	369
3455	Perobal	411885	18	5653	14	perobalense	408
3456	Pérola	411890	18	10208	42	perolense	241
3458	Piên	411910	18	11236	44	pienense	255
3460	Pinhal De São Bento	411925	18	2625	27	pinhalense	97
3462	Pinhão	411930	18	30208	15	pinhãoense	2002
3463	Piraí Do Sul	411940	18	23424	17	piraiense	1403
3465	Pitanga	411960	18	32638	20	pitanguense	1664
3467	Planaltina Do Paraná	411970	18	4095	12	planaltinense	356
3469	Ponta Grossa	411990	18	311611	151	ponta-grossense	2068
3470	Pontal Do Paraná	411995	18	20920	105	pontalense	200
3472	Porto Amazonas	412010	18	4514	24	porto-amazonense	187
3474	Porto Rico	412020	18	2530	12	porto-riquense 	218
3476	Prado Ferreira	412033	18	3434	22	prado ferreirense	153
3477	Pranchita	412035	18	5628	25	pranchitano	226
3479	Primeiro De Maio	412050	18	10832	26	primaiense	414
3481	Quarto Centenário	412065	18	4856	15	quarto centenariense	322
3483	Quatro Barras	412080	18	19851	110	quatro-barrense 	181
3485	Quedas Do Iguaçu	412090	18	30605	37	quedas-iguaçuense-	822
3486	Querência Do Norte	412100	18	11729	13	querenciano	915
3488	Quitandinha	412120	18	17089	38	quitandinhense	447
3490	Rancho Alegre	412130	18	3955	24	alegrense	168
3492	Realeza	412140	18	16338	46	realezense	353
3493	Rebouças	412150	18	14176	29	reboucense	482
3495	Reserva	412170	18	25172	15	reservense	1635
3497	Ribeirão Claro	412180	18	10678	17	ribeirão-clarense	629
3499	Rio Azul	412200	18	14093	22	rio-azulense	630
3500	Rio Bom	412210	18	3334	19	rio-bonense	178
3502	Rio Branco Do Ivaí	412217	18	3898	10	riobranquense	382
3503	Rio Branco Do Sul	412220	18	30650	38	rio-branquense	812
3505	Rolândia	412240	18	57862	126	rolandense	460
3507	Rondon	412260	18	8996	16	rondonense	556
3509	Sabáudia	412270	18	6096	32	sabaudiense	190
3510	Salgado Filho	412280	18	4403	23	salgadense	189
3512	Salto Do Lontra	412300	18	13689	44	salto-lontrense 	313
3514	Santa Cecília Do Pavão	412320	18	3646	33	pavonense	110
3516	Santa Fé	412340	18	10432	38	santa-feense	276
3517	Santa Helena	412350	18	23413	31	santa-helenense	758
3519	Santa Isabel Do Ivaí	412370	18	8760	25	santa-isabelense 	349
3521	Santa Lúcia	412382	18	3925	34	santaluciense	117
3522	Santa Maria Do Oeste	412385	18	11500	14	santa-mariense	847
3524	Santa Mônica	412395	18	3571	14	moniquense	260
3526	Santa Terezinha De Itaipu	412405	18	20841	80	terezinhense	259
3529	Santo Antônio Do Caiuá	412420	18	2727	12	santo-antoniense	219
3530	Santo Antônio Do Paraíso	412430	18	2408	15	santo-antoniense	166
3532	Santo Inácio	412450	18	5269	17	santo-inaciense	307
3534	São Jerônimo Da Serra	412470	18	11337	14	jeronimense	824
3535	São João	412480	18	10599	27	são-joanense 	388
3537	São João Do Ivaí	412500	18	11525	33	são-joanense	353
3538	São João Do Triunfo	412510	18	13704	19	triunfense	720
3540	São Jorge Do Ivaí	412530	18	5517	18	são-jorgense 	315
3542	São José Da Boa Vista	412540	18	6511	16	boa-vistense	400
3543	São José Das Palmeiras	412545	18	3830	21	são-joseliense	182
3545	São Manoel Do Paraná	412555	18	2098	22	são manoelense	95
3546	São Mateus Do Sul	412560	18	41257	31	são-mateuense	1343
3548	São Pedro Do Iguaçu	412575	18	6491	21	São pedrense	308
3550	São Pedro Do Paraná	412590	18	2491	10	são-pedrense	251
3552	São Tomé	412610	18	5349	24	são-tomeense	219
3553	Sapopema	412620	18	6736	10	sapopemense	678
3555	Saudade Do Iguaçu	412627	18	5028	33	saudadense	152
3556	Sengés	412630	18	18414	13	sengeano	1437
3558	Sertaneja	412640	18	5817	13	sertanejano 	444
3560	Siqueira Campos	412660	18	18454	66	siqueirense	278
3561	Sulina	412665	18	3394	20	sulinense	171
3563	Tamboara	412670	18	4664	24	tamboarense	193
3565	Tapira	412690	18	5836	13	tapirense	434
3567	Telêmaco Borba	412710	18	69872	51	telêmaco-borbense 	1383
3568	Terra Boa	412720	18	15776	49	terra-bonense	321
3570	Terra Roxa	412740	18	16759	21	terra-roxense	801
3572	Tijucas Do Sul	412760	18	14537	22	tijucano-do-sul 	672
3574	Tomazina	412780	18	8791	15	tomazinense	591
3576	Tunas Do Paraná	412788	18	6256	9	tunense	668
3577	Tuneiras Do Oeste	412790	18	8695	12	tuneirense	699
3579	Turvo	412796	18	13811	15	turvense	916
3581	Umuarama	412810	18	100676	82	umuaramense	1233
3583	Uniflor	412830	18	2466	26	uniflorense	95
3584	Uraí	412840	18	11472	48	uraiense	238
3586	Vera Cruz Do Oeste	412855	18	8973	27	vera-cruzense	327
3588	Virmond	412865	18	3950	16	virmondense	243
3589	Vitorino	412870	18	6513	21	vitorinense	308
3591	Xambrê	412880	18	6012	17	xambrense	360
3593	Aperibé	330015	19	10213	108	aperibeense	95
3594	Araruama	330020	19	112008	176	araruamense	638
3596	Armação Dos Búzios	330023	19	27560	392	buziano	70
3598	Barra Do Piraí	330030	19	94778	164	barrense	579
3600	Belford Roxo	330045	19	469332	6	belford-roxense	78
3601	Bom Jardim	330050	19	25333	66	bom-jardinense	385
3603	Cabo Frio	330070	19	186227	454	cabo-friense	410
3605	Cambuci	330090	19	14827	26	cambuciense	562
3606	Campos Dos Goytacazes	330100	19	463731	115	campista	4027
3608	Carapebus	330093	19	13359	43	carapebuense	308
3610	Carmo	330120	19	17434	54	carmense	322
3611	Casimiro De Abreu	330130	19	35347	77	casimirense	461
3613	Conceição De Macabu	330140	19	21211	61	macabuense	347
3615	Duas Barras	330160	19	10930	29	bibarrense	375
3617	Engenheiro Paulo De Frontin	330180	19	13237	100	fronteense	133
3618	Guapimirim	330185	19	51483	143	guapimiriense	361
3620	Itaboraí	330190	19	218008	507	itaboraiense	430
3621	Itaguaí	330200	19	109091	395	itaguaiense	276
3623	Itaocara	330210	19	22899	53	itaocarense	431
3625	Itatiaia	330225	19	28783	117	itatiaiense	245
3627	Laje Do Muriaé	330230	19	7487	30	lajense	250
3628	Macaé	330240	19	206728	170	macaense	1217
3630	Magé	330250	19	227322	585	mageense	388
3632	Maricá	330270	19	127461	352	maricaense	363
3634	Mesquita	330285	19	168376	4	mesquitnese	39
3636	Miracema	330300	19	26843	88	miracemense	305
3637	Natividade	330310	19	15082	39	natividadense	387
3639	Niterói	330330	19	487562	4	niteroiense	134
3641	Nova Iguaçu	330350	19	796257	2	iguaçuano	521
3642	Paracambi	330360	19	47124	262	paracambiense	180
3644	Parati	330380	19	37533	41	paratiense	925
3646	Petrópolis	330390	19	295917	372	petropolitano	796
3648	Piraí	330400	19	26314	52	piraiense	505
3649	Porciúncula	330410	19	17760	59	porciunculense	302
3653	Quissamã	330415	19	20242	28	quissamaense	713
3655	Rio Bonito	330430	19	55551	122	rio-bonitense	456
3657	Rio Das Flores	330450	19	8561	18	rio-florense 	478
3659	Rio De Janeiro	330455	19	6320446	5	carioca	1200
3660	Santa Maria Madalena	330460	19	10321	13	madalenense	815
3662	São Fidélis	330480	19	37543	36	fidelense	1032
3664	São Gonçalo	330490	19	999728	4	gonçalense	248
3665	São João Da Barra	330500	19	32747	72	são-joanense	455
3667	São José De Ubá	330513	19	7003	28	ubaense	250
3668	São José Do Vale Do Rio Preto	330515	19	20251	92	rio-pretano	220
3670	São Sebastião Do Alto	330530	19	8895	22	altense	398
3671	Sapucaia	330540	19	17525	32	sapucaiense	541
3673	Seropédica	330555	19	78186	276	seropediquense	284
3675	Sumidouro	330570	19	14900	38	sumidourense	396
3676	Tanguá	330575	19	30732	211	tanguaense	146
3678	Trajano De Moraes	330590	19	10289	17	trajanense	590
3680	Valença	330610	19	71843	55	valenciano	1305
3681	Varre Sai	330615	19	9475	50	varresaiense	190
3684	Acari	240010	20	11035	18	acariense	609
3685	Açu	240020	20	53227	41	açuense	1303
3687	Água Nova	240040	20	2980	59	água-novense	51
3688	Alexandria	240050	20	13507	35	alexandrinense	381
3690	Alto Do Rodrigues	240070	20	12305	64	alto-rodriguense	191
3692	Antônio Martins	240090	20	6907	28	antônio-martinense	245
3694	Areia Branca	240110	20	25315	71	areia-branquense	358
3696	Augusto Severo	240130	20	9289	10	augusto-severense	897
3698	Baraúna	240145	20	24182	29	baraunense	826
3699	Barcelona	240150	20	3950	26	barcelonense	153
3701	Bodó	240165	20	2425	10	bodoense	254
3703	Brejinho	240180	20	11577	188	brejinense	62
3705	Caiçara Do Rio Do Vento	240190	20	3308	13	caiçarense-do-rio-do-vento	261
3706	Caicó	240200	20	62709	51	caicoense	1229
3708	Canguaretama	240220	20	30916	126	canguaretamense	245
3710	Carnaúba Dos Dantas	240240	20	7429	30	carnaubense	246
3712	Ceará Mirim	240260	20	68141	94	ceará-miriense	724
3713	Cerro Corá	240270	20	10916	28	cerro-coraense	394
3715	Coronel João Pessoa	240290	20	4772	41	pessoense	117
3717	Currais Novos	240310	20	42652	49	currais-novense	864
3719	Encanto	240330	20	5231	42	encantense	126
3720	Equador	240340	20	5822	22	equatoriano	265
3722	Extremoz	240360	20	24569	176	extremozense	140
3724	Fernando Pedroza	240375	20	2854	9	fernando-pedrozense	323
3726	Francisco Dantas	240390	20	2874	16	francisco-dantense	182
3728	Galinhos	240410	20	2159	6	galinhense	342
3729	Goianinha	240420	20	22481	117	goianiense	192
3731	Grossos	240440	20	9393	74	grossense	126
3732	Guamaré	240450	20	12404	48	guamareense	259
3734	Ipanguaçu	240470	20	13856	37	ipanguaçuense	374
3736	Itajá	240485	20	6932	34	itajaense	204
3738	Jaçanã	240500	20	7925	145	jaçanãense	55
3739	Jandaíra	240510	20	6801	16	jandairense	436
3741	Januário Cicco	240530	20	9011	48	januarense	187
3743	Jardim De Angicos	240550	20	2607	10	jardim-angicanense	254
3745	Jardim Do Seridó	240570	20	12113	33	jardinense	369
3747	João Dias	240590	20	2601	30	joão-diense	88
3748	José Da Penha	240600	20	5868	50	josé-penhense	118
3750	Jundiá	240615	20	3582	80	\N	45
3752	Lagoa De Pedras	240630	20	6989	59	lagoa-dantense	118
3753	Lagoa De Velhos	240640	20	2668	24	lagoa-pedrense	113
3755	Lagoa Salgada	240660	20	7564	95	lagoa-salgadense	79
3757	Lajes Pintadas	240680	20	4612	35	lajes-pintadense	130
3759	Luís Gomes	240700	20	9610	58	luís-gomense	167
3761	Macau	240720	20	28954	37	macauense	788
3762	Major Sales	240725	20	3536	111	major-salense	32
3764	Martins	240740	20	8218	48	martinense	169
3766	Messias Targino	240760	20	4188	31	messias-targinense	135
3768	Monte Alegre	240780	20	20685	98	monte-alegrense	211
3770	Mossoró	240800	20	259815	124	mossoroense	2099
3771	Natal	240810	20	803739	5	natalense	167
3773	Nova Cruz	240830	20	35490	128	nova-cruzense	278
3775	Ouro Branco	240850	20	4699	19	ouro-branquense	253
3776	Paraná	240860	20	3952	49	paranaense	81
3779	Parelhas	240890	20	20354	40	parelhense	513
3781	Passa E Fica	240910	20	11100	263	passa-fiquense	42
3783	Patu	240930	20	11964	37	patuense	319
3785	Pedra Grande	240950	20	3521	16	pedra-grandense	221
3786	Pedra Preta	240960	20	2590	9	pedra-pretense	295
3788	Pedro Velho	240980	20	14114	73	pedro-velhense	193
3789	Pendências	240990	20	13432	32	pendenciano 	419
3792	Portalegre	241020	20	7320	67	portalegrense	110
3793	Porto Do Mangue	241025	20	5217	16	porto-manguense	319
3795	Pureza	241040	20	8424	17	purezense	504
3796	Rafael Fernandes	241050	20	4692	60	rafael-fernandense	78
3798	Riacho Da Cruz	241070	20	3165	25	riacho-cruzense	127
3800	Riachuelo	241090	20	7067	27	riachuelense	263
3801	Rio Do Fogo	240895	20	10059	67	rio-foguense	150
3803	Ruy Barbosa	241110	20	3595	29	rui-barbosense	126
3805	Santa Maria	240933	20	4762	22	santa-mariense	220
3807	Santana Do Seridó	241142	20	2526	13	santanense	188
3809	São Bento Do Norte	241160	20	2975	10	são-bento-nortense	289
3810	São Bento Do Trairí	241170	20	3905	20	trairiense	191
3812	São Francisco Do Oeste	241190	20	3874	51	oestense	76
3814	São João Do Sabugi	241210	20	5922	21	sabugiense	277
3815	São José De Mipibu	241220	20	39776	137	mipibuense	290
3817	São José Do Seridó	241240	20	4231	24	são-josé-seridoense 	175
3819	São Miguel Do  Gostoso	241255	20	8670	25	micaelense de touros	342
3821	São Pedro	241270	20	6235	32	são-pedrense	195
3822	São Rafael	241280	20	8111	17	são-rafaelense 	469
3824	São Vicente	241300	20	6028	30	são-vicentense 	198
3826	Senador Georgino Avelino	241320	20	3924	151	georginense	26
3827	Serra De São Bento	241330	20	5743	59	serra-bentense 	97
3829	Serra Negra Do Norte	241340	20	7770	14	serra-negrense-do-norte	562
3831	Serrinha Dos Pintos	241355	20	4540	37	serriense dos pintos	123
3833	Sítio Novo	241370	20	5020	24	sítio-novense	213
3834	Taboleiro Grande	241380	20	2317	19	taboleirense	124
3836	Tangará	241400	20	14175	40	tangarense	357
3838	Tenente Laurentino Cruz	241415	20	5406	73	tenente-laurentinense	74
3840	Tibau Do Sul	241420	20	11385	112	tibauense	102
3842	Touros	241440	20	31089	37	tourense	840
3843	Triunfo Potiguar	241445	20	3368	13	triunfense potiguar	269
3845	Upanema	241460	20	12992	15	upanemense	874
3847	Venha Ver	241475	20	3821	53	venha-verense	72
3848	Vera Cruz	241480	20	10719	128	vera-cruzense	83
3850	Vila Flor	241500	20	2872	60	vila-florense	48
3852	Alto Alegre Dos Parecis	110037	21	12816	3	alto-alegrense	3958
3854	Alvorada D`Oeste	110034	21	16853	6	alvoradense	3029
3855	Ariquemes	110002	21	90353	20	ariquemense	4427
3857	Cabixi	110003	21	6313	5	cabixiense	1314
3859	Cacoal	110004	21	78574	21	cacoaense	3793
3861	Candeias Do Jamari	110080	21	19779	3	candeiense	6844
3862	Castanheiras	110090	21	3575	4	castanheirense	893
3864	Chupinguaia	110092	21	8301	2	chupinguaiense	5127
3866	Corumbiara	110007	21	8783	3	corumbiarense	3060
3867	Costa Marques	110008	21	13678	3	costa-marquense	4987
3869	Espigão D`Oeste	110009	21	28729	6	espigãoense	4518
3871	Guajará Mirim	110010	21	41656	2	guajará-mirense 	24856
3872	Itapuã Do Oeste	110110	21	8566	2	jamariense	4082
3874	Ji Paraná	110012	21	116610	17	ji-paranaense	6897
3876	Ministro Andreazza	110120	21	10352	13	andreazense	798
3878	Monte Negro	110140	21	14091	7	monte-negrino	1931
3879	Nova Brasilândia D`Oeste	110014	21	19874	17	brasilandense	1155
3881	Nova União	110143	21	7493	9	nova-uniense	807
3883	Ouro Preto Do Oeste	110015	21	37928	19	ouro-pretense	1970
3884	Parecis	110145	21	4810	2	parecisense	2549
3886	Pimenteiras Do Oeste	110146	21	2315	0	pimenteirense	6015
3888	Presidente Médici	110025	21	22319	13	mediciense	1758
3890	Rio Crespo	110026	21	3316	2	rio-crespense	1718
3891	Rolim De Moura	110028	21	50648	35	rolimorense	1458
3893	São Felipe D`Oeste	110148	21	6018	11	são-felipense	542
3895	São Miguel Do Guaporé	110032	21	21828	3	miguelense	8008
3896	Seringueiras	110150	21	11629	3	seringueinense	3774
3898	Theobroma	110160	21	10649	5	theobromense	2197
3899	Urupá	110170	21	12974	16	urupaense	832
5422	Vista Alegre Do Alto	355690	26	6886	73	vista-alegrense	95
3902	Vilhena	110030	21	76202	7	vilhenense	11519
3903	Alto Alegre	140005	22	16448	1	alto-alegrense	25567
3905	Boa Vista	140010	22	284313	50	boa-vistense	5687
3907	Cantá	140017	22	13902	2	cantaense	7665
3909	Caroebe	140023	22	8114	1	caroebense	12066
3911	Mucajaí	140030	22	14792	1	mucajaiense	12461
3912	Normandia	140040	22	8940	1	normandiense	6967
3914	Rorainópolis	140047	22	24279	1	rorainopolitano	33594
3916	São Luiz	140060	22	6750	4	são-luizense	1527
3917	Uiramutã	140070	22	8375	1	uiramutansense	8066
3919	Água Santa	430005	23	3722	13	água-santense	292
3921	Ajuricaba	430020	23	7255	22	ajuricabense	323
3923	Alegrete	430040	23	77653	10	alegretense	7804
3925	Almirante Tamandaré Do Sul	430047	23	2067	8	tamandarense                        	265
3927	Alto Alegre	430055	23	1848	16	alto-alegrense	114
3929	Alvorada	430060	23	195673	3	alvoradense	71
3930	Amaral Ferrador	430063	23	6353	13	amaralense	506
3932	André Da Rocha	430066	23	1216	4	andré-rochense	324
3934	Antônio Prado	430080	23	12833	37	pradense	348
3936	Araricá	430087	23	4864	138	arariquense	35
3937	Aratiba	430090	23	6565	19	aratibense	341
3939	Arroio Do Padre	430107	23	2730	22	arroio padrense	124
3941	Arroio Do Tigre	430120	23	12648	40	tigrense	318
3942	Arroio Dos Ratos	430110	23	13606	32	ratense	426
3944	Arvorezinha	430140	23	10225	38	arvorezinhense	272
3946	Áurea	430155	23	3665	23	aurense	158
3947	Bagé	430160	23	116794	29	bageense	4096
3949	Barão	430165	23	5741	46	baronense	124
3951	Barão Do Triunfo	430175	23	7018	16	baronense	436
3953	Barra Do Quaraí	430187	23	4012	4	barrense	1056
3954	Barra Do Ribeiro	430190	23	12572	17	barrense	729
3956	Barra Funda	430195	23	2367	39	barra-fundense	60
3957	Barracão	430180	23	5357	10	barraconense	516
3959	Benjamin Constant Do Sul	430205	23	2307	17	benjaminense	132
3961	Boa Vista Das Missões	430215	23	2114	11	boa-vistense 	195
3963	Boa Vista Do Cadeado	430222	23	2441	3	cadeadense	701
3964	Boa Vista Do Incra	430223	23	2425	5	boa vistense do incra	503
3966	Bom Jesus	430230	23	11519	4	bom-jesuense	2626
3968	Bom Progresso	430237	23	2328	26	bom-progressense	89
3969	Bom Retiro Do Sul	430240	23	11472	112	bom-retirense	102
3971	Bossoroca	430250	23	6884	4	bossoroquense	1611
3973	Braga	430260	23	3702	29	braguense	129
3974	Brochier	430265	23	4675	44	brochiense	107
3976	Caçapava Do Sul	430280	23	33690	11	caçapavano	3047
3978	Cachoeira Do Sul	430300	23	83827	22	cachoeirense	3735
3980	Cacique Doble	430320	23	4868	24	caciquense	204
3981	Caibaté	430330	23	4954	19	caibateense	260
3983	Camaquã	430350	23	62764	37	camaquense	1679
3985	Cambará Do Sul	430360	23	6542	5	cambaraense	1213
3987	Campina Das Missões	430370	23	6117	27	campinense	226
3989	Campo Bom	430390	23	60074	993	campo-bonense	61
3990	Campo Novo	430400	23	5459	25	campo-novense	222
3992	Candelária	430420	23	30171	32	candelariense	944
3994	Candiota	430435	23	8771	9	candiotense	934
3995	Canela	430440	23	39229	155	canelense	254
3997	Canoas	430460	23	323827	2	canoense	131
3999	Capão Bonito Do Sul	430462	23	1754	3	capão bonitense	527
4001	Capão Do Cipó	430465	23	3104	3	cipoense	1009
4002	Capão Do Leão	430466	23	24298	31	leonense	785
4004	Capitão	430469	23	2636	36	capitanense	74
4006	Caraá	430471	23	7312	25	caraense	294
4007	Carazinho	430470	23	59317	89	carazinhense	665
4009	Carlos Gomes	430485	23	1607	19	carlos-gomense	83
4011	Caseiros	430495	23	3007	13	caseirense	236
4012	Catuípe	430500	23	9323	16	catuipano	583
4014	Centenário	430511	23	2965	22	centenariense	134
4016	Cerro Branco	430513	23	4454	28	cerro-branquense	159
4018	Cerro Grande Do Sul	430517	23	10268	32	sul-cerro-grandense	325
4020	Chapada	430530	23	9377	14	chapadense	684
4021	Charqueadas	430535	23	35320	163	charqueadense	217
4023	Chiapetta	430540	23	4044	10	chiapetense	397
4025	Chuvisca	430544	23	4944	22	chuvisquense	220
4028	Colinas	430558	23	2420	41	colinense	58
4030	Condor	430570	23	6552	14	condorense	465
4032	Coqueiro Baixo	430583	23	1528	14	coqueirense	112
4034	Coronel Barros	430587	23	2459	15	coronel-barrense	163
4036	Coronel Pilar	430593	23	1725	16	coronel pilarense	105
4037	Cotiporã	430595	23	3917	23	cotiporanense	172
4039	Crissiumal	430600	23	14084	39	crissiumalense	362
4041	Cristal Do Sul	430607	23	2826	29	cristalense	98
4043	Cruzaltense	430613	23	2141	13	cruzaltino	167
4045	David Canabarro	430630	23	4683	27	canabarrense	175
4046	Derrubadas	430632	23	3190	9	derrubadense	361
4048	Dilermando De Aguiar	430637	23	3064	5	dilermandense	601
4050	Dois Irmãos Das Missões	430642	23	2157	10	dois-irmãozense	226
4051	Dois Lajeados	430645	23	3278	25	dois-lajeense	133
4053	Dom Pedrito	430660	23	38898	7	pedritense	5192
4055	Dona Francisca	430670	23	3401	30	francisquense	114
4056	Doutor Maurício Cardoso	430673	23	5313	21	mauriciense	253
4058	Eldorado Do Sul	430676	23	34343	67	eldoradense	510
4059	Encantado	430680	23	20510	147	encantadense	139
4061	Engenho Velho	430692	23	1527	21	engenho-velhense	71
4063	Entre Ijuís	430693	23	8938	16	entre-ijuiense	553
4065	Erechim	430700	23	96087	223	erechinense	431
4066	Ernestina	430705	23	3088	13	ernestinense	239
4068	Erval Seco	430730	23	7878	22	erval-sequense	364
4070	Esperança Do Sul	430745	23	3272	22	esperançulense	148
4072	Estação	430755	23	6011	60	estacionense	100
4074	Esteio	430770	23	80755	3	esteiense	28
4075	Estrela	430780	23	30619	166	estrelense	184
4077	Eugênio De Castro	430783	23	2798	7	eugenio-castrense	419
4079	Farroupilha	430790	23	63635	177	farroupilhense	360
4080	Faxinal Do Soturno	430800	23	6672	39	soturnense	170
4082	Fazenda Vilanova	430807	23	3697	44	vilanovense	85
4084	Flores Da Cunha	430820	23	27126	99	florense	273
4086	Fontoura Xavier	430830	23	10719	18	fontourense	583
4087	Formigueiro	430840	23	7014	12	formigueirense	582
4089	Fortaleza Dos Valos	430845	23	4575	7	fortalezense	650
4091	Garibaldi	430860	23	30689	181	garibaldense	169
4092	Garruchos	430865	23	3234	4	garruchense	800
4094	General Câmara	430880	23	8447	17	camaraense	510
4096	Getúlio Vargas	430890	23	16154	56	getuliense	287
4098	Glorinha	430905	23	6891	21	glorinhense	324
4099	Gramado	430910	23	32273	136	gramadense	238
4101	Gramado Xavier	430915	23	3970	18	gramado-xavierense	218
4103	Guabiju	430925	23	1598	11	guabijuense	148
4105	Guaporé	430940	23	22814	77	guaporense	298
4107	Harmonia	430955	23	4254	95	harmoniense	45
4108	Herval	430710	23	6753	4	hervalense	1758
4110	Horizontina	430960	23	18348	79	horizontinense	232
4111	Hulha Negra	430965	23	6043	7	hulha-negrense	823
4113	Ibarama	430975	23	4371	23	ibaramense	193
4115	Ibiraiaras	430990	23	7171	24	ibiraiense	301
4117	Ibirubá	431000	23	19310	32	ibirubense	607
4119	Ijuí	431020	23	78915	115	ijuiense	689
4120	Ilópolis	431030	23	4102	35	ilopolitano	116
4122	Imigrante	431036	23	3023	41	imigrantense	73
4124	Inhacorá	431041	23	2267	20	inhacorense	114
4125	Ipê	431043	23	6016	10	ipeense	599
4127	Iraí	431050	23	8078	44	iraiense	182
4129	Itacurubi	431055	23	3441	3	itacurubiense	1121
4131	Itaqui	431060	23	38159	11	itaquiense	3404
4132	Itati	431065	23	2584	12	itatiense  	207
4134	Ivorá	431075	23	2156	18	ivorense	123
4136	Jaboticaba	431085	23	4098	32	jaboticabense	128
4138	Jacutinga	431090	23	3633	20	jacutinguense	179
4139	Jaguarão	431100	23	27931	14	jaguarense	2054
4141	Jaquirana	431112	23	4177	5	jaquiranense	908
4143	Jóia	431115	23	8331	7	joiense	1236
4145	Lagoa Bonita Do Sul	431123	23	2662	25	lagobonitense	108
4147	Lagoa Vermelha	431130	23	27525	22	lagoense	1264
4148	Lagoão	431125	23	6185	16	lagoense	384
4150	Lajeado Do Bugre	431142	23	2487	37	lajeado-bugrense	68
4152	Liberato Salzano	431160	23	5780	24	salzanense	246
4153	Lindolfo Collor	431162	23	5227	158	lindolfo-collorense	33
5424	Votorantim	355700	26	108809	592	votorantinense	184
4156	Machadinho	431170	23	5510	16	machadinhense	334
4158	Manoel Viana	431175	23	7072	5	vianense	1391
4160	Maratá	431179	23	2527	31	marataense	81
4161	Marau	431180	23	36364	56	marauense	649
4163	Mariana Pimentel	431198	23	3768	11	marianense	338
4165	Marques De Souza	431205	23	4068	33	marquesouzense	125
4166	Mata	431210	23	5111	16	matense	312
4168	Mato Leitão	431215	23	3865	84	mato-leitoense	46
4170	Maximiliano De Almeida	431220	23	4911	24	almeidense	209
4171	Minas Do Leão	431225	23	7631	18	leonense	424
4173	Montauri	431235	23	1542	19	montauriense	82
4175	Monte Belo Do Sul	431238	23	2670	39	monte-belense	68
4176	Montenegro	431240	23	59415	140	montenegrino	424
4178	Morrinhos Do Sul	431244	23	3182	19	morrinhense	165
4180	Morro Reuter	431247	23	5676	65	morroreutense	88
4182	Muçum	431260	23	4791	43	muçuense	111
4184	Muliterno	431262	23	1813	16	muliternense	111
4185	Não Me Toque	431265	23	15936	44	não-me-toquense	362
4187	Nonoai	431270	23	12074	26	nonoaiense	469
4189	Nova Araçá	431280	23	4001	54	araçaense	74
4190	Nova Bassano	431290	23	8840	42	bassanense	212
4192	Nova Bréscia	431300	23	3184	31	bresciense	103
4194	Nova Esperança Do Sul	431303	23	4671	24	nova-esperancense	191
4195	Nova Hartz	431306	23	18346	293	nova-hartense	63
4197	Nova Palma	431310	23	6342	20	nova-palmense	314
4199	Nova Prata	431330	23	22830	88	nova-pratense	259
4201	Nova Roma Do Sul	431335	23	3343	22	nova-romense	149
4203	Novo Barreiro	431349	23	3978	32	novo-barreirense	124
4204	Novo Cabrais	431339	23	3855	20	cabraisense	192
4206	Novo Machado	431342	23	3925	18	novo-machadense	219
4208	Novo Xingu	431346	23	1757	22	xinguense	81
4209	Osório	431350	23	40906	62	osoriense	664
4211	Palmares Do Sul	431365	23	10969	12	palmarense	949
4213	Palmitinho	431380	23	6920	48	palmitense	144
4214	Panambi	431390	23	38058	78	panambiense	491
4216	Paraí	431400	23	6812	57	paraiense	120
4218	Pareci Novo	431403	23	3511	61	pareciense	57
4219	Parobé	431405	23	51502	474	parobeense	109
4222	Passo Fundo	431410	23	184826	236	passo-fundense	783
4223	Paulo Bento	431413	23	2196	15	paulobentense	148
4225	Pedras Altas	431417	23	2212	2	pedras altense	1377
4227	Pejuçara	431430	23	3973	10	pejuçarense	414
4228	Pelotas	431440	23	328275	204	pelotense	1610
4230	Pinhal	431445	23	2513	37	pinhalense	68
4232	Pinhal Grande	431447	23	4471	9	pinhal-grandense	477
4233	Pinheirinho Do Vale	431449	23	4497	43	pinheirinhense	105
4235	Pirapó	431455	23	2757	9	pirapoense	292
4237	Planalto	431470	23	10524	46	planaltense	230
4239	Pontão	431477	23	3857	8	pontanense	506
4240	Ponte Preta	431478	23	1750	18	ponte-pretense	100
4242	Porto Alegre	431490	23	1409351	3	porto-alegrense	497
4244	Porto Mauá	431505	23	2542	24	porto-mauense	106
4246	Porto Xavier	431510	23	10558	38	porto-xavierense	281
4247	Pouso Novo	431513	23	1875	18	pouso-novense	107
4249	Progresso	431515	23	6163	24	progressense	256
4251	Putinga	431520	23	4141	20	putinguense	205
4252	Quaraí	431530	23	23021	7	quaraiense	3148
4254	Quevedos	431532	23	2710	5	quevedense	543
4256	Redentora	431540	23	10222	34	redentorense	303
4257	Relvado	431545	23	2155	17	relvadense	123
4259	Rio Dos Índios	431555	23	3616	15	riodinhense	237
4261	Rio Pardo	431570	23	37591	18	rio-pardense	2051
4263	Roca Sales	431580	23	10284	49	roca-salense	209
4264	Rodeio Bonito	431590	23	5743	69	rodeiense	83
4266	Rolante	431600	23	19485	66	rolantense	296
4268	Rondinha	431620	23	5518	22	rondinhense	252
4270	Rosário Do Sul	431640	23	39707	9	rosariense	4370
4271	Sagrada Família	431642	23	2595	33	sagradense	78
4273	Salto Do Jacuí	431645	23	11880	23	salto-jacuiense	507
4275	Salvador Do Sul	431650	23	6747	68	salvadorense	100
4276	Sananduva	431660	23	15373	30	sananduvense	505
4278	Santa Cecília Do Sul	431673	23	1655	8	ceciliense	199
4282	Santa Maria	431690	23	261031	146	santa-mariense	1788
4284	Santa Rosa	431720	23	68587	140	santa-rosense	490
4285	Santa Tereza	431725	23	1720	24	santa-teresense	72
4287	Santana Da Boa Vista	431700	23	8242	6	santanense-da-boa-vista	1421
4289	Santiago	431740	23	49071	20	santiaguense	2413
4290	Santo Ângelo	431750	23	76275	112	santo-angelense ou angelopolitano	681
4292	Santo Antônio Das Missões	431770	23	11210	7	santo-antoniense	1711
4294	Santo Antônio Do Planalto	431775	23	1987	10	santo-antoniense	203
4296	Santo Cristo	431790	23	14378	39	santo-cristense	367
4297	Santo Expedito Do Sul	431795	23	2461	20	expeditense	126
4299	São Domingos Do Sul	431805	23	2926	37	são-dominguense	79
4301	São Francisco De Paula	431820	23	20537	6	serrano	3274
4302	São Gabriel	431830	23	60425	12	gabrielense	5024
4304	São João Da Urtiga	431842	23	4726	28	urtiguense	171
4306	São Jorge	431844	23	2774	24	são-jorgense	118
4307	São José Das Missões	431845	23	2720	28	são-josezense	98
4309	São José Do Hortêncio	431848	23	4094	64	hortenciense	64
4311	São José Do Norte	431850	23	25503	23	nortense	1118
4312	São José Do Ouro	431860	23	6904	21	ourense	335
4314	São José Dos Ausentes	431862	23	3290	3	ausentino	1177
4315	São Leopoldo	431870	23	214087	2	leopoldense	103
4317	São Luiz Gonzaga	431890	23	34556	27	são-luizense	1296
4318	São Marcos	431900	23	20103	78	são-marquense	256
4320	São Martinho Da Serra	431912	23	3201	5	martinhense	670
4322	São Nicolau	431920	23	5727	12	são-nicolauense	485
4324	São Pedro Da Serra	431935	23	3315	94	são-pedrense	35
4325	São Pedro Das Missões	431936	23	1886	24	são pedrense 	80
4327	São Pedro Do Sul	431940	23	16368	19	são-pedrense	874
4328	São Sebastião Do Caí	431950	23	21932	197	caiense	111
4330	São Valentim	431970	23	3632	24	valentinense	154
4332	São Valério Do Sul	431973	23	2647	25	são-valerense	108
4333	São Vendelino	431975	23	1944	61	são-vendelinense	32
4335	Sapiranga	431990	23	74985	542	sapiranguense	138
4337	Sarandi	432010	23	21285	60	sarandiense	353
4338	Seberi	432020	23	10897	36	seberiense	301
4340	Segredo	432026	23	7158	29	segredense	247
4342	Senador Salgado Filho	432032	23	2814	19	salgadofilhense	147
4344	Serafina Corrêa	432040	23	14253	87	serafinense	163
4345	Sério	432045	23	2281	23	seriense	100
4347	Sertão Santana	432055	23	5850	23	sertanense	252
4349	Severiano De Almeida	432060	23	3842	23	severianense	168
4351	Sinimbu	432067	23	10068	20	sinimbuense 	510
4352	Sobradinho	432070	23	14283	110	sobradinhense	130
4354	Tabaí	432085	23	4131	44	tabaiense	95
4356	Tapera	432100	23	10448	58	taperense	180
4357	Tapes	432110	23	16629	21	tapense	806
4359	Taquari	432130	23	26092	75	taquariense	350
4361	Tavares	432135	23	5351	9	tavarense	604
4363	Terra De Areia	432143	23	9878	70	terrareense	142
4364	Teutônia	432145	23	27272	153	teutoniense	179
4366	Tiradentes Do Sul	432147	23	6461	28	tiradentense	234
4368	Torres	432150	23	34656	216	torrense	160
4370	Travesseiro	432162	23	2314	29	travesseirense	81
4372	Três Cachoeiras	432166	23	10217	41	três cachoeirense	251
4373	Três Coroas	432170	23	23848	129	três-coroense	186
4375	Três Forquilhas	432183	23	2914	13	forquilhense	217
4377	Três Passos	432190	23	23965	89	três-passense	268
4378	Trindade Do Sul	432195	23	5787	22	trindadense	268
4380	Tucunduva	432210	23	5898	33	tucunduvense	181
4382	Tupanci Do Sul	432218	23	1573	12	tupancisense	135
4384	Tupandi	432225	23	3924	66	tupandiense	60
4385	Tuparendi	432230	23	8557	28	tuparendiense	308
4387	Ubiretama	432234	23	2296	18	ubiretamense	127
4389	Unistalda	432237	23	2450	4	unistaldense	602
4391	Vacaria	432250	23	61342	29	vacariense 	2124
4392	Vale Do Sol	432253	23	11077	34	vale-solense	328
4394	Vale Verde	432252	23	3253	10	valeverdense	330
4396	Venâncio Aires	432260	23	65946	85	venâncio-airense	773
4398	Veranópolis	432280	23	22810	79	veranense	289
4400	Viadutos	432290	23	5311	20	viadutense	268
4401	Viamão	432300	23	239384	160	viamense	1497
4404	Vila Flores	432330	23	3207	30	vila-florense	108
4406	Vila Maria	432340	23	4221	23	vila-mariense	181
4408	Vista Alegre	432350	23	2832	37	vista-alegrense	77
4409	Vista Alegre Do Prata	432360	23	1569	13	vista-alegrense	119
4411	Vitória Das Missões	432375	23	3485	13	vitoriano	260
4412	Westfália	432377	23	2793	44	westfaliano	64
4414	Abdon Batista	420005	24	2653	11	abdonense	236
4416	Agrolândia	420020	24	9323	45	agrolandense	207
4418	Água Doce	420040	24	6961	5	água-docense	1313
4420	Águas Frias	420055	24	2424	32	águasfriense	75
4421	Águas Mornas	420060	24	5548	17	águas-mornense	327
4423	Alto Bela Vista	420075	24	2005	19	bela-vistense	104
4425	Angelina	420090	24	5250	11	angelinense	500
4427	Anitápolis	420110	24	3214	6	anitapolitano	542
4428	Antônio Carlos	420120	24	7458	33	antônio-carlense	229
4430	Arabutã	420127	24	4193	32	arabutanense	132
4432	Araranguá	420140	24	61310	202	araranguaense	304
4433	Armazém	420150	24	7753	45	armazenense	173
4435	Arvoredo	420165	24	2260	25	arvoredense	91
4437	Atalanta	420180	24	3300	35	atalantense	95
4439	Balneário Arroio Do Silva	420195	24	9586	101	arroio-silvense	95
4441	Balneário Camboriú	420200	24	108089	2	praiano	47
4442	Balneário Gaivota	420207	24	8234	56	gaivotense	147
4444	Bandeirante	420208	24	2906	20	bandeirantense	146
4445	Barra Bonita	420209	24	1878	20	barrabonitense	93
4447	Bela Vista Do Toldo	420213	24	6004	11	bela vistense	535
4449	Benedito Novo	420220	24	10336	27	benedito-novense	388
4451	Blumenau	420240	24	309011	594	blumenauense	520
4453	Bom Jardim Da Serra	420250	24	4395	5	bom-jardinense	935
4454	Bom Jesus	420253	24	2526	40	bonjesuense	64
4456	Bom Retiro	420260	24	8942	8	bom-retirense	1056
4457	Bombinhas	420245	24	14293	423	bombinense	34
4459	Braço Do Norte	420280	24	29018	137	braço-nortense	212
4461	Brunópolis	420287	24	2850	8	brunopolitense	336
4463	Caçador	420300	24	70762	72	caçadorense	982
4464	Caibi	420310	24	6219	36	caibiense	172
4466	Camboriú	420320	24	62361	291	camboriuense	214
4468	Campo Belo Do Sul	420340	24	7483	7	campo-belense	1027
4470	Campos Novos	420360	24	32824	19	campos-novense	1719
4471	Canelinha	420370	24	10603	70	canelense	151
4473	Capão Alto	420325	24	2753	2	capão altense	1335
4475	Capivari De Baixo	420395	24	21674	408	capivariense	53
4477	Caxambu Do Sul	420410	24	4411	31	caxambuense	141
4479	Cerro Negro	420417	24	3581	9	cerronegrense	417
4481	Chapecó	420420	24	183530	294	chapecoense	624
4482	Cocal Do Sul	420425	24	15159	213	cocalense	71
4484	Cordilheira Alta	420435	24	3767	45	cordilheiraltense	84
4486	Coronel Martins	420445	24	2458	23	coronel martiense	107
4488	Corupá	420450	24	13852	34	corupaense	405
4489	Criciúma	420460	24	192308	816	criciumense	236
4491	Cunhataí	420475	24	1882	35	cunhataiense	55
4493	Descanso	420490	24	8634	30	descansense	286
4495	Dona Emma	420510	24	3721	21	donemense	181
4496	Doutor Pedrinho	420515	24	3604	10	pedrinhense	376
4498	Ermo	420519	24	2050	32	ermense	64
4499	Erval Velho	420520	24	4352	21	ervalense	207
4501	Flor Do Sertão	420535	24	1588	27	flor-sertanense	59
4503	Formosa Do Sul	420543	24	2601	26	formoense do sul	100
4505	Fraiburgo	420550	24	34553	63	fraiburgense	546
4506	Frei Rogério	420555	24	2474	16	frei rogeriense	158
4508	Garopaba	420570	24	18138	157	garopabense	116
4510	Gaspar	420590	24	57981	150	gasparense	386
4512	Grão Pará	420610	24	6223	19	grão-paraense	336
4513	Gravatal	420620	24	10635	63	gravatalense	168
4515	Guaraciaba	420640	24	10498	32	guaraciabense	331
4517	Guarujá Do Sul	420660	24	4908	49	guarujaense	101
4519	Herval D`Oeste	420670	24	21239	98	hervalense	217
4520	Ibiam	420675	24	1945	13	ibianense	147
4522	Ibirama	420690	24	17330	70	ibiramense	247
4524	Ilhota	420710	24	12355	49	ilhotense	253
4526	Imbituba	420730	24	40170	220	imbitubense	183
4527	Imbuia	420740	24	5707	47	imbuiense	122
4529	Iomerê	420757	24	2739	24	iomerense	115
5426	Zacarias	355715	26	2335	7	zacariense	319
4532	Ipuaçu	420768	24	6798	26	ipuaçuense	261
4533	Ipumirim	420770	24	7220	29	ipumiriense	247
4535	Irani	420780	24	9531	29	iraniense	327
4537	Irineópolis	420790	24	10448	18	irineopolitense	591
4538	Itá	420800	24	6426	39	itaense	165
4540	Itajaí	420820	24	183373	634	itajaiense	289
4542	Itapiranga	420840	24	15409	55	itapiranguense	280
4544	Ituporanga	420850	24	22250	66	ituporanguense	337
4545	Jaborá	420860	24	4041	21	jaboraense	191
4547	Jaguaruna	420880	24	17290	52	jaguarunense	329
4549	Jardinópolis	420895	24	1766	26	jardinopolense	68
4551	Joinville	420910	24	515288	449	joinvilense	1147
4552	José Boiteux	420915	24	4721	12	josé-boatense	406
4554	Lacerdópolis	420920	24	2199	32	lacerdopolitano	68
4556	Laguna	420940	24	51562	117	lagunense	441
4558	Laurentino	420950	24	6004	76	laurentinense	80
4559	Lauro Muller	420960	24	14367	53	lauro-milense	271
4561	Leoberto Leal	420980	24	3365	12	leobertense	291
4563	Lontras	420990	24	10244	52	lontrense	198
4564	Luiz Alves	421000	24	10438	40	luiz-alvense	260
4566	Macieira	421005	24	1826	7	macieirense	260
4568	Major Gercino	421020	24	3279	11	majorense	286
4570	Maracajá	421040	24	6404	101	maracajaense	63
4571	Maravilha	421050	24	22101	130	maravilhense	169
4573	Massaranduba	421060	24	14674	39	massarandubense	373
4575	Meleiro	421080	24	7000	38	meleirense	187
4577	Modelo	421090	24	4045	44	modelense	93
4579	Monte Carlo	421105	24	9312	48	montecarlense	194
4581	Morro Da Fumaça	421120	24	16126	194	fumacense	83
4582	Morro Grande	421125	24	2890	11	morrograndense	256
4584	Nova Erechim	421140	24	4275	66	nova-erechinense	64
4586	Nova Trento	421150	24	12190	30	nova-trentino	402
4587	Nova Veneza	421160	24	13309	45	veneziano	294
4589	Orleans	421170	24	21393	39	orleanense	550
4591	Ouro	421180	24	7372	35	ourense	213
4592	Ouro Verde	421185	24	2271	12	ouro-verdense	189
4594	Painel	421189	24	2353	3	painelense	740
4596	Palma Sola	421200	24	7765	23	palma-solense	332
4598	Palmitos	421210	24	16020	46	palmitense	351
4599	Papanduva	421220	24	17928	24	papanduvense	760
4601	Passo De Torres	421225	24	6627	70	passotorrense	95
4603	Paulo Lopes	421230	24	6692	15	paulo-lopense	450
4605	Penha	421250	24	25141	406	penhense	62
4606	Peritiba	421260	24	2988	31	peritibense	96
4608	Pinhalzinho	421290	24	16332	127	pinhalense	128
4610	Piratuba	421310	24	4786	33	piratubense	146
4612	Pomerode	421320	24	27759	129	pomerodense	216
4613	Ponte Alta	421330	24	4894	9	ponte-altense	567
4615	Ponte Serrada	421340	24	11031	20	ponte-serradense	564
4617	Porto União	421360	24	33493	39	porto-unionense	851
4619	Praia Grande	421380	24	7267	26	praia-grandense	279
4620	Presidente Castello Branco	421390	24	1725	26	castelinense	65
4622	Presidente Nereu	421410	24	2284	10	nereusense	225
4624	Quilombo	421420	24	10248	37	quilombense	279
4626	Rio Das Antas	421440	24	6143	19	rio-antense	317
4627	Rio Do Campo	421450	24	6192	12	rio-campense	506
4629	Rio Do Sul	421480	24	61198	237	rio-sulense	258
4631	Rio Fortuna	421490	24	4446	15	rio-fortunense	302
4632	Rio Negrinho	421500	24	39846	44	rio-negrinhense	908
4634	Riqueza	421507	24	4838	25	riquezense	190
4636	Romelândia	421520	24	5551	25	romelandino	224
4637	Salete	421530	24	7370	41	saletense	179
4639	Salto Veloso	421540	24	4301	41	velosoense	105
4641	Santa Cecília	421550	24	15757	14	ceciliense	1145
4643	Santa Rosa De Lima	421560	24	2065	10	rosa-limense	203
4645	Santa Terezinha	421567	24	8767	12	terezinhense	716
4646	Santa Terezinha Do Progresso	421568	24	2896	24	terezinhano	119
4648	Santo Amaro Da Imperatriz	421570	24	19823	57	santo-amarense	345
4650	São Bernardino	421575	24	2677	18	bernardinense	145
4651	São Bonifácio	421590	24	3008	7	são-bonifacense	461
4653	São Cristovão Do Sul	421605	24	5012	14	são-cristovense 	349
4655	São Francisco Do Sul	421620	24	42520	86	francisquense	493
4658	São João Do Oeste	421625	24	6036	37	são-joanense	164
4660	São Joaquim	421650	24	24812	13	joaquinense	1886
4661	São José	421660	24	209804	1	josefense	151
4663	São José Do Cerrito	421680	24	9273	10	cerritense	946
4665	São Ludgero	421700	24	10993	102	são-ludgerense	108
4667	São Miguel Da Boa Vista	421715	24	1904	26	boa-vistense	72
4668	São Miguel Do Oeste	421720	24	36306	155	miguel-oestino	234
4670	Saudades	421730	24	9016	44	saudadense	206
4671	Schroeder	421740	24	15316	107	cheredense	144
4673	Serra Alta	421755	24	3285	36	serra-altense	90
4675	Sombrio	421770	24	26613	186	sombriense	143
4677	Taió	421780	24	17260	25	taioense	693
4678	Tangará	421790	24	8674	22	tangaraense	389
4680	Tijucas	421800	24	30960	112	tijucano	277
4682	Timbó	421820	24	36774	289	timboense	127
4684	Três Barras	421830	24	18129	41	três-barrense	438
4685	Treviso	421835	24	3527	22	trevisano	158
4687	Treze Tílias	421850	24	6341	34	treze-tiliense	185
4689	Tubarão	421870	24	97235	324	tubaronense	300
4690	Tunápolis	421875	24	4633	35	tunapolitano	133
4692	União Do Oeste	421885	24	2910	31	união-oestense	93
4694	Urupema	421895	24	2482	7	urupemense	353
4696	Vargeão	421910	24	3532	21	vargeonense	166
4697	Vargem	421915	24	2808	8	vargense	350
4699	Vidal Ramos	421920	24	6290	19	vidal-ramense	339
4701	Vitor Meireles	421935	24	5207	14	vitor-meirelense	372
4703	Xanxerê	421950	24	44128	117	xanxerense	378
4705	Xaxim	421970	24	25713	87	xaxiense	295
4706	Zortéa	421985	24	2991	16	zorteense	190
4708	Aquidabã	280020	25	20056	56	aquidabãense	359
4710	Arauá	280040	25	10878	56	arauaense	193
4712	Barra Dos Coqueiros	280060	25	24976	277	barra-coqueirense	90
4713	Boquim	280067	25	25533	124	boquinense	206
4715	Campo Do Brito	280100	25	16749	83	campo-britense	202
4717	Canindé De São Francisco	280120	25	24686	27	canindense	902
4718	Capela	280130	25	30761	69	capelense	443
4720	Carmópolis	280150	25	13503	294	carmopolense	46
4722	Cristinápolis	280170	25	16519	70	cristinapolense	236
4724	Divina Pastora	280200	25	4326	47	divina-pastorense	92
4726	Feira Nova	280220	25	5324	29	feira-novense	185
4727	Frei Paulo	280230	25	13874	35	frei-paulense	400
4729	General Maynard	280250	25	2929	147	mainardense	20
4731	Ilha Das Flores	280270	25	8348	153	ilha-florense	55
4733	Itabaiana	280290	25	86967	258	itabaianense	337
4734	Itabaianinha	280300	25	38910	79	itabaianinhense	493
4736	Itaporanga D`Ajuda	280320	25	30419	41	itaporanguense	740
4738	Japoatã	280340	25	12938	32	japoatãnense	407
4740	Laranjeiras	280360	25	26902	166	laranjeirense	162
4741	Macambira	280370	25	6401	47	macambirense	137
4743	Malhador	280390	25	12042	119	malhadorense	101
4745	Moita Bonita	280410	25	11001	115	moita-bonitense	96
4747	Muribeca	280430	25	7344	97	muribequense	76
4748	Neópolis	280440	25	18506	70	neopolense	266
4750	Nossa Senhora Da Glória	280450	25	32497	43	glorense	756
4752	Nossa Senhora De Lourdes	280470	25	6238	77	lourdense	81
4753	Nossa Senhora Do Socorro	280480	25	160827	1	socorrense	157
4755	Pedra Mole	280500	25	2974	36	pedra-molense	82
4757	Pinhão	280520	25	5973	38	pinhãoense	156
4758	Pirambu	280530	25	8369	41	pirambuense	206
4760	Poço Verde	280550	25	21983	50	poço-verdense	440
4762	Propriá	280570	25	28451	308	propriaense	92
4764	Riachuelo	280590	25	9355	119	riachuelense	79
4765	Ribeirópolis	280600	25	17173	66	ribeiropolense	259
4767	Salgado	280620	25	19365	78	salgadense	248
4769	Santa Rosa De Lima	280650	25	3749	55	santa-rosense	68
4770	Santana Do São Francisco	280640	25	7038	154	santanense	46
4772	São Cristóvão	280670	25	78864	181	são-cristóvense	437
4774	São Francisco	280690	25	3393	40	são-francisquense	84
4775	São Miguel Do Aleixo	280700	25	3698	26	aleixense	144
4777	Siriri	280720	25	8004	48	siririense	166
4779	Tobias Barreto	280740	25	48040	47	tobiense	1021
4781	Umbaúba	280760	25	22434	185	umbaubense	121
4784	Aguaí	350030	26	32148	68	aguaiano	475
4786	Águas De Lindóia	350050	26	17266	287	lindoiense	60
4788	Águas De São Pedro	350060	26	2707	504	água-pedrense	5
4789	Agudos	350070	26	34524	36	agudense	966
4791	Alfredo Marcondes	350080	26	3891	33	marcondense	118
4793	Altinópolis	350100	26	15607	17	altinopolense	930
4794	Alto Alegre	350110	26	4102	13	alto-alegrense	319
4797	Álvares Machado	350130	26	23513	68	machadense	347
4798	Álvaro De Carvalho	350140	26	4650	30	álvaro-carvalhense	153
4800	Americana	350160	26	210638	2	americanense	133
4802	Américo De Campos	350180	26	5706	23	americampense	253
4803	Amparo	350190	26	65829	148	amparense	446
4805	Andradina	350210	26	55334	57	andradinense	964
4807	Anhembi	350230	26	5653	8	anhembiense	737
4808	Anhumas	350240	26	3738	12	anhumense	320
4810	Aparecida D`Oeste	350260	26	4450	25	aparecidense	179
4812	Araçariguama	350275	26	17080	117	araçariguamense	146
4814	Araçoiaba Da Serra	350290	26	27299	107	araçoiabano	255
4816	Arandu	350310	26	6123	21	aranduense	286
4817	Arapeí	350315	26	2493	16	arapeiense	157
4819	Araras	350330	26	118843	184	ararense	645
4821	Arealva	350340	26	7841	16	arealvense	505
4823	Areiópolis	350360	26	10579	123	areiopolitano	86
4825	Artur Nogueira	350380	26	44177	248	nogueirense	178
4826	Arujá	350390	26	74905	777	arujaense	96
4828	Assis	350400	26	95144	207	assisense	460
4830	Auriflama	350420	26	14202	33	auriflamense	434
4832	Avanhandava	350440	26	11310	33	avanhandavense	339
4833	Avaré	350450	26	82934	68	avareense	1213
4835	Balbinos	350470	26	3702	40	balbinense	92
4837	Bananal	350490	26	10223	17	bananalense	616
4839	Barbosa	350510	26	6593	32	barbosano	205
4840	Bariri	350520	26	31593	71	baririense	444
4842	Barra Do Chapéu	350535	26	5244	13	barrense	406
4844	Barretos	350550	26	112101	72	barretense	1566
4845	Barrinha	350560	26	28496	196	barrinhense	146
4847	Bastos	350580	26	20445	119	bastense	172
4849	Bauru	350600	26	343937	515	bauruense	668
4851	Bento De Abreu	350620	26	2674	9	bento-abreuense	301
4853	Bertioga	350635	26	47645	97	bertioguense	490
4854	Bilac	350640	26	7048	45	bilaquense	158
4856	Biritiba Mirim	350660	26	28575	90	biritibano	317
4858	Bocaina	350680	26	10859	30	bocainense	364
4859	Bofete	350690	26	9618	15	bofetense	654
4861	Bom Jesus Dos Perdões	350710	26	19708	183	perdoense	108
4863	Borá	350720	26	805	7	boraense	118
4864	Boracéia	350730	26	4268	35	boraceense	122
4866	Borebi	350745	26	2293	7	borebiense	348
4868	Bragança Paulista	350760	26	146744	286	bragantino	513
4870	Brejo Alegre	350775	26	2573	24	brejoalegrense	105
4871	Brodowski	350780	26	21107	76	brodosquiano	280
4873	Buri	350800	26	18563	16	buriense	1196
4875	Buritizal	350820	26	4053	15	buritinense	266
4877	Cabreúva	350840	26	41604	160	cabreuvano	260
4878	Caçapava	350850	26	84752	229	caçapavense	370
4880	Caconde	350870	26	18538	39	cacondense	470
4882	Caiabu	350890	26	4072	16	caiabuense	253
4884	Caiuá	350910	26	5039	9	caiuense	552
4885	Cajamar	350920	26	64114	488	cajamarense	131
4887	Cajobi	350930	26	9768	55	cajobiense	177
4889	Campina Do Monte Alegre	350945	26	5567	30	campinense	185
4891	Campo Limpo Paulista	350960	26	74074	931	campo-limpense	80
4893	Campos Novos Paulista	350980	26	4539	9	campos-novense	484
4894	Cananéia	350990	26	12226	10	cananeiense	1243
4896	Cândido Mota	351000	26	29884	50	cândido-motense	596
4898	Canitar	351015	26	4369	76	canitarense	57
4900	Capela Do Alto	351030	26	17532	103	capelense	170
4901	Capivari	351040	26	48576	151	capivariano	323
4903	Carapicuíba	351060	26	369584	11	carapicuibano	35
4905	Casa Branca	351080	26	28307	33	casa-branquense	864
4907	Castilho	351100	26	18003	17	castilhense	1066
4908	Catanduva	351110	26	112820	388	catanduvense	291
4910	Cedral	351130	26	7972	40	cedralense	197
4913	Cesário Lange	351160	26	15540	81	cesariano-lange	191
4915	Chavantes	355720	26	12114	64	chavantense	188
4916	Clementina	351190	26	7065	42	clementinense	169
4918	Colômbia	351210	26	5994	8	colombiano	729
4920	Conchas	351230	26	16288	35	conchense	466
4922	Coroados	351250	26	5238	21	coroadense	246
4924	Corumbataí	351270	26	3874	14	corumbataiense	279
4925	Cosmópolis	351280	26	58827	380	cosmopolense	155
4927	Cotia	351300	26	201150	623	cotiano	323
4928	Cravinhos	351310	26	31691	102	cravinhense	311
4930	Cruzália	351330	26	2274	15	cruzaliense	149
4932	Cubatão	351350	26	118720	834	cubatonense	142
4934	Descalvado	351370	26	31056	41	descalvadense	754
4935	Diadema	351380	26	386089	13	diademense	31
4937	Divinolândia	351390	26	11208	50	divinolandense	222
4939	Dois Córregos	351410	26	24761	39	dois-correguense	633
4941	Dourado	351430	26	8609	42	douradense	206
4943	Duartina	351450	26	12251	46	duartinense	265
4944	Dumont	351460	26	8143	73	dumonense	111
4946	Eldorado	351480	26	14641	9	eldoradense	1654
4948	Elisiário	351492	26	3120	33	elisiarense	94
4950	Embu Das Artes	351500	26	240230	3	embuense	70
4951	Embu Guaçu	351510	26	62769	405	embu-guaçuense	155
4953	Engenheiro Coelho	351515	26	15721	143	engenheiro coelhense	110
4955	Espírito Santo Do Turvo	351519	26	4244	22	espírito santense	194
4957	Estrela D`Oeste	351520	26	8208	28	estrelense	296
4958	Estrela Do Norte	351530	26	2658	10	estrelense	263
4960	Fartura	351540	26	15320	36	farturense	429
4962	Fernandópolis	351550	26	64696	118	fernandopolense	550
4963	Fernão	351565	26	1563	16	fernãoense	101
4965	Flora Rica	351580	26	1752	8	flora-riquense	225
4966	Floreal	351590	26	3003	15	florealense	204
4968	Flórida Paulista	351600	26	12848	24	floridense	525
4970	Francisco Morato	351630	26	154472	3	moratense	49
4972	Gabriel Monteiro	351650	26	2708	20	monteirense	139
4973	Gália	351660	26	7011	20	galiense	356
4975	Gastão Vidigal	351680	26	4193	23	vidigalense	181
4977	General Salgado	351690	26	10669	22	salgadense	493
4979	Glicério	351710	26	4565	17	glicerense	274
4980	Guaiçara	351720	26	10670	39	guaiçarense	270
4982	Guaíra	351740	26	37404	30	guairense	1258
4984	Guapiara	351760	26	17998	44	guapiense	408
4986	Guaraçaí	351780	26	8435	15	guaraçaiense	570
4988	Guarani D`Oeste	351800	26	1970	23	guaraniense	86
4989	Guarantã	351810	26	6404	14	guarantãense	461
4991	Guararema	351830	26	25844	96	guararemense	271
4993	Guareí	351850	26	14565	26	guareiense	566
4995	Guarujá	351870	26	290752	2	guarujaense	143
4996	Guarulhos	351880	26	1221979	4	guarulhense	319
4998	Guzolândia	351890	26	4754	19	guzolandense	252
5000	Holambra	351905	26	11299	172	holambrense	66
5002	Iacanga	351910	26	10013	18	iacanguense	547
5003	Iacri	351920	26	6419	20	iacriano	323
5005	Ibaté	351930	26	30734	106	ibateense	291
5007	Ibirarema	351950	26	6725	29	ibiraremense	228
5009	Ibiúna	351970	26	71217	67	ibiunense	1058
5010	Icém	351980	26	7462	21	icense	363
5012	Igaraçu Do Tietê	352000	26	23362	239	igaraçuense	98
5014	Igaratá	352020	26	8831	30	igaratense	293
5016	Ilha Comprida	352042	26	9025	48	ilha compridense	188
5018	Ilhabela	352040	26	28196	81	ilhabelense	348
5019	Indaiatuba	352050	26	201619	648	indaiatubano	311
5021	Indiaporã	352070	26	3903	14	indiaporãense	280
5023	Ipaussu	352090	26	13663	65	ipauçuense	210
5024	Iperó	352100	26	28300	166	iperoense	170
5026	Ipiguá	352115	26	4463	33	ipiguarense	137
5028	Ipuã	352130	26	14148	30	ipuãnense	466
5030	Irapuã	352150	26	7275	28	irapuense	258
5031	Irapuru	352160	26	7789	36	irapuruense	215
5033	Itaí	352180	26	24008	22	itaiense	1111
5035	Itaju	352200	26	3246	14	itajuense	230
5037	Itaóca	352215	26	3228	18	itaoquense	183
5039	Itapetininga	352230	26	144377	81	itapetingano	1790
5040	Itapeva	352240	26	87753	48	itapevense	1826
5043	Itapirapuã Paulista	352265	26	3880	10	itapirapuã paulistense	406
5044	Itápolis	352270	26	40051	40	itapolitano	997
5046	Itapuí	352290	26	12173	86	itapuiense	141
5048	Itaquaquecetuba	352310	26	321770	4	itaquaquecetubano	83
5050	Itariri	352330	26	15471	57	itaririense	274
5052	Itatinga	352350	26	18052	18	itatinguense	980
5054	Itirapuã	352370	26	5914	37	itirapuãnense	161
5055	Itobi	352380	26	7546	54	itobiano	139
5057	Itupeva	352400	26	44859	223	itupevense	201
5059	Jaborandi	352420	26	6592	24	jaborandiense	273
5061	Jacareí	352440	26	211214	459	jacareiense	460
5063	Jacupiranga	352460	26	17208	24	jacupiranguense	704
5064	Jaguariúna	352470	26	44311	313	jaguariunense	142
5066	Jambeiro	352490	26	5349	29	jambeirense	184
5068	Jardinópolis	352510	26	37661	75	jardinopolense	502
5070	Jaú	352530	26	131040	191	jauense	686
5071	Jeriquara	352540	26	3160	22	jeriquarense	142
5073	João Ramalho	352560	26	4150	10	ramalhense	415
5075	Júlio Mesquita	352580	26	4430	35	júlio-mesquitense	128
5077	Jundiaí	352590	26	370126	858	jundiaiense	431
5079	Juquiá	352610	26	19246	23	juquiaense	822
5080	Juquitiba	352620	26	28737	55	juquitibense	522
5082	Laranjal Paulista	352640	26	25251	66	laranjalense	384
5084	Lavrinhas	352660	26	6590	39	lavrinhense	167
5085	Leme	352670	26	91756	228	lemense	403
5087	Limeira	352690	26	276022	475	limeirense	581
5089	Lins	352710	26	71432	125	linense	570
5090	Lorena	352720	26	82537	199	lorenense	414
5092	Louveira	352730	26	37125	673	louveirense	55
5094	Lucianópolis	352750	26	2249	12	lucianopolense	190
5096	Luiziânia	352770	26	5030	30	luiziano	167
5097	Lupércio	352780	26	4353	28	lupercense	154
5099	Macatuba	352800	26	16259	72	macatubense	225
5101	Macedônia	352820	26	3664	11	macedoniense	328
5103	Mairinque	352840	26	43223	206	mairinquense	210
5105	Manduri	352860	26	8992	39	mandurinense	229
5107	Maracaí	352880	26	13332	25	maracaiense	534
5108	Marapoama	352885	26	2633	24	marapoamense	111
5110	Marília	352900	26	216745	185	mariliense	1170
5112	Martinópolis	352920	26	24219	19	martinopolense	1253
5113	Matão	352930	26	76786	146	matonense	525
5115	Mendonça	352950	26	4640	24	mendoncino	195
5117	Mesópolis	352965	26	1886	13	mesopolense	149
5119	Mineiros Do Tietê	352980	26	12038	56	mineirense	213
5120	Mira Estrela	353000	26	2820	13	mira-estrelense	217
5122	Mirandópolis	353010	26	27483	30	mirandopolense	919
5124	Mirassol	353030	26	53792	221	mirassolense	243
5125	Mirassolândia	353040	26	4295	26	mirassolandense	166
5127	Mogi Das Cruzes	353060	26	387779	544	mogiano	713
5129	Moji Mirim	353080	26	86505	174	mogi-miriano	498
5131	Monções	353100	26	2132	20	monçolense	104
5132	Mongaguá	353110	26	46293	326	mongaguano	142
5134	Monte Alto	353130	26	46642	135	monte-altense	347
5136	Monte Azul Paulista	353150	26	18931	72	monte-azulense	263
5138	Monte Mor	353180	26	48949	204	monte-morense 	240
5139	Monteiro Lobato	353170	26	4120	12	lobatense	333
5141	Morungaba	353200	26	11769	80	morungabense	147
5143	Murutinga Do Sul	353210	26	4186	17	murutinguense	251
5144	Nantes	353215	26	2707	9	nantense	286
5146	Natividade Da Serra	353230	26	6678	8	nativense	833
5148	Neves Paulista	353250	26	8772	40	nevense	218
5149	Nhandeara	353260	26	10725	25	nhandearense	436
5151	Nova Aliança	353280	26	5891	27	nova-aliancense	217
5153	Nova Canaã Paulista	353284	26	2114	17	novacanaense	124
5155	Nova Europa	353290	26	9300	58	nova-europense	160
5156	Nova Granada	353300	26	19180	36	granadense	532
5158	Nova Independência	353320	26	3068	12	independentino	266
5160	Nova Odessa	353340	26	51242	694	novaodessense	74
5161	Novais	353325	26	4592	39	novaense	118
5163	Nuporanga	353360	26	6817	20	nuporanguense	348
5165	Óleo	353380	26	2673	13	oleense	198
5166	Olímpia	353390	26	50024	62	olimpiense	803
5168	Oriente	353410	26	6097	28	orientense	219
5170	Orlândia	353430	26	39781	136	orlandino	292
5428	Aguiarnópolis	170030	27	5162	22	aguiarnopolense	235
5173	Osvaldo Cruz	353460	26	30917	124	osvaldo-cruzense	248
5174	Ourinhos	353470	26	103035	348	ourinhense	296
5176	Ouroeste	353475	26	8405	29	ouroestense	289
5178	Palestina	353500	26	11051	16	palestinense	695
5180	Palmeira D`Oeste	353520	26	9584	30	palmeirense	319
5181	Palmital	353530	26	21186	39	palmitalense	548
5183	Paraguaçu Paulista	353550	26	42278	42	paraguaçuense	1000
5185	Paraíso	353570	26	5898	38	paraisense	156
5187	Paranapuã	353590	26	3815	27	paranapuense	140
5188	Parapuã	353600	26	10844	30	parapuense	366
5190	Pariquera Açu	353620	26	18446	51	pariquerense	359
5192	Patrocínio Paulista	353630	26	13000	22	patrocinense	603
5194	Paulínia	353650	26	82146	592	paulinense	139
5195	Paulistânia	353657	26	1779	7	paulistaniense	257
5197	Pederneiras	353670	26	41497	57	pederneirense	729
5199	Pedranópolis	353690	26	2558	10	pedranopolense	260
5201	Pedreira	353710	26	41558	380	pedreirense	109
5202	Pedrinhas Paulista	353715	26	2940	19	pedrinhense	153
5204	Penápolis	353730	26	58510	82	penapolitano	711
5206	Pereiras	353750	26	7454	33	pereirense	223
5207	Peruíbe	353760	26	59773	192	peruibense	311
5209	Piedade	353780	26	52143	70	piedadense	747
5211	Pindamonhangaba	353800	26	146995	201	pindamonhangabense	730
5213	Pinhalzinho	353820	26	13105	85	pinhalense	155
5215	Piquete	353850	26	14107	80	piquetense	176
5216	Piracaia	353860	26	25116	65	piracaiense	385
5218	Piraju	353880	26	28475	56	pirajuense	505
5220	Pirangi	353900	26	10623	49	piranginense	215
5222	Pirapozinho	353920	26	24694	51	pirapozense	480
5223	Pirassununga	353930	26	70081	96	pirassununguense	727
5225	Pitangueiras	353950	26	35307	82	pitangueirense	431
5227	Platina	353970	26	3192	10	platinense	327
5229	Poloni	353990	26	5395	40	poloniense	134
5230	Pompéia	354000	26	19964	25	pompeiano	784
5232	Pontal	354020	26	40244	113	pontalense	356
5234	Pontes Gestal	354030	26	2518	12	pontes-gestalense	217
5236	Porangaba	354050	26	8326	31	porangabense	266
5238	Porto Ferreira	354070	26	51400	210	ferreirense	245
5240	Potirendaba	354080	26	15449	45	potirendabano	342
5241	Pracinha	354085	26	2858	45	pracinhense	63
5243	Praia Grande	354100	26	262051	2	praia-grandense	148
5245	Presidente Alves	354110	26	4123	14	alvense	287
5247	Presidente Epitácio	354130	26	41318	33	epitaciano	1259
5248	Presidente Prudente	354140	26	207610	369	prudentino	563
5250	Promissão	354160	26	35674	46	promissense	781
5251	Quadra	354165	26	3236	16	quadrense	206
5253	Queiroz	354180	26	2808	12	queirozense	234
5255	Quintana	354200	26	6004	19	quintanense	320
5257	Rancharia	354220	26	28804	18	ranchariense	1587
5259	Regente Feijó	354240	26	18494	70	regentense	265
5260	Reginópolis	354250	26	7323	18	reginopolitano	411
5262	Restinga	354270	26	6587	27	restinguense	246
5264	Ribeirão Bonito	354290	26	12135	26	ribeirão-bonitense	472
5266	Ribeirão Corrente	354310	26	4273	29	ribeirão-correntense	148
5268	Ribeirão Dos Índios	354323	26	2187	11	ribeirindio	196
5269	Ribeirão Grande	354325	26	7422	22	ribeirão grandense	333
5271	Ribeirão Preto	354340	26	604682	928	ribeirão-pretano	651
5273	Rincão	354370	26	10414	33	rinconense	316
5275	Rio Claro	354390	26	186253	373	rio-clarense	499
5276	Rio Das Pedras	354400	26	29501	130	rio-pedrense	227
5278	Riolândia	354420	26	10575	17	riolandense	633
5280	Rosana	354425	26	19691	27	rosanense	743
5282	Rubiácea	354440	26	2729	12	rubiacense	237
5283	Rubinéia	354450	26	2862	12	rubineiense	237
5285	Sagres	354470	26	2395	16	sagrense	148
5287	Sales Oliveira	354490	26	10568	35	salense	306
5289	Salmourão	354510	26	4818	28	salmourense	172
5290	Saltinho	354515	26	7059	71	saltinhense	100
5292	Salto De Pirapora	354530	26	40132	143	saltense	281
5294	Sandovalina	354550	26	3699	8	sandovalinense	455
5296	Santa Albertina	354570	26	5723	21	santa-albertinense	273
5297	Santa Bárbara D`Oeste	354580	26	180009	663	barbarense	271
5413	Valinhos	355620	26	106793	721	valinhense	148
5415	Vargem	355635	26	8801	62	vargense	143
5417	Vargem Grande Paulista	355645	26	42997	1	vargem-grandense	42
5418	Várzea Paulista	355650	26	107089	3	varzino	35
5420	Vinhedo	355670	26	63611	780	vinhedense	82
5421	Viradouro	355680	26	17297	79	viradourense	218
5301	Santa Cruz Da Esperança	354625	26	1953	13	santacruzense	148
5303	Santa Cruz Do Rio Pardo	354640	26	43921	39	santa-cruzense	1114
5304	Santa Ernestina	354650	26	5568	41	santa-ernestinense	134
5306	Santa Gertrudes	354670	26	21634	221	santa-gertrudense	98
5308	Santa Lúcia	354690	26	8248	54	santa-luciense	154
5309	Santa Maria Da Serra	354700	26	5413	21	serrense	257
5311	Santa Rita D`Oeste	354740	26	2543	12	santa-ritense	210
5313	Santa Rosa De Viterbo	354760	26	23862	83	santa-rosense	289
5314	Santa Salete	354765	26	1447	18	saletense	79
5316	Santana De Parnaíba	354730	26	108813	605	parnaibano	180
5317	Santo Anastácio	354770	26	20475	37	anastaciano	553
5319	Santo Antônio Da Alegria	354790	26	6304	20	alegriense	310
5321	Santo Antônio Do Aracanguá	354805	26	7626	6	aracanguaense	1308
5323	Santo Antônio Do Pinhal	354820	26	6486	49	pinhalense	133
5324	Santo Expedito	354830	26	2803	30	expeditense	94
5326	Santos	354850	26	419400	1	santista	281
5327	São Bento Do Sapucaí	354860	26	10468	41	são-bentista	253
5329	São Caetano Do Sul	354880	26	149263	10	sul-caetanense	15
5330	São Carlos	354890	26	221950	195	são-carlense	1137
5332	São João Da Boa Vista	354910	26	83639	162	são-joanense	516
5334	São João De Iracema	354925	26	1780	10	iracemense	179
5336	São Joaquim Da Barra	354940	26	46512	113	joaquinense	411
5337	São José Da Bela Vista	354950	26	8406	30	bela-vistense	277
5339	São José Do Rio Pardo	354970	26	51900	124	rio-pardense	419
5340	São José Do Rio Preto	354980	26	408258	947	rio-pretense	431
5342	São Lourenço Da Serra	354995	26	13973	75	são-lourensano	186
5344	São Manuel	355010	26	38342	59	são-manuelense	651
5345	São Miguel Arcanjo	355020	26	31450	34	são-miguelense	930
5347	São Pedro	355040	26	31662	52	são-pedrense	611
5349	São Roque	355060	26	78821	257	são-roquense	306
5350	São Sebastião	355070	26	73942	185	sebastianense	400
5352	São Simão	355090	26	14346	23	simonense	617
5353	São Vicente	355100	26	332445	2	vicentino	149
5355	Sarutaiá	355120	26	3622	26	sarutaiano	142
5357	Serra Azul	355140	26	11256	40	serra-azulense	283
5358	Serra Negra	355160	26	26387	130	serrano	204
5360	Sertãozinho	355170	26	110074	273	sertanezino	403
5362	Severínia	355190	26	15501	110	severinense	140
5364	Socorro	355210	26	36686	82	socorrense	449
5365	Sorocaba	355220	26	586625	1	sorocabano	449
5367	Sumaré	355240	26	241311	2	sumareense	153
5369	Suzano	355250	26	262480	1	suzanense	207
5370	Tabapuã	355260	26	11363	33	tabapuãnense	346
5372	Taboão Da Serra	355280	26	244528	12	taboense	20
5374	Taguaí	355300	26	10828	75	taguaíno	145
5376	Taiúva	355320	26	5447	41	taiuvense	132
5378	Tanabi	355340	26	24055	32	tanabiense	746
5379	Tapiraí	355350	26	8012	11	tapiraiense	755
5381	Taquaral	355365	26	2726	51	taquaralense	54
5383	Taquarituba	355380	26	22291	50	taquaritubense	448
5385	Tarabai	355390	26	6607	34	tarabaíno	197
5386	Tarumã	355395	26	12885	43	tarumaense	303
5388	Taubaté	355410	26	278686	446	taubateano	625
5390	Teodoro Sampaio	355430	26	21386	14	teodorense	1556
5392	Tietê	355450	26	36835	91	tieteense	405
5394	Torre De Pedra	355465	26	2254	32	torrepedrense	71
5395	Torrinha	355470	26	9330	30	torrinhense	311
5397	Tremembé	355480	26	40984	214	tremembeense	191
5399	Tuiuti	355495	26	5930	47	tuiutiense	127
5401	Tupi Paulista	355510	26	14269	58	tupinense-paulista	245
5402	Turiúba	355520	26	1930	13	turiubano	153
5404	Ubarana	355535	26	5289	25	ubaranense	210
5406	Ubirajara	355550	26	4427	16	ubirajarense	282
5408	União Paulista	355570	26	1599	20	união-paulistense	79
5410	Uru	355590	26	1251	9	uruense	147
5411	Urupês	355600	26	12714	39	urupeense	324
5423	Vitória Brasil	355695	26	1737	35	vitoriabrasiliense	50
5425	Votuporanga	355710	26	84692	200	votuporanguense	424
5427	Abreulândia	170025	27	2391	1	abreulandense 	1895
5429	Aliança Do Tocantins	170035	27	5671	4	aliancense	1580
5430	Almas	170040	27	7586	2	almense	4013
5432	Ananás	170100	27	9865	6	ananaense 	1577
5434	Aparecida Do Rio Negro	170110	27	4213	4	aparecidense	1160
5436	Araguacema	170190	27	6317	2	araguacemense	2778
5437	Araguaçu	170200	27	8786	2	araguaçuense	5168
5439	Araguanã	170215	27	5030	6	araguanaense	836
5441	Arapoema	170230	27	6742	4	arapoemense	1552
5443	Augustinópolis	170255	27	15950	40	augustinopolino	395
5445	Axixá Do Tocantins	170290	27	9275	62	axixaense	150
5446	Babaçulândia	170300	27	10424	6	babaçulense	1788
5448	Barra Do Ouro	170307	27	4123	4	barraourense	1106
5450	Bernardo Sayão	170320	27	4456	5	bernardense	927
5451	Bom Jesus Do Tocantins	170330	27	3768	3	bonjesuense	1333
5453	Brejinho De Nazaré	170370	27	5185	3	brejinense	1724
5454	Buriti Do Tocantins	170380	27	9768	39	buritinense	252
5456	Campos Lindos	170384	27	8139	3	campolindense	3240
5458	Carmolândia	170388	27	2316	7	carmolandense	339
5460	Caseara	170390	27	4601	3	casearense	1692
5461	Centenário	170410	27	2566	1	centenarense	1955
5463	Chapada De Areia	170460	27	1335	2	chapadareiense	659
5465	Colméia	171670	27	8611	9	colmeiense	991
5466	Combinado	170555	27	4669	22	combinadense	210
5468	Couto Magalhães	170600	27	5009	3	coutense	1586
5469	Cristalândia	170610	27	7234	4	cristalandense	1848
5471	Darcinópolis	170650	27	5273	3	darcinopolino	1639
5472	Dianópolis	170700	27	19112	6	dianopolino	3217
5474	Dois Irmãos Do Tocantins	170720	27	7161	2	doisirmanense	3757
5476	Esperantina	170740	27	9476	19	esperantinense	504
5477	Fátima	170755	27	3805	10	fatimense	383
5479	Filadélfia	170770	27	8505	4	filadelfiense	1988
5481	Fortaleza Do Tabocão	170825	27	2419	4	tabocoense	622
5483	Goiatins	170900	27	12064	2	goiatinense	6409
5484	Guaraí	170930	27	23200	10	guaraiense	2268
5486	Ipueiras	170980	27	1639	2	ipueirense	815
5488	Itaguatins	171070	27	6029	8	itaguatinense	740
5490	Itaporã Do Tocantins	171110	27	2445	3	itaporanense	973
5491	Jaú Do Tocantins	171150	27	3507	2	jauense	2173
5493	Lagoa Da Confusão	171190	27	10210	1	lagoense	10565
5495	Lajeado	171200	27	2773	9	lajeadense	322
5497	Lizarda	171240	27	3725	1	lizardense	5723
5498	Luzinópolis	171245	27	2622	9	luzinopolino	280
5500	Mateiros	171270	27	2223	0	mateirense	9583
5502	Miracema Do Tocantins	171320	27	20684	8	miracemense	2656
5503	Miranorte	171330	27	12623	12	miranortense	1032
5505	Monte Santo Do Tocantins	171370	27	2085	2	montesantense	1092
5507	Natividade	171420	27	9000	3	nativitano	3241
5508	Nazaré	171430	27	4386	11	nazareno 	396
5510	Nova Rosalândia	171500	27	3770	7	rosalandense 	516
5512	Novo Alegre	171515	27	2286	11	novoalegrense 	200
5514	Oliveira De Fátima	171550	27	1037	5	oliverense 	206
5515	Palmas	172100	27	228332	103	palmense 	2219
5517	Palmeiras Do Tocantins	171380	27	5740	8	\N	748
5519	Paraíso Do Tocantins	171610	27	44417	35	paraisense	1268
5520	Paranã	171620	27	10338	1	paranãense	11260
5522	Pedro Afonso	171650	27	11539	6	pedro afonsino	2011
5524	Pequizeiro	171665	27	5054	4	pequizeirense	1210
5526	Piraquê	171720	27	2920	2	piraquêense	1368
5527	Pium	171750	27	6694	1	piuense	10014
5529	Ponte Alta Do Tocantins	171790	27	7180	1	pontealtense do tocantins	6491
5531	Porto Nacional	171820	27	49146	11	portuense	4450
5532	Praia Norte	171830	27	7659	27	praianortense	289
5534	Pugmil	171845	27	2369	6	pugmilense	402
5536	Riachinho	171855	27	4191	8	riachiense	517
5537	Rio Da Conceição	171865	27	1714	2	conceiçãoense	787
5539	Rio Sono	171875	27	6254	1	riosonense	6357
5541	Sandolândia	171884	27	3326	1	sandolandense	3529
5543	Santa Maria Do Tocantins	171888	27	2894	2	santamarinense	1410
5544	Santa Rita Do Tocantins	171889	27	2128	1	santa ritense	3275
1	Acrelândia	120001	1	12538	7	acrelandense	1808
4	Bujari	120013	1	8471	3	bujariense	3035
6	Cruzeiro Do Sul	120020	1	78507	9	cruzeirense	8779
9	Jordão	120032	1	6577	1	jordãoense	5357
11	Manoel Urbano	120034	1	7981	1	manoel-urbanense	10635
13	Plácido De Castro	120038	1	17209	9	placidiano	1943
16	Rio Branco	120040	1	336038	38	rio-branquense	8836
18	Santa Rosa Do Purus	120043	1	4691	1	santarosense	6146
20	Senador Guiomard	120045	1	20179	9	guiomaense	2321
23	Água Branca	270010	2	19377	43	água-branquense	455
25	Arapiraca	270030	2	214006	601	arapiraquense	356
27	Barra De Santo Antônio	270050	2	14230	103	barrense	138
30	Belém	270080	2	4551	94	belenense 	49
32	Boca Da Mata	270100	2	25776	138	matense	187
35	Cajueiro	270130	2	20409	164	cajueirense	124
37	Campo Alegre	270140	2	50816	172	campo-alegrense	295
39	Canapi	270160	2	17250	30	canapiense	575
42	Chã Preta	270190	2	7146	41	chã-pretense	173
44	Colônia Leopoldina	270210	2	20019	96	leopoldinense	208
46	Coruripe	270230	2	52130	57	coruripense	918
48	Delmiro Gouveia	270240	2	48096	79	delmirense	608
51	Feira Grande	270260	2	21321	123	feira-grandense	173
53	Flexeiras	270280	2	12325	37	flexeirense	333
56	Igaci	270310	2	25188	75	igaciense	334
58	Inhapi	270330	2	17898	47	inhapiense	377
60	Jacuípe	270350	2	6997	33	jacuipense	210
62	Jaramataia	270370	2	5558	54	jaramataiense	104
65	Jundiá	270390	2	4202	46	jundiaense	92
67	Lagoa Da Canoa	270410	2	18250	206	canoense	88
69	Maceió	270430	2	932748	2	maceioense	503
72	Maragogi	270450	2	28749	86	maragogiense	334
74	Marechal Deodoro	270470	2	45977	139	deodorense	332
76	Mata Grande	270500	2	24698	27	mata-grandense	908
79	Minador Do Negrão	270530	2	5275	31	negrense	168
81	Murici	270550	2	26710	63	muriciense	427
83	Olho D`Água Das Flores	270570	2	20364	111	olho-daguense	183
86	Olivença	270600	2	11047	64	olivense	173
88	Palestina	270620	2	5112	105	palestinense	49
90	Pão De Açúcar	270640	2	23811	35	pão-de-açucarense	683
93	Passo De Camaragibe	270650	2	14763	60	camaragibense	244
95	Penedo	270670	2	60378	88	penedense	689
98	Pindoba	270700	2	2866	24	pindobense	118
100	Poço Das Trincheiras	270720	2	13872	48	pocense	292
102	Porto De Pedras	270740	2	8429	33	porto-pedrense	258
105	Rio Largo	270770	2	68481	224	rio-larguense	306
107	Santa Luzia Do Norte	270790	2	6891	233	nortense	30
110	São Brás	270820	2	6718	48	são-braense	140
112	São José Da Tapera	270840	2	30088	61	taperense	495
115	São Miguel Dos Milagres	270870	2	7163	93	milagrense	77
118	Senador Rui Palmeira	270895	2	13047	38	rui-palmeirense	343
120	Taquarana	270910	2	19020	115	taquaranense	166
123	União Dos Palmares	270930	2	62358	148	palmarino	421
125	Alvarães	130002	3	14088	2	alvarãense	5912
127	Anamã	130008	3	10214	4	anamãense	2454
128	Anori	130010	3	16317	3	anoriense	5795
130	Atalaia Do Norte	130020	3	15153	0	atalaiense	76352
133	Barreirinha	130050	3	27355	5	barreirinhense	5751
135	Beruri	130063	3	15486	1	beruriense	17251
137	Boca Do Acre	130070	3	30632	1	bocacrense	21953
139	Caapiranga	130083	3	10975	1	caapiranguense	9457
142	Careiro	130110	3	32734	5	careirense	6092
144	Coari	130120	3	75965	1	coariense	57922
146	Eirunepé	130140	3	30665	2	eirunepeense	15012
5547	Santa Terezinha Do Tocantins	172000	27	2474	9	terezinense do tocantins	270
5549	São Félix Do Tocantins	172015	27	1437	1	são felense	1909
5550	São Miguel Do Tocantins	172020	27	10481	26	são miguelense	399
5552	São Sebastião Do Tocantins	172030	27	4283	15	sansebastianense	287
5554	Silvanópolis	172065	27	5068	4	silvanopolino	1259
5555	Sítio Novo Do Tocantins	172080	27	9148	28	sítionovense	324
5557	Taguatinga	172090	27	15051	6	taguatinense	2437
5559	Talismã	172097	27	2562	1	talismãense	2157
5560	Tocantínia	172110	27	6736	3	tocantiniense	2602
5562	Tupirama	172125	27	1574	2	tupiramense	712
5564	Wanderlândia	172208	27	10981	8	wanderlandiense	1373
148	Fonte Boa	130160	3	22817	2	fonte-boense	12111
151	Ipixuna	130180	3	22254	2	ipixunense	12045
153	Itacoatiara	130190	3	86839	10	itacoatiarense	8892
155	Itapiranga	130200	3	8211	2	itapiranguense	4231
157	Juruá	130220	3	10802	1	juruaense	19401
160	Manacapuru	130250	3	85141	12	manacapuruense	7330
162	Manaus	130260	3	1802014	158	manauara	11401
164	Maraã	130280	3	17528	1	maraãense	16910
167	Nova Olinda Do Norte	130310	3	30696	5	olindense	5609
169	Novo Aripuanã	130330	3	21451	1	aripuanense	41189
172	Presidente Figueiredo	130353	3	27175	1	figueirense	25422
174	Santa Isabel Do Rio Negro	130360	3	18146	0	santa-isabelense	62846
176	São Gabriel Da Cachoeira	130380	3	37896	0	são-gabrielense	109183
180	Tabatinga	130406	3	52272	16	tabatinguense	3225
182	Tefé	130420	3	61453	3	tefeense	23704
184	Uarini	130426	3	11891	1	uarinense	10246
186	Urucurituba	130440	3	17837	6	urucuritubense	2907
189	Cutias	160021	4	4696	2	cutienses	2114
191	Itaubal	160025	4	4265	3	itaubenses	1704
193	Macapá	160030	4	398204	62	macapaense	6409
195	Oiapoque	160050	4	20509	1	oiapoquenses	22625
197	Porto Grande	160053	4	16809	4	portograndenses	4402
200	Serra Do Navio	160005	4	4380	1	serranavienses	7756
202	Vitória Do Jari	160080	4	12428	5	vitorenses	2483
205	Acajutiba	290030	5	14653	76	acajutibense	193
207	Água Fria	290040	5	15731	24	água-friense	662
209	Alagoinhas	290070	5	141949	189	alagoinhense	752
212	Amargosa	290100	5	34351	74	amargosense	463
214	América Dourada	290115	5	15961	19	américo-douradense	839
216	Andaraí	290130	5	13960	8	andaraiense	1862
219	Anguera	290150	5	10242	58	anguerense	177
221	Antônio Cardoso	290170	5	11554	39	cardosense	294
223	Aporá	290190	5	17731	32	aporense	562
226	Aracatu	290200	5	13743	9	aracatuense	1490
228	Aramari	290220	5	10036	30	aramariense	330
230	Aratuípe	290230	5	8599	47	aratuipense	181
232	Baianópolis	290250	5	13850	4	baianopolense	3343
235	Barra	290270	5	49325	4	barrense	11413
237	Barra Do Choça	290290	5	34788	54	barra-chocense	647
240	Barreiras	290320	5	137427	17	barreirense	7859
242	Barrocas	290327	5	14191	71	barroquense	201
244	Belmonte	290340	5	21798	11	belmontense	1961
247	Boa Nova	290370	5	15411	18	boa-novense	869
249	Bom Jesus Da Lapa	290390	5	63480	15	lapense	4200
251	Boninal	290400	5	13695	15	boninalense	934
254	Botuporã	290420	5	11154	17	botuporãense	646
256	Brejolândia	290440	5	11077	4	brejolandense	2744
257	Brotas De Macaúbas	290450	5	10717	5	brotense	2240
259	Buerarema	290470	5	18605	81	bueraremense	230
261	Caatiba	290480	5	11420	23	caatibense	491
263	Cachoeira	290490	5	32026	81	cachoeirano	395
266	Caetanos	290515	5	13639	18	caetanense	775
268	Cafarnaum	290530	5	17209	25	cafarnauense	675
270	Caldeirão Grande	290550	5	12491	27	caldeirão-grandense	455
273	Camamu	290580	5	35180	38	camamuense	920
274	Campo Alegre De Lourdes	290590	5	28090	10	campo-alegrense	2781
277	Canarana	290620	5	24067	42	canaraense	576
280	Candeias	290650	5	83158	322	candeense	258
282	Cândido Sales	290670	5	27918	17	cândido-salense	1618
284	Canudos	290682	5	15732	5	canudense	3219
286	Capim Grosso	290687	5	26577	79	capim-grossense	336
289	Cardeal Da Silva	290700	5	8899	40	cardinalense	221
291	Casa Nova	290720	5	64940	7	casa-novense	9647
294	Catu	290750	5	51077	123	catuense	416
296	Central	290760	5	17013	28	centralense	602
298	Cícero Dantas	290780	5	32300	48	cícero-dantense	673
301	Cocos	290810	5	18153	2	coquense	10148
303	Conceição Do Almeida	290830	5	17889	62	almeidense	290
305	Conceição Do Jacuípe	290850	5	30123	256	conjacuipense	118
308	Contendas Do Sincorá	290880	5	4663	4	contendense	1045
311	Coribe	290910	5	14307	6	coribense	2523
313	Correntina	290930	5	31249	3	correntinense	11941
315	Cravolândia	290950	5	5041	31	cravolandense	162
318	Cruz Das Almas	290980	5	58606	402	cruz-almense	146
320	Dário Meira	291000	5	12836	29	dário-meirense	445
323	Dom Macedo Costa	291020	5	3874	46	macedense	85
325	Encruzilhada	291040	5	23766	12	encruzilhadense	1982
327	Érico Cardoso	290050	5	10859	15	érico-cardosense	701
330	Eunápolis	291072	5	100196	85	eunapolitano	1179
332	Feira Da Mata	291077	5	6184	4	matense	1669
335	Firmino Alves	291090	5	5384	33	firmino-alvense	162
337	Formosa Do Rio Preto	291110	5	22528	1	formosense	16404
340	Gentio Do Ouro	291130	5	10622	3	gentiense	3700
342	Gongogi	291150	5	8357	42	gongogiense	198
345	Guanambi	291170	5	78833	61	guanambiense	1297
347	Heliópolis	291185	5	13192	42	heliopoliense	312
349	Ibiassucê	291200	5	10062	24	ibiassuceense	427
351	Ibicoara	291220	5	17282	20	ibicoarense	850
354	Ibipitanga	291250	5	14171	15	ibipitanguense	954
356	Ibirapitanga	291270	5	22598	51	ibirapitanguense	447
358	Ibirataia	291290	5	18943	64	ibirataense	295
361	Ibotirama	291320	5	25424	15	ibotiramense	1722
363	Igaporã	291340	5	15205	18	igaporaense	833
365	Iguaí	291350	5	25705	31	iguaiense	828
367	Inhambupe	291370	5	36306	30	inhambupense	1223
370	Ipirá	291400	5	59343	19	ipiraense	3049
372	Irajuba	291420	5	7002	17	irajubense	414
374	Iraquara	291440	5	22601	22	iraquarense	1029
377	Itabela	291465	5	28390	33	itabelense	851
379	Itabuna	291480	5	204667	474	itabunense	432
381	Itaeté	291500	5	14924	12	itaeteense	1209
383	Itagibá	291520	5	15193	19	itagibaense	789
385	Itaguaçu Da Bahia	291535	5	13209	3	itaguaçuense	4451
386	Itaju Do Colônia	291540	5	7309	6	itajuense	1223
388	Itamaraju	291560	5	63069	28	itamarajuense	2274
390	Itambé	291580	5	23089	16	itambeense	1442
393	Itaparica	291610	5	20725	176	itaparicano	118
395	Itapebi	291630	5	10495	10	itapebiense	1005
397	Itapicuru	291650	5	32261	20	itapicuruense	1586
399	Itaquara	291670	5	7678	24	itaquarense	323
402	Itiruçu	291690	5	12693	40	itiruçuense	314
404	Itororó	291710	5	19914	64	itororoense	314
406	Ituberá	291730	5	26591	64	ituberense	417
408	Jaborandi	291735	5	8973	1	jaborandiense	9526
411	Jaguaquara	291760	5	51011	55	jaguaquarense	928
413	Jaguaripe	291780	5	16467	18	jaguaripense	899
415	Jequié	291800	5	151895	47	jequieense	3227
418	Jitaúna	291830	5	14115	64	jitaunense	219
419	João Dourado	291835	5	22549	25	joão-douradense	915
422	Jussara	291850	5	15052	16	jussaraense	949
425	Lafaiete Coutinho	291870	5	3901	10	lafaietense	405
427	Laje	291880	5	22201	49	lajista	458
429	Lajedinho	291900	5	3936	5	lajedinhense	776
432	Lapão	291915	5	25646	43	lapoense	602
434	Lençóis	291930	5	10368	8	lençoense	1277
436	Livramento De Nossa Senhora	291950	5	42693	20	livramentense	2136
439	Macarani	291970	5	17093	13	macaraniense	1288
441	Macururé	291990	5	8073	4	macururense	2294
443	Maetinga	291995	5	7038	10	maetinguense	682
445	Mairi	292010	5	19326	20	mairiense	953
447	Malhada De Pedras	292030	5	8468	16	malhada-pedrense	529
450	Maracás	292050	5	24613	11	maracaense	2253
452	Maraú	292070	5	19101	23	marauense	823
454	Mascote	292090	5	14640	19	mascotense	772
457	Medeiros Neto	292110	5	21560	17	medeirense	1239
459	Milagres	292130	5	10306	36	milagrense	284
462	Monte Santo	292150	5	52338	16	monte-santense	3187
464	Morro Do Chapéu	292170	5	35164	6	morrense	5743
466	Mucugê	292190	5	10545	4	mucugeense	2455
468	Mulungu Do Morro	292205	5	12249	22	mulunguense	566
471	Muquém De São Francisco	292225	5	10272	3	sanfranciscano	3638
474	Nazaré	292250	5	27274	107	nazareno	254
476	Nordestina	292265	5	12371	27	nordestinense	461
478	Nova Fátima	292273	5	7602	22	fatimense	350
480	Nova Itarana	292280	5	7435	16	nova-itaranense	470
483	Nova Viçosa	292300	5	38556	29	nova-viçosense	1323
485	Novo Triunfo	292305	5	15051	60	novo-triunfense	251
487	Oliveira Dos Brejinhos	292320	5	21831	6	brejinhense	3513
490	Palmas De Monte Alto	292340	5	20775	8	monte-altense	2525
493	Paratinga	292370	5	29504	11	paratinguense	2615
495	Pau Brasil	292390	5	10852	18	pau-brasilense	607
497	Pé De Serra	292405	5	13752	22	pé-de-serrense	616
499	Pedro Alexandre	292420	5	16995	19	pedro-alexandrense	896
502	Pindaí	292450	5	15628	25	pindaiense	614
504	Pintadas	292465	5	10342	19	pintadense	546
507	Piritiba	292480	5	22399	23	piritibano	976
509	Planalto	292500	5	24481	25	planaltense	962
511	Pojuca	292520	5	33066	114	pojucano	290
513	Porto Seguro	292530	5	126929	53	porto-segurense	2408
516	Presidente Dutra	292560	5	13750	84	utrense	164
517	Presidente Jânio Quadros	292570	5	13652	12	janio-quadrense	1185
520	Quijingue	292590	5	27228	20	quijinguense	1343
522	Rafael Jambeiro	292595	5	22874	19	jambeirense	1219
524	Retirolândia	292610	5	12055	66	retirolandense	181
526	Riachão Do Jacuípe	292630	5	33172	28	jacuipense	1190
529	Ribeira Do Pombal	292660	5	47518	60	pombalense	789
532	Rio Do Antônio	292680	5	14815	18	rio-antoniense	814
534	Rio Real	292700	5	37164	52	rio-realense	717
537	Salinas Da Margarida	292730	5	13456	90	salinense	150
539	Santa Bárbara	292750	5	19064	55	barbarense	346
541	Santa Cruz Cabrália	292770	5	26264	17	santa-cruzense	1563
544	Santa Luzia	292805	5	13344	17	santa-luziense	775
546	Santa Rita De Cássia	292840	5	26250	4	santa-ritense 	5978
549	Santana	292820	5	24750	14	santanense	1820
551	Santo Amaro	292860	5	57800	117	santo-amarense	493
553	Santo Estêvão	292880	5	47880	132	santo-estevense	363
555	São Domingos	292895	5	9226	28	são-dominguense	327
558	São Félix Do Coribe	292905	5	13048	14	são-felense	949
560	São Gabriel	292925	5	18427	15	são-gabrielense	1199
562	São José Da Vitória	292935	5	5715	79	são-joseense	72
565	São Sebastião Do Passé	292950	5	42153	78	sebastianense	538
568	Saubara	292975	5	11201	69	saubarense	163
570	Seabra	292990	5	41798	17	seabrense	2517
572	Senhor Do Bonfim	293010	5	74419	90	bonfinense	827
575	Serra Dourada	293030	5	18112	13	serra-douradense	1347
578	Serrolândia	293060	5	12344	42	serrolandense	296
580	Sítio Do Mato	293075	5	12050	7	sítio-matense	1751
582	Sobradinho	293077	5	22000	18	sobradinhense	1239
584	Tabocas Do Brejo Velho	293090	5	11431	8	taboquense	1376
587	Tanquinho	293110	5	8008	36	tanquinhense	220
589	Tapiramutá	293130	5	16516	25	tapiramutaense	664
591	Teodoro Sampaio	293140	5	7895	34	teodorense	232
594	Terra Nova	293170	5	12803	64	terra-novense	199
596	Tucano	293190	5	52418	19	tucanense	2799
599	Ubaitaba	293220	5	20691	116	ubaitabense	179
601	Uibaí	293240	5	13625	25	uibaiense	551
603	Una	293250	5	24110	20	unense	1177
605	Uruçuca	293270	5	19837	51	uruçuquense	392
607	Valença	293290	5	88673	74	valenciano	1193
610	Várzea Do Poço	293310	5	8661	42	varzeapense	205
612	Varzedo	293317	5	9109	40	varzedense	227
614	Vereda	293325	5	6800	8	veredense	874
617	Wanderley	293345	5	12485	4	wanderleiense	2960
618	Wenceslau Guimarães	293350	5	22189	33	wenceslau-guimarãense	674
622	Acaraú	230020	6	57551	68	acarauense	843
624	Aiuaba	230040	6	16203	7	aiuabense	2434
626	Altaneira	230060	6	6856	94	altaneirense	73
628	Amontada	230075	6	39232	33	amontadense	1179
631	Aquiraz	230100	6	72628	151	aquirazense	483
633	Aracoiaba	230120	6	25391	39	aracoiabense	657
635	Araripe	230130	6	20685	19	araripense	1100
638	Assaré	230160	6	22445	20	assareense	1116
640	Baixio	230180	6	6026	41	baixiense	146
642	Barbalha	230190	6	55323	92	barbalhense	599
644	Barro	230200	6	21514	30	barrense	712
646	Baturité	230210	6	33321	108	baturiteense	309
648	Bela Cruz	230230	6	30878	37	bela-cruzense	824
651	Camocim	230260	6	60158	53	camocimense	1139
653	Canindé	230280	6	74473	23	canindeense	3218
655	Caridade	230300	6	20020	24	caridadense	847
657	Caririaçu	230320	6	26393	41	caririaçuense	637
660	Cascavel	230350	6	66142	79	cascavelense	837
662	Catunda	230365	6	9952	13	catundense	783
664	Cedro	230380	6	24527	34	cedrense	726
667	Chorozinho	230395	6	18915	68	chorozinhense	278
669	Crateús	230410	6	72812	24	crateuense	2988
671	Croatá	230423	6	17069	24	croataense	697
673	Deputado Irapuan Pinheiro	230426	6	9095	19	irapuense	470
676	Farias Brito	230430	6	19007	38	farias-britense	504
678	Fortaleza	230440	6	2452185	8	fortalezense	315
681	General Sampaio	230460	6	6218	33	sampaiense	187
683	Granja	230470	6	52645	20	granjense	2698
685	Groaíras	230490	6	10228	66	groairense	156
688	Guaramiranga	230510	6	4164	41	guaramiranguense	101
690	Horizonte	230523	6	55187	345	horizontino	160
692	Ibiapina	230530	6	23808	57	ibiapinense	415
695	Icó	230540	6	65456	35	icoense	1872
697	Independência	230560	6	25573	8	independenciense	3219
699	Ipaumirim	230570	6	12009	44	ipaumirinense	274
702	Iracema	230600	6	13722	17	iracemense	824
704	Itaiçaba	230620	6	7316	35	itaiçabense	210
706	Itapagé	230630	6	48350	112	itapageense	430
709	Itarema	230655	6	37471	52	itaremense	721
711	Jaguaretama	230670	6	17863	10	jaguaretamense	1760
713	Jaguaribe	230690	6	34409	18	jaguaribano	1877
716	Jati	230720	6	7660	21	jatiense	361
717	Jijoca De Jericoacoara	230725	6	17002	83	jijoquense	205
720	Lavras Da Mangabeira	230750	6	31090	33	lavrense	948
723	Maracanaú	230765	6	209057	2	maracanauense	111
725	Marco	230780	6	24703	43	marquense	574
727	Massapê	230800	6	35191	62	massapeense	567
730	Milagres	230830	6	28316	49	milagrense	577
732	Miraíma	230837	6	12800	18	miraimense	700
734	Mombaça	230850	6	42690	20	mombaçano	2119
737	Moraújo	230880	6	8070	19	moraujense	416
739	Mucambo	230900	6	14102	74	mucambense	191
741	Nova Olinda	230920	6	14256	50	novo-olindense	284
743	Novo Oriente	230940	6	27453	29	novo-oriental	946
746	Pacajus	230960	6	61838	243	pacajuense	254
748	Pacoti	230980	6	11607	106	pacotiense	110
751	Palmácia	231010	6	12005	102	palmaciano	118
753	Paraipaba	231025	6	30041	100	paraipabense	301
755	Paramoti	231040	6	11308	23	paramotiense	483
757	Penaforte	231060	6	8226	58	penafortense	142
759	Pereiro	231080	6	15757	37	pereirense	423
761	Piquet Carneiro	231090	6	15467	26	piquet-carneirense	588
764	Porteiras	231110	6	15061	69	porteirense	218
766	Potiretama	231123	6	6126	15	potiretamense	405
768	Quixadá	231130	6	80604	40	quixadaense	2020
770	Quixeramobim	231140	6	71887	22	quixeramobinense	3330
773	Reriutaba	231170	6	19455	51	reriutabano	383
774	Russas	231180	6	69833	44	russano	1591
775	Saboeiro	231190	6	15752	11	saboeirense	1383
777	Santa Quitéria	231220	6	42763	10	quiteriense	4260
779	Santana Do Cariri	231210	6	17170	20	santanense-do-cariri	856
782	São João Do Jaguaribe	231250	6	7900	28	jaguaribense	280
785	Senador Sá	231280	6	6852	16	saense	424
787	Solonópole	231300	6	17665	12	solonopolitano	1536
789	Tamboril	231320	6	25451	13	tamborilense	2001
792	Tejuçuoca	231335	6	16827	22	tejuçuoquense	782
794	Trairi	231350	6	51422	56	trairiense	926
796	Ubajara	231360	6	31787	76	ubajarense	421
799	Uruburetama	231380	6	19765	184	uruburetamense	108
801	Varjota	231395	6	17593	98	varjotense	179
803	Viçosa Do Ceará	231410	6	54955	42	viçosense	1312
805	Afonso Cláudio	320010	8	31091	33	afonso-claudense	955
808	Alegre	320020	8	30768	40	alegrense	773
810	Alto Rio Novo	320035	8	7317	32	alto-rio-novense	228
813	Aracruz	320060	8	81832	57	aracruzense	1436
814	Atilio Vivacqua	320070	8	9850	43	atilio-vivacquense	227
817	Boa Esperança	320100	8	14199	33	esperancense	429
820	Cachoeiro De Itapemirim	320120	8	189889	217	cachoeirense	877
822	Castelo	320140	8	34747	52	castelense	664
824	Conceição Da Barra	320160	8	28449	24	barrense	1188
827	Domingos Martins	320190	8	31847	26	martinense	1225
830	Fundão	320220	8	17025	61	fundãoense	280
831	Governador Lindenberg	320225	8	10869	30	lindenberguense	360
834	Ibatiba	320245	8	22366	93	ibatibense	241
837	Iconha	320260	8	12523	62	iconhense	203
839	Itaguaçu	320270	8	14134	27	itaguaçuense	530
841	Itarana	320290	8	10881	36	itaranense	299
844	Jerônimo Monteiro	320310	8	10879	67	monteirense	162
846	Laranja Da Terra	320316	8	10826	24	laranjense	457
848	Mantenópolis	320330	8	13612	42	mantenopolisense	321
851	Marilândia	320335	8	11107	36	marilandense	309
853	Montanha	320350	8	17849	16	montanhense	1098
855	Muniz Freire	320370	8	18397	27	muniz-freirense	680
858	Pancas	320400	8	21548	26	panquense	824
860	Pinheiros	320410	8	23895	25	pinheirense	975
863	Presidente Kennedy	320430	8	10314	18	kennediense	587
865	Rio Novo Do Sul	320440	8	11325	56	novense-do-sul	204
867	Santa Maria De Jetibá	320455	8	34176	46	santa-mariense	736
870	São Gabriel Da Palha	320470	8	31859	74	gabrielense	433
873	São Roque Do Canaã	320495	8	11273	33	são-roquense	342
876	Vargem Alta	320503	8	19130	46	vargem-altense	415
878	Viana	320510	8	65001	209	vianense	312
880	Vila Valério	320517	8	13830	30	vila-valense	464
883	Abadia De Goiás	520005	9	6876	47	abadiense	147
885	Acreúna	520013	9	20279	13	acreunense	1566
887	Água Fria De Goiás	520017	9	5090	3	água-friense	2029
890	Alexânia	520030	9	23814	28	alexaniense	848
892	Alto Horizonte	520055	9	4505	9	alto horizontino	504
895	Amaralina	520082	9	3434	3	amaralinense	1343
897	Amorinópolis	520090	9	3609	9	amorinopolense	409
899	Anhanguera	520120	9	1020	18	anhanguerino	57
900	Anicuns	520130	9	20239	21	anicuense	979
901	Aparecida De Goiânia	520140	9	455657	2	aparecidense	288
904	Araçu	520160	9	3802	26	araçuense	149
906	Aragoiânia	520180	9	8365	38	aragoianense	220
908	Arenópolis	520235	9	3277	3	arenopolino	1075
911	Avelinópolis	520280	9	2450	14	avelinopense	174
913	Barro Alto	520320	9	8716	8	barro-altense	1093
915	Bom Jardim De Goiás	520340	9	8423	4	bom-jardinense	1899
918	Bonópolis	520357	9	3503	2	bonopolino	1628
920	Britânia	520380	9	5509	4	britaniense	1461
922	Buriti De Goiás	520393	9	2560	13	buritiense	199
925	Cachoeira Alta	520410	9	10553	6	cachoeira-altense	1655
927	Cachoeira Dourada	520425	9	8254	16	cachoeirense-do-sul	521
930	Caldas Novas	520450	9	70473	44	caldense	1596
932	Campestre De Goiás	520460	9	3387	12	campestrino	274
935	Campo Alegre De Goiás	520480	9	6060	2	campo-alegrense	2463
937	Campos Belos	520490	9	18410	25	campo-belense	724
939	Carmo Do Rio Verde	520500	9	8928	21	carmo-rio-verdino	419
942	Caturaí	520520	9	4686	23	caturaiense	207
945	Cezarina	520545	9	7545	18	cezarinense	416
947	Cidade Ocidental	520549	9	55915	143	ocidentalense	390
949	Colinas Do Sul	520552	9	3523	2	colinense	1708
952	Corumbaíba	520590	9	8181	4	corumbaibense	1884
954	Cristianópolis	520630	9	2932	13	cristianopolino	225
956	Cromínia	520650	9	3555	10	crominiense	364
959	Damolândia	520680	9	2747	33	damolandense	84
961	Diorama	520710	9	2479	4	dioramense	687
963	Doverlândia	520725	9	7892	2	doverlandense	3223
966	Estrela Do Norte	520750	9	3320	11	estrela-nortense	302
968	Fazenda Nova	520760	9	6322	5	fazenda-novense	1281
970	Flores De Goiás	520790	9	12066	3	florense	3709
973	Gameleira De Goiás	520815	9	3275	6	gameleirense	592
976	Goianésia	520860	9	59549	38	goianesiense	1547
978	Goianira	520880	9	34060	163	goianirense	209
980	Goiatuba	520910	9	32492	13	goiatubense	2475
983	Guaraíta	520929	9	2376	12	guaraitense	205
985	Guarinos	520945	9	2299	4	guarinense	596
987	Hidrolândia	520970	9	17398	18	hidrolandense	944
990	Inaciolândia	520993	9	5699	8	inaciolandense	688
992	Inhumas	521000	9	48246	79	inhumense	613
994	Ipiranga De Goiás	521015	9	2844	12	ipiranguense	241
997	Itaberaí	521040	9	35371	24	itaberino	1457
999	Itaguaru	521060	9	5437	23	itaguaruense	240
1001	Itapaci	521090	9	18458	19	itapacino	956
1004	Itarumã	521130	9	6300	2	itarumaense	3434
1006	Itumbiara	521150	9	92883	38	itumbiarense	2463
1008	Jandaia	521170	9	6164	7	jandaiense	864
1010	Jataí	521190	9	88006	12	jataiense	7174
1013	Joviânia	521210	9	7118	16	jovianiense	445
1015	Lagoa Santa	521225	9	1254	3	lagosentense	459
1017	Luziânia	521250	9	174531	44	luzianiense	3961
1019	Mambaí	521270	9	6871	8	mambaiense	881
1022	Matrinchã	521295	9	4414	4	matrinchaense	1151
1024	Mimoso De Goiás	521305	9	2685	2	mimosense	1387
1026	Mineiros	521310	9	52935	6	mineirense	9060
1028	Monte Alegre De Goiás	521350	9	7730	2	monte-alegrense	3120
1030	Montividiu	521375	9	10572	6	montividiuense	1874
1032	Morrinhos	521380	9	41460	15	morrinhense	2846
1035	Mozarlândia	521400	9	13404	8	mozarlandense	1734
1037	Mutunópolis	521410	9	3849	4	mutunopolino	956
1040	Niquelândia	521460	9	42361	4	niquelandense	9843
1042	Nova Aurora	521480	9	2062	7	nova-aurorense	303
1044	Nova Glória	521486	9	8508	21	nova-glorino	413
1047	Nova Veneza	521500	9	8129	66	nova-venezino	123
1049	Novo Gama	521523	9	95018	489	novo-gamense	194
1051	Orizona	521530	9	14300	7	orizonense	1973
1053	Ouvidor	521550	9	5467	13	ouvidorense	414
1055	Palestina De Goiás	521565	9	3371	3	palestinense	1321
1058	Palminópolis	521590	9	3557	9	palminopolino	388
1060	Paranaiguara	521630	9	9100	8	paranaiguarense	1154
1063	Petrolina De Goiás	521680	9	10283	19	petrolinense	531
1065	Piracanjuba	521710	9	24026	10	piracanjubense	2405
1067	Pirenópolis	521730	9	23006	10	pirenopolino	2205
1070	Pontalina	521770	9	17121	12	pontalinense	1437
1072	Porteirão	521805	9	3347	6	porteirense	604
1075	Professor Jamil	521839	9	3239	9	jamilense	347
1077	Rialma	521860	9	10523	39	rialmense	268
1079	Rio Quente	521878	9	3312	13	rio-quentense	256
1082	Sanclerlândia	521900	9	7550	15	sanclerlandense	497
1084	Santa Cruz De Goiás	521920	9	3142	3	santa-cruzano	1109
1086	Santa Helena De Goiás	521930	9	36469	32	santa-helenense	1141
1089	Santa Rita Do Novo Destino	521945	9	3173	3	santaritense	956
1091	Santa Tereza De Goiás	521960	9	3995	5	santerezino	795
1094	Santo Antônio De Goiás	521973	9	4703	35	santoantoniense	133
1097	São Francisco De Goiás	521990	9	6120	15	franciscano	416
1099	São João Da Paraúna	522005	9	1689	6	joanino	288
1102	São Miguel Do Araguaia	522020	9	22283	4	são-miguelense	6144
1105	São Simão	522040	9	17088	41	canalense	414
1107	Serranópolis	522050	9	7481	1	serranopolino	5527
1110	Sítio D`Abadia	522070	9	2825	2	sitiense	1598
1112	Teresina De Goiás	522108	9	3016	4	teresinense	775
1114	Três Ranchos	522130	9	2819	10	triranchense	282
1117	Turvânia	522150	9	4839	10	turvaniense	481
1119	Uirapuru	522157	9	2933	3	uirapuruense	1153
1121	Uruana	522170	9	13826	26	uruanense	523
1123	Valparaíso De Goiás	522185	9	132982	2	valparaisense	61
1126	Vicentinópolis	522205	9	7371	10	vicentinopolino	737
1129	Açailândia	210005	10	104047	18	açailandense	5806
1131	Água Doce Do Maranhão	210015	10	11581	26	aguadocense	443
1134	Altamira Do Maranhão	210040	10	11063	15	altamirense	722
1136	Alto Alegre Do Pindaré	210047	10	31057	16	alto-alegrense	1932
1139	Amarante Do Maranhão	210060	10	37932	5	amarantino	7438
1142	Apicum Açu	210083	10	14959	42	apicum-açuense	353
1144	Araioses	210090	10	42505	24	araiosense	1783
1146	Arari	210100	10	28488	26	arariense	1100
1149	Bacabeira	210125	10	14925	24	bacabeirense	616
1150	Bacuri	210130	10	16604	21	bacuriense	788
1151	Bacurituba	210135	10	5293	8	bacuritubense	675
1153	Barão De Grajaú	210150	10	17841	8	baronense	2247
1155	Barreirinhas	210170	10	54930	18	barreirinhense	3112
1158	Benedito Leite	210180	10	5469	3	beneleitense	1782
1160	Bernardo Do Mearim	210193	10	5996	23	bernardense	261
1163	Bom Jesus Das Selvas	210203	10	28459	11	bom-jesuense	2679
1165	Brejo	210210	10	33359	31	brejense	1075
1168	Buriti Bravo	210230	10	22899	14	buriti-bravense	1583
1170	Buritirana	210235	10	14784	18	buritiranense 	818
1172	Cajapió	210240	10	10593	12	cajapioense	909
1174	Campestre Do Maranhão	210255	10	13369	22	campestrense	615
1177	Capinzal Do Norte	210275	10	10698	18	capinzalense	591
1180	Caxias	210300	10	155129	30	caxiense	5151
1182	Central Do Maranhão	210312	10	7887	25	centralense	319
1184	Centro Novo Do Maranhão	210317	10	17622	2	centronovense	8258
1187	Codó	210330	10	118038	27	codoense	4361
1189	Colinas	210350	10	39132	20	colinense	1981
1192	Cururupu	210370	10	32652	27	cururupuense	1223
1194	Dom Pedro	210380	10	22681	63	dom-pedrense	358
1196	Esperantinópolis	210400	10	18452	38	esperantinopense 	481
1198	Feira Nova Do Maranhão	210407	10	8126	6	nova-feirense	1473
1201	Fortaleza Dos Nogueiras	210410	10	11646	7	fortalezense	1664
1204	Gonçalves Dias	210440	10	17482	20	gonçalvino	879
1206	Governador Edison Lobão	210455	10	15895	26	edison-lobense 	616
1208	Governador Luiz Rocha	210462	10	7337	20	luiz-rochense 	373
1211	Graça Aranha	210470	10	6140	23	graçaranhense	271
1214	Humberto De Campos	210500	10	26189	12	humbertoense	2131
1216	Igarapé Do Meio	210515	10	12550	34	igarapeense	369
1219	Itaipava Do Grajaú	210535	10	14297	12	itaipavense	1239
1221	Itinga Do Maranhão	210542	10	24863	7	itinguense	3582
1223	Jenipapo Dos Vieiras	210547	10	15440	8	jenipapoense	1963
1226	Junco Do Maranhão	210565	10	4020	7	juncoense	555
1228	Lago Do Junco	210580	10	10729	35	juncoense	309
1231	Lagoa Do Mato	210592	10	10934	6	lagoense	1688
1233	Lajeado Novo	210598	10	6923	7	lajeadense	1048
1236	Luís Domingues	210620	10	6510	14	luís-dominguense	464
1238	Maracaçumé	210632	10	19155	30	maracaçumeense	629
1240	Maranhãozinho	210637	10	14065	14	maranhãozinense	973
1243	Matões	210660	10	31015	16	matoense	1976
1245	Milagres Do Maranhão	210667	10	8118	13	milagrense	635
1248	Mirinzal	210680	10	14218	21	mirinzalense	688
1250	Montes Altos	210700	10	9413	6	monte-altense	1488
1253	Nova Colinas	210725	10	4885	7	nova-colinense	743
1255	Nova Olinda Do Maranhão	210735	10	19134	8	novaolindense 	2453
1257	Olinda Nova Do Maranhão	210745	10	13181	67	olindense	198
1260	Paraibano	210770	10	20103	38	paraibanense	531
1263	Pastos Bons	210800	10	18067	11	pastos-bonense	1635
1265	Paulo Ramos	210810	10	20079	19	paulo-ramense	1053
1267	Pedro Do Rosário	210825	10	22732	13	pedro-rosariense	1750
1270	Peritoró	210845	10	21201	26	peritoroense	825
1272	Pinheiro	210860	10	78162	52	pinheirense	1513
1274	Pirapemas	210880	10	17381	25	pirapemense	689
1275	Poção De Pedras	210890	10	19708	20	poção-pedrense	979
1278	Presidente Dutra	210910	10	44731	58	presidutrense	772
1280	Presidente Médici	210923	10	6374	15	medicense	438
1283	Primeira Cruz	210940	10	13954	10	primeira-cruzense	1368
1285	Riachão	210950	10	20209	3	riachãoense	6373
1288	Sambaíba	210970	10	5487	2	sambaibense	2479
1289	Santa Filomena Do Maranhão	210975	10	7061	12	santa-filomenense	602
1292	Santa Luzia	211000	10	74043	16	santa-luziense	4766
1294	Santa Quitéria Do Maranhão	211010	10	29191	15	quiteriense	1918
1297	Santo Amaro Do Maranhão	211027	10	13820	9	santamarense	1601
1299	São Benedito Do Rio Preto	211040	10	17799	19	são-beneditense	931
1302	São Domingos Do Azeitão	211065	10	6983	7	são-dominguense	961
1305	São Francisco Do Brejão	211085	10	10261	14	brejãoense	746
1307	São João Batista	211100	10	19920	29	juanino ou joanino	691
1309	São João Do Paraíso	211105	10	10814	5	paraisense	2054
1312	São José De Ribamar	211120	10	163045	420	ribamarense	388
1315	São Luís Gonzaga Do Maranhão	211140	10	20153	21	gonzaguense	969
1318	São Pedro Dos Crentes	211157	10	4425	5	são-pedrense	980
1320	São Raimundo Do Doca Bezerra	211163	10	6090	15	são-raimundense	419
1323	Satubinha	211172	10	11990	27	satubinhense	442
1325	Senador La Rocque	211176	10	17998	15	laroquense	1237
1328	Sucupira Do Norte	211190	10	10444	10	sucupirense	1074
1330	Tasso Fragoso	211200	10	7796	2	fragosense	4383
1333	Trizidela Do Vale	211223	10	18953	85	trizidelense	223
1335	Tuntum	211230	10	39183	12	tuntuense	3390
1338	Tutóia	211250	10	52788	32	tutoiense	1652
1340	Vargem Grande	211270	10	49412	25	vargem-grandense	1958
1342	Vila Nova Dos Martírios	211285	10	11258	9	vila-novense	1189
1345	Zé Doca	211400	10	50173	21	zé-doquense	2416
1347	Abaeté	310020	11	22690	12	abaetense	1817
1349	Acaiaca	310040	11	3920	38	acaiaquense	102
1352	Água Comprida	310070	11	2025	4	água-compridense	491
1354	Águas Formosas	310090	11	18479	23	águas-formosense	820
1356	Aimorés	310110	11	24959	19	aimorense	1349
1359	Albertina	310140	11	2913	50	albertinense	58
1361	Alfenas	310160	11	73774	87	alfenense	850
1363	Almenara	310170	11	38775	17	almenarense	2294
1365	Alpinópolis	310190	11	18488	41	alpinopolense	455
1368	Alto JequitibÁ	315350	11	8318	55	jequitibaense	152
1370	Alvarenga	310220	11	4444	16	alvarenguense	278
1372	Alvorada De Minas	310240	11	3546	9	alvoradense	374
1375	Andrelândia	310280	11	12173	12	andrelandense	1005
1377	Antônio Carlos	310290	11	11114	21	antônio-carlense	530
1379	Antônio Prado De Minas	310310	11	1671	20	pradense-de-minas	84
1382	Araçuaí	310340	11	36013	16	araçuaiense	2236
1385	Araponga	310370	11	8152	27	araponguense	304
1387	ArapuÁ	310380	11	2775	16	arapuaense	174
1389	AraxÁ	310400	11	93672	80	araxaense	1164
1391	Arcos	310420	11	36597	72	arcoense	510
1394	Aricanduva	310445	11	4770	20	aricanduvense 	243
1396	Astolfo Dutra	310460	11	13049	82	astolfo-dutrense	159
1397	Ataléia	310470	11	14455	8	ataleiense	1837
1400	Baldim	310500	11	7913	14	baldinense	556
1402	Bandeira	310520	11	4987	10	bandeirense	484
1404	Barão De Cocais	310540	11	28442	84	cocaiense	341
1407	Barra Longa	310570	11	6143	16	barra-longuense	384
1409	Bela Vista De Minas	310600	11	10004	92	bela-vistano	109
1411	Belo Horizonte	310620	11	2375151	7	belo-horizontino	331
1414	Berilo	310650	11	12300	21	berilense	587
1416	Bertópolis	310660	11	4498	11	bertopolitano	428
1418	Bias Fortes	310680	11	3793	13	bias-fortense	284
1421	Boa Esperança	310710	11	38516	45	esperancense	861
1423	Bocaiúva	310730	11	46654	14	bocaiuvense	3228
1425	Bom Jardim De Minas	310750	11	6501	16	bom-jardinense	412
1428	Bom Jesus Do Galho	310780	11	15364	26	bom-jesuense	592
1430	Bom Sucesso	310800	11	17243	24	bom-sucessense	705
1432	Bonfinópolis De Minas	310820	11	5865	3	bonfinopolitano	1789
1435	Botelhos	310840	11	14920	45	botelhense	334
1437	BrÁs Pires	310870	11	4637	21	brás-pirense	223
1439	Brasília De Minas	310860	11	31213	22	brasilminense	1399
1442	Brumadinho	310900	11	33973	53	brumadinhense	639
1444	Buenópolis	310920	11	10292	6	buenopolitano 	1600
1447	Buritizeiro	310940	11	26922	4	buritizeirense	7218
1449	Cabo Verde	310950	11	13823	38	cabo-verdense	368
1451	Cachoeira De Minas	310970	11	11034	36	cachoeirense	304
1453	Cachoeira Dourada	310980	11	2505	12	cachoeirense	201
1456	Caiana	311010	11	4968	47	caianense	106
1458	Caldas	311030	11	13633	19	caldense	711
1461	Cambuí	311060	11	26488	108	cambuiense	245
1463	CampanÁrio	311080	11	3564	8	campanarense	442
1465	Campestre	311100	11	20686	36	campestrense	578
1467	Campo Azul	311115	11	3684	7	campoazulense	506
1469	Campo Do Meio	311130	11	11476	42	campo-meiense	275
1472	Campos Gerais	311160	11	27600	36	campos-geraiense	770
1474	Canaã	311170	11	4628	26	canaãense	175
1477	Cantagalo	311205	11	4195	30	cantagalense	142
1479	Capela Nova	311220	11	4755	43	capela-novense	111
1481	Capetinga	311240	11	7089	24	capetinguense	298
1483	Capinópolis	311260	11	15290	25	capinopolino	621
1485	Capitão Enéas	311270	11	14206	15	capitão-eneense	972
1488	Caraí	311300	11	22343	18	caraiense	1242
1490	Carandaí	311320	11	23346	48	carandaiense	486
1492	Caratinga	311340	11	85239	68	caratinguense	1259
1495	Carlos Chagas	311370	11	20069	6	carlos-chaguense	3203
1497	Carmo Da Cachoeira	311390	11	11836	23	carmo-cachoeirense	506
1499	Carmo De Minas	311410	11	13750	43	carmoense	322
1502	Carmo Do Rio Claro	311440	11	20426	19	carmelitano	1066
1505	Carrancas	311460	11	3948	5	carranquense	728
1507	Carvalhos	311480	11	4556	16	carvalhense	282
1509	Cascalho Rico	311500	11	2857	8	cascalho-riquense	367
1512	Catas Altas	311535	11	4846	20	catas-altense 	240
1513	Catas Altas Da Noruega	311540	11	3462	24	catas-altense	142
1516	Caxambu	311550	11	21705	216	caxambuense	100
1519	Centralina	311580	11	10266	31	centralinense	327
1521	Chalé	311600	11	5645	27	chaleense	213
1523	Chapada Gaúcha	311615	11	10805	3	chapadense	3255
1524	Chiador	311620	11	2785	11	chiadorense	253
1526	Claraval	311640	11	4542	20	claravalense	228
1528	ClÁudio	311660	11	25771	41	claudiense	631
1530	Coluna	311680	11	9024	26	colunense	348
1532	Comercinho	311700	11	8298	13	comerciense	655
1534	Conceição Da Barra De Minas	311520	11	3954	14	conceicionense	273
1537	Conceição De Ipanema	311740	11	4456	18	ipanemense	254
1540	Conceição Do Rio Verde	311770	11	12949	35	conceicionense	370
1542	Cônego Marinho	311783	11	7101	4	cônego marinhense	1642
1545	Congonhas	311800	11	48519	160	congonhense	304
1547	Conquista	311820	11	6526	11	conquistense	618
1549	Conselheiro Pena	311840	11	22242	15	conselheiro-penense	1484
1552	Coqueiral	311870	11	9289	31	coqueirense	296
1554	Cordisburgo	311890	11	8667	11	cordisburguense	824
1557	Coroaci	311920	11	10270	18	coroaciense	576
1559	Coronel Fabriciano	311940	11	103694	469	fabricianense	221
1561	Coronel Pacheco	311960	11	2983	23	pachequense	132
1564	Córrego Do Bom Jesus	311990	11	3730	30	correguense	124
1566	Córrego Novo	312000	11	3127	15	córrego-novense	205
1569	Cristais	312020	11	11286	18	cristalense	628
1571	Cristiano Otoni	312040	11	5007	38	cristianense	133
1573	Crucilândia	312060	11	4757	28	crucilandense	167
1576	Cuparaque	312083	11	4680	21	cuparaquense	227
1578	Curvelo	312090	11	74219	23	curvelano	3299
1580	Delfim Moreira	312110	11	7971	20	delfinense	408
1583	Descoberto	312130	11	4768	22	descobertense	213
1585	Desterro Do Melo	312150	11	3015	21	melense	142
1587	Diogo De Vasconcelos	312170	11	3848	23	vasconcelense	165
1590	Divino	312200	11	19133	57	divinense	338
1592	Divinolândia De Minas	312220	11	7024	53	divinolandense	133
1595	Divisa Nova	312240	11	5763	27	divisa-novense	217
1598	Dom Cavati	312250	11	5209	88	dom-cavatiano	60
1600	Dom Silvério	312270	11	5196	27	dom-silveriense	195
1602	Dona Eusébia	312290	11	6001	85	euzebense 	70
1605	Dores Do IndaiÁ	312320	11	13778	12	dorense	1111
1608	Douradoquara	312350	11	1841	6	douradoquarense	313
1610	Elói Mendes	312360	11	25220	50	elói-mendense	500
1612	Engenheiro Navarro	312380	11	7122	12	navarrense	608
1615	ErvÁlia	312400	11	17946	50	ervalense	357
1617	Espera Feliz	312420	11	22856	72	espera-felizense	318
1619	Espírito Santo Do Dourado	312440	11	4429	17	douradense 	264
1622	Estrela Do IndaiÁ	312470	11	3516	6	estrelense	636
1624	Eugenópolis	312490	11	10540	34	eugenopolense	309
1627	Fama	312520	11	2350	27	famense	86
1629	Felício Dos Santos	312540	11	5142	14	feliz-santense	358
1632	Fernandes Tourinho	312580	11	3030	20	fernandes-tourinhense	152
1634	Fervedouro	312595	11	10349	29	fervedourense	358
1636	Formiga	312610	11	65128	43	formiguense	1502
1639	Fortuna De Minas	312640	11	2705	14	fortunense	199
1641	Francisco Dumont	312660	11	4863	3	francisco-dumonsense	1576
1643	Franciscópolis	312675	11	5800	8	franciscopolitano	717
1646	Frei Lagonegro	312695	11	3329	20	frei lagonegrense	167
1647	Fronteira	312700	11	14041	70	fronteirense	200
1648	Fronteira Dos Vales	312705	11	4687	15	fronteirista-dos-vales	321
1651	Funilândia	312720	11	3855	19	funilandense	200
1653	Gameleiras	312733	11	5139	3	gameleirense	1733
1656	GoianÁ	312738	11	3659	24	goianaense	152
1658	Gonzaga	312750	11	5921	28	gonzaguense	209
1660	Governador Valadares	312770	11	263689	113	valadarense	2342
1663	Guanhães	312800	11	31262	29	guanhanense	1075
1665	Guaraciaba	312820	11	10223	29	guaraciabense	349
1667	Guaranésia	312830	11	18714	63	guaranesiano	295
1670	Guarda Mor	312860	11	6565	3	guarda-morense	2070
1672	Guidoval	312880	11	7206	46	guidovalense	158
1674	Guiricema	312900	11	8707	30	guiricemense	294
1676	Heliodora	312920	11	6121	40	heliodorense	154
1679	IbiÁ	312950	11	23218	9	ibiaense	2704
1681	Ibiracatu	312965	11	6155	17	ibiracatuense	353
1683	Ibirité	312980	11	158954	2	ibiritenense	73
1685	Ibituruna	313000	11	2866	19	ibiturunense	153
1688	Igaratinga	313020	11	9264	42	igaratinguense	218
1690	Ijaci	313040	11	5859	56	ijaciense	105
1692	Imbé De Minas	313055	11	6424	33	imbeense	197
1695	Indianópolis	313070	11	6190	7	indianopolense	830
1697	Inhapim	313090	11	24294	28	inhapinhense	858
1699	Inimutaba	313110	11	6724	13	inimutabano	524
1702	Ipatinga	313130	11	239468	1	ipatinguense	165
1704	Ipuiúna	313150	11	9521	32	ipuiunense	298
1706	Itabira	313170	11	109783	88	itabirano	1254
1709	Itacambira	313200	11	4988	3	itacambirano	1788
1711	Itaguara	313220	11	12372	30	itaguarense	410
1713	ItajubÁ	313240	11	90658	307	itajubense	295
1715	Itamarati De Minas	313260	11	4079	43	tamaratiense	95
1717	Itambé Do Mato Dentro	313280	11	2283	6	itambeense	380
1720	Itanhandu	313310	11	14175	99	itanhanduense	143
1723	Itapagipe	313340	11	13656	8	itapagipense	1802
1725	Itapeva	313360	11	8664	49	itapevense	177
1727	Itaú De Minas	313375	11	14945	97	itauense	153
1730	Itinga	313400	11	14407	9	itinguense	1650
1732	Ituiutaba	313420	11	97171	37	ituiutabano	2598
1734	Iturama	313440	11	34456	25	ituramense	1405
1736	Jaboticatubas	313460	11	17134	15	jaboticatubense	1114
1739	Jacutinga	313490	11	22772	65	jacutinguense	348
1741	Jaíba	313505	11	33587	13	jaibense	2626
1744	JanuÁria	313520	11	65463	10	januarense	6662
1746	Japonvar	313535	11	8298	22	japonvaense	375
1748	Jenipapo De Minas	313545	11	7116	25	jenipapense	284
1751	JequitibÁ	313570	11	5156	12	jequitibaense	445
1752	Jequitinhonha	313580	11	24131	7	jequitinhonhense	3514
1755	Joanésia	313610	11	5425	23	joanense	233
1757	João Pinheiro	313630	11	45260	4	pinheirense	10727
1760	José Gonçalves De Minas	313652	11	4553	12	gonçalvense	381
1762	Josenópolis	313657	11	4566	8	josenopolense	541
1765	Juramento	313680	11	4113	10	juramentense	432
1767	Juvenília	313695	11	5708	5	juveniliense	1065
1769	Lagamar	313710	11	7600	5	lagamaraense	1475
1772	Lagoa Dourada	313740	11	12256	26	lagoense	477
1774	Lagoa Grande	313753	11	8631	7	lagoa grandense	1236
1777	Lambari	313780	11	19554	92	lambariense	213
1778	Lamim	313790	11	3452	29	laminense	119
1780	Lassance	313810	11	6484	2	lassancense	3204
1782	Leandro Ferreira	313830	11	3205	9	leandrense	352
1784	Leopoldina	313840	11	51130	54	leopoldinense	943
1787	Limeira Do Oeste	313862	11	6890	5	limeirense	1319
1789	Luisburgo	313867	11	6234	43	luisburguense	145
1791	LuminÁrias	313870	11	5422	11	luminarense	500
1794	Machado	313900	11	38688	66	machadense	586
1796	Malacacheta	313920	11	18776	26	malacachetense	728
1798	Manga	313930	11	19813	10	manguense	1950
1801	Mantena	313960	11	27111	40	mantenense	685
1803	Maravilhas	313970	11	7163	27	maravilhense	262
1805	Mariana	314000	11	54219	45	marianense	1194
1807	MÁrio Campos	314015	11	13192	375	mario-campense	35
1810	Marmelópolis	314040	11	2968	28	marmelopolense	108
1812	Martins Soares	314053	11	7173	63	martinsoarense	113
1814	Materlândia	314060	11	4595	16	materlandiense	281
1817	Matias Barbosa	314080	11	13435	86	matiense	157
1819	Matipó	314090	11	17639	66	matipoense	267
1822	Matutina	314120	11	3761	14	matutinense	261
1824	Medina	314140	11	21026	15	medinense	1436
1826	Mercês	314160	11	10368	30	mercesano	348
1829	Minduri	314190	11	3840	17	mindurense	220
1831	Miradouro	314210	11	10251	34	miradourense	302
1833	Miravânia	314225	11	4549	8	miravaniense	602
1835	Moema	314240	11	7028	35	moemense	203
1837	Monsenhor Paulo	314260	11	8161	38	paulense	217
1840	Monte Azul	314290	11	21994	22	monte-azulense	994
1842	Monte Carmelo	314310	11	45772	34	carmelitano	1343
1844	Monte Santo De Minas	314320	11	21234	36	monte-santense	595
1847	Montezuma	314345	11	7464	7	montesumense	1130
1849	Morro Da Garça	314360	11	2660	6	morrense	415
1852	Muriaé	314390	11	100765	120	muriaense	842
1854	Muzambinho	314410	11	20430	50	muzambinhense	410
1857	Naque	314435	11	6341	50	naquense	127
1859	Natércia	314440	11	4658	25	naterciano	189
1861	Nepomuceno	314460	11	25733	44	nepomucenense	583
1863	Nova Belém	314467	11	3732	25	belenense	147
1866	Nova Módica	314490	11	3790	10	neomodicano	376
1868	Nova Porteirinha	314505	11	7398	61	novaporteirinhense	121
1870	Nova Serrana	314520	11	73699	261	nova-serranense	282
1873	Novo Oriente De Minas	314535	11	10339	14	novo orientense	755
1875	Olaria	314540	11	1976	11	olariense	178
1877	Olímpio Noronha	314550	11	2533	46	olímpio-noroense	55
1880	Onça De Pitangui	314580	11	3055	12	oncense	247
1882	Orizânia	314587	11	7284	60	orizanense	122
1885	Ouro Preto	314610	11	70281	56	ouro-pretano	1246
1887	Padre Carvalho	314625	11	5834	13	padre carvaliense	446
1889	Pai Pedro	314655	11	5934	7	paipedrense	840
1892	Paiva	314660	11	1558	27	paivense	58
1894	Palmópolis	314675	11	6931	16	palmopolense	433
1896	ParÁ De Minas	314710	11	84215	153	paraense	551
1899	Paraisópolis	314730	11	19379	59	paraisopolense	331
1901	Passa Quatro	314760	11	15582	56	passa-quatrense	277
1903	Passa Vinte	314780	11	2079	8	passa-vintense	247
1906	Patis	314795	11	5579	13	patiense	444
1907	Patos De Minas	314800	11	138710	43	patense	3190
1909	Patrocínio Do Muriaé	314820	11	5287	49	patrocinense	108
1911	Paulistas	314840	11	4918	22	paulistano	221
1914	Pedra Azul	314870	11	23839	15	pedra-azulense	1595
1916	Pedra Do Anta	314880	11	3365	21	antense	163
1918	Pedra Dourada	314900	11	2191	31	douradense	70
1921	Pedrinópolis	314920	11	3490	10	pedrinopolense	358
1923	Pedro Teixeira	314940	11	1785	16	pedro-teixeirense	113
1926	Perdigão	314970	11	8912	36	perdiguense	249
1928	Perdões	314990	11	20087	74	perdoense	271
1930	Pescador	315000	11	4128	13	pescadorense	317
1932	Piedade De Caratinga	315015	11	7110	65	piedade-caratinguense	109
1935	Piedade Dos Gerais	315040	11	4640	18	piedadense	260
1937	Pingo D`Água	315053	11	4420	66	pingodaguense	67
1940	Pirajuba	315070	11	4656	14	pirajubense	338
1942	Piranguçu	315090	11	5217	26	piranguçuense	204
1945	Pirapora	315120	11	53368	97	piraporense	550
1947	Pitangui	315140	11	25311	44	pitanguense	570
1949	Planura	315160	11	10384	33	planurense	318
1951	Poços De Caldas	315180	11	152435	279	poços-caldense	547
1954	Ponte Nova	315210	11	57390	122	ponte-novense	471
1956	Ponto Dos Volantes	315217	11	11345	9	ponto volantense	1212
1959	Poté	315240	11	15667	25	poteense	625
1961	Pouso Alto	315260	11	6213	24	pouso-altense	262
1963	Prata	315280	11	25802	5	pratense	4848
1965	Pratinha	315300	11	3265	5	pratinhense	622
1967	Presidente Juscelino	315320	11	3908	6	juscelinense	696
1970	Prudente De Morais	315360	11	9573	77	prudentino	124
1973	Raposos	315390	11	15342	213	raposense	72
1975	Recreio	315410	11	10299	44	recreiense	234
1977	Resende Costa	315420	11	10913	18	resende-costense	618
1980	Riachinho	315445	11	8007	5	riachiense	1781
1982	Ribeirão Das Neves	315460	11	296317	2	nevense	155
1984	Rio Acima	315480	11	9090	40	rio-acimense	230
1987	Rio Doce	315500	11	2465	22	rio-docense	112
1989	Rio Manso	315530	11	5276	23	rio-mansense	232
1991	Rio Paranaíba	315550	11	11885	9	rio-paraibano	1352
1994	Rio Pomba	315580	11	17110	68	rio-pombense	252
1996	Rio Vermelho	315600	11	13645	14	rio-vermelhense	987
1998	Rochedo De Minas	315620	11	2116	27	rochedense	79
2001	RosÁrio Da Limeira	315645	11	4247	38	limeirense	111
2003	Rubim	315660	11	9919	10	rubinense	965
2005	Sabinópolis	315680	11	15704	17	sabinopolense	920
2008	Salto Da Divisa	315710	11	6859	7	saltense	938
2010	Santa BÁrbara Do Leste	315725	11	7682	72	santa barbarense	107
2013	Santa Cruz De Minas	315733	11	7865	2	santacruzense	4
2015	Santa Cruz Do Escalvado	315740	11	4992	19	santa-cruzense	259
2018	Santa Helena De Minas	315765	11	6055	22	santaelenense de minas	276
2021	Santa Margarida	315790	11	15011	59	santa-margaridense	256
2023	Santa Maria Do Salto	315810	11	5284	12	santa-mariense	441
2025	Santa Rita De Caldas	315920	11	9027	18	santa-ritense	503
2028	Santa Rita De Minas	315935	11	6547	96	santa-ritense	68
2030	Santa Rita Do Sapucaí	315960	11	37754	107	santa-ritense 	353
2031	Santa Rosa Da Serra	315970	11	3224	11	rosalense	284
2032	Santa Vitória	315980	11	18138	6	santa-vitoriense	3001
2034	Santana De Cataguases	315840	11	3622	22	santanense	161
2037	Santana Do Garambéu	315870	11	2234	11	santanense	203
2039	Santana Do Manhuaçu	315890	11	8582	25	santanense	347
2042	Santana Dos Montes	315910	11	3822	19	santanense	197
2044	Santo Antônio Do Aventureiro	316000	11	3538	18	aventureirense	202
2047	Santo Antônio Do Jacinto	316030	11	11775	23	santo-antoniense	503
2049	Santo Antônio Do Retiro	316045	11	6955	9	retirense	796
2052	Santos Dumont	316070	11	46284	73	sandumonense	637
2054	São BrÁs Do Suaçuí	316090	11	3513	32	suaçuiense	110
2057	São Félix De Minas	316105	11	3382	21	são felense	163
2059	São Francisco De Paula	316120	11	6483	20	francisco-paulense	317
2061	São Francisco Do Glória	316140	11	5178	31	são-franciscano-do-glória	165
2064	São Geraldo Do Baixio	316165	11	3486	12	baixiense	281
2067	São Gonçalo Do Rio Abaixo	316190	11	9777	27	são-gonçalense	364
2069	São Gonçalo Do Sapucaí	316200	11	23906	46	são-gonçalense	517
2072	São João Da Lagoa	316225	11	4656	5	lagoano	998
2074	São João Da Ponte	316240	11	25358	14	pontense	1851
2077	São João Do Manhuaçu	316255	11	10245	72	sanjoanense	143
2079	São João Do Oriente	316260	11	7874	66	são-joanense	120
2082	São João Evangelista	316280	11	15553	33	evangelistano	478
2084	São Joaquim De Bicas	316292	11	25537	357	sanjoaquimbiquense	72
2087	São José Da Safira	316300	11	4075	19	safirense	214
2089	São José Do Alegre	316320	11	3996	45	alegrense	89
2092	São José Do Jacuri	316350	11	6553	19	jacuriense	345
2094	São Lourenço	316370	11	41657	718	são-lourenciano	58
2097	São Pedro Do Suaçuí	316410	11	5570	18	são-pedrense 	308
2100	São Roque De Minas	316430	11	6686	3	são-roquense	2099
2102	São Sebastião Da Vargem Alegre	316443	11	2798	38	são sebastião vargem alegrense	74
2105	São Sebastião Do Oeste	316460	11	5805	14	sebastianense	408
2107	São Sebastião Do Rio Preto	316480	11	1613	13	são-sebastianense	128
2111	São TomÁs De Aquino	316510	11	7093	26	aquinense	278
2113	Sapucaí Mirim	316540	11	6241	22	sapucaiense	285
2116	Sem Peixe	316556	11	2847	16	sempeixiano	177
2118	Senador Cortes	316560	11	1988	20	senador-cortense	98
2120	Senador José Bento	316580	11	1868	20	senabentense	94
2123	Senhora Do Porto	316610	11	3497	9	portuense	381
2125	Sericita	316630	11	7128	43	sericitense	166
2128	Serra Da Saudade	316660	11	815	2	serrano-saudalense	336
2130	Serra Dos Aimorés	316670	11	8412	39	serrense	214
2132	Serranópolis De Minas	316695	11	4425	8	serranopolitano de minas	552
2135	Sete Lagoas	316720	11	214152	398	sete-lagoano	538
2138	Silvianópolis	316740	11	6027	19	silvianopolense	312
2140	Simonésia	316760	11	18298	38	simonense	487
2142	Soledade De Minas	316780	11	5676	29	soledadense	197
2145	Taparuba	316805	11	3137	16	taparubense	193
2146	Tapira	316810	11	4112	3	tapirense	1179
2148	Taquaraçu De Minas	316830	11	3794	12	taquaraçuense	329
2151	Teófilo Otoni	316860	11	134745	42	teófilo-otonense	3242
2153	Tiradentes	316880	11	6961	84	tiradentino	83
2156	Tocos Do Moji	316905	11	3950	34	tocos-mogiense	115
2158	Tombos	316920	11	9537	33	tomboense	285
2160	Três Marias	316935	11	28318	11	trimariense	2678
2163	Tupaciguara	316960	11	24188	13	tupaciguarense	1824
2165	Turvolândia	316980	11	4658	21	turvolandense	221
2168	Ubaporanga	317005	11	12040	64	ubaporanguense	189
2170	Uberlândia	317020	11	604013	147	uberlandense	4115
2172	Unaí	317040	11	77565	9	unaiense	8447
2175	Urucânia	317050	11	10291	74	urucaniense	139
2177	Vargem Alegre	317057	11	6461	55	vargealegrense	117
2179	Vargem Grande Do Rio Pardo	317065	11	4733	10	vargengrandense	492
2182	VÁrzea Da Palma	317080	11	35809	16	várzea-palmense	2220
2185	Verdelândia	317103	11	8346	5	verdelandense	1571
2187	Veríssimo	317110	11	3483	3	verissimense	1032
2189	Vespasiano	317120	11	104527	1	vespasianense	71
2192	Virgem Da Lapa	317160	11	13619	16	virgem-lapense	869
2194	Virginópolis	317180	11	10572	24	virginopolitano	440
2196	Visconde Do Rio Branco	317200	11	37942	156	rio-branquense	243
2199	Água Clara	500020	12	14424	1	água-clarense	11031
2201	Amambai	500060	12	34730	8	amambaiense	4202
2204	Angélica	500085	12	9185	7	angeliquense	1273
2206	Aparecida Do Taboado	500100	12	22320	8	aparecidense 	2750
2208	Aral Moreira	500124	12	10251	6	aral-moreirense	1656
2211	Batayporã	500200	12	10936	6	bataiporãense	1828
2213	Bodoquena	500215	12	7985	3	bodoquenense	2507
2215	Brasilândia	500230	12	11826	2	brasilandense	5807
2218	Campo Grande	500270	12	786797	97	campo-grandense	8093
2220	Cassilândia	500290	12	20966	6	cassilandense	3650
2223	Coronel Sapucaia	500315	12	14064	14	sapucaense	1025
2225	Costa Rica	500325	12	19695	4	costa-riquense	5372
2228	Dois Irmãos Do Buriti	500348	12	10363	4	buritiense	2345
2230	Dourados	500370	12	196035	48	douradense	4086
2232	Fátima Do Sul	500380	12	19035	60	fátima-sulense	315
2235	Guia Lopes Da Laguna	500410	12	10366	9	lagunense	1211
2238	Itaporã	500450	12	20865	16	itaporanense	1322
2240	Ivinhema	500470	12	22341	11	ivinhemense	2010
2242	Jaraguari	500490	12	6341	2	jaraguariense	2913
2244	Jateí	500510	12	4011	2	jateiense	1928
2247	Laguna Carapã	500525	12	6491	4	lagunense 	1734
2249	Miranda	500560	12	25595	5	mirandense	5479
2251	Naviraí	500570	12	46424	15	naviraiense	3194
2253	Nova Alvorada Do Sul	500600	12	16432	4	novalvoradense	4019
2256	Paranaíba	500630	12	40192	7	paranaibano	5403
2258	Pedro Gomes	500640	12	7967	2	pedro-gomense	3651
2260	Porto Murtinho	500690	12	15372	1	murtinhense	17744
2263	Rio Negro	500730	12	5036	3	rio-negrense	1808
2265	Rochedo	500750	12	4928	3	rochedense	1561
2267	São Gabriel Do Oeste	500769	12	22203	6	gabrielense	3865
2270	Sidrolândia	500790	12	42132	8	sidrolandense	5286
2272	Tacuru	500795	12	10215	6	tacuruense	1785
2273	Taquarussu	500797	12	3518	3	taquarussuense	1041
2275	Três Lagoas	500830	12	101791	10	três-lagoense	10207
2277	Acorizal	510010	13	5516	7	acorizano	841
2279	Alta Floresta	510025	13	49164	5	alta-florestense	9212
2282	Alto Garças	510040	13	10350	3	alto-garcense	3748
2284	Alto Taquari	510060	13	8072	6	taquariense	1417
2287	Araguainha	510120	13	1096	2	araguainhense	688
2289	Arenápolis	510130	13	10316	25	arenapolitano	416
2291	Barão De Melgaço	510160	13	7591	1	melgaciano	11377
2293	Barra Do Garças	510180	13	56560	6	barra-garcense 	9079
2296	Cáceres	510250	13	87942	4	cacerense	24351
2298	Campo Novo Do Parecis	510263	13	27577	3	campo-novense	9434
2301	Canabrava Do Norte	510269	13	4786	1	canabravense	3453
2303	Carlinda	510279	13	10990	5	carlindense	2157
2305	Chapada Dos Guimarães	510300	13	17821	3	chapadense	5984
2308	Colíder	510320	13	30766	10	colidense	3094
2311	Confresa	510335	13	25124	4	confresense	5801
2312	Conquista D`Oeste	510336	13	3385	1	conquistense d?oeste	2672
2315	Curvelândia	510343	13	4866	14	curvelandenses	360
2317	Diamantino	510350	13	20341	2	diamantinense	8230
2319	Feliz Natal	510370	13	10933	1	feliz-natalenses	11462
2322	General Carneiro	510390	13	5027	1	general-carneirense	3795
2324	Guarantã Do Norte	510410	13	32216	7	guarantanhense	4735
2326	Indiavaí	510450	13	2397	4	indiavaiense	603
2329	Itaúba	510455	13	4575	1	itaubense	4528
2331	Jaciara	510480	13	25647	16	jaciarense	1654
2333	Jauru	510500	13	10455	8	jauruense	1302
2336	Juruena	510517	13	11201	3	juruenense	3223
2338	Lambari D`Oeste	510523	13	5431	3	lambarienses	1764
2340	Luciára	510530	13	2224	1	luciarense	4243
2343	Mirassol D`Oeste	510562	13	25299	24	miradolense	1076
2345	Nortelândia	510600	13	6436	5	nortelandense	1349
2347	Nova Bandeirantes	510615	13	11643	1	nova bandeirantense	9606
2350	Nova Guarita	510880	13	4932	4	nova  guaritense	1114
2352	Nova Marilândia	510885	13	2951	2	nova marilandense	1940
2354	Nova Monte Verde	510895	13	8093	2	nova monte verdense	5249
2357	Nova Olímpia	510623	13	17515	11	nova-olimpiense	1550
2359	Nova Ubiratã	510624	13	9218	1	novo-ubiratãenses	12706
2361	Novo Horizonte Do Norte	510627	13	3749	4	novo-horizontino	880
2364	Novo São Joaquim	510628	13	6042	1	são-joaquinense	5035
2366	Paranatinga	510630	13	19290	1	paranatinguense	24166
2368	Peixoto De Azevedo	510642	13	30812	2	peixotense	14257
2371	Pontal Do Araguaia	510665	13	5395	2	pontalense	2739
2373	Pontes E Lacerda	510675	13	41408	5	lacerdense	8560
2375	Porto Dos Gaúchos	510680	13	5449	1	porto-gauchense	6994
2378	Poxoréo	510700	13	17599	3	poxoreano 	6910
2380	Querência	510706	13	13033	1	querenciano	17786
2382	Ribeirão Cascalheira	510718	13	8881	1	cascalheirense	11355
2385	Rondolândia	510757	13	3604	0	rondolandense	12671
2387	Rosário Oeste	510770	13	17679	2	rosariense	7648
2390	Santa Cruz Do Xingu	510774	13	1900	0	santa-cruzense-do-xingu	5652
2392	Santa Terezinha	510777	13	7397	1	santa-terezinhense	6467
2394	Santo Antônio Do Leste	510779	13	3754	1	santo-antoniense-do-leste	3601
2396	São Félix Do Araguaia	510785	13	10625	1	são-felixcense	16712
2397	São José Do Povo	510729	13	3592	8	sãojoseenses-do-povo	444
2398	São José Do Rio Claro	510730	13	17124	4	rio-clarense	4536
2400	São José Dos Quatro Marcos	510710	13	18998	15	quatro-marquense	1289
2404	Sinop	510790	13	113099	29	sinopense	3942
2406	Tabaporã	510794	13	9932	1	tabapoaense	8317
2408	Tapurah	510800	13	10392	2	tapuraense	4511
2411	Torixoréu	510820	13	4071	2	torixorino	2399
2413	Vale De São Domingos	510835	13	3052	2	vale-dominguenses	1933
2416	Vila Bela Da Santíssima Trindade	510550	13	14493	1	vila-belense	13421
2418	Abaetetuba	150010	14	141100	88	abaetetubense	1611
2420	Acará	150020	14	53569	12	acaraense	4344
2423	Alenquer	150040	14	52626	2	alenquerense	23645
2425	Altamira	150060	14	99075	1	altamirense	159533
2427	Ananindeua	150080	14	471980	2	ananindeuense	191
2429	Augusto Corrêa	150090	14	40497	37	augusto-correense	1092
2432	Bagre	150110	14	23864	5	bagrense	4397
2434	Bannach	150125	14	3431	1	bannaquense	2957
2437	Belterra	150145	14	16318	4	belterrense	4398
2439	Bom Jesus Do Tocantins	150157	14	15298	5	bom-jesuense	2816
2441	Bragança	150170	14	113227	54	bragantino	2092
2443	Brejo Grande Do Araguaia	150175	14	7317	6	brejo-grandense	1288
2446	Bujaru	150190	14	25695	26	bujaruense	1005
2448	Cachoeira Do Piriá	150195	14	26484	11	cachoeira-piriaense	2462
2451	Capanema	150220	14	63639	104	capanemense	614
2453	Castanhal	150240	14	173149	168	castanhalense	1029
2455	Colares	150260	14	11381	19	colarense	610
2458	Cumaru Do Norte	150276	14	10466	1	curaruense 	17085
2460	Curralinho	150280	14	28549	8	curralinense 	3617
2462	Curuçá	150290	14	34294	51	curuçaense	673
2464	Eldorado Dos Carajás	150295	14	31786	11	eldoradense	2957
2467	Garrafão Do Norte	150307	14	25034	16	garrafaense	1599
2470	Igarapé Açu	150320	14	35887	46	igarapé-açuense	786
2472	Inhangapi	150340	14	10037	21	inhangapiense	471
2474	Irituia	150350	14	31364	23	irituense 	1379
2477	Jacareacanga	150375	14	14103	0	jacareacanguenses	53303
2479	Juruti	150390	14	47086	6	jurutiense	8305
2481	Mãe Do Rio	150405	14	27904	59	mãe-riense	469
2483	Marabá	150420	14	233669	15	marabaense	15128
2486	Marituba	150442	14	108246	1	maritubense	103
2488	Melgaço	150450	14	24808	4	melgacense	6774
2490	Moju	150470	14	70018	8	mojuense	9094
2493	Nova Esperança Do Piriá	150495	14	20158	7	piriaense	2810
2495	Nova Timboteua	150500	14	13670	28	timboteuense	490
2497	Novo Repartimento	150506	14	62050	4	novo-repartimentense	15399
2500	Oriximiná	150530	14	62794	1	oriximinaense	107603
2502	Ourilândia Do Norte	150543	14	27359	2	ourilandense	14339
2505	Paragominas	150550	14	97819	5	paragominense	19342
2507	Pau D`Arco	150555	14	6033	4	paudarquense	1671
2510	Placas	150565	14	23934	3	plaquense	7173
2512	Portel	150580	14	52172	2	portelense	25385
2514	Prainha	150600	14	29349	2	prainhense	14787
2516	Quatipuru	150611	14	12411	38	quatipuruense	324
2519	Rondon Do Pará	150618	14	46964	6	rondonense	8246
2521	Salinópolis	150620	14	37421	158	salinopolitano 	237
2523	Santa Bárbara Do Pará	150635	14	17141	62	santa-barbarense	278
2524	Santa Cruz Do Arari	150640	14	8155	8	arariense	1075
2525	Santa Isabel Do Pará	150650	14	59466	83	isabelense	718
2528	Santa Maria Do Pará	150660	14	23026	50	santa-marianense	458
2531	Santarém Novo	150690	14	6141	27	santareno	230
2533	São Caetano De Odivelas	150710	14	16891	23	odivelense	743
2535	São Domingos Do Capim	150720	14	29846	18	capinense	1677
2538	São Geraldo Do Araguaia	150745	14	25587	8	são-geraldense	3168
2540	São João De Pirabas	150747	14	20647	29	pirabense	706
2543	São Sebastião Da Boa Vista	150770	14	22904	14	boa-vistense	1632
2546	Soure	150790	14	23001	7	sourense	3517
2548	Terra Alta	150796	14	10262	50	terraltense	206
2551	Tracuateua	150803	14	27455	29	tracuateuense	936
2553	Tucumã	150808	14	33690	13	tucumaense	2513
2555	Ulianópolis	150812	14	43341	9	ulianopolense	5088
2558	Viseu	150830	14	56716	12	visinense 	4915
2560	Xinguara	150840	14	40573	11	xinguarense	3779
2562	Aguiar	250020	15	5530	16	aguiarense	345
2564	Alagoa Nova	250040	15	19681	161	alagoa-novense	122
2566	Alcantil	250053	15	5239	17	alcantilense 	305
2569	Amparo	250073	15	2088	17	amparense	122
2571	Araçagi	250080	15	17224	75	araçagiense 	231
2573	Araruna	250100	15	18879	77	ararunense	246
2575	Areia De Baraúnas	250115	15	1927	20	baraunense	96
2578	Assunção	250135	15	3522	28	assunçãoense	126
2580	Bananeiras	250150	15	21851	85	bananeirense	258
2582	Barra De Santa Rosa	250160	15	14157	18	santa rosense	776
2585	Bayeux	250180	15	99716	3	baienense	32
2587	Belém Do Brejo Do Cruz	250200	15	7143	12	belenense do brejo do cruz 	603
2590	Boa Vista	250215	15	6227	13	boavistense	477
2592	Bom Sucesso	250230	15	5035	27	bom-sucessense	184
2594	Boqueirão	250250	15	16888	45	boqueirãoense	372
2597	Brejo Dos Santos	250290	15	6198	66	brejo-santense	94
2599	Cabaceiras	250310	15	5035	11	cabaceirense	453
2601	Cachoeira Dos Índios	250330	15	9546	49	cachoeirense (dos Índios)	193
2604	Cacimbas	250355	15	6814	54	cacimbense	127
2606	Cajazeiras	250370	15	58446	103	cajazeirense	566
2608	Caldas Brandão	250380	15	5637	101	caldas-brandense	56
2611	Capim	250403	15	5601	72	capiense	78
2613	Carrapateira	250410	15	2378	44	carrapateirense	55
2615	Catingueira	250420	15	4812	9	catingueirense	529
2618	Conceição	250440	15	18363	32	conceiçãoense	579
2620	Conde	250460	15	21400	124	condense	173
2622	Coremas	250480	15	15149	40	coremense	379
2624	Cruz Do Espírito Santo	250490	15	16257	83	Santo espírito-santense 	196
2627	Cuité De Mamanguape	250523	15	6202	57	cuiteense	108
2629	Curral De Cima	250527	15	5209	61	curralense de cima	85
2632	Desterro	250540	15	7991	45	desterrense	179
2635	Duas Estradas	250580	15	3638	139	duas-estradense	26
2637	Esperança	250600	15	31095	190	esperancense	164
2639	Frei Martinho	250620	15	2933	12	frei-martinhense	244
2642	Gurinhém	250640	15	13872	40	gurinheense 	346
2644	Ibiara	250660	15	6031	25	ibiarense	244
2646	Imaculada	250670	15	11352	36	imaculadense	317
2649	Itaporanga	250700	15	23192	50	itaporanguense	468
2650	Itapororoca	250710	15	16997	116	itapororoquense	146
2651	Itatuba	250720	15	10201	42	itatubense	244
2653	Jericó	250740	15	7538	42	jericoense	179
2655	Joca Claudino	251365	15	2615	35	Joca-Claudinense	74
2658	Junco Do Seridó	250780	15	6643	39	juncoense	170
2661	Lagoa	250810	15	4681	26	lagoense	178
2663	Lagoa Seca	250830	15	25900	241	lagoa-sequense	108
2665	Livramento	250850	15	7164	28	livramentense	260
2667	Lucena	250860	15	11730	132	lucenense	89
2670	Mamanguape	250890	15	42303	124	mamanguapense	341
2672	Marcação	250905	15	7609	62	marcaçãoense	123
2674	Marizópolis	250915	15	6173	97	marizopolense	64
2677	Matinhas	250933	15	4321	113	matinhense	38
2679	Maturéia	250939	15	5939	71	matureense	84
2681	Montadas	250950	15	4990	158	montadense	32
2684	Mulungu	250980	15	9469	48	mulunguense	195
2686	Nazarezinho	251000	15	7280	38	nazarezinhense	191
2688	Nova Olinda	251020	15	6070	72	nova-olindense	84
2690	Olho D`Água	251040	15	6931	12	olho-daguense	596
2692	Ouro Velho	251060	15	2928	23	ouro-velhense	129
2695	Patos	251080	15	100674	213	patense	473
2697	Pedra Branca	251100	15	3721	33	pedra-branquense	113
2699	Pedras De Fogo	251120	15	27032	68	pedras-foguense	400
2702	Picuí	251140	15	18222	28	picuíense	662
2704	Pilões	251160	15	6978	108	piloense 	64
2706	Pirpirituba	251180	15	10326	129	pirpiritubense	80
2709	Poço Dantas	251203	15	3751	39	poçodantense	97
2711	Pombal	251210	15	32110	36	pombalense	889
2738	São Domingos	251396	15	2855	17	sãodominguense	169
2741	São João Do Cariri	251400	15	4344	7	caririense 	654
2744	São José Da Lagoa Tapada	251420	15	7564	22	são-joseense	342
2746	São José De Espinharas	251440	15	4760	7	espinharense	726
2749	São José Do Bonfim	251460	15	3233	24	bonfinense	135
2752	São José Dos Cordeiros	251480	15	3985	10	são-joseense (dos Cordeiros)	418
2755	São Miguel De Taipu	251500	15	6696	72	taipuense	93
2757	São Sebastião Do Umbuzeiro	251520	15	3235	7	são-sebastianense	461
2760	Serra Branca	251550	15	12973	19	serra-branquense	687
2763	Serra Redonda	251580	15	7050	126	serra-redondense	56
2765	Sertãozinho	251593	15	4395	134	sertãozienhense	33
2768	Soledade	251610	15	13739	25	soledadense	560
2770	Sousa	251620	15	65803	89	sousense	739
2772	Tacima	251640	15	10262	42	tacimense	247
2775	Teixeira	251670	15	14153	88	teixeirense	161
2776	Tenório	251675	15	2813	27	tenorense	105
2778	Uiraúna	251690	15	14584	50	uiraunense	294
2781	Vieirópolis	251720	15	5045	34	vieiropolense	147
2783	Zabelê	251740	15	2075	19	zabeleense	109
2785	Afogados Da Ingazeira	260010	16	35088	93	afogadense	378
2788	Água Preta	260040	16	33095	62	água-pretense	533
2790	Alagoinha	260060	16	13759	63	alagoinhense	218
2792	Altinho	260080	16	22353	49	altinense	454
2795	Araçoiaba	260105	16	18156	197	araçoiabense	92
2797	Arcoverde	260120	16	68793	196	arcoverdense	351
2799	Barreiros	260140	16	40732	175	barreirense	233
2801	Belém De São Francisco	260160	16	20253	11	belenense	1831
2804	Bezerros	260190	16	58668	120	bezerrense	491
2806	Bom Conselho	260210	16	45503	57	conselhense	792
2809	Brejão	260240	16	8844	55	brejonense	160
2811	Brejo Da Madre De Deus	260260	16	45180	59	brejense	762
2814	Cabo De Santo Agostinho	260290	16	185025	414	cabense	447
2816	Cachoeirinha	260310	16	18819	105	cachoeirinhense	179
2819	Calumbi	260340	16	5648	32	calumbiense	179
2821	Camocim De São Félix	260350	16	17104	236	camocinense 	72
2824	Capoeiras	260380	16	19593	58	capoeirense	336
2826	Carnaubeira Da Penha	260392	16	11782	12	carnaubeirense	1005
2829	Casinhas	260415	16	13766	119	casinhense	116
2831	Cedro	260430	16	10778	63	cedrense	172
2833	Chã Grande	260450	16	20137	237	chã-grandense	85
2835	Correntes	260470	16	17419	53	correntense 	329
2838	Cupira	260500	16	23390	222	cupirense 	106
2840	Dormentes	260515	16	16917	11	dormentense	1538
2842	Exu	260530	16	31636	24	exuense 	1337
2844	Fernando De Noronha	260545	16	2630	155	noronhense	17
2847	Floresta	260570	16	29285	8	florestano	3644
2849	Gameleira	260590	16	27912	109	gameleirense	256
2851	Glória Do Goitá	260610	16	29019	125	gloriense	232
2854	Gravatá	260640	16	76458	151	gravataense	505
2856	Ibimirim	260660	16	26954	14	ibimiriense	1955
2858	Igarassu	260680	16	102021	334	igarassuano 	306
2860	Ilha De Itamaracá	260760	16	21884	328	itamaracaense	67
2874	Jatobá	260805	16	13963	50	jatobaense	278
2876	Joaquim Nabuco	260820	16	15773	129	nabuquense	122
2879	Jurema	260840	16	14541	98	juremense 	148
2881	Lagoa Do Itaenga	260850	16	20659	361	itaenguense	57
2883	Lagoa Dos Gatos	260870	16	15615	70	lagoense 	223
2886	Limoeiro	260890	16	55439	203	limoeirense	274
2888	Machados	260910	16	13596	226	machadense	60
2890	Maraial	260920	16	12230	61	maraialense	200
2892	Moreilândia	261430	16	11132	28	moreirense	405
2895	Olinda	260960	16	377779	9	olindense	42
2897	Orocó	260980	16	13180	24	orocoense	555
2900	Palmeirina	261010	16	8189	52	palmeirinense	158
2902	Paranatama	261030	16	11001	48	paranatamense	231
2904	Passira	261050	16	28628	88	passirense	327
2906	Paulista	261070	16	300466	3	paulistano	97
2907	Pedra	261080	16	20944	26	pedrense	803
2910	Petrolina	261110	16	293962	64	petrolinense	4558
2912	Pombos	261130	16	24046	118	pomboense	204
2914	Quipapá	261150	16	24186	105	quipapaense 	231
2917	Riacho Das Almas	261170	16	19162	61	riachense	314
2919	Rio Formoso	261190	16	22151	97	rio-formosense	227
2921	Salgadinho	261210	16	9312	105	salgadinense	89
2924	Sanharó	261240	16	21955	82	sanharoense 	269
2926	Santa Cruz Da Baixa Verde	261247	16	11768	102	santacruzense	115
2928	Santa Filomena	261255	16	13371	13	filomense	1005
2931	Santa Terezinha	261280	16	10991	56	santa-terezinhense	196
2933	São Bento Do Una	261300	16	53242	74	são-bentense	719
2936	São Joaquim Do Monte	261330	16	20488	88	são-joaquinense	232
2938	São José Do Belmonte	261350	16	32617	22	belmontense	1474
2940	São Lourenço Da Mata	261370	16	102895	392	são-lourensense	262
2943	Serrita	261400	16	18331	12	serritense	1514
2945	Sirinhaém	261420	16	40296	109	sirinhaense 	369
2948	Tabira	261460	16	26427	68	tabirense	388
2950	Tacaratu	261480	16	22068	17	tacaratuense 	1265
2952	Taquaritinga Do Norte	261500	16	24903	52	taquaritinguense 	475
2955	Timbaúba	261530	16	53825	184	timbaubense	292
2957	Tracunhaém	261550	16	13055	110	tracunhaense	118
2959	Triunfo	261570	16	15006	78	triunfense	192
2962	Venturosa	261600	16	16052	50	venturosense	321
2964	Vertente Do Lério	261618	16	7873	107	vertentense do lério	74
2966	Vicência	261630	16	30732	135	vicenciense	228
2969	Acauã	220005	17	6749	5	acauãnense	1280
2971	Água Branca	220020	17	16451	170	água-branquense	97
2973	Alegrete Do Piauí	220027	17	5153	18	alegretense	283
2976	Alvorada Do Gurguéia	220045	17	5050	2	alvoradense	2132
2978	Angical Do Piauí	220060	17	6672	30	angicalense	223
2980	Antônio Almeida	220080	17	3039	5	antônio-almeidense	646
2983	Arraial	220100	17	4688	7	arraialense	683
2986	Baixa Grande Do Ribeiro	220115	17	10516	1	baixagrandense do ribeiro	7809
2988	Barras	220120	17	44850	26	barrense	1720
2990	Barro Duro	220140	17	6607	50	barro-durense	131
2992	Bela Vista Do Piauí	220155	17	3778	8	bela  vistense	499
2995	Bertolínia	220170	17	5319	4	bertolinense	1225
2998	Bocaina	220180	17	4369	16	bocainense	269
3000	Bom Princípio Do Piauí	220191	17	5304	10	bomprincipiense	522
3002	Boqueirão Do Piauí	220194	17	6193	22	boqueirãoense	278
3005	Buriti Dos Lopes	220200	17	19074	28	buritiense	691
3007	Cabeceiras Do Piauí	220205	17	9928	16	cabeceirense	609
3010	Caldeirão Grande Do Piauí	220209	17	5671	11	caldeirão grandense	495
3013	Campo Grande Do Piauí	220213	17	5592	18	campo grandense	312
3016	Canavieira	220225	17	3921	2	canavieirense	2163
3017	Canto Do Buriti	220230	17	20020	5	canto-buritiense	4326
3020	Caracol	220250	17	10212	6	caracolense	1611
3022	Caridade Do Piauí	220255	17	4826	10	caridadense	501
3025	Cocal	220270	17	26036	21	cocalense	1269
3027	Cocal Dos Alves	220272	17	5572	16	cocalalvense	358
3029	Colônia Do Gurguéia	220275	17	6036	14	coloniense	431
3030	Colônia Do Piauí	220277	17	7433	8	coloniense	948
3031	Conceição Do Canindé	220280	17	4475	5	conceiçãonense	831
3034	Cristalândia Do Piauí	220300	17	7831	7	cristalandense	1203
3036	Curimatá	220320	17	10761	5	curimataense	2338
3038	Curral Novo Do Piauí	220327	17	4869	6	curral novense	752
3041	Dirceu Arcoverde	220335	17	6675	7	arcoverdense	1017
3043	Dom Inocêncio	220345	17	9245	2	inocentino	3870
3045	Elesbão Veloso	220350	17	14512	11	elesbonense	1347
3048	Fartura Do Piauí	220375	17	5074	7	farturense	713
3050	Floresta Do Piauí	220385	17	2482	13	florestense	195
3052	Francinópolis	220400	17	5235	19	francinopolitano	269
3055	Francisco Santos	220420	17	8592	17	francisco-santense	492
3057	Geminiano	220435	17	5475	12	geminianense	463
3060	Guaribas	220455	17	4401	1	guaribano	3118
3062	Ilha Grande	220465	17	8914	66	ilhagrandense	134
3064	Ipiranga Do Piauí	220480	17	9327	18	ipiranguense	528
3066	Itainópolis	220500	17	11109	13	itainopolense	828
3069	Jaicós	220520	17	18035	21	jaicoense	865
3071	Jatobá Do Piauí	220527	17	4656	7	jatobaense	653
3074	Joaquim Pires	220540	17	13817	19	joaquim-pirense	740
3076	José De Freitas	220550	17	37085	24	freitense	1538
3078	Júlio Borges	220552	17	5373	4	julio borgense	1297
3081	Lagoa De São Francisco	220557	17	6422	41	lagoense	156
3083	Lagoa Do Piauí	220558	17	3863	9	lagoense	427
3086	Landri Sales	220560	17	5281	5	landri-salesiano	1089
3088	Luzilândia	220580	17	24721	35	luzilandense	704
3090	Manoel Emídio	220590	17	5213	3	manoel-emidense	1619
3093	Massapê Do Piauí	220605	17	6220	12	massapêense	521
3095	Miguel Alves	220620	17	32289	23	miguel-alvense	1394
3097	Milton Brandão	220635	17	6769	5	milton brandãoense	1372
3100	Monte Alegre Do Piauí	220660	17	10345	4	montealegrense	2418
3102	Morro Do Chapéu Do Piauí	220667	17	6499	20	morrochapeuense	328
3105	Nazária	220672	17	8068	22	\N	364
3107	Nossa Senhora Dos Remédios	220680	17	8206	23	remediense	358
3110	Novo Santo Antônio	220695	17	3260	7	santantoniense	482
3112	Olho D`Água Do Piauí	220710	17	2626	12	olho d?aguense	220
3115	Pajeú Do Piauí	220735	17	3363	3	pajeuense	1079
3118	Paquetá	220755	17	4147	9	paquetaense	448
3120	Parnaíba	220770	17	145705	335	parnaíbano	436
3122	Patos Do Piauí	220777	17	6105	8	patoense	752
3124	Paulistana	220780	17	19785	10	paulistanense	1970
3127	Pedro Laurentino	220793	17	2407	3	pedro laurentinense	870
3129	Pimenteiras	220810	17	11733	3	pimenteirense	4563
3131	Piracuruca	220830	17	27553	12	piracuruquense	2380
3134	Porto Alegre Do Piauí	220855	17	2559	2	porto  alegrense	1169
3136	Queimada Nova	220865	17	8553	6	queimadanovense	1352
3138	Regeneração	220880	17	17556	14	regenerense	1251
3141	Ribeiro Gonçalves	220890	17	6845	2	ribeiro-gonçalvino	3979
3143	Santa Cruz Do Piauí	220910	17	6027	10	santa-cruzense	612
3146	Santa Luz	220930	17	5513	5	santa-luzense	1187
3148	Santana Do Piauí	220935	17	4917	35	santanense	141
3150	Santo Antônio Dos Milagres	220945	17	2059	62	santoantonhense	33
3151	Santo Inácio Do Piauí	220950	17	3648	4	santinacense	853
3153	São Félix Do Piauí	220960	17	3069	5	são-felicense	657
3155	São Francisco Do Piauí	220970	17	6298	5	são-franciscano	1341
3157	São Gonçalo Do Piauí	220980	17	4754	32	são-gonçalense	150
3160	São João Da Serra	220990	17	6157	6	serra-jonense	1006
3162	São João Do Arraial	220997	17	7336	34	são jãoense	213
3165	São José Do Peixe	221010	17	3700	3	são-joseense	1287
3168	São Lourenço Do Piauí	221035	17	4427	7	lourenciano	673
3170	São Miguel Da Baixa Grande	221038	17	2110	5	sãomiquelense	384
3173	São Pedro Do Piauí	221050	17	13639	26	são-pedrense	518
3175	Sebastião Barros	221062	17	3560	4	sebastião barrense	894
3178	Simões	221070	17	14180	13	simonense	1072
3180	Socorro Do Piauí	221090	17	4522	6	socorrense	762
3182	Tamboril Do Piauí	221095	17	2753	2	tamborilense	1587
3185	União	221110	17	42654	36	unionense	1173
3187	Valença Do Piauí	221130	17	20326	15	valenciano	1335
3189	Várzea Grande	221140	17	4336	18	várzea-grandense	237
3192	Wall Ferraz	221170	17	4280	16	wal farrazense	270
3194	Adrianópolis	410020	18	6376	5	adrianopolitano 	1349
3196	Almirante Tamandaré	410040	18	103204	530	tamandareense	195
3199	Alto Paraná	410060	18	13663	34	alto-paranaense	408
3202	Alvorada Do Sul	410080	18	10283	24	alvoradense-do-sul	424
3204	Ampére	410100	18	17308	58	amperense	298
3206	Andirá	410110	18	20610	87	andiraense	236
3209	Antônio Olinto	410130	18	7351	16	antoniolintense 	470
3211	Arapongas	410150	18	104150	273	araponguense	381
3213	Arapuã	410165	18	3561	16	arapuãense	218
3216	Ariranha Do Ivaí	410185	18	2453	10	ariranhense do ivaí	240
3218	Assis Chateaubriand	410200	18	33025	34	assis-chateaubriense 	970
3220	Atalaia	410220	18	3913	28	atalaiense	138
3223	Barbosa Ferraz	410250	18	12656	24	barbosense	539
3225	Barracão	410260	18	9735	57	barraconense	172
3227	Bela Vista Do Paraíso	410280	18	15079	62	bela-vistense	243
3230	Boa Esperança Do Iguaçu	410302	18	2764	18	boaesperencense	152
3232	Boa Vista Da Aparecida	410305	18	7911	31	boa-vistense	256
3235	Bom Sucesso	410320	18	6561	20	bom-sucessense	323
3237	Borrazópolis	410330	18	7878	24	borrazopolitano	334
3240	Cafeara	410340	18	2695	15	cafearense	186
3242	Cafezal Do Sul	410347	18	4290	13	cafezalense	335
3244	Cambará	410360	18	23886	65	cambaraense	366
3247	Campina Da Lagoa	410390	18	15394	19	campinense-da-lagoa	797
3249	Campina Grande Do Sul	410400	18	38769	72	campinense-do-sul	539
3251	Campo Do Tenente	410410	18	7125	23	tenentiano 	304
3254	Campo Mourão	410430	18	87194	115	campo-mourense	758
3256	Candói	410442	18	14983	10	candoianos	1513
3259	Capitão Leônidas Marques	410460	18	14970	54	leônidas-marquesiense 	276
3261	Carlópolis	410470	18	13706	30	carlopolitano 	451
3264	Catanduvas	410500	18	10202	18	catanduvense	582
3266	Cerro Azul	410520	18	16938	13	cerro-azulense	1341
3268	Chopinzinho	410540	18	19679	21	chopinzinhense	960
3270	Cidade Gaúcha	410560	18	11062	27	cidade-gauchense 	403
3274	Congonhinhas	410600	18	8279	15	congonhinhense	536
3275	Conselheiro Mairinck	410610	18	3636	18	mairinquense	205
3277	Corbélia	410630	18	16312	31	corbeliano 	529
3279	Coronel Domingos Soares	410645	18	7238	5	dominguense	1576
3282	Cruz Machado	410680	18	18040	12	cruz-machadense	1478
3284	Cruzeiro Do Oeste	410660	18	20416	26	cruzeirense 	779
3287	Curitiba	410690	18	1751907	4	curitibano	435
3289	Diamante D`Oeste	410715	18	5027	16	sul-diamantino 	309
3291	Diamante Do Sul	410712	18	3510	10	diamantense 	360
3294	Doutor Camargo	410730	18	5828	49	camarguense	118
3296	Enéas Marques	410740	18	6103	32	enéas-marquense	192
3299	Esperança Nova	410752	18	1970	14	esperançanovense	139
3301	Farol	410755	18	3472	12	farolense	289
3303	Fazenda Rio Grande	410765	18	81675	700	fazendense	117
3306	Figueira	410775	18	8293	64	figueirense	130
3308	Floraí	410780	18	5050	26	floraiense	191
3310	Florestópolis	410800	18	11222	46	florestopolitano	246
3312	Formosa Do Oeste	410820	18	7541	27	formosense-do-oeste 	276
3315	Francisco Alves	410832	18	6418	20	alvense	322
3317	General Carneiro	410850	18	13669	13	carneirense	1070
3320	Goioxim	410865	18	7503	11	goioxinhense	702
3322	Guaíra	410880	18	30704	55	guairense	560
3324	Guamiranga	410895	18	7900	32	guamiranguense	245
3327	Guaraci	410920	18	5227	25	guaraciense	212
3329	Guarapuava	410940	18	167328	54	guarapuavano	3116
3331	Guaratuba	410960	18	32095	24	guaratubense 	1326
3333	Ibaiti	410970	18	28751	32	ibaitiense	898
3336	Icaraíma	410990	18	8839	13	icaraimense	675
3338	Iguatu	411005	18	2234	21	iguatuense	107
3340	Imbituva	411010	18	28455	38	imbituvense	757
3342	Inajá	411030	18	2988	15	inajaense	195
3345	Iporã	411060	18	14981	23	iporãnense	648
3347	Irati	411070	18	56207	56	iratiense	1000
3349	Itaguajé	411090	18	4568	24	itaguajeense	190
3351	Itambaracá	411100	18	6759	33	itambaracaense	207
3353	Itapejara D`Oeste	411120	18	10531	41	itapejarense	254
3356	Ivaí	411140	18	12815	21	ivaiense	608
3358	Ivaté	411155	18	7514	18	ivateense	411
3361	Jacarezinho	411180	18	39121	65	jacarezinhense	603
3363	Jaguariaíva	411200	18	32606	22	jaguariaivense	1453
3365	Janiópolis	411220	18	6532	19	janiopolitano	336
3367	Japurá	411240	18	8549	52	japuraense	165
3369	Jardim Olinda	411260	18	1409	11	jardinolindense	129
3372	Joaquim Távora	411280	18	10736	37	tavorense	289
3374	Juranda	411295	18	7641	22	jurandense	350
3377	Lapa	411320	18	44932	21	lapeano	2094
3379	Laranjeiras Do Sul	411330	18	30777	46	laranjeirense-do-sul	672
3381	Lidianópolis	411342	18	3973	25	lidianopolitano	159
3384	Lobato	411360	18	4401	18	lobatense	241
3386	Luiziana	411373	18	7315	8	luizianense	909
3388	Lupionópolis	411380	18	4592	38	lupionopolense 	121
3391	Mandaguaçu	411410	18	19781	67	mandaguaçuense	294
3393	Mandirituba	411430	18	22220	59	mandiritubano 	379
3395	Mangueirinha	411440	18	17048	16	mangueirinhense	1055
3397	Marechal Cândido Rondon	411460	18	46819	63	rondonense	748
3400	Marilândia Do Sul	411490	18	8863	23	marilandense	384
3402	Mariluz	411510	18	10224	24	mariluzense	433
3403	Maringá	411520	18	357077	732	maringaense	488
3405	Maripá	411535	18	5684	20	maripaense	284
3407	Marquinho	411545	18	4981	10	marquinhense	511
3410	Matinhos	411570	18	29428	250	matinhense	118
3412	Mauá Da Serra	411575	18	8555	79	mauaense da serra	108
3414	Mercedes	411585	18	5046	25	mercedense	201
3417	Missal	411605	18	10474	32	missalense	324
3419	Morretes	411620	18	15718	23	morretense 	685
3421	Nossa Senhora Das Graças	411640	18	3836	21	gracense	186
3423	Nova América Da Colina	411660	18	3478	27	nova-americanense	129
3426	Nova Esperança	411690	18	26615	66	nova-esperancense	402
3428	Nova Fátima	411700	18	8147	29	fatimense	283
3430	Nova Londrina	411710	18	13067	49	nova-londrinense	269
3433	Nova Santa Bárbara	411721	18	3908	54	bárbaraense	72
3436	Novo Itacolomi	411729	18	2827	18	itacolomiense	161
3438	Ourizona	411740	18	3380	19	ourizonense	176
3440	Paiçandu	411750	18	35936	210	paiçanduense	171
3443	Palmital	411780	18	14865	18	palmitalense	818
3445	Paraíso Do Norte	411800	18	11772	58	paraisense-do-norte 	205
3447	Paranaguá	411820	18	140469	170	parnanguara	827
3450	Pato Bragado	411845	18	4822	36	pato bragadense	135
3452	Paula Freitas	411860	18	5434	13	paula-freitense 	420
3454	Peabiru	411880	18	13624	29	peabiruense	469
3457	Pérola D`Oeste	411900	18	6761	33	pérola-oestense 	206
3459	Pinhais	411915	18	117008	2	pinhaense	61
3461	Pinhalão	411920	18	6215	28	pinhalense ou pinhalãoense	221
3464	Piraquara	411950	18	93207	411	piraquarense	227
3466	Pitangueiras	411965	18	2814	23	pitangueirense	123
3468	Planalto	411980	18	13654	39	planaltense 	346
3471	Porecatu	412000	18	14189	49	porecatuense	292
3473	Porto Barreiro	412015	18	3663	10	porto barreirense	361
3475	Porto Vitória	412030	18	4020	19	porto-vitoriense	212
3478	Presidente Castelo Branco	412040	18	4784	31	castelo-branquense 	156
3480	Prudentópolis	412060	18	48792	21	prudentopolitano	2309
3482	Quatiguá	412070	18	7045	63	quatiguaense	113
3484	Quatro Pontes	412085	18	3803	33	quatro pontense	114
3487	Quinta Do Sol	412110	18	5088	16	quinta-solense 	326
3489	Ramilândia	412125	18	4134	17	ramilandiense	237
3491	Rancho Alegre D`Oeste	412135	18	2847	12	rancho alegrense	241
3494	Renascença	412160	18	6812	16	renascenseano 	425
3496	Reserva Do Iguaçu	412175	18	7307	9	reservense do iguçú	834
3498	Ribeirão Do Pinhal	412190	18	13524	36	ribeiro-pinhalense	375
3501	Rio Bonito Do Iguaçu	412215	18	13661	18	rio bonitense	746
3504	Rio Negro	412230	18	31274	52	rio-negrense	603
3506	Roncador	412250	18	11537	16	roncadorense 	742
3508	Rosário Do Ivaí	412265	18	5588	15	rosariense	371
3511	Salto Do Itararé	412290	18	5178	26	saltense-do-itararé 	201
3513	Santa Amélia	412310	18	3803	49	ameliense	78
3515	Santa Cruz De Monte Castelo	412330	18	8092	18	monte-castelense	442
3518	Santa Inês	412360	18	1818	13	santa-ineense	138
3520	Santa Izabel Do Oeste	412380	18	13132	41	santa-izabelense 	321
3523	Santa Mariana	412390	18	12435	29	santa-marianense	427
3525	Santa Tereza Do Oeste	412402	18	10332	32	santa-terezense 	326
3527	Santana Do Itararé	412400	18	5249	21	santanense	251
3528	Santo Antônio Da Platina	412410	18	42707	59	platinense	721
3531	Santo Antônio Do Sudoeste	412440	18	18893	58	santo-antoniense	326
3533	São Carlos Do Ivaí	412460	18	6354	28	são-carlense	225
3536	São João Do Caiuá	412490	18	5911	19	caiuense 	304
3539	São Jorge D`Oeste	412520	18	9085	24	são-jorgense ou jorgense	380
3541	São Jorge Do Patrocínio	412535	18	6041	15	patrocinense	405
3544	São José Dos Pinhais	412550	18	264210	279	são-joseense	946
3547	São Miguel Do Iguaçu	412570	18	25769	30	são-miguelense	851
3549	São Pedro Do Ivaí	412580	18	10167	32	ivaiense 	323
3551	São Sebastião Da Amoreira	412600	18	8626	38	amoreirense	228
3554	Sarandi	412625	18	82847	802	sarandiense	103
3557	Serranópolis Do Iguaçu	412635	18	4568	9	serranopolitano	484
3559	Sertanópolis	412650	18	15638	31	sertanopolense	506
3562	Tamarana	412667	18	12262	26	tamaraense	472
3564	Tapejara	412680	18	14598	25	tapejarense	591
3566	Teixeira Soares	412700	18	10283	11	teixeira-soarense	903
3569	Terra Rica	412730	18	15221	22	terra-riquense	701
3571	Tibagi	412750	18	19344	7	tibagiense	2952
3573	Toledo	412770	18	119313	100	toledense	1197
3575	Três Barras Do Paraná	412785	18	11824	23	tribarrense	504
3578	Tupãssi	412795	18	7997	26	tupãciense	311
3580	Ubiratã	412800	18	21558	33	ubiratãense	653
3582	União Da Vitória	412820	18	52735	73	união-vitoriense	720
3585	Ventania	412853	18	9957	13	ventaniense	759
3587	Verê	412860	18	7878	25	vereense	312
3590	Wenceslau Braz	412850	18	19298	49	brazense 	398
3592	Angra Dos Reis	330010	19	169511	205	angrense	825
3595	Areal	330022	19	11423	103	arealense	111
3597	Arraial Do Cabo	330025	19	27715	173	cabista	160
3599	Barra Mansa	330040	19	177813	325	barra-mansense	547
3602	Bom Jesus Do Itabapoana	330060	19	35411	59	bom-jesuense	599
3604	Cachoeiras De Macacu	330080	19	54273	57	cachoeirense	954
3607	Cantagalo	330110	19	19830	26	cantagalense	749
3609	Cardoso Moreira	330115	19	12600	24	cardosense	525
3612	Comendador Levy Gasparian	330095	19	8180	77	gaspariense	107
3614	Cordeiro	330150	19	20430	176	cordeirense	116
3616	Duque De Caxias	330170	19	855048	2	caxiense	468
3619	Iguaba Grande	330187	19	22851	440	iguabense	52
3622	Italva	330205	19	14063	48	italvense	294
3624	Itaperuna	330220	19	95841	87	itaperunense	1105
3626	Japeri	330227	19	95492	1	japeriense	82
3629	Macuco	330245	19	5269	68	macuquense	78
3631	Mangaratiba	330260	19	36456	103	mangaratibano	353
3633	Mendes	330280	19	17935	185	mendense	97
3635	Miguel Pereira	330290	19	24642	85	miguelense	289
3638	Nilópolis	330320	19	157425	8	nilopolitano	19
3640	Nova Friburgo	330340	19	182082	195	friburguense	933
3643	Paraíba Do Sul	330370	19	41084	71	sul-paraibano 	581
3645	Paty Do Alferes	330385	19	26359	83	patiense	319
3647	Pinheiral	330395	19	22719	297	pinheiralense	77
3650	Porto Real	330411	19	16592	327	porto realense	51
3651	Quatis	330412	19	12793	45	quatiense	286
3652	Queimados	330414	19	137962	2	queimadense	76
3654	Resende	330420	19	119769	109	resendense	1095
3656	Rio Claro	330440	19	17425	21	rio-clarense	841
3658	Rio Das Ostras	330452	19	105676	461	rio ostrense	229
3661	Santo Antônio De Pádua	330470	19	40589	67	paduano	603
3663	São Francisco De Itabapoana	330475	19	41354	37	são franciscano	1122
3666	São João De Meriti	330510	19	458673	13	meritiense	35
3669	São Pedro Da Aldeia	330520	19	87875	264	aldeiense	333
3672	Saquarema	330550	19	74234	210	saquaremense	354
3674	Silva Jardim	330560	19	21349	23	silva-jardinense	938
3677	Teresópolis	330580	19	163746	212	teresopolitano	771
3679	Três Rios	330600	19	77432	237	trirriense	326
3682	Vassouras	330620	19	34410	64	vassourense	538
3683	Volta Redonda	330630	19	257803	1	volta-redondense	182
3686	Afonso Bezerra	240030	20	10844	19	afonso-bezerrense	576
3689	Almino Afonso	240060	20	4871	38	almino-afonsense	128
3691	Angicos	240080	20	11549	16	angicano	742
3693	Apodi	240100	20	34763	22	apodiense	1602
3695	Arês	240120	20	12924	112	aresense	116
3697	Baía Formosa	240140	20	8573	35	baía-formosense	246
3700	Bento Fernandes	240160	20	5113	17	bento-fernandense	301
3702	Bom Jesus	240170	20	9440	77	bom-jesuense	122
3704	Caiçara Do Norte	240185	20	6016	32	caiçarense do norte	190
3707	Campo Redondo	240210	20	10266	48	campo-redondense	214
3709	Caraúbas	240230	20	19576	18	caraubense	1095
3711	Carnaubais	240250	20	9762	18	carnaubaense	543
3714	Coronel Ezequiel	240280	20	5405	29	coronel-ezequielense	186
3716	Cruzeta	240300	20	7967	27	cruzetense	296
3718	Doutor Severiano	240320	20	6492	60	severianense	108
3721	Espírito Santo	240350	20	10475	77	espírito-santense	136
3723	Felipe Guerra	240370	20	5734	21	felipe-guerrense 	269
3725	Florânia	240380	20	8959	18	floraniense	505
3727	Frutuoso Gomes	240400	20	4233	67	frutuoso-gomense	63
3730	Governador Dix Sept Rosado	240430	20	12374	11	dix-septiense	1129
3733	Ielmo Marinho	240460	20	12171	39	ielmo-marinhense	312
3735	Ipueira	240480	20	2077	16	ipueirense	127
3737	Itaú	240490	20	5564	42	itauense	133
3740	Janduís	240520	20	5345	18	janduiense	305
3742	Japi	240540	20	5522	29	japiense	189
3744	Jardim De Piranhas	240560	20	13506	41	piranhense 	331
3746	João Câmara	240580	20	32227	45	camarense	715
3749	Jucurutu	240610	20	17692	19	jucurutuense	934
3751	Lagoa D`Anta	240620	20	6227	59	lagoa-velhense	106
3754	Lagoa Nova	240650	20	13983	79	lagoa-novense	176
3756	Lajes	240670	20	10381	15	lajense	677
3758	Lucrécia	240690	20	3633	117	lucreciano	31
3760	Macaíba	240710	20	69467	136	macaibense	511
3763	Marcelino Vieira	240730	20	8265	24	marcelinense 	346
3765	Maxaranguape	240750	20	10441	80	maxaranguapense	131
3767	Montanhas	240770	20	11413	139	montanhense	82
3769	Monte Das Gameleiras	240790	20	2261	31	monte-gameleirense	72
3772	Nísia Floresta	240820	20	23784	77	nísia-florestense	308
3774	Olho D`Água Do Borges	240840	20	4295	30	olho-d'água-borgense	141
3777	Paraú	240870	20	3859	10	parauense	383
3778	Parazinho	240880	20	4845	18	parazinhense	275
3780	Parnamirim	240325	20	202456	2	parnamirinense	124
3782	Passagem	240920	20	2895	70	passagense	41
3784	Pau Dos Ferros	240940	20	27745	107	pau-ferrense	260
3787	Pedro Avelino	240970	20	7171	8	pedro-avelinense	953
3790	Pilões	241000	20	3453	42	pilonense	83
3791	Poço Branco	241010	20	13949	61	poço-branquense	230
3794	Presidente Juscelino	241030	20	8768	52	juscelinense	167
3797	Rafael Godeiro	241060	20	3063	31	rafael-godeirense	100
3799	Riacho De Santana	241080	20	4156	32	riacho-santanense	128
3802	Rodolfo Fernandes	241100	20	4418	29	rodolfo-fernandense 	155
3804	Santa Cruz	241120	20	35797	57	santa-cruzense	624
3806	Santana Do Matos	241140	20	13809	10	santanense	1419
3808	Santo Antônio	241150	20	22216	74	santo-antoniense	301
3811	São Fernando	241180	20	3401	8	são-fernandense	404
3813	São Gonçalo Do Amarante	241200	20	87668	352	gonçalense	249
3816	São José Do Campestre	241230	20	12356	36	campestrense	341
3818	São Miguel	241250	20	22157	129	são-miguelense 	172
3820	São Paulo Do Potengi	241260	20	15843	66	potengiense	240
3823	São Tomé	241290	20	10827	13	são-tomeense	863
3825	Senador Elói De Souza	241310	20	5637	34	elói-de-souzense	168
3828	Serra Do Mel	241335	20	10287	17	serrano	617
3830	Serrinha	241350	20	6581	34	serrinhense	193
3832	Severiano Melo	241360	20	5752	36	severianense	158
3835	Taipu	241390	20	11836	34	taipuense	353
3837	Tenente Ananias	241410	20	9883	44	tenente-ananiense	224
3839	Tibau	241105	20	3687	22	tibauense	169
3841	Timbaúba Dos Batistas	241430	20	2295	17	timbaubense	135
3844	Umarizal	241450	20	10659	50	umarizalense 	214
3846	Várzea	241470	20	5236	72	varzeano	73
3849	Viçosa	241490	20	1618	43	viçosense	38
3851	Alta Floresta D`Oeste	110001	21	24392	3	alta-florense	7067
3853	Alto Paraíso	110040	21	17135	6	alto-paraisense	2652
3856	Buritis	110045	21	32383	10	buritisense	3266
3858	Cacaulândia	110060	21	5736	3	cacaulandense	1962
3860	Campo Novo De Rondônia	110070	21	12665	4	campo-novense	3442
3863	Cerejeiras	110005	21	17029	6	cerejeirense	2783
3865	Colorado Do Oeste	110006	21	18591	13	coloradense	1451
3868	Cujubim	110094	21	15854	4	cujubiense	3864
3870	Governador Jorge Teixeira	110100	21	10512	2	jorge-teixeirense	5067
3873	Jaru	110011	21	52005	18	jaruense	2944
3875	Machadinho D`Oeste	110013	21	31135	4	machadinhense	8509
3877	Mirante Da Serra	110130	21	11878	10	mirantense	1192
3880	Nova Mamoré	110033	21	22546	2	nova-mamorense	10072
3882	Novo Horizonte Do Oeste	110050	21	10240	12	novo-horizontino	843
3885	Pimenta Bueno	110018	21	33822	5	pimenta-buenense	6241
3887	Porto Velho	110020	21	428527	13	porto-velhense	34096
3889	Primavera De Rondônia	110147	21	3524	6	primaverense	606
3892	Santa Luzia D`Oeste	110029	21	8886	7	santa-luziense	1198
3894	São Francisco Do Guaporé	110149	21	16035	1	são-francisquense	10960
3897	Teixeirópolis	110155	21	4888	11	teixeirense	460
3900	Vale Do Anari	110175	21	9384	3	anariense	3135
3901	Vale Do Paraíso	110180	21	8210	9	vale-paraisense	966
3904	Amajari	140002	22	9327	0	amajariense	28472
3906	Bonfim	140015	22	10943	1	bonfinense	8095
3908	Caracaraí	140020	22	18398	0	caracaraiense	47411
3910	Iracema	140028	22	8696	1	iracemense	14410
3913	Pacaraima	140045	22	10433	1	pacaraimense	8028
3915	São João Da Baliza	140050	22	6769	2	baliziense	4285
3918	Aceguá	430003	23	4394	3	aceguaense	1549
3920	Agudo	430010	23	16722	31	agudense	536
3922	Alecrim	430030	23	7045	22	alecrinense	315
3924	Alegria	430045	23	4301	25	alegriense	173
3926	Alpestre	430050	23	8027	24	alpestrense	329
3928	Alto Feliz	430057	23	2917	37	alto-felizense	79
4109	Herveiras	430957	23	2954	25	herveirense	118
3931	Ametista Do Sul	430064	23	7323	78	ametistense	93
3933	Anta Gorda	430070	23	6073	25	anta-gordense	243
3935	Arambaré	430085	23	3693	7	arambarense	519
3938	Arroio Do Meio	430100	23	18783	119	arroio-meense	158
3940	Arroio Do Sal	430105	23	7740	64	arroio-salense	121
3943	Arroio Grande	430130	23	18470	7	arroio-grandense	2514
3945	Augusto Pestana	430150	23	7096	20	augusto-pestanense	347
3948	Balneário Pinhal	430163	23	10856	105	pinhalense	104
3950	Barão De Cotegipe	430170	23	6529	25	cotegipense	260
3952	Barra Do Guarita	430185	23	3089	48	barra-guaritense	65
3955	Barra Do Rio Azul	430192	23	2003	14	barra-azulense	147
3958	Barros Cassal	430200	23	11133	17	barros-cassalense	649
3960	Bento Gonçalves	430210	23	107278	281	bento-gonçalvense	382
3962	Boa Vista Do Buricá	430220	23	6574	60	boa-vistense	109
3965	Boa Vista Do Sul	430225	23	2776	29	boavistense	94
3967	Bom Princípio	430235	23	11789	133	bom-principiense	89
3970	Boqueirão Do Leão	430245	23	7673	29	léo-boqueirense	265
3972	Bozano	430258	23	2200	11	bozanense	201
3975	Butiá	430270	23	20406	27	butiaense	752
3977	Cacequi	430290	23	13676	6	cacequiense	2370
3979	Cachoeirinha	430310	23	118278	3	cachoeirinhense	44
3982	Caiçara	430340	23	5071	27	caiçarense	189
3984	Camargo	430355	23	2592	19	camarguense	138
3986	Campestre Da Serra	430367	23	3247	6	campestrense	538
3988	Campinas Do Sul	430380	23	5506	20	campinense	276
3991	Campos Borges	430410	23	3494	15	campos-borgense	227
3993	Cândido Godói	430430	23	6535	27	godoiense	246
3996	Canguçu	430450	23	53259	15	canguçuense	3525
3998	Canudos Do Vale	430461	23	1807	22	canudense do vale	82
4000	Capão Da Canoa	430463	23	42040	433	caponense	97
4003	Capela De Santana	430468	23	11612	63	capelense	184
4005	Capivari Do Sul	430467	23	3890	9	capivariense	413
4008	Carlos Barbosa	430480	23	25192	110	barbosense	229
4010	Casca	430490	23	8651	32	casquense	272
4013	Caxias Do Sul	430510	23	435564	265	caxiense	1644
4015	Cerrito	430512	23	6402	14	cerritense	452
4017	Cerro Grande	430515	23	2417	33	cerro-grandense	73
4019	Cerro Largo	430520	23	13289	75	cerro-larguense	178
4022	Charrua	430537	23	3471	18	charruense	198
4024	Chuí	430543	23	5917	29	chuiense	203
4026	Cidreira	430545	23	12668	52	cidreirense	246
4027	Ciríaco	430550	23	4922	18	ciriaquense	274
4029	Colorado	430560	23	3550	12	coloradense	285
4031	Constantina	430580	23	9752	48	constantinense	203
4033	Coqueiros Do Sul	430585	23	2457	9	coqueirense	276
4035	Coronel Bicaco	430590	23	7748	16	bicaquense	492
4038	Coxilha	430597	23	2826	7	coxilhense	423
4040	Cristal	430605	23	7280	11	cristalense	682
4042	Cruz Alta	430610	23	62821	46	cruzaltense	1360
4044	Cruzeiro Do Sul	430620	23	12320	79	cruzeirense	156
4047	Dezesseis De Novembro	430635	23	2866	13	dezesseis-novembrense	217
4049	Dois Irmãos	430640	23	27572	423	dois-irmãosense	65
4052	Dom Feliciano	430650	23	14380	11	felicianense	1356
4279	Santa Clara Do Sul	431675	23	5697	66	santa-clarense	87
4054	Dom Pedro De Alcântara	430655	23	2550	33	dom-pedro-alcantarense	78
4057	Doutor Ricardo	430675	23	2030	19	ricardense	108
4060	Encruzilhada Do Sul	430690	23	24534	7	encruzilhadense	3348
4062	Entre Rios Do Sul	430695	23	3080	26	entre-rio-sulense	120
4064	Erebango	430697	23	2970	19	erebanguense	153
4067	Erval Grande	430720	23	5163	18	erval-grandense	286
4069	Esmeralda	430740	23	3168	4	esmeraldense	830
4071	Espumoso	430750	23	15240	19	espumosense	783
4073	Estância Velha	430760	23	42574	816	estanciense	52
4076	Estrela Velha	430781	23	3628	13	estrelavelhense	282
4078	Fagundes Varela	430786	23	2579	19	fagundense	134
4081	Faxinalzinho	430805	23	2567	18	faxinalzinhense	143
4083	Feliz	430810	23	12359	130	felizense	95
4085	Floriano Peixoto	430825	23	2018	12	florianense	168
4088	Forquetinha	430843	23	2479	26	forquetinhense	94
4090	Frederico Westphalen	430850	23	28843	109	westphalense	265
4093	Gaurama	430870	23	5862	29	gauramense	204
4095	Gentil	430885	23	1677	9	gentilense	184
4097	Giruá	430900	23	17075	20	giruaense	856
4100	Gramado Dos Loureiros	430912	23	2269	17	loureirense	131
4102	Gravataí	430920	23	255660	552	gravataiense	464
4104	Guaíba	430930	23	95204	253	guaibense	377
4106	Guarani Das Missões	430950	23	8115	28	guaraniense	290
4112	Humaitá	430970	23	4919	37	humaitaense	135
4114	Ibiaçá	430980	23	4710	14	ibiaçaense	349
4116	Ibirapuitã	430995	23	4061	13	ibirapuitanense	307
4118	Igrejinha	431010	23	31660	233	igrejinhense	136
4121	Imbé	431033	23	17670	449	Imbeense	39
4123	Independência	431040	23	6618	19	independenciense	357
4126	Ipiranga Do Sul	431046	23	1944	12	ipiranguense	158
4128	Itaara	431053	23	5010	29	itaarense	173
4130	Itapuca	431057	23	2344	13	itapuquense	184
4133	Itatiba Do Sul	431070	23	4171	20	itatibense	212
4135	Ivoti	431080	23	19874	315	ivotiense	63
4137	Jacuizinho	431087	23	2507	7	jacuizinhense	339
4140	Jaguari	431110	23	11473	17	jaguariense	673
4142	Jari	431113	23	3575	4	jariense	856
4144	Júlio De Castilhos	431120	23	19579	10	castilhense	1929
4146	Lagoa Dos Três Cantos	431127	23	1598	12	três-cantense	139
4149	Lajeado	431140	23	71445	793	lajeadense	90
4151	Lavras Do Sul	431150	23	7679	3	lavrense	2601
4154	Linha Nova	431164	23	1624	25	linha-novense	64
4155	Maçambara	431171	23	4738	3	maçambarense	1683
4157	Mampituba	431173	23	3003	19	mampitubense	158
4159	Maquiné	431177	23	6905	11	maquinense	622
4162	Marcelino Ramos	431190	23	5134	22	marcelinense	230
4164	Mariano Moro	431200	23	2210	22	marianense	99
4167	Mato Castelhano	431213	23	2470	10	mato-castelhanense	238
4169	Mato Queimado	431217	23	1799	16	matoqueimadense	115
4172	Miraguaí	431230	23	4855	37	miraguaiense	130
4174	Monte Alegre Dos Campos	431237	23	3102	6	montealegrense	550
4177	Mormaço	431242	23	2749	19	mormacense	146
4179	Morro Redondo	431245	23	6227	25	morro-redondense	245
4181	Mostardas	431250	23	12124	6	mostardense	1983
4183	Muitos Capões	431261	23	2988	2	caponense	1198
4186	Nicolau Vergueiro	431267	23	1721	11	nicolau-vergueirense	156
4188	Nova Alvorada	431275	23	3182	21	nova-alvoradense	149
4191	Nova Boa Vista	431295	23	1960	21	boa-vistense	94
4193	Nova Candelária	431301	23	2751	28	nova-candelariense	98
4196	Nova Pádua	431308	23	2450	24	paduense	103
4198	Nova Petrópolis	431320	23	19045	65	nova-petropolitano	291
4200	Nova Ramada	431333	23	2437	10	morador de nova rama	255
4202	Nova Santa Rita	431337	23	22716	104	nova-santaritense	218
4205	Novo Hamburgo	431340	23	238940	1	novo-hamburguense	224
4207	Novo Tiradentes	431344	23	2277	30	tiradentense	75
4210	Paim Filho	431360	23	4243	23	paim-filhense	182
4212	Palmeira Das Missões	431370	23	34328	24	palmeirense	1419
4215	Pantano Grande	431395	23	9895	12	pantanense	841
4217	Paraíso Do Sul	431402	23	7336	22	paraisense	338
4220	Passa Sete	431406	23	5154	17	passasetense	305
4221	Passo Do Sobrado	431407	23	6011	23	passo-sobradense	265
4224	Paverama	431415	23	8044	47	paveramense	172
4226	Pedro Osório	431420	23	7811	13	pedro-osoriense	609
4229	Picada Café	431442	23	5182	61	picadense	85
4231	Pinhal Da Serra	431446	23	2130	5	pinhalense	437
4234	Pinheiro Machado	431450	23	12780	6	pinheirense	2250
4236	Piratini	431460	23	19841	6	piratinense	3540
4238	Poço Das Antas	431475	23	2017	31	poçandense	65
4241	Portão	431480	23	30920	193	portanense	160
4243	Porto Lucena	431500	23	5413	22	porto-lucenense	250
4245	Porto Vera Cruz	431507	23	1852	16	porto-vera-cruzense	114
4248	Presidente Lucena	431514	23	2484	50	lucinense	49
4250	Protásio Alves	431517	23	2000	12	protásio-alvense	173
4253	Quatro Irmãos	431531	23	1775	7	quatroirmanense	268
4255	Quinze De Novembro	431535	23	3653	16	quinze-novembrense	224
4258	Restinga Seca	431550	23	15849	17	restinguense	956
4260	Rio Grande	431560	23	197228	73	rio-grandino	2710
4262	Riozinho	431575	23	4330	18	riozinhense	240
4265	Rolador	431595	23	2546	9	roladorense	295
4267	Ronda Alta	431610	23	10221	24	ronda-altense	419
4269	Roque Gonzales	431630	23	7203	21	roque-gonzalense	347
4272	Saldanha Marinho	431643	23	2869	13	saldanhense	222
4274	Salvador Das Missões	431647	23	2669	28	salvadorense	94
4277	Santa Bárbara Do Sul	431670	23	8829	9	santa-barbarense	976
4280	Santa Cruz Do Sul	431680	23	118374	161	santa-cruzense	733
4281	Santa Margarida Do Sul	431697	23	2352	2	margaridense 	955
4283	Santa Maria Do Herval	431695	23	6053	43	hervalense	140
4286	Santa Vitória Do Palmar	431730	23	30990	6	vitoriense	5244
4288	Santana Do Livramento	431710	23	82464	12	santanense	6950
4291	Santo Antônio Da Patrulha	431760	23	39685	38	patrulhense	1050
4293	Santo Antônio Do Palma	431755	23	2139	17	palmense	126
4295	Santo Augusto	431780	23	13968	30	santo-augustense	468
4298	São Borja	431800	23	61671	17	são borjense	3616
4300	São Francisco De Assis	431810	23	19254	8	assisense	2508
4303	São Jerônimo	431840	23	22134	24	jeronimense	936
4305	São João Do Polêsine	431843	23	2635	31	polesinense	85
4308	São José Do Herval	431846	23	2204	21	hervalense	103
4310	São José Do Inhacorá	431849	23	2200	28	inhacoraense	78
4313	São José Do Sul	431861	23	2082	35	são josense do sul	59
4316	São Lourenço Do Sul	431880	23	43111	21	lourenciano	2036
4319	São Martinho	431910	23	5773	34	são-martinhense	172
4321	São Miguel Das Missões	431915	23	7421	6	miguelino	1230
4528	Indaial	420750	24	54854	127	indaialense	431
4323	São Paulo Das Missões	431930	23	6364	28	paulista-das-missões	224
4326	São Pedro Do Butiá	431937	23	2873	27	são-butiaiense	108
4329	São Sepé	431960	23	23798	11	sepense	2201
4331	São Valentim Do Sul	431971	23	2168	24	são-valentinense	92
4334	São Vicente Do Sul	431980	23	8440	7	vicentino	1175
4336	Sapucaia Do Sul	432000	23	130957	2	sapucaiense	58
4339	Sede Nova	432023	23	3011	25	sede-novense	119
4341	Selbach	432030	23	4929	28	selbaquense	178
4343	Sentinela Do Sul	432035	23	5198	18	sentinelense	282
4346	Sertão	432050	23	6294	14	sertanense	439
4348	Sete De Setembro	432057	23	2124	16	setembrense	130
4350	Silveira Martins	432065	23	2449	21	sillveirense	118
4353	Soledade	432080	23	30044	25	soledadense	1213
4355	Tapejara	432090	23	19250	81	tapejarense	239
4358	Taquara	432120	23	54643	119	taquarense	458
4360	Taquaruçu Do Sul	432132	23	2966	39	taquaraçusense	77
4362	Tenente Portela	432140	23	13719	41	portelense	338
4365	Tio Hugo	432146	23	2724	24	tio-huguense	114
4367	Toropi	432149	23	2952	15	toropiense	203
4369	Tramandaí	432160	23	41585	288	tramandaiense	144
4371	Três Arroios	432163	23	2855	19	três-arroiense	149
4374	Três De Maio	432180	23	23726	56	três-maiense	422
4376	Três Palmeiras	432185	23	4381	24	três-palmeirense	181
4379	Triunfo	432200	23	25793	32	triunfense	819
4381	Tunas	432215	23	4395	20	tunense	218
4383	Tupanciretã	432220	23	22281	10	tupanciretanense	2252
4386	Turuçu	432232	23	3522	14	turuçuense	254
4388	União Da Serra	432235	23	1487	11	união-serrense	131
4390	Uruguaiana	432240	23	125435	22	uruguaianense	5716
4393	Vale Real	432254	23	5118	114	vale-realense	45
4395	Vanini	432255	23	1984	31	vaninense	65
4397	Vera Cruz	432270	23	23983	77	vera-cruzense	310
4399	Vespasiano Correa	432285	23	1974	17	vespasianense	114
4402	Vicente Dutra	432310	23	5285	27	dutrense	195
4403	Victor Graeff	432320	23	3036	13	victorense	238
4405	Vila Lângaro	432335	23	2152	14	vila-langarense	152
4407	Vila Nova Do Sul	432345	23	4221	8	vila-novense	508
4410	Vista Gaúcha	432370	23	2759	31	vista-gauchense	89
4413	Xangri Lá	432380	23	12434	205	xangri-laense	61
4415	Abelardo Luz	420010	24	17100	18	abelardo-lusense-	955
4417	Agronômica	420030	24	4904	38	agronomense	130
4419	Águas De Chapecó	420050	24	6110	44	chapecoense-das-águas	139
4422	Alfredo Wagner	420070	24	9410	13	alfredense	732
4424	Anchieta	420080	24	6380	28	anchietense	229
4426	Anita Garibaldi	420100	24	8623	15	anita-garibaldense	589
4429	Apiúna	420125	24	9600	19	apiunense	494
4431	Araquari	420130	24	24810	64	araquariense	386
4434	Arroio Trinta	420160	24	3502	37	arroio-trintense	94
4436	Ascurra	420170	24	7412	66	ascurrense	112
4438	Aurora	420190	24	5549	27	aurorense	207
4440	Balneário Barra Do Sul	420205	24	8430	76	barrassulense	111
4443	Balneáreo Piçarras	421280	24	17078	172	piçarrense	99
4446	Barra Velha	420210	24	22386	160	barra-velhense	140
4448	Belmonte	420215	24	2635	28	belmontense	94
4450	Biguaçu	420230	24	58206	155	biguaçuense	374
4452	Bocaina Do Sul	420243	24	3290	6	bocainense	513
4455	Bom Jesus Do Oeste	420257	24	2132	31	bonjesuense	68
4458	Botuverá	420270	24	4468	15	botuveraense	303
4460	Braço Do Trombudo	420285	24	3457	39	braço trombudense	90
4462	Brusque	420290	24	105503	372	brusquense	283
4465	Calmon	420315	24	3387	5	calmonense	640
4467	Campo Alegre	420330	24	11748	24	campo-alegrense	496
4469	Campo Erê	420350	24	9370	20	campo-erense	479
4472	Canoinhas	420380	24	52765	46	canoinhense	1145
4474	Capinzal	420390	24	20769	85	capinzalense	244
4476	Catanduvas	420400	24	9555	48	catanduvense	198
4478	Celso Ramos	420415	24	2771	13	celso-ramense	207
4480	Chapadão Do Lageado	420419	24	2762	22	lageadense	124
4483	Concórdia	420430	24	68621	86	concordense	797
4485	Coronel Freitas	420440	24	10213	44	freitense ou freitano	234
4487	Correia Pinto	420455	24	14785	23	correia-pintense	652
4490	Cunha Porã	420470	24	10613	48	cunha-porense	220
4492	Curitibanos	420480	24	37748	40	curitibanense	952
4494	Dionísio Cerqueira	420500	24	14811	39	cerqueirense	378
4497	Entre Rios	420517	24	3018	29	entrerriense	105
4500	Faxinal Dos Guedes	420530	24	10661	31	faxinalense	340
4502	Florianópolis	420540	24	421240	627	florianopolitano	672
4504	Forquilhinha	420545	24	22548	124	forquilhense	182
4507	Galvão	420560	24	3472	28	galvãoense	122
4509	Garuva	420580	24	14761	29	garuvense	501
4511	Governador Celso Ramos	420600	24	12999	111	gancheiro	117
4514	Guabiruba	420630	24	18430	106	guabirubense	174
4516	Guaramirim	420650	24	35172	131	guaramirense	268
4518	Guatambú	420665	24	4679	23	guatumbuense	205
4521	Ibicaré	420680	24	3373	22	ibicareense	156
4523	Içara	420700	24	58833	200	içarense	294
4525	Imaruí	420720	24	11672	22	imaruense	542
4530	Ipira	420760	24	4752	31	ipirense	155
4531	Iporã Do Oeste	420765	24	8409	42	iporã-oestino	202
4534	Iraceminha	420775	24	4253	26	iraceminhense	164
4536	Irati	420785	24	2096	27	iratiense	78
4539	Itaiópolis	420810	24	20301	16	itaiopolense	1295
4541	Itapema	420830	24	45797	772	itapemense	59
4543	Itapoá	420845	24	14763	58	itapoaense	256
4546	Jacinto Machado	420870	24	10609	25	jacinto-machadense	429
4548	Jaraguá Do Sul	420890	24	143123	269	jaraguaense	533
4550	Joaçaba	420900	24	27020	116	joaçabense	232
4553	Jupiá	420917	24	2148	23	jupiaense	92
4555	Lages	420930	24	156727	60	lageano	2630
4557	Lajeado Grande	420945	24	1490	23	lajeado grandense	66
4560	Lebon Régis	420970	24	11838	13	lebon-regense	941
4562	Lindóia Do Sul	420985	24	4642	24	lindoiense	190
4565	Luzerna	421003	24	5600	48	luzernense	117
4567	Mafra	421010	24	52912	38	mafrense	1404
4569	Major Vieira	421030	24	7479	14	major-vieirense	526
4572	Marema	421055	24	2203	21	maremense	104
4574	Matos Costa	421070	24	2839	7	matos-costense	432
4576	Mirim Doce	421085	24	2513	7	mirindocense	336
4578	Mondaí	421100	24	10231	51	mondaiense	201
4580	Monte Castelo	421110	24	8346	15	monte-castelense	562
4583	Navegantes	421130	24	60556	543	navegantino	111
4585	Nova Itaberaba	421145	24	4267	31	nova itaberadense	138
4588	Novo Horizonte	421165	24	2750	18	novo-horizontino	152
4590	Otacílio Costa	421175	24	16337	19	otaciliense	847
4593	Paial	421187	24	1763	21	paialense	86
4595	Palhoça	421190	24	137334	348	palhocense	395
4597	Palmeira	421205	24	2373	8	palmeirense	292
4600	Paraíso	421223	24	4080	23	paraisense	179
4602	Passos Maia	421227	24	4425	7	passosmaiense	614
4604	Pedras Grandes	421240	24	4107	24	pedras-grandense	172
4607	Petrolândia	421270	24	6131	20	petrolandense	306
4609	Pinheiro Preto	421300	24	3147	48	pinheirense	66
4611	Planalto Alegre	421315	24	2654	42	planaltoalegrense	63
4614	Ponte Alta Do Norte	421335	24	3303	8	norte pontealtense	401
4616	Porto Belo	421350	24	16083	168	porto-belense	96
4618	Pouso Redondo	421370	24	14810	41	pouso-redondense	360
4621	Presidente Getúlio	421400	24	14887	50	getulense	296
4623	Princesa	421415	24	2758	32	princesense	86
4625	Rancho Queimado	421430	24	2748	10	rancho-queimadense	286
4628	Rio Do Oeste	421460	24	7090	29	riense-do-oeste	246
4630	Rio Dos Cedros	421470	24	10284	19	rio-cedrense	556
4633	Rio Rufino	421505	24	2436	9	rio rufinense	283
4635	Rodeio	421510	24	10922	85	rodeiense	128
4638	Saltinho	421535	24	3961	25	saltinhense	157
4640	Sangão	421545	24	10400	125	sangãoense	83
4642	Santa Helena	421555	24	2382	29	santaelenense	81
4644	Santa Rosa Do Sul	421565	24	8054	53	santa-rosense	151
4647	Santiago Do Sul	421569	24	1465	20	santiaguense	74
4827	Aspásia	350395	26	1809	26	aspasiense	69
4649	São Bento Do Sul	421580	24	74801	151	são-bentense	496
4652	São Carlos	421600	24	10291	65	são-carlense	159
4654	São Domingos	421610	24	9491	25	dominguense	384
4656	São João Batista	421630	24	26260	119	batistense	221
4657	São João Do Itaperiú	421635	24	3435	23	itaperiuense	152
4659	São João Do Sul	421640	24	7002	38	joão-sulense	183
4662	São José Do Cedro	421670	24	13684	49	cedrense	280
4664	São Lourenço Do Oeste	421690	24	21792	60	lourencense ou lourenciano	362
4666	São Martinho	421710	24	3209	14	são-martinhense	225
4669	São Pedro De Alcântara	421725	24	4704	34	alcantarense	140
4672	Seara	421750	24	16936	54	searaense	313
4674	Siderópolis	421760	24	12998	49	sideropolitano	263
4676	Sul Brasil	421775	24	2766	25	sul brasilense	113
4679	Tigrinhos	421795	24	1757	31	tigrinhense	57
4681	Timbé Do Sul	421810	24	5308	16	timbeense	334
4683	Timbó Grande	421825	24	7167	12	timbó-grandense	597
4686	Treze De Maio	421840	24	6876	43	treze-maioense	161
4688	Trombudo Central	421860	24	6553	60	trombudense	109
4691	Turvo	421880	24	11854	51	turvense	234
4693	Urubici	421890	24	10699	11	urubiciense	1019
4695	Urussanga	421900	24	20223	84	urussanguense	240
4698	Vargem Bonita	421917	24	4793	16	vargembonitense	299
4700	Videira	421930	24	47188	125	videirense	378
4702	Witmarsum	421940	24	3600	24	witmarsumense	151
4704	Xavantina	421960	24	4142	19	xavantinense	215
4707	Amparo De São Francisco	280010	25	2275	65	amparense	35
4709	Aracaju	280030	25	571149	3	aracajuano	182
4711	Areia Branca	280050	25	16857	115	areia-branquense	147
4714	Brejo Grande	280070	25	7742	52	brejo-grandense	149
4716	Canhoba	280110	25	3956	23	canhobense	170
4719	Carira	280140	25	20007	31	carirense	636
4721	Cedro De São João	280160	25	5633	67	cedrense	84
4723	Cumbe	280190	25	3813	30	cumbense	129
4725	Estância	280210	25	64409	100	estanciano	644
4728	Gararu	280240	25	11405	17	gararuense	655
4730	Gracho Cardoso	280260	25	5645	23	gracho-cardosense	242
4732	Indiaroba	280280	25	15831	50	indiarobense	314
4735	Itabi	280310	25	4972	27	itabiense	184
4737	Japaratuba	280330	25	16864	46	japaratubense	365
4739	Lagarto	280350	25	94861	98	lagartense	970
4742	Malhada Dos Bois	280380	25	3456	55	malhadense	63
4744	Maruim	280400	25	16343	174	maruinense	94
4746	Monte Alegre De Sergipe	280420	25	13627	33	monte-alegrense	407
4749	Nossa Senhora Aparecida	280445	25	8508	25	aparecidense	340
4751	Nossa Senhora Das Dores	280460	25	24580	51	dorense	483
4754	Pacatuba	280490	25	13137	35	pacatubense	374
4756	Pedrinhas	280510	25	8833	260	pedrinhense	34
4759	Poço Redondo	280540	25	30880	25	poço-redondense	1232
4761	Porto Da Folha	280560	25	27146	31	porto-folhense	877
4763	Riachão Do Dantas	280580	25	19386	36	riachãoense	531
4766	Rosário Do Catete	280610	25	9221	87	rosarense	106
4768	Santa Luzia Do Itanhy	280630	25	12969	39	santa-luziense	330
4771	Santo Amaro Das Brotas	280660	25	11410	49	brotense	234
4773	São Domingos	280680	25	10271	100	são-dominguense	102
4776	Simão Dias	280710	25	38702	69	simão-diense	565
4778	Telha	280730	25	2957	60	telhense	49
4780	Tomar Do Geru	280750	25	12855	42	geruense	305
4782	Adamantina	350010	26	33797	82	adamantinense	411
4783	Adolfo	350020	26	3557	17	adolfino	211
4785	Águas Da Prata	350040	26	7584	53	pratense	143
4787	Águas De Santa Bárbara	350055	26	5601	14	santa-barbarense	408
4790	Alambari	350075	26	4884	31	alambariense	159
4792	Altair	350090	26	3815	12	altairense	314
4795	Alumínio	350115	26	16839	201	aluminense	84
4796	Álvares Florence	350120	26	3897	11	alvares florencense	363
4799	Alvinlândia	350150	26	3000	35	alvinlandense	85
4801	Américo Brasiliense	350170	26	34478	282	américo-brasiliense	122
4804	Analândia	350200	26	4293	13	analandense	326
4806	Angatuba	350220	26	22210	22	angatubense 	1028
4809	Aparecida	350250	26	35007	289	aparecidense	121
4811	Apiaí	350270	26	25191	26	apiaiense	974
4813	Araçatuba	350280	26	181579	156	araçatubense	1167
4815	Aramina	350300	26	5152	25	araminense	203
4818	Araraquara	350320	26	208662	208	araraquarense	1004
4820	Arco Íris	350335	26	1925	7	arcoirense	265
4822	Areias	350350	26	3696	12	areiense	305
4824	Ariranha	350370	26	8547	64	ariranhense	133
4829	Atibaia	350410	26	126603	265	atibaiano	478
4831	Avaí	350430	26	4959	9	avaiense	540
4834	Bady Bassitt	350460	26	14603	135	badiense	109
4836	Bálsamo	350480	26	8160	54	balsamense	151
4838	Barão De Antonina	350500	26	3116	20	barãoense	153
4841	Barra Bonita	350530	26	35246	235	barra-bonitense	150
4843	Barra Do Turvo	350540	26	7729	8	barra-turvense	1008
4846	Barueri	350570	26	240749	4	barueriense	66
4848	Batatais	350590	26	56476	66	batataense	850
4850	Bebedouro	350610	26	75035	110	bebedourense	683
4852	Bernardino De Campos	350630	26	10775	44	bernardinense	244
4855	Birigui	350650	26	108728	205	biriguiense	531
4857	Boa Esperança Do Sul	350670	26	13645	20	boa-esperancense	691
4860	Boituva	350700	26	48314	194	boituvense	249
4862	Bom Sucesso De Itararé	350715	26	3571	27	bom sucessiense	134
4865	Borborema	350740	26	14529	26	borboremense	552
4867	Botucatu	350750	26	127328	86	botucatuense	1483
4869	Braúna	350770	26	5021	26	braunense	195
4872	Brotas	350790	26	21580	20	brotense	1101
4874	Buritama	350810	26	15418	47	buritamense	327
4876	Cabrália Paulista	350830	26	4365	18	cabraliense	240
4879	Cachoeira Paulista	350860	26	30091	104	cachoeirense	288
4881	Cafelândia	350880	26	16607	18	cafelandense	920
4883	Caieiras	350900	26	86529	895	caieirense	97
4886	Cajati	350925	26	28372	62	cajatiense	454
4888	Cajuru	350940	26	23371	35	cajuruense	660
4890	Campinas	350950	26	1080113	1	campineiro	795
4892	Campos Do Jordão	350970	26	47789	164	jordanense	291
4895	Canas	350995	26	4385	82	canense	53
4897	Cândido Rodrigues	351010	26	2668	38	cândido-rodriguense	70
4899	Capão Bonito	351020	26	46178	28	capão-bonitense	1640
4902	Caraguatatuba	351050	26	100840	208	caraguatatubense	485
4904	Cardoso	351070	26	11805	18	cardosense	640
4906	Cássia Dos Coqueiros	351090	26	2634	14	cassiano	192
4909	Catiguá	351120	26	7127	48	catigüense	148
4911	Cerqueira César	351140	26	17532	34	cerqueirense	509
4912	Cerquilho	351150	26	39617	310	cerquilhense	128
4914	Charqueada	351170	26	15085	86	charqueadense	176
4917	Colina	351200	26	17371	41	colinense	423
4919	Conchal	351220	26	25229	138	conchalense	183
4921	Cordeirópolis	351240	26	21080	153	cordeiropolense	138
4923	Coronel Macedo	351260	26	5001	16	macedense	304
4926	Cosmorama	351290	26	7214	16	cosmoramense	444
4929	Cristais Paulista	351320	26	7588	20	cristalense	385
4931	Cruzeiro	351340	26	77039	252	cruzeirense	306
4933	Cunha	351360	26	21866	16	cunhense	1407
4936	Dirce Reis	351385	26	1689	19	dircense	88
4938	Dobrada	351400	26	7939	53	dobradense	150
4940	Dolcinópolis	351420	26	2096	27	dolcinopolense	78
4942	Dracena	351440	26	43258	89	dracenense	488
4945	Echaporã	351470	26	6318	12	echaporense	515
4947	Elias Fausto	351490	26	15775	78	elias-faustense	203
4949	Embaúba	351495	26	2423	29	embaubense	83
4952	Emilianópolis	351512	26	3020	13	emilianópolense	224
4954	Espírito Santo Do Pinhal	351518	26	41907	108	pinhalense	389
4956	Estiva Gerbi	355730	26	10044	135	estivense	74
4959	Euclides Da Cunha Paulista	351535	26	9585	17	euclidense	575
4961	Fernando Prestes	351560	26	5534	32	fernando-prestense	171
4964	Ferraz De Vasconcelos	351570	26	168306	6	ferrazense	30
4967	Florínia	351610	26	2829	13	florineense	226
4969	Franca	351620	26	318640	526	francano	606
4971	Franco Da Rocha	351640	26	131604	981	franco-rochense	134
4974	Garça	351670	26	43115	78	garcense	556
4976	Gavião Peixoto	351685	26	4419	18	gavionense	244
4978	Getulina	351700	26	10765	16	getulinense	679
4981	Guaimbê	351730	26	5425	25	guaimbeense	218
4983	Guapiaçu	351750	26	17869	55	guapiaçuense	326
4985	Guará	351770	26	19858	55	guaraense	362
4987	Guaraci	351790	26	9976	16	guaraciense	642
4990	Guararapes	351820	26	30597	32	guararapense	956
4992	Guaratinguetá	351840	26	112072	149	guaratinguetaense	752
4994	Guariba	351860	26	35486	131	guaribense	270
4997	Guatapará	351885	26	6966	17	guataparaense	413
4999	Herculândia	351900	26	8696	24	herculandense	365
5001	Hortolândia	351907	26	192692	3	hortolandense	63
5004	Iaras	351925	26	6376	16	iarense	401
5006	Ibirá	351940	26	10896	40	ibiraense	272
5008	Ibitinga	351960	26	53158	77	ibitinguense	689
5011	Iepê	351990	26	7628	13	iepense	595
5013	Igarapava	352010	26	27952	60	igarapavense	468
5015	Iguape	352030	26	28841	15	iguapense	1977
5017	Ilha Solteira	352044	26	25064	38	ilhense	656
5020	Indiana	352060	26	4825	38	indianense	127
5022	Inúbia Paulista	352080	26	3630	42	inubense	87
5025	Ipeúna	352110	26	6016	32	ipeunense	190
5027	Iporanga	352120	26	4299	4	iporanguense	1152
5029	Iracemápolis	352140	26	20029	174	iracemapolense	115
5032	Itaberá	352170	26	17858	17	itaberense	1082
5034	Itajobi	352190	26	14556	29	itajobiense	502
5036	Itanhaém	352210	26	87057	145	itanhaense	600
5038	Itapecerica Da Serra	352220	26	152614	1	itapecericano	150
5041	Itapevi	352250	26	200769	2	itapeviense	83
5042	Itapira	352260	26	68537	132	itapirense	518
5045	Itaporanga	352280	26	14549	29	itaporanguense	508
5047	Itapura	352300	26	4357	14	itapurense	301
5049	Itararé	352320	26	47934	48	itarareense	1004
5051	Itatiba	352340	26	101471	315	itatibense	322
5053	Itirapina	352360	26	15524	28	itirapinense	564
5056	Itu	352390	26	154147	241	ituano	641
5058	Ituverava	352410	26	38695	55	ituveravense	705
5060	Jaboticabal	352430	26	71662	101	jaboticabalense	707
5062	Jaci	352450	26	5657	39	jaciense	146
5065	Jales	352480	26	47012	128	jalesense	369
5067	Jandira	352500	26	108344	6	jandirense	18
5069	Jarinu	352520	26	23847	115	jarinuense	208
5072	Joanópolis	352550	26	11768	31	joanopolitano	375
5074	José Bonifácio	352570	26	32763	38	bonifacense	860
5076	Jumirim	352585	26	2798	49	jumirense	57
5078	Junqueirópolis	352600	26	18726	32	junqueiropolense	583
5081	Lagoinha	352630	26	4841	19	lagoinhense	255
5083	Lavínia	352650	26	8779	16	lavinense	538
5086	Lençóis Paulista	352680	26	61428	76	lençoiense	809
5088	Lindóia	352700	26	6712	138	lindoiano	49
5091	Lourdes	352725	26	2128	19	lourdense	114
5093	Lucélia	352740	26	19882	63	luceliense	315
5095	Luís Antônio	352760	26	11286	19	luís-antoniense	598
5098	Lutécia	352790	26	2714	6	luteciano	475
5100	Macaubal	352810	26	7663	31	macaubalense	248
5102	Magda	352830	26	3200	10	magdense	312
5104	Mairiporã	352850	26	80956	252	mairiporense	321
5106	Marabá Paulista	352870	26	4812	5	marabaense	918
5109	Mariápolis	352890	26	3916	21	mariapolense	186
5111	Marinópolis	352910	26	2113	27	marinopolense	78
5114	Mauá	352940	26	417064	7	mauaense	61
5116	Meridiano	352960	26	3855	17	meridianense	229
5118	Miguelópolis	352970	26	20451	25	miguelopense	822
5121	Miracatu	352990	26	20592	21	miracatuense	1002
5123	Mirante Do Paranapanema	353020	26	17059	14	mirantense	1239
5126	Mococa	353050	26	66290	78	mocoquense	855
5128	Mogi Guaçu	353070	26	137245	169	guaçuano	812
5130	Mombuca	353090	26	3266	24	mombucano	134
5133	Monte Alegre Do Sul	353120	26	7152	65	monte-alegrense	110
5135	Monte Aprazível	353140	26	21746	44	monte-aprazivelense	497
5137	Monte Castelo	353160	26	4063	17	monte-castelense	233
5140	Morro Agudo	353190	26	29116	21	morro-agudense	1388
5142	Motuca	353205	26	4290	19	motuquense	229
5145	Narandiba	353220	26	4288	12	narandibense	358
5147	Nazaré Paulista	353240	26	16414	50	nazareano	326
5150	Nipoã	353270	26	4274	31	nipoense	138
5152	Nova Campina	353282	26	8515	22	nova campinense	385
5154	Nova Castilho	353286	26	1125	6	castilhense	183
5157	Nova Guataporanga	353310	26	2177	64	guataporanguense	34
5159	Nova Luzitânia	353330	26	3441	46	luzitaniense	74
5162	Novo Horizonte	353350	26	36593	39	novo-horizontino	932
5164	Ocauçu	353370	26	4163	14	ocauçuense	300
5167	Onda Verde	353400	26	3884	16	onda-verdense	243
5169	Orindiúva	353420	26	5675	23	orindiuvense	248
5171	Osasco	353440	26	666740	10	osasquense	64
5172	Oscar Bressane	353450	26	2537	11	bressanense	221
5175	Ouro Verde	353480	26	7800	29	ouro-verdense	268
5177	Pacaembu	353490	26	13226	39	pacaembuense	339
5179	Palmares Paulista	353510	26	10934	133	palmarense	82
5182	Panorama	353540	26	14583	41	panoramense	356
5184	Paraibuna	353560	26	17388	21	paraibunense	810
5186	Paranapanema	353580	26	17808	17	paranapanemense	1019
5189	Pardinho	353610	26	5582	27	pardinhense	210
5191	Parisi	353625	26	2032	24	parasiano	85
5193	Paulicéia	353640	26	6339	17	pauliceiense	374
5196	Paulo De Faria	353660	26	8589	12	paulo-fariense	738
5198	Pedra Bela	353680	26	5780	36	pedra-belense	159
5200	Pedregulho	353700	26	15700	22	pedregulhense	713
5203	Pedro De Toledo	353720	26	10204	15	toledense	670
5205	Pereira Barreto	353740	26	24962	26	pereira-barretense	979
5208	Piacatu	353770	26	5287	23	piacatuense	232
5210	Pilar Do Sul	353790	26	26406	39	pilarense	681
5212	Pindorama	353810	26	15039	81	pindoramense	185
5214	Piquerobi	353830	26	3537	7	piquerobiense	483
5217	Piracicaba	353870	26	364571	265	piracicabano	1377
5219	Pirajuí	353890	26	22704	28	pirajuiense	824
5221	Pirapora Do Bom Jesus	353910	26	15733	145	piraporense	109
5224	Piratininga	353940	26	12072	30	piratiningano	402
5226	Planalto	353960	26	4463	15	planaltense	290
5228	Poá	353980	26	106013	6	poaense	17
5231	Pongaí	354010	26	3481	19	pongaiense	183
5233	Pontalinda	354025	26	4074	19	pantalindense	210
5235	Populina	354040	26	4223	13	populinense	316
5237	Porto Feliz	354060	26	48893	88	porto-felicense	557
5239	Potim	354075	26	19397	436	potinense	44
5242	Pradópolis	354090	26	17377	104	pradopolitano	168
5244	Pratânia	354105	26	4599	26	pratino	175
5246	Presidente Bernardes	354120	26	13570	18	bernardense	752
5249	Presidente Venceslau	354150	26	37910	50	venceslauense	757
5252	Quatá	354170	26	12799	20	quataense	652
5254	Queluz	354190	26	11309	45	queluzense	250
5256	Rafard	354210	26	8612	71	rafardense	121
5258	Redenção Da Serra	354230	26	3873	13	rendencense	309
5261	Registro	354260	26	54261	75	registrense	722
5263	Ribeira	354280	26	3358	10	ribeirense	336
5265	Ribeirão Branco	354300	26	18269	26	ribeirão-branquense	698
5267	Ribeirão Do Sul	354320	26	4446	22	ribeirão-sulense	204
5270	Ribeirão Pires	354330	26	113068	1	ribeirão-pirense	99
5272	Rifaina	354360	26	3436	21	rifainense	163
5274	Rinópolis	354380	26	9935	28	rinopolense	358
5277	Rio Grande Da Serra	354410	26	43974	1	rio-grandense-da-serra	37
5279	Riversul	354350	26	6163	16	riversulense	386
5281	Roseira	354430	26	9599	73	roseirense	131
5284	Sabino	354460	26	5217	17	sabinense	311
5286	Sales	354480	26	5451	18	salense	308
5288	Salesópolis	354500	26	15635	37	salesopolense	425
5291	Salto	354520	26	105516	792	saltense	133
5293	Salto Grande	354540	26	8787	47	salto-grandense	188
5295	Santa Adélia	354560	26	14333	43	santa-adeliense	331
5298	Santa Branca	354600	26	13763	50	santa-branquense	275
5299	Santa Clara D`Oeste	354610	26	2084	11	santa-clarense	183
5300	Santa Cruz Da Conceição	354620	26	4002	27	santa-cruzense	150
5302	Santa Cruz Das Palmeiras	354630	26	29932	101	palmeirense	295
5305	Santa Fé Do Sul	354660	26	29239	140	santa-fé-sulense	208
5307	Santa Isabel	354680	26	50453	139	isabelense	363
5310	Santa Mercedes	354710	26	2831	17	mercedense	167
5312	Santa Rita Do Passa Quatro	354750	26	26478	35	santa-ritense	754
5315	Santana Da Ponte Pensa	354720	26	1641	13	santanense-da-ponte-pensa	130
5318	Santo André	354780	26	676407	4	andreense	175
5320	Santo Antônio De Posse	354800	26	20650	134	possense	154
5322	Santo Antônio Do Jardim	354810	26	5943	54	jardinense	110
5325	Santópolis Do Aguapeí	354840	26	4277	33	santopolitano	128
5328	São Bernardo Do Campo	354870	26	765463	2	são-bernardense	409
5331	São Francisco	354900	26	2793	37	são-francisquense	76
5333	São João Das Duas Pontes	354920	26	2566	20	são-joanense	129
5335	São João Do Pau D`Alho	354930	26	2103	18	são-joanense	118
5338	São José Do Barreiro	354960	26	4077	7	barreirense	571
5341	São José Dos Campos	354990	26	629921	573	joseense	1100
5343	São Luís Do Paraitinga	355000	26	10397	17	luisense	617
5346	São Paulo	355030	26	11253503	7	paulistano	1523
5348	São Pedro Do Turvo	355050	26	7198	10	são-pedrense	732
5351	São Sebastião Da Grama	355080	26	12099	48	gramense	252
5354	Sarapuí	355110	26	9027	26	sarapuiano	353
5356	Sebastianópolis Do Sul	355130	26	3031	19	sebastianopolense	163
5359	Serrana	355150	26	38878	310	serranense	126
5361	Sete Barras	355180	26	13005	12	barrense	1053
5363	Silveiras	355200	26	5792	14	silveirense	415
5366	Sud Mennucci	355230	26	7435	13	sud-menucciano	591
5368	Suzanápolis	355255	26	3383	10	suzanapolense	329
5371	Tabatinga	355270	26	14686	40	tabatinguense	370
5373	Taciba	355290	26	5714	9	tacibense	607
5375	Taiaçu	355310	26	5894	55	taiaçuense	107
5377	Tambaú	355330	26	22406	40	tambauense	562
5380	Tapiratiba	355360	26	12737	57	tapiratibense	223
5382	Taquaritinga	355370	26	53988	91	taquaritinguense	594
5384	Taquarivaí	355385	26	5151	22	taquarivaiense	232
5387	Tatuí	355400	26	107326	205	tatuiano	523
5389	Tejupá	355420	26	4809	16	tejupaense	296
5391	Terra Roxa	355440	26	8505	38	terra-roxense	222
5393	Timburi	355460	26	2646	13	timburiense	197
5396	Trabiju	355475	26	1544	24	trabijuense	63
5398	Três Fronteiras	355490	26	5427	35	trifonteirano	153
5400	Tupã	355500	26	63476	101	tupãense	629
5403	Turmalina	355530	26	1978	13	turmalinense	148
5405	Ubatuba	355540	26	78801	111	ubatubano	711
5407	Uchoa	355560	26	9471	38	uchoense	252
5409	Urânia	355580	26	8836	42	uraniense	209
5412	Valentim Gentil	355610	26	11036	74	valentim-gentilense	150
5431	Alvorada	170070	27	8374	7	alvoradense	1212
5433	Angico	170105	27	3175	7	angicoense	452
5435	Aragominas	170130	27	5882	5	aragominense	1173
5438	Araguaína	170210	27	150484	38	araguainense	4000
5440	Araguatins	170220	27	31329	12	araguatinense	2625
5442	Arraias	170240	27	10645	2	arraiano	5787
5444	Aurora Do Tocantins	170270	27	3446	5	aurorense	753
5447	Bandeirantes Do Tocantins	170305	27	3122	2	bandeirantense	1542
5449	Barrolândia	170310	27	5349	8	barrolandense	713
5452	Brasilândia Do Tocantins	170360	27	2064	3	brasilandense	641
5455	Cachoeirinha	170382	27	2148	6	cachoeirense	352
5457	Cariri Do Tocantins	170386	27	3756	3	caririense	1129
5459	Carrasco Bonito	170389	27	3688	19	carrascoense	193
5462	Chapada Da Natividade	170510	27	3277	2	chapadense	1646
5464	Colinas Do Tocantins	170550	27	30838	37	colinense	844
5467	Conceição Do Tocantins	170560	27	4182	2	conceicionense	2501
5470	Crixás Do Tocantins	170625	27	1564	2	crixaense	987
5473	Divinópolis Do Tocantins	170710	27	6363	3	divinopolino	2347
5475	Dueré	170730	27	4592	1	duerense	3425
5478	Figueirópolis	170765	27	5340	3	figueiropolense	1930
5480	Formoso Do Araguaia	170820	27	18427	1	formosense do araguaia	13423
5482	Goianorte	170830	27	4956	3	goianortense	1801
5485	Gurupi	170950	27	76755	42	gurupiense	1836
5487	Itacajá	171050	27	7104	2	itacajaense	3051
5489	Itapiratins	171090	27	3532	3	itapiratinense	1244
5492	Juarina	171180	27	2231	5	juarinense	481
5494	Lagoa Do Tocantins	171195	27	3525	4	lagoense do tocantins	911
5496	Lavandeira	171215	27	1605	3	lavandeirense	520
5499	Marianópolis Do Tocantins	171250	27	4352	2	marianopolino	2091
5501	Maurilândia Do Tocantins	171280	27	3154	4	maurilandense	738
5504	Monte Do Carmo	171360	27	6716	2	carmelito	3617
5506	Muricilândia	171395	27	3152	3	muricilandense	1187
5509	Nova Olinda	171488	27	10686	7	novalindense 	1566
5511	Novo Acordo	171510	27	3762	1	novoacordino 	2672
5513	Novo Jardim	171525	27	2457	2	novojardinense	1310
5516	Palmeirante	171570	27	4954	2	palmeirantense	2641
5518	Palmeirópolis	171575	27	7339	4	palmeiropolitano	1704
5521	Pau D`Arco	171630	27	4588	3	pau d?arquense	1377
5523	Peixe	171660	27	10384	2	peixense	5291
5525	Pindorama Do Tocantins	171700	27	4506	3	pindoramense	1559
5528	Ponte Alta Do Bom Jesus	171780	27	4544	3	pontealtense	1806
5530	Porto Alegre Do Tocantins	171800	27	2796	6	porto-alegrense	502
5533	Presidente Kennedy	171840	27	3681	5	kenediense	770
5535	Recursolândia	171850	27	3768	2	recursolandense	2217
5538	Rio Dos Bois	171870	27	2570	3	rioboiense	845
5540	Sampaio	171880	27	3864	17	sampaiense	222
5542	Santa Fé Do Araguaia	171886	27	6599	4	santaféense	1678
5545	Santa Rosa Do Tocantins	171890	27	4568	3	santa rosense	1796
5546	Santa Tereza Do Tocantins	171900	27	2523	5	santa terezense	540
5548	São Bento Do Tocantins	172010	27	4608	4	são bentense	1106
5551	São Salvador Do Tocantins	172025	27	2910	2	são salvadorense	1422
5553	São Valério	172049	27	4383	2	são valeriano	2520
5558	Taipas Do Tocantins	172093	27	1945	2	taipense	1116
5561	Tocantinópolis	172120	27	22619	21	tocantinopolino	1077
5563	Tupiratins	172130	27	2097	2	tupiratinense	895
5565	Xambioá	172210	27	11484	10	xambioaense	1186
204	Abaré	290020	5	\N	\N	\N	\N
620	Abaiara	230010	6	\N	\N	\N	\N
1346	Abadia Dos Dourados	310010	11	\N	\N	\N	\N
2169	Uberaba	317010	11	\N	\N	\N	\N
\.


--
-- Name: cidade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cidade_id_seq', 5567, true);


--
-- Data for Name: estado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY estado (id, codigo_ibge, sigla, nome) FROM stdin;
1	12	AC	Acre
2	27	AL	Alagoas
3	13	AM	Amazonas
5	29	BA	Bahia
6	23	CE	Ceará
7	53	DF	Distrito Federal
8	32	ES	Espírito Santo
9	52	GO	Goiás
10	21	MA	Maranhão
11	31	MG	Minas Gerais
12	50	MS	Mato Grosso do Sul
13	51	MT	Mato Grosso
15	25	PB	Paraíba
16	26	PE	Pernambuco
17	22	PI	Piauí
18	41	PR	Paraná
19	33	RJ	Rio de Janeiro
20	24	RN	Rio Grande do Norte
21	11	RO	Rondônia
22	14	RR	Roraima
23	43	RS	Rio Grande do Sul
24	42	SC	Santa Catarina
25	28	SE	Sergipe
26	35	SP	São Paulo
27	17	TO	Tocantins
4	16	AP	Amapá
14	15	PA	Pará
\.


--
-- Name: estado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('estado_id_seq', 28, true);


--
-- Data for Name: individuo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY individuo (id, nome, sexo, email, data_nascimento, telefone1, telefone2, logradouro, numero, bairro, cidade_fk_id, rg, cpf, diagnostico, dt_diagnostico, medico_responsavel, telefone_medico_responsavel, outras_patologias, peso, altura, tipo_sangue_fk_id, foto, numero_registro, instituicao) FROM stdin;
34	Joao Paulo	M	\N	1982-06-21	(34)3333-1111	\N	\N	0	\N	2169	\N	\N	3	\N	\N	\N	\N	75.00	1.83	1	\N	81533678	UFU
\.


--
-- Name: individuo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('individuo_id_seq', 34, true);


--
-- Data for Name: individuo_medicamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY individuo_medicamento (id, individuo_fk_id, medicamento_fk_id, dosagem, observacao) FROM stdin;
\.


--
-- Name: individuo_medicamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('individuo_medicamento_id_seq', 8, true);


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY medicamento (id, nome, descricao, fabricante) FROM stdin;
5	Prolopa	Este medicamento é uma associação das substâncias levodopa e cloridrato de benserazida e é indicado para o tratamento de pacientes com doença de Parkinson.	Roche
\.


--
-- Name: medicamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('medicamento_id_seq', 5, true);


--
-- Data for Name: tipo_sangue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_sangue (id, tipo) FROM stdin;
1	O+
2	O-
3	A+
4	A-
5	B+
6	B-
7	AB+
8	AB-
\.


--
-- Name: tipo_sangue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_sangue_id_seq', 1, false);


SET search_path = questionario, pg_catalog;

--
-- Data for Name: agrupamento; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY agrupamento (id, descricao, ordem, status, tipo_questionario_fk_id) FROM stdin;
17	Pergunta única	1	t	6
18	Parte I: Aspectos Não Motores das Experiências da Vida Diária (nM-EVD)	1	t	4
19	Parte II: Aspectos Motores de Experiências da Vida Diária (M-EVD)	2	t	4
20	Parte III: Avaliação Motora	3	t	4
21	Parte IV: Complicações Motoras	4	t	4
\.


--
-- Name: agrupamento_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('agrupamento_id_seq', 21, true);


--
-- Data for Name: alternativa; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY alternativa (id, descricao, valor, ordem, status) FROM stdin;
64	Moderado: Os problemas estão presentes e geralmente causam muitas dificuldades na vida pessoal e familiar do paciente.	3	4	t
65	Grave: Os problemas estão presentes e impedem o paciente de desempenhar as\r\natividades habituais e interações sociais ou impedem a manutenção dos padrões anteriores\r\nna vida pessoal e familiar.	4	5	t
66	Normal: Sem problemas.	0	1	t
67	Discreto: Os problemas do sono existem, mas habitualmente não impedem que tenha uma noite de sono completa.	1	2	t
68	Ligeiro: Os problemas do sono causam habitualmente alguma dificuldade em ter uma noite de sono completa.	2	3	t
28	Nenhum sinal da doença	0	1	t
29	Doença unilateral	1	2	t
30	Envolvimento unilateral e axial.	1.5	3	t
31	Doença bilateral sem déficit de equilíbrio (recupera o equilíbrio dando três passos para trás ou menos)	2	4	t
32	Doença bilateral leve, com recuperação no “teste do empurrão”(empurra-se bruscamente o paciente\r\npara trás a partir dos ombros, o paciente dá mais que três passos, mas recupera o equilíbrio sem\r\najuda).	2.5	5	t
33	Doença bilateral leve a moderada; alguma instabilidade postural; capacidade para viver independente.	3	6	t
34	Incapacidade grave, ainda capaz de caminhar ou permanecer de pé sem ajuda	4	7	t
35	Confinado à cama ou cadeira de rodas a não ser que receba ajuda.	5	8	t
36	Normal: Sem disfunção cognitiva.	0	1	t
37	Discreto: Disfunção cognitiva identificada pelo paciente ou cuidador, sem interferência\r\nconcreta na capacidade do paciente desempenhar as suas atividades e interações sociais\r\nnormais.	1	2	t
38	Ligeiro: Disfunção cognitiva clinicamente evidente, mas apenas com interferência mínima na\r\ncapacidade do paciente desempenhar as suas atividades e interações sociais normais.	2	3	t
39	Moderado: As disfunções cognitivas interferem, mas não impedem, que o paciente desempenhe as suas atividades e interações sociais normais.	3	4	t
40	Grave: A disfunção cognitiva impede que o paciente desempenhe as suas atividades e\r\ninterações sociais normais.	4	5	t
41	Normal: Sem alucinações ou comportamento psicótico.	0	1	t
42	Discreto: Ilusões ou alucinações não formadas, mas o paciente reconhece-as sem perda\r\nde noção da realidade.	1	2	t
43	Ligeiro: Alucinações formadas, independentes de estímulos ambientais. Sem perda de\r\nnoção da realidade.	2	3	t
44	Moderado: Alucinações formadas com perda de noção da realidade.	3	4	t
45	Grave: O paciente tem delírios ou paranóia.	4	5	t
46	Normal: Sem humor depressivo.	0	1	t
47	Discreto: Episódios de humor depressivo que não se prolongam por mais de um dia de\r\ncada vez. Sem interferência na capacidade do paciente desempenhar as suas atividades e\r\ninterações sociais habituais.	1	2	t
48	Ligeiro: Humor depressivo mantido por vários dias, mas sem interferência na capacidade do\r\npaciente desempenhar as suas atividades e interações sociais habituais.	2	3	t
49	Moderado: Humor depressivo que interfere mas não impede o paciente de desempenhar as\r\nsuas atividades e interações sociais habituais.	3	4	t
50	Grave: Humor depressivo que impede o paciente de desempenhar as suas atividades e\r\ninterações sociais habituais.	4	5	t
51	Normal: Sem ansiedade.	0	1	t
52	Discreto: Sentimento de ansiedade presente mas não mantido por mais de um dia de\r\ncada vez. Sem interferência na capacidade do paciente desempenhar as suas atividades e\r\ninterações sociais habituais.	1	2	t
53	Ligeiro: Sentimento de ansiedade presente e mantido por mais de um dia de cada vez.\r\nSem interferências na capacidade do paciente desempenhar as suas atividades e interações\r\nsociais habituais	2	3	t
54	Moderado: O sentimento de ansiedade interfere mas não impede o paciente de\r\ndesempenhar as suas atividades e interações sociais habituais.	3	4	t
55	Grave: O sentimento de ansiedade impede o paciente de desempenhar as suas atividades\r\ne interações sociais habituais.	4	5	t
56	Normal: Sem apatia.	0	1	t
57	Discreto: Apatia referida pelo paciente e/ou cuidador, mas sem interferência na realização\r\ndas suas atividades e interações sociais habituais.	1	2	t
58	Ligeiro: Apatia que interfere com atividades e interações sociais esporádicas.	2	3	t
59	Moderado: Apatia que interfere com a maioria das atividades e interações sociais.	3	4	t
60	Grave: Passivo e com completa perda de iniciativa.	4	5	t
61	Normal: Ausência de problemas.	0	1	t
62	Discreto: Os problemas estão presentes mas geralmente não causam dificuldades ao paciente ou família/cuidador.	1	2	t
63	Ligeiro: Os problemas estão presentes e geralmente causam algumas dificuldades na vida pessoal e familiar do paciente.	2	3	t
69	Moderado: Os problemas do sono causam muitas dificuldades em ter uma noite de sono completa, mas habitualmente ainda durmo mais de metade da noite.	3	4	t
70	Grave: Habitualmente não consigo dormir durante a maior parte da noite.	4	5	t
71	Normal: Sem sonolência durante o dia.	0	1	t
72	Discreto: Tenho sonolência durante o dia, mas consigo resistir e permaneço acordado.	1	2	t
73	Ligeiro: Por vezes adormeço quando estou sozinho e relaxado. Por exemplo, enquanto leio ou vejo televisão	2	3	t
74	Moderado: Por vezes adormeço quando não deveria. Por exemplo, enquanto como ou falo com outras pessoas.	3	4	t
75	Grave: Adormeço frequentemente quando não deveria. Por exemplo, enquanto como ou falo com outras pessoas.	4	5	t
76	Normal: Não tenho estas sensações desconfortáveis	0	1	t
77	Discreto: Tenho estas sensações desconfortáveis. No entanto, consigo fazer coisas e estar com outras pessoas sem dificuldade.	1	2	t
78	Ligeiro: Estas sensações causam alguns problemas quando faço coisas ou estou com outras pessoas.	2	3	t
79	Moderado: Estas sensações causam muitos problemas, mas não me impedem de fazer coisas ou de estar com outras pessoas.	3	4	t
80	Grave: Estas sensações impedem-me de fazer coisas ou de estar com outras pessoas.	4	5	t
81	Normal: Sem problemas em reter a urina.	0	1	t
82	Discreto: Preciso de urinar frequentemente ou tenho urgência em urinar. No entanto, estes problemas não me causam dificuldades nas atividades diárias.	1	2	t
83	Ligeiro: Os problemas com a urina causam-me algumas dificuldades nas atividades diárias. No entanto, não tenho perdas acidentais de urina.	2	3	t
84	Moderado: Os problemas com a urina causam-me muitas dificuldades nas atividades diárias, incluindo perdas acidentais de urina.	3	4	t
85	Grave: Não consigo reter a minha urina e uso uma fralda ou tenho sonda urinária.	4	5	t
86	Normal: Sem obstipação (prisão de ventre).	0	1	t
87	Discreto: Tive obstipação (prisão de ventre). Faço um esforço extra para evacuar. No entanto, este problema não perturba as minhas atividades ou o meu conforto.	1	2	t
88	Ligeiro: A obstipação (prisão de ventre) causa-me alguma dificuldade em fazer coisas ou em estar confortável.	2	3	t
89	Moderado: A obstipação (prisão de ventre) causa-me muita dificuldade em fazer coisas ou em estar confortável. No entanto, não me impede de fazer o que quer que seja	3	4	t
90	Grave: Habitualmente preciso da ajuda física de outra pessoa para evacuar	4	5	t
91	Normal: Não tenho a sensação de cabeça vazia ou tonturas	0	1	t
92	Discreto: Tenho a sensação de cabeça vazia ou de tonturas, mas não me causam dificuldade em fazer coisas.	1	2	t
93	Ligeiro: A sensação de cabeça vazia ou de tonturas fazem com que tenha de me segurar a alguma coisa, mas não preciso de me sentar ou deitar.	2	3	t
94	Moderado: A sensação de cabeça vazia ou de tonturas fazem com que tenha de me sentar ou deitar para evitar desmaiar ou cair.	3	4	t
95	Grave: A sensação de cabeça vazia ou de tonturas fazem com que caia ou desmaie.	4	5	t
96	Normal: Sem fadiga.	0	1	t
97	Discreto: Sinto fadiga. No entanto, não me causa dificuldade em fazer coisas ou em estar com pessoas.	1	2	t
98	Ligeiro: A fadiga causa-me alguma dificuldade em fazer coisas ou em estar com pessoas.	2	3	t
99	Moderado: A fadiga causa-me muita dificuldade em fazer coisas ou em estar com pessoas. No entanto, não me impede de fazer nada.	3	4	t
100	Grave: A fadiga impede-me de fazer coisas ou de estar com pessoas.	4	5	t
101	Normal: Não (sem problemas)	0	1	t
102	Discreto: A minha forma de falar é com uma voz baixa, arrastada ou irregular, mas os outros não me pedem para repetir.	1	2	t
103	Ligeiro: A minha forma de falar faz com que, ocasionalmente, as pessoas me peçam para repetir, mas não todos os dias.	2	3	t
104	Moderado: A minha forma de falar é pouco clara, de tal modo que, as outras pessoas me pedem para repetir todos os dias, apesar da maioria da minha fala ser compreendida.	3	4	t
105	Grave: A maioria ou toda a minha fala não é compreendida.	4	5	t
106	Discreto: Eu tenho saliva em excesso, mas não babo.	1	2	t
107	Ligeiro: Eu babo um pouco durante o sono, mas não quando estou acordado.	2	3	t
108	Moderado: Eu babo um pouco quando estou acordado, mas habitualmente não preciso de lenço.	3	4	t
109	Grave: Eu babo tanto que preciso habitualmente de usar lenços para proteger as minhas roupas.	4	5	t
110	Normal: Sem problemas.	0	1	t
111	Discreto: Estou ciente da minha lentidão ao mastigar ou da minha maior dificuldade para engolir, mas eu não me engasgo nem necessito de ter a minha comida especialmente preparada.	1	2	t
112	Ligeiro: Preciso que os meus comprimidos sejam partidos ou que a minha comida seja especialmente preparada devido aos meus problemas em mastigar ou engolir, mas não me engasguei na última semana.	2	3	t
113	Moderado: Engasguei-me pelo menos uma vez na última semana.	3	4	t
114	Grave: Devido aos meus problemas em mastigar ou engolir, preciso de ser alimentado por uma sonda.	4	5	t
115	Discreto: Sou lento, mas não preciso de ajuda para manipular os alimentos e não tenho entornado alimentos enquanto como.	1	2	t
116	Ligeiro: Sou lento com a minha alimentação e ocasionalmente entorno comida. Posso precisar de ajuda em algumas tarefas, como cortar carne.	2	3	t
117	Moderado: Preciso de ajuda em muitas tarefas durante a alimentação, mas consigo fazer algumas tarefas sozinho.	3	4	t
118	Grave: Preciso de ajuda na maioria ou para todas as tarefas relacionadas com a alimentação.	4	5	t
119	Discreto: Sou lento, mas não preciso de ajuda.	1	2	t
120	Ligeiro: Sou lento e preciso de ajuda para algumas tarefas relacionadas com o vestir (botões, braceletes).	2	3	t
121	Moderado: Preciso de ajuda em várias tarefas relacionadas com o vestir.	3	4	t
122	Grave: Preciso de ajuda na maioria ou em todas as tarefas relacionadas com o vestir.	4	5	t
123	Discreto: Sou lento, mas não preciso de ajuda para nenhuma tarefa.	1	2	t
124	Ligeiro: Preciso da ajuda de outra pessoa para algumas tarefas de higiene.	2	3	t
125	Moderado: Preciso de ajuda para várias tarefas de higiene.	3	4	t
126	Grave: Preciso de ajuda para a maioria ou para todas as tarefas de higiene.	4	5	t
127	Discreto: A minha escrita é lenta, desajeitada ou irregular, mas todas as palavras são claras.	1	2	t
128	Ligeiro: Algumas palavras são pouco claras e difíceis de ler.	2	3	t
129	Moderado: Muitas palavras são pouco claras e difíceis de ler	3	4	t
130	Grave: A maioria ou todas as palavras são ilegíveis.	4	5	t
131	Discreto: Sou um pouco lento, mas faço estas atividades facilmente.	1	2	t
132	Ligeiro: Tenho alguma dificuldade em fazer estas atividades.	2	3	t
133	Moderado: Tenho grandes problemas em fazer estas atividades, mas ainda faço a maior parte delas	3	4	t
134	Grave: Sou incapaz de fazer a maioria ou todas estas atividades.	4	5	t
135	Discreto: Tenho alguma dificuldade, mas não preciso de nenhuma ajuda.	1	2	t
136	Ligeiro: Tenho muita dificuldade em virar-me, e ocasionalmente preciso de ajuda de outra pessoa.	2	3	t
137	Moderado: Preciso frequentemente de ajuda de outra pessoa para me virar.	3	4	t
138	Grave: Sou incapaz de me virar sem a ajuda de outra pessoa.	4	5	t
139	Normal: Não, eu não tenho tremor.	0	1	t
140	Discreto: O tremor ocorre, mas não me causa problemas em nenhuma atividade.	1	2	t
141	Ligeiro: O tremor causa problemas apenas em poucas atividades.	2	3	t
142	Moderado: O tremor causa problemas em muitas atividades diárias.	3	4	t
143	Grave: O tremor causa problemas na maioria ou em todas as atividades.	4	5	t
144	Discreto: Sou lento ou desajeitado, mas consigo, normalmente, na minha primeira tentativa.	1	2	t
145	Ligeiro: Preciso de mais de uma tentativa para me levantar, ou ocasionalmente preciso de ajuda.	2	3	t
146	Moderado: Por vezes, preciso de ajuda para me levantar, mas na maioria das vezes consigo fazê-lo sozinho.	3	4	t
147	Grave: Preciso de ajuda a maior parte ou todo o tempo.	4	5	t
148	Discreto: Sou discretamente lento ou arrasto uma perna. Nunca uso um auxílio para andar.	1	2	t
149	Ligeiro: Ocasionalmente, utilizo um auxílio para andar (bengala, muleta, andador), mas não preciso de ajuda de outra pessoa.	2	3	t
150	Moderado: Habitualmente, utilizo um auxílio para andar com mais segurança, sem\r\ncair. No entanto, geralmente não preciso do apoio de outra pessoa.	3	4	t
151	Grave: Habitualmente, utilizo o apoio de outra pessoa para andar de forma\r\nsegura, sem cair.	4	5	t
152	Discreto: Tenho bloqueios breves mas consigo facilmente começar a andar novamente. Não preciso da ajuda de outra pessoa ou de um auxílio para andar (bengala, muleta ou andador) devido aos bloqueios.	1	2	t
153	Ligeiro: Bloqueio e tenho problemas quando começo a andar novamente, mas não preciso de ajuda de outra pessoa ou de um auxílio para andar (bengala, muleta ou andador) devido aos bloqueios.	2	3	t
154	Moderado: Quando bloqueio tenho muita dificuldade em começar a andar novamente e, devido aos bloqueios, preciso, por vezes, de usar um auxílio para andar (bengala, muleta ou andador) ou a ajuda de outra pessoa.	3	4	t
155	Grave: Devido aos bloqueios, na maior parte ou todo o tempo, preciso de usar um auxílio para andar (bengala, muleta ou andador) ou a ajuda de outra pessoa.	4	5	t
156	Não	0	1	t
157	Sim	0	2	t
159	OFF	0	2	t
158	ON	0	1	t
160	Informe quantos minutos	0	1	t
161	Normal: Sem problemas de fala.	0	1	t
162	Discreto: Perda de modulação, dicção ou volume, mas todas as palavras são facilmente compreensíveis.	1	2	t
163	Ligeiro: Perda de modulação, dicção ou volume, com algumas palavras não claras, mas a frase como um todo é fácil de compreender.	2	3	t
164	Moderado: A fala é difícil de compreender ao ponto de algumas, mas não a maioria das frases, serem difíceis de compreender.	3	4	t
165	Grave: A maioria da fala é difícil de compreender ou ininteligível	4	5	t
166	Normal: Expressão facial normal.	0	1	t
168	Ligeiro: Além da diminuição da frequência do piscar de olhos, presença de fácies inexpressiva na parte inferior da face, particularmente nos movimentos da boca, tal como menos sorriso  espontâneo, mas sem afastamento dos lábios.	2	3	t
167	Discreto: Mínima fácies inexpressiva manifestada apenas pela diminuição na frequência do piscar de olhos.	1	2	t
169	Moderado: Fácies inexpressiva com afastamento dos lábios por algum tempo quando a boca está em repouso.	3	4	t
170	Grave: Fácies inexpressiva com afastamento dos lábios na maior parte do tempo quando a boca está em repouso.	4	5	t
171	Normal: Sem rigidez.	0	1	t
172	Discreto: Rigidez apenas detectada com uma manobra de ativação.	1	2	t
173	Ligeiro: Rigidez detectada sem a manobra de ativação, mas a amplitude total de movimento\r\né facilmente alcançada.	2	3	t
174	Moderado: Rigidez detectada sem a manobra de ativação; amplitude total alcançada com esforço.	3	4	t
175	Grave: Rigidez detectada sem a manobra de ativação e amplitude total de movimento não\r\nalcançada.	4	5	t
179	Grave: Não consegue ou quase não consegue executar a tarefa devido à lentidão, interrupções ou decrementos.	4	5	t
176	Discreto: Qualquer dos seguintes: a) o ritmo regular é interrompido com uma ou duas interrupções ou hesitações nos movimentos; b) lentidão mínima; c) a amplitude diminui perto do fim das 10 repetições.	1	2	t
177	Ligeiro: Qualquer um dos seguintes: a) 3 a 5 interrupções durante os movimentos; b) lentidão ligeira; c) a amplitude diminui no meio da sequência das 10 repetições.	2	3	t
178	Moderado: Qualquer um dos seguintes: a) mais de 5 interrupções durante os movimentos ou pelo menos uma pausa mais longa (bloqueio); b) lentidão moderada; c) a amplitude diminui após o primeiro movimento.	3	4	t
180	Discreto: Qualquer dos seguintes: a) o ritmo regular é interrompido com uma ou duas D interrupções ou hesitações dos movimentos; b) lentidão mínima; c) a amplitude diminui perto do fim da tarefa.	1	2	t
181	Ligeiro: Qualquer dos seguintes: a) 3 a 5 interrupções durante o movimento; b) lentidão ligeira; c) a amplitude diminui no meio da tarefa.	2	3	t
182	Moderado: Qualquer dos seguintes: a) mais de 5 interrupções durante o movimento ou pelo menos uma pausa mais prolongada (bloqueio); b) lentidão moderada; c) a amplitude diminui após a primeira sequência de abrir e fechar.	3	4	t
183	Grave: Não consegue ou quase não consegue executar a tarefa devido à lentidão, interrupções ou decrementos.	4	5	t
184	Discreto: Qualquer dos seguintes: a) o ritmo regular é interrompido com uma ou duas D interrupções ou hesitações dos movimentos; b) lentidão mínima; c) a amplitude diminui perto do fim da sequência.	1	2	t
185	Ligeiro: Qualquer dos seguintes: a) 3 a 5 interrupções durante o movimento; b) lentidão ligeira; c) a amplitude diminui no meio da sequência.	2	3	t
186	Moderado: Qualquer dos seguintes: a) mais de 5 interrupções durante o movimento ou pelo menos uma pausa mais prolongada (bloqueio); b) lentidão moderada; c) a amplitude diminui após a primeira sequência de pronação-supinação.	3	4	t
187	Grave: Não consegue ou quase não consegue executar a tarefa devido à lentidão, interrupções ou decrementos.	4	5	t
188	Discreto: Qualquer dos seguintes: a) o ritmo regular é interrompido com uma ou  duas interrupções ou hesitações dos movimentos; b) lentidão mínima; c) a amplitude diminui perto do fim das 10 repetições.	1	2	t
189	Ligeiro: Qualquer dos seguintes: a) 3 a 5 interrupções durante o movimento; b) lentidão ligeira; c) a amplitude diminui a meio da tarefa.	2	3	t
190	Moderado: Qualquer dos seguintes: a) mais de 5 interrupções durante a sequência ou pelo menos uma pausa mais prolongada (bloqueio); b) lentidão moderada; c) a amplitude diminui após a primeira repetição.	3	4	t
191	Grave: Não consegue ou quase não consegue executar a tarefa devido à lentidão, interrupções ou decrementos.	4	5	t
192	Discreto: Qualquer dos seguintes: a) o ritmo regular é interrompido com uma ou  duas interrupções ou hesitações dos movimentos; b) lentidão discreta;  c) a amplitude diminui perto do fim da tarefa.	1	2	t
193	Ligeiro: Qualquer dos seguintes: a) 3 a 5 interrupções durante os movimentos; b) lentidão ligeira; c) a amplitude diminui no meio da tarefa.	2	3	t
194	Moderado: Qualquer dos seguintes: a) mais de 5 interrupções durante a sequência ou pelo menos uma pausa mais prolongada (bloqueio); b) lentidão moderada; c) a amplitude diminui após o primeiro movimento.	3	4	t
195	Grave: Não consegue ou quase não consegue executar a tarefa devido à lentidão, interrupções ou decrementos.	4	5	t
196	Normal: Sem problemas. Capaz de se levantar rapidamente sem hesitações.	0	1	t
197	Discreto: O levantar é mais lento que o normal; ou pode ser necessária mais que uma tentativa; ou pode ser necessário mover-se à frente na cadeira para se levantar. Sem necessidade de usar os braços da cadeira.	1	2	t
198	Ligeiro: Empurra-se para cima usando os braços da cadeira sem dificuldade.	2	3	t
199	Moderado: Necessita de se empurrar, mas tende a cair para trás; ou pode ter de tentar mais do que uma vez utilizando os braços da cadeira, mas consegue levantar-se sem ajuda.	3	4	t
200	Grave: Incapaz de se levantar sem ajuda.	4	5	t
201	Discreto: Marcha independente com mínima alteração.	1	2	t
202	Ligeiro: Marcha independente mas com alteração substancial.	2	3	t
203	Moderado Precisa de um auxílio de marcha (bengala, muleta, andador) para andar em segurança, mas não de outra pessoa.	3	4	t
204	Grave: Incapaz de caminhar ou consegue apenas com ajuda de outra pessoa.	4	5	t
205	Normal: Sem bloqueio na marcha (freezing).	0	1	t
206	Discreto: Bloqueio ao iniciar a marcha, ao se virar ou ao atravessar portas com apenas uma\r\ninterrupção durante qualquer um destes eventos, mas depois continua sem bloqueios durante a marcha em linha reta.	1	2	t
207	Ligeiro: Bloqueio no início, nas voltas ou ao atravessar portas com mais de uma interrupção durante qualquer uma destas atividades, mas depois continua sem bloqueios durante a marcha em linha reta.	2	3	t
208	Moderado: Bloqueia uma vez durante a marcha em linha reta.	3	4	t
209	Grave: Bloqueia várias vezes durante a marcha em linha reta.	4	5	t
210	Normal: Sem problemas. Recupera com um ou dois passos	0	1	t
211	Discreto: 3 a 5 passos, mas o paciente recupera sem ajuda.	1	2	t
212	Ligeiro: Mais de 5 passos, mas o paciente recupera sem ajuda.	2	3	t
213	Moderado: Mantém-se de pé em segurança, mas com ausência de resposta postural; cai se não for\r\naparado pelo avaliador.	3	4	t
214	Grave: Muito instável, tende a perder o equilíbrio espontaneamente ou com um ligeiro puxão nos\r\nombros.	4	5	t
215	Discreto: O paciente não está completamente ereto, mas a postura pode ser normal para uma pessoa mais idosa.	1	2	t
216	Ligeiro: Evidente flexão, escoliose ou inclinação lateral, mas o paciente consegue corrigir e adotar uma postura normal quando solicitado.	2	3	t
217	Moderado: Postura encurvada, escoliose ou inclinação lateral, que não pode ser voluntariamente corrigida pelo paciente até uma postura normal	3	4	t
218	Grave: Flexão, escoliose ou inclinação com postura extremamente anormal.	4	5	t
219	Discreto: Lentidão global e pobreza de movimentos espontâneos discreta.	1	2	t
220	Ligeiro: Lentidão global e pobreza de movimentos espontâneos ligeira.	2	3	t
221	Moderado: Lentidão global e pobreza de movimentos espontâneos moderada.	3	4	t
222	Grave: Lentidão global e pobreza de movimentos espontâneos grave.	4	5	t
223	Normal: Sem tremor	0	1	t
224	Discreto: O tremor está presente mas tem menos de 1 cm de amplitude.	1	2	t
225	Ligeiro: O tremor tem pelo menos 1 cm mas menos de 3 cm de amplitude.	2	3	t
226	Moderado: O tremor tem pelo menos 3 cm, mas menos de 10 cm de amplitude.	3	4	t
227	Grave: O tremor tem pelo menos 10 cm de amplitude.	4	5	t
228	Discreto: O tremor está presente mas tem menos de 1 cm de amplitude.	1	2	t
229	Ligeiro: O tremor tem pelo menos 1 cm mas menos de 3 cm de amplitude.	2	3	t
230	Moderado: O tremor tem pelo menos 3 cm mas menos de 10 cm de amplitude.	3	4	t
231	Grave: O tremor tem pelo pelo menos 10 cm de amplitude.	4	5	t
232	Discreto.: ≤1 cm de amplitude máxima.	1	2	t
233	Ligeiro: > 1 cm mas < 3 cm de amplitude máxima.	2	3	t
234	Moderado: 3 - 10 cm de amplitude máxima.	3	4	t
235	Grave: > 10 cm de amplitude máxima.	4	5	t
236	Discreto: ≤ 1 cm de amplitude máxima.	1	2	t
237	Ligeiro: > 1 cm mas ≤ 2 cm de amplitude máxima.	2	3	t
238	Moderado: > 2 cm mas ≤ 3 cm de amplitude máxima.	3	4	t
239	Grave: > 3 cm de amplitude máxima.	4	5	t
240	Discreto: Tremor de repouso presente durante ≤ 25% do tempo de avaliação.	1	2	t
241	Ligeiro: Tremor de repouso presente durante 26-50% do tempo de avaliação.	2	3	t
242	Moderado: Tremor de repouso presente durante 51-75% do tempo de avaliação.	3	4	t
243	Grave: Tremor de repouso presente durante > 75% do tempo de avaliação.	4	5	t
244	Assintomático.	0	1	t
245	Apenas envolvimento unilateral.	1	2	t
246	Envolvimento bilateral sem alteração do equilíbrio.	2	3	t
247	Envolvimento ligeiro a moderado, alguma instabilidade postural mas independente fisicamente; necessita de ajuda para recuperar do teste do puxão.	3	4	t
248	Incapacidade grave; ainda consegue andar ou ficar de pé sem ajuda.	4	5	t
249	Confinado a cadeira de rodas ou acamado, se não for ajudado.	5	6	t
250	Normal: Sem discinesias.	0	1	t
251	Discreto: ≤ 25% do período do dia em que está acordado.	1	2	t
252	Ligeiro: 26 - 50% do período do dia em que está acordado.	2	3	t
253	Moderado: 51 - 75% do período do dia em que está acordado.	3	4	t
254	Grave: > 75% do período do dia em que está acordado.	4	5	t
255	Normal: Sem discinesias ou sem impacto das discinesias nas atividades ou interações sociais.	0	1	t
256	Discreto: As discinesias têm impacto em algumas atividades mas o paciente habitualmente realiza todas as suas atividades e participa em interações sociais durante o período em que tem discinesias.	1	2	t
257	Ligeiro: As discinesias têm impacto sobre muitas atividades mas o paciente habitualmente realiza todas as suas atividades e participa em interações sociais durante os episódios de discinesias.	2	3	t
258	Moderado: As discinesias têm impacto em atividades ao ponto de o paciente habitualmente não\r\nrealizar algumas das suas atividades ou não participa em algumas atividades sociais durante o período em que tem discinesias.	3	4	t
259	Grave: As discinesias têm impacto na funcionalidade ao ponto de o paciente habitualmente não realizar a maioria das atividades ou não participar na maioria das atividades sociais durante os episódios de discinesias.	4	5	t
260	Normal: Sem período OFF.	0	1	t
261	Discreto: ≤ 25% do período do dia em que está acordado.	1	2	t
262	Ligeiro: 26 - 50% do período do dia em que está acordado.	2	3	t
263	Moderado: 51 - 75% do período do dia em que está acordado.	3	4	t
264	Grave: > 75% do período do dia em que está acordado.	4	5	t
265	Normal: Sem flutuações ou flutuações sem impacto nas atividades ou interações sociais.	0	1	t
266	Discreto: As flutuações têm impacto em algumas atividades, mas durante o OFF o paciente realiza habitualmente todas as suas atividades e participa em interações sociais que tipicamente ocorrem durante o período ON.	1	2	t
267	Ligeiro: As flutuações têm impacto sobre muitas atividades, mas durante o OFF, o paciente ainda realiza habitualmente todas as suas atividades e participa em interações sociais que tipicamente ocorrem durante o estado ON.	2	3	t
268	Moderado: As flutuações têm impacto sobre as atividades durante o OFF ao ponto de o paciente não realizar habitualmente algumas atividades ou não participar em algumas interações sociais que são realizadas no período ON.	3	4	t
269	Grave: As flutuações têm impacto sobre a funcionalidade ao ponto de, durante o OFF, o paciente não desempenhar a maioria das atividades ou não participar na maioria das interações sociais que ocorrem durante o período ON.	4	5	t
270	Normal: Sem flutuações motoras.	0	1	t
271	Discreto: Períodos de OFF são previsíveis em todo ou quase todo o tempo (> 75%).	1	2	t
272	Ligeiro: Períodos de OFF são previsíveis a maior parte do tempo (51-75%).	2	3	t
273	Moderado: Períodos de OFF são previsíveis alguma parte do tempo (26-50%).	3	4	t
274	Grave: Episódios de OFF são raramente previsíveis (< 25%).	4	5	t
275	Normal: Sem distonia OU SEM PERÍODO OFF.	0	1	t
276	Discreto: ≤ 25% do tempo do período OFF.	1	2	t
277	Ligeiro: 26-50% do tempo do período OFF.	2	3	t
278	Moderado: 51-75% do tempo do período OFF.	3	4	t
279	Grave: > 75% do tempo do período OFF.	4	5	t
\.


--
-- Name: alternativa_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('alternativa_id_seq', 279, true);


--
-- Data for Name: avaliacao; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY avaliacao (id, investigador, participante_fk_id, data_avaliacao, fonte_informacao, local, medicamento, observacao, finalizada, login_fk_id, tipo_questionario_fk_id) FROM stdin;
12	João	34	2020-11-29	2	Local teste	Levodopa (2 mg)	\N	f	2	4
\.


--
-- Data for Name: avaliacao_grupo_pesquisadores_login; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY avaliacao_grupo_pesquisadores_login (id, avaliacao_fk_id, grupo_pesquisadores_login_fk_id) FROM stdin;
\.


--
-- Name: avaliacao_grupo_pesquisadores_login_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('avaliacao_grupo_pesquisadores_login_id_seq', 151, true);


--
-- Name: avaliacao_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('avaliacao_id_seq', 12, true);


--
-- Data for Name: questao; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY questao (id, agrupamento_fk_id, tipo_questao_fk_id, ordem, status, titulo, descricao, instrucao, numero, contavel) FROM stdin;
37	18	1	6	t	Aspectos da síndrome de desregulação dopaminérgica	Durante a última semana, teve algum desejo extremamente forte e difícil de controlar? Sentiu-se tentado a fazer ou pensar algo e depois teve dificuldade em parar essa atividade?	Considere o envolvimento em várias atividades, incluindo jogo atípico ou excessivo (e.x., cassinos ou bilhetes de loteria), ímpeto sexual atípico ou excessivo (e.x., interesse incomum por pornografia, masturbação, exigências sexuais ao parceiro), outras atividades repetitivas (e.x., passatempos, desmontar, ordenar ou organizar objetos), ou tomar medicação extra não prescrita por razões não relacionadas com o estado físico (ou seja, comportamentos aditivos). Pontue o impacto destas atividades ou comportamentos anormais do paciente na sua vida pessoal, familiar e relações sociais (incluindo a necessidade de pedir dinheiro emprestado ou outras dificuldades financeiras como a suspensão do cartão de crédito, conflitos graves com a família, perda de horas de trabalho, de refeições ou de sono devido à atividade).	6	t
38	18	1	7	t	Problemas do sono	Durante a última semana, você teve algum problema para adormecer à noite ou em permanecer dormindo durante a noite? Considere o quanto descansado se sentiu ao acordar de manhã.		7	t
39	18	1	8	t	Sonolência diurna	Durante a última semana, teve dificuldade em manter-se acordado durante o dia?		8	t
40	18	1	9	t	Dor e outras sensações	Durante a última semana, teve sensações desconfortáveis no seu corpo tais como dor, sensação de ardor, formigamento ou cãimbras?		9	t
41	18	1	10	t	Problemas urinários	Durante a última semana, teve problemas em reter a urina? Por exemplo, necessidade urgente em urinar, necessidade de urinar vezes de mais, ou perder controlo da urina?		10	t
42	18	1	11	t	Problemas de obstipação intestinal (prisão de ventre)	Durante a última semana, teve problemas de obstipação intestinal (prisão de ventre) que lhe tenham causado dificuldade em evacuar?		11	t
43	18	1	12	t	Tonturas ao se levantar	Durante a última semana, sentiu que iria desmaiar, ficou tonto ou com sensação de cabeça vazia quando se levantou, após ter estado sentado ou deitado?		12	t
44	18	1	13	t	Fadiga	Durante a última semana, sentiu-se habitualmente fatigado? Esta sensação não é por estar com sono ou triste.		13	t
31	17	1	1	t	Classificação Hoehn e Yahr		Classificação: estágio 1 - 3: incapacidades leve a moderada; 4 - 5: incapacidade grave.	1	t
32	18	1	1	t	Disfunção cognitiva	Durante a última semana, teve dificuldade em lembrar-se de coisas, acompanhar conversas, prestar atenção, pensar claramente ou em orientar-se em casa ou na cidade?	Considere todos os tipos de alteração das funções cognitivas, incluindo lentidão cognitiva, alteração do raciocínio, perda de memória, déficit de atenção e orientação. Pontue o seu impacto nas atividades da vida diária, tal como estas são identificadas pelo paciente e/ou cuidador.	1	t
33	18	1	2	t	Alucinações e Psicose	Durante a última semana, viu, ouviu, cheirou ou\r\nsentiu coisas que não estavam realmente lá?	Considere ilusões (interpretações falsas de estímulos reais) e\r\nalucinações (sensações falsas espontâneas). Considere todos os principais domínios\r\nsensoriais (visual, auditivo, táctil, olfativo e gustativo). Determine a presença de sensações\r\nnão formadas (por exemplo, sensação de presença ou falsas impressões transitórias) bem\r\ncomo de sensações formadas (completamente desenvolvidas e detalhadas). Avalie a noção\r\nde realidade que o paciente tem em relação às alucinações e identifique delírios e\r\npensamentos psicóticos.	2	t
34	18	1	3	t	Humor depressivo	Durante a última semana, sentiu-se mal, triste, desesperado ou incapaz de apreciar coisas? Se sim, esse sentimento durou mais de um dia de cada vez? Este sentimento trouxe-lhe dificuldades em desempenhar as suas atividades habituais ou em estar com outras pessoas?	Considere desânimo, tristeza, desespero, sentimentos de vazio ou perda da capacidade de sentir prazer (anedonia). Determine a sua presença e duração na última semana e pontue a sua interferência na capacidade do paciente desempenhar rotinas diárias e envolver-se em interações sociais.	3	t
35	18	1	4	t	Ansiedade	Durante a última semana, sentiu-se nervoso, preocupado ou tenso? Se sim, este sentimento durou mais de um dia de cada vez? Isto fez com que tivesse dificuldade em realizar as suas atividades habituais ou em estar com outras pessoas?	Determine a presença da sensação de nervosismo, tensão, preocupação ou ansiedade (incluindo ataques de pânico) durante a última semana e pontue a sua duração e interferência com a capacidade do paciente desempenhar rotinas diárias e envolver-se em interações sociais.	4	t
36	18	1	5	t	Apatia	Durante a última semana, sentiu-se sem interesse em realizar atividades ou estar com pessoas?	Considere os níveis de atividade espontânea, assertividade, motivação e iniciativa e pontue o seu impacto no desempenho das rotinas diárias e interação social. Aqui, o avaliador deve tentar distinguir entre apatia e sintomas semelhantes que são melhor explicados pela depressão.	5	t
46	19	1	15	t	Saliva e baba	Durante a última semana, teve habitualmente excesso de saliva enquanto estava acordado ou enquanto estava dormindo?		2	t
48	19	1	17	t	Tarefas para comer	Durante a última semana, teve habitualmente problemas em manipular os alimentos e em utilizar os talheres para comer? Por exemplo, teve dificuldade em manusear a comida com as mãos ou a usar garfos, facas, colheres ou pauzinhos?		4	t
49	19	1	18	t	Vestir	Durante a última semana, teve habitualmente dificuldade em vestir-se? Por exemplo: é lento ou precisa de ajuda para abotoar botões, usar fechecler, vestir ou despir roupa, ou colocar ou retirar jóias?		5	t
50	19	1	19	t	Higiene	Durante a última semana, você tem estado lento ou precisou de ajuda para se lavar, tomar banho, barbear, escovar os dentes, pentear o cabelo ou para outras tarefas de higiene pessoal?		6	t
51	19	1	20	t	Escrita	Durante a última semana, as pessoas tiveram, habitualmente, dificuldade em ler o que escreveu?		7	t
52	19	1	21	t	Passatempos e outras atividades	Durante a última semana, teve, habitualmente, dificuldade em praticar os seus passatempos ou outras coisas que gosta de fazer?		8	t
53	19	1	22	t	Virar-se na cama	Durante a última semana, teve, habitualmente, dificuldade em virar-se na cama?		9	t
60	20	1	29	t	O paciente usa Levodopa?			c	f
56	19	1	25	t	Marcha e equilíbrio	Durante a última semana, teve, habitualmente, dificuldade em equilibrar-se e em andar?		12	t
57	19	1	26	t	Bloqueios na marcha	Durante a última semana, num dia normal, enquanto anda, fica de repente bloqueado ou parado como se os seus pés ficassem colados ao chão?		13	t
58	20	1	27	t	O paciente usa medicação para o tratamento dos sintomas da doença de Parkinson?			a	f
61	20	2	30	t	Se sim, minutos desde a última dose de levodopa			c1	f
62	20	1	31	t	Fala		Escute a fala espontânea do paciente e participe da conversa se\r\nnecessário. Tópicos sugeridos: pergunte sobre o trabalho do paciente, passatempos,\r\nexercício, ou como ele chegou ao consultório. Avalie o volume, modulação (prosódia) e a\r\nclareza, incluindo fala arrastada, palilalia (repetição de sílabas) e taquifemia (discurso rápido,\r\njuntando as sílabas).	1	t
63	20	1	32	t	Expressão facial		Observe o paciente sentado em repouso durante 10 segundos, sem falar e também enquanto fala. Observe a frequência do piscar de olhos, face tipo máscara ou perda de expressão facial, sorriso espontâneo ou afastamento dos lábios	2	t
64	20	1	33	t	Rigidez		A rigidez é avaliada usando movimentos passivos lentos das grandes articulações com o paciente numa posição relaxada e o avaliador manipulando os membros e pescoço. Primeiro teste sem a manobra de ativação. Teste e pontue o pescoço e cada membro separadamente. Para os braços, teste as articulações do punho e cotovelos simultaneamente. Para as pernas teste as articulações coxo-femural e do joelho simultaneamente. Se não for detectada rigidez, use uma manobra de ativação tais como bater o primeiro e o segundo dedo, abrir/fechar a mão, ou toque do calcanhar, no membro que não está sendo testado. Explique ao paciente que deve tentar relaxar o máximo possível enquanto é testada a rigidez.	3	t
65	20	1	34	t	Bater dos dedos da mão (pinça)		Cada mão é testada separadamente. Faça a demonstração da tarefa, mas não realize a tarefa enquanto o paciente é testado. Instrua o paciente para que toque com o indicador no polegar 10 vezes, o mais rápido e amplo possível. Pontue cada lado separadamente, avaliando velocidade, amplitude, hesitações, interrupções e diminuição da amplitude.	4	t
66	20	1	35	t	Movimentos das mãos		Cada mão é testada separadamente. Faça a demonstração da tarefa, mas não realize a tarefa enquanto o paciente é testado. Instrua o paciente a fechar a mão com força com o braço fletido ao nível do cotovelo de forma que a palma da mão esteja virada para o avaliador. Peça ao paciente para abrir a mão 10 vezes o mais rápido e amplo possível. Se o paciente não fechar a mão firmemente ou não abrir a mão por completo, lembre-o de o fazer. Pontue cada lado separadamente, avaliando velocidade, amplitude, hesitações, interrupções e diminuições da amplitude.	5	t
67	20	1	36	t	Movimentos de pronação-supinação das mãos		Cada mão é testada separadamente. Faça a demonstração da tarefa, mas não realize a tarefa enquanto o paciente é testado. Instrua o paciente a estender o braço em frente ao seu corpo com a palma da mão virada para baixo; depois a virar a palma da mão para cima e para baixo alternadamente 10 vezes o mais rápido e amplo possível. Pontue cada lado separadamente, avaliando velocidade, amplitude, hesitações, interrupções e diminuições da amplitude.	6	t
68	20	1	37	t	Bater dos dedos dos pés		Coloque o paciente sentado numa cadeira de encosto reto e com braços, com ambos os pés no chão. Teste cada pé separadamente. Faça a demonstração da tarefa, mas não realize a tarefa enquanto o paciente é testado. Instrua o paciente a colocar o calcanhar no chão numa posição confortável e depois tocar com os dedos dos pés 10 vezes no chão, o mais rápido e amplo possível. Pontue cada lado\r\nseparadamente, avaliando velocidade, amplitude, hesitações, interrupções e diminuições da\r\namplitude.	7	t
69	20	1	38	t	Agilidade das pernas		Coloque o paciente sentado numa cadeira de encosto reto e com braços, com ambos os pés confortavelmente no chão. Teste cada pé separadamente. Faça a demonstração da tarefa, mas não realize a tarefa enquanto o paciente é testado. Instrua o paciente a colocar o pé no chão numa posição confortável e depois a levantá-lo e batê-lo no chão 10 vezes, o mais rápido e alto possível. Pontue cada lado separadamente, avaliando velocidade, amplitude, hesitações, interrupções e diminuições da amplitude	8	t
71	20	1	40	t	Marcha		A avaliação da marcha é melhor realizada solicitando que o paciente caminhe para longe e depois em direção ao avaliador para que quer o lado direito, quer o lado esquerdo do corpo possam ser facilmente observados simultaneamente. O paciente deve andar pelo menos 10 metros (30 pés), depois dar a volta e regressar para junto do avaliador. Este item mede vários comportamentos: amplitude dos passos, velocidade do passos, altura da elevação do pés, contato do calcanhar durante a marcha, dar a volta, e o balanceio dos braços, mas não o bloqueio da marcha (freezing). Aproveite para avaliar o bloqueio da marcha (freezing) (próximo item 3.11) enquanto o paciente caminha. Observe postura para o item 3.13.	10	t
72	20	1	41	t	Bloqueio na marcha (freezing)		Enquanto avalia a marcha, avalie também a presença de qualquer episódio de bloqueio na marcha (freezing). Procure hesitações no início e titubeação nos movimentos especialmente quando se vira e atinge o final da tarefa. Na medida em que a segurança permitir, os pacientes NÃO podem usar truques sensoriais durante a avaliação.	11	t
79	20	1	48	t	Amplitude do tremor de repouso - Lábio/Mandíbula			17	t
85	21	1	54	t	Impacto funcional das discinesias	Durante a última semana você teve habitualmente dificuldade em fazer coisas ou estar com outras pessoas quando estes movimentos involuntários acontecem? Os movimentos impediram-no(a) de fazer as coisas ou de estar com outras pessoas?	Determine o grau do impacto das discinesias na funcionalidade diária do paciente em termos das atividades e interações sociais. Use as respostas do paciente e do cuidador, bem como as suas observações durante a consulta para chegar à melhor resposta.	2	t
74	20	1	43	t	Postura		A postura é avaliada com o paciente em posição ereta após se ter levantado da cadeira, durante a marcha, e enquanto são testados os reflexos posturais. Se notar uma postura incorreta, diga ao paciente para se posicionar direito e observe se a postura melhora (ver a opção 2 abaixo). Pontue a pior postura observada nestes três momentos de observação. Esteja atento à flexão e inclinação lateral.	13	t
75	20	1	44	t	Espontaneidade global de movimento (bradicinesia corporal)		Esta pontuação global combina todas as observações de lentidão, hesitação e pequena amplitude e pobreza de movimentos em geral, incluindo a redução da gesticulação e do cruzamento de pernas. Esta avaliação é baseada na impressão global do avaliador após observar os gestos espontâneos enquanto sentado, e a forma do levantar e andar	14	t
76	20	1	45	t	Tremor postural das mãos		Todo o tremor, incluindo o tremor de repouso reemergente, que está presente na postura é incluído nesta pontuação. Pontue cada mão separadamente. Pontue a maior amplitude observada. Instrua o paciente a estender os braços em frente do corpo com as palmas das mãos viradas para baixo. O punho deve estar reto e os dedos confortavelmente separados para que não se toquem. Observe esta postura durante 10 segundos.	15	t
77	20	1	46	t	Tremor cinético das mãos		Este tremor é testado através da manobra de dedo-nariz. Iniciando com o braço estendido, peça ao paciente que execute pelo menos três manobras dedo-nariz com cada mão, chegando o mais longe possível para tocar o dedo do avaliador. A manobra dedo-ao-nariz deve ser executada com lentidão suficiente para que o tremor não seja ocultado, o que pode acontecer com movimentos muito rápidos do braço. Repetir com a outra mão, pontuando cada mão separadamente. O tremor pode estar presente durante o movimento ou quando se alcança qualquer um dos alvos (nariz ou dedo). Pontue a maior amplitude observada.	16	t
80	20	1	49	t	Persistência do tremor de repouso		Este item recebe uma pontuação única para todo o tremor de repouso e foca-se na persistência do tremor de repouso durante o período de avaliação quando diferentes partes do corpo estão em repouso. Este item é pontuado deliberadamente no final da avaliação para que vários minutos de informação possam ser reunidos em uma única pontuação.	18	t
81	20	1	50	t	IMPACTO DAS DISCINESIAS NAS PONTUAÇÕES DA PARTE III - A. Estiveram presentes discinesias (coreia ou distonia) durante a avaliação?			19	f
82	20	1	51	t	IMPACTO DAS DISCINESIAS NAS PONTUAÇÕES DA PARTE III - B. Se sim, estes movimentos interferiram com as suas pontuações?			20	f
83	20	1	52	t	Estadiamento de hoehn e yahr			21	t
84	21	1	53	t	Tempo com discinesias	Durante a última semana quantas horas habitualmente dormiu no total, incluindo o sono noturno e as sonecas diurnas? Muito bem, se dorme ___ horas, está acordado ____ horas. Dessas horas acordado(a), em quantas horas no total tem movimentos irregulares, repentinos ou de contorção? Não considere os períodos em que está com tremor, que é um movimento regular oscilante, nem períodos em que tem cãibras dolorosas ou espasmos nos pés no início da manhã ou à noite. Eu irei perguntar-lhe acerca destes mais tarde. Concentre-se apenas nesses tipos de movimentos irregulares, repentinos ou de contorção. Some todo o tempo durante o dia em que está acordado quando estes movimentos habitualmente ocorrem. Quantas horas _____ (utilize este número para os seus cálculos)?	Determine o número de horas por dia em que o paciente está acordado e depois o número de horas com discinesias. Calcule a percentagem. Se o paciente apresentar discinesias no consultório, pode usá-las como referência para assegurar que os pacientes e os cuidadores compreendem o que estão pontuando. Você pode também fazer uma representação dos movimentos discinéticos que observou anteriormente no paciente ou mostrar-lhe movimentos discinéticos típicos de outros pacientes. Exclua desta questão a distonia dolorosa matinal e noturna.	1	t
45	19	1	14	t	Fala	Durante a última semana, teve dificuldades com a sua fala?		1	t
47	19	1	16	t	Mastigação e deglutição	Durante a última semana, teve habitualmente problemas em engolir comprimidos ou em comer as refeições? Precisa que os seus comprimidos sejam cortados ou amassados ou que as suas refeições sejam pastosas, picadas ou batidas para evitar engasgar-se?		3	t
54	19	1	23	t	Tremor	Durante a última semana, teve, habitualmente, tremor?		10	t
55	19	1	24	t	Sair da cama, do carro ou de uma cadeira baixa	Durante a última semana, teve, habitualmente, dificuldade em levantar-se da cama, do assento do carro, ou de uma cadeira baixa?		11	t
59	20	1	28	t	Se o paciente recebe medicação para o tratamento dos sintomas da doença de Parkinson, marque o estado clínico do paciente usando as seguintes definições		ON: On é o estado funcional típico de quando os pacientes estão a tomar medicação e têm uma boa resposta.\r\nOFF: Off é o estado funcional típico de quando os pacientes têm uma resposta fraca apesar de tomarem medicação.	b	f
70	20	1	39	t	Levantar-se da cadeira		Coloque o paciente sentado numa cadeira de encosto reto e com braços, com ambos os pés no chão e costas no fundo da cadeira (se o paciente não for muito baixo). Peça ao paciente para cruzar os seus braços sobre o peito e depois levantar-se. Se o paciente não conseguir, tentar novamente até um máximo de duas vezes. Se ainda assim não conseguir, permitir ao paciente que se chegue à frente na cadeira para se levantar com os braços cruzados ao nível do peito. Permitir apenas uma\r\ntentativa nesta situação. Se sem sucesso, permitir que o paciente se empurre usando as mãos nos braços da cadeira. Permitir um máximo de três tentativas usando esta estratégia. Se ainda assim não conseguir, ajude o paciente a levantar-se. Após o paciente estar de pé, observe a postura para o item 3.13.	9	t
86	21	1	55	t	Tempo em OFF	Alguns pacientes com doença de Parkinson têm um bom efeito da medicação durante o período em que estão acordados e chamamos a isso período “ON”. Outros pacientes tomam a sua medicação mas ainda assim têm alguns momentos maus, momentos difíceis, momentos de lentidão ou momentos do tremor. Os médicos chamam a isso período “OFF”. Durante a semana passada, já me disse que estava geralmente acordado(a)____horas por dia. Dessas horas acordado(a), quantas horas no total é que tem este tipo de período difícil ou em OFF ____ (use este número para os seus cálculos).	Use o número de horas que o paciente está acordado proveniente do item 4.1 e determine o número de horas passadas em “OFF”. Calcule a percentagem. Se o paciente tiver um período OFF no consultório, pode apontar esse estado como uma referência. Pode também usar o seu conhecimento\r\ndo paciente para descrever o período OFF típico. Pode ainda fazer uma representação de um período OFF que observou anteriormente no paciente ou mostrar-lhe o típico estado de OFF de outro paciente. Escreva o número típico de horas em OFF porque precisará desse número para completar o item 4.6.	3	t
87	21	1	56	t	Impacto funcional das flutuações	Pense naqueles períodos difíceis ou em “OFF” que ocorreram durante a última semana. Tem habitualmente mais problemas para fazer coisas ou em estar com pessoas, comparando estas horas com o resto do dia quando sente que a medicação está fazendo efeito? Há alguma coisa que faz durante o seu período bom que tenha dificuldade em fazer ou interrompe quando está no seu período difícil?	Determine o grau de impacto das flutuações motoras na funcionalidade diária do paciente em termos de atividades e interações sociais. Esta questão concentra-se na diferença entre o período ON e o período OFF. Se o paciente não tem períodos OFF, a pontuação deve ser 0, mas se o paciente tem flutuações muito ligeiras, é também possível pontuar 0 neste item se não houver impacto nas atividades. Utilize as respostas do paciente e do cuidador e as suas observações no consultório para chegar à melhor resposta.	4	t
88	21	1	57	t	Complexidade das flutuações motoras	Para alguns pacientes, os períodos difíceis ou “OFF” ocorre em momentos específicos do dia ou quando fazem atividades como comer ou exercício. Durante a última semana, soube habitualmente quando iam ocorrer estes períodos difíceis? Em outras palavras, esses períodos difíceis aparecem sempre num momento específico? Aparecem a maioria das vezes em um momento específico? Aparecem apenas algumas vezes num momento específico? Esses períodos são totalmente imprevisíveis?	Determine a previsibilidade do aparecimento do período em OFF, quer devido à dose, hora do dia, ingestão de alimentos ou outros fatores. Use a informação fornecida pelo paciente e cuidador e complemente com as suas observações. Pergunte ao paciente se consegue prever o seu aparecimento sempre num momento específico, predominantemente em um momento específico (caso em que deverá investigar mais para distinguir mínima de ligeira), aparece apenas por vezes num momento específico ou se são totalmente imprevisíveis? Restringir a percentagem permitirá que você descubra a resposta correta	5	t
89	21	1	58	t	Distonia dolorosa do período OFF	Numa questão que lhe coloquei anteriormente, disse-me que normalmente tem ___ horas em “OFF” quando a sua doença de Parkinson está mal controlada. Durante estes períodos difíceis ou em “OFF”, em geral, tem cãibras dolorosas ou espasmos? Do total de ____ horas deste período difícil, se somar todo o tempo em um dia quando estas cãibras dolorosas ocorrem, quantas horas perfaz?	Para os pacientes que têm flutuações motoras, determine qual a proporção habitual dos episódios de OFF que incluem distonia dolorosa? Você já determinou o número de horas do período “OFF” (4.3). Determine quantas dessas horas estão associadas com distonia e calcule a percentagem. Se não houver períodos de OFF, marque 0.	6	t
73	20	1	42	t	Estabilidade postural		Este teste avalia a resposta ao movimento súbito do corpo produzido por um puxão rápido e forte sobre os ombros, enquanto o paciente está de pé com os olhos abertos e os pés confortavelmente afastados e paralelos um ao outro. Teste a retropulsão. Posicione-se atrás do paciente e instrua-o sobre o que ocorrerá. Explique ao paciente que pode dar um passo atrás para evitar a queda. Deve\r\nhaver uma parede sólida atrás do avaliador a, pelo menos, 1-2 metros de distância para permitir a observação do número de passos atrás. O primeiro puxão é uma demonstração instrutiva e é deliberadamente mais suave e não pontuado. Na segunda vez os ombros devem ser puxados rápida e bruscamente em direção ao avaliador com força suficiente para deslocar o centro de gravidade de modo a que o paciente tenha de dar um passo para trás. O avaliador deve estar preparado para amparar o paciente, mas deve estar suficientemente afastado para permitir espaço suficiente para o paciente dar vários passos e recuperar de forma independente. Não permita que o paciente flexione o corpo anormalmente em antecipação ao puxão. Observe o número de passos para trás ou a queda. Até inclusive dois passos para a recuperação é considerado normal, por isso uma pontuação anormal começa aos três passos. Se o paciente não compreender o teste, o avaliador pode repetí-lo para que a pontuação seja baseada numa avaliação que o avaliador sinta que reflete as limitações do paciente e não a falta de compreensão ou preparação. Observe a postura em pé para o item 3.13	12	t
78	20	1	47	t	Amplitude do tremor de repouso		Este e o próximo item foram colocados deliberadamente no final da avaliação para permitir ao avaliador reunir observações sobre o tremor de repouso que podem ter surgido a qualquer momento da avaliação, incluindo quando o paciente está calmamente sentado, durante a marcha e durante as atividades em que algumas partes do corpo estão em movimento, mas outras estão em repouso. Pontue a amplitude máxima observada em qualquer momento, como a pontuação final. Pontue apenas a amplitude e não a persistência ou a intermitência do tremor. Como parte desta pontuação, o paciente deve sentar-se calmamente numa cadeira, com as mãos colocadas nos braços da cadeira (e não no colo) e os pés confortavelmente apoiados no chão durante 10 segundos sem nenhuma outra instrução. O tremor de repouso é avaliado separadamente para os quatro membros e também para o lábio/mandíbula. Pontue apenas a amplitude máxima observada a qualquer momento, sendo essa a pontuação final.	17	t
\.


--
-- Data for Name: questao_alternativa; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY questao_alternativa (id, questao_fk_id, alternativa_fk_id) FROM stdin;
131	31	28
132	31	29
133	31	30
134	31	31
135	31	32
136	31	33
137	31	34
138	31	35
139	32	36
140	32	37
141	32	38
142	32	39
143	32	40
144	33	41
145	33	42
146	33	43
147	33	44
148	33	45
149	34	46
150	34	47
151	34	48
152	34	49
153	34	50
154	35	51
155	35	52
156	35	53
157	35	54
158	35	55
159	36	56
160	36	57
161	36	58
162	36	59
163	36	60
164	37	61
165	37	62
166	37	63
167	37	64
168	37	65
169	38	66
170	38	67
171	38	68
172	38	69
173	38	70
174	39	71
175	39	72
176	39	73
177	39	74
178	39	75
179	40	76
180	40	77
181	40	78
182	40	79
183	40	80
184	41	81
185	41	82
186	41	83
187	41	84
188	41	85
189	42	86
190	42	87
191	42	88
192	42	89
193	42	90
194	43	91
195	43	92
196	43	93
197	43	94
198	43	95
199	44	96
200	44	97
201	44	98
202	44	99
203	44	100
204	45	101
205	45	102
206	45	103
207	45	104
208	45	105
209	46	101
210	46	106
211	46	107
212	46	108
213	46	109
214	47	110
215	47	111
216	47	112
217	47	113
218	47	114
220	48	101
221	48	115
222	48	116
223	48	117
224	48	118
225	49	101
226	49	119
227	49	120
228	49	121
229	49	122
231	50	101
232	50	123
233	50	124
234	50	125
235	50	126
238	51	101
239	51	127
240	51	128
241	51	129
242	51	130
243	52	101
244	52	131
245	52	132
246	52	133
247	52	134
249	53	101
250	53	135
251	53	136
252	53	137
253	53	138
254	54	139
255	54	140
256	54	141
257	54	142
258	54	143
261	55	101
262	55	144
263	55	145
264	55	146
265	55	147
269	56	101
270	56	148
271	56	149
272	56	150
273	56	151
278	57	101
279	57	152
280	57	153
281	57	154
282	57	155
283	58	156
284	58	157
285	59	158
286	59	159
287	60	156
288	60	157
289	61	160
290	62	161
291	62	162
292	62	163
293	62	164
294	62	165
295	63	166
296	63	167
297	63	168
298	63	169
299	63	170
300	64	171
301	64	172
302	64	173
303	64	174
304	64	175
306	65	66
307	65	176
308	65	177
309	65	178
310	65	179
313	66	66
314	66	180
315	66	181
316	66	182
317	66	183
321	67	66
322	67	184
323	67	185
324	67	186
325	67	187
330	68	66
331	68	188
332	68	189
333	68	190
334	68	191
335	69	66
336	69	192
337	69	193
338	69	194
339	69	195
340	70	196
341	70	197
342	70	198
343	70	199
344	70	200
346	71	66
347	71	201
348	71	202
349	71	203
350	71	204
351	72	205
352	72	206
353	72	207
354	72	208
355	72	209
356	73	210
357	73	211
358	73	212
359	73	213
360	73	214
361	74	110
362	74	215
363	74	216
364	74	217
365	74	218
367	75	110
368	75	219
369	75	220
370	75	221
371	75	222
372	76	223
373	76	224
374	76	225
375	76	226
376	76	227
379	77	223
380	77	228
381	77	229
382	77	230
383	77	231
384	78	110
385	78	232
386	78	233
387	78	234
388	78	235
391	79	236
392	79	237
393	79	238
394	79	239
397	80	223
398	80	240
399	80	241
400	80	242
401	80	243
405	81	156
409	81	157
413	82	156
417	82	157
418	83	244
419	83	245
420	83	246
421	83	247
422	83	248
423	83	249
424	84	250
425	84	251
426	84	252
427	84	253
428	84	254
429	85	255
430	85	256
431	85	257
432	85	258
433	85	259
434	86	260
435	86	261
436	86	262
437	86	263
438	86	264
439	87	265
440	87	266
441	87	267
442	87	268
443	87	269
444	88	270
445	88	271
446	88	272
447	88	273
448	88	274
449	89	275
450	89	276
451	89	277
452	89	278
453	89	279
454	79	223
\.


--
-- Name: questao_alternativa_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('questao_alternativa_id_seq', 454, true);


--
-- Name: questao_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('questao_id_seq', 89, true);


--
-- Data for Name: questao_tipo_aplicacao; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY questao_tipo_aplicacao (id, questao_fk_id, tipo_aplicacao_fk_id) FROM stdin;
83	60	9
84	61	9
85	62	9
86	63	9
87	64	3
88	64	4
89	64	5
90	64	6
91	64	8
92	65	1
93	65	2
94	66	1
95	66	2
96	67	1
97	67	2
98	68	1
99	68	2
100	69	1
101	69	2
102	70	9
103	71	9
104	72	9
105	73	9
106	74	9
107	75	9
108	76	1
109	76	2
110	77	1
111	77	2
122	78	3
123	78	4
124	78	5
125	78	6
126	79	9
127	80	9
128	81	9
129	82	9
131	83	9
132	84	9
133	85	9
134	86	9
53	31	9
54	32	9
55	33	9
56	34	9
57	35	9
58	36	9
59	37	9
60	38	9
61	39	9
62	40	9
63	41	9
64	42	9
65	43	9
66	44	9
67	45	9
68	46	9
69	47	9
70	48	9
71	49	9
72	50	9
73	51	9
74	52	9
75	53	9
76	54	9
77	55	9
78	56	9
79	57	9
80	58	9
135	87	9
82	59	9
136	88	9
138	89	9
\.


--
-- Name: questao_tipo_aplicacao_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('questao_tipo_aplicacao_id_seq', 138, true);


--
-- Data for Name: resposta; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY resposta (id, avaliacao_fk_id, tipo_questionario_fk_id, alternativa_fk_id, tipo_aplicacao_fk_id, login_fk_id, data_registro, alternativa_descritiva, questao_fk_id) FROM stdin;
\.


--
-- Name: resposta_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('resposta_id_seq', 397, true);


--
-- Data for Name: tipo_aplicacao; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY tipo_aplicacao (id, descricao, sigla, status) FROM stdin;
1	mão direita	D    	t
2	mão esquerda	E    	t
3	membro superior direito	MSD  	t
4	membro superior esquerdo	MSE  	t
5	membro inferior direito	MID  	t
6	membro inferior esquerdo	MIE  	t
7	lábio-mandíbula	LM   	t
9	não se aplica	NA   	t
8	pescoço	P    	t
\.


--
-- Name: tipo_aplicacao_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('tipo_aplicacao_id_seq', 11, true);


--
-- Data for Name: tipo_questao; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY tipo_questao (id, descricao, status) FROM stdin;
1	Multipla escolha	t
2	Descritiva curta	t
3	Descritiva longa	t
\.


--
-- Name: tipo_questao_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('tipo_questao_id_seq', 3, true);


--
-- Data for Name: tipo_questionario; Type: TABLE DATA; Schema: questionario; Owner: postgres
--

COPY tipo_questionario (id, titulo, descricao, endereco_eletronico, status) FROM stdin;
4	MDS-UPDRS (2008)	A MDS UPDRS tem quatro partes: Parte I (aspectos não motores da vida diária), Parte II (aspectos motores da vida diária), Parte III (avaliação motora) e Parte IV (complicações\nmotoras).	https://www.movementdisorders.org/MDS-Files1/Education/Rating-Scales/MDS-UPDRS_Portuguese_Official_Translation_FINAL.pdf	t
6	Hoehn e Yahr	Escala Hoehn e Yahr modificada	http://www2.fct.unesp.br/docentes/fisio/augustocesinando/AVALIACAO%20FISIOTERAPEUTICA%20NEUROLOGICA/Escala%20de%20Hoehn%20e%20Yahr%20Modificada.pdf	t
\.


--
-- Name: tipo_questionario_id_seq; Type: SEQUENCE SET; Schema: questionario; Owner: postgres
--

SELECT pg_catalog.setval('tipo_questionario_id_seq', 6, true);


SET search_path = sidabi, pg_catalog;

--
-- Data for Name: grupo_pesquisadores; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY grupo_pesquisadores (id, nome, descricao, status) FROM stdin;
4	Grupo XYZ	XYZ para estudos sobre W	t
\.


--
-- Name: grupo_pesquisadores_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('grupo_pesquisadores_id_seq', 4, true);


--
-- Data for Name: grupo_pesquisadores_login; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY grupo_pesquisadores_login (id, grupo_pesquisadores_fk_id, login_fk_id, ativo) FROM stdin;
59	4	1	t
60	4	2	t
\.


--
-- Name: grupo_pesquisadores_login_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('grupo_pesquisadores_login_id_seq', 60, true);


--
-- Data for Name: login; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY login (id, usuario, senha, email, nome, ativo, perfil, administrador) FROM stdin;
2	joao.folador	7bee0477f82303aa43de5d78f7b9cb05	joao@joao.com	João Paulo	t	3	t
1	admin	81dc9bdb52d04dc20036dbd8313ed055	admin@admin.com	admin	t	6	t
\.


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('login_id_seq', 25, true);


--
-- Data for Name: login_menu; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY login_menu (id, login_fk_id, menu_fk_id, incluir, editar, visualizar, excluir) FROM stdin;
2	2	2	t	t	f	t
5	2	5	t	f	f	t
6	2	6	t	t	f	t
11	1	2	t	t	t	t
12	1	3	t	t	t	t
15	1	6	t	t	t	t
16	1	7	t	t	t	t
14	1	5	t	f	f	t
304	1	32	t	t	f	t
305	1	33	t	t	f	t
306	1	31	t	t	f	t
307	1	30	t	t	f	t
308	1	29	t	t	f	t
309	1	35	t	t	f	t
310	1	36	t	t	f	t
311	1	34	t	t	f	t
312	2	35	t	t	f	t
313	2	36	t	t	f	t
29	1	21	t	t	f	t
30	1	22	t	t	f	t
28	1	20	t	t	f	t
31	1	23	t	t	t	t
32	2	23	t	t	t	t
10	1	1	t	t	f	t
316	2	38	t	t	f	t
315	2	37	t	t	f	t
317	2	39	t	t	t	t
318	1	39	t	t	t	t
45	2	27	t	t	f	t
46	2	26	t	t	f	t
319	2	40	t	t	t	t
314	2	34	t	t	t	t
49	1	27	t	t	f	t
50	1	26	t	t	f	t
146	2	21	t	t	f	t
147	2	22	t	t	f	t
148	2	20	t	t	f	t
1	2	1	t	t	f	t
7	2	7	t	t	f	t
3	2	3	t	t	t	t
161	2	29	t	t	f	t
302	2	32	t	t	f	t
301	2	31	t	t	t	t
300	2	30	t	t	t	t
303	2	33	t	t	t	t
\.


--
-- Name: login_menu_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('login_menu_id_seq', 319, true);


--
-- Data for Name: login_modulo; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY login_modulo (login_fk_id, modulo_fk_id, id) FROM stdin;
1	2	2
1	3	7
2	3	8
2	5	14
1	5	16
2	2	29
2	6	32
2	7	57
1	7	58
1	6	59
1	8	60
2	8	61
\.


--
-- Name: login_modulo_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('login_modulo_id_seq', 61, true);


--
-- Data for Name: menu; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY menu (id, nome, url, modulo_fk_id, ordem) FROM stdin;
1	Equipamento	../../controller/ctrl_gerenciamento/equipamento.php	3	1
2	Estudo	../../controller/ctrl_gerenciamento/estudo.php	3	2
3	Grupo de estudo	../../controller/ctrl_gerenciamento/grupo.php	3	3
5	Associar Participantes-Grupo	../../controller/ctrl_gerenciamento/participanteGrupo.php	3	5
6	Protocolo	../../controller/ctrl_gerenciamento/protocolo.php	3	6
7	Sessão de coleta	../../controller/ctrl_gerenciamento/sessao.php	3	7
20	Setor	../../controller/ctrl_setor/setor.php	2	1
21	Idealizador	../../controller/ctrl_idealizador/idealizador.php	2	2
22	Ideia	../../controller/ctrl_ideia/ideia.php	2	3
23	Baixar arquivos	../../controller/ctrl_gerenciamento/baixarArquivos.php	3	8
27	Categoria	../../controller/ctrl_gerenciamento/gerenciaCategoria.php	5	1
26	Sintomas	../../controller/ctrl_gerenciamento/gerenciaSintomas.php	5	2
29	Consultar dados	../../controller/ctrl_consultar_dados/consultarDados.php	6	1
39	Detectar tremor	../../controller/ctrl_detecta_tremor/detectarTremor.php	6	2
30	Tipo de questionário	../../controller/ctrl_gerenciamento/tipoQuestionario.php	7	1
31	Tipo de aplicação das questões	../../controller/ctrl_gerenciamento/tipoAplicacao.php	7	2
32	Questionário	../../controller/ctrl_gerenciamento/criarQuestionario.php	7	3
33	Relatório	../../controller/ctrl_rel_contabilizar/relatorioContabilizar.php	7	4
40	Relatório de avaliação do tremor	../../controller/ctrl_rel_avalia_tremor/rel_avalia_tremor.php	6	3
34	Pessoas	../../controller/ctrl_individuo/individuo.php	8	1
37	Medicamento	../../controller/ctrl_medicamento/medicamento.php	8	2
35	Cidade	../../controller/ctrl_cidade/cidade.php	8	4
36	Estado	../../controller/ctrl_estado/estado.php	8	5
38	Associar medicamento	../../controller/ctrl_individuo_medicamento/individuoMedicamento.php	8	3
\.


--
-- Name: menu_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('menu_id_seq', 40, true);


--
-- Data for Name: modulo; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY modulo (id, sigla, titulo, status, caminho_imagem, caminho_modulo) FROM stdin;
7	Avaliação Clínica	Criar e aplicar questionário para avaliar participantes	t	../../view/img/questionario-icone.png	../../../questionario/index.php
3	Gerenciamento de dados	Gerenciamento de arquivos biomédicos	t	../../view/img/biodata-icone.png	../../../biodata/index.php
2	Ideias inovadoras	Ideias inovadoras a favor da saúde	t	../../view/img/inova-icone.png	../../../inova/index.php
5	Educação e treinamento	Lista de sintomas da doença de Parkinson	t	../../view/img/sintoma-icone.png	../../../parkinson/index.php
8	Gestão de pessoas	Gerenciamento de dados de participantes e pacientes	t	../../view/img/gestaopessoa-icone.png	../../../gestao_pessoa/index.php
6	Pesquisa e análise de dados	Pesquisa e Análise de dados 	t	../../view/img/analise-icone.png	../../../prodata/index.php
\.


--
-- Name: modulo_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('modulo_id_seq', 8, true);


--
-- Data for Name: perfil; Type: TABLE DATA; Schema: sidabi; Owner: postgres
--

COPY perfil (id, descricao) FROM stdin;
1	Aluno(a) de Graduação
2	Aluno(a) de Mestrado
3	Aluno(a) de Doutorado
4	Professor(a)
5	Aluno(a) de Pós Doutorado
6	Convidado
\.


--
-- Name: perfil_id_seq; Type: SEQUENCE SET; Schema: sidabi; Owner: postgres
--

SELECT pg_catalog.setval('perfil_id_seq', 7, true);


SET search_path = biodata, pg_catalog;

--
-- Name: equipamento_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY equipamento
    ADD CONSTRAINT equipamento_pkey PRIMARY KEY (id);


--
-- Name: estudos_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY estudo
    ADD CONSTRAINT estudos_pkey PRIMARY KEY (id);


--
-- Name: grupo_estudo_participante_index01; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo_participante
    ADD CONSTRAINT grupo_estudo_participante_index01 UNIQUE (grupo_estudo_fk_id, participante_fk_id);


--
-- Name: grupo_estudo_participante_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo_participante
    ADD CONSTRAINT grupo_estudo_participante_pkey PRIMARY KEY (id);


--
-- Name: grupo_estudo_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo
    ADD CONSTRAINT grupo_estudo_pkey PRIMARY KEY (id);


--
-- Name: protocolo_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY protocolo
    ADD CONSTRAINT protocolo_pkey PRIMARY KEY (id);


--
-- Name: sessao_grupo_pesquisadores_login_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao_grupo_pesquisadores_login
    ADD CONSTRAINT sessao_grupo_pesquisadores_login_pkey PRIMARY KEY (id);


--
-- Name: sessao_pkey; Type: CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_pkey PRIMARY KEY (id);


SET search_path = inova, pg_catalog;

--
-- Name: idealizador_pkey; Type: CONSTRAINT; Schema: inova; Owner: postgres
--

ALTER TABLE ONLY idealizador
    ADD CONSTRAINT idealizador_pkey PRIMARY KEY (id);


--
-- Name: ideia_pkey; Type: CONSTRAINT; Schema: inova; Owner: postgres
--

ALTER TABLE ONLY ideia
    ADD CONSTRAINT ideia_pkey PRIMARY KEY (id);


--
-- Name: setor_pkey; Type: CONSTRAINT; Schema: inova; Owner: postgres
--

ALTER TABLE ONLY setor
    ADD CONSTRAINT setor_pkey PRIMARY KEY (id);


SET search_path = parkinson, pg_catalog;

--
-- Name: categoria_pkey; Type: CONSTRAINT; Schema: parkinson; Owner: postgres
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- Name: sintoma_pkey; Type: CONSTRAINT; Schema: parkinson; Owner: postgres
--

ALTER TABLE ONLY sintoma
    ADD CONSTRAINT sintoma_pkey PRIMARY KEY (id);


SET search_path = prodata, pg_catalog;

--
-- Name: avalia_tremor_pk; Type: CONSTRAINT; Schema: prodata; Owner: postgres
--

ALTER TABLE ONLY avalia_tremor
    ADD CONSTRAINT avalia_tremor_pk PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: cidade_index01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cidade
    ADD CONSTRAINT cidade_index01 PRIMARY KEY (id);


--
-- Name: estado_index01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estado
    ADD CONSTRAINT estado_index01 PRIMARY KEY (id);


--
-- Name: individuo_index01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo
    ADD CONSTRAINT individuo_index01 PRIMARY KEY (id);


--
-- Name: individuo_medicamento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo_medicamento
    ADD CONSTRAINT individuo_medicamento_pk PRIMARY KEY (id);


--
-- Name: medicamento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY medicamento
    ADD CONSTRAINT medicamento_pk PRIMARY KEY (id);


--
-- Name: tipo_sangue_index01; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_sangue
    ADD CONSTRAINT tipo_sangue_index01 PRIMARY KEY (id);


SET search_path = questionario, pg_catalog;

--
-- Name: agrupamento_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY agrupamento
    ADD CONSTRAINT agrupamento_pkey PRIMARY KEY (id);


--
-- Name: alternativa_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY alternativa
    ADD CONSTRAINT alternativa_pkey PRIMARY KEY (id);


--
-- Name: avaliacao_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao
    ADD CONSTRAINT avaliacao_pkey PRIMARY KEY (id);


--
-- Name: questao_alternativa_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_alternativa
    ADD CONSTRAINT questao_alternativa_pkey PRIMARY KEY (id);


--
-- Name: questao_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao
    ADD CONSTRAINT questao_pkey PRIMARY KEY (id);


--
-- Name: questao_tipo_aplicacao_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_tipo_aplicacao
    ADD CONSTRAINT questao_tipo_aplicacao_pkey PRIMARY KEY (id);


--
-- Name: resposta_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_pkey PRIMARY KEY (id);


--
-- Name: tipo_aplicacao_index01; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY tipo_aplicacao
    ADD CONSTRAINT tipo_aplicacao_index01 PRIMARY KEY (id);


--
-- Name: tipo_questao_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY tipo_questao
    ADD CONSTRAINT tipo_questao_pkey PRIMARY KEY (id);


--
-- Name: tipo_questionario_pkey; Type: CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY tipo_questionario
    ADD CONSTRAINT tipo_questionario_pkey PRIMARY KEY (id);


SET search_path = sidabi, pg_catalog;

--
-- Name: email_unique; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login
    ADD CONSTRAINT email_unique UNIQUE (email);


--
-- Name: grupo_pesquisadores_login_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY grupo_pesquisadores_login
    ADD CONSTRAINT grupo_pesquisadores_login_pkey PRIMARY KEY (id);


--
-- Name: grupo_pesquisadores_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY grupo_pesquisadores
    ADD CONSTRAINT grupo_pesquisadores_pkey PRIMARY KEY (id);


--
-- Name: login_menu_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_menu
    ADD CONSTRAINT login_menu_pkey PRIMARY KEY (id);


--
-- Name: login_modulo_index01; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_modulo
    ADD CONSTRAINT login_modulo_index01 UNIQUE (login_fk_id, modulo_fk_id);


--
-- Name: login_modulo_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_modulo
    ADD CONSTRAINT login_modulo_pkey PRIMARY KEY (id);


--
-- Name: login_pk; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login
    ADD CONSTRAINT login_pk PRIMARY KEY (id);


--
-- Name: menu_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- Name: modulo_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY modulo
    ADD CONSTRAINT modulo_pkey PRIMARY KEY (id);


--
-- Name: perfil_pkey; Type: CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id);


SET search_path = biodata, pg_catalog;

--
-- Name: grupo_estudo_estudo_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo
    ADD CONSTRAINT grupo_estudo_estudo_fk FOREIGN KEY (estudo_fk_id) REFERENCES estudo(id);


--
-- Name: grupo_estudo_participante_gurpo_estudo_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo_participante
    ADD CONSTRAINT grupo_estudo_participante_gurpo_estudo_fk FOREIGN KEY (grupo_estudo_fk_id) REFERENCES grupo_estudo(id);


--
-- Name: grupo_estudo_participante_participante_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY grupo_estudo_participante
    ADD CONSTRAINT grupo_estudo_participante_participante_fk FOREIGN KEY (participante_fk_id) REFERENCES public.individuo(id);


--
-- Name: sessao_equipamento_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_equipamento_fk FOREIGN KEY (equipamento_fk_id) REFERENCES equipamento(id);


--
-- Name: sessao_grupo_estudo_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_grupo_estudo_fk FOREIGN KEY (grupo_estudo_fk_id) REFERENCES grupo_estudo(id);


--
-- Name: sessao_grupo_pesquisadores_login_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao_grupo_pesquisadores_login
    ADD CONSTRAINT sessao_grupo_pesquisadores_login_fk FOREIGN KEY (grupo_pesquisadores_login_fk_id) REFERENCES sidabi.grupo_pesquisadores_login(id);


--
-- Name: CONSTRAINT sessao_grupo_pesquisadores_login_fk ON sessao_grupo_pesquisadores_login; Type: COMMENT; Schema: biodata; Owner: postgres
--

COMMENT ON CONSTRAINT sessao_grupo_pesquisadores_login_fk ON sessao_grupo_pesquisadores_login IS 'Chave estrangeira para grupo_pesquisadores_login_id';


--
-- Name: sessao_grupo_pesquisadores_login_sessao_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao_grupo_pesquisadores_login
    ADD CONSTRAINT sessao_grupo_pesquisadores_login_sessao_fk FOREIGN KEY (sessao_fk_id) REFERENCES sessao(id);


--
-- Name: sessao_login_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_login_fk FOREIGN KEY (usuario_logado) REFERENCES sidabi.login(id);


--
-- Name: sessao_participante_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_participante_fk FOREIGN KEY (participante_fk_id) REFERENCES public.individuo(id);


--
-- Name: sessao_protocolo_fk; Type: FK CONSTRAINT; Schema: biodata; Owner: postgres
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_protocolo_fk FOREIGN KEY (protocolo_fk_id) REFERENCES protocolo(id);


SET search_path = inova, pg_catalog;

--
-- Name: ideia_idealizador_fk; Type: FK CONSTRAINT; Schema: inova; Owner: postgres
--

ALTER TABLE ONLY ideia
    ADD CONSTRAINT ideia_idealizador_fk FOREIGN KEY (idealizador_fk_id) REFERENCES idealizador(id);


--
-- Name: ideia_setor_fk; Type: FK CONSTRAINT; Schema: inova; Owner: postgres
--

ALTER TABLE ONLY ideia
    ADD CONSTRAINT ideia_setor_fk FOREIGN KEY (setor_fk_id) REFERENCES setor(id);


SET search_path = parkinson, pg_catalog;

--
-- Name: sintoma_categoria_fk; Type: FK CONSTRAINT; Schema: parkinson; Owner: postgres
--

ALTER TABLE ONLY sintoma
    ADD CONSTRAINT sintoma_categoria_fk FOREIGN KEY (categoria_fk_id) REFERENCES categoria(id);


SET search_path = prodata, pg_catalog;

--
-- Name: avalia_tremor_individuo_fk; Type: FK CONSTRAINT; Schema: prodata; Owner: postgres
--

ALTER TABLE ONLY avalia_tremor
    ADD CONSTRAINT avalia_tremor_individuo_fk FOREIGN KEY (individuo_fk_id) REFERENCES public.individuo(id);


SET search_path = public, pg_catalog;

--
-- Name: cidade_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cidade
    ADD CONSTRAINT cidade_fk FOREIGN KEY (estado_fk_id) REFERENCES estado(id);


--
-- Name: individuo_cidade_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo
    ADD CONSTRAINT individuo_cidade_fk FOREIGN KEY (cidade_fk_id) REFERENCES cidade(id);


--
-- Name: individuo_medicamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo_medicamento
    ADD CONSTRAINT individuo_medicamento_fk FOREIGN KEY (individuo_fk_id) REFERENCES individuo(id);


--
-- Name: individuo_medicamento_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo_medicamento
    ADD CONSTRAINT individuo_medicamento_fk_1 FOREIGN KEY (medicamento_fk_id) REFERENCES medicamento(id);


--
-- Name: individuo_tipo_sangue_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY individuo
    ADD CONSTRAINT individuo_tipo_sangue_fk FOREIGN KEY (tipo_sangue_fk_id) REFERENCES tipo_sangue(id);


SET search_path = questionario, pg_catalog;

--
-- Name: agrupamento_tipo_questionario_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY agrupamento
    ADD CONSTRAINT agrupamento_tipo_questionario_fk FOREIGN KEY (tipo_questionario_fk_id) REFERENCES tipo_questionario(id);


--
-- Name: avaliacao_grupo_pesquisadores_login_avaliacao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao_grupo_pesquisadores_login
    ADD CONSTRAINT avaliacao_grupo_pesquisadores_login_avaliacao_fk FOREIGN KEY (avaliacao_fk_id) REFERENCES avaliacao(id);


--
-- Name: avaliacao_grupo_pesquisadores_login_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao_grupo_pesquisadores_login
    ADD CONSTRAINT avaliacao_grupo_pesquisadores_login_fk FOREIGN KEY (grupo_pesquisadores_login_fk_id) REFERENCES sidabi.grupo_pesquisadores_login(id);


--
-- Name: avaliacao_login_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao
    ADD CONSTRAINT avaliacao_login_fk FOREIGN KEY (login_fk_id) REFERENCES sidabi.login(id);


--
-- Name: avaliacao_participante_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao
    ADD CONSTRAINT avaliacao_participante_fk FOREIGN KEY (participante_fk_id) REFERENCES public.individuo(id);


--
-- Name: avaliacao_tipo_questionario_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY avaliacao
    ADD CONSTRAINT avaliacao_tipo_questionario_fk FOREIGN KEY (tipo_questionario_fk_id) REFERENCES tipo_questionario(id);


--
-- Name: questao_agrupamento_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao
    ADD CONSTRAINT questao_agrupamento_fk FOREIGN KEY (agrupamento_fk_id) REFERENCES agrupamento(id);


--
-- Name: questao_alternativa_alternativa_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_alternativa
    ADD CONSTRAINT questao_alternativa_alternativa_fk FOREIGN KEY (alternativa_fk_id) REFERENCES alternativa(id);


--
-- Name: questao_alternativa_questao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_alternativa
    ADD CONSTRAINT questao_alternativa_questao_fk FOREIGN KEY (questao_fk_id) REFERENCES questao(id);


--
-- Name: questao_tipo_aplicacao_questao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_tipo_aplicacao
    ADD CONSTRAINT questao_tipo_aplicacao_questao_fk FOREIGN KEY (questao_fk_id) REFERENCES questao(id);


--
-- Name: questao_tipo_aplicacao_tipo_aplicacao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao_tipo_aplicacao
    ADD CONSTRAINT questao_tipo_aplicacao_tipo_aplicacao_fk FOREIGN KEY (tipo_aplicacao_fk_id) REFERENCES tipo_aplicacao(id);


--
-- Name: questao_tipo_questao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY questao
    ADD CONSTRAINT questao_tipo_questao_fk FOREIGN KEY (tipo_questao_fk_id) REFERENCES tipo_questao(id);


--
-- Name: resposta_alternativa_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_alternativa_fk FOREIGN KEY (alternativa_fk_id) REFERENCES alternativa(id);


--
-- Name: resposta_avaliacao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_avaliacao_fk FOREIGN KEY (avaliacao_fk_id) REFERENCES avaliacao(id);


--
-- Name: resposta_login_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_login_fk FOREIGN KEY (login_fk_id) REFERENCES sidabi.login(id);


--
-- Name: resposta_questao_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_questao_fk FOREIGN KEY (questao_fk_id) REFERENCES questao(id);


--
-- Name: resposta_tipo_aplicacao; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_tipo_aplicacao FOREIGN KEY (tipo_aplicacao_fk_id) REFERENCES tipo_aplicacao(id);


--
-- Name: resposta_tipo_questionario_fk; Type: FK CONSTRAINT; Schema: questionario; Owner: postgres
--

ALTER TABLE ONLY resposta
    ADD CONSTRAINT resposta_tipo_questionario_fk FOREIGN KEY (tipo_questionario_fk_id) REFERENCES tipo_questionario(id);


SET search_path = sidabi, pg_catalog;

--
-- Name: grupo_pesquisadores_login_grupo_pesquisadores_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY grupo_pesquisadores_login
    ADD CONSTRAINT grupo_pesquisadores_login_grupo_pesquisadores_fk FOREIGN KEY (grupo_pesquisadores_fk_id) REFERENCES grupo_pesquisadores(id);


--
-- Name: grupo_pesquisadores_login_login_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY grupo_pesquisadores_login
    ADD CONSTRAINT grupo_pesquisadores_login_login_fk FOREIGN KEY (login_fk_id) REFERENCES login(id);


--
-- Name: login_menu_login_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_menu
    ADD CONSTRAINT login_menu_login_fk FOREIGN KEY (login_fk_id) REFERENCES login(id);


--
-- Name: login_menu_menu_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_menu
    ADD CONSTRAINT login_menu_menu_fk FOREIGN KEY (menu_fk_id) REFERENCES menu(id);


--
-- Name: login_modulo_login_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_modulo
    ADD CONSTRAINT login_modulo_login_fk FOREIGN KEY (login_fk_id) REFERENCES login(id);


--
-- Name: login_modulo_modulo_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login_modulo
    ADD CONSTRAINT login_modulo_modulo_fk FOREIGN KEY (modulo_fk_id) REFERENCES modulo(id);


--
-- Name: login_perfil_fk; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY login
    ADD CONSTRAINT login_perfil_fk FOREIGN KEY (perfil) REFERENCES perfil(id);


--
-- Name: menu_modulo_id; Type: FK CONSTRAINT; Schema: sidabi; Owner: postgres
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_modulo_id FOREIGN KEY (modulo_fk_id) REFERENCES modulo(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

