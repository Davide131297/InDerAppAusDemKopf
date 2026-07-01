import SwiftUI

struct MemoRowView: View {
    let item: MemoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: item.status.icon)
                    .foregroundStyle(statusColor(item.status))

                Text(item.title)
                    .font(.headline)
                    .strikethrough(item.isDone)
                    .foregroundStyle(item.isDone ? .secondary : .primary)

                Spacer()

                PriorityBadge(priority: item.priority)
            }

            if !item.note.isEmpty {
                Text(item.note)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 12) {
                Label(item.category.rawValue, systemImage: "folder")

                if let dueDate = item.dueDate {
                    Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        .foregroundStyle(dueDate < Date() && !item.isDone ? .red : .secondary)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func statusColor(_ status: MemoStatus) -> Color {
        switch status {
        case .offen: return .secondary
        case .inArbeit: return .blue
        case .erledigt: return .green
        }
    }
}

struct PriorityBadge: View {
    let priority: MemoPriority

    var body: some View {
        Text(priority.rawValue)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundStyle)
            .clipShape(Capsule())
    }

    private var backgroundStyle: Color {
        switch priority {
        case .low:
            return .gray.opacity(0.2)
        case .medium:
            return .orange.opacity(0.2)
        case .high:
            return .red.opacity(0.2)
        }
    }
}

#Preview {
    List {
        MemoRowView(
            item: MemoItem(
                title: "Beispielaufgabe",
                note: "Eine kurze Notiz für die Vorschau.",
                category: .study,
                priority: .high,
                dueDate: Date()
            )
        )
    }
}
