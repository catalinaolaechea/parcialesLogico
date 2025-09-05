integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

tieneBuenaBase(Grupo):-
    integrante(Grupo, Integrante, Instrumento),
    integrante(Grupo, OtroIntegrante, OtroInstrumento),
    instrumento(Instrumento, armonico),
    instrumento(OtroInstrumento, ritmico).

seDestaca(Persona,Grupo):-
    nivelConElQueToca(Persona,Grupo,NivelSuperior),
    forall((nivelConElQueToca(OtraPersona,Grupo,Nivel),OtraPersona \= Persona), Nivel+2 < NivelSuperior).

nivelConElQueToca(Persona,Grupo,Nivel):-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel).

grupo(vientosDelEste,bigBand).
grupo(sophieTrio ,formacion([contrabajo,guitarra,violín])).
grupo(jazzmin ,formacion([bateria,bajo,trompeta,piano,guitarra])).
grupo(estudio1,ensamble(3)).

sirve(Intrumento,formacion(InstrumentosQueBuscan)):-
    member(Instrumento,InstrumentosQueBuscan).

sirve(bateria,bigBand).
sirve(bajo,bigBand).
sirve(piano,bigBand).
sirve(Instrumento,bigBand):-
    esDeViento(Instrumento).

sirve(Instrumento,ensamble(_)):-
    instrumento(Instrumento, _).

esDeViento(Instrumento):-
    instrumento(Instrumento, melodico(viento)).

hayCupo(Instrumento,Grupo):-
    grupo(Grupo,TipoDeBanda),
    instrumento(Instrumento, _),
    sirve(Instrumento,TipoDeBanda),
    not(integrante(Grupo, _, Instrumento)).

hayCupo(Instrumento,Grupo):-
    grupo(Grupo,bigBand),
    esDeViento(Instrumento).

puedeIncorporarse(Persona,Instrumento,Grupo):-
    nivelQueTiene(Persona, Instrumento, Nivel),
    grupo(Grupo,TipoDeGrupo),
    nivelMinimoRequerido(TipoDeGrupo,NivelMinimo),
    Nivel >= NivelMinimo,
    hayCupo(Instrumento,Grupo),
    not(integrante(Grupo,Persona,Instrumento)).

nivelMinimoRequerido(bigBand,1).
nivelMinimoRequerido(formacion([Instrumentos]),Nivel):-
    length(Instrumentos,CantidadInstrumentosBuscados),
    Nivel is 7 - CantidadInstrumentosBuscados.
nivelMinimoRequerido(ensamble(Nivel),Nivel).

seQuedoEnBanda(Persona):-
    nivelQueTiene(Persona, _, _),
    not(integrante(_, Persona, _)), 
    not(puedeIncorporarse(Persona,_,_)).

puedeTocar(Grupo):-
    grupo(Grupo,TipoDebanda),
    estaListo(Grupo,TipoDebanda).

estaListo(Grupo,bigBand):-
    tieneBuenaBase(Grupo),
    tocanInstrumentosDeViento(Grupo,CantidadDeIntegrantes),
    CantidadDeIntegrantes >= 5.

tocanInstrumentosDeViento(Grupo,CantidadDeIntegrantes):-
    findall(Persona,(integrante(Grupo, Persona, Instrumento),esDeViento(Instrumento)),Integrantes),
    length(Integrantes,CantidadDeIntegrantes).

estaListo(Grupo,formacion(Instrumentos)):-
    forall(member(Instrumento,Instrumentos),integrante(Grupo, _, Instrumento)).

estaListo(Grupo,ensamble(NivelMinimo)):-
    tieneBuenaBase(Grupo),
    integrante(Grupo, Integrante, Instrumento),
    instrumento(Instrumento, melodico(_)).

