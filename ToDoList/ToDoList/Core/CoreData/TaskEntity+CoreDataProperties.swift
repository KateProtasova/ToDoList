import Foundation
import CoreData

extension TaskEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
}

extension TaskEntity: Identifiable {}

extension TaskEntity {
    var todoItem: TodoItem {
        TodoItem(
            id: id ?? UUID(),
            title: title ?? "",
            taskDescription: taskDescription ?? "",
            createdAt: createdAt ?? Date(),
            isCompleted: isCompleted
        )
    }
}
