# Specifiche progetto per l’esame di DataBase 

Scrivere uno schema relativo ad un sistema di gestione delle corse di cavalli, con la seguente relazioni:
FANTINO(name, eta)  
eta >=25

CAVALLO(nome, eta, scuderia)
COPPIA( pettorale, nazione, fantino, cavallo)
CE: fantino -> FANTINO
CE: cavllo -> CAVALLO
UNI:{fantino, cavallo}
1<=pettorale<=25

GARA(giorno, ippodromo, vinc_pett, vinc_naz)
CE: (vinc_pett, vinc_naz) -> COPPIA

GARA mantiene le informazioni relative alle gare (per semplicita' assumiamo ce ne possa essere al piu' una al giorno): 
la data, l'ippodromo in cui si è svolta  o si svolgerà e il vincitore (pettorale e nazionalità).

Andiamo a definire un script SQL per la generazione e a popolazione di uno schema di Ippica che implementa lo schema relazione proposto.
Tale script dovrà essere composto da 3 parti principali.


