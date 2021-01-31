<?php
	class SidabiLogin
	{
        public static function consultarUsuarioPorGrupoPesquisador()
        {
            $db = Database::conexao();

            $sql = "select 
                           count(login.id) as qtd_usuario,
                           grupo_pesquisadores.nome as grupo_pesquisadores_nome
                    from
                           sidabi.grupo_pesquisadores_login
                           inner join sidabi.login
                           on sidabi.login.id = grupo_pesquisadores_login.login_fk_id
                           inner join sidabi.grupo_pesquisadores
                           on sidabi.grupo_pesquisadores.id = grupo_pesquisadores_login.grupo_pesquisadores_fk_id
                           
                    group by
                           grupo_pesquisadores.nome
                    order by
                           grupo_pesquisadores.nome";

            $result = $db->query($sql);
            $result = $result->fetchAll(PDO::FETCH_ASSOC);
            return $result;
        }

		public static function consultarAlunoPorPerfil() {
			$db = Database::conexao();

			$sql = "select 
						   perfil.descricao as perfil_descricao,
						   count(login.id) as qtd_usuario
					from
						   sidabi.login
						   inner join sidabi.perfil
								   on perfil.id = login.perfil
					group by
						  perfil.descricao
					order by
						  perfil.descricao";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function procurarUsuarioInline($gsSearchParam, $offset, $limit)
		{
			$db = Database::conexao();

			$sql = "select 
							login.id, 
							login.nome as descricao
					from 
							sidabi.login
					where 
							login.nome ilike '%$gsSearchParam%'
					
					order by login.nome asc
					limit $limit offset $offset";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function procurarUsuarioInlineCount($gsSearchParam)
		{
			$db = Database::conexao();

			$sql = "select count(*) as quantidade_registro
					from sidabi.login
					where login.nome ilike '%$gsSearchParam%'";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result[0]["quantidade_registro"];
		}

		/**
		 * Função que participa do processo de recuperação de senha
		 * Servirá para cadastrar a nova senha informada pelo usuário
		 * @param $senha
		 * @param $id
		 * @return int
		 */
		public static function atualizarSenha($senha, $id)
		{
			$db = Database::conexao();

			$sql = "update sidabi.login 
					set senha = MD5(:senha)
					where id = :id";

			$stmt = $db->prepare($sql);
			$stmt->bindParam(":senha", $senha, PDO::PARAM_STR);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();

			return $stmt->rowCount();
		}

		/**
		 * Função usada para procurar um usuário pelo Id
		 * Usada para validar a recuperação de senha
		 * @param $id
		 * @return array|PDOStatement
		 */
		public static function consultarLoginPeloId($id)
		{
			$db = Database::conexao();

			$sql = "select *
					from sidabi.login
					where id = $id";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function consultarLogin()
		{
			$db = Database::conexao();

			$sql = "select *
					from sidabi.login
					order by login.usuario asc";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function consultarUsuariosAtivos()
		{
			$db = Database::conexao();

			$sql = "select *
					from sidabi.login
					where ativo is true
					order by login.usuario asc";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function loginBuscarModulos($usuario)
		{
			$db = Database::conexao();

			$sql = "select 
						   login.id login_id,
						   login.usuario login_usuario,
						   login.administrador login_administrador,
						   modulo.*
					from
						   sidabi.login
						   inner join sidabi.login_modulo
								   on login_modulo.login_fk_id = login.id
						   inner join sidabi.modulo
								   on modulo.id = login_modulo.modulo_fk_id
					where
						   modulo.status is true
						   and login.usuario = '$usuario'
					order by
						   modulo.sigla ";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function verificarLogin($usuario, $senha)
		{
			$db = Database::conexao();

			$sql = "select 
							login.id,
							login.usuario,
							login.senha,
							login.email,
							login.nome,
							login.administrador,
							case when login.ativo is true then 'ativo' else 'inativo' end ativo
					from 
							sidabi.login
					where 
							login.usuario = '$usuario'
							and login.senha = md5('$senha')";

			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function verificarEmail($email, $id='', $op='')
		{
			$db = Database::conexao();

			$op = !empty($op) ? $op : '=';
			$temp = !empty($id) ? " and id $op :id " : '';

			$sql = "select *
					from sidabi.login
					where email = :email $temp";

			$stmt = $db->prepare($sql);
			$stmt->bindParam(":email", $email, PDO::PARAM_STR);
			if (!empty($id)) {
				$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			}
			$stmt->execute();

			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function validarHashRecuperarSenha($hash, $user)
		{
			$db = Database::conexao();

			$sql = "select *
					from sidabi.login
					where senha = :senha and id = :id";

			$stmt = $db->prepare($sql);
			$stmt->bindParam(":senha", $hash, PDO::PARAM_STR);
			$stmt->bindParam(":id", $user, PDO::PARAM_INT);
			$stmt->execute();

			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			return $result;
		}

		public static function consultarTodosRegistros($sidx, $sord, $start, $limit, $filtro="")
		{
			$db = Database::conexao();
			$temp = 'where 1=1';
			if (!empty($filtro)){
				if (!empty($filtro["nome"])) {
					$temp .= " and login.nome ilike '%". $filtro["nome"]."%'";
				}
				if (!empty($filtro["usuario"])) {
					$temp .= " and login.usuario ilike '%". $filtro["usuario"]."%'";
				}
				if (!empty($filtro["email"])) {
					$temp .= " and login.email ilike '%". $filtro["email"]."%'";
				}
				if (!empty($filtro["id"])) {
					$temp .= " and login.id = ". $filtro["id"];
				}
				if (!empty($filtro["administrador"])) {
					$temp .= " and login.administrador = ". $filtro["administrador"];
				}
				if (!empty($filtro["ativo"])) {
					$temp .= " and login.ativo = ". $filtro["ativo"];
				}
				if (!empty($filtro["perfil_descricao"])) {
					$temp .= " and login.perfil = ". $filtro["perfil_descricao"];
				}
			}
			$sql = "select 
						login.id,
						login.usuario,
						login.senha,
						login.email,
						login.nome,
						perfil.descricao perfil_descricao,
						case when login.ativo is true then 'ativo' else 'inativo' end ativo,
						case when login.administrador is true then 'sim' else 'não' end administrador
					from 
						sidabi.login
						left join sidabi.perfil on perfil.id = login.perfil
					$temp
					order by $sidx $sord 
					limit $limit offset $start";
		
			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function contarTodosRegistros()
		{
			$db = Database::conexao();
		
			$sql = "select count(*) as count
					from sidabi.login";
		
			$result = $db->query($sql);
			$result = $result->fetchAll(PDO::FETCH_ASSOC);
			return $result;
		}
		
		public static function insert($usuario, $senha, $email, $nome,  $ativo, $perfil, $administrador)
		{
			$db = Database::conexao();
			
			$sql = "insert into sidabi.login 
					values (default, :usuario, MD5(:senha), :email, :nome, :ativo, :perfil, :administrador)
					returning id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":usuario", $usuario, PDO::PARAM_STR);
			$stmt->bindParam(":senha", $senha, PDO::PARAM_STR);
			$stmt->bindParam(":email", $email, PDO::PARAM_STR);
			$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
			$stmt->bindParam(":ativo", $ativo, PDO::PARAM_BOOL);
			$stmt->bindParam(":perfil", $perfil, PDO::PARAM_INT);
			$stmt->bindParam(":administrador", $administrador, PDO::PARAM_BOOL);
			$stmt->execute();
		
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			return $result['id'];
		}

		public static function update($usuario, $senha, $email, $nome, $ativo, $perfil, $administrador, $id)
		{
			$db = Database::conexao();
				
			$sql = "update sidabi.login 
					set usuario = :usuario, 
						senha = MD5(:senha), 
						email = :email,
						nome = :nome,
						ativo = :ativo,
						perfil = :perfil,
						administrador = :administrador
					where id = :id";
				
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":usuario", $usuario, PDO::PARAM_STR);
			$stmt->bindParam(":senha", $senha, PDO::PARAM_STR);
			$stmt->bindParam(":email", $email, PDO::PARAM_STR);
			$stmt->bindParam(":nome", $nome, PDO::PARAM_STR);
			$stmt->bindParam(":ativo", $ativo, PDO::PARAM_BOOL);
			$stmt->bindParam(":perfil", $perfil, PDO::PARAM_INT);
			$stmt->bindParam(":administrador", $administrador, PDO::PARAM_BOOL);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
		
			return $stmt->rowCount();
		}
		
		public static function delete($id) 
		{
			$db = Database::conexao();
			
			$sql = "delete from sidabi.login 
					where id = :id";
			
			$stmt = $db->prepare($sql);
			$stmt->bindParam(":id", $id, PDO::PARAM_INT);
			$stmt->execute();
			
			return $stmt->rowCount();
		}
		
	}