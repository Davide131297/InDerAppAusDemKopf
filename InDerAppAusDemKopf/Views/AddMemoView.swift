import SwiftUI

struct AddMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: MemoStore

    @State private var title = ""
    @State private var note = ""
    @State private var category: MemoCategory = .personal
    @State private var priority: MemoPriority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Eintrag") {
                    TextField("Titel", text: $title)
                    TextEditor(text: $note)
                        .frame(minHeight: 120)
                }

                Section("Organisation") {
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

                    Toggle("Fälligkeitsdatum", isOn: $hasDueDate)

                    if hasDueDate {
                        DatePicker("Fällig am", selection: $dueDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Neuer Eintrag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveItem()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func saveItem() {
        let item = MemoItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )

        store.add(item)
        dismiss()
    }
}

#Preview {
    AddMemoView()
        .environmentObject(MemoStore())
}
