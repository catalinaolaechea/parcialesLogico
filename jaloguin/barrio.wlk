class Barrio{
    var habitantes = #{}

    method ordenarNenesPorCantidadDeCaramelos()= habitantes.sortedBy{nene => nene.caramelos()}.reverse()
    method topNenesConMasCaramelos(n) = self.ordenarNenesPorCantidadDeCaramelos().take(n)
    method top3nenes() = self.topNenesConMasCaramelos(3) 
    method elementosMasUsados() = self.topNenesConMasCaramelos(10).flatMap{nene => nene.elementos()}.asSet()

}   
