
class Legion{
    var grupoDeNenes = []

    method capacidadDeasustar() = grupoDeNenes.sum{nene => nene.capacidadDeasustar()}

    method caramelosEnPosesion() = grupoDeNenes.sum{nene => nene.caramelos()}

    method liderDeLaRegion() = grupoDeNenes.max{nene => nene.capacidadDeAsustar()}

    method intentarAsustarA(adulto){
        adulto.darCaramelosA(self.liderDeLaRegion())
    }
/*
    method cantidadDeNenes(){
        if(grupoDeNenes.size() < 2){
            throw new Exception(message = "no se pudo crear la clase")
        }   
    } 
*/

}
