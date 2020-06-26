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



#show lezione/5.