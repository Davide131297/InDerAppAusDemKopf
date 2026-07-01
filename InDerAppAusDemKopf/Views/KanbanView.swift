import SwiftUI

struct KanbanView: View {
    @EnvironmentObject private var store: MemoStore
    let items: [MemoItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(MemoStatus.allCases) { status in
                    KanbanColumnView(
                        status: status,
                        items: items.filter { $0.status == status }
                    )
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct KanbanColumnView: View {
    @EnvironmentObject private var store: MemoStore
    let status: MemoStatus
    let items: [MemoItem]

    @State private var isDropTarget = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            columnHeader
            cardList
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(width: 220)
        .frame(minHeight: 480, alignment: .top)
        .background(columnBackground)
        .overlay(dropBorder)
        .dropDestination(for: String.self) { droppedItems, _ in
            guard let idString = droppedItems.first,
                  let id = UUID(uuidString: idString) else { return false }
            withAnimation(.spring(duration: 0.3)) {
                store.updateStatus(id: id, status: status)
            }
            return true
        } isTargeted: { targeted in
            withAnimation(.easeInOut(duration: 0.15)) {
                isDropTarget = targeted
            }
        }
    }

    private var columnHeader: some View {
        HStack(spacing: 6) {
            Image(systemName: status.icon)
                .foregroundStyle(statusColor)
                .font(.subheadline.bold())
            Text(status.rawValue)
                .font(.headline)
            Spacer()
            Text("\(items.count)")
                .font(.caption.bold())
                .foregroundStyle(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(statusColor.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding(.bottom, 4)
    }

    @ViewBuilder
    private var cardList: some View {
        if items.isEmpty {
            Text("Ablegen zum Verschieben")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
        } else {
            ForEach(items) { item in
                NavigationLink {
                    MemoDetailView(item: item)
                } label: {
                    KanbanCardView(item: item)
                }
                .buttonStyle(.plain)
                .draggable(item.id.uuidString) {
                    KanbanCardView(item: item)
                        .frame(width: 200)
                        .opacity(0.9)
                        .scaleEffect(1.05)
                }
            }
        }
    }

    private var columnBackground: some View {
        LinearGradient(
            colors: [
                isDropTarget ? statusColor.opacity(0.18) : statusColor.opacity(0.08),
                Color(.systemGray6)
            ],
            startPoint: .top,
            endPoint: .init(x: 0.5, y: 0.4)
        )
    }

    private var dropBorder: some View {
        RoundedRectangle(cornerRadius: 0)
            .stroke(
                isDropTarget ? statusColor.opacity(0.5) : Color(.separator).opacity(0.4),
                lineWidth: isDropTarget ? 2 : 0.5
            )
    }

    private var statusColor: Color {
        switch status {
        case .offen: return .secondary
        case .inArbeit: return .blue
        case .erledigt: return .green
        }
    }
}

private struct KanbanCardView: View {
    let item: MemoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Label(item.category.rawValue, systemImage: "folder")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                PriorityBadge(priority: item.priority)
            }

            Text(item.title)
                .font(.subheadline.bold())
                .strikethrough(item.isDone)
                .foregroundStyle(item.isDone ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let dueDate = item.dueDate {
                Label(
                    dueDate.formatted(date: .abbreviated, time: .omitted),
                    systemImage: "calendar"
                )
                .font(.caption)
                .foregroundStyle(dueDate < Date() && !item.isDone ? .red : .secondary)
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.07), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        KanbanView(items: [
            MemoItem(title: "Beispielaufgabe", note: "", category: .study, priority: .high, status: .offen),
            MemoItem(title: "Einkaufen", note: "", category: .shopping, priority: .medium, status: .inArbeit),
            MemoItem(title: "Idee notieren", note: "", category: .idea, priority: .low, status: .erledigt)
        ])
        .environmentObject(MemoStore())
    }
}
