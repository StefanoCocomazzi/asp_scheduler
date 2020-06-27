{lezione(S, G, C, D, Len): insegnamento(C,D,_)} :- settimana_giorno(S,G), durata_lezione(Len).

% =======================[durata_insegnamento]======================== %
durataInsegnamento(C, Ore) :-  
    Ore = #sum { Durata, S, G, Doc : lezione(S, G, C, Doc, Durata)},
    corso(C).
:- insegnamento(C,D,Atteso), durataInsegnamento(C, Attuale), Attuale!=Atteso.
% =======================[/durata_insegnamento]======================== %

% =======================[ore_al_giorno]================================%
oreAlGiorno(Sett, Gio, Sum) :- 
    Sum = #sum { Durata,C,D : lezione(Sett,Gio,C,D,Durata)}, settimana_giorno(Sett, Gio).
:- oreAlGiorno(Settimana,Giorno, Somma), giorno_ore(Giorno, OreMassime), Somma>OreMassime.
% =======================[/ore_al_giorno]================================%

% =======================[ore_docente]================================%
% lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
oreDocente(Sett, Gio, D, Sum) :- 
    Sum = #sum { Durata,C : lezione(Sett,Gio,C,D,Durata)}, docente(D), settimana_giorno(Sett,Gio).
:- oreDocente(Settimana,Giorno, Docente, Somma), docente(Docente), giorno_ore(Giorno, OreMassime), Somma>4.
% =======================[/ore_docente]================================%

% =======================[ore_corso]================================%
% a ciascun insegnamento vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno
oreCorso(Sett, Gio, C, Sum) :- 
    Sum = #sum { Durata,D : lezione(Sett,Gio,C,D,Durata)}, corso(C), settimana_giorno(Sett, Gio).
:- oreCorso(Settimana, Giorno, Corso, Somma), corso(Corso), giorno_ore(Giorno, OreMassime), Somma>4.
:- oreCorso(Settimana, Giorno, Corso, Somma), corso(Corso), giorno_ore(Giorno, OreMassime), Somma==1.
% =======================[/ore_corso]================================%

% =======================[presentazione_master]================================%
% il primo giorno di lezione prevede nelle prime due ore la presentazione del master
lezione(1,5,presentazione,tutti, 2).
% =======================[/presentazione_master]================================%

% =======================[giorni_di_recupero]================================%
% prevedere almeno 2 blocchi liberi di 2 ore per recuperi di lezioni annullate 
giornoRecupero(Settimana, Giorno, Ore) :- 
    oreAlGiorno(Settimana, Giorno, Somma), 
    giorno_ore(Giorno, OreMassime),
    Ore = OreMassime - Somma, 
    Ore >= 2.
numGiorniDiRecupero(Num) :- Num = #count { Ore,Settimana,Giorno: giornoRecupero(Settimana, Giorno, Ore) }.
:- numGiorniDiRecupero(Num), Num < 2.
% =======================[/giorni_di_recupero]================================%

% =======================[termine_project_management]================================%
% • “Project Management” deve concludersi non oltre la prima settimana full-time
:- lezione(Settimana,_,project_management,_,_), Settimana > full_week_1.
% =======================[/termine_project_management]===============================%

% =======================[c1_prima_di_c2]===============================%
% "• la prima lezione di c1 [aupm] 
%  deve essere collocata prima che siano terminate le lezioni di c2 [lmkp] 
minSettC1(Sett):- Sett = #min { S : lezione(S,_,aupm,_,_) }.
minGioC1(Gio):- Gio = #min { G : lezione(Sett,G,aupm,_,_) }, minSettC1(Sett).

maxSettC2(Sett):- Sett = #max { S : lezione(S,_,lmkp,_,_) }.
maxGioC2(Gio):- Gio = #max { G : lezione(Sett,G,lmkp,_,_) }, maxSettC2(Sett).

:- maxSettC2(SettC2),
    minSettC1(SettC1),
    SettC1 > SettC2.
    
:- maxSettC2(Sett), maxGioC2(GioC2),
    minSettC1(Sett), minGioC1(GioC1),
    GioC1 > GioC2.
% =======================[/c1_prima_di_c2]==============================%


% =======================[ordine_corsi]===============================%
:- lezione(Settimana1,_,C1,_,_), 
    lezione(Settimana2,_,C2,_,_),
    ordineCorsi(C1,C2),
    Settimana1 > Settimana2.
:- lezione(Settimana1,G1,C1,_,_), 
    lezione(Settimana2,G2,C2,_,_),
    ordineCorsi(C1,C2),
    Settimana1 == Settimana2, G1>G2.
% =======================[/ordine_corsi]===============================%

% #show settimana_giorno/2.
% #show oreCorso/4.
% #show durataInsegnamento/2.

#show lezione/5.
% #show giornoRecupero/3.
% #show oreAlGiorno/3.
% #show numGiorniDiRecupero/1.