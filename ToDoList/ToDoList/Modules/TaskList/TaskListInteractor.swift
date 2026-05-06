import Foundation

final class TaskListInteractor: TaskListInteractorProtocol {
    private let coreDataService: CoreDataServiceProtocol
    private let networkService: NetworkServiceProtocol

    init(
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.coreDataService = coreDataService
        self.networkService = networkService
    }

    func fetchTasks() -> [TodoItem] {
        coreDataService.fetchTasks()
    }

    func toggleTask(_ item: TodoItem) {
        var updated = item
        updated.isCompleted.toggle()
        coreDataService.updateTask(updated)
    }

    func deleteTask(_ item: TodoItem) {
        coreDataService.deleteTask(item)
    }

    func performFirstLaunchIfNeeded() async {
        guard !coreDataService.hasExistingTasks() else { return }
        guard let items = try? await networkService.fetchTodos() else { return }
        coreDataService.saveImportedTasks(items)
    }
}
