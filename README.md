# Just Meet


[![Codemagic build status](https://api.codemagic.io/apps/5e65fef49399a26267397a0a/5e65fef49399a26267397a09/status_badge.svg)](https://codemagic.io/apps/5e65fef49399a26267397a0a/5e65fef49399a26267397a09/latest_build)
<img src="https://img.shields.io/badge/made%20with-Flutter-blue.svg?style=for-the-badge" alt="made with flutter">

Just Meet è un progetto realizzato in Flutter e Spring Boot per l'esame "Programmazione Web App e Mobile". L'applicativo è stato realizzato da :

  > Diego Diomedi e 
  > Alessandro Berdozzi

# Branches
  - master
    - Il branch contiene la versione di release.
  - dev
    - In questo branch è presente una versione in sviluppo non ancora stabile.
  - test
    - Qui vengono effettuati i test per migliorare l'applicativo e renderlo piu' fluido.

# Panoramica
Just Meet nasce con l'idea di semplificare l'organizzazione, la partecipazione e la ricerca di eventi.
E' possibile visualizzare gli eventi disponibili e parteciparne se si è registrati alla piattaforma. 
Per quanto riguarda la pubblicazione di un evento basterà inserire gli opportuni dati richiesti, è 
possibile poi gestire le richieste degli utenti che vogliono partecipare(se l'evento è privato) e 
poterne modficare i dettagli o addirittura rimuoverlo. E' presente la funzionalità di filtrare la 
ricerca degli eventi in base alla categoria o alla distanza calcolata in base alla posizione in cui
ci troviamo. La ricerca di un evento può avvenire tramite ricerca del nome oppure ricercando 
l'organizzatore.

#### Altre funzionalità :
  - Aggiornamento profilo utente nella piattaforma
  - Segnalazione evento/utente
  - Visualizzare un altro utente registrato nella piattaforma

# Tecnologie usate

| Tecnologie  | Utilizzo |
| ------------- | ------------- |
| Flutter  | Framework utilizzato per lo sviluppo front-end  |
| Dart  | Linguaggio di programmazione open-source utilizzato da Flutter  |
| Spring Boot  | Framework per lo sviluppo lato back-end  |
| Java  | Linguaggio di programmazione utilizzato da Spring Boot  |
| Firebase  | Piattaforma back-end per i database e per il cloud |
| Google  | Provider per l'autenticazione |

### In particolare : 

Per il lato front-end è stato utilizzato Flutter in quanto capace di sviluppare degli applicativi cross 
platform (sia Android che IOS) molto ottimizzati. La logica front-end si occupa di definire un'esperienza
utente semplice e veloce per sfruttare tutte le funzionalità definite nel back-end. Sono presenti diverse
schermate in cui l'utente può registrarsi, autenticarsi, visualizzare eventi, ricercare eventi e commentare.
L'applicazione mobile di base effettua delle chiamate http al back-end e mostra i risultati ottenuti modellandoli
in base ai widget offerti da Flutter. L'autenticazione tramite providers di terze parti come Google è gestita
lato front-end. 
Per quanto riguarda il back-end Spring Boot definisce i servizi REST API offerti dalla piattaforma. Si appoggia a Firebase per il salvataggio dei dati nei database e per le query da effettuare. La sicurezza viene in primo luogo
gestita attraverso un controllo nell'header di ogni richiesta(deve essere presente un token che verrà poi comparato
a quelli salvati da Firebase), e poi filtrando le richieste piu' invasive con l'utilizzo delle "Authority".
Per semplificare la gestione degli stati si è optato per l'utilizzo di Redux, un framework architetturale in grado
di gestire gli stati dell'applicativo con una visione ad "albero" molto piu' organizzata e pulita rendendo il codice
piu' semplice da leggere e da modificare.




