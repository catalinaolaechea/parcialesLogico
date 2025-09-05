% Recorridos en GBA:
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% Recorridos en CABA:
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

puedenCombinarse(UnaLinea,OtraLinea):-
    recorrido(UnaLinea, Zona, Calle),
    recorrido(OtraLinea, Zona , Calle),
    Linea \= OtraLinea.

cruzaGeneralPaz(Linea):-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_),_).

jurisdiccion(Linea,nacional):-
    cruzaGeneralPaz(Linea).

jurisdiccion(Linea,provincial(caba)):-
    recorrido(Linea, caba, _),
    not(cruzaGeneralPaz(Linea)).

jurisdiccion(Linea,provincial(buenosAires)):-
    recorrido(Linea, gba(_), _),
    not(cruzaGeneralPaz(Linea)).

%Zona puede ser gba(_) o caba
laMasTransitada(Calle,Zona):-
    transito(Calle,Zona,MayorNivelDeTransito),
    forall((recorrido(_, Zona , OtraCalle), Calle \= OtraCalle) ,(transito(OtraCalle,Zona,OtroNivelDeTransito) , OtroNivelDeTransito < MayorNivelDeTransito)).

transito(Calle,Zona,Cantidad):-
    recorrido(_, Zona , Calle),
    findall(Linea,recorrido(Linea, Zona , Calle),CantidadDeLineas),
    length(CantidadDeLineas, Cantidad).
    
esDeTransbordo(Calle,Zona):-
    transito(Calle,Zona,CantidadDeLineas),
    CantidadDeLineas >= 3,
    forall(recorrido(Linea, Zona, Calle),jurisdiccion(Linea,nacional)).

beneficiario(juanita,estudiantil).
beneficiario(pepito,personalCasasParticulares(gba(oeste))).
beneficiario(marta,jubilado).
beneficiario(marta,personalCasasParticulares(caba)).
beneficiario(marta,personalCasasParticulares(gba(sur))).

descuento(_,estudiantil,50).

descuento(Linea,personalCasasParticulares(Zona),0):-
    recorrido(Linea, Zona , _).

descuento(Linea,jubilado,PrecioConDescuento):-
    costoNormal(Linea,Precio),
    PrecioConDescuento is Precio / 2.

costoNormal(Linea,500):-
    jurisdiccion(Linea,nacional).

costoNormal(Linea,350):-
    jurisdiccion(Linea,provincial(caba)).

costoNormal(Linea,CostoTotal):-
    jurisdiccion(Linea,provincial(buenosAires)),
    callesEnsuRecorrido(Linea,CantidadTotal),
    pasaPorZonasDistintas(Linea),
    plus(Linea,ValorAgregado),
    CostoTotal is 25*CantidadTotal + ValorAgregado.

costoNormal(Linea,CostoTotal):-
    jurisdiccion(Linea,provincial(buenosAires)),
    callesEnsuRecorrido(Linea,CantidadTotal),
    not(pasaPorZonasDistintas(Linea)),
    CostoTotal is 25*CantidadTotal.

callesEnsuRecorrido(Linea,CantidadTotal):-
    recorrido(Linea, _,_),
    findall(Calle,recorrido(Linea, _,Calle),Calles),
    length(Calles, CantidadTotal).

pasaPorZonasDistintas(Linea):-
    recorrido(Linea, gba(Zona), _),
    recorrido(Linea, gba(OtraZona), _),
    Zona \= OtraZona.

plus(Linea,0):-
    not(pasaPorZonasDistintas(Linea)).

plus(Linea,50):-
    pasaPorZonasDistintas(Linea).

costoPasaje(Persona,Linea,Precio):-
    costoNormal(Linea,CostoTotal),
    not(beneficiario(Persona,_)).

% evaluo tambien la posibilidad de que la persona tenga más de un beneficio.
costoPasaje(Persona,Linea,Precio):-
    beneficiario(Persona,UnBeneficio),
    descuento(Linea,UnBeneficio,MejorPrecio),
    forall((beneficiario(Persona,OtroBeneficio),descuento(Linea,OtroBeneficio,OtroPrecio),OtroBeneficio \= UnBeneficio), MejorPrecio < OtroPrecio ).
