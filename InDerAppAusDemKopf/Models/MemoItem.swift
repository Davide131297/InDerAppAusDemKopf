import Foundation

struct MemoItem: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var note: String
    var category: MemoCategory
    var priority: MemoPriority
    var dueDate: Date?
    var status: MemoStatus
    var createdAt: Date

    var isDone: Bool { status == .erledigt }

    init(
        id: UUID = UUID(),
        title: String,
        note: String,
        category: MemoCategory = .personal,
        priority: MemoPriority = .medium,
        dueDate: Date? = nil,
        status: MemoStatus = .offen,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        self.status = status
        self.createdAt = createdAt
    }

}

enum MemoStatus: String, CaseIterable, Codable, Identifiable {
    case offen = "Offen"
    case inArbeit = "In Arbeit"
    case erledigt = "Erledigt"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .offen: return "circle"
        case .inArbeit: return "clock.circle.fill"
        case .erledigt: return "checkmark.circle.fill"
        }
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
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }

    static func < (lhs: MemoPriority, rhs: MemoPriority) -> Bool {
        lhs.sortValue < rhs.sortValue
    }
}
