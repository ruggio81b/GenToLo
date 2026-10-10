# GenToLo - Generatore numeri casuali

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white)
![Version](https://img.shields.io/badge/version-1.1.0-blue)
![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

> 🌐 **Lingua / Language**: **Italiano** | [English](README.en.md)

**GenToLo** (acronimo di *«Generatore numeri per Tombola e Lotterie»*) è un simulatore e generatore casuale di combinazioni numeriche completamente configurabile, sviluppato in **Flutter & Dart** con motore di animazione e rendering grafico vettoriale 3D personalizzato su Canvas.

L'applicazione consente di personalizzare liberamente il numero di estratti contemporanei (da 1 a 10), il limite superiore dei numeri estraibili (range da 1 a $X$, con $X \le 90$) e include una modalità **Tombola** per estrazioni progressive senza reinserimento.

Il progetto rappresenta la moderna riscrittura ed espansione di un software amatoriale sviluppato in Visual Basic 6 tra il 2001 e il 2005.

---

## Caratteristiche Principali

### 1. Estrazione Configurabile e Modalità Tombola
* **Parametri personalizzabili**: Tramite l'apposita finestra delle impostazioni accessibile dal badge superiore, l'utente può scegliere:
  * **Quantità di estratti**: da 1 a 10 numeri contemporanei.
  * **Range numerico**: estrazione da 1 a un massimo configurabile (fino a 90).
* **Modalità Tombola**: Consente estrazioni progressive sequenziali senza reinserimento dei numeri già estratti. Un contatore in tempo reale monitora i numeri rimanenti nel tabellone fino al completamento della partita.
* **Salvataggio automatico**: Le preferenze di estrazione vengono memorizzate in locale sul dispositivo.

### 2. I Tre Metodi di Estrazione
* 🎲 **Casuale**: Selezione casuale diretta di $N$ numeri senza ripetizione. Al termine della simulazione di moto caotico, i numeri estratti salgono negli alloggiamenti superiori ingrandendosi, mentre i rimanenti tornano ordinati sul tabellone.
* ❌ **Esclusione**: Selezione casuale di $(Totale - N)$ numeri che vengono progressivamente scartati ed espulsi dallo schermo con animazione dedicata. I rimanenti $N$ numeri superstiti vanno a comporre la combinazione estratta.
* 🔀 **Combinazione**: Generazione di una permutazione casuale dei numeri sul tabellone, seguita dal sorteggio casuale di $N$ posizioni. I numeri posizionati nelle caselle sorteggiate vengono evidenziati ed estratti negli alloggiamenti superiori.

### 3. Funzionalità
* **Transizioni fluide**: Premendo un pulsante durante o dopo un'estrazione, le palline tornano ordinatamente sul tabellone prima di avviare il nuovo sorteggio.
* **Ordinamento dinamico**: Pulsante **Ordina (1 ➔ 90)** per alternare l'ordine naturale crescente con l'ordine originale di estrazione.
* **Condivisione rapida**: Pulsante dedicato per condividere istantaneamente i numeri estratti tramite il menu nativo di sistema.
* **Funzionamento Offline**: Nessuna richiesta di permessi di rete, zero telemetria, nessun tracciamento né pubblicità.

### 4. Grafica 3D e Ottimizzazione Rendering
* **Rendering su Canvas**: Disegno vettoriale personalizzato con illuminazione dall'alto, sfumature di luce, bordi scuri e ombre proiettate per ottenere un effetto sferico realistico.
* **Prestazioni ottimizzate**: Pre-caching dei testi e riutilizzo degli oggetti grafici per favorire animazioni fluide riducendo il rischio di microscatti.

### 5. Generazione Numeri Casuali
* **Sorgente crittografica**: Il motore di estrazione impiega il generatore crittograficamente sicuro di Dart (Random.secure()), basato sul CSPRNG del sistema operativo. L’entropia disponibile dipende dall’implementazione del kernel e dall’hardware del singolo dispositivo.
* **Equiprobabilità algoritmica**: La selezione casuale senza ripetizione impiega l'algoritmo di permutazione di Fisher-Yates, garantendo la medesima probabilità uniforme a ogni estrazione.

---

## Struttura del Progetto

```text
assets/
└── app_icon.png                    # Icona applicativa sorgente ad alta risoluzione (1024x1024)

lib/
├── controllers/
│   └── lottery_controller.dart         # Gestione dello stato e coordinamento delle animazioni
├── l10n/
│   ├── app_it.arb                      # Dizionario localizzazione Italiano
│   └── app_localizations.dart          # Classi di localizzazione
├── models/
│   ├── extraction_settings.dart        # Modello dati impostazioni (quantità, range, tombola)
│   └── lottery_ball.dart               # Modello della pallina (coordinate, stati e traiettorie)
├── painters/
│   ├── ball_3d_painter.dart            # Rendering vettoriale 3D delle sfere e alloggiamenti
│   ├── ball_render_item.dart           # Modello dati per il rendering
│   ├── lottery_scene_painter.dart      # Rendering tabellone e griglia
│   └── trajectory_calculator.dart      # Cinematica, turbolenza e traiettorie matematiche
├── screens/
│   └── lottery_screen.dart             # Schermata principale e gestione barre di sistema
├── services/
│   ├── extraction_service.dart         # Algoritmi di estrazione (Casuale, Esclusione, Combinazione)
│   └── settings_service.dart           # Persistenza locale impostazioni su SharedPreferences
├── theme/
│   └── app_theme.dart                  # Palette cromatiche centralizzate
└── widgets/
    ├── control_panel.dart              # Pannello di controllo con i pulsanti di estrazione
    ├── extraction_settings_dialog.dart # Modale per configurare quantità, range e tombola
    ├── info_dialog.dart                # Finestra informativa, guida ai metodi e note
    └── top_bar.dart                    # Barra superiore con badge impostazioni, info e condividi
```

---

## Requisiti

* **Dart SDK**: >= 3.11.5
* **Flutter SDK**: >= 3.38.0
* **Android SDK**: API 29+ (Android 10+) minSdk
* **Application ID**: `com.ruggio81b.gentolo`

> [!NOTE]
> **Compatibilità di Piattaforma**: Il codice sorgente è scritto in Flutter standard ed è architetturalmente predisposto per funzionare sia su **Android** che su **iOS**. Tuttavia, lo sviluppo e le verifiche sul campo sono stati eseguiti specificamente su ambiente **Android** (API 29+).

---

## Comandi Flutter

```bash
# Installazione delle dipendenze
flutter pub get

# Esecuzione dei test automatici
flutter test

# Verifica analisi statica del codice
flutter analyze

# Avvio dell'applicazione
flutter run
```

---

## Documentazione e Note

* [Changelog Completo](CHANGELOG.md)
* [Informativa sulla Privacy](PRIVACY_POLICY.md)
* [Licenza del Software](LICENSE)

---

## Finalità del Software

**GenToLo** è un software indipendente sviluppato esclusivamente a scopo ricreativo.

* L'applicazione opera interamente in locale e offline: non gestisce scommesse, non prevede transazioni in denaro reale e non garantisce alcuna vincita.
* Il software non ha alcun collegamento o affiliazione con enti, marchi o gestori ufficiali di lotterie e concorsi a premi.
* L'issue tracker su GitHub è riservato esclusivamente a segnalazioni di bug software e proposte di miglioramento tecnico del codice.

---

## Licenza e Crediti

- **Autore**: Fabrizio Ruggiano
- **Sviluppo**: Il codice sorgente dell'applicazione moderna è stato interamente generato tramite Google Antigravity, con l'obiettivo di testare le potenzialità del *vibe coding* nella riscrittura e rielaborazione di un'applicazione esistente sviluppata con un linguaggio di programmazione obsoleto.
- Sviluppato partendo dall'idea di un software amatoriale in Visual Basic 6 (2001–2005).
- Rilasciato come software open source sotto licenza [GNU General Public License v3.0 (GPL-3.0)](LICENSE).

### Asset Grafici e Icona
- L'icona dell'applicazione e gli asset grafici originali sono stati ideati dall'autore con il supporto di strumenti di intelligenza artificiale (Google Gemini), e sono distribuiti sotto licenza [Creative Commons Attribuzione 4.0 Internazionale (CC-BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

### Licenze di Terze Parti
- **Flutter Framework & Dart SDK**: Licenza [BSD 3-Clause](https://github.com/flutter/flutter/blob/master/LICENSE) (© The Flutter Authors / The Dart Authors).
- **share_plus**: Licenza [BSD 3-Clause](https://github.com/fluttercommunity/plus_plugins/blob/main/packages/share_plus/share_plus/LICENSE) (© The Flutter Community).
- **shared_preferences**: Licenza [BSD 3-Clause](https://github.com/fluttercommunity/plus_plugins/blob/main/packages/shared_preferences/shared_preferences/LICENSE) (© The Flutter Community).
- **Material Design Icons**: Licenza [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) (© Google LLC).
- **Cupertino Icons**: Licenze [MIT](https://github.com/flutter/packages/blob/main/packages/cupertino_icons/LICENSE) e [SIL Open Font License 1.1](https://scripts.sil.org/OFL).
