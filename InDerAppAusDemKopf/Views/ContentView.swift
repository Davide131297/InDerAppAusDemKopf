import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: MemoStore
    @State private var showingAddView = false
    @State private var searchText = ""
    @State private var sortMode: SortMode = .priority

    private var visibleItems: [MemoItem] {
        let filteredItems = store.items.filter { item in
            searchText.isEmpty
            || item.title.localizedCaseInsensitiveContains(searchText)
            || item.note.localizedCaseInsensitiveContains(searchText)
            || item.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }

        switch sortMode {
        case .priority:
            return filteredItems.sorted {
                if $0.priority == $1.priority {
                    return $0.createdAt > $1.createdAt
                }
                return $0.priority > $1.priority
            }
        case .date:
            return filteredItems.sorted {
                ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
            }
        case .created:
            return filteredItems.sorted { $0.createdAt > $1.createdAt }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if visibleItems.isEmpty {
                    ContentUnavailableView(
                        "Keine Einträge",
                        systemImage: "tray",
                        description: Text("Lege einen neuen Gedanken oder eine Aufgabe an.")
                    )
                } else {
                    ForEach(visibleItems) { item in
                        NavigationLink {
                            MemoDetailView(item: item)
                        } label: {
                            MemoRowView(item: item)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                store.toggleDone(item)
                            } label: {
                                Label(item.isDone ? "Offen" : "Erledigt", systemImage: item.isDone ? "circle" : "checkmark.circle")
                            }
                            .tint(.green)
                        }
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets, from: visibleItems)
                    }
                }
            }
            .navigationTitle("Aus dem Kopf")
            .searchable(text: $searchText, prompt: "Einträge suchen")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sortierung", selection: $sortMode) {
                            ForEach(SortMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                    } label: {
                        Label("Sortieren", systemImage: "arrow.up.arrow.down")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddView = true
                    } label: {
                        Label("Neu", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddMemoView()
            }
        }
    }
}

private enum SortMode: String, CaseIterable, Identifiable {
    case priority = "Priorität"
    case date = "Fälligkeitsdatum"
    case created = "Neueste zuerst"

    var id: String { rawValue }
}

#Preview {
    ContentView()
        .environmentObject(MemoStore())
}
