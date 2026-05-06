import Foundation

final class TaskDetailRouter: TaskDetailRouterProtocol {
    private let appRouter: AppRouter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func dismiss() {
        appRouter.pop()
    }
}
