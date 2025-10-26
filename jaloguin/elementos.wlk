
class Maquillaje{
    var nivelDeSusto = 3
    method nivelDesusto() = nivelDeSusto
}

class Traje{
    const tipo 
    method nivelDesusto() = tipo.susto()

}

object terrorifico {
    const susto = 5

    method susto() = susto
}
object tierno {
    const susto = 2

    method susto() = susto
}
const georgeBush = new Traje(tipo = terrorifico)
const jason = new Traje(tipo = terrorifico)
const winniePooh = new Traje(tipo = tierno)
const sullivan = new Traje(tipo = tierno)
