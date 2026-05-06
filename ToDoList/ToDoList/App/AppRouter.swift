import SwiftUI

enum Route: Hashable {
    case createTask
    case editTask(TodoItem)
}

@Observable
final class AppRouter {
    var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
