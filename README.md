# InDerAppAusDemKopf

Vollständiges SwiftUI-Xcode-Projekt für Aufgabe 1.2: Eine Merklisten-App, in der persönliche Einträge gespeichert, angezeigt, bearbeitet und gelöscht werden können.

## Funktionen

- Anzeige aller gespeicherten Merklisteinträge beim App-Start
- Neue Einträge hinzufügen
- Vorhandene Einträge löschen
- Detailansicht für jeden Eintrag
- Einträge bearbeiten und speichern
- Dauerhafte lokale Speicherung per JSON-Datei
- Suche und Sortierung
- Kreatives Zusatzfeature: Priorität, Kategorie, Erledigt-Status und optionales Fälligkeitsdatum

## Projekt öffnen

1. Repository klonen oder als ZIP herunterladen.
2. Datei `InDerAppAusDemKopf.xcodeproj` in Xcode öffnen.
3. Als Zielgerät einen iPhone-Simulator auswählen.
4. App starten.

## Wichtige Dateien

- `InDerAppAusDemKopf.xcodeproj`: Xcode-Projekt
- `InDerAppAusDemKopf/InDerAppAusDemKopfApp.swift`: Einstiegspunkt der App
- `InDerAppAusDemKopf/Models/MemoItem.swift`: Datenmodell für einen Merklisteintrag
- `InDerAppAusDemKopf/Stores/MemoStore.swift`: Verwaltung und lokale Speicherung der Einträge
- `InDerAppAusDemKopf/Views/ContentView.swift`: Hauptansicht mit Liste, Suche, Sortierung und Navigation
- `InDerAppAusDemKopf/Views/AddMemoView.swift`: Formular zum Erstellen neuer Einträge
- `InDerAppAusDemKopf/Views/MemoDetailView.swift`: Detailansicht zum Bearbeiten bestehender Einträge
- `InDerAppAusDemKopf/Views/MemoRowView.swift`: Darstellung eines Eintrags in der Liste

## Projektidee

Die App unterstützt Nutzerinnen und Nutzer dabei, Gedanken, Lernaufgaben oder Alltagserinnerungen schnell aus dem Kopf in eine strukturierte Liste zu übertragen. Durch Prioritäten, Kategorien und Fälligkeitsdaten werden die Einträge übersichtlich organisierbar.

## Bezug zur Aufgabenstellung

Die App erfüllt die Kernanforderungen einer Merklisten-App: gespeicherte Einträge werden beim Start geladen, neue Einträge können erstellt, bestehende Einträge können gelöscht und in einer Detailansicht bearbeitet werden. Die Speicherung erfolgt lokal über eine JSON-Datei. Das kreative Zusatzfeature besteht aus Priorität, Kategorie, Erledigt-Status, Suche, Sortierung und Fälligkeitsdatum.