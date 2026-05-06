import Foundation

final class TaskListRouter: TaskListRouterProtocol {
    private let appRouter: AppRouter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func showCreateTask() {
        appRouter.push(.createTask)
    }

    func showEditTask(_ item: TodoItem) {
        appRouter.push(.editTask(item))
    }
}
