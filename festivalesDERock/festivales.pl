% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia], hipodromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival 
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

itinerante(Festival):-
    festival(NombreDelFestival, Artistas , Lugar ),
    festival(NombreDelFestival, Artistas , OtroLugar ),
    Lugar \= OtroLugar.

careta(Festival):-
    festival(Festival, _ , _),
    not(entradaVendida(Festival,campo)).

careta(personalFest).
    
nacAndPop(Festival):-
    festival(Festival, Bandas , _),
    not(careta(Festival)).
    forall(member(Banda,Bandas),(banda(Banda, argentina, Popularidad), Popularidad > 1000)).

sobrevendido(Festival):-
    lugar(Festival, Capacidad , _),
    findall(Entrada,entradaVendida(Festival,Entrada),Entradas),
    length(Entradas, CantidadEntradasVendidas),
    CantidadEntradasVendidas > Capacidad.

precioLugarDelFestival(Festival,Lugar,Precio):-
    festival(Festival, _ , Lugar),
    lugar(Lugar, _ , Precio).

%precioEntrada(Festival,Sector,Precio)
precioEntrada(Festival,campo,Precio):-
     lugar(Lugar, _ , Precio).

precioEntrada(Festival,plateaNumerada(Fila),Precio):-
     lugar(Lugar, _ , PrecioBase),
    Fila > 10,
    Precio is PrecioBase * 3.

precioEntrada(Festival,plateaNumerada(Fila),Precio):-
     lugar(Lugar, _ , PrecioBase),
    Fila =< 10,
    Precio is PrecioBase * 6.

precioEntrada(Lugar,plateaGeneral(Zona),Precio):-
    lugar(Lugar, _ , PrecioBase),
    plusZona(Lugar, Zona, Recargo),
    Precio is PrecioBase + Recargo.

recaudacionTotal(Festival,Recaudacion):-
    festival(Festival, _ , Lugar),
    findall(Precio,(entradaVendida(Festival,Entrada),precioEntrada(Lugar,Entrada,Precio)),Precios),
    sumlist(Precios,Recaudacion).

% Relaciona dos bandas si tocaron juntas en algún recital o si una de ellas tocó con una banda del mismo palo que la otra, pero más popular. (con Recursividad)
tocoCon(UnaBanda,OtraBanda):-
    festival(Festival, Bandas, _),
    member(UnaBanda,Bandas),
    member(OtraBanda,Bandas),
    UnaBanda \= OtraBanda.

delMismoPalo(UnaBanda,OtraBanda):-
    tocoCon(UnaBanda,OtraBanda).

delMismoPalo(UnaBanda,OtraBanda):-
    tocoCon(UnaBanda,BandaAmiga),
    banda(BandaAmiga, _ , PopularidadBandaAmiga),
    banda(OtraBanda, _ , PopularidadBanda),
    PopularidadBandaAmiga > PopularidadBanda,
    tocoCon(BandaAmiga,OtraBanda).
