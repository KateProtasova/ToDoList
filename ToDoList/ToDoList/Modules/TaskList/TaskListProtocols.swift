import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    func loadTasks()
    func toggleTask(_ item: TodoItem)
    func deleteTask(_ item: TodoItem)
    func editTask(_ item: TodoItem)
    func createTask()
    func performFirstLaunchIfNeeded() async
}

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks() -> [TodoItem]
    func toggleTask(_ item: TodoItem)
    func deleteTask(_ item: TodoItem)
    func performFirstLaunchIfNeeded() async
}

protocol TaskListRouterProtocol: AnyObject {
    func showCreateTask()
    func showEditTask(_ item: TodoItem)
}
