# InDerAppAusDemKopf

SwiftUI-Projekt für Aufgabe 1.2: Eine Merklisten-App, in der persönliche Einträge gespeichert, angezeigt, bearbeitet und gelöscht werden können.

## Funktionen

- Anzeige aller gespeicherten Merklisteinträge beim App-Start
- Neue Einträge hinzufügen
- Vorhandene Einträge löschen
- Detailansicht für jeden Eintrag
- Einträge bearbeiten und speichern
- Dauerhafte lokale Speicherung per JSON-Datei
- Kreatives Zusatzfeature: Priorität, Kategorie, Erledigt-Status und optionales Fälligkeitsdatum

## Dateien

- `InDerAppAusDemKopfApp.swift`: Einstiegspunkt der App
- `ContentView.swift`: Hauptansicht mit Liste, Suche, Sortierung und Navigation
- `MemoItem.swift`: Datenmodell für einen Merklisteintrag
- `MemoStore.swift`: Verwaltung und lokale Speicherung der Einträge
- `AddMemoView.swift`: Formular zum Erstellen neuer Einträge
- `MemoDetailView.swift`: Detailansicht zum Bearbeiten bestehender Einträge

## Hinweis zur Verwendung in Xcode

1. Neues iOS-Projekt in Xcode erstellen.
2. SwiftUI als Interface auswählen.
3. Die Swift-Dateien aus diesem Repository in das Projekt kopieren.
4. App starten und testen.

## Projektidee

Die App unterstützt Nutzerinnen und Nutzer dabei, Gedanken, Lernaufgaben oder Alltagserinnerungen schnell aus dem Kopf in eine strukturierte Liste zu übertragen. Durch Prioritäten, Kategorien und Fälligkeitsdaten werden die Einträge übersichtlich organisierbar.