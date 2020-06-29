% #const project_management = c4.
% #const full_week_1 = 2.

% corso(c1).
% corso(aupm).
% corso(lmkp).
% corso(project_management).

% docente(doc1).
% docente(doc2).
% docente(doc3).
% docente(doc4).

% insegnamento(c1,  doc1,      10).
% insegnamento(aupm,  doc2,      10).
% insegnamento(lmkp,  doc3,      10).
% insegnamento(project_management,  doc4,      6).



% %settimana_giorno(Settimana, Giorno).
% % settimana_giorno(4, 5..6).

% durata_lezione(1..4).
% giorno_ore(1..5,8).
% giorno_ore(6,5).
% giorno(1..6).
% settimana(1..4).
% settimana_giorno(1..4,5..6).
% settimana_giorno(full_week_1,1..4).

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
% applicazioni web su dispositivi mobile II” non deve superare le due
% settimane

:- minSett(psa2, InizioPsa2), maxSett(psa1, FinePsa1), InizioPsa2 - FinePsa1 > 2.
% =======================[/distanza_psa1_psa2]===============================%



% le lezioni dei vari insegnamenti devono rispettare le seguenti
% propedeuticità, in particolare la prima lezione dell’insegnamento della
% colonna di destra deve essere successiva alle prime 4 ore di lezione del
% corrispondente insegnamento della colonna di sinistra:
% minGio(C,Gio):- Gio = #min { G : lezione(Sett,G,C,_,_) }, minSett(C, Sett), corso(C).

% ordineAuspicabile(c1,c2; c3,cn).
% % (c1, c2)
%   % contare le ore di C1 fatte nelle settimane precedenti all'inizio di C2.
% oreSettimanePreC2(C1, C2, Ore) :- 
%     Ore = #sum { Durata :  lezione(S1,G,C1,D,Durata)}, 
%     ordineAuspicabile(C1,C2), 
%     settimana(S1),
%     minSett(C2, S2),
%     S1 < S2.

    
    % contare le ore fatte nelle settimane precedenti.
    % contare le ore fatte nella stessa settimana ma nei giorni precedenti
    % la loro somma deve essere >= 4



% Fondamenti di ICT e Paradigmi di Programmazione              inizioC2



% #show oreSettimanePreC2/3.
% #show lezione/5.
#show minSett/2.
#show maxSett/2.
