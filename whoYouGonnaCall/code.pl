
% herramientasRequeridas(Tarea, Herramientas).
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(winston,aritaDeNeutrones).

necesita(Integrante,aspiradora(Potencia)):-
    tiene(Integrante,aspiradora(UnaPotencia)),
    UnaPotencia >= Potencia. 

necesita(Integrante,Herramienta):-
    tiene(Integrante,Herramienta).

puedeRealizar(Persona,Tarea):-
    herramientasRequeridas(Tarea, _),
    necesita(Persona,varitaDeNeutrones).

puedeRealizar(Persona,Tarea):-
    tiene(Persona,_),
    herramientasRequeridas(Tarea, HerramientasRequeridas),
    forall(member(Herramienta,HerramientasRequeridas),necesita(Integrante,Herramienta)).

%tareaPedida(Cliente,Tarea,CantidadMetros).
tareaPedida(juano,ordenarCuarto,5).
%precio(Tarea,PrecioPorMetroCuadrado).
precio(ordenarCuarto,600).

%pedido son las tareas del cliente
%lo que se le cobraría al cliente sería la suma del valor 
%a cobrar por cada tarea, multiplicando el precio por los metros cuadrados de la tarea.
cobrar(Cliente,PrecioFinal):-
    tareaPedida(Cliente,_,_),
    findall(Precio,(tareaPedida(Cliente,Tarea,Metros),calcularPrecio(Tarea,Metros,Precio)),ListaDePrecios),
    sumlist(ListaDePrecios, PrecioFinal).
    
calcularPrecio(Tarea,Metros,PrecioFinal):-
    precio(Tarea,PrecioDeLaTarea),
    PrecioFinal is PrecioDeLaTarea * Metros.

%un pedido es una lista de tareas
aceptaPedido(Integrante,Cliente):-
    tiene(Integrante,_),
    tareaPedida(Cliente,_,_),
    estaDispuesto(Integrante,Tarea,Cliente),
    forall(tareaPedida(Cliente,Tarea,Metros),puedeRealizar(Integrante,Tarea)).

estaDispuesto(winston,Tarea,Cliente):-
    cobrar(Cliente,Precio),
    Precio > 500.

%Ray sólo acepta pedidos que no incluyan limpiar techos
estaDispuestoAHacer(ray,_, Cliente):-
	not(tareaPedida(Cliente, limpiarTecho, _)).

estaDispuesto(peter,_,_).

estaDispuesto(egon,Tarea,Cliente):-
    tareaPedida(Cliente,Tarea,_),
    not(esCompleja(Tarea)).

esCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, CantidadDeHerramientas),
    CantidadDeHerramientas > 2.

esCompleja(limpiezaDeTecho).
    
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).
