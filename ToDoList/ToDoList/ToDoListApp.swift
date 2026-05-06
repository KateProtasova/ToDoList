//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Екатерина Протасова on 05.05.2026.
//

import SwiftUI

@main
struct ToDoListApp: App {
    @State private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView(appRouter: appRouter)
        }
    }
}

struct RootView: View {
    @Bindable var appRouter: AppRouter

    @State private var presenter: TaskListPresenter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
        let interactor = TaskListInteractor()
        let router = TaskListRouter(appRouter: appRouter)
        _presenter = State(wrappedValue: TaskListPresenter(interactor: interactor, router: router))
    }

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            TaskListView(presenter: presenter)
                .navigationDestination(for: Route.self) { route in
                    detailView(for: route)
                }
        }
    }

    @ViewBuilder
    private func detailView(for route: Route) -> some View {
        switch route {
        case .createTask:
            TaskDetailContainerView(
                mode: .create,
                appRouter: appRouter,
                onSave: { presenter.loadTasks() }
            )
        case .editTask(let item):
            TaskDetailContainerView(
                mode: .edit(item),
                appRouter: appRouter,
                onSave: { presenter.loadTasks() }
            )
        }
    }
}

private struct TaskDetailContainerView: View {
    let mode: TaskDetailMode
    let appRouter: AppRouter
    let onSave: () -> Void

    @State private var presenter: TaskDetailPresenter

    init(mode: TaskDetailMode, appRouter: AppRouter, onSave: @escaping () -> Void) {
        self.mode = mode
        self.appRouter = appRouter
        self.onSave = onSave
        let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter(appRouter: appRouter)
        _presenter = State(wrappedValue: TaskDetailPresenter(
            mode: mode,
            interactor: interactor,
            router: router,
            onSave: onSave
        ))
    }

    var body: some View {
        TaskDetailView(presenter: presenter)
    }
}
