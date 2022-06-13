<?php
use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\Http\OriginCheck;
use Ratchet\WebSocket\WsServer;
use React\EventLoop\Factory;

use CalidadBitel\Calidad;

$vars = include 'global-vars.php';

require __DIR__ . '/vendor/autoload.php';

$loop = Factory::create();

$oc = new OriginCheck(
	new WsServer(
		new Calidad($vars['db'])
	)
);
$oc->allowedOrigins = $vars['allowed-origins'];

$app = new HttpServer($oc);

$secure_websockets = new \React\Socket\Server('0.0.0.0:' . $vars['ws-port'], $loop);
$secure_websockets = new \React\Socket\SecureServer($secure_websockets, $loop, $vars['ws-certs-path']);

$secure_websockets_server = new \Ratchet\Server\IoServer($app, $secure_websockets, $loop);
$secure_websockets_server->run();
