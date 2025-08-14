%persona(Apodo, Edad, Peculiaridades). 
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]). 
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]). 
persona(fran, 30, [fanDeLosComics]). 
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa). 
esSalaDe(elPayasoExorcista, salSiPuedes). 
esSalaDe(socorro, salSiPuedes). 
esSalaDe(linternas, elLaberintoso). 
esSalaDe(guerrasEstelares, escapepepe). 
esSalaDe(fundacionDelMulo, escapepepe).
esSalaDe(estrellasDePelea, supercelula).
esSalaDe(miseriaDeLaNoche, skPista).
esSalaDe(estrellasDePelea, estrellasDePelea).
%verigo no cuenta con salas, por lo que no puede ser definida.

%terrorifica(CantidadDeSustos, EdadMinima). 
%familiar(Tematica, CantidadDeHabitaciones). 
%enigmatica(Candados). 
%sala(Nombre, Experiencia). 

sala(estrellasDePelea, familiar(videojuegos, 7)). 
sala(choqueDeLaRealeza, familiar(videojuegos, _)).
sala(miseriaDeLaNoche, terrorifica(150, 21)). 
sala(elPayasoExorcista, terrorifica(100, 18)). 
sala(socorro, terrorifica(20, 12)). 
sala(linternas, familiar(comics, 5)). 
sala(guerrasEstelares, familiar(futurista, 7)). 
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, 
deBoton])).


nivelDeDificultadDeLaSala(Sala, Dificultad):-
    sala(Sala, Experiencia),
    dificultadExperiencia(Experiencia,Dificultad).

dificultadExperiencia(terrorifica(CantidadDeSustos, EdadMinima),Dificultad).
    Dificultad is CantidadDeSustos - EdadMinima.

dificultadExperiencia(familiar(futurista, _), 15).

dificultadExperiencia(familiar(_, Dificultad), Dificultad).

dificultadExperiencia(enigmatica(Candados), Dificultad):-
    length(Candados, Dificultad).

esClaustrofobica(Persona):-
    persona(Persona, _, Peculiaridades),
    member(claustrofobia, Peculiaridades).
    
puedeSalir(Persona,Sala):-
    persona(Persona, _, _ ),
    nivelDeDificultadDeLaSala(Sala, 1),
    not(esClaustrofobica(Persona)).

puedeSalir(Persona,Sala):-
    persona(Persona, Edad, _ ),
    Edad > 13,
    nivelDeDificultadDeLaSala(Sala, Dificultad),
    Dificultad < 5,
    not(esClaustrofobica(Persona)).

tieneSuerte(Persona,Sala):-
    persona(Persona,_,Peculiaridades),
    puedeSalir(Persona,Sala),
    not(member(_,Peculiaridades)).

esMacabra(Empresa):-
    esSalaDe(_, Empresa),
    forall(esSalaDe(UnaSala, Empresa),sala(UnaSala, terrorifica(_, _))).

empresaCopada(Empresa):-
    esSalaDe(_, Empresa),
    not(esMacabra(Empresa)),
    findall(Dificultad,dificultadSala(Empresa,Sala,Dificultad),ListaDeDificultadDeSalas),
    promedioDeDificultadDeSalas(ListaDeDificultadDeSalas,Promedio),
    Promedio < 4.

dificultadSala(Empresa,Sala,Dificultad):-
    esSalaDe(Sala, Empresa),
    nivelDeDificultadDeLaSala(Sala, Dificultad).

promedioDeDificultadDeSalas(ListaDeDificultadDeSalas,Promedio):-
    length(ListaDeDificultadDeSalas,CantidadDeSalas),
    sumlist(ListaDeDificultadDeSalas,TotalDificultad),
    Promedio is TotalDificultad/CantidadDeSalas.
