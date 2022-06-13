var calidad, app
const CONEXION_INCONECTABLE = "Sin conexión con servidor."
const CONEXION_CONECTABLE = "Estableciendo conexión\u2026"
const WS_PORT = "666"

var CalidadBitel = function() {
	console.log("Bitelis Qualitas")
	var conn

	var manejarAcceso = function(cheveridad, parametros) {
		if(cheveridad) {
			calidad.token = parametros.token
			Notiflix.Notify.Success("Sesión iniciada.")

			if(parametros.persistencia) {
				window.localStorage.setItem("token", this.token)
				//~ console.log("Sesión perenne.")
			}
			else {
				window.sessionStorage.setItem("token", this.token)
				//~ console.log("Sesión efímera.")
			}

			//Y lo mandamos a que use el programa (posiblemente donde se quedó)
			if( this.urlReferenciador && ( this.urlReferenciador != "/acceder" ) ) {
				app.navigate( this.urlReferenciador, true )
			}
			else {
				app.navigate("/", true)
			}
		}
		else {
			Notiflix.Notify.Warning(parametros.info)
		}
	}

	this.acceder = function(formulario) {
		if(conn.readyState != WebSocket.OPEN) {
			Notiflix.Notify.Failure(CONEXION_INCONECTABLE)
			return
		}

		formulario.elements.usuario.blur()
		formulario.elements.clave.blur()
		const credencial = new Object()
		credencial.action = 1
		credencial.params = {
			usuario: formulario.elements.usuario.value.trim().toLowerCase(),
			password: formulario.elements.clave.value.trim(),
			persistencia: formulario.elements.persistencia.checked
		}

		if(! (credencial.params.usuario.length && credencial.params.password.length ) ) {
			Notiflix.Notify.Warning("Credenciales incompletas")
			return
		}

		mensajear( JSON.stringify( credencial ) )
	}

	var wsMensajeado = function(e) {
		let respuesta = JSON.parse(e.data)

		switch(respuesta.action) {
			case 1:
				manejarAcceso(respuesta.cheveridad, respuesta.params)
				break
		}
	}

	var mensajear = function(json) {
		//Cotejar si la conexión al WebSocket está abierta
		if(conn.readyState != WebSocket.OPEN) {
			Notiflix.Notify.Failure("Imposible enviar datos al servidor.")
			return false
		}
		conn.send(json)
		return true
	}

	this.enlazar = function() {
		try {
			conn = new ReconnectingWebSocket("wss://" + location.hostname + ":" + WS_PORT)
			conn.debug = false
			conn.reconnectInterval = 3666
			conn.reconnectDecay = 3.255
			conn.onopen = wsEnchufado
			conn.onmessage = wsMensajeado
			conn.onclose = wsDesenchufado
			conn.onerror = wsHorrorizado
		}
		catch(e) {
			wsHorrorizado()
		}
	}

	var wsHorrorizado = function() {
		if( this.readyState == WebSocket.CONNECTING ) {
			Notiflix.Notify.Info(CONEXION_CONECTABLE);
		}
		else {
			Notiflix.Notify.Failure(CONEXION_INCONECTABLE);
		}
	}

	var wsDesenchufado = function() {
	}

	var wsEnchufado = function() {
		calidad.ejecutarSegunRuta()
	}

	this.restringirAcceso = function() {
		const rutaActual = window.location.pathname
		if( this.rutasLibres.includes( rutaActual ) ) {
			return false
		}

		if(this.token == undefined) {
			this.urlReferenciador = rutaActual
			app.navigate("/acceder")
			return true
		}
		return false
	}

	this.salir = function() {
		Notiflix.Confirm.Show("Cerrando sesión","¿Desea cerrar su sesión?","Sí","No",
			function() {
				const solicitud = new Object()
				solicitud.action = -1
				solicitud.token = calidad.token

				mensajear( JSON.stringify( solicitud ) )

				calidad.token = null
				window.localStorage.removeItem("token")
				window.sessionStorage.removeItem("token")

				app.navigate("/acceder")
			}
		)
	}

	this.ejecutarSegunRuta = function(ruta) {
		if(this.restringirAcceso()) {
			return
		}

		const datos = parseJwt(this.token)

		const contenedor = document.getElementById("usuario-tag")
		contenedor.appendChild(document.createTextNode(datos.alias))
	}

	this.rutasLibres = ["/acceder"]

	this.token = window.localStorage.getItem("token")
	if(this.token == null) {
		this.token = window.sessionStorage.getItem("token")
	}
}

function parseJwt(token) {
	let base64Url = token.split('.')[1];
	let base64 = base64Url.replace('-', '+').replace('_', '/');
	return JSON.parse(window.atob(base64));
}

window.onload = function() {
	app = new senna.App()
	app.addSurfaces(["lienzo"])
	app.addRoutes([
		new senna.Route("/", senna.HtmlScreen),
		new senna.Route("/tiendas", senna.HtmlScreen),
		new senna.Route("/acceder", senna.HtmlScreen)
	])

	calidad = new CalidadBitel()
	calidad.enlazar()
	calidad.restringirAcceso()

	app.on("endNavigate", function(event) {
		if(event.error) {
			if(event.error.invalidStatus) {
				Notiflix.Report.Info("Página no disponible","No se puede mostrar la página solicitada.<br>Tal vez no esté disponible por ahora.<br>Prueba navegando a otras secciones.", "Aceptar", function(){document.documentElement.classList.remove( app.getLoadingCssClass() )})
			}

			if(event.error.requestError) {
				Notiflix.Report.Failure("Error de navegación","No se puede solicitar página.<br>Comprueba tu conexión a Internet.", "Aceptar", function(){document.documentElement.classList.remove( app.getLoadingCssClass() )})
			}

			if(event.error.timeout) {
				Notiflix.Report.Warning("Demora en la red","No se pudo traer la página solicitada.<br>La conexión a Internet está tardando mucho.", "Aceptar", function(){document.documentElement.classList.remove( app.getLoadingCssClass() )})
			}
		}
		else {
			calidad.ejecutarSegunRuta()
			if(feather) {
				feather.replace()
			}
		}
	})

	if(feather) {
		feather.replace()
	}
}
