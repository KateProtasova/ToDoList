import Foundation

struct TodoItem: Identifiable, Hashable, Sendable {
    let id: UUID
    var title: String
    var taskDescription: String
    let createdAt: Date
    var isCompleted: Bool
}

extension TodoItem {
    var shareText: String {
        var text = title
        if !taskDescription.isEmpty {
            text += "\n\n" + taskDescription
        }
        text += "\n\n" + createdAt.formatted(date: .numeric, time: .omitted)
        text += "\n" + (isCompleted ? "✓ Выполнено" : "○ Не выполнено")
        return text
    }
}
