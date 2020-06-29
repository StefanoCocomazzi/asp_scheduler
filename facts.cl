#const full_week_1 = 7.
#const full_week_2 = 16.
#const num_settimane = 24.

giorno(1..6).
settimana(1..num_settimane).

settimana_giorno(1..num_settimane,5..6).
settimana_giorno(full_week_1,1..4).
settimana_giorno(full_week_2,1..4).


durata_lezione(1..4).
giorno_ore(1..5,8).
giorno_ore(6,5).

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
corso(pmgt  ).
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


insegnamento(aupm,  gena,       14). %Accessibilità e usabilità nella progettazione multimediale
insegnamento(aeds,  valle,      10). %Acquisizione ed elaborazione del suono
insegnamento(aeis,  zanchetta,  14). %Acquisizione ed elaborazione di immagini statiche - grafica
insegnamento(aesid, ghidelli,   20). %Acquisizione ed elaborazione di sequenze di immagini digitali
insegnamento(aslcw, micalizio,  20). %Ambienti di sviluppo e linguaggi client-side per il web
insegnamento(cpcp,  gabardi,    14). %Comunicazione pubblicitaria e comunicazione pubblica
insegnamento(casm,  taddeo,     20). %Crossmedia: articolazione delle scritture multimediali
insegnamento(edfd,  vargiu,     10). %Elementi di fotografia digitale
insegnamento(fipp,  pozzato,    14). %Fondamenti di ICT e Paradigmi di Programmazione
insegnamento(g3d,   gribaudo,   20). %Grafica 3D
insegnamento(vgpd,  travostino, 10). %I vincoli giuridici del progetto: diritto dei media
insegnamento(ismm,  suppini,    14). %Introduzione al social media management
insegnamento(gsqa,  tomatis,    10). %La gestione della qualità
insegnamento(gsru,  lombardo,   10). %La gestione delle risorse umane
insegnamento(lmkp,  gena,       20). %Linguaggi di markup
insegnamento(mkdg,  muzzetto,   10). %Marketing digitale
insegnamento(prdb,  mazzei,     20). %Progettazione di basi di dati
insegnamento(psa1,  pozzato,    10). %Progettazione e sviluppo di applicazioni web su dispositivi mobile I
insegnamento(psa2,  schifanella,10). %Progettazione e sviluppo di applicazioni web su dispositivi mobile II
insegnamento(pgdi,  terranova,  10). %Progettazione grafica e design di interfacce
insegnamento(pmgt,  muzzetto,   14). %Project Management
insegnamento(rdpcd, boniolo,    10). %Risorse digitali per il progetto: collaborazione e documentazione
insegnamento(smlt,  santangelo, 10). %Semiologia e multimedialità
insegnamento(smism, giordani,   14). %Strumenti e metodi di interazione nei Social media
insegnamento(tsmd,  zanchetta,  10). %Tecniche e strumenti di Marketing digitale
insegnamento(tssw,  damiano,    20). %Tecnologie server-side per il web


ordineCorsi(
fipp,   aslcw;
aslcw,  psa1;
psa1,   psa2;
prdb,   tssw;
lmkp,   aslcw;
pmgt,   mkdg;
mkdg,   tsmd;
pmgt,   smism;
pmgt,   pgdi;
aeis,   edfd;
edfd,   aesid;
aeis,   g3d;
).

ordineAuspicabile(
   fipp, prdb;
   tsmd, ismm; 
   cpcp, gsru;
   tssw, psa1;
).