# Calidad Bitel

Proyecto de prácticas pre profesionales de Bautista.
El programa es web estilizado en un sola página con conexión al servidor WebSocket.

## Instalar
Instalación de componentes necesarios con Composer dentro de la carpeta *api*:

    php ~/composer.phar require cboden/ratchet

### Constantes para usar los recursos propios
Crear un archivo llamado *global-vars.php* dentro de la carpeta *api* con el siguiente contenido modificado al gusto:

    <?php
    return
    [
     'allowed-origins' => [
      'localhost', 'another-ip'
     ],
     'db' => [
      'host' => '',
      'user' => '',
      'password' => '',
      'db' => 'calidadbitel'
     ],
     'ws-port' => '666',
     'ws-certs-path' => [
      'local_cert' => 'ruta/archivo.crt',
      'local_pk' => 'ruta/archivo.key',
      'verify_peer' => false
     ],
    ];

## Encedido del servidor
Simplemente iniciar el programa servidor que usará el puerto definido en el archivo anterior de la carpeta *api*:

    php Bitelis.php
Y luego de alojar en un servidor web la carpeta *web*, en un navegador simplemente acceder a la raíz y si no hay sesión activa será dirigido a la página para escribir las credenciales.
