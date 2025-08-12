personaje(pumkin,ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny,ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston,mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).


esPeligroso(Personaje):-
    personaje(Personaje,mafioso(maton)),
    trabajaPara(Personaje, OtroPersonaje),
    esPeligroso(OtroPersonaje).

esPeligroso(Personaje):-
    personaje(Personaje,ladron(ListadeLugares)),
    member(licorerias,ListadeLugares),
    trabajaPara(Personaje, OtroPersonaje),
    esPeligroso(OtroPersonaje).

duoTemible(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    pareja(Personaje, OtroPersonaje).

duoTemible(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    amigo(Personaje, OtroPersonaje).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    pareja(Jefe, Espose),
    encargo(Jefe, Personaje,   cuidar(Espose)).

estaEnProblemas(Personaje):-
    personaje(Boxeador, boxeador),
    encargo(_, Personaje, buscar(Boxeador, _)).

estaEnProblemas(butch).

tieneCerca(Personaje,OtroPersonaje):-
    amigo(Personaje, OtroPersonaje).

tieneCerca(Personaje,OtroPersonaje):-
    trabajaPara(Personaje, OtroPersonaje).

sanCayetano(Personaje):-
    tieneCerca(Personaje,OtroPersonaje),
    encargo(Personaje, OtroPersonaje, _).

masAtareado(Personaje):-
    personaje(Personaje, _),
    obtenerEncargos(Personaje,Encargos),
    forall(personaje(OtroPersonaje, _),(obtenerEncargos(OtroPersonaje,OtrosEncargos), Encargos >= OtrosEncargos)).

obtenerEncargos(Personaje,Encargos):-
    personaje(Personaje, _),
    findall(Encargo,encargo(_, Personaje, Encargo),ListaDeEncargos),
    length(ListaDeEncargos, Encargos).

personajesRespetables(Personajes):-
    findall(Personaje,(nivelDeRespeto(Personaje,Nivel), Nivel > 9),Personajes).

nivelDeRespeto(Personaje,Nivel):-
    personaje(Personaje, actriz(Peliculas)),
    length(Peliculas,CantidadDePeliculas),
    Nivel is CantidadDePeliculas/10.

nivelDeRespeto(Personaje,10):-
    personaje(Personaje,mafioso(resuelveProblemas)).

nivelDeRespeto(Personaje,1):-
    personaje(Personaje,mafioso(maton)).

nivelDeRespeto(Personaje,20):-
    personaje(Personaje,mafioso(capo)).

hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    forall(encargo(_, Personaje,Tarea),participaEn(Tarea,OtroPersonaje)).

hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    amigo(OtroPersonaje, Amigo),
    forall(encargo(_, Personaje,Tarea),participaEn(Tarea,Amigo)).

participaEn(ayudar(OtroPersonaje),OtroPersonaje).
participaEn(cuidar(OtroPersonaje),OtroPersonaje).
participaEn(buscar(OtroPersonaje, _),OtroPersonaje).

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(Personaje,OtroPersonaje):-
    unDuo(Personaje,OtroPersonaje),
    tienenCaracteristicasEnComun(Personaje,OtroPersonaje).

duoDiferenciable(Personaje,OtroPersonaje):-
    unDuo(Personaje,OtroPersonaje),
    tienenCaracteristicasEnComun(OtroPersonaje,Personaje).

tienenCaracteristicasEnComun(Personaje,OtroPersonaje):-
    caracteristicas(Personaje,Caracteristicas),
    caracteristicas(OtroPersonaje,OtrasCaracteristicas),
    member(UnaCaracteristica,Caracteristicas),
    not(member(UnaCaracteristica,OtrasCaracteristicas)).

unDuo(Personaje,OtroPersonaje):-
    amigo(Personaje, OtroPersonaje).

unDuo(Personaje,OtroPersonaje):-
    pareja(Personaje, OtroPersonaje).
