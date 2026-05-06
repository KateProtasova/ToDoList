import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func fetchTodos() async throws -> [TodoAPIItem]
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    private init() {}

    func fetchTodos() async throws -> [TodoAPIItem] {
        var components = URLComponents(string: "https://dummyjson.com/todos")!
        components.queryItems = [URLQueryItem(name: "limit", value: "254")]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let response = try JSONDecoder().decode(TodoAPIResponse.self, from: data)
        return response.todos
    }
}
