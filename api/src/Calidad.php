<?php
namespace CalidadBitel;

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use Psr\Http\Message\RequestInterface;

class Calidad implements MessageComponentInterface {

	public function __construct($credentials) {
		$this->bd = new \mysqli($credentials['host'], $credentials['user'], $credentials['password'], $credentials['db']);
		echo("Calidad encendida.\n");
	}

	public function __destruct() {
		$this->sessionsClient->close();
		$this->bd->close();
		echo("Calidad apagada.\n");
	}

	public function onOpen(ConnectionInterface $conn) {
		echo "Conexión nueva ({$conn->resourceId})\n";
	}

	public function onMessage(ConnectionInterface $from, $msg) {
		$respuesta['params'] = [];//Para enviar al navegador
		$datos = json_decode($msg, true);

		//Siempre debe haber una reacción de igual magnitud (y en sentido contrario).
		$respuesta['action'] = $datos['action'];

		//El token puede que venga o no.
		if( isset($datos['token']) && $datos['token'] != null) {
			try {
				$token = JWT::decode($datos['token'], CLAVE_JWT);
			}
			catch(\Exception $e) {
				$respuesta['action'] = 600;
				$respuesta['cheveridad'] = false;
				$respuesta['params']['texto'] = 'Token de sesión modificado.';

				$from->send( json_encode( $respuesta ) );
				return;
			}
		}

		try {
			switch($datos['action']) {
				case -1:
					$this->cerrarSesion($datos, $token, $from, $respuesta);
					return;
				case 1:
					$this->iniciarSesion($datos, $from, $respuesta);
					return;
				case 15:
					$this->listarTiendas($datos, $token, $from, $respuesta);
					return;
				case 16:
					$this->listarMetadatosTiendae($datos, $token, $from, $respuesta);
					return;
				case 17:
					$this->guardarTienda($datos, $token, $from, $respuesta);
					return;
				default:
					$respuesta['cheveridad'] = false;
					$respuesta['params']['info'] = 'No existe opción';
					$from->send( json_encode( $respuesta ) );
			}
		}
		catch(\Exception $e) {
			echo $e->getMessage();

			$respuesta['cheveridad'] = false;
			$respuesta['params']['info'] = 'Servidor no pudo procesar.';

			$from->send( json_encode( $respuesta ) );
		}
	}

	public function onClose(ConnectionInterface $conn) {
	}

	public function onError(ConnectionInterface $conn, \Exception $e) {
	}

	private function iniciarSesion($datos, $from, $respuesta) {
		$respuesta['params'] = [];

		$usuario = strtolower( $datos['params']['usuario'] );
		$clave = $datos['params']['password'];

		//Se busca en la base de datos
		$sentenciaSeleccionadora = $this->bd->prepare('SELECT identidad, hash, usuario, nombre FROM analista WHERE usuario = ? LIMIT 1');
		$sentenciaSeleccionadora->bind_param('s', $usuario);
		$sentenciaSeleccionadora->execute();
		$resultado = $sentenciaSeleccionadora->get_result();
		$sentenciaSeleccionadora->close();

		//Si no hay usuario es porque el correo electrónico no existe entonces en el cliente invitar a registrarse
		if($resultado->num_rows == 0) {
			$respuesta['cheveridad'] = false;
			$respuesta['params']['nivel'] = 0;
			$respuesta['params']['info'] = "Usuario $usuario no registrado.";
			$from->send( json_encode( $respuesta ) );
			return;
		}

		//Si hemos llegado hasta acá toca comparar los datos con los del registro obtenido
		$usuario = $resultado->fetch_assoc();

		if( password_verify($clave, $usuario['hash']) ) {
			$recordarlo = isset( $datos['params']['persistencia'] ) && $datos['params']['persistencia'];// ? true : false;

			//Se obtiene un token para decirle que puede usar el programa
			$datos = array();
			$datos['uid'] = $usuario['identidad'];
			$datos['alias'] = $usuario['nombre'];
			$datos['email'] = $usuario['usuario'];
			$datos['pers'] = $recordarlo ? time() + 31104000 : 86400;//Agregar más tiempo si hay persistencia


			$respuesta['cheveridad'] = true;
			$respuesta['params']['token'] = JWT::encode($datos, CLAVE_JWT);
			$respuesta['params']['persistencia'] = $recordarlo;
			//Envío de lo correcto
			$from->send(json_encode($respuesta));
		}
		else {//Contraseña incorrecta
			$respuesta['cheveridad'] = false;
			$respuesta['params']['info'] = 'Credenciales incorrectas.';
			$from->send(json_encode($respuesta));
		}
	}

	private function cerrarSesion(&$datos, &$token, &$from, $respuesta) {
	}

	private function listarTiendas(&$datos, &$token, &$from, $respuesta) {
		//Cotejar que datos de filtración sean los adecuados
		$direccion = "%{$datos['params']['direccion']}%";
		$sucursal = $datos['params']['sucursal'];
		$tipo = $datos['params']['tipo'];

		//Para paginación
		$pagina = $datos['params']['pagina'];
		if( ! isset( $pagina ) && ! is_int( $pagina ) && $pagina < 1 )  {
			$respuesta['cheveridad'] = false;
			$respuesta['params']['info'] = 'Problemas de paginación.';
			$from->send(json_encode($respuesta));
			return;
		}
		$pagina = ($pagina - 1) << 3;

		$sentenciaSeleccionadora = $this->bd->prepare('SELECT identidad, codigo, direccion, tipo, instante FROM tienda WHERE tipo = ? AND identidadSucursal = ? OR direccion LIKE ?');
		$sentenciaSeleccionadora->bind_param('iis', $tipo, $sucursal, $direccion);
		$resultado = $sentenciaSeleccionadora->execute();

		if($resultado) {
			$respuesta['cheveridad'] = true;
			$resultado = $sentenciaSeleccionadora->get_result();
			while($fila = $resultado->fetch_assoc()) {
				$respuesta['params']['tiendas'][] = $fila;
			}
			$resultado->free();
		}
		else {
			$respuesta['cheveridad'] = false;
			$respuesta['params']['info'] = 'BD no ejecutó bien.';
		}

		$from->send( json_encode( $respuesta ) );
	}

	private function guardarTienda(&$datos, &$token, &$from, $respuesta) {
		try {
			//Si viene una identidad entonces es para editar.
			//Nota: Podría usarse UPDATE ON DUPLICATE
			if( isset( $datos['params']['identidad'] ) ) {
				$respuesta['params']['info'] = 'Actualizado';
				$sentenciaActualizadora = $this->bd->prepare('UPDATE tienda SET identidadSucursal = ?, descripcion = ?, codigo = ?, direccion = ?, tipo = ? WHERE identidad = ?');
				$sentenciaActualizadora->bind_param('isssii', $datos['params']['sucursal'], $datos['params']['descripcion'], $datos['params']['codigo'], $datos['params']['direccion'], $datos['params']['tipo'], $datos['params']['identidad']);
				$sentenciaActualizadora->execute();

				if($this->bd->affected_rows > 0) {
					$respuesta['cheveridad'] = true;
					$respuesta['params']['info'] = 'Actualizado.';
				}
				else {
					$respuesta['cheveridad'] = false;
					$respuesta['params']['info'] = 'No se pudo actualizar.';
				}
			}
			else {//actualizar
				$sentenciaInsertadora = $this->bd->prepare('INSERT INTO tienda(identidadSucursal, descripcion, codigo, direccion, tipo, instante) VALUES(?, ?, ?, ?, ?, UNIX_TIMESTAMP(NOW()))');
				$sentenciaInsertadora->bind_param('isssi', $datos['params']['sucursal'], $datos['params']['descripcion'], $datos['params']['codigo'], $datos['params']['direccion'], $datos['params']['tipo']);
				$sentenciaInsertadora->execute();

				//Si hay identidad es porque se guardó bien.
				$identidadDeCuenta = $this->bd->insert_id;

				if($identidadDeCuenta > 0) {
					$respuesta['cheveridad'] = true;
					$respuesta['params']['info'] = 'Creado';
				}
				else {
					$respuesta['cheveridad'] = false;
					$respuesta['params']['info'] = 'No se pudo crear registro.';
				}
			}
		}
		catch(\Exception $e) {
			$respuesta['cheveridad'] = false;
			$respuesta['params']['info'] = 'Datos inconsistentes.';
		}

		$from->send( json_encode( $respuesta ) );
	}

	/**
	 * Para poblar los selectores de la tienda.
	 */
	private function listarMetadatosTiendae(&$datos, &$token, &$from, $respuesta) {
		$sentenciaSeleccionadora = $this->bd->prepare('SELECT * FROM branch');
		//~ $sentenciaSeleccionadora->bind_param('', $);
		if( $sentenciaSeleccionadora->execute() ) {
			$resultado = $sentenciaSeleccionadora->get_result();
			while($fila = $resultado->fetch_assoc()) {
				$respuesta['params']['branches'][$fila['identidad']] = $fila;
			}
			$resultado->free();
			$respuesta['cheveridad'] = true;

			$sentenciaSeleccionadora = $this->bd->prepare('SELECT * FROM sucursal');
			if( $sentenciaSeleccionadora->execute() ) {
				$resultado = $sentenciaSeleccionadora->get_result();
				while($fila = $resultado->fetch_assoc()) {
					$respuesta['params']['branches'][$fila['identidadBranch']]['sucursales'][] = $fila;
				}
				$resultado->free();
			}
		}
		else {
			$respuesta['cheveridad'] = false;
			$respuesta['params']['info'] = 'BD no ejecutó bien.';
		}

		$from->send( json_encode( $respuesta ) );
	}
}
