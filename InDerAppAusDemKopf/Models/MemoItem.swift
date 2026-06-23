import Foundation

struct MemoItem: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var note: String
    var category: MemoCategory
    var priority: MemoPriority
    var dueDate: Date?
    var isDone: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        note: String,
        category: MemoCategory = .personal,
        priority: MemoPriority = .medium,
        dueDate: Date? = nil,
        isDone: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

enum MemoCategory: String, CaseIterable, Codable, Identifiable {
    case personal = "Privat"
    case study = "Studium"
    case work = "Arbeit"
    case shopping = "Einkauf"
    case idea = "Idee"

    var id: String { rawValue }
}

enum MemoPriority: String, CaseIterable, Codable, Identifiable, Comparable {
    case low = "Niedrig"
    case medium = "Mittel"
    case high = "Hoch"

    var id: String { rawValue }

    var sortValue: Int {
        switch self {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        }
    }

    static func < (lhs: MemoPriority, rhs: MemoPriority) -> Bool {
        lhs.sortValue < rhs.sortValue
    }
}
