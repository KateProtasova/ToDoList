import SwiftUI

struct TaskListView: View {
    @Bindable var presenter: TaskListPresenter

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Text("Задачи")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.appPrimary)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 8)

                Section {
                    taskContent
                } header: {
                    TaskSearchBar(text: $presenter.searchText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.appBackground)
                }
            }
        }
        .background(Color.appBackground)
        .toolbarBackground(Color.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .overlay {
            if presenter.isLoading {
                ProgressView().tint(Color.appAccent)
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

    @ViewBuilder
    private var taskContent: some View {
        if presenter.filteredTasks.isEmpty && !presenter.isLoading {
            Text("Задачи не найдены")
                .foregroundStyle(Color.appSecondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
        } else {
            ForEach(presenter.filteredTasks) { task in
                VStack(spacing: 0) {
                    TaskRowView(task: task) {
                        presenter.toggleTask(task)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        presenter.editTask(task)
                    }
                    .contextMenu {
                        Button {
                            presenter.editTask(task)
                        } label: {
                            HStack {
                                Text("Редактировать")
                                Spacer()
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        ShareLink(item: task.shareText) {
                            HStack {
                                Text("Поделиться")
                                Spacer()
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        Divider()
                        Button(role: .destructive) {
                            presenter.deleteTask(task)
                        } label: {
                            HStack {
                                Text("Удалить")
                                Spacer()
                                Image(systemName: "trash")
                            }
                        }
                    } preview: {
                        TaskContextPreview(task: task)
                    }

                    Color.appSeparator
                        .frame(height: 0.5)
                        .padding(.leading, 52)
                }
            }
        }
    }

    private var taskFooter: some View {
        ZStack {
            Text("\(presenter.filteredTasks.count) Задач")
                .font(.taskDate)
                .foregroundStyle(Color.appSecondary)
                .frame(maxWidth: .infinity)

            HStack {
                Spacer()
                Button {
                    presenter.createTask()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundStyle(Color.appAccent)
                }
            }
            .padding(.trailing, 20)
        }
        .padding(.vertical, 12)
        .background(Color.appSurface)
        .overlay(alignment: .top) {
            Color.appSeparator.frame(height: 0.5)
        }
    }
}

// MARK: - Search Bar

private struct TaskSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.appSecondary)
                .font(.system(size: 15, weight: .medium))

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Search")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.appTertiary)
                }
                TextField("", text: $text)
                    .foregroundStyle(Color.appPrimary)
                    .tint(Color.appAccent)
                    .font(.system(size: 17))
            }

            Spacer(minLength: 0)

            if text.isEmpty {
                Image(systemName: "mic.fill")
                    .foregroundStyle(Color.appSecondary)
                    .font(.system(size: 15, weight: .medium))
            } else {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.appSecondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Task Row

private struct TaskRowView: View {
    let task: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TaskCheckbox(isCompleted: task.isCompleted, onToggle: onToggle)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.taskTitle)
                    .strikethrough(task.isCompleted, color: Color.appSecondary)
                    .foregroundStyle(task.isCompleted ? Color.appSecondary : Color.appPrimary)

                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.taskBody)
                        .foregroundStyle(task.isCompleted ? Color.appTertiary : Color.appPrimary)
                        .lineLimit(2)
                }

                Text(task.formattedDate)
                    .font(.taskDate)
                    .foregroundStyle(Color.appTertiary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Context Menu Preview

private struct TaskContextPreview: View {
    let task: TodoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(task.title)
                .font(.headline)
                .foregroundStyle(Color.appPrimary)

            if !task.taskDescription.isEmpty {
                Text(task.taskDescription)
                    .font(.subheadline)
                    .foregroundStyle(Color.appSecondary)
                    .lineLimit(3)
            }

            Text(task.formattedDate)
                .font(.caption)
                .foregroundStyle(Color.appTertiary)
        }
        .padding(16)
        .frame(minWidth: 250, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Checkbox

private struct TaskCheckbox: View {
    let isCompleted: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            ZStack {
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 24, height: 24)
                Circle()
                    .stroke(isCompleted ? Color.appAccent : Color.appSecondary, lineWidth: 1.5)
                    .frame(width: 24, height: 24)
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                }
            }
        }
        .buttonStyle(.plain)
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
