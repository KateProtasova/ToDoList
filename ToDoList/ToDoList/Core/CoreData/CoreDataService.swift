import Foundation
import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    func fetchTasks() -> [TodoItem]
    func createTask(title: String, description: String) -> TodoItem
    func updateTask(_ item: TodoItem)
    func deleteTask(_ item: TodoItem)
    func saveImportedTasks(_ items: [TodoAPIItem])
    func hasExistingTasks() -> Bool
}

final class CoreDataService: CoreDataServiceProtocol {
    static let shared = CoreDataService()

    private let container: NSPersistentContainer

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData load failed: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func fetchTasks() -> [TodoItem] {
        let request = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: false)]
        return (try? context.fetch(request))?.map(\.todoItem) ?? []
    }

    func createTask(title: String, description: String) -> TodoItem {
        let entity = TaskEntity(context: context)
        entity.id = UUID()
        entity.title = title
        entity.taskDescription = description
        entity.createdAt = Date()
        entity.isCompleted = false
        save()
        return entity.todoItem
    }

    func updateTask(_ item: TodoItem) {
        guard let entity = findEntity(by: item.id) else { return }
        entity.title = item.title
        entity.taskDescription = item.taskDescription
        entity.isCompleted = item.isCompleted
        save()
    }

    func deleteTask(_ item: TodoItem) {
        guard let entity = findEntity(by: item.id) else { return }
        context.delete(entity)
        save()
    }

    func saveImportedTasks(_ items: [TodoAPIItem]) {
        let now = Date()
        for apiItem in items {
            let entity = TaskEntity(context: context)
            entity.id = UUID()
            entity.title = apiItem.todo
            entity.taskDescription = ""
            entity.createdAt = now
            entity.isCompleted = apiItem.completed
        }
        save()
    }

    func hasExistingTasks() -> Bool {
        let request = TaskEntity.fetchRequest()
        request.fetchLimit = 1
        return (try? context.count(for: request)) ?? 0 > 0
    }

    private func findEntity(by id: UUID) -> TaskEntity? {
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
