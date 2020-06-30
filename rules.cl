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
% oreDocente(Sett, Gio, D, Sum) :- 
%     Sum = #sum { Durata,C : lezione(Sett,Gio,C,D,Durata)}, docente(D), settimana_giorno(Sett,Gio).
% :- oreDocente(Settimana,Giorno, Docente, Somma), docente(Docente), giorno_ore(Giorno, OreMassime), Somma>4.

:- { lezione(Sett,Gio,C,D,Durata)   },
    Sum = #sum { Durata,C : lezione(Sett,Gio,C,D,Durata)}, 
    settimana_giorno(Sett,Gio),
    docente(D), 
    Sum>4.
% =======================[/ore_docente]================================%

% =======================[ore_corso]================================%
% a ciascun insegnamento vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno
% oreCorso(Sett, Gio, C, Sum) :- 
%     Sum = #sum { Durata,D : lezione(Sett,Gio,C,D,Durata)}, corso(C), settimana_giorno(Sett, Gio).
% :- oreCorso(Settimana, Giorno, Corso, Somma), corso(Corso), giorno_ore(Giorno, OreMassime), Somma>4.
% :- oreCorso(Settimana, Giorno, Corso, Somma), corso(Corso), giorno_ore(Giorno, OreMassime), Somma==1.

:- { lezione(Sett,Gio,C,D,Durata) },
    Sum = #sum { Durata,D : lezione(Sett,Gio,C,D,Durata)}, 
    settimana_giorno(Sett, Gio),
    corso(C),
    Sum>4.
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
:- lezione(Settimana,_,pmgt,_,_), Settimana > full_week_1.
% =======================[/termine_project_management]===============================%

% =======================[c1_prima_di_c2]===============================%
% "• la prima lezione di c1 [aupm] 
%  deve essere collocata prima che siano terminate le lezioni di c2 [lmkp] 
% minSettC1(Sett):- Sett = #min { S : lezione(S,_,aupm,_,_) }.
minGioC1(Gio):- Gio = #min { G : lezione(Sett,G,aupm,_,_) }, minSett(aupm, Sett).

% maxSettC2(Sett):- Sett = #max { S : lezione(S,_,lmkp,_,_) }.
maxGioC2(Gio):- Gio = #max { G : lezione(Sett,G,lmkp,_,_) }, maxSett(lmkp, Sett).

:- maxSett(lmkp, SettC2),
    minSett(aupm, SettC1),
    SettC1 > SettC2.
    
:- maxSett(lmkp, Sett), maxGioC2(GioC2),
    minSett(aupm, Sett), minGioC1(GioC1),
    GioC1 > GioC2.
% =======================[/c1_prima_di_c2]==============================%

% =======================[ordine_corsi]===============================%
:- lezione(Settimana1,_,C1,_,_), 
    lezione(Settimana2,_,C2,_,_),
    ordineCorsi(C1,C2),
    Settimana1 > Settimana2.
:- lezione(Settimana,G1,C1,_,_), 
    lezione(Settimana,G2,C2,_,_),
    ordineCorsi(C1,C2),
    G1>G2.
% =======================[/ordine_corsi]===============================%

% =======================[distanza_corsi]===============================%
% la  distanza  tra  la  prima  e  l’ultima  lezione  di  ciascun  insegnamento  
% non deve superare le 6 settimane
minSett(Corso, Sett):- Sett = #min { S : lezione(S,_,Corso,_,_) }, corso(Corso), Sett != #sup.
maxSett(Corso, Sett):- Sett = #max { S : lezione(S,_,Corso,_,_) }, corso(Corso), Sett != #sup.
% https://github.com/potassco/clingo/issues/172
:- minSett(C, Min), maxSett(C, Max),  Max - Min > 6.
% =======================[/distanza_corsi]===============================%

% =======================[prima_lezione_casm_issm]===============================%
% la prima lezione degli insegnamenti “Crossmedia: articolazione delle
% scritture multimediali” e “Introduzione al social media management”
% devono essere collocate nella seconda settimana full-time
:- minSett(casm, Start), Start != full_week_2.
:- minSett(issm, Start), Start != full_week_2.

% =======================[/prima_lezione_casm_issm]===============================%

% =======================[distanza_psa1_psa2]===============================%
% la distanza fra l’ultima lezione di “Progettazione e sviluppo di applicazioni
% web su dispositivi mobile I” e la prima di “Progettazione e sviluppo di
% applicazioni web su dispositivi mobile II” non deve superare le due settimane
:- minSett(psa2, InizioPsa2), maxSett(psa1, FinePsa1), InizioPsa2 - FinePsa1 > 2.
% =======================[/distanza_psa1_psa2]===============================%



% =======================[ordine_auspicabile]===============================%

% diffGiorni(S,G,C2, Res):-
%     settimana_giorno(S,G),
%     minSett(C2, S2),
%     minGio(C2, G2),
%     Res = ((S2*7)+G2)-((S*7)+G). 
% orePrima(C1,C2, Ore):-
%     Ore = #sum { Durata,S,G : lezione(S,G,C1,_,Durata), diffGiorni(S,G,C2, Res), Res>0 },
%     corso(C1),
%     ordineAuspicabile(C1,C2).
% :- orePrima(C1,C2,X), ordineAuspicabile(C1,C2), X<4.
% #show orePrima/3.

minGio(C,Gio):- Gio = #min { G : lezione(Sett,G,C,_,_) }, minSett(C, Sett), corso(C).
diffGiorni(S,G,C2, Res):-
    settimana_giorno(S,G),
    minSett(C2, S2),
    minGio(C2, G2),
    Res = ((S2*7)+G2)-((S*7)+G). 

:- {lezione(S,G,C1,_,Durata): corso(C1)}, 
    Ore = #sum { Durata,S,G : lezione(S,G,C1,_,Durata), diffGiorni(S,G,C2, Res), Res>0 },
    ordineAuspicabile(C1,C2),
    Ore < 4.
% =======================[/ordine_auspicabile]===============================%
    

#show lezione/5.