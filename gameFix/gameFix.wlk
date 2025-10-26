class Juego {
    const nombre 
    var precio
    const categoria
    const genero 

    
    method mismoNombre(unNombre) = nombre == unNombre 

    method efecto(cliente, tiempoJugada){}

}

class JuegoViolento inherits Juego{
    override method efecto(cliente, horasJugadas) = cliente.modificarHumor(-10*horasJugadas)
}

class Moba inherits Juego{
    override method efecto(cliente, horasJugadas) = cliente.pagar(30)
}

class JuegoDeTerror inherits Juego{
    override method efecto(cliente, horasJugadas) = cliente.actualizarSuscripcion(infantil)
}

class JuegoEstrategico inherits Juego{
    override method efecto(cliente, horasJugadas) = cliente.modificarHumor(5*horasJugadas)
}


object premium {
  method precio() = 50
  method permiteJugar(juego) = true
}

object base {
  method precio() = 25
  method permiteJugar(juego) = juego.precio() < 30
}

object infantil {
  method precio() = 10
  method permiteJugar(juego) = juego.categoria() == "infantil"
}

object prueba {
  method precio() = 0
  method permiteJugar(juego) = juego.categoria() == "demo"
}

class Usuario{
    
    var suscripcion 
    var saldoDisponible
    var humor

    method modificarHumor(valor){
        humor += valor
    }
    method pagar(valor){
       if (saldoDisponible < valor) {
        throw new Exception(message = "No tiene saldo suficiente para cambiar de suscripcion.")
        }

        saldoDisponible -= valor

    }

    method suscripcion(unaSuscripcion){
        suscripcion = unaSuscripcion
    }

    method actualizarSuscripcion(nuevaSuscripcion){
        if(saldoDisponible >= nuevaSuscripcion.precio()){
            self.pagar(nuevaSuscripcion.precio())
            self.suscripcion(nuevaSuscripcion)
        }
        else{
            self.suscripcion(prueba)
            throw new Exception(message = "No tiene saldo suficiente para cambiar de suscripcion.")
        }
        
    }

    method jugar(unJuego,cantidadDeHoras){
        if(suscripcion.permiteJugar(unJuego)){
            unJuego.efecto(self,cantidadDeHoras)
        }
        else{
            throw new Exception(message = "No esta permitido ese juego")
        }
    }
    
}

object gameFix{
    var juegos = #{}
    var clientes = #{}

    method filtrar(categoria){
        return juegos.filter({juego => juego.categoria() == categoria})
    }
    method coleccionSegun(suscripcion){
        return juegos.filter({juego => suscripcion.permiteJugar(juego)})
    }
    method perteneceA(coleccion, nombreDeUnJuego) = coleccion.contains({juego => juego.mismoNombre(nombreDeUnJuego)})
    
    method buscar(nombreDelJuego, usuario){
        const coleccion = self.coleccionSegun(usuario.suscripcion())
        if (self.perteneceA(coleccion,nombreDelJuego)){
            return coleccion.find({juego => juego.mismoNombre(nombreDelJuego)})
        }
        else{
            throw new Exception(message = "El juego buscado no existe a la colección disponible para el usuario")
        }
    }

    method recomendar() = juegos.anyOne()

    method cobrarSuscripciones() {
        clientes.forEach({ unCliente => unCliente.pagarSuscripcion() })
    }

} 
