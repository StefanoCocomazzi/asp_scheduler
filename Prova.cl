corso(c1).
corso(c2).
corso(c3).
corso(c4).

docente(doc1).
docente(doc2).
docente(doc3).
docente(doc4).

insegnamento(c1,  doc1,      4).
insegnamento(c2,  doc2,      5).
insegnamento(c3,  doc3,      6).
insegnamento(c4,  doc4,      10).

% giorno_ore(1..5,8).
% giorno_ore(6,4..5).

%settimana_giorno(Settimana, Giorno).
% settimana_giorno(4, 5..6).

durata_lezione(1..4).
giorno(ven;sab).
settimana(1..10).


{lezione(S, G, C, D, Len): insegnamento(C,D,_)} :- settimana(S), giorno(G), durata_lezione(Len).

% =======================[durata_insegnamento]======================== %
durataInsegnamento(C, Ore) :-  
    Ore = #sum { Durata, S, G, Doc : lezione(S, G, C, Doc, Durata)},
    corso(C).
:- insegnamento(C,D,Atteso), durataInsegnamento(C, Attuale), Attuale!=Atteso.
% =======================[/durata_insegnamento]======================== %




#show durataInsegnamento/2.
#show lezione/5.

