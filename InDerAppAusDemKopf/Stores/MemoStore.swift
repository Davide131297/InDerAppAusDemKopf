import Foundation

final class MemoStore: ObservableObject {
    @Published var items: [MemoItem] = [] {
        didSet {
            saveItems()
        }
    }

    private let fileName = "memo_items.json"

    init() {
        loadItems()
    }

    func add(_ item: MemoItem) {
        items.append(item)
    }

    func update(_ item: MemoItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }

    func delete(at offsets: IndexSet, from visibleItems: [MemoItem]) {
        let idsToDelete = offsets.map { visibleItems[$0].id }
        items.removeAll { idsToDelete.contains($0.id) }
    }

    func delete(_ item: MemoItem) {
        items.removeAll { $0.id == item.id }
    }

    func updateStatus(id: UUID, status: MemoStatus) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].status = status
    }

    func toggleDone(_ item: MemoItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].status = items[index].status == .erledigt ? .offen : .erledigt
    }

    private func loadItems() {
        let url = fileURL

        guard FileManager.default.fileExists(atPath: url.path) else {
            items = []
            return
        }

        do {
            let data = try Data(contentsOf: url)
            items = try JSONDecoder.memoDecoder.decode([MemoItem].self, from: data)
        } catch {
            print("Fehler beim Laden der Einträge: \(error.localizedDescription)")
            items = []
        }
    }

    private func saveItems() {
        do {
            let data = try JSONEncoder.memoEncoder.encode(items)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Fehler beim Speichern der Einträge: \(error.localizedDescription)")
        }
    }

    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }

}

private extension JSONEncoder {
    static var memoEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

private extension JSONDecoder {
    static var memoDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
