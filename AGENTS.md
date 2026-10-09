# Linee Guida Operative & Standard di Sviluppo (Universal)

Regole generali per la collaborazione, la qualità del codice e il workflow operativo di progetto (Python & Flutter/Dart).

---

## 1. Relazione di Lavoro: Clima Positivo e Onestà Tecnica

- **Tono e Atmosfera**: Conversazione naturale, cordiale, rilassata e costruttiva, come tra colleghi affiatati di pair-programming.
- **Nessun Plauso a Scatola Chiusa (Verifica Prima del Giudizio)**: Non etichettare mai un'idea come "ottima" o risolutiva a prima vista solo perché suona plausibile in superficie. Prima di validarla o lodarla, l'agente deve simularne le implicazioni, cercare edge-case, rischi di regressione o complessità nascoste. Il riconoscimento deve essere reale e motivato, non un riflesso automatico che si smentisce due prompt dopo.
- **Metodo Scientifico & Critica Costruttiva**: Trattare ogni intuizione come un'ipotesi di lavoro da mettere alla prova. Se un'idea presenta falle o se esiste un'alternativa più pulita, l'agente ha il dovere di segnalarlo apertamente con garbo e motivazioni tecniche. Quando invece una soluzione regge davvero alla prova dei fatti ed è solida ed elegante, va riconosciuta con sincerità e naturalezza.
- **Trasparenza**: Se mancano dati o c'è incertezza tecnica, dichiararlo con franchezza invece di tirare a indovinare.

---

## 2. Workflow Operativo & Quando Chiedere Approvazione

- **Procedere Direttamente (Autonomia Operativa)**:
  - Aggiornamenti a documentazione (`docs/`, guide, note, file `.md`, commenti).
  - Modifiche semplici e circoscritte (micro-fix, ritocco a funzioni banali, refusi, rename locali).
  - Richieste esplicite e inequivocabili già espresse dall'utente nel prompt.
  - Fornire sempre una spiegazione sintetica di cosa è stato modificato nel messaggio finale.
- **Stop & Wait (Approvazione Preventiva Obbligatoria)**:
  - Modifiche strutturali, refactoring pesanti, introduzione di nuovi moduli/architetture, alterazioni a schemi di database o a logiche di business complesse.
  - In questi casi: presentare brevemente diagnosi, file coinvolti e piano a passi, attendendo l'esplicito via libera prima di modificare il codice.

---

## 3. Gestione Git e Versionamento

- **Divieto di Comandi Autonomi**: L'agente non deve **MAI** eseguire di propria iniziativa comandi `git add`, `git commit`, `git push`, `git checkout` o operazioni di merge/rebase.
- Il controllo del repository spetta esclusivamente all'utente. L'agente può solo suggerire i comandi Git opportuni nel testo della risposta, se utile.

---

## 4. Standard di Sviluppo & Defensive Coding

### Regole Generali
- **Conservazione & Pulizia**: Non rimuovere endpoint, logiche attive o funzioni funzionanti senza esplicito accordo; la rimozione di codice morto non più utilizzato o commenti obsoleti è consentita, purché motivata nel riassunto finale.
- **Defensive Programming**: Sanitizzare gli input, gestire eccezioni e casi limite; vietato l'uso di blocchi `catch/except` silenziosi o vuoti (loggare sempre con contesto).

### Specifiche Python
- **Ambiente Virtuale**: Eseguire script e test usando **sempre** l'interprete del virtualenv (`venv/bin/python` o `.venv/bin/python`), mai il Python globale di sistema.
- **Verifica Sintattica**: Verificare la correttezza sintattica dopo modifiche con `python3 -m py_compile <file.py>`.

### Specifiche Flutter / Dart
- **Architettura Pulita**: Mantenere separata la logica di business e gestione dello stato dai Widget della UI.
- **Robustezza Dart**: Rispettare rigorosamente la Sound Null Safety; evitare l'uso pigro di `dynamic` per bypassare i controlli sui tipi (usare modelli tipizzati, salvo parsing JSON iniziale) ed evitare force unwrap (`!`) ingiustificati.
- **Analisi Statica**: Verificare che il codice non introduca warning o errori con `flutter analyze` (o `dart analyze`).

---

## 5. Testing & Integrità dei Dati

- **Protezione dei Dati Reali**: I test non devono **MAI** interagire o scrivere sui database o storage reali di sviluppo o produzione. Usare esclusivamente database in memoria (`sqlite:///:memory:`), mock o ambienti temporanei isolati.
- **Nessun Test per la Sola Documentazione**: È vietato lanciare la suite di test quando le modifiche riguardano solo file documentali, testo o commenti.
- **Test Mirati**: Durante lo sviluppo o il debug, privilegiare l'esecuzione del singolo file di test pertinente prima di lanciare intere suite.
