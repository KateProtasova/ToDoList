import SwiftUI

struct TaskDetailView: View {
    @Bindable var presenter: TaskDetailPresenter
    @FocusState private var focusedField: Field?

    private enum Field { case title, description }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Название задачи", text: $presenter.title, axis: .vertical)
                    .font(.detailTitle)
                    .foregroundStyle(Color.appPrimary)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .description }

                Text(presenter.formattedDate)
                    .font(.taskBody)
                    .foregroundStyle(Color.appSecondary)
                    .padding(.bottom, 4)

                TextField("Описание", text: $presenter.taskDescription, axis: .vertical)
                    .font(.body)
                    .foregroundStyle(Color.appSecondary)
                    .focused($focusedField, equals: .description)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Color.appBackground)
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presenter.dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .foregroundStyle(Color.appAccent)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Сохранить") {
                    presenter.save()
                }
                .foregroundStyle(Color.appAccent)
                .disabled(presenter.title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear {
            if presenter.isNewTask {
                focusedField = .title
            }
        }
    }
}

#Preview {
    let interactor = TaskDetailInteractor()
    let router = TaskDetailRouter(appRouter: AppRouter())
    let presenter = TaskDetailPresenter(
        mode: .edit(TodoItem(
            id: UUID(),
            title: "Заняться спортом",
            taskDescription: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку!",
            createdAt: Date(),
            isCompleted: false
        )),
        interactor: interactor,
        router: router,
        onSave: {}
    )
    NavigationStack {
        TaskDetailView(presenter: presenter)
    }
}
