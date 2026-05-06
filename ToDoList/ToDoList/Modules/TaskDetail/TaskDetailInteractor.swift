import Foundation

final class TaskDetailInteractor: TaskDetailInteractorProtocol {
    private let coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }

    func createTask(title: String, description: String) -> TodoItem {
        coreDataService.createTask(title: title, description: description)
    }

    func updateTask(_ item: TodoItem) {
        coreDataService.updateTask(item)
    }
}
