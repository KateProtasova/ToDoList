import Foundation
import Observation

@Observable
final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    var title: String
    var taskDescription: String
    let formattedDate: String
    let isNewTask: Bool

    private let mode: TaskDetailMode
    private let interactor: TaskDetailInteractorProtocol
    private let router: TaskDetailRouterProtocol
    private let onSave: () -> Void

    init(
        mode: TaskDetailMode,
        interactor: TaskDetailInteractorProtocol,
        router: TaskDetailRouterProtocol,
        onSave: @escaping () -> Void
    ) {
        self.mode = mode
        self.interactor = interactor
        self.router = router
        self.onSave = onSave

        switch mode {
        case .create:
            title = ""
            taskDescription = ""
            formattedDate = Date().formatted(date: .numeric, time: .omitted)
            isNewTask = true
        case .edit(let item):
            title = item.title
            taskDescription = item.taskDescription
            formattedDate = item.createdAt.formatted(date: .numeric, time: .omitted)
            isNewTask = false
        }
    }

    func save() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        switch mode {
        case .create:
            _ = interactor.createTask(title: trimmed, description: taskDescription)
        case .edit(let item):
            var updated = item
            updated.title = trimmed
            updated.taskDescription = taskDescription
            interactor.updateTask(updated)
        }
        onSave()
        router.dismiss()
    }

    func dismiss() {
        router.dismiss()
    }
}
