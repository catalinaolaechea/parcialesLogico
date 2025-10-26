class Nene {
    var maquillaje = []
    var traje = []
    var actitud
    var caramelos 

    method elementos() = maquillaje ++ traje

    method sustosDeElementos() = self.sumatoriaDeSustosPorElemento(maquillaje) + self.sumatoriaDeSustosPorElemento(traje)

    method sumatoriaDeSustosPorElemento(elementos) = elementos.sum{elemento => elemento.nivelDeSusto()}

    method capacidadDeAsustar() = self.sustosDeElementos() * actitud

    method actitud() = actitud.between(1, 10)

    method recibirCaramelos(cantidad) {
        caramelos += cantidad 
    }

    method intentarAsustar(unAdulto){
        unAdulto.darCaramelosA(self)
    }
    
    method comerCaramelos(cantidad){ 
        if(cantidad > caramelos){
            throw new Exception(message = "no tiene suficientes caramelos en la bolsa")
        }
        else{
            caramelos -= cantidad
        }
        
    }

}

class AdultoComun{
    var nenesQueIntentaronAsustarlo 
    method puedeAsustarsePor(nene) = self.tolerancia() < nene.capacidadDeAsustar()
    method tolerancia() = 10 * nenesQueIntentaronAsustarlo
    method entregarCaramelos() = self.tolerancia() / 2
    method darCaramelosA(nene){
        if(self.puedeAsustarsePor(nene)){
            nene.recibirCaramelos(self.entregarCaramelos())
            self.aumentarNenes(nene)
        }
        else{
            throw new Exception(message = "El nene no pudo asustar al adulto")
        }
    } 
    method aumentarNenes(nene){
        if(nene.caramelos() > 15){
            nenesQueIntentaronAsustarlo += 1
        }
    }
    
}

class Abuelo inherits AdultoComun{
    override method puedeAsustarsePor(nene) = true
    override method entregarCaramelos() = super() / 2
}

class AdultoNecio inherits AdultoComun{
    override method puedeAsustarsePor(nene) = false
}



