corso(aupm  ).
corso(aeds  ).
corso(aeis  ).
corso(aesid ).
corso(aslcw ).
corso(cpcp  ).
corso(casm  ).
corso(edfd  ).
corso(fipp  ).
corso(g3d   ).
corso(vgpd  ).
corso(ismm  ).
corso(gsqa  ).
corso(gsru  ).
corso(lmkp  ).
corso(mkdg  ).
corso(prdb  ).
corso(psa1  ).
corso(psa2  ).
corso(pgdi  ).
corso(pmgm  ).
corso(rdpcd ).
corso(smlt  ).
corso(smism ).
corso(tsmd  ).
corso(tssw  ).

docente(boniolo     ).
docente(damiano     ).
docente(gabardi     ).
docente(gena        ).
docente(ghidelli    ).
docente(giordani    ).
docente(gribaudo    ).
docente(lombardo    ).
docente(mazzei      ).
docente(micalizio   ).
docente(muzzetto    ).
docente(pozzato     ).
docente(santangelo  ).
docente(schifanella ).
docente(suppini     ).
docente(taddeo      ).
docente(terranova   ).
docente(tomatis     ).
docente(travostino  ).
docente(valle       ).
docente(vargiu      ).
docente(zanchetta   ).

insegnamento(aupm,  gena,       14).
insegnamento(aeds,  valle,      10).
% insegnamento(aeis,  zanchetta,  14).
% insegnamento(aesid, ghidelli,   20).
% insegnamento(aslcw, micalizio,  20).
% insegnamento(cpcp,  gabardi,    14).
% insegnamento(casm,  taddeo,     20).
% insegnamento(edfd,  vargiu,     10).
% insegnamento(fipp,  pozzato,    14).
% insegnamento(g3d,   gribaudo,   20).
% insegnamento(vgpd,  travostino, 10).
% insegnamento(ismm,  suppini,    14).
% insegnamento(gsqa,  tomatis,    10).
% insegnamento(gsru,  lombardo,   10).
% insegnamento(lmkp,  gena,       20).
% insegnamento(mkdg,  muzzetto,   10).
% insegnamento(prdb,  mazzei,     20).
% insegnamento(psa1,  pozzato,    10).
% insegnamento(psa2,  schifanella,10).
% insegnamento(pgdi,  terranova,  10).
% insegnamento(pmgm,  muzzetto,   14).
% insegnamento(rdpcd, boniolo,    10).
% insegnamento(smlt,  santangelo, 10).
% insegnamento(smism, giordani,   14).
% insegnamento(tsmd,  zanchetta,  10).
% insegnamento(tssw,  damiano,    20).

settimana(1..24).
giorno(1..6).

%ore_al_giorno(giorno, ore_disponibili). 
ore_al_giorno(1..5,8).
ore_al_giorno(6,4..5).

%giorno_settimana(settimana, giorno). 
giorno_settimana(1..4, 5..6).
giorno_settimana(3,     1..4).
% giorno_settimana(16,    1..4).


5 { calendario } 5


% • lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
% r1 :- 
%     ore_docente_in_giorno(Settimana, Giorno, Docente, OreEffettive),
%     OreEffettive<=4.

 0 #count { calendario(insegnamento(Corso, Docente, _), Settimana, Giorno): docente(Docente) } 4 :- settimana(Settimana), giorno(Giorno).



% • a ciascun insegnamento vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno
% • il primo giorno di lezione prevede nelle prime due ore la presentazione del master
% • prevedere almeno 2 blocchi liberi di 2 ore per recuperi di lezioni annullate 
% • “Project Management” deve concludersi non oltre la prima settimana full-time
% "• la prima lezione di “Accessibilità e usabilità nella progettazione multimediale” 
% deve essere collocata prima che siano terminate le lezioni di “Linguaggi di markup”"


#show calendario/3.