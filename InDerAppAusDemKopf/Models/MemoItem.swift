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

    // Custom Codable to migrate old `isDone: Bool` data to `status`
    enum CodingKeys: String, CodingKey {
        case id, title, note, category, priority, dueDate, status, isDone, createdAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        note = try c.decode(String.self, forKey: .note)
        category = try c.decode(MemoCategory.self, forKey: .category)
        priority = try c.decode(MemoPriority.self, forKey: .priority)
        dueDate = try c.decodeIfPresent(Date.self, forKey: .dueDate)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        if let s = try c.decodeIfPresent(MemoStatus.self, forKey: .status) {
            status = s
        } else {
            let done = (try? c.decode(Bool.self, forKey: .isDone)) ?? false
            status = done ? .erledigt : .offen
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(note, forKey: .note)
        try c.encode(category, forKey: .category)
        try c.encode(priority, forKey: .priority)
        try c.encodeIfPresent(dueDate, forKey: .dueDate)
        try c.encode(status, forKey: .status)
        try c.encode(createdAt, forKey: .createdAt)
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
