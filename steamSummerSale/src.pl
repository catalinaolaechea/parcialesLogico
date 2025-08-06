%accion(NombreDelJuego).
%mmorpg(NombreDelJuego, CantidadDeUsuarios).
%puzzle(NombreDelJuego, CantidadDeNiveles, Dificultad).

%juego(Juego,Precio)
juego(accion(callOfDuty),5).
juego(accion(batmanAA),10).
juego(mmorpg(wow,5000000),30).
juego(mmorpg(lineage2,6000000),15).
juego(puzzle(plantsVsZombies,40,media),10).
juego(puzzle(tetris,10,facil),0).

%oferta(NombreDelJuego,PorcentajeDeDescuento).
oferta(callOfDuty,10).
oferta(plantsVsZombies,50).

%compra(NombreDelJuego).
%regalo(NombreDelJuego,Destinatario).

%usuario(Persona,Juegos,Adquisiciones)
usuario(nico,[batmanAA,plantsVsZombies,tetris],[compra(lineage2)]).
usuario(fede,[],[regalo(callOfDuty,nico),regalo(wow,nico)]).
usuario(rasta,[lineage2],[]).
usuario(agus,[],[]).
usuario(felipe,[plantsVsZombies],[compra(tetris)]).

generoDelJuego(juego(Genero,_),Genero).

%nombreDelJuego(Juego,NombreDelJuego).
nombreDelJuego(juego(accion(NombreDelJuego),_),NombreDelJuego).
nombreDelJuego(juego(mmorpg(NombreDelJuego,_),_),NombreDelJuego).
nombreDelJuego(juego(puzzle(NombreDelJuego,_,_),_),NombreDelJuego).

%precioDelJuego(Juego,PrecioDelJuego).
precioDelJuego(juego(accion(_),PrecioDelJuego),PrecioDelJuego).
precioDelJuego(juego(puzzle(_,_,_),PrecioDelJuego),PrecioDelJuego).
precioDelJuego(juego(mmorpg(_,_),PrecioDelJuego),PrecioDelJuego).

%nombreDeLaAdquisicion(Adquisicion,NombreDelJuego).
nombreDeLaAdquisicion(compra(NombreDelJuego),NombreDelJuego).
nombreDeLaAdquisicion(regalo(NombreDelJuego,_),NombreDelJuego).

evaluarOferta(NombreDelJuego,Precio,Valor):-
    oferta(NombreDelJuego,Descuento),
    Valor is Precio * (1 - Descuento/ 100).

evaluarOferta(_,Precio,Precio).

cuantoSale(Juego,Valor):-
    nombreDelJuego(Juego,NombreDelJuego),
    precioDelJuego(Juego,PrecioDelJuego),
    evaluarOferta(NombreDelJuego,PrecioDelJuego,Valor).

juegoPopular(juego(accion(_),_)).
juegoPopular(juego(puzzle(_,25,_),_)).
juegoPopular(juego(puzzle(_,_,facil),_)).
juegoPopular(juego(mmorpg(_, CantidadDeUsuarios),_)):-
    CantidadDeUsuarios > 1000000.

tieneUnBuenDescuento(Juego):-
    nombreDelJuego(Juego,NombreDelJuego),
    oferta(NombreDelJuego,Descuento),
    Descuento > 50.

adictoALosDescuentos(Usuario):-
    usuario(Usuario,_,_),
    forall(usuario(Usuario,_,VaAAdquirir),(member(compra(NombreDelJuego),VaAAdquirir),nombreDelJuego(Juego,NombreDelJuego),tieneUnBuenDescuento(Juego))).

fanaticoDe(Usuario,Genero):-
    usuario(Usuario,JuegosQueTiene,_),
    member(UnNombreDeJuego, JuegosQueTiene),
    member(OtroNombreDeJuego, JuegosQueTiene),
    UnNombreDeJuego \= OtroNombreDeJuego,
    nombreDelJuego(UnJuego,UnNombreDeJuego),
    nombreDelJuego(OtroJuego,OtroNombreDeJuego),
    generoDelJuego(UnJuego,Genero),
    generoDelJuego(OtroJuego,Genero).

monotematico(Usuario,Genero):-
    usuario(Usuario, JuegosQueYaTiene, _),
    generoDelJuego(_, Genero),
    forall(member(Nombre,JuegosQueYaTiene), esDeGenero(Nombre,Genero)).

esDeGenero(Nombre,Genero):-
    nombreDelJuego(Juego, Nombre),
    generoDelJuego(Juego, Genero).

buenosAmigos(UsuarioUno,UsuarioDos):-
    usuario(UsuarioUno, _ , _ ),
    usuario(UsuarioDos, _, _),
    leRegala(UsuarioUno,UsuarioDos),
    leRegala(UsuarioDos,UsuarioUno).

leRegala(Usuario1,Usuario2):-
    usuario(Usuario1, _ , ListaAdquisiones),
    member(regalo(NombreDelJuego,Usuario2),ListaAdquisiones),
    nombreDelJuego(Juego,NombreDelJuego),
    juegoPopular(Juego).

cuantoGastara(Usuario,CantidadDeDinero):-
    usuario(Usuario, _ , ListaAdquisiones),
    findall(PrecioAdquisicion,(member(Adquisicion,ListaAdquisiones),valorAdquisicion(Adquisicion,PrecioAdquisicion)),ListaPrecioPorAdquisicion),
    sumlist(ListaPrecioPorAdquisicion, CantidadDeDinero).
    
valorAdquisicion(Adquisicion,Precio):-
    nombreDeLaAdquisicion(Adquisicion,NombreDelJuego),
    nombreDelJuego(Juego,NombreDelJuego),
    cuantoSale(Juego,Precio).
