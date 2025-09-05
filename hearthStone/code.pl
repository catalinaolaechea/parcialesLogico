% jugadores
%jugador(nombre,15,15,[criatura(Nombre, PuntosDanio, PuntosVida, CostoMana)],
%[criatura(Nombre, PuntosDanio, PuntosVida, CostoMana)],[criatura(Nombre, PuntosDanio, PuntosVida, CostoMana)])
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo).

% cartas
criatura(Nombre, PuntosDanio, PuntosVida, CostoMana).
hechizo(Nombre, FunctorEfecto, CostoMana).

% efectos
danio(CantidadDanio).
curar(CantidadCura).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).


cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,daño(Danio),_), Danio).


carta(Jugador,Carta):-
    jugador(Nombre, _, _, CartasMazo, _, _).
    member(Carta,CartasMazo).

carta(Jugador,Carta):-
    jugador(Nombre, _, _, _, CartasMano, _).
    member(Carta,CartasMano).

carta(Jugador,Carta):-
    jugador(Nombre, _, _, _, _, CartasCampo).
    member(Carta,CartasCampo).

esGuerrero(Jugador):-
    jugador(Jugador, _, _, _, _, _),
    forall(carta(Jugador,Carta),esDeTipo(Carta, criatura)).

esDeTipo(criatura(_, _, _, _),criatura).
esDeTipo(hechizo(_, _, _),hechizo).

empiezaTurno(
    jugador(Nombre, PuntosVida, PuntosMana, [PrimeraCarta | RestoMazo], CartasMano, CartasCampo),
    jugador(Nombre, PuntosVida, NuevosPuntosMana, RestoMazo, [PrimeraCarta | CartasMano], CartasCampo)
) :-
    NuevosPuntosMana is PuntosMana + 1.

tieneCapacidad(Jugador,Carta):-
    mana(Jugador, ManaJugador),
    mana(Carta, ManaCarta),
    ManaJugador >= ManaCarta.

vaAPoderJugar(Jugador,Carta):-
    cartasMano(Jugador, Cartas),
    tieneCapacidad(Jugador,Carta),
    empiezaTurno(Jugador,JugadorPost),
    member(Carta,Cartas).




