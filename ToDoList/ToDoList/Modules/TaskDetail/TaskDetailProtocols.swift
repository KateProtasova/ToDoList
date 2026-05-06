import Foundation

enum TaskDetailMode {
    case create
    case edit(TodoItem)
}

protocol TaskDetailPresenterProtocol: AnyObject {
    func save()
    func dismiss()
}

protocol TaskDetailInteractorProtocol: AnyObject {
    func createTask(title: String, description: String) -> TodoItem
    func updateTask(_ item: TodoItem)
}

protocol TaskDetailRouterProtocol: AnyObject {
    func dismiss()
}
