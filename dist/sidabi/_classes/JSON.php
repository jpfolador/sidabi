<?php

/** 
 * Classe para definição de retorno de informações no formato JSON
 */
class JSON {
	private $status;
	private $mensagem;
	private $objeto;
	private $url;
	
	public function getMensagem() {
		return $this->mensagem;
	}
	
	public function setMensagem($mensagem) {
		$this->mensagem = $mensagem;
	}
	
	public function getStatus() {
		return $this->status;
	}
	
	public function setStatus($status) {
		$this->status = $status;
	}
	
	public function getObjeto() {
		return $this->objeto;
	}
	
	public function setObjeto($objeto) {
		$this->objeto = $objeto;
	}
	
	public function getUrl() {
		return $this->url;
	}
	
	public function setUrl($url) {
		$this->url = $url;
	}
	
	/**
	 * Retorna o objeto JSON com a mensagem para o cliente
	 */
	public function imprimirJSON() {
		$retorno = '';
		switch ($this->getStatus()) {
			
			case "ok" :
				$retorno = array (
						"status" => $this->getStatus(),
						"obj" => $this->getObjeto()
				);
				break;
				
			case "erro" :
				$retorno = array (
						"status" => $this->getStatus(),
						"msg" => $this->getMensagem()
				);
				break;

            default:
				break;
		}
		$objeto = json_encode($retorno);
		echo str_replace( "\\/", "/", $objeto );
	}
}