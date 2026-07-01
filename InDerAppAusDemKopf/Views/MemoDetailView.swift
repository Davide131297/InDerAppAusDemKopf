import SwiftUI

struct MemoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: MemoStore

    let item: MemoItem

    @State private var title: String
    @State private var note: String
    @State private var category: MemoCategory
    @State private var priority: MemoPriority
    @State private var status: MemoStatus
    @State private var hasDueDate: Bool
    @State private var dueDate: Date

    init(item: MemoItem) {
        self.item = item
        _title = State(initialValue: item.title)
        _note = State(initialValue: item.note)
        _category = State(initialValue: item.category)
        _priority = State(initialValue: item.priority)
        _status = State(initialValue: item.status)
        _hasDueDate = State(initialValue: item.dueDate != nil)
        _dueDate = State(initialValue: item.dueDate ?? Date())
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section("Eintrag") {
                TextField("Titel", text: $title)
                TextEditor(text: $note)
                    .frame(minHeight: 140)
            }

            Section("Status") {
                Picker("Status", selection: $status) {
                    ForEach(MemoStatus.allCases) { s in
                        Label(s.rawValue, systemImage: s.icon).tag(s)
                    }
                }

                Picker("Kategorie", selection: $category) {
                    ForEach(MemoCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }

                Picker("Priorität", selection: $priority) {
                    ForEach(MemoPriority.allCases) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
            }

            Section("Fälligkeit") {
                Toggle("Fälligkeitsdatum verwenden", isOn: $hasDueDate)

                if hasDueDate {
                    DatePicker("Fällig am", selection: $dueDate, displayedComponents: .date)
                }
            }

            Section("Information") {
                LabeledContent("Erstellt", value: item.createdAt.formatted(date: .abbreviated, time: .shortened))
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Speichern") {
                    saveChanges()
                }
                .disabled(!canSave)
            }
        }
    }

    private func saveChanges() {
        let updatedItem = MemoItem(
            id: item.id,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil,
            status: status,
            createdAt: item.createdAt
        )

        store.update(updatedItem)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        MemoDetailView(
            item: MemoItem(
                title: "Projektbericht schreiben",
                note: "Umsetzung der App dokumentieren.",
                category: .study,
                priority: .high,
                dueDate: Date()
            )
        )
    }
    .environmentObject(MemoStore())
}
