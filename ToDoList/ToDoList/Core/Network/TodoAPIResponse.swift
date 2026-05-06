import Foundation

struct TodoAPIResponse: Decodable {
    let todos: [TodoAPIItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoAPIItem: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
