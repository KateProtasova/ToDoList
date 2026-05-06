import SwiftUI

struct TaskListView: View {
    @Bindable var presenter: TaskListPresenter

    var body: some View {
        List {
            ForEach(presenter.filteredTasks) { task in
                TaskRowView(task: task) {
                    presenter.toggleTask(task)
                }
                .contextMenu {
                    Button {
                        presenter.editTask(task)
                    } label: {
                        Label("Редактировать", systemImage: "pencil")
                    }

                    ShareLink(item: task.shareText) {
                        Label("Поделиться", systemImage: "square.and.arrow.up")
                    }

                    Divider()

                    Button(role: .destructive) {
                        presenter.deleteTask(task)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Задачи")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $presenter.searchText, prompt: "Search")
        .overlay {
            if presenter.isLoading {
                ProgressView()
                    .tint(Color.appAccent)
            }
        }
        .safeAreaInset(edge: .bottom) {
            taskFooter
        }
        .onAppear {
            presenter.loadTasks()
        }
        .task {
            await presenter.performFirstLaunchIfNeeded()
        }
    }

    private var taskFooter: some View {
        HStack {
            Text("\(presenter.filteredTasks.count) Задач")
                .font(.taskDate)
                .foregroundStyle(.secondary)
            Spacer()
            Button {
                presenter.createTask()
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .foregroundStyle(Color.appAccent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.bar)
    }
}

// MARK: - Task Row

private struct TaskRowView: View {
    let task: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? Color.appAccent : Color(.tertiaryLabel))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.taskTitle)
                    .strikethrough(task.isCompleted, color: .secondary)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.taskBody)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Text(task.createdAt.formatted(date: .numeric, time: .omitted))
                    .font(.taskDate)
                    .foregroundStyle(Color(.tertiaryLabel))
            }

            Spacer()
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    let interactor = TaskListInteractor()
    let router = TaskListRouter(appRouter: AppRouter())
    let presenter = TaskListPresenter(interactor: interactor, router: router)
    NavigationStack {
        TaskListView(presenter: presenter)
    }
}
