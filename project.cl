corso(aupm).
corso(aeds).

docente(gena).
docente(valle).

insegnamento(aupm,  gena,       14).
insegnamento(aeds,  valle,      10).

settimana(1..24).
giorno(1..6).

%ore_al_giorno(giorno, ore_disponibili). 
ore_al_giorno(1..5,8).
ore_al_giorno(6,4..5).

%giorno_settimana(settimana, giorno). 
giorno_settimana(1..4, 5..6).
giorno_settimana(3,     1..4).
% giorno_settimana(16,    1..4).    

durata_lezione(1..4).

lezione(Corso, Docente, Settimana, Giorno, Durata) :- 
    insegnamento(Corso, Docente, _), 
    giorno_settimana(Settimana, Giorno), 
    durata_lezione(Durata).

4 #sum { Durata :  lezione(Corso, Docente, Settimana, Giorno, Durata) } 4 :- 
    insegnamento(Corso, Docente, _),
    giorno_settimana(Settimana, Giorno),
    durata_lezione(Durata).

:- 
:- 
:- 
:- 

% • lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
% r1 :- 
%     ore_docente_in_giorno(Settimana, Giorno, Docente, OreEffettive),
%     OreEffettive<=4.

% 0 #count { calendario(insegnamento(Corso, Docente, _), Settimana, Giorno): docente(Docente) } 4 :- settimana(Settimana), giorno(Giorno).


% • a ciascun insegnamento vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno
% • il primo giorno di lezione prevede nelle prime due ore la presentazione del master
% • prevedere almeno 2 blocchi liberi di 2 ore per recuperi di lezioni annullate 
% • “Project Management” deve concludersi non oltre la prima settimana full-time
% "• la prima lezione di “Accessibilità e usabilità nella progettazione multimediale” 
% deve essere collocata prima che siano terminate le lezioni di “Linguaggi di markup”"

#show lezione/5.