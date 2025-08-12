%hormiga(Nombre).
%vaquitaSanAntonio(Nombre,Peso).
%cucaracha(Nombre,Tamaño,Peso).

 %comio(Personaje, Bicho).
 %base de conocimiento
 comio(pumba, vaquitaSanAntonio(gervasia,3)).
 comio(pumba, hormiga(federica)).
 comio(pumba, hormiga(tuNoEresLaReina)).
 comio(pumba, cucaracha(ginger,15,6)).
 comio(pumba, cucaracha(erikElRojo,25,70)).
 comio(timon, vaquitaSanAntonio(romualda,4)).
 comio(timon, cucaracha(gimeno,12,8)).
 comio(timon, cucaracha(cucurucha,12,5)).
 comio(simba, vaquitaSanAntonio(remeditos,4)).
 comio(simba, hormiga(schwartzenegger)).
 comio(simba, hormiga(niato)).
 comio(simba, hormiga(lula)).

 pesoHormiga(2).

 %peso(Personaje, Peso)
 peso(pumba, 100).
 peso(timon, 50).
 peso(simba, 200).

 peso(cucaracha(_,_,Peso),Peso).
 peso(vaquitaSanAntonio(_,Peso),Peso).
 peso(hormiga(_),2).

jugosita(cucaracha(Nombre,Tamanio,Peso)):-
    comio(_, cucaracha(Nombre,Tamanio,Peso)),
    comio(_, cucaracha(OtroNombre,Tamanio,OtroPeso)),
    Nombre \= OtroNombre,
    Peso > OtroPeso.

hormigofilico(Personaje):-
    comio(Personaje, hormiga(Nombre)),
    comio(Personaje, hormiga(OtroNombre)),
    Nombre \= OtroNombre.

cucarachofobico(Personaje):-
    comio(Personaje, _),
    not(comio(Personaje, cucaracha(_,_,_))).

picaron(pumba).

picaron(Personaje):-
    comio(Personaje, cucaracha(_,_,_)),
    jugosita(cucaracha(_,_,_)).

picaron(Personaje):-
     comio(Personaje, vaquitaSanAntonio(remeditos,4)).

picarones(Personajes):-
    findall(Personaje,picaron(Personaje),Personajes).

%base de conocimiento.
%persigue(Hiena, Personaje).
persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
comio(shenzi,hormiga(conCaraDeSimba)).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).
persigue(scar, mufasa).

engorda(Personaje, PesoTotal):-
   comio(Personaje,_),
   findall(Peso,(comio(Personaje,Presa),peso(Presa,Peso)),ListaDePesos),
   sum_list(ListaDePesos, PesoTotal).

comio(Personaje,Presa):-
    persigue(Personaje, Presa).

cantoEngorda(Personaje, PesoTotal):-
    comio(Personaje,_),
    findall(Peso,(comio(Personaje,OtroPersonaje),pesoTotal(OtroPersonaje,Peso)),ListaDePesos),
    sum_list(ListaDePesos, PesoJuntado).

pesoTotal(OtroPersonaje,Peso):-
    engorda(OtroPersonaje, Peso1),
    peso(OtroPersonaje,Peso2),
    Peso is Peso1 + Peso2.

rey(Rey):-
    comio(Rey,_),
    persigue(Personaje,Rey),
    forall(comio(OtroPersonaje,_),adora(OtroPersonaje,Rey)).

adora(Animal,OtroAnimal):-
    not(comio(OtroAnimal,Animal)).
