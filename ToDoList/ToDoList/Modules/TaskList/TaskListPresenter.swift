import Foundation
import Observation

@Observable
final class TaskListPresenter: TaskListPresenterProtocol {
    var tasks: [TodoItem] = []
    var searchText: String = ""
    var isLoading = false

    var filteredTasks: [TodoItem] {
        guard !searchText.isEmpty else { return tasks }
        return tasks.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.taskDescription.localizedCaseInsensitiveContains(searchText)
        }
    }

    private let interactor: TaskListInteractorProtocol
    private let router: TaskListRouterProtocol

    init(interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func loadTasks() {
        tasks = interactor.fetchTasks()
    }

    func toggleTask(_ item: TodoItem) {
        interactor.toggleTask(item)
        loadTasks()
    }

    func deleteTask(_ item: TodoItem) {
        interactor.deleteTask(item)
        loadTasks()
    }

    func editTask(_ item: TodoItem) {
        router.showEditTask(item)
    }

    func createTask() {
        router.showCreateTask()
    }

    func performFirstLaunchIfNeeded() async {
        isLoading = true
        await interactor.performFirstLaunchIfNeeded()
        loadTasks()
        isLoading = false
    }
}
